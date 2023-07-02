---@diagnostic disable: undefined-global
---------------------------------------------------------------------------------------------------
---------------------------------- DEV TOOLS ------------------------------------------------------

function OpenDevTools()
    MenuData.CloseAll()
    local elements = {
        { label = _U("spawnpedanimal"), value = 'spawnped',   desc = _U("spawnpedanimal_desc") },
        { label = _U("getcoords"),      value = 'getcoords',  desc = _U("getcoords_desc") },
        { label = _U("spawnwagon"),     value = 'spawnwagon', desc = _U("spawnwagon_desc") },
        { label = _U("objectmenu"),     value = 'delobject',  desc = _U("object_desc") },

    }

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U("MenuTitle"),
            subtext  = _U("devtoolssubmenu"),
            align    = 'top-left',
            elements = elements,
            lastmenu = 'OpenMenu'
        },
        function(data, menu)
            if data.current == "backup" then
                _G[data.trigger]()
            end
            if data.current.value == "spawnped" then
                local myInput = Inputs("input", _U("confirm"), _U("insertpedhash"), _U("spawnentity"), "text",
                    "wrong syntax", "[A-Za-z0-9 \\_\\-]{5,60}")
                menu.close()
                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                    local ped = result
                    local player = PlayerPedId()
                    local playerCoords = GetEntityCoords(player)

                    if ped ~= "" then
                        RequestModel(ped)
                        while not HasModelLoaded(ped) do
                            Wait(10)
                        end

                        ped = CreatePed(ped, playerCoords.x, playerCoords.y, playerCoords.z, true, false, true)
                        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, ped, 1, 0)
                        Wait(2000)
                    else
                        TriggerEvent('vorp:TipRight', _U("advalue"), 3000)
                    end
                end)
            elseif data.current.value == "delobject" then
                OpenObjMenu()
            elseif data.current.value == "getcoords" then
                OpenCoordsMenu()
            elseif data.current.value == "spawnwagon" then
                local myInput = Inputs("input", _U("confirm"), _U("insertmodel"), _U("spawnwagon"), "text",
                    "wrong syntax", "[A-Za-z0-9 \\_\\-]{5,60}")
                menu.close()
                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                    local wagon = result
                    local playerCoords = GetEntityCoords(player)
                    if wagon ~= "" then
                        RequestModel(wagon)
                        while not HasModelLoaded(wagon) do
                            Wait(10)
                        end
                        wagon = CreateVehicle(wagon, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
                        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, wagon, 1, 0)
                        SetPedIntoVehicle(player, wagon, -1)
                    else
                        TriggerEvent('vorp:TipRight', _U("advalue"), 3000)
                    end
                end)
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
        { label = _U("printmodel"),  value = 'print', desc = _U("printmodel_desc") },
        { label = _U("deletemodel"), value = 'del',   desc = _U("deletemodel_desc") },
    }

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U("MenuTitle"),
            subtext  = _U("objectmenu"),
            align    = 'top-left',
            elements = elements,
            lastmenu = 'Actions', --Go back
        },

        function(data)
            if data.current == "backup" then
                _G[data.trigger]()
            end
            if data.current.value == "print" then
                local coords = GetEntityCoords(player)
                local closestObject, distance = GetClosestObject(coords)
                local model = GetEntityModel(closestObject)
                TriggerEvent("vorp:TipRight", _U("closestobject") .. model, 6000)
            elseif data.current.value == "del" then
                local coords = GetEntityCoords(player)
                local closestObject, distance = GetClosestObject(coords)
                TriggerEvent("vorp:TipRight", _U("closestobject") .. closestObject, 4000)
                DeleteObject(closestObject)
            elseif data.current.value == "getcoords" then
                OpenCoordsMenu()
            end
        end,

        function(menu)
            menu.close()
        end)
end
