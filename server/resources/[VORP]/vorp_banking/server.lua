local VorpCore = {}

TriggerEvent("getCore", function(core)
    VorpCore = core
end)

local VorpInv = exports.vorp_inventory:vorp_inventoryApi()

local T = TranslationBanking.Langs[Lang]

RegisterServerEvent('vorp_bank:getinfo')
AddEventHandler('vorp_bank:getinfo', function(name)
    local _source = source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local charidentifier = Character.charIdentifier
    local identifier = Character.identifier

    MySQL.query("SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @name",
        { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result)
            if result[1] then
                local money = result[1].money
                local gold = result[1].gold
                local invspace1 = result[1].invspace
                local bankinfo = { money = money, gold = gold, invspace = invspace1, name = name }

                TriggerClientEvent("vorp_bank:recinfo", _source, bankinfo)
            else -- if account dont exist create new one
                local Parameters = {
                    ['name'] = name,
                    ['identifier'] = identifier,
                    ['charidentifier'] = charidentifier,
                    ['money'] = 0,
                    ['gold'] = 0,
                    ['invspace'] = 10
                }
                MySQL.insert(
                "INSERT INTO bank_users ( `name`,`identifier`,`charidentifier`,`money`,`gold`,`invspace`) VALUES ( @name, @identifier, @charidentifier, @money, @gold, @invspace)",
                    Parameters)
                Wait(200)
                MySQL.query("SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @name",
                    { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result1)
                    if result1[1] then
                        local money = 0
                        local gold = 0
                        local invspace1 = 10
                        local bankinfo = { money = money, gold = gold, invspace = invspace1, name = name }

                        TriggerClientEvent("vorp_bank:recinfo", _source, bankinfo)
                    end
                end)
            end
        end)
end)

RegisterServerEvent('vorp_bank:UpgradeSafeBox')
AddEventHandler('vorp_bank:UpgradeSafeBox', function(costlot, maxslots, slotsBought, name, currentspace)
    local _source = source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local charidentifier = Character.charIdentifier
    local money = Character.money

    local amountToPay = costlot * slotsBought
    local FinalSlots = currentspace + slotsBought -- slot to add to db


    if money < amountToPay then --if player has the money
        TriggerClientEvent("vorp:TipRight", _source, T.nomoney, 10000)
        return
    end

    if FinalSlots > maxslots then
        TriggerClientEvent("vorp:TipRight", _source, T.maxslots .. " | " .. slotsBought .. " / " .. maxslots, 10000)
        return
    end

    Character.removeCurrency(0, amountToPay)
    local Parameters = { ['charidentifier'] = charidentifier, ['invspace'] = FinalSlots, ['name'] = name }
    MySQL.update("UPDATE bank_users SET invspace=@invspace WHERE charidentifier=@charidentifier AND name = @name",
        Parameters)

    TriggerClientEvent("vorp:TipRight", _source,
        T.success .. (costlot * slotsBought) .. " | " .. FinalSlots .. " / " .. maxslots, 10000)
end)


DiscordLogs = function(amount, bankname, playername, type)
    local title = "Bank Logs"
    local color = nil
    local logo = nil
    local footerlogo = nil
    local avatar = nil
    local names = nil

    if type == "with" then
        local webhook = Config.Logwithdraw
        local description = "**Player:**`" ..
            playername .. "`\n **withdrew:** `" .. amount .. "` \n**Bank** `" .. bankname .. "`"
        VorpCore.AddWebhook(title, webhook, description, color, names, logo, footerlogo, avatar)
    end

    if type == "depo" then
        local webhook = Config.LogDeposti
        local description = "**Player:**`" ..
            playername .. "`\n **Deposited: ** `" .. amount .. "`\n **Bank** `" .. bankname .. "`"
        VorpCore.AddWebhook(title, webhook, description, color, names, logo, footerlogo, avatar)
    end
end

RegisterServerEvent('vorp_bank:depositcash')
AddEventHandler('vorp_bank:depositcash', function(amount, name, bankinfo)
    local _source = source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local playername = Character.firstname .. ' ' .. Character.lastname
    local charidentifier = Character.charIdentifier
    local money = Character.money

    if money >= amount then
        MySQL.query("SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @name",
            { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result)
                if result[1] then
                    Character.removeCurrency(0, amount)
                    DiscordLogs(amount, name, playername, "depo")
                    local inmoney = result[1].money
                    local finalamount = inmoney + amount
                    Wait(100)
                    local Parameters = { ['charidentifier'] = charidentifier, ['money'] = finalamount, ['name'] = name }
                    MySQL.update(
                    "UPDATE bank_users Set money=@money WHERE charidentifier=@charidentifier AND name = @name",
                        Parameters)
                    TriggerClientEvent("vorp:TipRight", _source, T.youdepo .. amount, 10000)
                end
            end)
    else
        TriggerClientEvent("vorp:TipRight", _source, T.invalid, 10000)
    end
    TriggerClientEvent("vorp_bank:ready", _source)
end)

RegisterServerEvent('vorp_bank:depositgold')
AddEventHandler('vorp_bank:depositgold', function(amount, name, bankinfo)
    local _source = source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local charidentifier = Character.charIdentifier
    local money = Character.gold
    if money >= amount then
        Character.removeCurrency(1, amount)
        local Parameters = { ['charidentifier'] = charidentifier, ['gold'] = amount, ['name'] = name }
        MySQL.update("UPDATE bank_users Set gold=gold+@gold WHERE charidentifier=@charidentifier AND name = @name",
            Parameters)
        TriggerClientEvent("vorp:TipRight", _source, T.youdepog .. amount, 10000)
    else
        TriggerClientEvent("vorp:TipRight", _source, T.invalid, 10000)
    end
    TriggerClientEvent("vorp_bank:ready", _source)
end)

RegisterServerEvent('vorp_bank:withcash')
AddEventHandler('vorp_bank:withcash', function(amount, name, bankinfo)
    local _source = source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local playername = Character.firstname .. ' ' .. Character.lastname
    local charidentifier = Character.charIdentifier
    MySQL.query("SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @name",
        { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result)
            if result[1] then
                local money = result[1].money
                if money >= amount then
                    local finalamount = money - amount
                    local Parameters = { ['charidentifier'] = charidentifier, ['money'] = finalamount, ['name'] = name }
                    MySQL.update(
                        "UPDATE bank_users Set money=@money WHERE charidentifier=@charidentifier AND name = @name",
                        Parameters)
                    Character.addCurrency(0, amount)
                    DiscordLogs(amount, name, playername, "with")
                    TriggerClientEvent("vorp:TipRight", _source, T.withdrew .. amount, 10000)
                else
                    TriggerClientEvent("vorp:TipRight", _source, T.invalid, 10000)
                end
            end
            TriggerClientEvent("vorp_bank:ready", _source)
        end)
end)

RegisterServerEvent('vorp_bank:withgold')
AddEventHandler('vorp_bank:withgold', function(amount, name, bankinfo)
    local _source = source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local charidentifier = Character.charIdentifier
    MySQL.query("SELECT gold FROM bank_users WHERE charidentifier = @charidentifier AND name = @name"
        ,
        { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result)
            local gold = result[1].gold
            if gold >= amount then
                local Parameters = { ['charidentifier'] = charidentifier, ['gold'] = amount, ['name'] = name }
                MySQL.update(
                "UPDATE bank_users Set gold=gold-@gold WHERE charidentifier=@charidentifier AND name = @name", Parameters)
                Character.addCurrency(1, amount)
                TriggerClientEvent("vorp:TipRight", _source, T.withdrewg .. amount, 10000)
            else
                TriggerClientEvent("vorp:TipRight", _source, T.invalid, 10000)
            end
            TriggerClientEvent("vorp_bank:ready", _source)
        end)
end)

RegisterServerEvent("vorp_bank:find")
AddEventHandler("vorp_bank:find", function(name)
    local _source = source
    MySQL.query('SELECT * FROM bank_users', {}, function(result)
        local banklocations = {}
        if result[1] then
            for i = 1, #result, 1 do
                banklocations[#banklocations + 1] = {
                    id             = result[i].id,
                    name           = result[i].name,
                    identifier     = result[i].identifier,
                    charidentifier = result[i].charidentifier,
                    money          = result[i].money,
                    gold           = result[i].gold,
                    invspace       = result[i].invspace,
                }
            end
            TriggerClientEvent("vorp_bank:findbank", _source, banklocations)
        end
    end)
end)

local processinguser = {}

function inprocessing(id)
    for k, v in pairs(processinguser) do
        if v == id then
            return true
        end
    end
    return false
end

function trem(id)
    for k, v in pairs(processinguser) do
        if v == id then
            table.remove(processinguser, k)
        end
    end
end

function AnIndexOf(t, val)
    for k, v in ipairs(t) do
        if v == val then return k end
    end
end

function ToInteger(number)
    _source = source
    number = tonumber(number)
    if number then
        if 0 > number then
            number = number * -1
        elseif number == 0 then
            return nil
        end
        return math.floor(number or error("Could not cast '" .. tostring(number) .. "' to number.'"))
    else
        return nil
    end
end

function pairsByKeys(t, f) -- non toccare
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0             -- iterator variable
    local iter = function() -- iterator function
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end

RegisterNetEvent("vorp_bank:ReloadBankInventory") -- inventory system
AddEventHandler("vorp_bank:ReloadBankInventory", function(bankid)
    local _source = source
    local name = bankid
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local charidentifier = Character.charIdentifier
    MySQL.query("SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @name ",
        { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result)
            if result[1].items then
                local items = {}
                local inv = json.decode(result[1].items)
                if not inv then
                    items.itemList = {}
                    items.action = "setSecondInventoryItems"
                    TriggerClientEvent("vorp_inventory:ReloadBankInventory", _source, json.encode(items))
                else
                    items.itemList = inv
                    items.action = "setSecondInventoryItems"
                    TriggerClientEvent("vorp_inventory:ReloadBankInventory", _source, json.encode(items))
                end
            end
        end)
end)

RegisterServerEvent("vorp_bank:TakeFromBank") -- inventory system
AddEventHandler("vorp_bank:TakeFromBank", function(jsonData)
    local _source = source
    if not inprocessing(_source) then
        processinguser[#processinguser + 1] = _source
        local notpass = false
        local User = VorpCore.getUser(_source)
        local Character = User.getUsedCharacter
        local charidentifier = Character.charIdentifier
        local data = json.decode(jsonData)
        local name = data["bank"]
        local item = data.item
        local itemCount = ToInteger(data["number"])
        local itemType = data.type

        local itemMeta = data.item.metadata
        local dataMeta = true
        if itemMeta == nil then
            itemMeta = {}
        end

        if itemCount and itemCount ~= 0 then
            if item.count < itemCount then
                TriggerClientEvent("vorp:TipRight", _source, T.invalid, 5000)
                return trem(_source)
            end
        else
            TriggerClientEvent("vorp:TipRight", _source, T.invalid, 5000)
            return trem(_source)
        end
        if itemType == "item_weapon" then
            TriggerEvent("vorpCore:canCarryWeapons", tonumber(_source), itemCount, function(canCarry)
                if canCarry then
                    MySQL.query(
                        "SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @name",
                        { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result)
                            notpass = true
                            if result[1].items then
                                local items = {}
                                local inv = json.decode(result[1].items)
                                local foundItem, foundIndex = nil, nil
                                for k, v in pairs(inv) do
                                    if v.name == item.name then
                                        foundItem = v
                                        if #foundItem > 1 then
                                            if k == 1 then
                                                foundItem = v
                                            end
                                        end
                                    end
                                end
                                if foundItem then
                                    local foundIndex2 = AnIndexOf(inv, foundItem)
                                    foundItem.count = foundItem.count - itemCount
                                    if 0 >= foundItem.count then
                                        table.remove(inv, foundIndex2)
                                    end
                                    items.itemList = inv
                                    items.action = "setSecondInventoryItems"
                                    local weapId = foundItem.id
                                    VorpInv.giveWeapon(_source, weapId, 0)
                                    Wait(200)
                                    TriggerClientEvent("vorp_inventory:ReloadBankInventory", _source, json.encode(items))
                                    MySQL.update(
                                        "UPDATE bank_users SET items = @inv WHERE charidentifier = @charidentifier AND name = @name",
                                        {
                                            ["@inv"] = json.encode(inv),
                                            ["@charidentifier"] = charidentifier,
                                            ["@name"] = name
                                        })
                                end
                            end
                            notpass = false
                        end)
                    while notpass do
                        Wait(500)
                    end
                else
                    TriggerClientEvent("vorp:TipRight", _source, T.limit, 5000)
                end
            end, item.name)
        else
            if itemCount and itemCount ~= 0 then
                if item.count < itemCount then
                    TriggerClientEvent("vorp:TipRight", _source, T.invalid, 5000)
                    return trem(_source)
                end
            else
                TriggerClientEvent("vorp:TipRight", _source, T.invalid, 5000)
                return trem(_source)
            end
            local count = VorpInv.getItemCount(_source, item.name)

            if (count + itemCount) > item.limit then
                TriggerClientEvent("vorp:TipRight", _source, T.maxlimit, 5000)
                return trem(_source)
            end
            TriggerEvent("vorpCore:canCarryItems", tonumber(_source), itemCount, function(canCarry)
                TriggerEvent("vorpCore:canCarryItem", tonumber(_source), item.name, itemCount, function(canCarry2)
                    if canCarry and canCarry2 then
                        MySQL.query(
                            "SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @name",
                            { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result)
                                notpass = true
                                if result[1].items then
                                    local items = {}
                                    local inv = json.decode(result[1].items)
                                    local foundItem, foundIndex = nil, nil

                                    if next(itemMeta) ~= nil then
                                        for k, v in pairs(inv) do
                                            if v.name == item.name then -- se hanno stesso nome
                                                for x, y in pairsByKeys(v.metadata) do
                                                    for w, z in pairsByKeys(itemMeta) do
                                                        if x == w and y == z then
                                                            foundItem = v
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        for k, v in pairs(inv) do
                                            if v.name == item.name then
                                                if v.metadata == nil or next(v.metadata) == nil then
                                                    foundItem = v
                                                end
                                            end
                                        end
                                    end

                                    if foundItem then
                                        local foundIndex2 = AnIndexOf(inv, foundItem)
                                        foundItem.count = foundItem.count - itemCount
                                        if 0 >= foundItem.count then
                                            table.remove(inv, foundIndex2)
                                        end

                                        items.itemList = inv
                                        items.action = "setSecondInventoryItems"

                                        if dataMeta then
                                            VorpInv.addItem(_source, item.name, itemCount, itemMeta)
                                        else
                                            VorpInv.addItem(_source, item.name, itemCount)
                                        end

                                        TriggerClientEvent("vorp_inventory:ReloadBankInventory", _source,
                                            json.encode(items))
                                        MySQL.update(
                                            "UPDATE bank_users SET items = @inv WHERE charidentifier = @charidentifier AND name = @name"
                                            ,
                                            {
                                                ["@inv"] = json.encode(inv),
                                                ["@charidentifier"] = charidentifier,
                                                ["@name"] = name
                                            })
                                    end
                                end
                                notpass = false
                            end)
                        while notpass do
                            Wait(500)
                        end
                    else
                        TriggerClientEvent("vorp:TipRight", _source, T.limit, 5000)
                    end
                end)
            end)
        end
        trem(_source)
    end
end)

function checkLimit(limit, name)
    for k, v in pairs(limit) do
        if k == name then
            return true
        end
    end
end

function checkCount(countinv, countdb, limit, nameitem)
    for k, v in pairs(limit) do
        if k == nameitem then
            if countinv > v or countdb > v then
                return true
            end
        end
    end
end

function checkLimite(limit, nameitem)
    for index, countConfig in pairs(limit) do
        if index == nameitem then
            return countConfig
        end
    end
end

function checkDB(inv, itemName, itemType)
    for k, v in pairs(inv) do
        if v.name == itemName then
            if itemType == "item_standard" then
                return v.count -- da quanti item c erano prima del deposito
            else
                for index, data in pairs(inv) do
                    if v.name == itemName and itemType == "item_weapon" then
                        count = count + 1
                        return count
                    end
                end
            end
        end
    end
end

RegisterServerEvent("vorp_bank:MoveToBank") -- inventory system
AddEventHandler("vorp_bank:MoveToBank", function(jsonData)
    local _source = source
    if not inprocessing(_source) then
        processinguser[#processinguser + 1] = _source
        local notpass = false
        local User = VorpCore.getUser(_source)
        local Character = User.getUsedCharacter
        local charidentifier = Character.charIdentifier
        local data = json.decode(jsonData)
        local bankName = data["bank"]
        local item = data.item
        local itemCount = ToInteger(data["number"])
        local itemType = data["type"]
        local itemDBCount = 1
        -- until its resolved
        if itemType == "weapon" then
            return TriggerClientEvent("vorp:TipRight", _source, "cant store weapons", 5000)
        end
        local itemMeta = data.item.metadata
        local dataMeta = true
        if itemMeta == nil then
            itemMeta = {}
        end

        for index, bankConfig in pairs(Config.banks) do
            if bankConfig.city == bankName then
                local existItem = checkLimit(bankConfig.itemlist, item.name)
                if (existItem and bankConfig.useitemlimit) or (existItem and bankConfig.usespecificitem) then
                    MySQL.query(
                        "SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @name"
                        , { ["@charidentifier"] = charidentifier, ["@name"] = bankName }, function(result)
                            if result[1].items ~= "[]" then
                                local inv = json.decode(result[1].items)
                                for k, v in pairs(inv) do
                                    if v.name == item.name then
                                        if itemType == "item_standard" then
                                            itemDBCount = v.count + itemCount
                                        elseif itemType == "item_weapon" then
                                            itemDBCount = itemDBCount + itemCount
                                        end
                                    end
                                end
                            else
                                itemDBCount = itemCount
                            end
                            local checkCount = checkCount(itemCount, itemDBCount, bankConfig.itemlist, item.name)
                            if checkCount then
                                local limite = checkLimite(bankConfig.itemlist, item.name)
                                TriggerClientEvent("vorp:TipRight", _source, T.maxitems .. limite, 5000)
                                return trem(_source)
                            else
                                if itemType ~= "item_weapon" then
                                    local countin = VorpInv.getItemCount(_source, item.name)
                                    if itemCount > countin then
                                        TriggerClientEvent("vorp:TipRight", _source, T.limit, 5000)
                                        return trem(_source)
                                    end
                                end
                                if itemType == "item_weapon" then
                                    itemCount = 1
                                    item.count = 1
                                end
                                if itemCount and itemCount ~= 0 then
                                    if item.count < itemCount then
                                        TriggerClientEvent("vorp:TipRight", _source, T.invalid, 5000)
                                        return trem(_source)
                                    end
                                else
                                    TriggerClientEvent("vorp:TipRight", _source, T.invalid, 5000)
                                    return trem(_source)
                                end
                                MySQL.query(
                                    "SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @name"
                                    , { ["@charidentifier"] = charidentifier, ["@name"] = bankName }, function(result)
                                        notpass = true

                                        if result[1].items then
                                            local space = result[1].invspace
                                            local items = {}
                                            local countDB = 0
                                            local inv = json.decode(result[1].items)
                                            local foundItem = nil

                                            if next(itemMeta) ~= nil then
                                                for k, v in pairs(inv) do
                                                    if v.name == item.name then
                                                        for x, y in pairsByKeys(v.metadata) do
                                                            for w, z in pairsByKeys(itemMeta) do
                                                                if x == w and y == z then
                                                                    if itemType == "item_standard" then
                                                                        foundItem = v
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            else
                                                for k, v in pairs(inv) do
                                                    if v.name == item.name then
                                                        if v.metadata == nil or next(v.metadata) == nil then
                                                            if itemType == "item_standard" then
                                                                foundItem = v
                                                            end
                                                        end
                                                    end
                                                end
                                            end

                                            for _, k in pairs(inv) do
                                                countDB = countDB + k.count
                                            end
                                            countDB = countDB + itemCount
                                            if countDB > space then
                                                TriggerClientEvent("vorp:TipRight", _source, T.limit, 5000)
                                            else
                                                if foundItem then
                                                    foundItem.count = foundItem.count + itemCount
                                                else
                                                    if itemType == "item_standard" then
                                                        if next(itemMeta) == nil then
                                                            foundItem = {
                                                                name = item.name,
                                                                count = itemCount,
                                                                label = item.label,
                                                                type = item.type,
                                                                limit = item.limit,
                                                                metadata = {}
                                                            }
                                                            inv[#inv + 1] = foundItem
                                                        else
                                                            foundItem = {
                                                                name = item.name,
                                                                count = itemCount,
                                                                label = item.label,
                                                                type = item.type,
                                                                limit = item.limit,
                                                                id = item.id,
                                                                metadata = itemMeta
                                                            }
                                                            inv[#inv + 1] = foundItem
                                                        end
                                                    else
                                                        foundItem = {
                                                            name = item.name,
                                                            count = itemCount,
                                                            label = item.label,
                                                            type = item.type,
                                                            limit = item.limit,
                                                            id = item.id
                                                        }
                                                        table.insert(inv, foundItem)
                                                    end
                                                end
                                                items.itemList = inv
                                                items.action = "setSecondInventoryItems"
                                                if itemType == "item_standard" then
                                                    if dataMeta then
                                                        VorpInv.subItem(_source, item.name, itemCount, itemMeta)
                                                        TriggerClientEvent("vorp:TipRight", _source,
                                                            T.depoitem3 ..
                                                            itemCount .. T.of .. item.label, 5000)
                                                    else
                                                        VorpInv.subItem(_source, item.name, itemCount)
                                                        TriggerClientEvent("vorp:TipRight", _source,
                                                            T.depoitem3 ..
                                                            itemCount .. T.of .. item.label, 5000)
                                                    end
                                                end
                                                if itemType == "item_weapon" then
                                                    local weapId = item.id
                                                    VorpInv.subWeapon(_source, weapId)
                                                    TriggerClientEvent("vorp:TipRight", _source,
                                                        T.depoitem3 .. item.label, 5000)
                                                end
                                                TriggerClientEvent("vorp_inventory:ReloadBankInventory", _source,
                                                    json.encode(items))
                                                MySQL.update(
                                                    "UPDATE bank_users SET items = @inv WHERE charidentifier = @charidentifier AND name = @name"
                                                    ,
                                                    {
                                                        ["@inv"] = json.encode(inv),
                                                        ["@charidentifier"] = charidentifier,
                                                        ["@name"] = bankName
                                                    })
                                            end
                                        end
                                        notpass = false
                                    end)
                                while notpass do
                                    Wait(500)
                                end
                                trem(_source)
                            end
                        end)
                elseif (bankConfig.useitemlimit and not bankConfig.usespecificitem) or
                    (not bankConfig.useitemlimit and not bankConfig.usespecificitem) then
                    if itemType ~= "item_weapon" then
                        local countin = VorpInv.getItemCount(_source, item.name)
                        if itemCount > countin then
                            TriggerClientEvent("vorp:TipRight", _source, T.limit, 5000)
                            return trem(_source)
                        end
                    end
                    if itemType == "item_weapon" then
                        itemCount = 1
                        item.count = 1
                    end
                    if itemCount and itemCount ~= 0 then
                        if item.count < itemCount then
                            TriggerClientEvent("vorp:TipRight", _source, T.invalid, 5000)
                            return trem(_source)
                        end
                    else
                        TriggerClientEvent("vorp:TipRight", _source, T.invalid, 5000)
                        return trem(_source)
                    end
                    MySQL.query(
                        "SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @name"
                        , { ["@charidentifier"] = charidentifier, ["@name"] = bankName }, function(result)
                            notpass = true
                            if result[1].items then
                                local space = result[1].invspace
                                local items = {}
                                local countDB = 0
                                local inv = json.decode(result[1].items)
                                local foundItem = nil

                                if next(itemMeta) ~= nil then
                                    for k, v in pairs(inv) do
                                        if v.name == item.name then
                                            for x, y in pairsByKeys(v.metadata) do
                                                for w, z in pairsByKeys(itemMeta) do
                                                    if x == w and y == z then
                                                        if itemType == "item_standard" then
                                                            foundItem = v
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                else
                                    for k, v in pairs(inv) do
                                        if v.name == item.name then
                                            if v.metadata == nil or next(v.metadata) == nil then
                                                if itemType == "item_standard" then
                                                    foundItem = v
                                                end
                                            end
                                        end
                                    end
                                end

                                for k, v in pairs(inv) do
                                    countDB = countDB + v.count
                                end
                                countDB = countDB + itemCount
                                if countDB > space then
                                    TriggerClientEvent("vorp:TipRight", _source, T.limit, 5000)
                                else
                                    if foundItem then
                                        foundItem.count = foundItem.count + itemCount
                                    else
                                        if itemType == "item_standard" then
                                            if next(itemMeta) == nil then
                                                foundItem = {
                                                    name = item.name,
                                                    count = itemCount,
                                                    label = item.label,
                                                    type = item.type,
                                                    limit = item.limit,
                                                    metadata = {}
                                                }
                                                inv[#inv + 1] = foundItem
                                            else
                                                foundItem = {
                                                    name = item.name,
                                                    count = itemCount,
                                                    label = item.label,
                                                    type = item.type,
                                                    limit = item.limit,
                                                    id = item.id,
                                                    metadata = itemMeta
                                                }
                                                inv[#inv + 1] = foundItem
                                            end
                                        else
                                            foundItem = {
                                                name = item.name,
                                                count = itemCount,
                                                label = item.label,
                                                type = item.type,
                                                limit = item.limit,
                                                id = item.id
                                            }
                                            table.insert(inv, foundItem)
                                        end
                                    end
                                    items.itemList = inv
                                    items.action = "setSecondInventoryItems"
                                    if itemType == "item_standard" then
                                        if dataMeta then
                                            VorpInv.subItem(_source, item.name, itemCount, itemMeta)
                                        else
                                            VorpInv.subItem(_source, item.name, itemCount)
                                        end
                                        TriggerClientEvent("vorp:TipRight", _source,
                                            T.depoitem3 .. itemCount .. T.of .. item.label, 5000)
                                    end
                                    if itemType == "item_weapon" then
                                        local weapId = item.id
                                        VorpInv.subWeapon(_source, weapId)
                                        TriggerClientEvent("vorp:TipRight", _source, T.depoitem3 .. item.label, 5000)
                                    end
                                    TriggerClientEvent("vorp_inventory:ReloadBankInventory", _source, json.encode(items))
                                    MySQL.update(
                                        "UPDATE bank_users SET items = @inv WHERE charidentifier = @charidentifier AND name = @name",
                                        {
                                            ["@inv"] = json.encode(inv),
                                            ["@charidentifier"] = charidentifier,
                                            ["@name"] = bankName
                                        })
                                end
                            end
                            notpass = false
                        end)
                    while notpass do
                        Wait(500)
                    end
                    trem(_source)
                else
                    TriggerClientEvent("vorp:TipRight", _source, T.cant, 5000)
                    trem(_source)
                end
            end
        end
    end
end)
