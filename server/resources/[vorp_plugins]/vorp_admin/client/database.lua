------------------------------------------------------------------------------------------------------------------
---------------------------------------- DATABASE ----------------------------------------------------------------
function DataBase()
    MenuData.CloseAll()
    local elements = {}
    local players = GetPlayers()

    for _, PlayersData in pairs(players) do
        elements[#elements + 1] = {

            label = PlayersData.PlayerName, value = "players",
            desc = _U("SteamName") .. "<span style=color:MediumSeaGreen;> "
                .. PlayersData.name .. "</span><br>" .. _U("ServerID") .. "<span style=color:MediumSeaGreen;>"
                .. PlayersData.serverId .. "</span><br>" .. _U("PlayerGroup") .. "<span style=color:MediumSeaGreen;>"
                .. PlayersData.Group .. "</span><br>" .. _U("PlayerJob") .. "<span style=color:MediumSeaGreen;>"
                .. PlayersData.Job .. "</span>" .. _U("Grade") .. "<span style=color:MediumSeaGreen;>"
                .. PlayersData.Grade .. "</span><br>" .. _U("Identifier") .. "<span style=color:MediumSeaGreen;>"
                .. PlayersData.SteamId .. "</span><br>" .. _U("PlayerMoney") .. "<span style=color:MediumSeaGreen;>"
                .. PlayersData.Money .. "</span><br>" .. _U("PlayerGold") .. "<span style=color:Gold;>"
                .. PlayersData.Gold .. "</span><br>" .. _U("PlayerStaticID") .. "<span style=color:Red;>"
                .. PlayersData.Gold .. "</span>", PlayerData = PlayersData
        }

    end

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U("MenuTitle"),
            subtext  = _U("MenuSubtitle2"),
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
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            end
        end,
        function(menu)
            menu.close()
        end)
end

function DatabasePlayers(PlayerData)
    MenuData.CloseAll()
    local elements = {
        { label = _U("give"), value = 'give', desc = _U("Give_desc") },
        { label = _U("remove"), value = 'remove', desc = _U("Remove_desc") },
    }
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U("MenuTitle"),
            subtext  = _U("MenuSubtitle2"),
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
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            end
            if data.current.value == "remove" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.OpenRemoveMenu")
                Wait(100)
                if AdminAllowed then
                    RemovePlayers(PlayerData)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
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
        { label = _U("showInventory"), value = 'inventory',
            desc = _U("showinventory_desc") ..
                "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span>",
            info = PlayerData.serverId },
        { label = _U("GiveItems"), value = 'addItem',
            desc = _U("giveitem_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span>",
            info = PlayerData.serverId },
        { label = _U("GiveWeapons"), value = 'addWeapon',
            desc = _U("giveweapon_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName,
            info = PlayerData.serverId },
        { label = _U("GiveMoneyGold"), value = 'addMoneygold',
            desc = _U("givemoney_desc") ..
                "<span style=color:MediumSeaGreen;>" ..
                PlayerData.PlayerName .. "</span><br><span> 0 FOR CASH 1 FOR GOLD THEN QUANTITY</span>",
            info = PlayerData.serverId },
        { label = _U("GiveHorse"), value = 'addHorse',
            desc = _U("givehorse_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span>",
            info = PlayerData.serverId },
        { label = _U("GiveWagon"), value = 'addWagon',
            desc = _U("givewagon_desc") .. "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span>",
            info = PlayerData.serverId },
    }

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U("MenuTitle"),
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
                    local myInput = {
                        type = "enableinput", -- dont touch
                        inputType = "input",
                        button = _U("confirm"), -- button name
                        placeholder = "NAME  QUANTITY", --placeholdername
                        style = "block", --- dont touch
                        attributes = {
                            inputHeader = "GIVE ITEM", -- header
                            type = "text", -- inputype text, number,date.etc if number comment out the pattern
                            pattern = "[A-Za-z0-9_ ]{3,60}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                            title = "DONT USE - and . or , comas", -- if input doesnt match show this message
                            style = "border-radius: 10px; background-color: ; border:none;", -- style  the inptup
                        }
                    }
                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                        local result = tostring(cb)
                        if result ~= "" then
                            local splitString = {}
                            for i in string.gmatch(result, "%S+") do
                                splitString[#splitString + 1] = i
                            end
                            local itemName, itemQuantity = tostring(splitString[1]), tonumber(splitString[2])
                            TriggerServerEvent("vorp_admin:givePlayer", targetID, type, itemName, itemQuantity)
                            if Config.DatabaseLogs.Giveitem then
                                TriggerServerEvent("vorp_admin:logs", Config.DatabaseLogs.Giveitem, _U("titledatabase"),
                                    _U("usedgiveitem") ..
                                    "\nPlayer: " ..
                                    PlayerData.PlayerName .. "\nitem: " .. itemName .. "\nQTY: " .. itemQuantity)
                            end
                        else
                            TriggerEvent("vorp:TipRight", _U("empty"), 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "addWeapon" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.GiveWeapons")
                Wait(100)
                if AdminAllowed then
                    local targetID = data.current.info
                    local myInput = {
                        type = "enableinput", -- dont touch
                        inputType = "input",
                        button = _U("confirm"), -- button name
                        placeholder = "WEAPON_MELEE_KNIFE", --placeholdername
                        style = "block", --- dont touch
                        attributes = {
                            inputHeader = "GIVE WEAPON", -- header
                            type = "text", -- inputype text, number,date.etc if number comment out the pattern
                            pattern = "[A-Za-z_ ]{5,60}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                            title = "DONT USE - and . or , comas", -- if input doesnt match show this message
                            style = "border-radius: 10px; background-color: ; border:none;", -- style  the inptup
                        }
                    }
                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                        local result = tostring(cb)
                        if result ~= "" then
                            local weaponName = result
                            local type = "weapon"
                            TriggerServerEvent("vorp_admin:givePlayer", targetID, type, weaponName)
                            if Config.DatabaseLogs.Giveweapon then
                                TriggerServerEvent("vorp_admin:logs", Config.DatabaseLogs.Giveweapon, _U("titledatabase")
                                    , _U("usedgiveweapon") ..
                                    "\nPlayer: " .. PlayerData.PlayerName .. "\nweapon: " .. weaponName)
                            end
                        else
                            TriggerEvent("vorp:TipRight", _U("empty"), 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "addMoneygold" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.GiveCurrency")
                Wait(100)
                if AdminAllowed then
                    local targetID = data.current.info
                    local type = "moneygold"
                    local myInput = {
                        type = "enableinput", -- dont touch
                        inputType = "input",
                        button = _U("confirm"), -- button name
                        placeholder = "CURRENCY QUANTITY", --placeholdername
                        style = "block", --- dont touch
                        attributes = {
                            inputHeader = "GIVE CURRENCY", -- header
                            type = "text", -- inputype text, number,date.etc if number comment out the pattern
                            pattern = "[0-9 ]{1,20}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                            title = "DONT USE - and . or , comas", -- if input doesnt match show this message
                            style = "border-radius: 10px; background-color: ; border:none;", -- style  the inptup
                        }
                    }

                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                        local result = tostring(cb)
                        if result ~= "" then
                            local splitString = {}
                            for i in string.gmatch(result, "%S+") do
                                splitString[#splitString + 1] = i
                            end
                            local moneyType, Quantity = tonumber(splitString[1]), tonumber(splitString[2])
                            TriggerServerEvent("vorp_admin:givePlayer", targetID, type, moneyType, Quantity)
                            if Config.DatabaseLogs.Givecurrency then
                                TriggerServerEvent("vorp_admin:logs", Config.DatabaseLogs.Givecurrency,
                                    _U("titledatabase")
                                    , _U("usedgivecurrency") ..
                                    "\nPlayer: " .. PlayerData.PlayerName .. "\ntype: " .. moneyType ..
                                    "\nQTY: " .. Quantity)
                            end
                        else
                            TriggerEvent("vorp:TipRight", _U("empty"), 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "addHorse" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.GiveHorse")
                Wait(100)
                if AdminAllowed then
                    local targetID = data.current.info
                    local type = "horse"
                    local myInput = {
                        type = "enableinput", -- dont touch
                        inputType = "input",
                        button = _U("confirm"), -- button name
                        placeholder = "HASH NAME SEX", --placeholdername
                        style = "block", --- dont touch
                        attributes = {
                            inputHeader = "GIVE HORSE", -- header
                            type = "text", -- inputype text, number,date.etc if number comment out the pattern
                            pattern = "[A-Za-z0-9_ ]{9,30}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                            title = "DONT USE - and . or , comas", -- if input doesnt match show this message
                            style = "border-radius: 10px; background-color: ; border:none;", -- style  the inptup
                        }
                    }
                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                        local result = tostring(cb)
                        if result ~= "" then
                            local splitString = {}
                            for i in string.gmatch(result, "%S+") do
                                splitString[#splitString + 1] = i
                            end
                            local Hashname, Horsename, Horsesex = tostring(splitString[1]), tostring(splitString[2]),
                                tonumber(splitString[3])
                            TriggerServerEvent("vorp_admin:givePlayer", targetID, type, Hashname, Horsename, Horsesex)
                            if Config.DatabaseLogs.Givehorse then
                                TriggerServerEvent("vorp_admin:logs", Config.DatabaseLogs.Givehorse, _U("titledatabase")
                                    , _U("usedgivehorse") ..
                                    "\nPlayer: " .. PlayerData.PlayerName .. "\nhorse: " .. Hashname)
                            end
                        else
                            TriggerEvent("vorp:TipRight", _U("empty"), 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "addWagon" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.GiveWagons")
                Wait(100)
                if AdminAllowed then
                    local targetID = data.current.info
                    local type = "wagon"
                    local myInput = {
                        type = "enableinput", -- dont touch
                        inputType = "input",
                        button = _U("confirm"), -- button name
                        placeholder = "MODEL NAME ", --placeholdername
                        style = "block", --- dont touch
                        attributes = {
                            inputHeader = "GIVE WAGON", -- header
                            type = "text", -- inputype text, number,date.etc if number comment out the pattern
                            pattern = "[A-Za-z0-9_ ]{9,30}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                            title = "DONT USE - and . or , comas", -- if input doesnt match show this message
                            style = "border-radius: 10px; background-color: ; border:none;", -- style  the inptup
                        }
                    }

                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                        local result = tostring(cb)
                        if result ~= "" then
                            local splitString = {}
                            for i in string.gmatch(result, "%S+") do
                                splitString[#splitString + 1] = i
                            end
                            local Modelname, Wagonname = tostring(splitString[1]), tostring(splitString[2])
                            TriggerServerEvent("vorp_admin:givePlayer", targetID, type, Modelname, Wagonname)
                            if Config.DatabaseLogs.Givewagon then
                                TriggerServerEvent("vorp_admin:logs", Config.DatabaseLogs.Givewagon, _U("titledatabase")
                                    , _U("usedgivewagon") ..
                                    "\nPlayer: " .. PlayerData.PlayerName .. "\nwagon: " .. Modelname)
                            end
                        else
                            TriggerEvent("vorp:TipRight", _U("empty"), 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "inventory" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.ShowInvGive")
                Wait(100)
                if AdminAllowed then
                    local TargetID = data.current.info
                    TriggerServerEvent("vorp_admin:checkInventory", TargetID)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
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
        { label = _U("showInventory"), value = 'showinventory',
            desc = _U("showinventory_desc") ..
                "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span>",
            info = PlayerData.serverId },
        { label = _U("Removemoney"), value = "clearmoney",
            desc = _U("removemoney_desc") ..
                "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span>",
            info = PlayerData.serverId },
        { label = _U("RemoveGold"), value = "cleargold",
            desc = _U("removegold_desc") ..
                "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span>",
            info = PlayerData.serverId },
        { label = _U("Clearallitems"), value = 'clearitems',
            desc = _U("clearallitems_desc") ..
                "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span> Inventory",
            info = PlayerData.serverId },
        { label = _U("Clearallweapons"), value = 'clearweapons',
            desc = _U("clearallweapons_desc") ..
                "<span style=color:MediumSeaGreen;>" .. PlayerData.PlayerName .. "</span> Inventory",
            info = PlayerData.serverId },
    }

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U("MenuTitle"),
            subtext  = _U("MenuSubTitle"),
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
                    TriggerServerEvent("vorp_admin:ClearCurrency", targetID, type)
                    if Config.DatabaseLogs.Clearmoney then
                        TriggerServerEvent("vorp_admin:logs", Config.DatabaseLogs.Clearmoney, _U("titledatabase")
                            , _U("usedclearmoney") ..
                            "\nPlayer: " .. PlayerData.PlayerName .. "\nplayerID: " .. targetID .. "\ntype: " .. type)
                    end
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "cleargold" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.RemoveAllGold")
                Wait(100)
                if AdminAllowed then
                    local targetID = data.current.info
                    local type = "gold"
                    TriggerServerEvent("vorp_admin:ClearCurrency", targetID, type)
                    if Config.DatabaseLogs.Cleargold then
                        TriggerServerEvent("vorp_admin:logs", Config.DatabaseLogs.Cleargold, _U("titledatabase")
                            , _U("usedcleargold") ..
                            "\nPlayer: " .. PlayerData.PlayerName .. "\nplayerID: " .. targetID .. "\ntype: " .. type)
                    end
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "clearitems" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.RemoveAllItems")
                Wait(100)
                if AdminAllowed then
                    local targetID = data.current.info
                    local type = "items"
                    local myInput = {
                        type = "enableinput", -- dont touch
                        inputType = "input",
                        button = _U("confirm"), -- button name
                        placeholder = " yes or no ", --placeholdername
                        style = "block", --- dont touch
                        attributes = {
                            inputHeader = "ARE YOU SURE?", -- header
                            type = "text", -- inputype text, number,date.etc if number comment out the pattern
                            pattern = "[A-Za-z]+", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                            title = "DONT USE - and . or , comas", -- if input doesnt match show this message
                            style = "border-radius: 10px; background-color: ; border:none;", -- style  the inptup
                        }
                    }
                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                        local result = tostring(cb)
                        if result ~= "" then
                            if result == "yes" then
                                TriggerServerEvent("vorp_admin:ClearAllItems", type, targetID)
                                if Config.DatabaseLogs.Clearitems then
                                    TriggerServerEvent("vorp_admin:logs", Config.DatabaseLogs.Clearitems,
                                        _U("titledatabase")
                                        , _U("usedclearitems") ..
                                        "\nPlayer: " .. PlayerData.PlayerName .. "\nplayerID: " .. targetID)
                                end
                            end
                        else
                            TriggerEvent("vorp:TipRight", _U("empty"), 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end

            elseif data.current.value == "clearweapons" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.RemoveAllWeapons")
                Wait(100)
                if AdminAllowed then
                    local targetID = data.current.info
                    local type = "weapons"

                    local myInput = {
                        type = "enableinput", -- dont touch
                        inputType = "input",
                        button = _U("confirm"), -- button name
                        placeholder = " yes or no ", --placeholdername
                        style = "block", --- dont touch
                        attributes = {
                            inputHeader = "ARE YOU SURE?", -- header
                            type = "text", -- inputype text, number,date.etc if number comment out the pattern
                            pattern = "[A-Za-z]+", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
                            title = "DONT USE - and . or , comas", -- if input doesnt match show this message
                            style = "border-radius: 10px; background-color: ; border:none;", -- style  the inptup
                        }
                    }
                    TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                        local result = tostring(cb)
                        if result ~= "" then
                            if result == "yes" then
                                TriggerServerEvent("vorp_admin:ClearAllItems", type, targetID)
                                if Config.DatabaseLogs.Clearweapons then
                                    TriggerServerEvent("vorp_admin:logs", Config.DatabaseLogs.Clearweapons,
                                        _U("titledatabase")
                                        , _U("usedclearweapons") ..
                                        "\nPlayer: " .. PlayerData.PlayerName .. "\nplayerID: " .. targetID)
                                end
                            end
                        else
                            TriggerEvent("vorp:TipRight", _U("empty"), 4000)
                        end
                    end)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
                end
            elseif data.current.value == "showinventory" then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.ShowInvRemove")
                Wait(100)
                if AdminAllowed then
                    local TargetID = data.current.info
                    TriggerServerEvent("vorp_admin:checkInventory", TargetID)
                else
                    TriggerEvent("vorp:TipRight", _U("noperms"), 4000)
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

        elements[#elements + 1] = { label = dataItems.label ..
            " <span style='margin-left:10px; color: Yellow;'>" .. dataItems.count .. '</span>', value = "",
            desc = dataItems.label }
    end
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title    = _U("MenuTitle"),
            subtext  = _U("Playerinventory"),
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
