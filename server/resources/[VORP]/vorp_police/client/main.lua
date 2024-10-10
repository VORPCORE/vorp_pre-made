local Core       = exports.vorp_core:GetCore()
local MenuData   = exports.vorp_menu:GetMenuData()
local T          = Translation.Langs[Config.Lang]
local draggedBy  = -1
local drag       = false
local wasDragged = false
local blip       = 0

-- on resource stop
AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if drag then
        drag = false
        DetachEntity(PlayerPedId(), true, false)
    end
    -- remove blips
    for key, value in pairs(Config.Stations) do
        RemoveBlip(value.BlipHandle)
    end
end)

local function getClosestPlayer()
    local players <const> = GetActivePlayers()
    local coords <const> = GetEntityCoords(PlayerPedId())

    for _, value in ipairs(players) do
        if PlayerId() ~= value then
            local targetPed <const> = GetPlayerPed(value)
            local targetCoords <const> = GetEntityCoords(targetPed)
            local distance <const> = #(coords - targetCoords)
            if distance < 3.0 then
                return true, targetPed, value
            end
        end
    end
    return false, nil
end

local group <const> = GetRandomIntInRange(0, 0xFFFFFF)
local prompt        = 0
local function registerPrompts()
    if prompt ~= 0 then UiPromptDelete(prompt) end
    prompt = UiPromptRegisterBegin()
    UiPromptSetControlAction(prompt, Config.Keys.B)
    local label = VarString(10, "LITERAL_STRING", T.Menu.Press)
    UiPromptSetText(prompt, label)
    UiPromptSetGroup(prompt, group, 0)
    UiPromptSetStandardMode(prompt, true)
    UiPromptRegisterEnd(prompt)
end

local function applyBadge(result)
    local playerPed <const> = PlayerPedId()
    if result then
        RemoveTagFromMetaPed(playerPed, 0x3F7F3587, 0)
        UpdatePedVariation(playerPed, false, true, true, true, false)
        if IsPedMale(playerPed) then
            ApplyShopItemToPed(playerPed, 0x1FC12C9C, true, true, true)
        else
            ApplyShopItemToPed(playerPed, 0x929677D, true, true, true)
        end
        UpdatePedVariation(playerPed, false, true, true, true, false)
    else
        RemoveTagFromMetaPed(playerPed, 0x3F7F3587, 0)
        UpdatePedVariation(playerPed, false, true, true, true, false)
    end
end

local function getPlayerJob()
    local job <const> = LocalPlayer.state.Character.Job
    return Config.PoliceJobs[job]
end

local function isOnDuty()
    if not LocalPlayer.state.isPoliceDuty then
        Core.NotifyObjective(T.Duty.YouAreNotOnDuty, 5000)
        return false
    end
    return true
end

local function createBlips()
    for key, value in pairs(Config.Stations) do
        local blip <const> = BlipAddForCoords(Config.Blips.Style, value.Coords.x, value.Coords.y, value.Coords.z)
        SetBlipSprite(blip, Config.Blips.Sprite)
        BlipAddModifier(blip, Config.Blips.Color)
        SetBlipName(blip, value.Name)
        value.BlipHandle = blip
    end
end

local isHandleRunning = false
local function Handle()
    registerPrompts()
    isHandleRunning = true
    while true do
        local sleep = 1000
        for key, value in pairs(Config.Stations) do
            local coords <const> = GetEntityCoords(PlayerPedId())

            if value.Storage[key] then
                local distanceStorage <const> = #(coords - value.Storage[key].Coords)
                if distanceStorage < 2.0 then
                    sleep = 0
                    if distanceStorage < 1.5 then
                        local label <const> = VarString(10, "LITERAL_STRING", value.Name)
                        UiPromptSetActiveGroupThisFrame(group, label, 0, 0, 0, 0)

                        if UiPromptHasStandardModeCompleted(prompt, 0) then
                            if isOnDuty() then
                                local isAnyPlayerClose <const> = getClosestPlayer()
                                if not isAnyPlayerClose then
                                    TriggerServerEvent("vorp_police:Server:OpenStorage", key)
                                else
                                    Core.NotifyObjective(T.Error.Playernearby, 5000)
                                end
                            end
                        end
                    end
                end
            end

            if value.Teleports[key] then
                local distanceTeleport <const> = #(coords - value.Teleports[key].Coords)
                if distanceTeleport < 2.0 then
                    sleep = 0
                    if distanceTeleport < 1.5 then
                        local label <const> = VarString(10, "LITERAL_STRING", value.Name)
                        UiPromptSetActiveGroupThisFrame(group, label, 0, 0, 0, 0)

                        if UiPromptHasStandardModeCompleted(prompt, 0) then
                            if isOnDuty() then
                                OpenTeleportMenu(key)
                            end
                        end
                    end
                end
            end

            local distanceStation <const> = #(coords - value.Coords)
            if distanceStation < 2.0 then
                sleep = 0

                local label <const> = VarString(10, "LITERAL_STRING", value.Name)
                UiPromptSetActiveGroupThisFrame(group, label, 0, 0, 0, 0)

                if UiPromptHasStandardModeCompleted(prompt, 0) then
                    local job <const> = LocalPlayer.state.Character.Job
                    if Config.SheriffJobs[job] then
                        OpenSheriffMenu()
                    else
                        Core.NotifyObjective(T.Error.OnlyPoliceopenmenu, 5000)
                    end
                end
            end
        end

        if not isHandleRunning then return end
        Wait(sleep)
    end
end

local function dragHandle()
    if not isOnDuty() then
        Core.NotifyObjective(T.Duty.YouAreNotOnDuty, 5000)
        return
    end

    local isclose <const>, _, player <const> = getClosestPlayer()
    if isclose then
        local serverid <const> = GetPlayerServerId(player)
        TriggerServerEvent("vorp_police:Server:dragPlayer", serverid)
    end
end

RegisterNetEvent("vorp_police:Client:JobUpdate", function()
    local hasJob = getPlayerJob()

    if not hasJob then
        RegisterCommand(Config.Dragcommand, function()
            Core.NotifyObjective(T.Jobs.YouAreNotAPoliceOfficer, 5000)
        end, false)
        isHandleRunning = false
        return
    end

    if isHandleRunning then return end
    CreateThread(Handle)
    RegisterCommand(Config.Dragcommand, dragHandle, false)
end)

CreateThread(function()
    repeat Wait(5000) until LocalPlayer.state.IsInSession
    createBlips()
    local hasJob <const> = getPlayerJob()
    if not hasJob then return end
    if not isHandleRunning then
        CreateThread(Handle)
        RegisterCommand(Config.Dragcommand, dragHandle, false)
    end
end)

function OpenSheriffMenu()
    MenuData.CloseAll()
    local elements <const> = {
        {
            label = T.Menu.HirePlayer,
            value = "hire",
            desc = T.Menu.HirePlayer .. "<br><br><br><br><br><br><br><br><br><br><br><br>"
        },
        {
            label = T.Menu.FirePlayer,
            value = "fire",
            desc = T.Menu.FirePlayer .. "<br><br><br><br><br><br><br><br><br><br><br><br>"
        }
    }

    MenuData.Open("default", GetCurrentResourceName(), "OpenSheriffMenu", {
        title = T.Menu.SheriffMenu,
        subtext = T.Menu.HireFireMenu,
        align = Config.Align,
        elements = elements,

    }, function(data, menu)
        if data.current.value == "hire" then
            OpenHireMenu()
        elseif data.current.value == "fire" then
            local MyInput <const> = {
                type = "enableinput",
                inputType = "input",
                button = T.Player.Confirm,
                placeholder = T.Player.PlayerId,
                style = "block",
                attributes = {
                    inputHeader = T.Menu.FirePlayer,
                    type = "number",
                    pattern = "[0-9]",
                    title = T.Player.OnlyNumbersAreAllowed,
                    style = "border-radius: 10px; background-color: ; border:none;",
                }
            }

            local res = exports.vorp_inputs:advancedInput(MyInput)
            res = tonumber(res)
            if res and res > 0 then
                TriggerServerEvent("vorp_police:server:firePlayer", res)
            end
        end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenHireMenu()
    MenuData.CloseAll()
    local elements = {}
    for key, _ in pairs(Config.PoliceJobs) do
        table.insert(elements, { label = T.Jobs.Job .. ": " .. key, value = key, desc = T.Jobs.Job .. key })
    end

    MenuData.Open("default", GetCurrentResourceName(), "OpenHireFireMenu", {
        title = T.Menu.HireFireMenu,
        subtext = T.Menu.SubMenu,
        elements = elements,
        align = Config.Align,
        lastmenu = "OpenSheriffMenu"

    }, function(data, menu)
        if (data.current == "backup") then
            return _G[data.trigger]()
        end

        menu.close()
        local MyInput = {
            type = "enableinput",
            inputType = "input",
            button = T.Player.Confirm,
            placeholder = T.Player.PlayerId,
            style = "block",
            attributes = {
                inputHeader = T.Menu.HirePlayer,
                type = "number",
                pattern = "[0-9]",
                title = T.Player.OnlyNumbersAreAllowed,
                style = "border-radius: 10px; background-color: ; border:none;",
            }
        }

        local res = exports.vorp_inputs:advancedInput(MyInput)
        res = tonumber(res)
        if res and res > 0 then
            TriggerServerEvent("vorp_police:server:hirePlayer", res, data.current.value)
        end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenTeleportMenu(location)
    MenuData.CloseAll()
    local elements = {}
    for key, value in pairs(Config.Teleports) do
        if location then
            if location ~= key then
                table.insert(elements, {
                    label = key,
                    value = key,
                    desc = T.Teleport.TeleportTo .. ": " .. value.Name
                })
            end
        else
            table.insert(elements, {
                label = key,
                value = key,
                desc = T.Teleport.TeleportTo .. ": " .. value.Name
            })
        end
    end

    MenuData.Open("default", GetCurrentResourceName(), "OpenTeleportMenu", {
        title = T.Teleport.TeleportMenu,
        subtext = T.Menu.SubMenu,
        align = Config.Align,
        elements = elements,

    }, function(data, menu)
        menu.close()
        local coords <const> = Config.Teleports[data.current.value].Coords
        DoScreenFadeOut(1000)
        repeat Wait(0) until IsScreenFadedOut()
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
        repeat Wait(0) until HasCollisionLoadedAroundEntity(PlayerPedId()) == 1
        DoScreenFadeIn(1000)
        repeat Wait(0) until IsScreenFadedIn()
    end, function(data, menu)
        menu.close()
    end)
end

local function OpenPoliceMenu()
    MenuData.CloseAll()
    local isONduty <const> = LocalPlayer.state.isPoliceDuty
    local label <const> = isONduty and T.Duty.OffDuty or T.Duty.OnDuty
    local desc <const> = isONduty and T.Duty.GoOffDuty or T.Duty.GoOnDuty
    local elements <const> = {
        {
            label = label,
            value = "duty",
            desc = desc .. "<br><br><br><br><br><br><br><br><br><br><br><br>"
        }
    }

    if Config.UseTeleportsMenu then
        table.insert(elements, {
            label = T.Teleport.TeleportTo,
            value = "teleports",
            desc = T.Teleport.TeleportToDifferentLocations .. "<br><br><br><br><br><br><br><br><br><br><br><br>"
        })
    end

    MenuData.Open("default", GetCurrentResourceName(), "OpenPoliceMenu", {
        title = T.Menu.SheriffMenu,
        subtext = T.Menu.SubMenu,
        align = Config.Align,
        elements = elements,

    }, function(data, menu)
        if data.current.value == "teleports" then
            OpenTeleportMenu()
        elseif data.current.value == "duty" then
            local result = Core.Callback.TriggerAwait("vorp_police:server:checkDuty")
            if result then
                Core.NotifyObjective(T.Duty.YouAreNowOnDuty, 5000)
                applyBadge(true)
            else
                Core.NotifyObjective(T.Duty.YouAreNotOnDuty, 5000)
                applyBadge(false)
            end
            menu.close()
        end
    end, function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent("vorp_police:Client:OpenPoliceMenu", function()
    OpenPoliceMenu()
end)

RegisterNetEvent('vorp_police:Client:PlayerCuff', function(action)
    local playerPed <const> = PlayerPedId()
    if action == "cuff" then
        CuffPed(playerPed)
        SetEnableHandcuffs(playerPed, true, false)
        SetPedCanPlayGestureAnims(playerPed, false)
        DisplayRadar(false)
    else
        UncuffPed(playerPed)
        SetEnableHandcuffs(playerPed, false, false)
        SetPedCanPlayGestureAnims(playerPed, true)
        DisplayRadar(true)
    end
end)

Core.Callback.Register("vorp_police:server:isPlayerCuffed", function(CB)
    local isclose <const>, playerped <const>, player <const> = getClosestPlayer()
    if not isclose then
        Core.NotifyObjective(T.Player.NoPlayerFound, 5000)
        return CB({ false, false })
    end

    local isCuffed <const> = IsPedCuffed(playerped)
    local serverid <const> = GetPlayerServerId(player)

    return CB({ isCuffed, serverid })
end)

RegisterNetEvent("vorp_police:Client:dragPlayer", function(_source)
    draggedBy = _source
    drag = not drag
end)

AddEventHandler("vorp_core:Client:OnPlayerDeath", function(killerserverid, causeofdeath)
    if drag then
        drag = false
        wasDragged = true
    end
end)

CreateThread(function()
    repeat Wait(5000) until LocalPlayer.state.IsInSession

    while true do
        local sleep = 1000
        if drag then
            wasDragged = true
            local entity2 = GetPlayerPed(GetPlayerFromServerId(draggedBy))
            AttachEntityToEntity(PlayerPedId(), entity2, 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, false, false, false,
                false, 2, false, true, false)
        else
            if wasDragged then
                wasDragged = false
                DetachEntity(PlayerPedId(), true, false)
            end
        end
        Wait(sleep)
    end
end)


RegisterNetEvent("vorp_police:Client:AlertPolice", function(targetCoords)
    if blip ~= 0 then return end -- dont allow more than one call

    blip = BlipAddForCoords(Config.Blips.Style, targetCoords.x, targetCoords.y, targetCoords.z)
    SetBlipSprite(blip, Config.Blips.Sprite)
    BlipAddModifier(blip, Config.Blips.Color)
    SetBlipName(blip, "player alert")

    StartGpsMultiRoute(joaat("COLOR_RED"), true, true)
    AddPointToGpsMultiRoute(targetCoords.x, targetCoords.y, targetCoords.z, false)
    SetGpsMultiRouteRender(true)

    repeat Wait(1000) until #(GetEntityCoords(PlayerPedId()) - targetCoords) < 15.0 or blip == 0

    if blip ~= 0 then
        Core.NotifyObjective(T.Alerts.arive, 5000)
    end
    RemoveBlip(blip)
    blip = 0
    ClearGpsMultiRoute()
end)


RegisterNetEvent("vorp_police:Client:RemoveBlip", function()
    if blip == 0 then return end
    RemoveBlip(blip)
    blip = 0
    ClearGpsMultiRoute()
end)
