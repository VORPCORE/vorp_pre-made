---------------------------------------------------------------------------------------------------
---------------------------------- DEV TOOLS ------------------------------------------------------

function OpenDevTools()
    MenuData.CloseAll()
    local elements = {
        { label = _U("spawnpedanimal"), value = 'spawnped', desc = _U("spawnpedanimal_desc") },
        { label = _U("getcoords"), value = 'getcoords', desc = _U("getcoords_desc") },
        { label = _U("spawnwagon"), value = 'spawnwagon', desc = _U("spawnwagon_desc") },
        { label = _U("objectmenu"), value = 'delobject', desc = _U("object_desc") },

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
                local myInput = {
                    type = "enableinput", -- dont touch
                    inputType = "input",
                    button = _U("confirm"), -- button name
                    placeholder = _U("insertpedhash"), --placeholdername
                    style = "block", --- dont touch
                    attributes = {
                        inputHeader = _U("spawnentity"), -- header
                        type = "text", -- inputype text, number,date.etc if number comment out the pattern
                        pattern = "[A-Za-z0-9 \\_\\-]{5,60}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                        title = "wrong syntax", -- if input doesnt match show this message
                        style = "border-radius: 10px; backgRound-color: ; border:none;", -- style  the inptup
                    }
                }
                MenuData.CloseAll()
                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                    local ped = result
                    local player = PlayerPedId()
                    local playerCoords = GetEntityCoords(player)

                    if ped ~= "" then
                        RequestModel(ped)
                        while not HasModelLoaded(ped) do
                            Wait(10)
                        end

                        ped = CreatePed(ped, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
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
                local myInput = {
                    type = "enableinput", -- dont touch
                    inputType = "input",
                    button = _U("confirm"), -- button name
                    placeholder = _U("insertmodel"), --placeholdername
                    style = "block", --- dont touch
                    attributes = {
                        inputHeader = _U("SpawnWagon"), -- header
                        type = "text", -- inputype text, number,date.etc if number comment out the pattern
                        pattern = "[A-Za-z0-9_ \\-]{5,60}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                        title = "wrong syntax", -- if input doesnt match show this message
                        style = "border-radius: 10px; backgRound-color: ; border:none;", -- style  the inptup
                    }
                }
                MenuData.CloseAll()
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
        { label = _U("printmodel"), value = 'print', desc = _U("printmodel_desc") },
        { label = _U("deletemodel"), value = 'del', desc = _U("deletemodel_desc") },
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
