----------------------------------------------------------------------------
---------------------------------- BOOSTERS --------------------------------
local god = false
local player = PlayerPedId()
local goldenCores = false
local infiniteammo = false
local NoClipActive = false
local timer

function Boost()
    MenuData.CloseAll()



    local elements = {
        { label = _U("godMode"), value = 'god', desc = _U("godMode_desc") },
        { label = _U("noclipMode"), value = 'noclip',
            desc = "<span>" ..
                _U("move") .. "</span><br><span>" .. _U("speedMode") .. "</span><br>" .. _U("Cammode") .. "" },
        { label = _U("goldenCores"), value = 'goldcores', desc = _U("goldCores_desc") },
        { label = _U("infiniteammo"), value = 'infiniteammo', desc = _U("infammo_desc") },
        { label = _U("spawnwagon"), value = 'spawnwagon', desc = _U("spawnwagon_desc") },
        { label = _U("spawnhorse"), value = 'spawnhorse', desc = _U("spawnhorse_desc") },
        { label = _U("selfheal"), value = 'selfheal', desc = _U("selfheal_desc") },
        { label = _U("selfrevive"), value = 'selfrevive', desc = _U("selfrevive_desc") },
        --{ label = "players bip map", value = 'playerblip', desc = "show players blip on the map" }, todo
        --{ label = "players id", value = 'showid', desc = "show players id over head", }, todo
    }

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U("MenuTitle"),
            subtext  = _U("Boosters"),
            align    = 'top-left',
            elements = elements,
            lastmenu = 'OpenMenu'
        },

        function(data)
            if data.current == "backup" then
                _G[data.trigger]()

            end
            if data.current.value == "god" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.Godmode")
                Wait(100)
                if AdminAllowed then
                    if not god then
                        god = true
                        TriggerEvent('vorp:TipRight', _U("switchedon"), 3000)
                        SetEntityCanBeDamaged(player, false)
                        SetEntityInvincible(player, true)
                        SetPedConfigFlag(player, 2, true) -- no critical hits
                        SetPedCanRagdoll(player, false)
                        SetPedCanBeTargetted(player, false)
                        Citizen.InvokeNative(0x5240864E847C691C, player, false) --set ped can be incapacitaded
                        SetPlayerInvincible(player, true)
                        Citizen.InvokeNative(0xFD6943B6DF77E449, player, false) -- set ped can be lassoed
                    else
                        god = false
                        TriggerEvent('vorp:TipRight', _U("switchedoff"), 3000)
                        SetEntityCanBeDamaged(player, true)
                        SetEntityInvincible(player, false)
                        SetPedConfigFlag(player, 2, false)
                        SetPedCanRagdoll(player, true)
                        SetPedCanBeTargetted(player, true)
                        Citizen.InvokeNative(0x5240864E847C691C, player, true)
                        SetPlayerInvincible(PlayerId(), false)
                        Citizen.InvokeNative(0xFD6943B6DF77E449, player, true)
                    end
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "goldcores" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.Golden")
                Wait(100)
                if AdminAllowed then
                    if not goldenCores then

                        goldenCores = true
                        TriggerEvent('vorp:TipRight', _U("switchedon"), 3000)
                        -- inner cores
                        Citizen.InvokeNative(0xC6258F41D86676E0, player, 0, 100)
                        Citizen.InvokeNative(0xC6258F41D86676E0, player, 1, 100)
                        Citizen.InvokeNative(0xC6258F41D86676E0, player, 2, 100)

                        --outter cores
                        Citizen.InvokeNative(0x4AF5A4C7B9157D14, player, 0, 5000.0)
                        Citizen.InvokeNative(0x4AF5A4C7B9157D14, player, 1, 5000.0)
                        Citizen.InvokeNative(0x4AF5A4C7B9157D14, player, 2, 5000.0)

                        Citizen.InvokeNative(0xF6A7C08DF2E28B28, player, 1, 5000.0)
                        Citizen.InvokeNative(0xF6A7C08DF2E28B28, player, 2, 5000.0)
                        Citizen.InvokeNative(0xF6A7C08DF2E28B28, player, 0, 5000.0)
                    else
                        goldenCores = false
                        TriggerEvent('vorp:TipRight', _U("switchedoff"), 3000)
                        --inner cores
                        Citizen.InvokeNative(0xC6258F41D86676E0, player, 0, 100)
                        Citizen.InvokeNative(0xC6258F41D86676E0, player, 1, 100)
                        Citizen.InvokeNative(0xC6258F41D86676E0, player, 2, 100)

                        --outter cores
                        Citizen.InvokeNative(0x4AF5A4C7B9157D14, player, 0, 0.0)
                        Citizen.InvokeNative(0x4AF5A4C7B9157D14, player, 1, 0.0)
                        Citizen.InvokeNative(0x4AF5A4C7B9157D14, player, 2, 0.0)

                        Citizen.InvokeNative(0xF6A7C08DF2E28B28, player, 1, 0.0)
                        Citizen.InvokeNative(0xF6A7C08DF2E28B28, player, 2, 0.0)
                        Citizen.InvokeNative(0xF6A7C08DF2E28B28, player, 0, 0.0)
                    end
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "noclip" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.Noclip")
                Wait(100)
                if AdminAllowed then
                    if not NoClipActive then
                        NoClipActive = true
                        TriggerEvent('vorp:TipRight', _U("switchedon"), 3000)
                        if Config.FrozenPosition then
                            SetEntityHeading(player, GetEntityHeading(player) + 180)
                        end

                    else
                        NoClipActive = false
                        timer = 5000
                        TriggerEvent('vorp:TipRight', _U("switchedoff"), 3000)
                    end
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "infiniteammo" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.InfiniteAmmo")
                Wait(100)
                if AdminAllowed then
                    local _, weaponHash = GetCurrentPedWeapon(player, false, 0, false)
                    if not infiniteammo then
                        infiniteammo = true
                        local unarmed = -1569615261
                        TriggerEvent("vorp:TipRight", _U("switchedon"), 3000)
                        if weaponHash == unarmed then
                            TriggerEvent("vorp:Tip", _U("noweapon"), 3000)
                        else
                            SetPedInfiniteAmmo(player, true, weaponHash)
                        end
                    else
                        infiniteammo = false
                        TriggerEvent("vorp:TipRight", _U("switchedoff"), 3000)
                        SetPedInfiniteAmmo(player, false, weaponHash)
                    end
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "selfrevive" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.SelfRevive")
                Wait(100)
                if AdminAllowed then
                    TriggerEvent('vorp:resurrectPlayer')
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "selfheal" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.SelfHeal")
                Wait(100)
                if AdminAllowed then
                    TriggerEvent('vorp:heal')
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "spawnhorse" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.SpawHorse")
                Wait(100)
                if AdminAllowed then
                    local myInput = {
                        type = "enableinput", -- dont touch
                        inputType = "input",
                        button = _U("confirm"), -- button name
                        placeholder = _U("inserthashmodel"), --placeholdername
                        style = "block", --- dont touch
                        attributes = {
                            inputHeader = _U("spawnhorse"), -- header
                            type = "text", -- inputype text, number,date.etc if number comment out the pattern
                            pattern = "[A-Za-z0-9_ \\-]{5,60}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                            title = "wrong syntax", -- if input doesnt match show this message
                            style = "border-radius: 10px; backgRound-color: ; border:none;", -- style  the inptup
                        }
                    }
                    MenuData.CloseAll()
                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                        local horse = result
                        local playerCoords = GetEntityCoords(player) + 1
                        if horse ~= "" then
                            RequestModel(horse)
                            while not HasModelLoaded(horse) do
                                Wait(10)
                            end
                            horse = CreatePed(horse, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
                            Citizen.InvokeNative(0x77FF8D35EEC6BBC4, horse, 1, 0)
                            Citizen.InvokeNative(0x028F76B6E78246EB, player, horse, -1, true)
                        else
                            TriggerEvent('vorp:TipRight', _U("advalue"), 3000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end

            elseif data.current.value == "spawnwagon" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.SpawnWagon")
                Wait(100)
                if AdminAllowed then
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
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            end
        end,

        function(menu)
            menu.close()
        end)


end

function DisableControls()
    DisableControlAction(0, 0xB238FE0B, true) --disable controls here
    DisableControlAction(0, 0x3C0A40F2, true) --disable controls here
end

function DrawText(text, x, y, centred)
    SetTextScale(0.35, 0.35)
    SetTextColor(255, 255, 255, 255)
    SetTextCentre(centred)
    SetTextDropshadow(1, 0, 0, 0, 200)
    SetTextFontForCurrentCommand(22)
    DisplayText(CreateVarString(10, "LITERAL_STRING", text), x, y)
end

--CREDITS to the author for the noclip
Citizen.CreateThread(function()

    local index = 1
    local CurrentSpeed = Config.Speeds[index].speed
    local FollowCamMode = true

    while true do
        while NoClipActive do

            if IsPedInAnyVehicle(PlayerPedId(), false) then
                player = GetVehiclePedIsIn(PlayerPedId(), false)
            else
                player = PlayerPedId()
            end

            local yoff = 0.0
            local zoff = 0.0

            DisableControls()

            if IsDisabledControlJustPressed(1, Config.Controls.camMode) then
                timer = 2000
                FollowCamMode = not FollowCamMode
            end


            if IsDisabledControlJustPressed(1, Config.Controls.changeSpeed) then
                timer = 2000
                if index ~= #Config.Speeds then
                    index = index + 1
                    CurrentSpeed = Config.Speeds[index].speed
                else
                    CurrentSpeed = Config.Speeds[1].speed
                    index = 1
                end

            end
            if Config.ShowControls then
                DrawText(string.format('NoClip Speed: %.1f', CurrentSpeed), 0.5, 0.90, true)
            end
            if IsDisabledControlPressed(0, Config.Controls.goForward) then
                if Config.FrozenPosition then
                    yoff = -Config.Offsets.y
                else
                    yoff = Config.Offsets.y
                end
            end

            if IsDisabledControlPressed(0, Config.Controls.goBackward) then
                if Config.FrozenPosition then
                    yoff = Config.Offsets.y
                else
                    yoff = -Config.Offsets.y
                end
            end

            if not FollowCamMode and IsDisabledControlPressed(0, Config.Controls.turnLeft) then
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + Config.Offsets.h)
            end

            if not FollowCamMode and IsDisabledControlPressed(0, Config.Controls.turnRight) then
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - Config.Offsets.h)
            end

            if IsDisabledControlPressed(0, Config.Controls.goUp) then
                zoff = Config.Offsets.z
            end

            if IsDisabledControlPressed(0, Config.Controls.goDown) then
                zoff = -Config.Offsets.z
            end

            local newPos = GetOffsetFromEntityInWorldCoords(player, 0.0, yoff * (CurrentSpeed + 0.3),
                zoff * (CurrentSpeed + 0.3))
            local heading = GetEntityHeading(player)
            SetEntityVelocity(player, 0.0, 0.0, 0.0)
            if Config.FrozenPosition then
                SetEntityRotation(player, 0.0, 0.0, 180.0, 0, false)
            else
                SetEntityRotation(player, 0.0, 0.0, 0.0, 0, false)
            end
            if (FollowCamMode) then
                SetEntityHeading(player, GetGameplayCamRelativeHeading())
            else
                SetEntityHeading(player, heading);
            end
            if Config.FrozenPosition then
                SetEntityCoordsNoOffset(player, newPos.x, newPos.y, newPos.z, not NoClipActive, not NoClipActive,
                    not NoClipActive)
            else
                SetEntityCoordsNoOffset(player, newPos.x, newPos.y, newPos.z, NoClipActive, NoClipActive, NoClipActive)
            end

            SetEntityAlpha(player, 51, 0)
            if (player ~= PlayerPedId()) then
                SetEntityAlpha(PlayerPedId(), 51, 0)
            end

            SetEntityCollision(player, false, false)
            FreezeEntityPosition(player, true)
            SetEntityInvincible(player, true)
            SetEntityVisible(player, false, false)
            SetEveryoneIgnorePlayer(PlayerPedId(), true)
            SetPedCanBeTargetted(player, false)
            Citizen.Wait(0)

            ResetEntityAlpha(player)
            if (player ~= PlayerPedId()) then
                ResetEntityAlpha(PlayerPedId())
            end

            SetEntityCollision(player, true, true)
            FreezeEntityPosition(player, false)
            SetEntityInvincible(player, false)
            SetEntityVisible(player, true, false)
            SetEveryoneIgnorePlayer(PlayerPedId(), false)
            SetPedCanBeTargetted(player, true)
            if Config.ShowControls then
                DrawText('W/A/S/D/Q/Z- Move, LShift  Change speed,  H- Relative mode', 0.5, 0.95, true)
            end
        end
        Citizen.Wait(0)
    end
end)
