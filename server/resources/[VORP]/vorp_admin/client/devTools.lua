---@diagnostic disable: undefined-global

local T = Translation.Langs[Config.Lang]
local active = false
---------------------------------------------------------------------------------------------------
---------------------------------- DEV TOOLS ------------------------------------------------------

local function LoadModel(ped)
    if not IsModelInCdimage(ped) then
        TriggerEvent('vorp:TipRight', "invalid model", 3000)
        return
    end

    local count = 1000
    if not HasModelLoaded(ped) then
        RequestModel(ped, false)
        repeat
            Wait(0)
            count = count - 1
        until HasModelLoaded(ped) or count <= 0
    end
end



function OpenDevTools()
    MenuData.CloseAll()
    local elements = {
        { label = T.Menus.MainDevToolsOptions.spawnPedWithList,    value = 'pedlist',    desc = T.Menus.MainDevToolsOptions.spawnPedWithList_desc },
        { label = T.Menus.MainDevToolsOptions.spawnPedWithInput,   value = 'spawnped',   desc = T.Menus.MainDevToolsOptions.spawnPedWithInput_desc },
        { label = T.Menus.MainDevToolsOptions.coordsMenu,          value = 'getcoords',  desc = T.Menus.MainDevToolsOptions.coordsMenu_desc },
        { label = T.Menus.MainDevToolsOptions.spawnWagonWithInput, value = 'spawnwagon', desc = T.Menus.MainDevToolsOptions.spawnWagonWithInput_desc },
        { label = T.Menus.MainDevToolsOptions.spawnWagonWithList,  value = 'wagonlist',  desc = T.Menus.MainDevToolsOptions.spawnWagonWithList_desc },
        { label = T.Menus.MainDevToolsOptions.objectMenu,          value = 'delobject',  desc = T.Menus.MainDevToolsOptions.objectMenu_desc },
        { label = T.Menus.MainDevToolsOptions.imapViwer,           value = 'imap',       desc = T.Menus.MainDevToolsOptions.imapViwer_desc },
        { label = T.Menus.MainDevToolsOptions.scenarioHashViwer,   value = 'scenario',   desc = T.Menus.MainDevToolsOptions.scenarioHashViwer_desc },
    }
    MenuData.Open('default', GetCurrentResourceName(), 'OpenDevTools',
        {
            title    = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext  = T.Menus.DefaultsMenusTitle.menuSubTitleDevTools,
            align    = 'top-left',
            elements = elements,
            lastmenu = 'OpenMenu'
        },
        function(data, menu)
            if data.current == "backup" then
                return _G[data.trigger]()
            end

            if data.current.value == "spawnped" then
                MenuData.CloseAll()
                local myInput = Inputs("input", T.Menus.DefaultsInputs.confirm,
                    T.Menus.MainDevToolsOptions.SpawnPedInput.placeholder,
                    T.Menus.MainDevToolsOptions.SpawnPedInput.title, "text",
                    T.Menus.MainDevToolsOptions.SpawnPedInput.errorMsg, "[A-Za-z0-9_ \\-]{5,60}")
                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                    local ped = tostring(result)
                    local playerCoords = GetEntityCoords(PlayerPedId())
                    if ped ~= "" then
                        LoadModel(ped)
                        local npc = CreatePed(joaat(ped), playerCoords.x, playerCoords.y, playerCoords.z, 0.0, true, true,
                            true)
                        repeat Wait(0) until DoesEntityExist(npc)
                        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, npc, 1, 0)
                        SetModelAsNoLongerNeeded(ped)
                        SetEntityAsNoLongerNeeded(npc)
                    else
                        TriggerEvent('vorp:TipRight', T.Notify.empty, 3000)
                    end
                end)
                return
            end

            if data.current.value == "pedlist" then
                return SpawnPeds("peds")
            end

            if data.current.value == "wagonlist" then
                return SpawnPeds("wagons")
            end

            if data.current.value == "delobject" then
                return OpenObjMenu()
            end

            if data.current.value == "getcoords" then
                return OpenCoordsMenu()
            end

            if data.current.value == "imap" then
                return ExecuteCommand("imapview")
            end

            if data.current.value == "scenario" then
                active = not active
                while active do
                    Wait(1000)
                    local ped = PlayerPedId()
                    local retval = IsPedUsingAnyScenario(ped)
                    if retval then
                        local hash = Citizen.InvokeNative(0x569F1E1237508DEB, ped)
                        print("scenario Hash", hash)
                    end
                end
            end

            if data.current.value == "spawnwagon" then
                MenuData.CloseAll()
                local myInput = Inputs("input", T.Menus.DefaultsInputs.confirm,
                    T.Menus.MainDevToolsOptions.SpawnWagonInput.placeholder,
                    T.Menus.MainDevToolsOptions.SpawnWagonInput.title, "text",
                    T.Menus.MainDevToolsOptions.SpawnWagonInput.errorMsg, "[A-Za-z0-9_ \\-]{5,60}")
                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                    local wagon = tostring(result)
                    local player = PlayerPedId()
                    local playerCoords = GetOffsetFromEntityInWorldCoords(player, 0.0, 5.0, 0.0)
                    if wagon ~= "" then
                        LoadModel(wagon)
                        local Wagon = CreateVehicle(wagon, playerCoords.x, playerCoords.y, playerCoords.z, 0, true, true,
                            true)
                        repeat Wait(0) until DoesEntityExist(Wagon)
                        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, Wagon, 1, 0)
                        SetPedIntoVehicle(player, Wagon, -1)
                        SetModelAsNoLongerNeeded(wagon)
                        SetEntityAsNoLongerNeeded(Wagon)
                    else
                        TriggerEvent('vorp:TipRight', T.Notify.empty, 3000)
                    end
                end)
            end
        end,
        function(data, menu)
            menu.close()
        end)
end

function SpawnPeds(action)
    MenuData.CloseAll()
    local elements = {}
    if action == "peds" then
        for _, value in ipairs(Peds) do
            elements[#elements + 1] = {
                label = value,
                value = value,
                desc = T.Menus.MainDevToolsOptions.spawnPeds_desc
            }
        end
    elseif action == "wagons" then
        for _, value in ipairs(Vehicles) do
            elements[#elements + 1] = {
                label = value,
                value = value,
                desc = T.Menus.MainDevToolsOptions.spawnVehicle_desc
            }
        end
    end

    MenuData.Open('default', GetCurrentResourceName(), 'SpawnPeds',
        {
            title    = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext  = T.Menus.DefaultsMenusTitle.menuSubTitleDevTools,
            align    = 'top-left',
            elements = elements,
            lastmenu = 'OpenMenu'
        },
        function(data, menu)
            if data.current == "backup" then
                return _G[data.trigger]()
            end

            if data.current.value then
                local ped = data.current.value
                local player = PlayerPedId()
                local playerCoords = GetOffsetFromEntityInWorldCoords(player, 0.0, 5.0, 0.0)

                LoadModel(ped)

                if action == "peds" then
                    local npc = CreatePed(joaat(ped), playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
                    repeat Wait(0) until DoesEntityExist(npc)
                    Citizen.InvokeNative(0x77FF8D35EEC6BBC4, npc, true, 0) -- variation
                else
                    local Wagon = CreateVehicle(joaat(ped), playerCoords.x, playerCoords.y, playerCoords.z, 0.0, true,
                        true)
                    repeat Wait(0) until DoesEntityExist(Wagon)
                    Citizen.InvokeNative(0x77FF8D35EEC6BBC4, Wagon, true, 0)
                    SetPedIntoVehicle(player, Wagon, -1)
                end
                SetModelAsNoLongerNeeded(npc)
            end
        end,
        function(data, menu)
            menu.close()
        end)
end

function OpenObjMenu()
    MenuData.CloseAll()
    local player = PlayerPedId()
    local elements = {
        { label = T.Menus.SubDevToolsOptions.printModel,  value = 'print',     desc = T.Menus.SubDevToolsOptions.printModel_desc },
        { label = T.Menus.SubDevToolsOptions.deleteModel, value = 'del',       desc = T.Menus.SubDevToolsOptions.deleteModel_desc },
        { label = T.Menus.SubDevToolsOptions.coordsMenu,  value = 'getcoords', desc = T.Menus.SubDevToolsOptions.coordsMenu_desc }
    }

    MenuData.Open('default', GetCurrentResourceName(), 'OpenObjMenu',
        {
            title    = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext  = T.Menus.DefaultsMenusTitle.menuSubTitleDevTools,
            align    = 'top-left',
            elements = elements,
            lastmenu = 'Actions', --Go back
        },

        function(data)
            if data.current == "backup" then
                return _G[data.trigger]()
            end
            if data.current.value == "print" then
                local coords = GetEntityCoords(player)
                local closestObject, distance = GetClosestObject(coords)
                local model = GetEntityModel(closestObject)
                print(T.Notify.closesObject .. " " .. model)
                TriggerEvent("vorp:TipRight", T.Notify.closesObject .. " " .. model, 6000)
            elseif data.current.value == "del" then
                -- only client side
                local coords = GetEntityCoords(player)
                local closestObject, distance = GetClosestObject(coords)
                print(closestObject, distance)
                TriggerEvent("vorp:TipRight", T.Notify.closesObject .. " " .. closestObject, 4000)
                DeleteObject(closestObject)
            elseif data.current.value == "getcoords" then
                OpenCoordsMenu()
            end
        end,

        function(menu)
            menu.close()
        end)
end
