---@diagnostic disable: undefined-global
-------------------------------------------------------------------------------------------------
--------------------------------- ADMIN ACTIONS -------------------------------------------------
-- administration category
local freeze = false
local lastLocation = {}

function Admin()
    MenuData.CloseAll()
    local elements = {
        { label = _U("playerslist"),    value = 'players', desc = _U("playerlist_desc") },
        { label = _U("adminactions"),   value = 'actions', desc = _U("adminactions_desc") },
        { label = _U("offLineactions"), value = 'offline', desc = _U("offlineplayers_desc") },
        { label = "viewreports",        value = 'view',    desc = "viewreports" },
        { label = "search player",      value = 'search',  desc = "insert server id to find a player info " },
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
            elseif data.current.value == "view" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.ViewReports')
                Wait(100)
                if AdminAllowed then
                    TriggerEvent("vorp_admin:viewreports")
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "search" then
                local myInput = Inputs("input", _U("confirm"), "server id", "SEARCH PLAYER", "number",
                    " min 10 max 100 chars dont use dot or commas", "[0-9]{10,100}")
                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                    local id = tonumber(result)
                    if id and id > 0 then
                        VORP.RpcCall("vorp_admin:Callback:getplayersinfo", function(cb)
                            if cb then
                                OpenOnePlayerMenu(cb)
                            else
                                TriggerEvent("vorp:TipRight", "user dont exist ", 4000)
                            end
                        end, { search = "search", id = id })
                    end
                end)
            end
        end,
        function(menu)
            menu.close()
        end)
end

function OpenOnePlayerMenu(playersInfo)
    MenuData.CloseAll()
    local elements = {
        {
            label = playersInfo.PlayerName .. "<br> Server id: " .. playersInfo.serverId,
            value = "players" .. playersInfo.serverId,
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
                .. playersInfo.warns .. "</span>",
            info = playersInfo
        }
    }
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title      = _U("MenuTitle"),
            subtext    = _U("MenuSubtitle2"),
            align      = 'top-left',
            elements   = elements,
            lastmenu   = 'Admin',
            itemHeight = "4vh",
        },
        function(data)
            if data.current == "backup" then
                _G[data.trigger]()
            end
            if data.current.value then
                OpenSubAdminMenu(data.current.info)
            end
        end,
        function(menu)
            menu.close()
        end)
end

function PlayerList()
    MenuData.CloseAll()
    local elements = {}
    VORP.RpcCall("vorp_admin:Callback:getplayersinfo", function(result)
        if not result then
            return
        end
        local players = result
        local sortedPlayers = {} -- Create a new table to store the sorted player list

        for playerid, playersInfo in pairs(players) do
            sortedPlayers[#sortedPlayers + 1] = playersInfo
        end

        -- Sort players by serverId in ascending order
        table.sort(sortedPlayers, function(a, b)
            return a.serverId < b.serverId
        end)

        for _, playersInfo in ipairs(sortedPlayers) do
            elements[#elements + 1] = {
                label = playersInfo.PlayerName .. "<br> Server id: " .. playersInfo.serverId,
                value = "players" .. playersInfo.serverId,
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
                    .. playersInfo.warns .. "</span>",
                info = playersInfo
            }
        end

        MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
            {
                title      = _U("MenuTitle"),
                subtext    = _U("MenuSubtitle2"),
                align      = 'top-left',
                elements   = elements,
                lastmenu   = 'Admin',
                itemHeight = "4vh",
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
    end, { search = "all" })
end

function OpenSubAdminMenu(Player)
    MenuData.CloseAll()
    local elements = {
        { label = _U("SimpleAction"),   value = 'simpleaction',   desc = _U("SimpleAction") },
        { label = _U("AdvancedAction"), value = 'advancedaction', desc = _U("AdvancedAction") },
        { label = _U("TrollActions"),   value = 'trollactions',   desc = _U('TrollActions') },
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
            elseif data.current.value == 'trollactions' then
                TriggerServerEvent('vorp_admin:opneStaffMenu', 'vorp.staff.OpenTrollActions')
                Wait(100)
                if AdminAllowed then
                    OpenTrollActions(Player)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            end
        end,
        function(menu)
            menu.close()
        end)
end

function OpenTrollActions(PlayerInfo)
    MenuData.CloseAll()
    local elements = {
        {
            label = _U('KillPlayer'),
            value = 'killplayer',
            desc = _U('killplayer_desc') .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = _U("InvisPlayer"),
            value = 'invisplayer',
            desc = _U('InvisPlayer_desc') .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = _U('LightningStrikePlayer'),
            value = 'lightningstrikeplayer',
            desc = _U('LightningStrikePlayer_desc') ..
                "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = _U('SetPlayerOnFire'),
            value = 'setplayeronfire',
            desc = _U('SetPlayerOnFire_desc') ..
                "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = _U('TPToHeaven'),
            value = 'tptoheaven',
            desc = _U('TPToHeaven_desc') .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = _U('RagdollPlayer'),
            value = 'ragdollplayer',
            desc = _U('RagdollPlayer_desc') .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = _U('DrainPlayerStam'),
            value = 'drainplayerstam',
            desc = _U('DrainPlayerStam_desc') ..
                "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = _U('CuffPlayer'),
            value = 'cuffplayer',
            desc = _U('CuffPlayer_desc') .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = _U('TempHighPlayer'),
            value = 'temphighplayer',
            desc = _U('TempHighPlayer_desc') ..
                "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
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
            if data.current.value == 'killplayer' then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.KillPlayer')
                Wait(100)
                if AdminAllowed then
                    TriggerServerEvent('vorp_admin:ServerTrollKillPlayerHandler', data.current.info)
                end
            elseif data.current.value == 'invisplayer' then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.InvisPlayer')
                Wait(100)
                if AdminAllowed then
                    TriggerServerEvent('vorp_admin:ServerTrollInvisibleHandler', data.current.info)
                end
            elseif data.current.value == 'lightningstrikeplayer' then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.LightningStrikePlayer')
                Wait(100)
                if AdminAllowed then
                    TriggerServerEvent('vorp_admin:ServerTrollLightningStrikePlayerHandler', data.current.info)
                end
            elseif data.current.value == 'setplayeronfire' then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.SetPlayerOnFire')
                Wait(100)
                if AdminAllowed then
                    TriggerServerEvent('vorp_admin:ServerTrollSetPlayerOnFireHandler', data.current.info)
                end
            elseif data.current.value == 'tptoheaven' then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.TPToHeaven')
                Wait(100)
                if AdminAllowed then
                    TriggerServerEvent('vorp_admin:ServerTrollTPToHeavenHandler', data.current.info)
                end
            elseif data.current.value == 'ragdollplayer' then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.RagdollPlayer')
                Wait(100)
                if AdminAllowed then
                    TriggerServerEvent('vorp_admin:ServerTrollRagdollPlayerHandler', data.current.info)
                end
            elseif data.current.value == 'drainplayerstam' then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.DrainPlayerStam')
                Wait(100)
                if AdminAllowed then
                    TriggerServerEvent('vorp_admin:ServerDrainPlayerStamHandler', data.current.info)
                end
            elseif data.current.value == 'cuffplayer' then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.CuffPlayer')
                Wait(100)
                if AdminAllowed then
                    TriggerServerEvent('vorp_admin:ServerHandcuffPlayerHandler', data.current.info)
                end
            elseif data.current.value == 'temphighplayer' then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.PlayerTempHigh')
                Wait(100)
                if AdminAllowed then
                    TriggerServerEvent('vorp_admin:ServerTempHighPlayerHandler', data.current.info)
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
        {
            label = _U("spectate_p"),
            value = 'spectate',
            desc = _U("spectate_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = _U("freeze_p"),
            value = 'freeze',
            desc = _U("freeze_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = _U("revive_p"),
            value = 'revive',
            desc = _U("revive_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = _U("heal_p"),
            value = 'heal',
            desc = _U("heal_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = _U("goto_p"),
            value = 'goto',
            desc = _U("goto_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = _U("goback_p"),
            value = 'goback',
            desc = _U("goback_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = _U("bring_p"),
            value = 'bring',
            desc = _U("bring_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = _U("sendback"),
            value = 'sendback',
            desc = _U("sendback_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = _U("warn_p"),
            value = 'warn',
            desc = _U("warn_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.staticID,
            info2 = PlayerInfo.Group,
            info3 = PlayerInfo.serverId
        },
        {
            label = _U("unwarn_p"),
            value = 'unwarn',
            desc = _U("unwarn_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.staticID,
            info2 = PlayerInfo.serverId
        },
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
                    local myInput = Inputs("textarea", _U("confirm"), "Reason for Ban", "player was mean", "text",
                        " min 10 max 100 chars dont use dot or commas", "[A-Za-z0-9 ]{10,100}")
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
        {
            label = _U("kick_p"),
            value = 'kick',
            desc = _U("kick_desc") .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.Group,
            info2 = Player.serverId
        },
        {
            label = _U("ban_p"),
            value = 'ban',
            desc = _U("ban_desc") .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.staticID,
            info2 = Player.Group,
            info3 = Player.serverId
        },
        {
            label = _U("unban_p"),
            value = 'unban',
            desc = _U("unban_desc") .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.staticID
        },
        {
            label = _U("respawn_p"),
            value = 'respawn',
            desc = _U("respawn_desc") .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.serverId
        },
        {
            label = _U("whitelist_p"),
            value = 'whitelist',
            desc = _U("whitelist_desc") .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.serverId,
            info2 = Player.staticID
        },
        {
            label = _U("unwhitelist_p"),
            value = 'unwhitelist',
            desc = _U("unwarn_desc") .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.serverId,
            info2 = Player.staticID
        },
        {
            label = _U("setjob_p"),
            value = 'setjob',
            desc = _U("setjob_desc") .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.serverId
        },
        {
            label = _U("setgroup_p"),
            value = 'setgroup',
            desc = _U("setgroup_desc") .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.serverId
        },
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
                    local myInput = Inputs("input", _U("confirm"), "Reason for kick", "KICK PLAYER", "text",
                        " min 10 max 100 chars dont use dot or commas", "[A-Za-z0-9 ]{10,100}")
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
                    local myInput = Inputs("input", _U("confirm"), " example 1d is 1 day", "BAN PLAYER", "text",
                        " min 2 max 2 chars dont use dot or commas", "[A-Za-z0-9 ]{2,2}")

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
                    local myInput = Inputs("input", _U("confirm"), "name", "Set Group", "text",
                        " min 3 max 20 only letters", "[A-Za-z]{3,20}")
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
                    local myInput = Inputs("input", _U("confirm"), "jobname and grade", "Set Group", "text",
                        " min 3 max 20 no . no , no - no _", "[A-Za-z0-9 ]{3,20}")

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
        { label = _U("deletehorse"),       value = 'delhorse',       desc = _U("deletehorse_desc") },
        { label = _U("deletewagon"),       value = 'delwagon',       desc = _U("deletewagon_desc") },
        { label = _U("deletewagonradius"), value = 'delwagonradius', desc = _U("deletewagonradius_desc") },
        { label = _U("getcoords"),         value = 'getcoords',      desc = _U("getcoords_desc") },
        { label = _U("announce"),          value = 'announce',       desc = _U("announce_desc") },

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
                    local myInput = Inputs("input", _U("confirm"), _U("insertnumber"), _U("radius"), "number",
                        "numbers only max allowed is 2", "[0-9]{1,2}")
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
                    local myInput = Inputs("input", _U("confirm"), _U("announce"), _U("announce"), "text",
                        _U("lettersandnumbers"), "[A-Za-z0-9 ]{5,100}")

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
        { label = _U("XYZ"),     value = 'v2',      desc = _U("copyclipboardcoords_desc") },
        { label = _U("vector3"), value = 'v3',      desc = _U("copyclipboardvector3_desc") },
        { label = _U("vector4"), value = 'v4',      desc = _U("copyclipboardvector4_desc") },
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
        {
            label = _U("banunban"),
            value = 'bans',
            desc = _U("banunban_desc")
        },
        {
            label = _U("whiteunwhite"),
            value = 'whites',
            desc = _U("whiteunwhite_desc")
        },
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
                local myInput = Inputs("input", _U("confirm"), _U("typestaticidtime"), _U("banunban"), "text",
                    " min 1 max 20 no . no , no - no _", "[A-Za-z0-9 ]{5,100}")
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
                            TriggerEvent("vorp:TipRight", _U("incorrecttype"), 4000)
                        end
                    else
                        TriggerEvent("vorp:TipRight", _U("empty"), 4000)
                    end
                end)
            elseif data.current.value == "whites" then
                local myInput = Inputs("input", _U("confirm"), _U("typestaticid"), _U("whiteunwhite"), "text",
                    " min 1 max 20 no . no , no - no _", "[A-Za-z0-9 ]{5,100}")

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
                                TriggerServerEvent("vorp_admin:Whitelistoffline", StaticID, type)
                            elseif type == "unwhitelist" then
                                TriggerServerEvent("vorp_admin:Whitelistoffline", StaticID, type)
                            else
                                TriggerEvent("vorp:TipRight", _U("incorrect"))
                            end
                        end
                    else
                        TriggerEvent("vorp:TipRight", _U("empty"), 4000)
                    end
                end)
            elseif data.current.value == "warn" then
                local myInput = Inputs("input", _U("confirm"), "WARN PLAYER", _U("warnunwarn"), "text",
                    " min 1 max 20 no . no , no - no _", "[A-Za-z0-9 ]{5,100}")

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
                                TriggerEvent("vorp:TipRight", _U("incorrect"), 4000)
                            end
                        else
                            TriggerEvent("vorp:TipRight", _U("missing"), 4000)
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
