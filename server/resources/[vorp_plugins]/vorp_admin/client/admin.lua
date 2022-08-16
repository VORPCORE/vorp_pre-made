-------------------------------------------------------------------------------------------------
--------------------------------- ADMIN ACTIONS -------------------------------------------------
-- administration category
local freeze = false
local lastLocation = {}



function Admin()
    MenuData.CloseAll()
    local elements = {
        { label = _U("playerslist"), value = 'players', desc = _U("playerlist_desc") },
        { label = _U("adminactions"), value = 'actions', desc = _U("adminactions_desc") },
        { label = _U("offLineactions"), value = 'offline', desc = _U("offlineplayers_desc") },
    }
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U("MenuTitle"),
            subtext  = _U("MenuSubTitle"),
            align    = 'top-left',
            elements = elements,
            lastmenu = 'OpenMenu', --Go back
        },
        function(data)
            if data.current == "backup" then
                _G[data.trigger]()

            end
            if data.current.value == "players" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.PlayersList')
                Wait(100)

                if AdminAllowed then

                    PlayerList()
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "actions" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.AdminActions')
                Wait(100)

                if AdminAllowed then
                    Actions()
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "offline" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.OfflineActions')
                Wait(100)

                if AdminAllowed then
                    OffLine()
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end

            end
        end,
        function(menu)
            menu.close()
        end)
end

--TODO added to langs
function PlayerList()
    MenuData.CloseAll()
    local elements = {}
    local players = GetPlayers()

    for k, playersInfo in pairs(players) do

        elements[#elements + 1] = {
            label = playersInfo.PlayerName,
            value = "players" .. k,
            desc = _U("SteamName") .. "<span style=color:MediumSeaGreen;> "
                .. playersInfo.name .. "</span><br>" .. _U("ServerID") .. "<span style=color:MediumSeaGreen;>"
                .. playersInfo.serverId .. "</span><br>" .. _U("PlayerGroup") .. "<span style=color:MediumSeaGreen;>"
                .. playersInfo.Group .. "</span><br>" .. _U("PlayerJob") .. "<span style=color:MediumSeaGreen;>"
                .. playersInfo.Job .. "</span>" .. _U("Grade") .. "<span style=color:MediumSeaGreen;>"
                .. playersInfo.Grade .. "</span><br>" .. _U("Identifier") .. "<span style=color:MediumSeaGreen;>"
                .. playersInfo.SteamId .. "</span><br>" .. _U("PlayerMoney") .. "<span style=color:MediumSeaGreen;>"
                .. playersInfo.Money .. "</span><br>" .. _U("PlayerGold") .. "<span style=color:Gold;>"
                .. playersInfo.Gold .. "</span><br>" .. _U("PlayerStaticID") .. "<span style=color:Red;>"
                .. playersInfo.staticID .. "</span><br>" .. _U("PlyaerWhitelist") .. "<span style=color:Gold;>"
                .. playersInfo.WLstatus .. "</span><br>" .. _U("PlayerWarnings") .. "<span style=color:Gold;>"
                .. playersInfo.warns .. "</span>", info = playersInfo
        }

    end

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U("MenuTitle"),
            subtext  = _U("MenuSubtitle2"),
            align    = 'top-left',
            elements = elements,
            lastmenu = 'Admin',
        },
        function(data)
            if data.current == "backup" then
                _G[data.trigger]()
            end
            if data.current.value then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.PlayersListSubmenu')
                Wait(100)
                if AdminAllowed then
                    local player = data.current.info
                    OpenSubAdminMenu(player)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end

            end
        end,
        function(menu)
            menu.close()
        end)

end

function OpenSubAdminMenu(Player)
    MenuData.CloseAll()
    local elements = {
        { label = _U("SimpleAction"), value = 'simpleaction', desc = _U("SimpleAction") },
        { label = _U("AdvancedAction"), value = 'advancedaction', desc = _U("AdvancedAction") },
    }
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U("MenuTitle"),
            subtext  = _U("MenuTitle_desc"),
            align    = 'top-left',
            elements = elements,
            lastmenu = 'PlayerList',
        },
        function(data)
            if data.current == "backup" then
                _G[data.trigger]()
            end
            if data.current.value == "simpleaction" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.OpenSimpleActions')
                Wait(100)
                if AdminAllowed then
                    OpenSimpleActionMenu(Player)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "advancedaction" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.OpenAdvancedActions')
                Wait(100)
                if AdminAllowed then
                    OpenAdvancedActions(Player)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            end
        end,
        function(menu)
            menu.close()
        end)

end

function OpenSimpleActionMenu(PlayerInfo)

    MenuData.CloseAll()
    local elements = {
        { label = _U("spectate_p"), value = 'spectate',
            desc = _U("spectate_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId },
        { label = _U("freeze_p"), value = 'freeze',
            desc = _U("freeze_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId },
        { label = _U("revive_p"), value = 'revive',
            desc = _U("revive_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId },
        { label = _U("heal_p"), value = 'heal',
            desc = _U("heal_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId },
        { label = _U("goto_p"), value = 'goto',
            desc = _U("goto_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId },
        { label = _U("goback_p"), value = 'goback',
            desc = _U("goback_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId },
        { label = _U("bring_p"), value = 'bring',
            desc = _U("bring_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId },
        { label = _U("sendback"), value = 'sendback',
            desc = _U("sendback_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId },
        { label = _U("warn_p"), value = 'warn',
            desc = _U("warn_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.staticID, info2 = PlayerInfo.Group, info3 = PlayerInfo.serverId },
        { label = _U("unwarn_p"), value = 'unwarn',
            desc = _U("unwarn_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.staticID, info2 = PlayerInfo.serverId },
    }

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U("MenuTitle"),
            subtext  = "SubMenu",
            align    = 'top-left',
            elements = elements,
            lastmenu = 'PlayerList', --Go back
        },

        function(data)
            if data.current == "backup" then
                _G[data.trigger]()

            end
            if data.current.value == "freeze" then
                local target = data.current.info
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Frezee')
                Wait(100)

                if AdminAllowed then
                    if target then
                        if not freeze then
                            freeze = true
                            TriggerServerEvent("vorp_admin:freeze", target, freeze)
                            TriggerEvent("vorp:TipRight", _U("switchedon"), 3000)
                            if Config.AdminLogs.Freezed then
                                TriggerServerEvent("vorp_admin:logs",
                                    Config.AdminLogs.Freezed
                                    , _U("titleadmin"), _U("usedfreeze") .. "\n> " .. PlayerInfo.PlayerName)
                            end
                        else
                            freeze = false
                            TriggerServerEvent("vorp_admin:freeze", target, freeze)
                            TriggerEvent("vorp:TipRight", _U("switchedoff"), 3000)
                        end
                    end
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end


            elseif data.current.value == "bring" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Bring')
                Wait(100)

                if AdminAllowed then
                    local target = data.current.info


                    local adminCoords = GetEntityCoords(PlayerPedId())
                    TriggerServerEvent("vorp_admin:Bring", target, adminCoords)
                    if Config.AdminLogs.Bring then
                        TriggerServerEvent("vorp_admin:logs",
                            Config.AdminLogs.Bring
                            , _U("titleadmin"), _U("usedbring") .. "\n> " .. PlayerInfo.PlayerName)
                    end
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end

            elseif data.current.value == "sendback" then
                local target = data.current.info
                if lastLocation then
                    TriggerServerEvent("vorp_admin:TeleportPlayerBack", target)
                end

            elseif data.current.value == "goto" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.GoTo')
                Wait(100)

                if AdminAllowed then
                    local target = data.current.info

                    TriggerServerEvent("vorp_admin:TpToPlayer", target)
                    if Config.AdminLogs.Goto then
                        TriggerServerEvent("vorp_admin:logs",
                            Config.AdminLogs.Goto
                            , _U("titleadmin"), _U("usedgoto") .. "\n> " .. PlayerInfo.PlayerName)
                    end
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end

            elseif data.current.value == "goback" then
                if lastLocation then
                    TriggerServerEvent("vorp_admin:sendAdminBack")
                end
            elseif data.current.value == "revive" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Revive')
                Wait(100)

                if AdminAllowed then
                    local target = data.current.info
                    TriggerServerEvent('vorp_admin:revive', target)
                    if Config.AdminLogs.Revive then
                        TriggerServerEvent("vorp_admin:logs",
                            Config.AdminLogs.Revive
                            , _U("titleadmin"), _U("usedreviveplayer") .. "\n> " .. PlayerInfo.PlayerName)
                    end
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "heal" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Heal')
                Wait(100)

                if AdminAllowed then
                    local target = data.current.info
                    TriggerServerEvent('vorp_admin:heal', target)
                    if Config.AdminLogs.Heal then
                        TriggerServerEvent("vorp_admin:logs",
                            Config.AdminLogs.Heal
                            , _U("titleadmin"), _U("usedhealplayer") .. "\n> " .. PlayerInfo.PlayerName)
                    end
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "warn" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Warn')
                Wait(100)

                if AdminAllowed then
                    local staticID = data.current.info
                    local targetGroup = data.current.info2
                    local target = data.current.info3
                    local status = "warn"
                    local myInput = {
                        type = "enableinput", -- dont touch
                        inputType = "textarea",
                        button = _U("confirm"), -- button name
                        placeholder = "Reason for warn", --placeholdername
                        style = "block", --- dont touch
                        attributes = {
                            inputHeader = "WARN PLAYER", -- header
                            type = "text", -- inputype text, number,date.etc if number comment out the pattern
                            pattern = "[A-Za-z0-9 ]{10,100}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                            title = " min 10 max 100 chars dont use dot or commas", -- if input doesnt match show this message
                            style = "border-radius: 10px; background-color: ; border:none;", -- style  the inptup
                        }
                    }

                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                        local reason = tostring(result)
                        if reason ~= "" then
                            if targetGroup ~= "user" then
                                TriggerEvent("vorp:TipRight", _U("cantwarnstaff"), 4000)
                            else

                                TriggerServerEvent("vorp_admin:warns", target, status, staticID, reason)
                                if Config.AdminLogs.Warned then
                                    TriggerServerEvent("vorp_admin:logs",
                                        Config.AdminLogs.Warned
                                        , _U("titleadmin"), _U("warned") .. reason .. "\n > " .. PlayerInfo.PlayerName)
                                end
                            end

                        else
                            TriggerEvent("vorp:TipRight", _U("empty"), 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end

            elseif data.current.value == "unwarn" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.UnWarn')
                Wait(100)

                if AdminAllowed then
                    local staticID = data.current.info
                    local target = data.current.info2
                    local status = "unwarn"
                    TriggerServerEvent("vorp_admin:warns", target, status, staticID)
                    if Config.AdminLogs.Unwarned then
                        TriggerServerEvent("vorp_admin:logs",
                            Config.AdminLogs.Unwarned
                            , _U("titleadmin"), _U("unwarned") .. "\n > " .. staticID)
                    end
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "spectate" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Spectate')
                Wait(100)

                if AdminAllowed then
                    local target = data.current.info
                    TriggerServerEvent("vorp_admin:spectate", target)
                    if Config.AdminLogs.Spectate then
                        TriggerServerEvent("vorp_admin:logs",
                            Config.AdminLogs.Spectate
                            , _U("titleadmin"), _U("usedspectate") .. "\n > " .. PlayerInfo.PlayerName)
                    end
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end

            end
        end,

        function(menu)
            menu.close()
        end)

end

function OpenAdvancedActions(Player)
    MenuData.CloseAll()
    local elements = {
        { label = _U("kick_p"), value = 'kick',
            desc = _U("kick_desc") .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.Group, info2 = Player.serverId },
        { label = _U("ban_p"), value = 'ban',
            desc = _U("ban_desc") .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.staticID, info2 = Player.Group, info3 = Player.serverId },
        { label = _U("unban_p"), value = 'unban',
            desc = _U("unban_desc") .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.staticID },
        { label = _U("respawn_p"), value = 'respawn',
            desc = _U("respawn_desc") .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.serverId },
        { label = _U("whitelist_p"), value = 'whitelist',
            desc = _U("whitelist_desc") .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.serverId, info2 = Player.staticID },
        { label = _U("unwhitelist_p"), value = 'unwhitelist',
            desc = _U("unwarn_desc") .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.serverId, info2 = Player.staticID },
        { label = _U("setjob_p"), value = 'setjob',
            desc = _U("setjob_desc") .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.serverId },
        { label = _U("setgroup_p"), value = 'setgroup',
            desc = _U("setgroup_desc") .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.serverId },
    }


    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U("MenuTitle"),
            subtext  = Player.PlayerName, --char player name
            align    = 'top-left',
            elements = elements,
            lastmenu = 'PlayerList',
        },

        function(data)
            if data.current == "backup" then
                _G[data.trigger]()
            end

            if data.current.value == "respawn" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Respawn')
                Wait(100)

                if AdminAllowed then
                    local target = data.current.info
                    TriggerServerEvent("vorp_admin:respawnPlayer", target)
                    if Config.AdminLogs.Respawn then
                        TriggerServerEvent("vorp_admin:logs",
                            Config.AdminLogs.Respawn
                            , _U("titleadmin"), _U("usedrespawn") .. "\n > " .. Player.PlayerName)
                    end
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "kick" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Kick')
                Wait(100)

                if AdminAllowed then
                    local targetGroup = data.current.info
                    local targetID = data.current.info2
                    local myInput = {
                        type = "enableinput", -- dont touch
                        inputType = "input",
                        button = _U("confirm"), -- button name
                        placeholder = "Reason for kick", --placeholdername
                        style = "block", --- dont touch
                        attributes = {
                            inputHeader = "KICK PLAYER", -- header
                            type = "text", -- inputype text, number,date.etc if number comment out the pattern
                            pattern = "[A-Za-z0-9 ]{10,100}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                            title = " min 10 max 100 chars dont use dot or commas", -- if input doesnt match show this message
                            style = "border-radius: 10px; background-color: ; border:none;", -- style  the inptup
                        }
                    }
                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                        local reason = tostring(result)
                        if reason ~= "" then
                            if targetGroup ~= "user" then
                                TriggerEvent("vorp:TipRight", _U("cantkickstaff"), 4000)
                            else

                                TriggerServerEvent("vorp_admin:kick", targetID, reason)
                                if Config.AdminLogs.Kick then
                                    TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Kick
                                        , _U("titleadmin"), _U("usedkick") .. "\n > " .. Player.PlayerName ..
                                        "\n: " .. reason)
                                end
                            end

                        else
                            TriggerEvent("vorp:TipRight", _U("empty"), 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end


            elseif data.current.value == "ban" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Ban')
                Wait(100)

                if AdminAllowed then
                    local group = data.current.info2
                    local staticID = data.current.info
                    local target = data.current.info3

                    local myInput = {
                        type = "enableinput", -- dont touch
                        inputType = "input",
                        button = _U("confirm"), -- button name
                        placeholder = " example 1d is 1 day", --placeholdername
                        style = "block", --- dont touch
                        attributes = {
                            inputHeader = "BAN PLAYER", -- header
                            type = "text", -- inputype text, number,date.etc if number comment out the pattern
                            pattern = "[A-Za-z0-9 ]{2,2}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                            title = " min 2 max 2 chars dont use dot or commas", -- if input doesnt match show this message
                            style = "border-radius: 10px; background-color: ; border:none;", -- style  the inptup
                        }
                    }

                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                        local time = tostring(result)
                        if time ~= "" then

                            if group ~= "user" then
                                TriggerEvent("vorp:TipRight", _U("cantbanstaff"), 4000)
                            else
                                TriggerServerEvent("vorp_admin:BanPlayer", target, staticID, time)
                                if Config.AdminLogs.Ban then
                                    TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Ban
                                        , _U("titleadmin"), _U("usedban") .. "\n > " .. Player.PlayerName ..
                                        "\n: " .. time)
                                end
                            end

                        else
                            TriggerEvent("vorp:TipRight", _U("empty"), 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end

            elseif data.current.value == "unban" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Unban')
                Wait(100)

                if AdminAllowed then
                    local staticID = data.current.info
                    TriggerEvent("vorp:unban", staticID)
                    if Config.AdminLogs.Unban then
                        TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Unban
                            , _U("titleadmin"), _U("usedunban") .. "\n > " .. Player.PlayerName ..
                            "\n: " .. staticID)
                    end
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "whitelist" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Whitelist')
                Wait(100)

                if AdminAllowed then
                    local target = data.current.info
                    local staticID = data.current.info2
                    local type = "addWhiteList"
                    TriggerServerEvent("vorp_admin:Whitelist", target, staticID, type)
                    TriggerEvent("vorp:TipRight", _U("whiteset"), 5000)
                    if Config.AdminLogs.Whitelist then
                        TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Whitelist, _U("titleadmin"),
                            _U("usedwhitelist") .. "\n > " .. Player.PlayerName .. "\n: " .. staticID)
                    end
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end

            elseif data.current.value == "unwhitelist" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Unwhitelist')
                Wait(100)

                if AdminAllowed then
                    local target = data.current.info
                    local staticID = data.current.info2
                    local type = "removewhitelist"
                    TriggerServerEvent("vorp_admin:Whitelist", target, staticID, type)
                    TriggerEvent("vorp:TipRight", _U("whiteremove"), 5000)
                    if Config.AdminLogs.Unwhitelist then
                        TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Unwhitelist
                            , _U("titleadmin"), _U("usedunwhitelist") .. "\n > " .. Player.PlayerName ..
                            "\n: " .. staticID)
                    end
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "setgroup" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Setgroup')
                Wait(100)

                if AdminAllowed then
                    local target = data.current.info
                    local myInput = {
                        type = "enableinput", -- dont touch
                        inputType = "input",
                        button = _U("confirm"), -- button name
                        placeholder = "NAME", --placeholdername
                        style = "block", --- dont touch
                        attributes = {
                            inputHeader = "SET GROUP", -- header
                            type = "text", -- inputype text, number,date.etc if number comment out the pattern
                            pattern = "[A-Za-z]{3,20}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                            title = " min 3 max 20 only letters", -- if input doesnt match show this message
                            style = "border-radius: 10px; background-color: ; border:none;", -- style  the inptup
                        }
                    }
                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                        local result = tostring(cb)

                        if result ~= "" then
                            TriggerServerEvent("vorp_admin:setGroup", target, result)
                            if Config.AdminLogs.Setgroup then
                                TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Setgroup
                                    , _U("titleadmin"), _U("usedsetgroup") .. "\n > " .. Player.PlayerName ..
                                    "\ngroup: " .. result)
                            end
                        else
                            TriggerEvent("vorp:TipRight", _U("empty"), 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end

            elseif data.current.value == "setjob" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Setjob')
                Wait(100)

                if AdminAllowed then
                    local target = data.current.info
                    local myInput = {
                        type = "enableinput", -- dont touch
                        inputType = "input",
                        button = _U("confirm"), -- button name
                        placeholder = "JOB  GRADE", --placeholdername
                        style = "block", --- dont touch
                        attributes = {
                            inputHeader = "SET JOB", -- header
                            type = "text", -- inputype text, number,date.etc if number comment out the pattern
                            pattern = "[A-Za-z0-9 ]{3,20}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                            title = " min 3 max 20 no . no , no - no _", -- if input doesnt match show this message
                            style = "border-radius: 10px; background-color: ; border:none;", -- style  the inptup
                        }
                    }

                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                        local result = tostring(cb)

                        if result ~= "" then

                            local splitstring = {}
                            for i in string.gmatch(result, "%S+") do
                                splitstring[#splitstring + 1] = i
                            end
                            local jobname, jobgrade = tostring(splitstring[1]), tonumber(splitstring[2])
                            if jobname and jobgrade then
                                TriggerServerEvent("vorp_admin:setJob", target, jobname, jobgrade)
                                if Config.AdminLogs.Setjob then
                                    TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Setjob
                                        , _U("titleadmin"), _U("usedsetjob") .. "\n > " .. Player.PlayerName ..
                                        "\njob:  " .. jobname .. " \ngrade: " .. jobgrade)
                                end
                            end
                        else
                            TriggerEvent("vorp:TipRight", _U("empty"), 4000)
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

-------------------------------------------------------------------------------------------------------------
---------------------------------------- Actions ------------------------------------------------------------


function Actions()
    MenuData.CloseAll()
    local player = PlayerPedId()
    local elements = {
        { label = _U("deletehorse"), value = 'delhorse', desc = _U("deletehorse_desc") },
        { label = _U("deletewagon"), value = 'delwagon', desc = _U("deletewagon_desc") },
        { label = _U("deletewagonradius"), value = 'delwagonradius', desc = _U("deletewagonradius_desc") },
        { label = _U("getcoords"), value = 'getcoords', desc = _U("getcoords_desc") },
        { label = _U("announce"), value = 'announce', desc = _U("announce_desc") },

    }

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U("MenuTitle"),
            subtext  = _U("MenuSubTitle"),
            align    = 'top-left',
            elements = elements,
            lastmenu = 'Admin', --Go back
        },

        function(data)
            if data.current == "backup" then
                _G[data.trigger]()

            end

            if data.current.value == "delhorse" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.DeleteHorse')
                Wait(100)

                if AdminAllowed then

                    TriggerEvent("vorp:delHorse")
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end

            elseif data.current.value == "delwagon" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.DeleteWagon')
                Wait(100)

                if AdminAllowed then
                    Delwagon()
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end

            elseif data.current.value == "delwagonradius" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.DeleteWagonsRadius')
                Wait(100)

                if AdminAllowed then

                    local myInput = {
                        type = "enableinput", -- dont touch
                        inputType = "input",
                        button = _U("confirm"), -- button name
                        placeholder = _U("insertnumber"), --placeholdername
                        style = "block", --- dont touch
                        attributes = {
                            inputHeader = _U("radius"), -- header
                            type = "number", -- inputype text, number,date.etc if number comment out the pattern
                            pattern = "[0-9]{1,2}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                            title = "numbers only max allowed is 2", -- if input doesnt match show this message
                            style = "border-radius: 10px; backgRound-color: ; border:none;", -- style  the inptup
                        }
                    }

                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                        local radius = result

                        if radius ~= "" then
                            TriggerEvent("vorp:deleteVehicle", radius)
                        else
                            TriggerEvent('vorp:TipRight', _U("advalue"), 3000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "getcoords" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.GetCoords')
                Wait(100)

                if AdminAllowed then
                    OpenCoordsMenu()
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "announce" then

                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Announce')
                Wait(100)

                if AdminAllowed then

                    local myInput = {
                        type = "enableinput", -- dont touch
                        inputType = "input",
                        button = _U("confirm"), -- button name
                        placeholder = _U("announce"), --placeholdername
                        style = "block", --- dont touch
                        attributes = {
                            inputHeader = _U("announce"), -- header
                            type = "text", -- inputype text, number,date.etc if number comment out the pattern
                            pattern = "[A-Za-z0-9 ]{5,100}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                            title = _U("lettersandnumbers"), -- if input doesnt match show this message
                            style = "border-radius: 10px; backgRound-color: ; border:none;", -- style  the input
                        }
                    }

                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                        local announce = result

                        if announce ~= "" and announce then
                            TriggerServerEvent("vorp_admin:announce", announce)
                            if Config.AdminLogs.Announce then
                                TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Announce
                                    , _U("titleadmin"), _U("usedannounce") .. "\n > " .. announce)
                            end
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

function OpenCoordsMenu()
    MenuData.CloseAll()
    local elements = {
        { label = _U("XYZ"), value = 'v2', desc = _U("copyclipboardcoords_desc") },
        { label = _U("vector3"), value = 'v3', desc = _U("copyclipboardvector3_desc") },
        { label = _U("vector4"), value = 'v4', desc = _U("copyclipboardvector4_desc") },
        { label = _U("heading"), value = 'heading', desc = _U("copyclipboardheading_desc") },



    }
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U("MenuTitle"),
            subtext  = _U("getcoords"),
            align    = 'top-left',
            elements = elements,
            lastmenu = 'Actions', --Go back
        },

        function(data)
            if data.current == "backup" then
                _G[data.trigger]()

            end
            if data.current.value then
                local DataCoords = data.current.value
                CopyToClipboard(DataCoords)
            end

        end,

        function(menu)
            menu.close()
        end)

end

--to test
function OffLine()
    MenuData.CloseAll()
    local elements = {
        { label = _U("banunban"), value = 'bans',
            desc = _U("banunban_desc") },
        { label = _U("whiteunwhite"), value = 'whites',
            desc = _U("whiteunwhite_desc") },
        { label = _U("warnunwarn"), value = 'warn', desc = _U("warn_desc") },

    }

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U("MenuTitle"),
            subtext  = _U("getcoords"),
            align    = 'top-left',
            elements = elements,
            lastmenu = 'Admin',
        },

        function(data)
            if data.current == "backup" then
                _G[data.trigger]()
            end

            if data.current.value == "bans" then

                local myInput = {
                    type = "enableinput", -- dont touch
                    inputType = "input",
                    button = _U("confirm"), -- button name
                    placeholder = _U("typestaticidtime"), --placeholdername
                    style = "block", --- dont touch
                    attributes = {
                        inputHeader = _U("banunban"), -- header
                        type = "text", -- inputype text, number,date.etc if number comment out the pattern
                        pattern = "[A-Za-z0-9 ]{1,10}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                        title = " min 1 max 20 no . no , no - no _", -- if input doesnt match show this message
                        style = "border-radius: 10px; background-color: ; border:none;", -- style  the inptup
                    }
                }

                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                    local result = cb
                    if result ~= "" then

                        local splitstring = {}
                        for i in string.gmatch(result, "%S+") do
                            splitstring[#splitstring + 1] = i
                        end
                        local type, StaticID, time = tostring(splitstring[1]), tonumber(splitstring[2]),
                            tostring(splitstring[3])

                        if type == "ban" then
                            if StaticID and time then
                                TriggerEvent("vorp:ban", StaticID, time) -- need to test
                            end
                        elseif type == "unban" then
                            TriggerEvent("vorp:unban", StaticID)
                        else
                            TriggerEvent("vorp:TipRight", _U("incorrecttype"))
                        end

                    else
                        TriggerEvent("vorp:TipRight", _U("empty"), 4000)
                    end
                end)

            elseif data.current.value == "whites" then
                local myInput = {
                    type = "enableinput", -- dont touch
                    inputType = "input",
                    button = _U("confirm"), -- button name
                    placeholder = _U("typestaticid"), --placeholdername
                    style = "block", --- dont touch
                    attributes = {
                        inputHeader = _U("whiteunwhite"), -- header
                        type = "text", -- inputype text, number,date.etc if number comment out the pattern
                        pattern = "[A-Za-z0-9 ]{1,20}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                        title = " min 1 max 20 no . no , no - no _", -- if input doesnt match show this message
                        style = "border-radius: 10px; background-color: ; border:none;", -- style  the inptup
                    }
                }

                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                    local result = cb
                    if result ~= "" then
                        local splitstring = {}
                        for i in string.gmatch(result, "%S+") do
                            splitstring[#splitstring + 1] = i
                        end
                        local type, StaticID = tostring(splitstring[1]), tonumber(splitstring[2])
                        if type and StaticID then -- if empty dont run
                            if type == "whitelist" then
                                TriggerEvent("vorp:whitelistPlayer", StaticID)
                            elseif type == "unwhitelist" then
                                TriggerEvent("vorp:unwhitelistPlayer", StaticID)
                            else
                                TriggerEvent("vorp:TipRight", _U("incorrect"))
                            end
                        end
                    else
                        TriggerEvent("vorp:TipRight", _U("empty"), 4000)
                    end
                end)
            elseif data.current.value == "warns" then
                local myInput = {
                    type = "enableinput", -- dont touch
                    inputType = "textarea",
                    button = _U("confirm"), -- button name
                    placeholder = _U("typestaticid"), --placeholdername
                    style = "block", --- dont touch
                    attributes = {
                        inputHeader = _U("warnunwarn"), -- header
                        type = "text", -- inputype text, number,date.etc if number comment out the pattern
                        pattern = "[A-Za-z0-9 ]{10,100}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                        title = " min 10 max 100 chars dont use dot or commas", -- if input doesnt match show this message
                        style = "border-radius: 10px; background-color: ; border:none;", -- style  the inptup
                    }
                }

                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                    local result = tostring(cb)
                    if result ~= "" then

                        local splitstring = {}
                        for i in string.gmatch(result, "%S+") do
                            splitstring[#splitstring + 1] = i
                        end
                        local type, StaticID = tostring(splitstring[1]), tonumber(splitstring[2])

                        if type and StaticID then

                            if type == "warn" then
                                TriggerEvent("vorp:warn", StaticID)
                            elseif type == "unwarn" then
                                TriggerEvent("vorp:unwarn", StaticID)
                            else
                                TriggerEvent("vorp:TipRight", _U("incorrect"))
                            end
                        else
                            TriggerEvent("vorp:TipRight", _U("missing"))
                        end

                    else
                        TriggerEvent("vorp:TipRight", _U("empty"), 4000)
                    end
                end)

            end

        end,

        function(menu)
            menu.close()
        end)

end
