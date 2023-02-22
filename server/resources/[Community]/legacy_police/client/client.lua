local IsHandcuffed = false
local IsSearching = false
local playerJob
local star = false
local timeinjail = 0
local playerid = 0
local fineamount = 0
local jailname = _U('none')
local JailID
local Tele = _U('vartrue')
local Autotele = true
local chore = _U('none')
local Choreamount = _U('none')
local currentCheck
local jaillocation
local Jailed = false
local Open
local Search
local searchid
local takenmoney
local InWagon = false

PoliceOnDuty = nil

local dragStatus = {}
dragStatus.isDragged = false

local prompt2 = GetRandomIntInRange(0, 0xffffff)
local prompt = GetRandomIntInRange(0, 0xffffff)

CreateThread(function()
    local str = _U('opencabinet')
    Open = PromptRegisterBegin()
    PromptSetControlAction(Open, 0xCEFD9220)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(Open, str)
    PromptSetEnabled(Open, true)
    PromptSetVisible(Open, true)
    PromptSetHoldMode(Open, true, 2000)
    PromptSetGroup(Open, prompt)
    PromptRegisterEnd(Open)

    local str = _U('search')
    Search = PromptRegisterBegin()
    PromptSetControlAction(Search, 0xC7B5340A)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(Search, str)
    PromptSetEnabled(Search, true)
    PromptSetVisible(Search, true)
    PromptSetHoldMode(Search, true, 2000)
    PromptSetGroup(Search, prompt2)
    PromptRegisterEnd(Search)
end)

local VORPcore = {}

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

Citizen.CreateThread(function() -- In jail chores to reduce time in jail
    while true do
        Wait(0)
        if Jailed then
            local doingchore = false
            for k, v in pairs(Config.jailchores) do
                local blip = N_0x554d9d53f696d002(1664425300, v.x, v.y, v.z)
                SetBlipSprite(blip, 28148096, 1)
                Citizen.InvokeNative(0x9CB1A1623062F402, blip, _U('jailchoreblip'))
                local coords = GetEntityCoords(PlayerPedId())
                local currentCheck = Vdist2(coords.x, coords.y, coords.z, v.x, v.y, v.z)
                if currentCheck < 5 then
                    DrawTxt(_U('presstodotask'), 0.42, 0.90, 0.4, 0.4, true, 255, 255, 255, 255, false)
                    if IsControlJustReleased(0, 0xCEFD9220) and doingchore == false then
                        TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_BROOM_WORKING'), 10000, true,
                            false, false, false)
                        Wait(10000)
                        ClearPedTasksImmediately(PlayerPedId())
                        SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true) -- unarm player
                        Jail_time = Jail_time - 10
                        Wait(10000)
                    end
                end
            end

        end
    end
end)

Citizen.CreateThread(function() -- In jail chores to reduce time in jail
    while true do
        Wait(0)
        local playercoords = GetEntityCoords(PlayerPedId())
        while Jailed do
            Wait(0)
            if JailID == "sk" then
                local Jailedcoords = GetEntityCoords(PlayerPedId())
                local currentCheck = GetDistanceBetweenCoords(Jailedcoords.x, Jailedcoords.y, Jailedcoords.z,
                    Config.Jails.sisika.entrance.x, Config.Jails.sisika.entrance.y, Config.Jails.sisika.entrance.z,
                    true)
                print(currentCheck)
                if currentCheck > 420 then
                    TriggerEvent("lawmen:breakout")
                end
            else
                local Jailedcoords = GetEntityCoords(PlayerPedId())
                local currentCheck2 = GetDistanceBetweenCoords(playercoords.x, playercoords.y, playercoords.z,
                    Jailedcoords.x, Jailedcoords.y, Jailedcoords.z, true)
                print(currentCheck2)
                if currentCheck2 > 15 then
                    TriggerEvent("lawmen:breakout")
                end
            end
        end
    end
end)


Citizen.CreateThread(function() -- Community Service Logic, including animations minigame difficulty and more
    while true do
        Wait(10)
        local coords = GetEntityCoords(PlayerPedId())
        if Serviced then
            if not Serviceblip then
                Serviceblip = N_0x554d9d53f696d002(1664425300, Pos.x, Pos.y, Pos.z)
                SetBlipSprite(Serviceblip, 28148096, 1)
                Citizen.InvokeNative(0x9CB1A1623062F402, Serviceblip, _U('jailchoreblip'))
            end

            currentCheck = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, Pos.x, Pos.y, Pos.z, true)
            if currentCheck < 1 then
                DrawTxt(_U('presstodotask'), 0.38, 0.90, 0.4, 0.4, true, 255, 255, 255, 255, false)
                if IsControlJustReleased(0, 0xCEFD9220) then
                    if Config.CommunityServiceSettings.minigame then
                        local test = exports["syn_minigame"]:taskBar(3000, 7) -- difficulty,skillGapSent
                        if test == 100 then
                            local ped = PlayerPedId()
                            if IsPedMale(ped) then
                                TaskStartScenarioInPlace(PlayerPedId(),
                                    GetHashKey('PROP_HUMAN_REPAIR_WAGON_WHEEL_ON_SMALL'), 10000, true, false, false,
                                    false)
                            else
                                TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 10000,
                                    true, false, false, false)
                            end
                            Wait(12000)
                            Choreamount = Choreamount - 1
                            TriggerServerEvent("lawmen:updateservice")
                        else
                            VORPcore.NotifyBottomRight(_U('taskfailed'), 4000)
                        end
                    else
                        TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 10000, true,
                            false, false, false)
                        Wait(10000)
                        SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true) -- unarm player
                    end

                end
            end

            for k, v in pairs(Config.construction) do
                local coords = GetEntityCoords(PlayerPedId())
                if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) >
                    Config.CommunityServiceSettings.communityservicedistance then
                    Brokedistance = true
                else
                    Brokedistance = false
                end
            end
        end

        if Choreamount and Choreamount == 0 then
            TriggerServerEvent("lawmen:endservice")
            Serviced = false
            RemoveBlip(Serviceblip)
            Serviceblip = nil
            VORPcore.NotifyBottomRight(_U('servicecomplete'), 4000)
            break
        end
    end
end)

RegisterNetEvent("lawmen:ServicePlayer") -- Assigns Chore amount and picks random coord for construcion
AddEventHandler("lawmen:ServicePlayer", function(chore, amount)
    Serviced = true
    Choreamount = amount
    Pos = Config.construction[math.random(1, #Config.construction)]
end)

Citizen.CreateThread(function() -- Prompt and code to access Gun Cabinets
    while true do
        Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        local isDead = IsEntityDead(PlayerPedId())
        for k, v in pairs(Config.Guncabinets) do

            if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.5 and not Inmenu then
                if not isDead then
                    local item_name = CreateVarString(10, 'LITERAL_STRING', _U('opencabinet'))
                    PromptSetActiveGroupThisFrame(prompt, item_name)

                    if PromptHasHoldModeCompleted(Open) then
                        TriggerServerEvent("lawmen:PlayerJob") -- run client side check before check for distance. no need to run code that is not meant for the client its optimized this way
                        Wait(200)
                        if CheckTable(OnDutyJobs, playerJob) then
                            Inmenu = true
                            CabinetMenu()
                        end
                    end
                end
            end
        end
    end
end)

function CuffPlayer(closestPlayer) -- Prompt and code to access Gun Cabinets
    while true do
        local playercoords = GetEntityCoords(PlayerPedId())
        local tgtcoords = GetEntityCoords(GetPlayerPed(closestPlayer))
        local distance = #(playercoords - tgtcoords)
        local isDead = IsEntityDead(PlayerPedId())
        Wait(0)
        if distance <= 1.5 then
            if not isDead then
                if IsSearching then
                    if not Inmenu then
                        if not InWagon then
                            local item_name = CreateVarString(10, 'LITERAL_STRING', _U('searchplayer'))
                            PromptSetActiveGroupThisFrame(prompt2, item_name)
                        end
                    end
                end
            end
        end
        if PromptHasHoldModeCompleted(Search) then
            TriggerServerEvent('lawmen:grabdata', GetPlayerServerId(closestPlayer))
            Wait(200)
            if takenmoney then
                SearchMenu(takenmoney)
            end
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if InWagon then 
            SetRelationshipBetweenGroups(1, `PLAYER`, `PLAYER`)
        end
    end
end)

function PutInOutVehicle()
    local closestPlayer, closestDistance = GetClosestPlayer()
    local iscuffed = Citizen.InvokeNative(0x74E559B3BC910685, closestPlayer)
    print(iscuffed)
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('lawmen:GetPlayerWagonID', GetPlayerServerId(closestPlayer))
    else
        VORPcore.NotifyBottomRight(_U('notcloseenough'), 4000)
        return
    end
end

RegisterNetEvent('lawmen:PlayerInWagon') --Put in Vehicle logic, not in use currently
AddEventHandler('lawmen:PlayerInWagon', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local closestWagon = GetClosestVehicle(coords)
    local vehicle = IsPedInVehicle(ped, closestWagon, 0)
        local seat = math.random(2,6)
    if ped ~= nil then
        if not vehicle then

            SetPedIntoVehicle(ped, closestWagon, seat)
            Wait(500)
            InWagon = true
        else
            TaskLeaveVehicle(ped, closestWagon, 16)
            Wait(5000)
            InWagon = false
        end
    end
end)

function GetClosestVehicle(coords)
    local ped = PlayerPedId()
    local objects = GetGamePool('CVehicle')
    local closestDistance = -1
    local closestObject = -1
    if coords then
    else
        coords = GetEntityCoords(ped)
    end
    for i = 1, #objects, 1 do
        local objectCoords = GetEntityCoords(objects[i])
        local distance = #(objectCoords - coords)
        if closestDistance == -1 or closestDistance > distance then
            closestObject = objects[i]
            closestDistance = distance
        end
    end
    return closestObject, closestDistance
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if InWagon == true then
            DisableControlAction(1, 0xFEFAB9B4, true)
            DisableControlAction(1, 0xE31C6A41, true)
            DisableControlAction(1, 0x4CC0E2FE, true)
        end
    end
end)

function GetClosestPlayer() -- Get closest player function
    local players, closestDistance, closestPlayer = GetActivePlayers(), -1, -1
    local playerPed, playerId = PlayerPedId(), PlayerId()
    local coords, usePlayerPed = coords, false

    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        usePlayerPed = true
        coords = GetEntityCoords(playerPed)
    end

    for i = 1, #players, 1 do
        local tgt = GetPlayerPed(players[i])

        if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then

            local targetCoords = GetEntityCoords(tgt)
            local distance = #(coords - targetCoords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = players[i]
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

RegisterNetEvent('lawmen:StartSearch', function()
    local closestPlayer, closestDistance = GetClosestPlayer()
    searchid = GetPlayerServerId(closestPlayer)
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent("lawmen:ReloadInventory", searchid)
        TriggerEvent("vorp_inventory:OpenstealInventory", _U('inventorytitle'), searchid)
    end
end)

RegisterNetEvent('lawmen:GetSearch')
AddEventHandler('lawmen:GetSearch', function(obj)
    TriggerServerEvent('lawmen:TakeFrom', obj, searchid)
end)

function CheckTable(table, element) --Job checking table
    for k, v in pairs(table) do
        if v == element then
            return true
        end
    end
    return false
end

RegisterNetEvent("lawmen:PlayerJob") -- Job check event
AddEventHandler("lawmen:PlayerJob", function(Job)
    playerJob = Job
end)

RegisterNetEvent("lawmen:senddata") -- Job check event
AddEventHandler("lawmen:senddata", function(playermoney)
    takenmoney = playermoney
end)
--Start of Menu Code

PlayerIDInput = { -- Player ID input
    type = "enableinput", -- don't touch
    inputType = "input", -- input type
    button = _U('inputconfirm'), -- button name
    placeholder = _U('playerid'), -- placeholder name
    style = "block", -- don't touch
    attributes = {
        inputHeader = _U('playerid'), -- header
        type = "number", -- inputype text, number,date,textarea ETC
        pattern = "[0-9]", --  only numbers "[0-9]" | for letters only "[A-Za-z]+"
        title = _U('numberonly'), -- if input doesnt match show this message
        style = "border-radius: 10px; background-color: ; border:none;" -- style
    }
}

FineAmount = { -- Fine Amount input
    type = "enableinput", -- don't touch
    inputType = "input", -- input type
    button = _U('inputconfirm'), -- button name
    placeholder = _U('fineamount'), -- placeholder name
    style = "block", -- don't touch
    attributes = {
        inputHeader = _U('fineamount'), -- header
        type = "number", -- inputype text, number,date,textarea ETC
        pattern = "[0-9]", --  only numbers "[0-9]" | for letters only "[A-Za-z]+"
        title = _U('numberonly'), -- if input doesnt match show this message
        style = "border-radius: 10px; background-color: ; border:none;" -- style
    }
}

JailTime = { -- Jail time input
    type = "enableinput", -- don't touch
    inputType = "input", -- input type
    button = _U('inputconfirm'), -- button name
    placeholder = _U('jailamount'), -- placeholder name
    style = "block", -- don't touch
    attributes = {
        inputHeader = _U('jailamount'), -- header
        type = "number", -- inputype text, number,date,textarea ETC
        pattern = "[0-9]", --  only numbers "[0-9]" | for letters only "[A-Za-z]+"
        title = _U('numberonly'), -- if input doesnt match show this message
        style = "border-radius: 10px; background-color: ; border:none;" -- style
    }
}

MenuData = {}
TriggerEvent("menuapi:getData", function(call)
    MenuData = call
end)

function OpenPoliceMenu() -- Base Police Menu Logic
    Inmenu = true
    MenuData.CloseAll()
    local ped = PlayerPedId()
    local elements = {
        { label = _U('togglebadge'), value = 'star' },
        { label = _U('idmenu'), value = 'idmenu' },
        { label = _U('cufftoggle'), value = 'cuff' },
        { label = _U('escort'), value = 'escort' },
        { label = _U('putinoutvehicle'), value = 'vehicle' },
        { label = _U('fineplayer'), value = 'fine' },
        { label = _U('jailplayer'), value = 'jail' },
        { label = _U('serviceplayer'), value = 'community' },
    }
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U('lawmenu'),
            align    = 'top-left',
            elements = elements,
        },
        function(data, menu)
            if (data.current.value == 'star') then
                if star == false then
                    if not IsPedMale(ped) then
                        Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, 0x0929677D, true, true, true)
                        Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, 0, 1, 1, 1, false)
                    else
                        Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, 0x1FC12C9C, true, true, true)
                        Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, 0, 1, 1, 1, false)
                    end
                    VORPcore.NotifyBottomRight(_U('badgeon'), 4000)
                    star = true
                else
                    if not IsPedMale(ped) then
                        Citizen.InvokeNative(0x0D7FFA1B2F69ED82, ped, 0x0929677D, 0, 0)
                        Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, 0, 1, 1, 1, false)
                    else
                        Citizen.InvokeNative(0x0D7FFA1B2F69ED82, ped, 0x1FC12C9C, 0, 0)
                        Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, 0, 1, 1, 1, false)
                    end
                    VORPcore.NotifyBottomRight(_U('badgeoff'), 4000)
                    star = false
                end
            elseif (data.current.value == 'cuff') then
                local closestPlayer, closestDistance = GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    HandcuffPlayer()
                else
                    VORPcore.NotifyBottomRight(_U('notcloseenough'), 4000)
                end
            elseif (data.current.value == 'escort') then
                local closestPlayer, closestDistance = GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('lawmen:drag', GetPlayerServerId(closestPlayer))
                else
                    VORPcore.NotifyBottomRight(_U('notcloseenough'), 4000)
                end
            elseif (data.current.value == 'fine') then
                OpenFineMenu()

            elseif (data.current.value == 'vehicle') then
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                local closestWagon, distance = GetClosestVehicle(coords)
                if closestWagon ~= -1 and distance <= 5.0 then
                    PutInOutVehicle()
                else
                    VORPcore.NotifyBottomRight(_U('notcloseenoughtowagon'), 4000)
                end
            elseif (data.current.value == 'jail') then
                OpenJailMenu()

            elseif (data.current.value == 'idmenu') then
                OpenIDMenu()

            elseif (data.current.value == 'community') then
                OpenCommunityMenu()
            end
        end,
        function(data, menu)
            Inmenu = false
            menu.close()
        end)
end

function OpenJailMenu() -- Jail menu logic
    MenuData.CloseAll()
    local elements = {
        { label = _U('playerid') .. "<span style='margin-left:10px; color: Red;'>" .. playerid .. '</span>', value = 'id' },
        { label = _U('jailamount') .. "<span style='margin-left:10px; color: Red;'>" .. timeinjail .. '</span>',
            value = 'time' },
        { label = _U('Autotele') .. Tele, value = 'auto', desc = _U('Autoteledesc') },
        { label = _U('jaillocaiton') .. jailname, value = 'loc' },
        { label = _U('jail'), value = 'jail', desc = _U('jaildesc') },
        { label = _U('unjail'), value = 'unjail', desc = _U('unjail') },

    }
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U('jailmenu'),
            align    = 'top-left',
            elements = elements,
            lastmenu = "OpenPoliceMenu"
        },
        function(data, menu)
            if data.current == "backup" then
                _G[data.trigger]()

            elseif (data.current.value == 'id') then

                TriggerEvent("vorpinputs:advancedInput", json.encode(PlayerIDInput), function(result)
                    local amount = tonumber(result)
                    if amount > 0 and amount then -- make sure its not empty or nil
                        playerid = amount
                        menu.close()
                        OpenJailMenu()
                    else
                        print("it's empty?") --notify
                    end
                end)

            elseif (data.current.value == 'time') then

                TriggerEvent("vorpinputs:advancedInput", json.encode(JailTime), function(result)
                    local amount = result
                    if result ~= "" and result then -- make sure its not empty or nil
                        timeinjail = amount
                        menu.close()
                        OpenJailMenu()
                    else
                        print("it's empty?") --notify
                    end
                end)

            elseif (data.current.value == 'jail') then
                Wait(500)
                if JailID == nil then
                    JailID = 'sk'
                end
                TriggerServerEvent('lawmen:JailPlayer', tonumber(playerid), tonumber(timeinjail), JailID)

            elseif (data.current.value == 'auto') then
                if Autotele == false then
                    Autotele = true
                    Tele = _U('vartrue')
                    menu.close()
                    OpenJailMenu()
                else
                    Autotele = false
                    Tele = _U('varfalse')
                    menu.close()
                    OpenJailMenu()
                end

            elseif (data.current.value == 'loc') then
                OpenSubJailMenu()
            elseif (data.current.value == 'unjail') then
                TriggerServerEvent('lawmen:unjailed', playerid, JailID)
            end
        end,
        function(data, menu)
            menu.close()
        end)
end

function OpenSubJailMenu() -- Choosing Jail menu logic
    MenuData.CloseAll()
    local elements = {
        { label = _U('valjail'), value = "val" },
        { label = _U('bwjail'), value = 'bw' },
        { label = _U('sdjail'), value = "sd" },
        { label = _U('rhjail'), value = "rh" },
        { label = _U('stjail'), value = "st" },
        { label = _U('arjail'), value = "ar" },
        { label = _U('tujail'), value = "tu" },
        { label = _U('anjail'), value = "an" },
        { label = _U('sisika'), value = "sk" },
    }
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U('jailmenu'),
            align    = 'top-left',
            elements = elements,
            lastmenu = "OpenJailMenu"
        },
        function(data, menu)
            if data.current == "backup" then
                _G[data.trigger]()

            elseif data.current.value then
                jailname = data.current.label
                JailID = data.current.value
                menu.close()
                OpenJailMenu()
            end
        end,
        function(data, menu)
            menu.close()
        end)
end

function OpenFineMenu() -- Fine Menu logic
    MenuData.CloseAll()
    local elements = {
        { label = _U('playerid') .. "<span style='margin-left:10px; color: Red;'>" .. playerid .. '</span>', value = 'id' },
        { label = _U('fineamount') .. "<span style='margin-left:10px; color: Red;'>" .. fineamount .. '</span>',
            value = 'amount' },
        { label = _U('bill'), value = 'bill', desc = _U('billdesc') },
        { label = _U('fine'), value = 'fine', desc = _U('finedesc') },
    }
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = "Fine Menu",
            subtext  = "Actions",
            align    = 'top-left',
            elements = elements,
            lastmenu = "OpenPoliceMenu"
        },
        function(data, menu)
            if data.current == "backup" then
                _G[data.trigger]()

            elseif (data.current.value == 'id') then

                TriggerEvent("vorpinputs:advancedInput", json.encode(PlayerIDInput), function(result)
                    local amount = result
                    if result ~= "" and result then -- make sure its not empty or nil
                        playerid = amount
                        menu.close()
                        OpenFineMenu()
                    else
                        print("it's empty?") --notify
                    end
                end)

            elseif (data.current.value == 'amount') then

                TriggerEvent("vorpinputs:advancedInput", json.encode(FineAmount), function(result)
                    local amount = result
                    if result ~= "" and result then -- make sure its not empty or nil
                        fineamount = amount
                        menu.close()
                        OpenFineMenu()
                    else
                        print("it's empty?") --notify
                    end
                end)

            elseif (data.current.value == 'bill') then
                TriggerServerEvent("syn_society:bill", tonumber(fineamount), tonumber(playerid)) -- playerid

            elseif (data.current.value == 'fine') then
                TriggerServerEvent("lawmen:FinePlayer", tonumber(playerid), tonumber(fineamount))
            end
        end,
        function(data, menu)
            menu.close()
        end)
end

local OpenChoreTypeMenu = function() -- Set chore menu logic
    MenuData.CloseAll()
    local elements = {
        { label = _U('choretype'), value = 'cont' },
    }
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U('servicemenu'),
            align    = 'top-left',
            elements = elements,
            lastmenu = "OpenPoliceMenu"
        },
        function(data, menu)
            if data.current == "backup" then
                _G[data.trigger]()

            elseif data.current.label then
                chore = data.current.label
                menu.close()
                OpenCommunityMenu()
            end
        end,
        function(data, menu)
            menu.close()
        end)
end

function OpenCommunityMenu() -- Community service menu logic
    MenuData.CloseAll()
    local elements = {
        { label = _U('playerid') .. "<span style='margin-left:10px; color: Red;'>" .. playerid .. '</span>', value = 'id' },
        { label = _U('choosechore') .. chore, value = 'chore' },
        { label = _U('amountofchores') .. "<span style='margin-left:10px; color: Red;'>" .. Choreamount .. '</span>',
            value = 'amount' },
        { label = _U('giveservice'), value = 'service' },
    }
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U('servicemenu'),
            align    = 'top-left',
            elements = elements,
            lastmenu = "OpenPoliceMenu"
        },
        function(data, menu)
            if data.current == "backup" then
                _G[data.trigger]()
            elseif (data.current.value == 'id') then
                TriggerEvent("vorpinputs:advancedInput", json.encode(PlayerIDInput), function(result)
                    local amount = result
                    if result ~= "" and result then -- make sure its not empty or nil
                        playerid = amount
                        menu.close()
                        OpenCommunityMenu()
                    else
                        print("it's empty?") --notify
                    end
                end)
            elseif (data.current.value == 'amount') then
                TriggerEvent("vorpinputs:advancedInput", json.encode(FineAmount), function(result)
                    local amount = result
                    if result ~= "" and result then -- make sure its not empty or nil
                        Choreamount = amount
                        menu.close()
                        OpenCommunityMenu()
                    else
                        print("it's empty?") --notify
                    end

                end)
            elseif (data.current.value == 'chore') then
                OpenChoreTypeMenu()
            elseif (data.current.value == 'service') then
                TriggerServerEvent("lawmen:CommunityService", tonumber(playerid), chore, tonumber(Choreamount))
            end
        end,
        function(data, menu)
            menu.close()
        end)
end

local CloseMenu = function()
    Inmenu = false
    MenuData.CloseAll()
end

local WeaponMenu = function() -- Choosing Jail menu logic
    MenuData.CloseAll()
    local elements = {
        { label = Config.WeaponsandAmmo.RevolverName1, value = "revolver1" },
        { label = Config.WeaponsandAmmo.RevolverName2, value = "revolver2" },
        { label = Config.WeaponsandAmmo.RifleName, value = "rifle" },
        { label = Config.WeaponsandAmmo.KnifeName, value = "knife" },
        { label = Config.WeaponsandAmmo.ShotgunName, value = "shotgun" },
        { label = Config.WeaponsandAmmo.LassoName, value = "lasso" },
        { label = Config.WeaponsandAmmo.RepeaterName, value = 'repeater' },


    }
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U('grabweapons'),
            align    = 'top-left',
            elements = elements,
            lastmenu = "CabinetMenu"
        },
        function(data, menu)
            if data.current == "backup" then
                _G[data.trigger]()
            elseif data.current.value == "revolver1" then
                TriggerServerEvent("lawmen:guncabinet", Config.WeaponsandAmmo.RevolverSpawnName1)
                CloseMenu()
            elseif data.current.value == "knife" then
                TriggerServerEvent("lawmen:guncabinet", Config.WeaponsandAmmo.KnifeSpawnName)
                CloseMenu()
            elseif data.current.value == "lasso" then
                TriggerServerEvent("lawmen:guncabinet", Config.WeaponsandAmmo.LassoSpawnName)
                CloseMenu()
            elseif data.current.value == "revolver2" then
                TriggerServerEvent("lawmen:guncabinet", Config.WeaponsandAmmo.RevolverSpawnName2)
                CloseMenu()
            elseif data.current.value == "shotgun" then
                TriggerServerEvent("lawmen:guncabinet", Config.WeaponsandAmmo.ShotgunSpawnName)
                CloseMenu()
            elseif data.current.value == "rifle" then
                TriggerServerEvent("lawmen:guncabinet", Config.WeaponsandAmmo.RifleSpawnName)
                CloseMenu()
            elseif data.current.value == "repeater" then
                TriggerServerEvent("lawmen:guncabinet", Config.WeaponsandAmmo.RepeaterSpawnName)
                CloseMenu()
            end
        end,
        function(data, menu)
            CloseMenu()
        end)
end

local AmmoMenu = function() -- Choosing Jail menu logic
    MenuData.CloseAll()
    local elements = {
        { label = Config.WeaponsandAmmo.RevolverAmmoType, value = "ammo1", desc = "Grab your ammo" },
        { label = Config.WeaponsandAmmo.RifleAmmoType, value = "ammo2", desc = "Grab your ammo" },
        { label = Config.WeaponsandAmmo.ShotgunAmmoType, value = "ammo3", desc = "Grab your ammo" },
        { label = Config.WeaponsandAmmo.RepeaterAmmoType, value = "ammo4", desc = "Grab your ammo" },
    }
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U('grabammo'),
            align    = 'top-left',
            elements = elements,
            lastmenu = "CabinetMenu"
        },
        function(data, menu)
            if data.current == "backup" then
                _G[data.trigger]()
            elseif data.current.value == "ammo1" then
                local ammotype = Config.WeaponsandAmmo.RevolverAmmoType
                TriggerServerEvent("lawmen:addammo", ammotype)
                Inmenu = false
                menu.close()
            elseif data.current.value == "ammo2" then
                local ammotype = Config.WeaponsandAmmo.RifleAmmoType
                TriggerServerEvent("lawmen:addammo", ammotype)
                Inmenu = false
                menu.close()
            elseif data.current.value == "ammo3" then
                local ammotype = Config.WeaponsandAmmo.ShotgunAmmoType
                TriggerServerEvent("lawmen:addammo", ammotype)
                Inmenu = false
                menu.close()
            elseif data.current.value == "ammo4" then
                local ammotype = Config.WeaponsandAmmo.RepeaterAmmoType
                TriggerServerEvent("lawmen:addammo", ammotype)
                Inmenu = false
                menu.close()
            end
        end,
        function(data, menu)
            Inmenu = false
            menu.close()
        end)
end

function CabinetMenu() -- Set chore menu logic
    MenuData.CloseAll()
    local elements = {
        { label = _U('grabammo'), value = 'ammo' },
        { label = _U('grabweapons'), value = 'wep' },

    }
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U('Cabinet'),
            align    = 'top-left',
            elements = elements,
        },
        function(data, menu)
            if data.current == "backup" then
                _G[data.trigger]()

            elseif data.current.value == "ammo" then
                AmmoMenu()
            elseif data.current.value == "wep" then
                WeaponMenu()
            end
        end,
        function(data, menu)
            menu.close()
            Inmenu = false
        end)
end

function OpenIDMenu() -- Set chore menu logic
    MenuData.CloseAll()
    local elements = {
        { label = _U('citizenid'), value = 'getid' },
    }
    if Config.CheckHorse then
        table.insert(elements, { label = _U('horseowner'), value = 'getowner', desc = _U('horseownerdesc') })
    end
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U('idmenu'),
            align    = 'bottom-left',
            elements = elements,
            lastmenu = "OpenPoliceMenu"
        },
        function(data, menu)
            if data.current == "backup" then
                _G[data.trigger]()

            elseif data.current.value == "getid" then
                local closestPlayer, closestDistance = GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('lawmen:GetID', GetPlayerServerId(closestPlayer))
                end
            elseif data.current.value == "getowner" then
                local closestPlayer, closestDistance = GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    local mount = GetMount(PlayerPedId())
                    TriggerServerEvent('lawmen:getVehicleInfo', GetPlayerServerId(closestPlayer), GetEntityModel(mount))
                else
                    local mount = GetMount(PlayerPedId())
                    local id = GetPlayerServerId(GetPlayerIndex())
                    TriggerServerEvent('lawmen:getVehicleInfo', id, GetEntityModel(mount))
                end
            end
        end,
        function(data, menu)
            CloseMenu()
        end)
end

function SearchMenu(takenmoney) -- Set chore menu logic
    MenuData.CloseAll()
    Inmenu = true
    local elements = {
        { label = _U('playermoney') .. takenmoney, value = 'Money' },
        { label = _U('checkitems'), value = 'Items' },

    }
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = "Chore Menu",
            align    = 'top-left',
            elements = elements,
            lastmenu = "OpenPoliceMenu"
        },
        function(data, menu)
            if data.current == "backup" then
                _G[data.trigger]()

            elseif data.current.value == "Items" then
                TriggerEvent('lawmen:StartSearch')

            end
        end,
        function(data, menu)
            menu.close()
            Inmenu = false
        end)
end

RegisterNetEvent("lawmen:breakout") -- Event for breaking out
AddEventHandler("lawmen:breakout", function()
    local coords = GetEntityCoords(PlayerPedId())
    local local_player = PlayerId()
    TriggerServerEvent('lawmen:jailbreak')
    TriggerServerEvent('lawmen:policenotify', coords)
    VORPcore.NotifyBottomRight(_U('jailbreak'), 4000)
    Jailed = false
    Jail_time = 0
    SetPlayerInvincible(local_player, false)
end)

RegisterNetEvent("vorp:SelectedCharacter") -- Event for checking jail and job on character select
AddEventHandler("vorp:SelectedCharacter", function(charid)

    TriggerServerEvent("lawmen:check_jail")
    Wait(200)
    TriggerServerEvent("lawmen:gooffdutysv")
end)

RegisterNetEvent("lawmen:onduty")
AddEventHandler("lawmen:onduty", function(duty)
    if not duty then
        PoliceOnDuty = false
        if Config.synsociety then
            TriggerServerEvent('lawmen:synsociety', false)
            ExecuteCommand('refreshjob')
        end
    else
        PoliceOnDuty = true
        if Config.synsociety then
            TriggerServerEvent('lawmen:synsociety', true)
            ExecuteCommand('refreshjob')
        end
    end
end)

RegisterNetEvent("lawmen:goonduty") -- Go on duty event
AddEventHandler("lawmen:goonduty", function()
    if PoliceOnDuty then
        VORPcore.NotifyBottomRight(_U('onduty'), 4000)
    else
        TriggerServerEvent('lawmen:goondutysv', GetPlayers())
    end
end)

RegisterCommand(Config.ondutycommand, function() -- on duty command
    TriggerEvent('lawmen:goonduty')
end)

RegisterNetEvent("lawmen:gooffduty") -- Go off duty event
AddEventHandler("lawmen:gooffduty", function()
    TriggerServerEvent("lawmen:gooffdutysv")
end)

RegisterCommand(Config.offdutycommand, function() -- Go off duty command
    TriggerEvent('lawmen:gooffduty')
end)

RegisterCommand(Config.openpolicemenu, function()
    local isDead = IsEntityDead(PlayerPedId())

    if PoliceOnDuty and not isDead then
        OpenPoliceMenu()
    else
        return
    end
end)

-- Disable player actions when handcuffed
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsHandcuffed then
            DisableControlAction(0, 0xB2F377E8, true) -- Attack
            DisableControlAction(0, 0xC1989F95, true) -- Attack 2
            DisableControlAction(0, 0x07CE1E61, true) -- Melee Attack 1
            DisableControlAction(0, 0xF84FA74F, true) -- MOUSE2
            DisableControlAction(0, 0xCEE12B50, true) -- MOUSE3
            DisableControlAction(0, 0x8FFC75D6, true) -- Shift
            DisableControlAction(0, 0xD9D0E1C0, true) -- SPACE
            DisableControlAction(0, 0xF3830D8E, true) -- J
            DisableControlAction(0, 0x80F28E95, true) -- L
            DisableControlAction(0, 0xDB096B85, true) -- CTRL
            DisableControlAction(0, 0xE30CD707, true) -- R
        elseif IsHandcuffed and IsPedDeadOrDying(PlayerPedId()) then
            ClearPedSecondaryTask(PlayerPedId())
            SetEnableHandcuffs(PlayerPedId(), false)
            DisablePlayerFiring(PlayerPedId(), false)
            SetPedCanPlayGestureAnims(PlayerPedId(), true)
            Citizen.Wait(500)
        end
    end
end)

function GetPlayers() -- Get players function
    local players = {}
    for i = 0, 256 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, GetPlayerServerId(i))
        end
    end
    return players
end

Citizen.CreateThread(function() -- Logic for dragging person cuffed
    local wasDragged
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        if IsHandcuffed and dragStatus.isDragged then
            local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))
            if DoesEntityExist(targetPed) and IsPedOnFoot(targetPed) and not IsPedDeadOrDying(targetPed, true) then
                if not wasDragged then
                    AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false
                        , false, 2, true)
                    wasDragged = true
                else
                    Citizen.Wait(1000)
                end
            else
                wasDragged = false
                dragStatus.isDragged = false
                DetachEntity(playerPed, true, false)
            end
        elseif wasDragged then
            wasDragged = false
            DetachEntity(playerPed, true, false)
        else
            Citizen.Wait(500)
        end
    end
end)

RegisterNetEvent('lawmen:drag') -- Event to register dragging
AddEventHandler('lawmen:drag', function(copId)
    if IsHandcuffed then
        dragStatus.isDragged = not dragStatus.isDragged
        dragStatus.CopId = copId
    end
end)

RegisterNetEvent("lawmen:JailPlayer") -- Jailing player event
AddEventHandler("lawmen:JailPlayer", function(time, Location)
    local ped = PlayerPedId()
    local time_minutes = math.floor(time / 60)
    JailID = Location
    print(Location)
    Serviced = false
    if not Jailed then
        if Autotele then
            DoScreenFadeOut(500)
            Citizen.Wait(600)
            if JailID == "sk" then
                SetEntityCoords(ped, Config.Jails.sisika.entrance.x, Config.Jails.sisika.entrance.y,
                    Config.Jails.sisika.entrance.z)
            elseif JailID == "bw" then
                SetEntityCoords(ped, Config.Jails.blackwater.entrance.x, Config.Jails.blackwater.entrance.y,
                    Config.Jails.blackwater.entrance.z)
            elseif JailID == "st" then
                SetEntityCoords(ped, Config.Jails.strawberry.entrance.x, Config.Jails.strawberry.entrance.y,
                    Config.Jails.strawberry.entrance.z)
            elseif JailID == "val" then
                SetEntityCoords(ped, Config.Jails.valentine.entrance.x, Config.Jails.valentine.entrance.y,
                    Config.Jails.valentine.entrance.z)
            elseif JailID == "ar" then
                SetEntityCoords(ped, Config.Jails.armadillo.entrance.x, Config.Jails.armadillo.entrance.y,
                    Config.Jails.armadillo.entrance.z)
            elseif JailID == "tu" then
                SetEntityCoords(ped, Config.Jails.tumbleweed.entrance.x, Config.Jails.tumbleweed.entrance.y,
                    Config.Jails.tumbleweed.entrance.z)
            elseif JailID == "rh" then
                SetEntityCoords(ped, Config.Jails.rhodes.entrance.x, Config.Jails.rhodes.entrance.y,
                    Config.Jails.rhodes.entrance.z)
            elseif JailID == "sd" then
                SetEntityCoords(ped, Config.Jails.stdenis.entrance.x, Config.Jails.stdenis.entrance.y,
                    Config.Jails.stdenis.entrance.z)
            elseif JailID == "an" then
                SetEntityCoords(ped, Config.Jails.annesburg.entrance.x, Config.Jails.annesburg.entrance.y,
                    Config.Jails.annesburg.entrance.z)
            end
            FreezeEntityPosition(ped, true)
            Jail_time = time
            Jailed = true
            RemoveAllPedWeapons(ped, true)
            DoScreenFadeIn(500)
            Citizen.Wait(600)
            VORPcore.NotifyBottomRight(_U('imprisoned') .. time_minutes .. _U('minutes'), 4000)
            FreezeEntityPosition(ped, false)
            TriggerEvent("lawmen:wear_prison", ped)
            Wait(500)
        else
            Jail_time = time
            Jailed = true
            Citizen.Wait(600)
            RemoveAllPedWeapons(ped, true)
            VORPcore.NotifyBottomRight(_U('imprisoned') .. time_minutes .. _U('minutes'), 4000)
            TriggerEvent("lawmen:wear_prison", ped)
        end
    end

end)

RegisterNetEvent("lawmen:wear_prison") -- Wear prison outfit event
AddEventHandler("lawmen:wear_prison", function()
    local ped = PlayerPedId()
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0x9925C067, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0x485EE834, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0x18729F39, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0x3107499B, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0x3C1A74CD, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0x3F1F01E5, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0x3F7F3587, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0x49C89D9B, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0x4A73515C, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0x514ADCEA, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0x5FC29285, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0x79D7DF96, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0x7A96FACA, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0x877A2CF7, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0x9B2C8B89, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0xA6D134C6, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0xE06D30CE, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0x662AC34, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0xAF14310B, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0x72E6EF74, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0xEABE0032, true, true, true)
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0x2026C46D, true, true, true)

    if IsPedMale(ped) then
        Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, 0x5BA76CCF, true, true, true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, 0x216612F0, true, true, true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, 0x1CCEE58D, true, true, true)
    else
        Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, 0x6AB27695, true, true, true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, 0x75BC0CF5, true, true, true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, 0x14683CDF, true, true, true)
    end
    RemoveAllPedWeapons(ped, true, true)
end)

RegisterNetEvent("lawmen:UnjailPlayer") -- Unjail player event
AddEventHandler("lawmen:UnjailPlayer", function(jaillocation)
    local local_ped = PlayerPedId()
    local local_player = PlayerId()
    JailID = jaillocation
    ExecuteCommand('rc')
    VORPcore.NotifyBottomRight(_U('released'), 4000)
    Jailed = false
    Jail_time = 0
    if Autotele then
            Wait(1)
        if JailID == "sk" then
            SetEntityCoords(local_ped, Config.Jails.sisika.exit.x, Config.Jails.sisika.exit.y, Config.Jails.sisika.exit.z)
        elseif JailID == "bw" then
            SetEntityCoords(local_ped, Config.Jails.blackwater.exit.x, Config.Jails.blackwater.exit.y,
                Config.Jails.blackwater.exit.z)
        elseif JailID == "st" then
            SetEntityCoords(local_ped, Config.Jails.strawberry.exit.x, Config.Jails.strawberry.exit.y,
                Config.Jails.strawberry.exit.z)
        elseif JailID == "val" then
            SetEntityCoords(local_ped, Config.Jails.valentine.exit.x, Config.Jails.valentine.exit.y,
                Config.Jails.valentine.exit.z)
        elseif JailID == "ar" then
            SetEntityCoords(local_ped, Config.Jails.armadillo.exit.x, Config.Jails.armadillo.exit.y,
                Config.Jails.armadillo.exit.z)
        elseif JailID == "tu" then
            SetEntityCoords(local_ped, Config.Jails.tumbleweed.exit.x, Config.Jails.tumbleweed.exit.y,
                Config.Jails.tumbleweed.exit.z)
        elseif JailID == "rh" then
            SetEntityCoords(local_ped, Config.Jails.rhodes.exit.x, Config.Jails.rhodes.exit.y, Config.Jails.rhodes.exit.z)
        elseif JailID == "sd" then
            SetEntityCoords(local_ped, Config.Jails.stdenis.exit.x, Config.Jails.stdenis.exit.y,
                Config.Jails.stdenis.exit.z)
        elseif JailID == "an" then
            SetEntityCoords(local_ped, Config.Jails.annesburg.exit.x, Config.Jails.annesburg.exit.y,
                Config.Jails.annesburg.exit.z)
        end
        SetPlayerInvincible(local_player, false)
    else
        SetPlayerInvincible(local_player, false)
    end
end)

Citizen.CreateThread(function() --Display timer when in jail logic
    while true do
        Wait(0)
        if Jailed then
            DrawTxt(_U('imprisoned') .. Jail_time .. _U('jailseconds'), 0.38, 0.95, 0.4, 0.4, true, 255, 0, 0, 255, false)
        end

    end
end)

RegisterNetEvent("lawmen:cuffs") --Cuffing player event
AddEventHandler("lawmen:cuffs", function()
    HandcuffPlayer()
end)

RegisterNetEvent("lawmen:lockpick") -- Lockpicking handcuffs event
AddEventHandler("lawmen:lockpick", function()
    local closestPlayer, closestDistance = GetClosestPlayer()
    local isDead = IsEntityDead(PlayerPedId())

    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        local chance = math.random(1, 100)
        print("chance", chance)
        if not isDead then
            if chance < 85 then
                local ped = PlayerPedId()
                local anim = "mini_games@story@mud5@cracksafe_look_at_dial@med_r@ped"
                local idle = "base_idle"
                local lr = "left_to_right"
                local rl = "right_to_left"
                RequestAnimDict(anim)
                while not HasAnimDictLoaded(anim) do
                    Citizen.Wait(50)
                end

                TaskPlayAnim(PlayerPedId(), anim, idle, 8.0, -8.0, -1, 32, 0, false, false, false)
                Citizen.Wait(1250)
                TaskPlayAnim(PlayerPedId(), anim, lr, 8.0, -8.0, -1, 32, 0, false, false, false)
                Citizen.Wait(325)
                TaskPlayAnim(PlayerPedId(), anim, idle, 8.0, -8.0, -1, 32, 0, false, false, false)
                Citizen.Wait(1250)
                TaskPlayAnim(PlayerPedId(), anim, rl, 8.0, -8.0, -1, 32, 0, false, false, false)
                Citizen.Wait(325)
                repeat
                    TriggerEvent("lawmen:lockpick")
                until (chance)
            end
            if chance >= 85 then
                local breakChance = math.random(1, 10)
                print("breakChance", breakChance)
                if breakChance < 3 then
                    TriggerServerEvent("lawmen:lockpick:break")
                else
                    local ped = PlayerPedId()
                    local anim = "mini_games@story@mud5@cracksafe_look_at_dial@small_r@ped"
                    local open = "open"
                    RequestAnimDict(anim)
                    while not HasAnimDictLoaded(anim) do
                        Citizen.Wait(50)
                    end
                    TaskPlayAnim(PlayerPedId(), anim, open, 8.0, -8.0, -1, 32, 0, false, false, false)
                    Citizen.Wait(1250)
                    TriggerServerEvent('lawmen:lockpicksv', GetPlayerServerId(closestPlayer))
                end
            end
        end
    else
        VORPcore.NotifyBottomRight(_U('notcloseenough'), 4000)
        return
    end

end)

function DrawTxt(text, x, y, w, h, enableShadow, col1, col2, col3, a, centre) -- Draw text function
    local str = CreateVarString(10, "LITERAL_STRING", text)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
    SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    Citizen.InvokeNative(0xADA9255D, 1);
    DisplayText(str, x, y)
end

function CreateVarString(p0, p1, variadic) -- Create variable string function
    return Citizen.InvokeNative(0xFA925AC00EB830B9, p0, p1, variadic, Citizen.ResultAsLong())
end

Citizen.CreateThread(function() -- Added time if over max distance/count down until unJailed logic
    while true do
        if Jailed then
            local ped = PlayerPedId()
            local local_player = PlayerId()
            if not GetPlayerInvincible(local_player) then
                SetPlayerInvincible(local_player, true)
            end
            if Jail_time < 1 then
                local player_server_id = GetPlayerServerId(PlayerId())
                TriggerServerEvent("lawmen:finishedjail", player_server_id, jaillocation)
            else
                Jail_time = Jail_time - 1

            end
            Citizen.Wait(1000)
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function() -- Added time if over max distance/count down until unJailed logic
    while true do
        Wait(0)
        if Jailed then
            Wait(Config.JailSettings.UpdateJailTime)
            TriggerServerEvent("lawmen:taketime")
        end
    end
end)

function HandcuffPlayer() --Handcuff player function
    MenuData.CloseAll()
    Inmenu = false
    local closestPlayer, closestDistance = GetClosestPlayer()
    local targetplayerid = GetPlayerServerId(closestPlayer)
    local isDead = IsEntityDead(PlayerPedId())

    if closestDistance <= 3.0 then
        if not isDead then
            TriggerServerEvent('lawmen:handcuff', targetplayerid)
            if not IsSearching then
                IsSearching = true
                CuffPlayer(closestPlayer)
            elseif IsSearching then
                IsSearching = false
            end
        end
    else
        VORPcore.NotifyBottomRight(_U('notcloseenough'), 4000)
    end
end

function GetClosestPlayer()
    local players, closestDistance, closestPlayer = GetActivePlayers(), -1, -1
    local playerPed, playerId = PlayerPedId(), PlayerId()
    local coords, usePlayerPed = coords, false

    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        usePlayerPed = true
        coords = GetEntityCoords(playerPed)
    end

    for i = 1, #players, 1 do
        local tgt = GetPlayerPed(players[i])
        if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then

            local targetCoords = GetEntityCoords(tgt)
            local distance = #(coords - targetCoords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = players[i]
                closestDistance = distance
                playerid = GetPlayerServerId(players[i])
            end
        end
    end
    return closestPlayer, closestDistance
end

RegisterNetEvent('lawmen:handcuff', function()
    local playerPed = PlayerPedId()
    Citizen.CreateThread(function()
        if not IsHandcuffed then
            IsHandcuffed = true
            SetEnableHandcuffs(playerPed, true)
            Citizen.InvokeNative(0x7981037A96E7D174, playerPed) --Cuff Ped Native
            DisablePlayerFiring(playerPed, true)
            SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
            SetPedCanPlayGestureAnims(playerPed, false)
        else
            IsHandcuffed = false
            ClearPedSecondaryTask(playerPed)
            SetEnableHandcuffs(playerPed, false)
            Citizen.InvokeNative(0x67406F2C8F87FC4F, playerPed) --Uncuff Ped Native
            DisablePlayerFiring(playerPed, false)
            SetPedCanPlayGestureAnims(playerPed, true)
        end
    end)
end)

RegisterNetEvent('lawmen:lockpicked') -- Successful lockpick event
AddEventHandler('lawmen:lockpicked', function()
    local playerPed = PlayerPedId()
    ClearPedSecondaryTask(playerPed)
    SetEnableHandcuffs(playerPed, false)
    DisablePlayerFiring(playerPed, false)
    SetPedCanPlayGestureAnims(playerPed, true)
    IsHandcuffed = false
end)

Citizen.CreateThread(function() -- Timer for leaving community service logic, which jails player
    while true do
        Wait(0)
        local gametime = GetGameTimer()
        local seconds = Config.CommunityServiceSettings.communityservicetimer -- max time (seconds) you want to set
        local printtime = seconds
        while Brokedistance do
            Wait(0)
            if printtime > 0 then
                local diftime = GetGameTimer() - gametime
                printtime = math.floor(seconds - (diftime / 1000))
                DrawTxt(_U('youhave') .. printtime .. _U('secondsremaining'), 0.50, 0.95, 0.6, 0.6, true, 255, 255, 255,
                    255, true, 10000)
            else
                Citizen.Wait(1000)
                Brokedistance = false
                Serviced = false
                Autotele = true
                JailID = "sk"
                local player_server_id = GetPlayerServerId(PlayerId())
                TriggerServerEvent('lawmen:JailPlayer', tonumber(player_server_id),
                    tonumber(Config.CommunityServiceSettings.leftserviceamount), JailID)
                TriggerServerEvent('lawmen:Jailedservice', source)
            end
        end
    end
end)

RegisterNetEvent("lawmen:witness", function(coords)
    print(coords)
    VORPcore.NotifyLeft(_U('crimereported'), _U('jailbreakalert'), "generic_textures", "star", 6000)
    local blip = Citizen.InvokeNative(0x45F13B7E0A15C880, -1282792512, coords.x, coords.y, coords.z, 20.0)
    Wait(60000) --Time till notify blips dispears, 1 min
    RemoveBlip(blip)
end)

AddEventHandler('onResourceStop', function(resource) -- on resource restart remove Serviceblips
    if resource == GetCurrentResourceName() then
        RemoveBlip(Serviceblip)
        Choreamount = _U('none')
    end
end)
