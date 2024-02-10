---@diagnostic disable: undefined-global
-------------------------------------------------------------------------------------------------
--------------------------------- ADMIN ACTIONS -------------------------------------------------
-- administration category
local freeze = false
local lastLocation = {}
local T = Translation.Langs[Config.Lang]

function Admin()
    MenuData.CloseAll()
    local elements = {
        { label = T.Menus.MainAdminOptions.playersList,    value = 'players', desc = T.Menus.MainAdminOptions.playersList_desc },
        { label = T.Menus.MainAdminOptions.adminActions,   value = 'actions', desc = T.Menus.MainAdminOptions.adminActions_desc },
        { label = T.Menus.MainAdminOptions.offLineActions, value = 'offline', desc = T.Menus.MainAdminOptions.offLineActions_desc },
        { label = T.Menus.MainAdminOptions.viewReports,    value = 'view',    desc = T.Menus.MainAdminOptions.viewReports_desc },
        { label = T.Menus.MainAdminOptions.searchPlayer,   value = 'search',  desc = T.Menus.MainAdminOptions.searchPlayer_desc },
    }
    MenuData.Open('default', GetCurrentResourceName(), 'Admin',
        {
            title    = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext  = T.Menus.DefaultsMenusTitle.menuSubTitleAdmin,
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
                    TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                end
            elseif data.current.value == "actions" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.AdminActions')
                Wait(100)
                if AdminAllowed then
                    Actions()
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "offline" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.OfflineActions')
                Wait(100)
                if AdminAllowed then
                    OffLine()
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "view" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.ViewReports')
                Wait(100)
                if AdminAllowed then
                    TriggerEvent("vorp_admin:viewreports")
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "search" then
                local myInput = Inputs("input", T.Menus.DefaultsInputs.confirm,
                    T.Menus.MainAdminOptions.MenuAdminInput.placeholder, T.Menus.MainAdminOptions.MenuAdminInput.title,
                    "number", T.Menus.MainAdminOptions.MenuAdminInput.errorMsg, "[0-9]{10,100}")
                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                    local id = tonumber(result)
                    if id and id > 0 then
                        VORP.Callback.TriggerAsync("vorp_admin:Callback:getplayersinfo", function(cb)
                            if cb then
                                OpenOnePlayerMenu(cb)
                            else
                                TriggerEvent("vorp:TipRight", T.Notify.userNotExist, 4000)
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
            label = playersInfo.PlayerName .. "<br>" .. T.Menus.MainPlayerStatus.playerServerID .. playersInfo.serverId,
            value = "players" .. playersInfo.serverId,
            desc = T.Menus.MainPlayerStatus.playerSteamName .. "<span style=color:MediumSeaGreen;> "
                ..
                playersInfo.name ..
                "</span><br>" .. T.Menus.MainPlayerStatus.playerServerID .. " " .. "<span style=color:MediumSeaGreen;>"
                ..
                playersInfo.serverId ..
                "</span><br>" .. T.Menus.MainPlayerStatus.playerGroup .. " " .. "<span style=color:MediumSeaGreen;>"
                ..
                playersInfo.Group ..
                "</span><br>" .. T.Menus.MainPlayerStatus.playerJob .. " " .. "<span style=color:MediumSeaGreen;>"
                .. playersInfo.Job ..
                "</span>" .. T.Menus.MainPlayerStatus.playerGrade .. " " .. "<span style=color:MediumSeaGreen;>"
                ..
                playersInfo.Grade ..
                "</span><br>" .. T.Menus.MainPlayerStatus.playerIdentifier .. " " .. "<span style=color:MediumSeaGreen;>"
                ..
                playersInfo.SteamId ..
                "</span><br>" .. T.Menus.MainPlayerStatus.playerMoney .. " " .. "<span style=color:MediumSeaGreen;>"
                .. playersInfo.Money ..
                "</span><br>" .. T.Menus.MainPlayerStatus.playerGold .. " " .. "<span style=color:Gold;>"
                .. playersInfo.Gold ..
                "</span><br>" .. T.Menus.MainPlayerStatus.playerStaticID .. " " .. "<span style=color:Red;>"
                .. playersInfo.staticID ..
                "</span><br>" .. T.Menus.MainPlayerStatus.playerWhitelist .. " " .. "<span style=color:Gold;>"
                .. playersInfo.WLstatus ..
                "</span><br>" .. T.Menus.MainPlayerStatus.playerWarnings .. " " .. "<span style=color:Gold;>"
                .. playersInfo.warns .. "</span>",
            info = playersInfo
        }
    }
    MenuData.Open('default', GetCurrentResourceName(), 'OpenOnePlayerMenu',
        {
            title      = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext    = T.Menus.DefaultsMenusTitle.menuSubTitleAdmin,
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
    local cbname = "vorp_admin:Callback:getplayersinfo"

    local result = VORP.Callback.TriggerAwait(cbname, { search = "all" })
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
            label = playersInfo.PlayerName .. "<br>" .. T.Menus.MainPlayerStatus.playerServerID .. playersInfo.serverId,
            value = "players" .. playersInfo.serverId,
            desc = T.Menus.MainPlayerStatus.playerSteamName .. "<span style=color:MediumSeaGreen;> "
                ..
                playersInfo.name ..
                "</span><br>" .. T.Menus.MainPlayerStatus.playerServerID .. " " .. "<span style=color:MediumSeaGreen;>"
                ..
                playersInfo.serverId ..
                "</span><br>" .. T.Menus.MainPlayerStatus.playerGroup .. " " .. "<span style=color:MediumSeaGreen;>"
                ..
                playersInfo.Group ..
                "</span><br>" .. T.Menus.MainPlayerStatus.playerJob .. " " .. "<span style=color:MediumSeaGreen;>"
                .. playersInfo.Job ..
                "</span>" .. T.Menus.MainPlayerStatus.playerGrade .. " " .. "<span style=color:MediumSeaGreen;>"
                ..
                playersInfo.Grade ..
                "</span><br>" .. T.Menus.MainPlayerStatus.playerIdentifier .. " " .. "<span style=color:MediumSeaGreen;>"
                ..
                playersInfo.SteamId ..
                "</span><br>" .. T.Menus.MainPlayerStatus.playerMoney .. " " .. "<span style=color:MediumSeaGreen;>"
                .. playersInfo.Money ..
                "</span><br>" .. T.Menus.MainPlayerStatus.playerGold .. " " .. "<span style=color:Gold;>"
                .. playersInfo.Gold ..
                "</span><br>" .. T.Menus.MainPlayerStatus.playerStaticID .. " " .. "<span style=color:Red;>"
                .. playersInfo.staticID ..
                "</span><br>" .. T.Menus.MainPlayerStatus.playerWhitelist .. " " .. "<span style=color:Gold;>"
                .. playersInfo.WLstatus ..
                "</span><br>" .. T.Menus.MainPlayerStatus.playerWarnings .. " " .. "<span style=color:Gold;>"
                .. playersInfo.warns .. "</span>",
            info = playersInfo
        }
    end

    MenuData.Open('default', GetCurrentResourceName(), 'PlayerList',
        {
            title      = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext    = T.Menus.DefaultsMenusTitle.menuSubTitleAdmin,
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
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
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
        { label = T.Menus.SubAdminOptions.simpleActions,   value = 'simpleaction',   desc = T.Menus.SubAdminOptions.simpleActions_desc },
        { label = T.Menus.SubAdminOptions.advancedActions, value = 'advancedaction', desc = T.Menus.SubAdminOptions.advancedActions_desc },
        { label = T.Menus.SubAdminOptions.trollActions,    value = 'trollactions',   desc = T.Menus.SubAdminOptions.trollActions_desc },
    }
    MenuData.Open('default', GetCurrentResourceName(), 'OpenSubAdminMenu',
        {
            title    = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext  = T.Menus.DefaultsMenusTitle.menuSubTitleAdmin,
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
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "advancedaction" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.OpenAdvancedActions')
                Wait(100)
                if AdminAllowed then
                    OpenAdvancedActions(Player)
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == 'trollactions' then
                TriggerServerEvent('vorp_admin:opneStaffMenu', 'vorp.staff.OpenTrollActions')
                Wait(100)
                if AdminAllowed then
                    OpenTrollActions(Player)
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
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
            label = T.Menus.SubTrollOptions.killPlayer,
            value = 'killplayer',
            desc = T.Menus.SubTrollOptions.killPlayer_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = T.Menus.SubTrollOptions.invisPlayer,
            value = 'invisplayer',
            desc = T.Menus.SubTrollOptions.invisPlayer_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = T.Menus.SubTrollOptions.lightningStrikePlayer,
            value = 'lightningstrikeplayer',
            desc = T.Menus.SubTrollOptions.lightningStrikePlayer_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = T.Menus.SubTrollOptions.setPlayerOnFire,
            value = 'setplayeronfire',
            desc = T.Menus.SubTrollOptions.setPlayerOnFire_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = T.Menus.SubTrollOptions.teleportToHeaven,
            value = 'tptoheaven',
            desc = T.Menus.SubTrollOptions.teleportToHeaven_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = T.Menus.SubTrollOptions.ragdollPlayer,
            value = 'ragdollplayer',
            desc = T.Menus.SubTrollOptions.ragdollPlayer_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = T.Menus.SubTrollOptions.drainPlayerStam,
            value = 'drainplayerstam',
            desc = T.Menus.SubTrollOptions.drainPlayerStam_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = T.Menus.SubTrollOptions.cuffPlayer,
            value = 'cuffplayer',
            desc = T.Menus.SubTrollOptions.cuffPlayer_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = T.Menus.SubTrollOptions.tempHighPlayer,
            value = 'temphighplayer',
            desc = T.Menus.SubTrollOptions.tempHighPlayer_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
    }
    MenuData.Open('default', GetCurrentResourceName(), 'OpenTrollActions',
        {
            title    = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext  = T.Menus.DefaultsMenusTitle.menuSubTitleAdmin,
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
                    TriggerServerEvent('vorp_admin:ServerTrollKillPlayerHandler', data.current.info,
                        'vorp.staff.KillPlayer')
                end
            elseif data.current.value == 'invisplayer' then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.InvisPlayer')
                Wait(100)
                if AdminAllowed then
                    TriggerServerEvent('vorp_admin:ServerTrollInvisibleHandler', data.current.info,
                        'vorp.staff.InvisPlayer')
                end
            elseif data.current.value == 'lightningstrikeplayer' then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.LightningStrikePlayer')
                Wait(100)
                if AdminAllowed then
                    TriggerServerEvent('vorp_admin:ServerTrollLightningStrikePlayerHandler', data.current.info,
                        'vorp.staff.LightningStrikePlayer')
                end
            elseif data.current.value == 'setplayeronfire' then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.SetPlayerOnFire')
                Wait(100)
                if AdminAllowed then
                    TriggerServerEvent('vorp_admin:ServerTrollSetPlayerOnFireHandler', data.current.info,
                        'vorp.staff.SetPlayerOnFire')
                end
            elseif data.current.value == 'tptoheaven' then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.TPToHeaven')
                Wait(100)
                if AdminAllowed then
                    TriggerServerEvent('vorp_admin:ServerTrollTPToHeavenHandler', data.current.info,
                        'vorp.staff.TPToHeaven')
                end
            elseif data.current.value == 'ragdollplayer' then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.RagdollPlayer')
                Wait(100)
                if AdminAllowed then
                    TriggerServerEvent('vorp_admin:ServerTrollRagdollPlayerHandler', data.current.info,
                        'vorp.staff.RagdollPlayer')
                end
            elseif data.current.value == 'drainplayerstam' then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.DrainPlayerStam')
                Wait(100)
                if AdminAllowed then
                    TriggerServerEvent('vorp_admin:ServerDrainPlayerStamHandler', data.current.info,
                        'vorp.staff.DrainPlayerStam')
                end
            elseif data.current.value == 'cuffplayer' then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.CuffPlayer')
                Wait(100)
                if AdminAllowed then
                    TriggerServerEvent('vorp_admin:ServerHandcuffPlayerHandler', data.current.info,
                        'vorp.staff.CuffPlayer')
                end
            elseif data.current.value == 'temphighplayer' then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.PlayerTempHigh')
                Wait(100)
                if AdminAllowed then
                    TriggerServerEvent('vorp_admin:ServerTempHighPlayerHandler', data.current.info,
                        'vorp.staff.PlayerTempHigh')
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
            label = T.Menus.SubSimpleActionOptions.playerSpectate,
            value = 'spectate',
            desc = T.Menus.SubSimpleActionOptions.playerSpectate_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = T.Menus.SubSimpleActionOptions.playerFreeze,
            value = 'freeze',
            desc = T.Menus.SubSimpleActionOptions.playerFreeze_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = T.Menus.SubSimpleActionOptions.playerRevive,
            value = 'revive',
            desc = T.Menus.SubSimpleActionOptions.playerRevive_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = T.Menus.SubSimpleActionOptions.playerHeal,
            value = 'heal',
            desc = T.Menus.SubSimpleActionOptions.playerHeal_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = T.Menus.SubSimpleActionOptions.playerGoTo,
            value = 'goto',
            desc = T.Menus.SubSimpleActionOptions.playerGoTo_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = T.Menus.SubSimpleActionOptions.playerGoBack,
            value = 'goback',
            desc = T.Menus.SubSimpleActionOptions.playerGoBack_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = T.Menus.SubSimpleActionOptions.playerBring,
            value = 'bring',
            desc = T.Menus.SubSimpleActionOptions.playerBring_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = T.Menus.SubSimpleActionOptions.playerSendBack,
            value = 'sendback',
            desc = T.Menus.SubSimpleActionOptions.playerSendBack_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.serverId
        },
        {
            label = T.Menus.SubSimpleActionOptions.playerWarn,
            value = 'warn',
            desc = T.Menus.SubSimpleActionOptions.playerWarn_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.staticID,
            info2 = PlayerInfo.Group,
            info3 = PlayerInfo.serverId
        },
        {
            label = T.Menus.SubSimpleActionOptions.playerUnWarn,
            value = 'unwarn',
            desc = T.Menus.SubSimpleActionOptions.playerUnWarn_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. PlayerInfo.PlayerName .. "</span>",
            info = PlayerInfo.staticID,
            info2 = PlayerInfo.serverId
        },
    }

    MenuData.Open('default', GetCurrentResourceName(), 'OpenSimpleActionMenu',
        {
            title    = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext  = T.Menus.DefaultsMenusTitle.menuSubTitleAdmin,
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
                            TriggerServerEvent("vorp_admin:freeze", target, freeze, 'vorp.staff.Frezee')
                            TriggerEvent("vorp:TipRight", T.Notify.switchedOn, 3000)
                            if Config.AdminLogs.Freezed then
                                TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Freezed,
                                    T.Webhooks.ActionsAdmin.title,
                                    T.Webhooks.ActionsAdmin.usedfreeze .. "\n> " .. PlayerInfo.PlayerName)
                            end
                        else
                            freeze = false
                            TriggerServerEvent("vorp_admin:freeze", target, freeze, 'vorp.staff.Frezee')
                            TriggerEvent("vorp:TipRight", T.Notify.switchedOff, 3000)
                        end
                    end
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "bring" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Bring')
                Wait(100)
                if AdminAllowed then
                    local target = data.current.info
                    local adminCoords = GetEntityCoords(PlayerPedId())
                    TriggerServerEvent("vorp_admin:Bring", target, adminCoords, 'vorp.staff.Bring')
                    if Config.AdminLogs.Bring then
                        TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Bring, T.Webhooks.ActionsAdmin.title,
                            T.Webhooks.ActionsAdmin.usedbring .. "\n> " .. PlayerInfo.PlayerName)
                    end
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "sendback" then
                local target = data.current.info
                if lastLocation then
                    TriggerServerEvent("vorp_admin:TeleportPlayerBack", target, 'vorp.staff.Bring')
                end
            elseif data.current.value == "goto" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.GoTo')
                Wait(100)

                if AdminAllowed then
                    local target = data.current.info

                    TriggerServerEvent("vorp_admin:TpToPlayer", target, 'vorp.staff.GoTo')
                    if Config.AdminLogs.Goto then
                        TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Goto, T.Webhooks.ActionsAdmin.title,
                            T.Webhooks.ActionsAdmin.usedgoto .. "\n> " .. PlayerInfo.PlayerName)
                    end
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "goback" then
                if lastLocation then
                    TriggerServerEvent("vorp_admin:sendAdminBack", 'vorp.staff.GoTo')
                end
            elseif data.current.value == "revive" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Revive')
                Wait(100)

                if AdminAllowed then
                    local target = data.current.info
                    TriggerServerEvent('vorp_admin:revive', target, 'vorp.staff.Revive')
                    if Config.AdminLogs.Revive then
                        TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Revive, T.Webhooks.ActionsAdmin.title,
                            T.Webhooks.ActionsAdmin.usedreviveplayer .. "\n> " .. PlayerInfo.PlayerName)
                    end
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "heal" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Heal')
                Wait(100)

                if AdminAllowed then
                    local target = data.current.info
                    TriggerServerEvent('vorp_admin:heal', target, 'vorp.staff.Heal')
                    if Config.AdminLogs.Heal then
                        TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Heal, T.Webhooks.ActionsAdmin.title,
                            T.Webhooks.ActionsAdmin.usedhealplayer .. "\n> " .. PlayerInfo.PlayerName)
                    end
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "warn" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Warn')
                Wait(100)

                if AdminAllowed then
                    local staticID = data.current.info
                    local targetGroup = data.current.info2
                    local target = data.current.info3
                    local status = "warn"
                    local myInput = Inputs("textarea", T.Menus.DefaultsInputs.confirm,
                        T.Menus.SubSimpleActionOptions.WarnInput.placeholder,
                        T.Menus.SubSimpleActionOptions.WarnInput.title, "text",
                        T.Menus.SubSimpleActionOptions.WarnInput.errorMsg, "[A-Za-z0-9 ]{10,100}")
                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                        local reason = tostring(result)
                        if reason ~= "" then
                            if targetGroup ~= "user" then
                                TriggerEvent("vorp:TipRight", T.Notify.cantWarnStaff, 4000)
                            else
                                TriggerServerEvent("vorp_admin:warns", target, status, staticID, reason,
                                    'vorp.staff.Warn')
                                if Config.AdminLogs.Warned then
                                    TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Warned,
                                        T.Webhooks.ActionsAdmin.title,
                                        T.Webhooks.ActionsAdmin.warned .. reason .. "\n > " .. PlayerInfo.PlayerName)
                                end
                            end
                        else
                            TriggerEvent("vorp:TipRight", T.Notify.empty, 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "unwarn" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.UnWarn')
                Wait(100)

                if AdminAllowed then
                    local staticID = data.current.info
                    local target = data.current.info2
                    local status = "unwarn"
                    TriggerServerEvent("vorp_admin:warns", target, status, staticID, 'vorp.staff.UnWarn')
                    if Config.AdminLogs.Unwarned then
                        TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Unwarned, T.Webhooks.ActionsAdmin.title,
                            T.Webhooks.ActionsAdmin.unwarned .. "\n > " .. staticID)
                    end
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "spectate" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Spectate')
                Wait(100)

                if AdminAllowed then
                    local target = data.current.info
                    TriggerServerEvent("vorp_admin:spectate", target, 'vorp.staff.Spectate')
                    if Config.AdminLogs.Spectate then
                        TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Spectate, T.Webhooks.ActionsAdmin.title,
                            T.Webhooks.ActionsAdmin.usedspectate .. "\n > " .. PlayerInfo.PlayerName)
                    end
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
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
            label = T.Menus.SubAdvancedActionOptions.playerKick,
            value = 'kick',
            desc = T.Menus.SubAdvancedActionOptions.playerKick_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.Group,
            info2 = Player.serverId
        },
        {
            label = T.Menus.SubAdvancedActionOptions.playerBan,
            value = 'ban',
            desc = T.Menus.SubAdvancedActionOptions.playerBan_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.staticID,
            info2 = Player.Group,
            info3 = Player.serverId
        },
        {
            label = T.Menus.SubAdvancedActionOptions.playerUnBan,
            value = 'unban',
            desc = T.Menus.SubAdvancedActionOptions.playerUnBan_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.staticID
        },
        {
            label = T.Menus.SubAdvancedActionOptions.playerRespawn,
            value = 'respawn',
            desc = T.Menus.SubAdvancedActionOptions.playerRespawn_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.serverId
        },
        --[[         { -- cant use this as it requires source to be in game use vorp core command to whitelist
            label = T.Menus.SubAdvancedActionOptions.playerWhitelist,
            value = 'whitelist',
            desc = T.Menus.SubAdvancedActionOptions.playerWhitelist_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.serverId,
            info2 = Player.steamID
        }, ]]
        {
            label = T.Menus.SubAdvancedActionOptions.playerUnWhitelist,
            value = 'unwhitelist',
            desc = T.Menus.SubAdvancedActionOptions.playerUnWhitelist_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.serverId,
            info2 = Player.SteamId
        },
        {
            label = T.Menus.SubAdvancedActionOptions.playerSetJob,
            value = 'setjob',
            desc = T.Menus.SubAdvancedActionOptions.playerSetJob_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.serverId
        },
        {
            label = T.Menus.SubAdvancedActionOptions.playerSetGroup,
            value = 'setgroup',
            desc = T.Menus.SubAdvancedActionOptions.playerSetGroup_desc ..
                " " .. "<span style=color:MediumSeaGreen;>" .. Player.PlayerName .. "</span>",
            info = Player.serverId
        },
    }
    MenuData.Open('default', GetCurrentResourceName(), 'OpenAdvancedActions',
        {
            title    = T.Menus.DefaultsMenusTitle.menuTitle,
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
                    TriggerServerEvent("vorp_admin:respawnPlayer", target, 'vorp.staff.Respawn')
                    if Config.AdminLogs.Respawn then
                        TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Respawn, T.Webhooks.ActionsAdmin.title,
                            T.Webhooks.ActionsAdmin.usedrespawn .. "\n > " .. Player.PlayerName)
                    end
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "kick" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Kick')
                Wait(100)

                if AdminAllowed then
                    local targetGroup = data.current.info
                    local targetID = data.current.info2
                    local myInput = Inputs("input", T.Menus.DefaultsInputs.confirm,
                        T.Menus.SubAdvancedActionOptions.KickInput.placeholder,
                        T.Menus.SubAdvancedActionOptions.KickInput.title, "text",
                        T.Menus.SubAdvancedActionOptions.KickInput.errorMsg, "[A-Za-z0-9 ]{10,100}")
                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                        local reason = tostring(result)
                        if reason ~= "" then
                            if targetGroup ~= "user" then
                                TriggerEvent("vorp:TipRight", T.Notify.cantKickStaff, 4000)
                            else
                                TriggerServerEvent("vorp_admin:kick", targetID, reason, 'vorp.staff.Kick')
                                if Config.AdminLogs.Kick then
                                    TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Kick,
                                        T.Webhooks.ActionsAdmin.title,
                                        T.Webhooks.ActionsAdmin.usedkick ..
                                        "\n > " .. Player.PlayerName .. "\n: " .. reason)
                                end
                            end
                        else
                            TriggerEvent("vorp:TipRight", T.Notify.empty, 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "ban" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Ban')
                Wait(100)

                if AdminAllowed then
                    local group = data.current.info2
                    local staticID = data.current.info
                    local target = data.current.info3
                    local myInput = Inputs("input", T.Menus.DefaultsInputs.confirm,
                        T.Menus.SubAdvancedActionOptions.BanInput.placeholder,
                        T.Menus.SubAdvancedActionOptions.BanInput.title, "text",
                        T.Menus.SubAdvancedActionOptions.BanInput.errorMsg, "[A-Za-z0-9 ]{2,2}")

                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                        local time = tostring(result)
                        if time ~= "" then
                            if group ~= "user" then
                                TriggerEvent("vorp:TipRight", T.Notify.cantBanStaff, 4000)
                            else
                                TriggerServerEvent("vorp_admin:BanPlayer", target, staticID, time, 'vorp.staff.Ban')
                                if Config.AdminLogs.Ban then
                                    TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Ban,
                                        T.Webhooks.ActionsAdmin.title,
                                        T.Webhooks.ActionsAdmin.usedban .. "\n > " .. Player.PlayerName .. "\n: " .. time)
                                end
                            end
                        else
                            TriggerEvent("vorp:TipRight", T.Notify.empty, 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "unban" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Unban')
                Wait(100)

                if AdminAllowed then
                    local staticID = data.current.info
                    TriggerServerEvent("vorp_admin:UnBan", staticID, 'vorp.staff,Unban')
                    if Config.AdminLogs.Unban then
                        TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Unban, T.Webhooks.ActionsAdmin.title,
                            T.Webhooks.ActionsAdmin.usedunban .. "\n > " .. Player.PlayerName .. "\n: " .. staticID)
                    end
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
                --[[  elseif data.current.value == "whitelist" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Whitelist')
                Wait(100)

                if AdminAllowed then
                    local target = data.current.info
                    local staticID = data.current.info2
                    local type = "addWhiteList"
                    TriggerServerEvent("vorp_admin:Whitelist", target, staticID, type, 'vorp.staff.Whitelist')
                    TriggerEvent("vorp:TipRight", T.Notify.whiteApproved, 5000)
                    if Config.AdminLogs.Whitelist then
                        TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Whitelist, T.Webhooks.ActionsAdmin.title,
                            T.Webhooks.ActionsAdmin.usedwhitelist .. "\n > " .. Player.PlayerName .. "\n: " .. staticID)
                    end
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end ]]
            elseif data.current.value == "unwhitelist" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Unwhitelist')
                Wait(100)

                if AdminAllowed then
                    local target = data.current.info
                    local steam = data.current.info2
                    local type = "removewhitelist"
                    TriggerServerEvent("vorp_admin:Whitelist", target, steam, type, 'vorp.staff.Unwhitelist')
                    TriggerEvent("vorp:TipRight", T.Notify.whiteRemoved, 5000)
                    if Config.AdminLogs.Unwhitelist then
                        TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Unwhitelist,
                            T.Webhooks.ActionsAdmin.title,
                            T.Webhooks.ActionsAdmin.usedunwhitelist .. "\n > " .. Player.PlayerName .. "\n: " .. steam)
                    end
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "setgroup" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Setgroup')
                Wait(100)

                if AdminAllowed then
                    local target = data.current.info
                    local myInput = Inputs("input", T.Menus.DefaultsInputs.confirm,
                        T.Menus.SubAdvancedActionOptions.GroupInput.placeholder,
                        T.Menus.SubAdvancedActionOptions.GroupInput.title, "text",
                        T.Menus.SubAdvancedActionOptions.GroupInput.errorMsg, "[A-Za-z]{3,20}")
                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                        local result = tostring(cb)

                        if result ~= "" then
                            TriggerServerEvent("vorp_admin:setGroup", target, result, 'vorp.staff.Setgroup')
                            if Config.AdminLogs.Setgroup then
                                TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Setgroup,
                                    T.Webhooks.ActionsAdmin.title,
                                    T.Webhooks.ActionsAdmin.usedsetgroup ..
                                    "\n > " .. Player.PlayerName .. "\nGroup: " .. result)
                            end
                        else
                            TriggerEvent("vorp:TipRight", T.Notify.empty, 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "setjob" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Setjob')
                Wait(100)

                if AdminAllowed then
                    local target = data.current.info
                    local myInput = Inputs("input", T.Menus.DefaultsInputs.confirm,
                        T.Menus.SubAdvancedActionOptions.JobInput.placeholder,
                        T.Menus.SubAdvancedActionOptions.JobInput.title, "text",
                        T.Menus.SubAdvancedActionOptions.JobInput.errorMsg, "[A-Za-z0-9 ]{3,20}")

                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                        local result = tostring(cb)

                        if result ~= "" then
                            local splitstring = {}
                            for i in string.gmatch(result, "%S+") do
                                splitstring[#splitstring + 1] = i
                            end
                            local jobname = tostring(splitstring[1])
                            local jobgrade = tonumber(splitstring[2])
                            local joblabel = tostring(splitstring[3]) .. " " .. (tostring(splitstring[4]) or "")
                            if jobname and jobgrade and joblabel then
                                TriggerServerEvent("vorp_admin:setJob", target, jobname, jobgrade, joblabel,
                                    'vorp.staff.Setjob')
                                if Config.AdminLogs.Setjob then
                                    TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Setjob,
                                        T.Webhooks.ActionsAdmin.title,
                                        T.Webhooks.ActionsAdmin.usedsetjob ..
                                        "\n > " .. Player.PlayerName .. "\nJob:  " .. jobname .. " \nGrade: " .. jobgrade)
                                end
                            end
                        else
                            TriggerEvent("vorp:TipRight", T.Notify.empty, 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
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
    local elements = {
        { label = T.Menus.SubActionsAdminOptions.deleteMountHorse,    value = 'delhorse',       desc = T.Menus.SubActionsAdminOptions.deleteMountHorse_desc },
        { label = T.Menus.SubActionsAdminOptions.deleteMountWagon,    value = 'delwagon',       desc = T.Menus.SubActionsAdminOptions.deleteMountWagon_desc },
        { label = T.Menus.SubActionsAdminOptions.deleteWagonInRadius, value = 'delwagonradius', desc = T.Menus.SubActionsAdminOptions.deleteWagonInRadius_desc },
        { label = T.Menus.SubActionsAdminOptions.getCoords,           value = 'getcoords',      desc = T.Menus.SubActionsAdminOptions.getCoords_desc },
        { label = T.Menus.SubActionsAdminOptions.adminAnnounce,       value = 'announce',       desc = T.Menus.SubActionsAdminOptions.adminAnnounce_desc },
    }

    MenuData.Open('default', GetCurrentResourceName(), 'Actions',
        {
            title    = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext  = T.Menus.DefaultsMenusTitle.menuSubTitleAdmin,
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
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "delwagon" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.DeleteWagon')
                Wait(100)

                if AdminAllowed then
                    Delwagon()
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "delwagonradius" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.DeleteWagonsRadius')
                Wait(100)

                if AdminAllowed then
                    local myInput = Inputs("input", T.Menus.DefaultsInputs.confirm,
                        T.Menus.SubActionsAdminOptions.DelWagonRadiusInput.placeholder,
                        T.Menus.SubActionsAdminOptions.DelWagonRadiusInput.title, "number",
                        T.Menus.SubActionsAdminOptions.DelWagonRadiusInput.errorMsg, "[0-9]{1,2}")
                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                        local radius = result

                        if radius ~= "" then
                            TriggerEvent("vorp:deleteVehicle", radius)
                        else
                            TriggerEvent('vorp:TipRight', T.Notify.empty, 3000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "getcoords" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.GetCoords')
                Wait(100)

                if AdminAllowed then
                    OpenCoordsMenu()
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
                end
            elseif data.current.value == "announce" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", 'vorp.staff.Announce')
                Wait(100)

                if AdminAllowed then
                    local myInput = Inputs("input", T.Menus.DefaultsInputs.confirm,
                        T.Menus.SubActionsAdminOptions.AnnounceInput.placeholder,
                        T.Menus.SubActionsAdminOptions.AnnounceInput.title, "text",
                        T.Menus.SubActionsAdminOptions.AnnounceInput.errorMsg, "[A-Za-z0-9 ]{5,100}")

                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
                        local announce = result

                        if announce ~= "" and announce then
                            TriggerServerEvent("vorp_admin:announce", announce, 'vorp.staff.Announce')
                            if Config.AdminLogs.Announce then
                                TriggerServerEvent("vorp_admin:logs", Config.AdminLogs.Announce,
                                    T.Webhooks.ActionsAdmin.title,
                                    T.Webhooks.ActionsAdmin.usedannounce .. "\n > " .. announce)
                            end
                        else
                            TriggerEvent('vorp:TipRight', T.Notify.empty, 3000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperm, 4000)
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
        { label = T.Menus.SubCoordsMenu.getCoordsXYZ,  value = 'v2',      desc = T.Menus.SubCoordsMenu.getCoordsXYZ_desc },
        { label = T.Menus.SubCoordsMenu.getCoordsVec3, value = 'v3',      desc = T.Menus.SubCoordsMenu.getCoordsVec3_desc },
        { label = T.Menus.SubCoordsMenu.getCoordsVec4, value = 'v4',      desc = T.Menus.SubCoordsMenu.getCoordsVec4_desc },
        { label = T.Menus.SubCoordsMenu.getHeading,    value = 'heading', desc = T.Menus.SubCoordsMenu.getHeading_desc },
    }
    MenuData.Open('default', GetCurrentResourceName(), 'OpenCoordsMenu',
        {
            title    = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext  = T.Menus.DefaultsMenusTitle.menuSubTitleCoords,
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
            label = T.Menus.SubOfflineOptions.banOrUnban,
            value = 'bans',
            desc = T.Menus.SubOfflineOptions.banOrUnban_desc
        },
        {
            label = T.Menus.SubOfflineOptions.whiteOrUnwhite,
            value = 'whites',
            desc = T.Menus.SubOfflineOptions.whiteOrUnwhite_desc
        },
        {
            label = T.Menus.SubOfflineOptions.warnOrUnWarn,
            value = 'warn',
            desc = T.Menus.SubOfflineOptions.warnOrUnWarn_desc
        },
    }
    MenuData.Open('default', GetCurrentResourceName(), 'OffLine',
        {
            title    = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext  = T.Menus.DefaultsMenusTitle.menuSubTitleAdmin,
            align    = 'top-left',
            elements = elements,
            lastmenu = 'Admin',
        },

        function(data)
            if data.current == "backup" then
                _G[data.trigger]()
            end

            if data.current.value == "bans" then
                local myInput = Inputs("input", T.Menus.DefaultsInputs.confirm,
                    T.Menus.SubOfflineOptions.BanTypeInput.placeholder, T.Menus.SubOfflineOptions.BanTypeInput.title,
                    "text", T.Menus.SubOfflineOptions.BanTypeInput.errorMsg, "[A-Za-z0-9 ]{5,100}")
                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                    local result = cb
                    if result ~= "" then
                        local splitstring = {}
                        for i in string.gmatch(result, "%S+") do
                            splitstring[#splitstring + 1] = i
                        end
                        local type, StaticID, time = tostring(splitstring[1]), tonumber(splitstring[2]),
                            tostring(splitstring[3])
                        if type and StaticID and time then
                            if type == "ban" then
                                if StaticID and time then
                                    TriggerServerEvent("vorp_admin:BanOffline", StaticID, time, 'vorp.staff.Ban')
                                end
                            elseif type == "unban" then
                                TriggerServerEvent("vorp_admin:UnBan", StaticID, 'vorp.staff.Unban')
                            else
                                TriggerEvent("vorp:TipRight", T.Notify.incorrectType, 4000)
                            end
                        else
                            TriggerEvent("vorp:TipRight", T.Notify.missingArgument, 4000)
                        end
                    else
                        TriggerEvent("vorp:TipRight", T.Notify.empty, 4000)
                    end
                end)
            elseif data.current.value == "whites" then
                local myInput = Inputs("input", T.Menus.DefaultsInputs.confirm,
                    T.Menus.SubOfflineOptions.WhiteTypeInput.placeholder, T.Menus.SubOfflineOptions.WhiteTypeInput.title,
                    "text", T.Menus.SubOfflineOptions.WhiteTypeInput.errorMsg, "[A-Za-z0-9 ]{5,100}")
                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                    local result = cb
                    if result ~= "" then
                        local splitstring = {}
                        for i in string.gmatch(result, "%S+") do
                            splitstring[#splitstring + 1] = i
                        end
                        local type, steam = tostring(splitstring[1]), tostring(splitstring[2])
                        if type and steam then -- if empty dont run
                            if type == "whitelist" then
                                TriggerServerEvent("vorp_admin:Whitelistoffline", steam, type)
                                --[[ elseif type == "unwhitelist" then
                                TriggerServerEvent("vorp_admin:Whitelistoffline", steam, type) ]]
                            else
                                TriggerEvent("vorp:TipRight", T.Notify.incorrectType, 4000)
                            end
                        else
                            TriggerEvent("vorp:TipRight", T.Notify.missingArgument, 4000)
                        end
                    else
                        TriggerEvent("vorp:TipRight", T.Notify.empty, 4000)
                    end
                end)
            elseif data.current.value == "warn" then
                local myInput = Inputs("input", T.Menus.DefaultsInputs.confirm,
                    T.Menus.SubOfflineOptions.WarnTypeInput.placeholder, T.Menus.SubOfflineOptions.WarnTypeInput.title,
                    "text", T.Menus.SubOfflineOptions.WarnTypeInput.errorMsg, "[A-Za-z0-9 ]{5,100}")
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
                                TriggerEvent("vorp:TipRight", T.Notify.incorrectType, 4000)
                            end
                        else
                            TriggerEvent("vorp:TipRight", T.Notify.missingArgument, 4000)
                        end
                    else
                        TriggerEvent("vorp:TipRight", T.Notify.empty, 4000)
                    end
                end)
            end
        end,

        function(menu)
            menu.close()
        end)
end
