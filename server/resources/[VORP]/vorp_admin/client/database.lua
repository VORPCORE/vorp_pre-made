local T = Translation.Langs[Config.Lang]

------------------------------------------------------------------------------------------------------------------
---------------------------------------- DATABASE ----------------------------------------------------------------
function DataBase()
    MenuData.CloseAll()
    local elements = {}
    VORP.Callback.TriggerAsync("vorp_admin:Callback:getplayersinfo", function(result)
        if not result then
            return
        end
        local players = result

        for _, PlayersData in pairs(players) do
            elements[#elements + 1] = {
                label = PlayersData.PlayerName,
                value = "players",
                desc = T.Menus.MainPlayerStatus.playerSteamName .. "<span style=color:MediumSeaGreen;> "
                    ..
                    PlayersData.name ..
                    "</span><br>" ..
                    T.Menus.MainPlayerStatus.playerServerID .. " " .. "<span style=color:MediumSeaGreen;>"
                    ..
                    PlayersData.serverId ..
                    "</span><br>" .. T.Menus.MainPlayerStatus.playerGroup .. " " .. "<span style=color:MediumSeaGreen;>"
                    ..
                    PlayersData.Group ..
                    "</span><br>" .. T.Menus.MainPlayerStatus.playerJob .. " " .. "<span style=color:MediumSeaGreen;>"
                    .. PlayersData.Job ..
                    "</span>" .. T.Menus.MainPlayerStatus.playerGrade .. " " .. "<span style=color:MediumSeaGreen;>"
                    ..
                    PlayersData.Grade ..
                    "</span><br>" ..
                    T.Menus.MainPlayerStatus.playerIdentifier .. " " .. "<span style=color:MediumSeaGreen;>"
                    ..
                    PlayersData.SteamId ..
                    "</span><br>" .. T.Menus.MainPlayerStatus.playerMoney .. " " .. "<span style=color:MediumSeaGreen;>"
                    .. PlayersData.Money ..
                    "</span><br>" .. T.Menus.MainPlayerStatus.playerGold .. " " .. "<span style=color:Gold;>"
                    .. PlayersData.Gold ..
                    "</span><br>" .. T.Menus.MainPlayerStatus.playerStaticID .. " " .. "<span style=color:Red;>"
                    .. PlayersData.staticID ..
                    "</span><br>" .. T.Menus.MainPlayerStatus.playerWhitelist .. " " .. "<span style=color:Gold;>"
                    .. PlayersData.WLstatus ..
                    "</span><br>" .. T.Menus.MainPlayerStatus.playerWarnings .. " " .. "<span style=color:Gold;>"
                    .. PlayersData.warns .. "</span>",
                PlayerData = PlayersData
            }
        end

        MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
            {
                title    = T.Menus.DefaultsMenusTitle.menuTitle,
                subtext  = T.Menus.DefaultsMenusTitle.menuSubTitleDatabase,
                align    = 'top-left',
                elements = elements,
                lastmenu = 'OpenMenu',
            },
            function(data)
                if data.current == "backup" then
                    _G[data.trigger]()
                end
                if data.current.value == "players" then
                    TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.OpenDatabase")
                    Wait(100)
                    if AdminAllowed then
                        DatabasePlayers(data.current.PlayerData)
                    else
                        TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                    end
                end
            end,
            function(menu)
                menu.close()
            end)
    end, { search = "all" })
end

function DatabasePlayers(PlayerData)
    MenuData.CloseAll()
    local elements = {
        { label = T.Menus.MainDatabaseOptions.give,   value = 'give',   desc = T.Menus.MainDatabaseOptions.give_desc },
        { label = T.Menus.MainDatabaseOptions.remove, value = 'remove', desc = T.Menus.MainDatabaseOptions.remove_desc },
    }
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext  = T.Menus.DefaultsMenusTitle.menuSubTitleDatabase,
            align    = 'top-left',
            elements = elements,
            lastmenu = 'DataBase', --Go back
        },
        function(data)
            if data.current == "backup" then
                _G[data.trigger]()
            end
            if data.current.value == "give" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.OpenGiveMenu")
                Wait(100)
                if AdminAllowed then
                    GivePlayers(PlayerData)
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                end
            end
            if data.current.value == "remove" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.OpenRemoveMenu")
                Wait(100)
                if AdminAllowed then
                    RemovePlayers(PlayerData)
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                end
            end
        end,

        function(menu)
            menu.close()
        end)
end

function GivePlayers(PlayerData)
    MenuData.CloseAll()
    local elements = {
        {
            label = T.Menus.SubDatabaseGiveOptions.showInventory,
            value = 'inventory',
            desc = T.Menus.SubDatabaseGiveOptions.showInventory_desc ..
            "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span>",
            info = PlayerData.serverId
        },
        {
            label = T.Menus.SubDatabaseGiveOptions.giveItem,
            value = 'addItem',
            desc = T.Menus.SubDatabaseGiveOptions.giveItem_desc ..
            "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span>",
            info = PlayerData.serverId
        },
        {
            label = T.Menus.SubDatabaseGiveOptions.giveWeapon,
            value = 'addWeapon',
            desc = T.Menus.SubDatabaseGiveOptions.giveWeapon_desc ..
            "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName,
            info = PlayerData.serverId
        },
        {
            label = T.Menus.SubDatabaseGiveOptions.giveMoneyOrGold,
            value = 'addMoneygold',
            desc = T.Menus.SubDatabaseGiveOptions.giveMoneyOrGold_desc ..
            "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span>",
            info = PlayerData.serverId
        },
        {
            label = T.Menus.SubDatabaseGiveOptions.giveHorse,
            value = 'addHorse',
            desc = T.Menus.SubDatabaseGiveOptions.giveHorse_desc ..
            "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span>",
            info = PlayerData.serverId
        },
        {
            label = T.Menus.SubDatabaseGiveOptions.giveWagon,
            value = 'addWagon',
            desc = T.Menus.SubDatabaseGiveOptions.giveWagon_desc ..
            "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span>",
            info = PlayerData.serverId
        },
    }

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext  = "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span>",
            align    = 'top-left',
            elements = elements,
            lastmenu = 'DataBase', --Go back
        },
        function(data)
            if data.current == "backup" then
                _G[data.trigger]()
            end
            if data.current.value == "addItem" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.Giveitems")
                Wait(100)
                if AdminAllowed then
                    local targetID = data.current.info
                    local type = "item"
                    local myInput = Inputs("input", T.Menus.DefaultsInputs.confirm,
                        T.Menus.SubDatabaseGiveOptions.GiveItemInput.placeholder,
                        T.Menus.SubDatabaseGiveOptions.GiveItemInput.title, "text",
                        T.Menus.SubDatabaseGiveOptions.GiveItemInput.errorMsg, "[A-Za-z0-9_ ]{3,60}")
                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                        local result = tostring(cb)
                        if result ~= "" then
                            local splitString = {}
                            for i in string.gmatch(result, "%S+") do
                                splitString[#splitString + 1] = i
                            end
                            local itemName, itemQuantity = tostring(splitString[1]), tonumber(splitString[2])
                            if not itemQuantity then
                                itemQuantity = 1
                            end
                            if itemName and itemQuantity then
                                TriggerServerEvent("vorp_admin:givePlayer", targetID, type, itemName, itemQuantity, nil,
                                    "vorp.staff.Giveitems")
                            else
                                TriggerEvent("vorp:TipRight", T.Notify.missingArgument, 4000)
                            end
                            if Config.DatabaseLogs.Giveitem then
                                TriggerServerEvent("vorp_admin:logs", Config.DatabaseLogs.Giveitem,
                                    T.Webhooks.ActionDatabase.title,
                                    T.Webhooks.ActionDatabase.usedgiveitem ..
                                    "\nPlayer: " ..
                                    PlayerData.PlayerName .. "\nItem: " .. itemName .. "\nQTY: " .. itemQuantity)
                            end
                        else
                            TriggerEvent("vorp:TipRight", T.Notify.empty, 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                end
            elseif data.current.value == "addWeapon" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.GiveWeapons")
                Wait(100)
                if AdminAllowed then
                    local targetID = data.current.info
                    local myInput = Inputs("input", T.Menus.DefaultsInputs.confirm,
                        T.Menus.SubDatabaseGiveOptions.GiveWeaponInput.placeholder,
                        T.Menus.SubDatabaseGiveOptions.GiveWeaponInput.title, "text",
                        T.Menus.SubDatabaseGiveOptions.GiveWeaponInput.errorMsg, "[A-Za-z_ ]{5,60}")
                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                        local result = tostring(cb)
                        if result ~= "" then
                            local weaponName = result
                            local type = "weapon"
                            TriggerServerEvent("vorp_admin:givePlayer", targetID, type, weaponName, nil, nil,
                                "vorp.staff.GiveWeapons")
                            if Config.DatabaseLogs.Giveweapon then
                                TriggerServerEvent("vorp_admin:logs", Config.DatabaseLogs.Giveweapon,
                                    T.Webhooks.ActionDatabase.title,
                                    T.Webhooks.ActionDatabase.usedgiveweapon ..
                                    "\nPlayer: " .. PlayerData.PlayerName .. "\nWeapon: " .. weaponName)
                            end
                        else
                            TriggerEvent("vorp:TipRight", T.Notify.empty, 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                end
            elseif data.current.value == "addMoneygold" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.GiveCurrency")
                Wait(100)
                if AdminAllowed then
                    local targetID = data.current.info
                    local type = "moneygold"
                    local myInput = Inputs("input", T.Menus.DefaultsInputs.confirm,
                        T.Menus.SubDatabaseGiveOptions.GiveCurrencyInput.placeholder,
                        T.Menus.SubDatabaseGiveOptions.GiveCurrencyInput.title, "text",
                        T.Menus.SubDatabaseGiveOptions.GiveCurrencyInput.errorMsg, "[0-9 ]{1,20}")
                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                        local result = tostring(cb)
                        if result ~= "" then
                            local splitString = {}
                            for i in string.gmatch(result, "%S+") do
                                splitString[#splitString + 1] = i
                            end
                            local moneyType, Quantity = tonumber(splitString[1]), tonumber(splitString[2])
                            if moneyType and Quantity then
                                TriggerServerEvent("vorp_admin:givePlayer", targetID, type, moneyType, Quantity, nil,
                                    "vorp.staff.GiveCurrency")
                            else
                                TriggerEvent("vorp:TipRight", T.Notify.missingArgument, 4000)
                            end
                            if Config.DatabaseLogs.Givecurrency then
                                TriggerServerEvent("vorp_admin:logs", Config.DatabaseLogs.Givecurrency,
                                    T.Webhooks.ActionDatabase.title,
                                    T.Webhooks.ActionDatabase.usedgivecurrency ..
                                    "\nPlayer: " ..
                                    PlayerData.PlayerName .. "\nCurrency: " .. moneyType .. "\nQTY: " .. Quantity)
                            end
                        else
                            TriggerEvent("vorp:TipRight", T.Notify.empty, 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                end
            elseif data.current.value == "addHorse" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.GiveHorse")
                Wait(100)
                if AdminAllowed then
                    local targetID = data.current.info
                    local type = "horse"
                    local myInput = Inputs("input", T.Menus.DefaultsInputs.confirm,
                        T.Menus.SubDatabaseGiveOptions.GiveHorseInput.placeholder,
                        T.Menus.SubDatabaseGiveOptions.GiveHorseInput.title, "text",
                        T.Menus.SubDatabaseGiveOptions.GiveHorseInput.errorMsg, "[A-Za-z0-9_ ]{9,30}")
                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                        local result = tostring(cb)
                        if result ~= "" then
                            local splitString = {}
                            for i in string.gmatch(result, "%S+") do
                                splitString[#splitString + 1] = i
                            end
                            local Hashname, Horsename, Horsesex = tostring(splitString[1]), tostring(splitString[2]),
                                tonumber(splitString[3])
                            if Hashname and Horsename and Horsesex then
                                TriggerServerEvent("vorp_admin:givePlayer", targetID, type, Hashname, Horsename, Horsesex,
                                    "vorp.staff.GiveHorse")
                            else
                                TriggerEvent("vorp:TipRight", T.Notify.missingArgument, 4000)
                            end
                            if Config.DatabaseLogs.Givehorse then
                                TriggerServerEvent("vorp_admin:logs", Config.DatabaseLogs.Givehorse,
                                    T.Webhooks.ActionDatabase.title,
                                    T.Webhooks.ActionDatabase.usedgivehorse ..
                                    "\nPlayer: " .. PlayerData.PlayerName .. "\nHorse: " .. Hashname)
                            end
                        else
                            TriggerEvent("vorp:TipRight", T.Notify.empty, 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                end
            elseif data.current.value == "addWagon" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.GiveWagons")
                Wait(100)
                if AdminAllowed then
                    local targetID = data.current.info
                    local type = "wagon"
                    local myInput = Inputs("input", T.Menus.DefaultsInputs.confirm,
                        T.Menus.SubDatabaseGiveOptions.GiveWagonInput.placeholder,
                        T.Menus.SubDatabaseGiveOptions.GiveWagonInput.title, "text",
                        T.Menus.SubDatabaseGiveOptions.GiveWagonInput.errorMsg, "[A-Za-z0-9_ ]{9,30}")
                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                        local result = tostring(cb)
                        if result ~= "" then
                            local splitString = {}
                            for i in string.gmatch(result, "%S+") do
                                splitString[#splitString + 1] = i
                            end
                            local Modelname, Wagonname = tostring(splitString[1]), tostring(splitString[2])
                            if Modelname and Wagonname then
                                TriggerServerEvent("vorp_admin:givePlayer", targetID, type, Modelname, Wagonname, nil,
                                    "vorp.staff.GiveWagons")
                            else
                                TriggerEvent("vorp:TipRight", T.Notify.missingArgument, 4000)
                            end
                            if Config.DatabaseLogs.Givewagon then
                                TriggerServerEvent("vorp_admin:logs", Config.DatabaseLogs.Givewagon,
                                    T.Webhooks.ActionDatabase.title,
                                    T.Webhooks.ActionDatabase.usedgivewagon ..
                                    "\nPlayer: " .. PlayerData.PlayerName .. "\nWagon: " .. Modelname)
                            end
                        else
                            TriggerEvent("vorp:TipRight", T.Notify.empty, 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                end
            elseif data.current.value == "inventory" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.ShowInvGive")
                Wait(100)
                if AdminAllowed then
                    local TargetID = data.current.info
                    TriggerServerEvent("vorp_admin:checkInventory", TargetID, "vorp.staff.ShowInvGive")
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                end
            end
        end,

        function(menu)
            menu.close()
        end)
end

function RemovePlayers(PlayerData)
    MenuData.CloseAll()

    local elements = {
        {
            label = T.Menus.SubDatabaseRemoveOptions.showInventory,
            value = 'showinventory',
            desc = T.Menus.SubDatabaseRemoveOptions.showInventory_desc ..
            "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span>",
            info = PlayerData.serverId
        },
        {
            label = T.Menus.SubDatabaseRemoveOptions.removeMoney,
            value = "clearmoney",
            desc = T.Menus.SubDatabaseRemoveOptions.removeMoney_desc ..
            "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span>",
            info = PlayerData.serverId
        },
        {
            label = T.Menus.SubDatabaseRemoveOptions.removeGold,
            value = "cleargold",
            desc = T.Menus.SubDatabaseRemoveOptions.removeGold_desc ..
            "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span>",
            info = PlayerData.serverId
        },
        {
            label = T.Menus.SubDatabaseRemoveOptions.clearAllItems,
            value = 'clearitems',
            desc = T.Menus.SubDatabaseRemoveOptions.clearAllItems_desc ..
            "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span>",
            info = PlayerData.serverId
        },
        {
            label = T.Menus.SubDatabaseRemoveOptions.clearAllWeapons,
            value = 'clearweapons',
            desc = T.Menus.SubDatabaseRemoveOptions.clearAllWeapons_desc ..
            "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span>",
            info = PlayerData.serverId
        },
    }

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext  = T.Menus.DefaultsMenusTitle.menuSubTitleDatabase,
            align    = 'top-left',
            elements = elements,
            lastmenu = 'DataBase', --Go back
        },
        function(data)
            if data.current == "backup" then
                _G[data.trigger]()
            end
            if data.current.value == "clearmoney" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.RemoveAllMoney")
                Wait(100)
                if AdminAllowed then
                    local targetID = data.current.info
                    local type = "money"
                    TriggerServerEvent("vorp_admin:ClearCurrency", targetID, type, "vorp.staff.RemoveAllMoney")
                    if Config.DatabaseLogs.Clearmoney then
                        TriggerServerEvent("vorp_admin:logs", Config.DatabaseLogs.Clearmoney,
                            T.Webhooks.ActionDatabase.title,
                            T.Webhooks.ActionDatabase.usedclearmoney ..
                            "\nPlayer: " .. PlayerData.PlayerName .. "\nID: " .. targetID .. "\nCurrency: " .. type)
                    end
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                end
            elseif data.current.value == "cleargold" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.RemoveAllGold")
                Wait(100)
                if AdminAllowed then
                    local targetID = data.current.info
                    local type = "gold"
                    TriggerServerEvent("vorp_admin:ClearCurrency", targetID, type, "vorp.staff.RemoveAllGold")
                    if Config.DatabaseLogs.Cleargold then
                        TriggerServerEvent("vorp_admin:logs", Config.DatabaseLogs.Cleargold,
                            T.Webhooks.ActionDatabase.title,
                            T.Webhooks.ActionDatabase.usedcleargold ..
                            "\nPlayer: " .. PlayerData.PlayerName .. "\nID: " .. targetID .. "\nCurrency: " .. type)
                    end
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                end
            elseif data.current.value == "clearitems" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.RemoveAllItems")
                Wait(100)
                if AdminAllowed then
                    local targetID = data.current.info
                    local type = "items"
                    local myInput = Inputs("input", T.Menus.DefaultsInputs.confirm,
                        T.Menus.SubDatabaseRemoveOptions.RemoveAllItemInput.placeholder,
                        T.Menus.SubDatabaseRemoveOptions.RemoveAllItemInput.title, "text",
                        T.Menus.SubDatabaseRemoveOptions.RemoveAllItemInput.errorMsg, "[A-Za-z]+")
                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                        local result = tostring(cb)
                        if result ~= "" then
                            if result == "yes" then
                                TriggerServerEvent("vorp_admin:ClearAllItems", type, targetID,
                                    "vorp.staff.RemoveAllItems")
                                if Config.DatabaseLogs.Clearitems then
                                    TriggerServerEvent("vorp_admin:logs", Config.DatabaseLogs.Clearitems,
                                        T.Webhooks.ActionDatabase.title,
                                        T.Webhooks.ActionDatabase.usedclearitems ..
                                        "\nPlayer: " .. PlayerData.PlayerName .. "\nID: " .. targetID)
                                end
                            else
                                TriggerEvent("vorp:TipRight", T.Notify.actionCancell, 4000)
                            end
                        else
                            TriggerEvent("vorp:TipRight", T.Notify.empty, 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                end
            elseif data.current.value == "clearweapons" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.RemoveAllWeapons")
                Wait(100)
                if AdminAllowed then
                    local targetID = data.current.info
                    local type = "weapons"
                    local myInput = Inputs("input", T.Menus.DefaultsInputs.confirm,
                        T.Menus.SubDatabaseRemoveOptions.RemoveAllWeaponInput.placeholder,
                        T.Menus.SubDatabaseRemoveOptions.RemoveAllWeaponInput.title, "text",
                        T.Menus.SubDatabaseRemoveOptions.RemoveAllWeaponInput.errorMsg, "[A-Za-z]+")
                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                        local result = tostring(cb)
                        if result ~= "" then
                            if result == "yes" then
                                TriggerServerEvent("vorp_admin:ClearAllItems", type, targetID,
                                    "vorp.staff.RemoveAllWeapons")
                                if Config.DatabaseLogs.Clearweapons then
                                    TriggerServerEvent("vorp_admin:logs", Config.DatabaseLogs.Clearweapons,
                                        T.Webhooks.ActionDatabase.title,
                                        T.Webhooks.ActionDatabase.usedclearweapons ..
                                        "\nPlayer: " .. PlayerData.PlayerName .. "\nID: " .. targetID)
                                end
                            else
                                TriggerEvent("vorp:TipRight", T.Notify.actionCancell, 4000)
                            end
                        else
                            TriggerEvent("vorp:TipRight", T.Notify.empty, 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                end
            elseif data.current.value == "showinventory" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.ShowInvRemove")
                Wait(100)
                if AdminAllowed then
                    local TargetID = data.current.info
                    TriggerServerEvent("vorp_admin:checkInventory", TargetID, "vorp.staff.ShowInvRemove")
                else
                    TriggerEvent("vorp:TipRight", T.Notify.noperms, 4000)
                end
            end
        end,
        function(menu)
            menu.close()
        end)
end

function OpenInvnetory(inventorydata)
    MenuData.CloseAll()
    local elements = {}

    for _, dataItems in pairs(inventorydata) do -- to prevent menu from opening empty and give errors
        elements[#elements + 1] = {
            label = dataItems.label .. " <span style='margin-left:10px; color: Yellow;'>" .. dataItems.count .. '</span>',
            value = "",
            desc = dataItems.label
        }
    end
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = T.Menus.DefaultsMenusTitle.menuTitle,
            subtext  = T.Menus.DefaultsMenusTitle.menuSubTitleDatabase,
            align    = 'top-left',
            elements = elements,
            lastmenu = 'DataBase',
        },
        function(data)
            if data.current == "backup" then
                _G[data.trigger]()
            end
        end,
        function(menu)
            menu.close()
        end)
end
