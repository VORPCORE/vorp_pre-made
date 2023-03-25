local TEXTS = Config.Texts
local TEXTURES = Config.Textures
local pcoords = nil
local isdead = nil
local praying = false
local digging = true
local shovelObject = nil
local BlipEntities
local PromptKey
local PromptKey2
local PromptGroup = GetRandomIntInRange(0, 0xffffff)
local Town
local prompts = {}

function TableNum(tbl)
    local c = 0
    for i, v in pairs(tbl) do
        c = c + 1
    end
    return c
end

function LoadPrompts()
    local str = TEXTS.Prompt1
    PromptKey = PromptRegisterBegin()
    PromptSetControlAction(PromptKey, Config.Prompts.Prompt1)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(PromptKey, str)
    PromptSetEnabled(PromptKey, 1)
    PromptSetVisible(PromptKey, 1)
    PromptSetStandardMode(PromptKey, 1)
    PromptSetGroup(PromptKey, PromptGroup)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, PromptKey, true)
    PromptRegisterEnd(PromptKey)
    prompts[#prompts + 1] = PromptKey

    local str = TEXTS.Prompt2
    PromptKey2 = PromptRegisterBegin()
    PromptSetControlAction(PromptKey2, Config.Prompts.Prompt2)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(PromptKey2, str)
    PromptSetEnabled(PromptKey2, 1)
    PromptSetVisible(PromptKey2, 1)
    PromptSetStandardMode(PromptKey2, 1)
    PromptSetGroup(PromptKey2, PromptGroup)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, PromptKey2, true)
    PromptRegisterEnd(PromptKey2)
    prompts[#prompts + 1] = PromptKey2
end

Citizen.CreateThread(function()
    LoadPrompts()
    while true do
        Citizen.Wait(500)
        pcoords = GetEntityCoords(PlayerPedId())
        isdead = IsEntityDead(PlayerPedId())
    end
end)



Citizen.CreateThread(function()
    while true do
        local t = 5
        if pcoords and (isdead ~= nil and isdead == false) then
            for i, v in pairs(Config.Graves) do
                local dist = #(pcoords - v.coords)

                if dist < 1.0 then
                    local label = CreateVarString(10, 'LITERAL_STRING', TEXTS.GraveDisplay .. " " .. v.name)
                    PromptSetActiveGroupThisFrame(PromptGroup, label)
                    if Citizen.InvokeNative(0xC92AC953F0A982AE, PromptKey) then
                        TriggerEvent("ricx_grave_robbery:dig", i)
                        Citizen.Wait(2000)
                    end
                    if Citizen.InvokeNative(0xC92AC953F0A982AE, PromptKey2) then
                        TriggerEvent("ricx_grave_robbery:pray", i)
                        Citizen.Wait(2000)
                    end
                end
            end
        else
            t = 1500
        end
        Citizen.Wait(t)
    end
end)

function EndShovel()
    digging = false
    if shovelObject then
        DeleteObject(shovelObject)
        SetEntityAsNoLongerNeeded(shovelObject)
        shovelObject = nil
    end
    ClearPedTasks(PlayerPedId())
end

RegisterNetEvent("ricx_grave_robbery:dig")
AddEventHandler("ricx_grave_robbery:dig", function(id)
    if praying then
        TriggerEvent("Notification:left_grave_robbery", TEXTS.GraveRobbery, TEXTS.CantDoThat, TEXTURES.alert[1],
            TEXTURES.alert[2], 2000)
        return
    end
    if digging then
        EndShovel()
    else
        TriggerServerEvent("ricx_grave_robbery:check_shovel", id, Town)
    end
end)

function AttachEnt(from, to, boneIndex, x, y, z, pitch, roll, yaw, useSoftPinning, collision, vertex, fixedRot)
    return AttachEntityToEntity(from, to, boneIndex, x, y, z, pitch, roll, yaw, false, useSoftPinning, collision, false,
        vertex, fixedRot, false, false)
end

RegisterNetEvent("ricx_grave_robbery:start_dig")
AddEventHandler("ricx_grave_robbery:start_dig", function(id)
    if shovelObject then
        DeleteObject(shovelObject)
        SetEntityAsNoLongerNeeded(shovelObject)
        shovelObject = nil
    end
    digging = true
    local pedp = PlayerPedId()
    local pc = GetEntityCoords(pedp)
    local model = Config.Dig.shovel
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
    shovelObject = CreateObject(model, pc.x, pc.y, pc.z, true, true, true)
    local boneIndex = GetEntityBoneIndexByName(pedp, Config.Dig.bone)
    local Attach = Config.Dig.pos
    local heading = Config.Graves[id].heading
    SetEntityHeading(PlayerPedId(), heading)
    local anim = Config.Dig.anim
    RequestAnimDict(anim[1])
    while not HasAnimDictLoaded(anim[1]) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(pedp, anim[1], anim[2], 1.0, 1.0, -1, 1, 0, false, false, false)
    AttachEnt(shovelObject, pedp, boneIndex, Attach[1], Attach[2], Attach[3], Attach[4], Attach[5], Attach[6], 0, 1, 1, 1)
    TriggerEvent("ricx_grave_robbery:digging_timer", id)
    Citizen.Wait(200)
    RemoveAnimDict(anim[1])
    SetModelAsNoLongerNeeded(model)
end)

RegisterNetEvent("ricx_grave_robbery:digging_timer")
AddEventHandler("ricx_grave_robbery:digging_timer", function(id)
    local timer = Config.DiggingTimer
    local timer2 = 0
    while timer2 ~= timer and digging do
        Citizen.Wait(1000)
        timer2 = timer2 + 1
        if not digging then
            break
        end
    end
    if digging then
        EndShovel()
        TriggerServerEvent("ricx_grave_robbery:reward", id)
    end
end)

RegisterNetEvent("ricx_grave_robbery:pray")
AddEventHandler("ricx_grave_robbery:pray", function(id)
    if digging then
        TriggerEvent("Notification:left_grave_robbery", TEXTS.GraveRobbery, TEXTS.CantDoThat, TEXTURES.alert[1],
            TEXTURES.alert[2], 2000)
        return
    end
    if praying then
        ClearPedTasks(PlayerPedId())
    else
        local randomAnim = math.random(1, #Config.PrayAnim)
        local anim = Config.PrayAnim[randomAnim]
        local heading = Config.Graves[id].heading
        RequestAnimDict(anim[1])
        while not HasAnimDictLoaded(anim[1]) do
            Citizen.Wait(0)
        end
        SetEntityHeading(PlayerPedId(), heading)
        TaskPlayAnim(PlayerPedId(), anim[1], anim[2], 1.0, 1.0, -1, 1, 0, true, 0, false, 0, false)
        Citizen.Wait(500)
        Citizen.Wait(500)
        RemoveAnimDict(anim[1])
    end
    praying = not praying
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    if praying or digging then
        EndShovel()
    end
    for i, v in pairs(prompts) do
        PromptDelete(v)
    end
end)
----------------------------Basic Notification----------------------------

RegisterNetEvent('Notification:left_grave_robbery')
AddEventHandler('Notification:left_grave_robbery', function(t1, t2, dict, txtr, timer)
    if Config.framework == "redemrp" then
        local _dict = tostring(dict)
        if not HasStreamedTextureDictLoaded(_dict) then
            RequestStreamedTextureDict(_dict, true)
            while not HasStreamedTextureDictLoaded(_dict) do
                Citizen.Wait(5)
            end
        end
        if txtr ~= nil then
            exports.ricx_grave_robbery.LeftNot(0, tostring(t1), tostring(t2), tostring(dict), tostring(txtr),
                tonumber(timer))
        else
            local txtr = "tick"
            exports.ricx_grave_robbery.LeftNot(0, tostring(t1), tostring(t2), tostring(dict), tostring(txtr),
                tonumber(timer))
        end
        SetStreamedTextureDictAsNoLongerNeeded(_dict)
    elseif Config.framework == "vorp" then
        TriggerEvent("vorp:TipBottom", t1 .. "\n" .. t2, timer)
    elseif Config.framework == "qbr" then
        TriggerEvent('QBCore:Notify', 9, t1 .. "\n" .. t2, timer, 0, dict, txtr, 'COLOR_WHITE')
    end
end)

if Config.framework == "vorp" then
    RegisterNetEvent('vorp:SelectedCharacter', function()
        local player = GetPlayerServerId(tonumber(PlayerId()))
        Wait(100)
        TriggerServerEvent("outsider_robbery:sendPlayers", player)
    end)
end


Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1000)

            local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
            local ZoneTypeId = 1
            local current_district = Citizen.InvokeNative(0x43AD8FC02B429D33, x, y, z, ZoneTypeId)

            if current_district then

                if current_district == 459833523 then
                    Town = "Valentine"
                elseif current_district == 1053078005 then
                    Town = "Blackwater"
                elseif current_district == 427683330 then
                    Town = "Strawberry"
                elseif current_district == -765540529 then
                    Town = "Saint Denis"
                elseif current_district == 7359335 then
                    Town = "Annesburg"
                elseif current_district == -744494798 then
                    Town = "Armadillo"
                elseif current_district == 2046780049 then
                    Town = "Rhodes"
                elseif current_district == 2126321341 then
                    Town = "Vanhorn"
                elseif current_district == -1524959147 then
                    Town = "Tumbleweed"
                end
            end

        end
    end
)
