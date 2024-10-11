local PromptGroup1 <const> = GetRandomIntInRange(0, 0xffffff)
local OpenDoors = 0
local Core = exports.vorp_core:GetCore()

local function loadModel(model)
    if not HasModelLoaded(model) then
        RequestModel(model, false)
        repeat Wait(0) until HasModelLoaded(model)
    end
end

local function PlayKeyAnim(ped, duration)
    CreateThread(function()
        local player <const> = ped
        ClearPedTasks(player)
        ClearPedSecondaryTask(player)
        TaskStandStill(player, 3000)
        Wait(100)
        local plc <const> = GetEntityCoords(player)
        loadModel('p_key02x')
        RequestAnimDict("script_common@jail_cell@unlock@key")
        repeat Wait(0) until HasAnimDictLoaded("script_common@jail_cell@unlock@key")
        local prop <const> = CreateObject(joaat('p_key02x'), plc.x, plc.y, plc.z + 0.2, true, false, false, false, false)
        repeat Wait(0) until DoesEntityExist(prop)
        SetEntityVisible(prop, false)
        FreezeEntityPosition(prop, true)
        local boneIndex <const> = GetEntityBoneIndexByName(player, "SKEL_R_Finger12")
        TaskPlayAnim(player, 'script_common@jail_cell@unlock@key', 'action', 8.0, 8.0, duration, 1, 0, false, false, false)
        Wait(750)
        FreezeEntityPosition(prop, false)
        SetEntityVisible(prop, true)
        AttachEntityToEntity(prop, player, boneIndex, 0.02, 0.0120, -0.00850, 0.024, -160.0, 200.0, true, true, false, true, 1, true, false, false)
        repeat Wait(50) until not IsEntityPlayingAnim(player, "script_common@jail_cell@unlock@key", "action", 3)
        DeleteObject(prop)
        SetModelAsNoLongerNeeded('p_key02x')
        RemoveAnimDict('script_common@jail_cell@unlock@key')
    end)
end

local function GetPlayerDistanceFromCoords(x, y, z)
    local player <const> = PlayerPedId()
    local playerCoords <const> = GetEntityCoords(player)
    return #(playerCoords - vector3(x, y, z))
end

local function registerPrompt()
    OpenDoors = UiPromptRegisterBegin()
    UiPromptSetControlAction(OpenDoors, `INPUT_INTERACT_LOCKON_ANIMAL`) -- G by default
    local str = VarString(10, 'LITERAL_STRING', Config.lang.PromptText)
    UiPromptSetText(OpenDoors, str)
    UiPromptSetEnabled(OpenDoors, true)
    UiPromptSetVisible(OpenDoors, true)
    UiPromptSetStandardMode(OpenDoors, true)
    UiPromptSetGroup(OpenDoors, PromptGroup1, 0)
    UiPromptRegisterEnd(OpenDoors)
end

local function addDoorsToSystem()
    for door, value in pairs(Config.Doors) do
        if not IsDoorRegisteredWithSystem(door) then
            AddDoorToSystemNew(door, true, true, false, 0, 0, false)
        end
        DoorSystemSetDoorState(door, value.DoorState)
        SetDoorNetworked(door)
    end
end
local function loadAnim(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        repeat Wait(0) until HasAnimDictLoaded(dict)
    end
end

local function startLockPickAnim()
    local player <const> = PlayerPedId()
    loadAnim('script_proc@rustling@unapproved@gate_lockpick')
    TaskPlayAnim(player, 'script_proc@rustling@unapproved@gate_lockpick', 'enter', 1.0, -1.0, 3500, 1, 0, true, 0, false, "", false)
    Wait(3500)
    loadAnim('script_ca@carust@02@ig@ig1_rustlerslockpickingconv01')
    TaskPlayAnim(player, 'script_ca@carust@02@ig@ig1_rustlerslockpickingconv01', 'idle_01_smhthug_01', 1.0, -1.0, -1, 1, 0, true, 0, false, "", false)
end

local function getDoorForLockPick(item)
    local job = LocalPlayer.state.Character.Job
    for door, value in pairs(Config.Doors) do
        if value.BreakAble and value.BreakAble == item then
            local distance <const> = GetPlayerDistanceFromCoords(value.Pos.x, value.Pos.y, value.Pos.z)
            if distance < 2.0 then
                return true, door
            end
        end
    end
    return false
end

RegisterNetEvent("vorp_doorlocks:Client:lockpickdoor", function(item)
    local isLockpick <const>, door <const> = getDoorForLockPick(item)
    if not isLockpick then return Core.NotifyObjective("not near a door or this dont cant be lockpicked", 2000) end -- player is not near any door or the item is not allowed to lockpick

    local value <const> = Config.Doors[door]
    -- door state ?
    if value.DoorState == 0 then return Core.NotifyObjective("door is already open", 5000) end -- door is already open
    startLockPickAnim()

    local result <const> = exports.lockpick:startLockpick(value.Difficulty)
    if result then
        if value.Alert then
            if math.random() < Config.AlertProbability then
                TriggerServerEvent("vorp_doorlocks:Server:AlertPolice")
            end
        end
        TriggerServerEvent("vorp_doorlocks:Server:UpdateDoorState", door, 0, true)
    else
        TriggerServerEvent("vorp_doorlocks:Server:RemoveLockpick", item)
    end
    Wait(1000)
    TaskPlayAnim(PlayerPedId(), 'script_proc@rustling@unapproved@gate_lockpick', 'exit', 1.0, -1.0, 2500, 1, 0, true, 0, false, "", false)
    Wait(2500)
    RemoveAnimDict('script_ca@carust@02@ig@ig1_rustlerslockpickingconv01')
    RemoveAnimDict('script_proc@rustling@unapproved@gate_lockpick')
end)


local function ThreadHandler()
    while true do
        local sleep = 1000
        for door, v in pairs(Config.Doors) do
            if v.isAllowed then -- dont show prompt if player is not allowed to open the door
                local distance = GetPlayerDistanceFromCoords(v.Pos.x, v.Pos.y, v.Pos.z)
                if distance < 1.5 then
                    sleep = 0
                    local label = VarString(10, 'LITERAL_STRING', v.Name .. " " .. (v.DoorState == 0 and "Open" or "Close"))
                    UiPromptSetActiveGroupThisFrame(PromptGroup1, label, 0, 0, 0, 0)

                    if UiPromptIsJustPressed(OpenDoors) then
                        local ped = PlayerPedId()
                        HidePedWeapons(ped, 2, true)
                        PlayKeyAnim(ped, 2500)
                        Wait(2500)
                        ClearPedTasksImmediately(ped)
                        v.DoorState = v.DoorState == 0 and 1 or 0
                        TriggerServerEvent("vorp_doorlocks:Server:UpdateDoorState", door, v.DoorState)
                    end
                end
            end
        end

        Wait(sleep)
    end
end

local function manageDoorState()
    for key, value in pairs(Config.Doors) do
        if value.Permissions then
            local job = LocalPlayer.state.Character.Job
            if value.Permissions[job] then
                value.isAllowed = true
            else
                value.isAllowed = false
            end
        else
            value.isAllowed = true
        end
    end
end

RegisterNetEvent("vorp_doorlocks:Client:UpdatePerms", function()
    Wait(1000)
    manageDoorState()
end)


RegisterNetEvent("vorp_doorlocks:Client:UpdateDoorState", function(door, state)
    Config.Doors[door].DoorState = state
    if state == 1 then
        DoorSystemForceShut(door, true)
        DoorSystemSetOpenRatio(door, 0.0, true)
    end
    DoorSystemSetDoorState(door, state)
end)

RegisterNetEvent("vorp_doorlocks:Client:Sync", function(data)
    local doors <const> = msgpack.unpack(data)
    for door, state in pairs(doors) do
        Config.Doors[door].DoorState = state
        if state == 1 then
            DoorSystemForceShut(door, true)
            DoorSystemSetOpenRatio(door, 0.0, true)
        end
        DoorSystemSetDoorState(door, state)
    end

    manageDoorState()
    registerPrompt()
    addDoorsToSystem()
    CreateThread(ThreadHandler)
end)


AddEventHandler("onClientResourceStart", function(resource)
    if GetCurrentResourceName() ~= resource then return end
    if not Config.DevMode then return end
    repeat Wait(2000) until LocalPlayer.state.IsInSession
    manageDoorState()
    registerPrompt()
    addDoorsToSystem()
    CreateThread(ThreadHandler)
end)
