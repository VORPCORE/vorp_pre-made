---@diagnostic disable: undefined-global
------------------------------------------------------------------------------------------------------
------------------------------------------ USERS MENU ------------------------------------------------

local hideUI = false

local T = Translation.Langs[Config.Lang]

function OpenUsersMenu()
    MenuData.CloseAll()
    local elements = {
        { label = T.Menus.MainUserOptions.playerReport,              value = 'report',       desc = T.Menus.MainUserOptions.playerReport_desc },
        { label = T.Menus.MainUserOptions.playerRequestStaff,        value = 'requeststaff', desc = T.Menus.MainUserOptions.playerRequestStaff_desc },
        { label = T.Menus.MainUserOptions.selfShowInfo,              value = 'showinfo',     desc = T.Menus.MainUserOptions.selfShowInfo_desc },
        { label = T.Menus.MainUserOptions.playerCommands,            value = 'commands',     desc = T.Menus.MainUserOptions.playerCommands_desc },
        { label = T.Menus.MainUserOptions.playerWalkAndClothesStyle, value = 'menu',         desc = T.Menus.MainUserOptions.playerWalkAndClothesStyle_desc },
    }
    if Config.EnablePlayerlist then
        elements[#elements + 1] = {
            label = T.Menus.DefaultsMenusTitle.menuSubTitleScoreboard,
            value = 'scoreboard',
            desc = T.Menus.DefaultsMenusTitle.menuSubTitleScoreboard,
        }
    end

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext  = T.Menus.DefaultsMenusTitle.menuSubTitleScoreboard,
            align    = 'top-left',
            elements = elements,
        },
        function(data, menu)
            if data.current == "backup" then
                _G[data.trigger]()
            end

            if data.current.value == "scoreboard" then
                ScoreBoard()
            elseif data.current.value == "report" then
                if not Config.useQWreports then
                    Report()
                else
                    TriggerEvent("vorp_admin:CreateReport")
                end
            elseif data.current.value == "requeststaff" then
                RequestStaff()
            elseif data.current.value == "showinfo" then
                VORP.NotifyRightTip(T.Notify.notAvailable, 4000)
            elseif data.current.value == "commands" then
                OpenCommands()
            elseif data.current.value == "menu" then
                TriggerEvent("vorp_walkanim:OpenMenu")
                menu.close()
            end
        end,
        function(data, menu)
            menu.close()
        end)
end

function ScoreBoard()
    MenuData.CloseAll()
    local elements = {}

    -- local players = GetPlayers()
    VORP.Callback.TriggerAsync("vorp_admin:Callback:getplayersinfo", function(result)
        if not result then
            return
        end
        local players = result
        for key, playersInfo in pairs(players) do
            if Config.showUsersInfo == "showAll" then
                ShowInfo = "</span><br>" ..
                    T.Menus.MainPlayerStatus.playerServerID .. " " .. "<span style=color:MediumSeaGreen;>"
                    ..
                    playersInfo.serverId ..
                    "</span><br>" .. T.Menus.MainPlayerStatus.playerGroup .. " " .. "<span style=color:MediumSeaGreen;>"
                    ..
                    playersInfo.Group ..
                    "</span><br>" .. T.Menus.MainPlayerStatus.playerJob .. " " .. "<span style=color:MediumSeaGreen;> "
                    .. playersInfo.Job
            elseif Config.showUsersInfo == "showJob" then
                ShowInfo = "</span><br>" ..
                T.Menus.MainPlayerStatus.playerJob .. " " .. "<span style=color:MediumSeaGreen;> " .. playersInfo.Job
            elseif Config.showUsersInfo == "showGroup" then
                ShowInfo = "</span><br>" ..
                T.Menus.MainPlayerStatus.playerGroup .. " " .. "<span style=color:MediumSeaGreen;>" .. playersInfo.Group
            elseif Config.showUsersInfo == "showID" then
                ShowInfo = "</span><br>" ..
                T.Menus.MainPlayerStatus.playerServerID ..
                " " .. "<span style=color:MediumSeaGreen;>" .. playersInfo.serverId
            end
            elements[#elements + 1] = {
                label = playersInfo.PlayerName,
                value = "players",
                desc = ShowInfo
            }
        end

        MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
            {
                title    = T.Menus.DefaultsMenusTitle.menuTitle,
                subtext  = T.Menus.DefaultsMenusTitle.menuSubTitleScoreboard,
                align    = 'top-left',
                elements = elements,
                lastmenu = 'OpenUsersMenu', --Go back
            },
            function(data, menu)
                if data.current == "backup" then
                    _G[data.trigger]()
                end
            end,

            function(data, menu)
                menu.close()
            end)
    end, { search = "all" })
end

function Report()
    local player = GetPlayerServerId(tonumber(PlayerId()))
    local myInput = Inputs("textarea", T.Menus.DefaultsInputs.confirm, T.Menus.MainUserOptions.ReportInput.placeholder,
        T.Menus.MainUserOptions.ReportInput.title, "text", T.Menus.MainUserOptions.ReportInput.errorMsg,
        "[A-Za-z0-9 ]{10,100}")
    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(result)
        local report = tostring(result)
        if report and report ~= "" then
            if Config.ReportLogs then -- if nil dont send
                TriggerServerEvent("vorp_admin:logs", Config.ReportLogs.Reports, T.Webhooks.ActionScoreBoard.title,
                    T.Webhooks.ActionScoreBoard.playerreported .. report)
                VORP.NotifySimpleTop(T.Notify.reportTitle, T.Notify.reportSent, 3000)
                TriggerServerEvent("vorp_admin:alertstaff", player)
            end
        end
    end)
end

------ REQUEST STAFF ---------------------------------

local cooldown = false
local timer = Config.AlertCooldown

function RequestStaff()
    MenuData.CloseAll()
    local elements = {
        { label = T.Menus.SubUserOptions.needHelp,        value = "new",      desc = T.Menus.SubUserOptions.needHelp_desc },
        { label = T.Menus.SubUserOptions.foundBug,        value = "bug",      desc = T.Menus.SubUserOptions.foundBug_desc },
        { label = T.Menus.SubUserOptions.rulesBroken,     value = "rules",    desc = T.Menus.SubUserOptions.rulesBroken_desc },
        { label = T.Menus.SubUserOptions.someoneCheating, value = "cheating", desc = T.Menus.SubUserOptions.someoneCheating_desc },
    }
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext  = T.Menus.DefaultsMenusTitle.menuSubTitleRequestStaff,
            align    = 'top-left',
            elements = elements,
            lastmenu = 'OpenUsersMenu', --Go back
        },
        function(data, menu)
            local player = GetPlayerServerId(tonumber(PlayerId()))
            if data.current == "backup" then
                _G[data.trigger]()
            end
            if data.current.value == "new" and not cooldown then
                TriggerServerEvent("vorp_admin:requeststaff", player, "new")
                VORP.NotifyRightTip(T.Notify.requestSent, 4000)
                TriggerServerEvent("vorp_admin:logs", Config.ReportLogs.RequestStaff, T.Webhooks.ActionScoreBoard.title,
                    T.Webhooks.ActionScoreBoard.requeststaff_disc)
                cooldown = true
            elseif data.current.value == "bug" and not cooldown then
                TriggerServerEvent("vorp_admin:requeststaff", player, "bug")
                VORP.NotifyRightTip(T.Notify.requestSent, 4000)
                TriggerServerEvent("vorp_admin:logs", Config.ReportLogs.BugReport, T.Webhooks.ActionScoreBoard.title,
                    T.Webhooks.ActionScoreBoard.requeststaff_bug)
                cooldown = true
            elseif data.current.value == "rules" and not cooldown then
                TriggerServerEvent("vorp_admin:requeststaff", player, "rules")
                VORP.NotifyRightTip(T.Notify.requestSent, 4000)
                TriggerServerEvent("vorp_admin:logs", Config.ReportLogs.RulesBroken, T.Webhooks.ActionScoreBoard.title,
                    T.Webhooks.ActionScoreBoard.requeststaff_rulesbroke)
                cooldown = true
            elseif data.current.value == "cheating" and not cooldown then
                TriggerServerEvent("vorp_admin:requeststaff", player, "cheating")
                VORP.NotifyRightTip(T.Notify.requestSent, 4000)
                TriggerServerEvent("vorp_admin:logs", Config.ReportLogs.Cheating, T.Webhooks.ActionScoreBoard.title,
                    T.Webhooks.ActionScoreBoard.requeststaff_cheating)
                cooldown = true
            elseif cooldown then
                VORP.NotifyRightTip(T.Notify.waitToReportAgain .. " " .. timer, 5000)
            end
        end,

        function(data, menu)
            menu.close()
        end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if timer >= 0 and cooldown then
            Citizen.Wait(1000)
            if timer > 0 then
                timer = timer - 1
            end
            if 0 >= timer and cooldown then
                cooldown = false
                timer = Config.AlertCooldown
            end
        end
    end
end)

---------------------------------------------------------------------------------------------------------

function OpenCommands()
    MenuData.CloseAll()
    local elements = {
        { label = T.Menus.SubUserOptions.delHorse,        value = 'delhorse',   desc = T.Menus.SubUserOptions.delHorse_desc },
        { label = T.Menus.SubUserOptions.delWagon,        value = 'delwagon',   desc = T.Menus.SubUserOptions.delWagon_desc },
        { label = T.Menus.SubUserOptions.hideUi,          value = 'hideui',     desc = T.Menus.SubUserOptions.hideUi_desc },
        { label = T.Menus.SubUserOptions.cancelAnimation, value = 'cancelanim', desc = T.Menus.SubUserOptions.cancelAnimation_desc },
    }

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext  = T.Menus.DefaultsMenusTitle.menuSubTitleCommands,
            align    = 'top-left',
            elements = elements,
            lastmenu = 'OpenUsersMenu', --Go back
        },
        function(data, menu)
            if data.current == "backup" then
                _G[data.trigger]()
            end

            if data.current.value == "delhorse" then
                DelHorse()
            elseif data.current.value == "delwagon" then
                Delwagon()
            elseif data.current.value == "hideui" then
                HideUI()
            elseif data.current.value == "cancelanim" then
                local player = PlayerPedId()
                ClearPedTasksImmediately(player)
            end
        end,
        function(data, menu)
            menu.close()
        end)
end

function DelHorse()
    local player = PlayerPedId()
    local mount  = GetMount(player)
    if IsPedOnMount(player) then
        DeleteEntity(mount)
    else
        TriggerEvent("vorp:TipRight", T.Notify.youNeedtoSeatead, 3000)
    end
end

function Delwagon()
    local player = PlayerPedId()
    local wagon = GetVehiclePedIsIn(player, true)

    if IsPedInAnyVehicle(player, true) then
        wagon = GetVehiclePedIsIn(player, true)
    end
    if DoesEntityExist(wagon) then
        DeleteVehicle(wagon)
        DeleteEntity(wagon)
        TriggerEvent('vorp:TipRight', T.Notify.youDeletedWagon, 3000)
    else
        TriggerEvent('vorp:TipRight', T.Notify.youNeedtoSeatead, 3000)
    end
end

function HideUI()
    if not hideUI then
        --ExecuteCommand("togglechat")
        DisplayRadar(false)
        DisplayHud(false)
        TriggerEvent("syn_displayrange", false)
        TriggerEvent("vorp:showUi", false)
        hideUI = true
    else
        -- ExecuteCommand("togglechat")
        DisplayRadar(true)
        DisplayHud(true)
        TriggerEvent("syn_displayrange", true)
        TriggerEvent("vorp:showUi", true)
        hideUI = false
    end
end
