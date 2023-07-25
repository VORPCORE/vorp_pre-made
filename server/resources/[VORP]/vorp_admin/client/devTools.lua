---@diagnostic disable: undefined-global
---------------------------------------------------------------------------------------------------
---------------------------------- DEV TOOLS ------------------------------------------------------

local function LoadModel(ped)
    if not IsModelInCdimage(ped) then
        TriggerEvent('vorp:TipRight', "invalid model", 3000)
        return
    end
    local count = 1000
    while not HasModelLoaded(ped) do
        RequestModel(ped)
        if count <= 0 then
            break
        end
        Wait(10)
    end
end
local active = false
function OpenDevTools()
    MenuData.CloseAll()
    local elements = {
        { label = "choose ped/animal",  value = 'pedlist',    desc = "choose from a list to spawn a ped" },
        { label = _U("spawnpedanimal"), value = 'spawnped',   desc = _U("spawnpedanimal_desc") },
        { label = _U("getcoords"),      value = 'getcoords',  desc = _U("getcoords_desc") },
        { label = _U("spawnwagon"),     value = 'spawnwagon', desc = _U("spawnwagon_desc") },
        { label = "choose wagon",       value = 'wagonlist',  desc = _U("spawnwagon_desc") },
        { label = _U("objectmenu"),     value = 'delobject',  desc = "choose from list" },
        { label = "imap viewer",        value = 'imap',       desc = "activate imap viewer" },
        { label = "get scenario hash",  value = 'scenario',   desc = "get scenario hash in f8 console" },

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
                MenuData.CloseAll()
                local myInput = {
                    type = "enableinput",                                                -- dont touch
                    inputType = "input",
                    button = _U("confirm"),                                              -- button name
                    placeholder = _U("insertmodel"),                                     --placeholdername
                    style = "block",                                                     --- dont touch
                    attributes = {
                        inputHeader = "ped model",                                       -- header
                        type = "text",                                                   -- inputype text, number,date.etc if number comment out the pattern
                        pattern = "[A-Za-z0-9_ \\-]{5,60}",                              -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                        title = "wrong syntax",                                          -- if input doesnt match show this message
                        style = "border-radius: 10px; backgRound-color: ; border:none;", -- style  the inptup
                    }
                }

                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                    local ped = result
                    local playerCoords = GetEntityCoords(PlayerPedId())
                    if ped ~= "" then
                        LoadModel(ped)

                        if type(ped) == "string" then
                            ped = joaat(ped)
                        end

                        local npc = CreatePed(ped, playerCoords.x, playerCoords.y, playerCoords.z, 0, true, true, true)
                        while not DoesEntityExist(npc) do
                            Wait(100)
                        end
                        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, npc, 1, 0)
                        Wait(2000)
                        SetModelAsNoLongerNeeded(ped)
                        SetEntityAsNoLongerNeeded(npc)
                    else
                        TriggerEvent('vorp:TipRight', _U("advalue"), 3000)
                    end
                end)
            end

            if data.current.value == "pedlist" then
                SpawnPeds("peds")
            end

            if data.current.value == "wagonlist" then
                SpawnPeds("wagons")
            end

            if data.current.value == "delobject" then
                OpenObjMenu()
            end

            if data.current.value == "getcoords" then
                OpenCoordsMenu()
            end

            if data.current.value == "imap" then
                ExecuteCommand("imapview")
            end

            if data.current.value == "scenario" then
                if not active then
                    active = true
                else
                    active = false
                end

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
                local myInput = {
                    type = "enableinput",                                                -- dont touch
                    inputType = "input",
                    button = _U("confirm"),                                              -- button name
                    placeholder = _U("insertmodel"),                                     --placeholdername
                    style = "block",                                                     --- dont touch
                    attributes = {
                        inputHeader = _U("SpawnWagon"),                                  -- header
                        type = "text",                                                   -- inputype text, number,date.etc if number comment out the pattern
                        pattern = "[A-Za-z0-9_ \\-]{5,60}",                              -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                        title = "wrong syntax",                                          -- if input doesnt match show this message
                        style = "border-radius: 10px; backgRound-color: ; border:none;", -- style  the inptup
                    }
                }

                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                    local wagon = result
                    local player = PlayerPedId()
                    local playerCoords = GetOffsetFromEntityInWorldCoords(player, 0.0, 5.0, 0.0)
                    if wagon ~= "" then
                        LoadModel(wagon)

                        if type(wagon) == "string" then
                            wagon = joaat(wagon)
                        end

                        local Wagon = CreateVehicle(wagon, playerCoords.x, playerCoords.y, playerCoords.z, 0, true, true,
                            true)
                        while not DoesEntityExist(Wagon) do
                            Wait(100)
                        end
                        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, Wagon, 1, 0)
                        SetPedIntoVehicle(player, Wagon, -1)
                        Wait(2000)
                        SetModelAsNoLongerNeeded(wagon)
                        SetEntityAsNoLongerNeeded(Wagon)
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

function SpawnPeds(action)
    MenuData.CloseAll()
    local elements = {}
    if action == "peds" then
        for key, value in pairs(Peds) do
            elements[#elements + 1] = { label = value, value = value, desc = "select to spawn a ped" }
        end
    elseif action == "wagons" then
        for key, value in pairs(Vehicles) do
            elements[#elements + 1] = { label = value, value = value, desc = "select to spawn a vehicle" }
        end
    end

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
            if data.current.value then
                local ped = data.current.value
                local player = PlayerPedId()
                local playerCoords = GetOffsetFromEntityInWorldCoords(player, 0.0, 5.0, 0.0)

                LoadModel(ped)

                if type(ped) == "string" then
                    ped = joaat(ped)
                end
                if action == "peds" then
                    local npc = CreatePed(ped, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
                    Citizen.InvokeNative(0x77FF8D35EEC6BBC4, npc, 1, 0) -- variation
                else
                    local Wagon = CreateVehicle(ped, playerCoords.x, playerCoords.y, playerCoords.z, true, true,
                        true)
                    Citizen.InvokeNative(0x77FF8D35EEC6BBC4, Wagon, 1, 0)
                    SetPedIntoVehicle(player, Wagon, -1)
                end
                Wait(2000)
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
                print("object: " .. model)
                TriggerEvent("vorp:TipRight", _U("closestobject") .. model, 6000)
            elseif data.current.value == "del" then
                -- only client side
                local coords = GetEntityCoords(player)
                local closestObject, distance = GetClosestObject(coords)
                print(closestObject, distance)
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
