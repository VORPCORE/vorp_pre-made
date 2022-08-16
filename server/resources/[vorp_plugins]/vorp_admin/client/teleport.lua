------------------------------------------------------------------------------------------------------------
---------------------------------------- TELEPORTS ---------------------------------------------------------
local lastLocation = {}

function Teleport()
    MenuData.CloseAll()
    local elements = {
        { label = _U("tpm"), value = 'tpm', desc = _U("teleporttomarker_desc") },
        { label = _U("tptocoords"), value = 'tptocoords', desc = _U("teleporttocoords_desc") },
        { label = _U("tptoplayer"), value = 'tptoplayer', desc = _U("teleportplayer_desc") },
        { label = _U("tpbackadmin"), value = 'admingoback', desc = _U("sendback_desc") },
        { label = _U("bringplayer"), value = 'bringplayer', desc = _U("bringplayer_desc") },
        { label = _U("sendback"), value = 'sendback', desc = _U("sendback_desc") },
    }

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U("MenuTitle"),
            subtext  = _U("teleports"),
            align    = 'top-left',
            elements = elements,
            lastmenu = 'OpenMenu', --Go back
        },

        function(data)
            if data.current == "backup" then
                _G[data.trigger]()
            end
            if data.current.value == "tpm" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.WayPoint")
                Wait(100)
                if AdminAllowed then
                    TriggerEvent('vorp:teleportWayPoint')
                    if Config.TeleportLogs.Tpm then
                        TriggerServerEvent("vorp_admin:logs", Config.TeleportLogs.Tpm
                            , _U("titleteleport"), _U("usedtpm"))
                    end
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "tptocoords" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.TpCoords")
                Wait(100)
                if AdminAllowed then
                    local myInput = {
                        type = "enableinput", -- dont touch
                        inputType = "input",
                        button = _U("confirm"), -- button name
                        placeholder = "X Y Z", --placeholdername
                        style = "block", --- dont touch
                        attributes = {
                            inputHeader = _U("insertcoords"), -- header
                            type = "text", -- inputype text, number,date.etc if number comment out the pattern
                            pattern = "[0-9 \\-\\.]{5,60}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                            title = "must use only numbers - and .", -- if input doesnt match show this message
                            style = "border-radius: 10px; background-color: ; border:none;", -- style  the inptup
                        }
                    }

                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                        local coords = result
                        local admin = PlayerPedId()
                        if coords ~= "" and coords then

                            local finalCoords = {}
                            for i in string.gmatch(coords, "%S+") do
                                finalCoords[#finalCoords + 1] = i
                            end
                            local x, y, z = tonumber(finalCoords[1]), tonumber(finalCoords[2]), tonumber(finalCoords[3])
                            DoScreenFadeOut(2000)
                            Wait(2000)
                            SetEntityCoords(admin, x, y, z)
                            DoScreenFadeIn(3000)
                            if Config.TeleportLogs.Tptocoords then
                                TriggerServerEvent("vorp_admin:logs", Config.TeleportLogs.Tptocoords
                                    , _U("titleteleport"), _U("usedtptocoords"))
                            end
                        else
                            TriggerEvent("vorp:TipRight", _U("empty"), 5000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "tptoplayer" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.TpPlayer")
                Wait(100)
                if AdminAllowed then
                    TriggerEvent("vorpinputs:getInput", _U("confirm"), _U("insertid"), function(result)
                        local TargetID = result
                        if TargetID ~= "" then
                            TriggerServerEvent("vorp_admin:TpToPlayer", TargetID)
                            if Config.TeleportLogs.Tptoplayer then
                                TriggerServerEvent("vorp_admin:logs", Config.TeleportLogs.Tptoplayer
                                    , _U("titleteleport"), _U("usedtptoplayer") .. "\n playerID: " .. TargetID)
                            end
                        else
                            TriggerEvent("vorp:TipRight", _U("empty"), 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "admingoback" then
                if lastLocation then
                    TriggerServerEvent("vorp_admin:sendAdminBack")
                end
            elseif data.current.value == "bringplayer" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.BringPlayer")
                Wait(100)
                if AdminAllowed then
                    TriggerEvent("vorpinputs:getInput", _U("confirm"), _U("insertid"), function(result)
                        local TargetID = result
                        if TargetID ~= "" and lastLocation then
                            local adminCoords = GetEntityCoords(PlayerPedId())
                            TriggerServerEvent("vorp_admin:Bring", TargetID, adminCoords)
                            if Config.TeleportLogs.Bringplayer then
                                TriggerServerEvent("vorp_admin:logs", Config.TeleportLogs.Bringplayer
                                    , _U("titleteleport"), _U("usedbringplayer") .. "\n playerID: " .. TargetID)
                            end
                        else
                            TriggerEvent("vorp:TipRight", _U("empty"))
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "sendback" then
                TriggerEvent("vorpinputs:getInput", _U("confirm"), _U("insertid"), function(result)
                    local TargetID = result
                    if TargetID ~= "" and lastLocation then
                        TriggerServerEvent("vorp_admin:TeleportPlayerBack", TargetID)
                    else
                        TriggerEvent("vorp:TipRight", _U("gotoplayerfirst"), 4000)
                    end
                end)
            end

        end,

        function(menu)
            menu.close()
        end)

end
