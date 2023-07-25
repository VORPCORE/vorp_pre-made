---@diagnostic disable: undefined-global
--------------------------------------------------------------------------------------------------------------
--------------------------------------------- SERVER SIDE ----------------------------------------------------
local VORPcore = {}
local storeLimits = {}
local VORPinv = exports.vorp_inventory:vorp_inventoryApi()
local Jobs = {}

T = TranslationStores.Langs[Lang]

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

-- * STORE ITEM SELL/BUY LIMITS * --
Citizen.CreateThread(function()
    local sellItems = Config.SellItems
    local buyItems = Config.BuyItems
    -- Sell Items

    for index, v in pairs(sellItems) do
        for _, value in pairs(v) do
            if value.itemLimit and value.itemLimit > 0 then
                storeLimits[index] = storeLimits[index] or {}
                table.insert(storeLimits[index], {
                    itemName = value.itemName,
                    amount = value.itemLimit,
                    type = "sell"
                })
            end
        end
    end

    -- Buy Items
    for key, value in pairs(buyItems) do
        for _, v in pairs(value) do
            if v.itemLimit and v.itemLimit > 0 then
                storeLimits[key] = storeLimits[key] or {}
                table.insert(storeLimits[key], {
                    itemName = v.itemName,
                    amount = v.itemLimit,
                    type = "buy"
                })
            end
        end
    end
end)


-- * FUNCTIONS * --

local function DiscordLog(message)
    if Config.UseWebhook == true then
        VORPcore.AddWebhook(Config.WebhookLanguage.WebhookTitle, Config.WebhookLanguage.WebhookUrl, message,
            Config.WebhookLanguage.WebhookColor, Config.WebhookLanguage.WebhookName, Config.WebhookLanguage.WebhookLogo,
            Config.WebhookLanguage.WebhookLogo2, Config.WebhookLanguage.WebhookAvatar)
    end
end

local function checkStoreLimits(storeId, ItemName, quantity, action)
    if not storeLimits[storeId] then
        return true
    end
    for k, v in pairs(storeLimits[storeId]) do
        if action == "sell" then
            -- *sell to store and increase stock from buy items and decrease stock from sell items  * --
            if v.itemName == ItemName and v.type == "buy" then
                v.amount = v.amount + quantity
            end
            -- if you dont want to decrease stock from sell items remove this if statement
            if v.itemName == ItemName and v.type == "sell" then
                v.amount = v.amount - quantity
            end
        end

        if action == "buy" then
            -- *buy from store and decrease amount in stock * --
            if v.itemName == ItemName and v.type == "buy" then
                if v.amount >= quantity then
                    v.amount = v.amount - quantity
                    return true
                else
                    return false
                end
            end
        end
    end
    return true
end

local function sellItems(_source, Character, value, ItemName, storeId)
    local fname = Character.firstname
    local lname = Character.lastname
    local canContinue = false

    local total = value.price * value.quantity
    local total2 = (math.floor(total * 100) / 100)

    if value.weapon then
        for i = 1, value.quantity, 1 do
            Wait(500)
            local userWeapons = VORPinv.getUserWeapons(_source)
            for _, v in pairs(userWeapons) do
                if v.name == ItemName then
                    VORPinv.subWeapon(_source, v.id)
                    VORPinv.deletegun(_source, v.id)
                    canContinue = true
                    break
                end
            end
        end
    else
        local count = VORPinv.getItemCount(_source, ItemName)

        if value.quantity <= count then
            VORPinv.subItem(_source, ItemName, value.quantity)
            canContinue = true
        else
            return VORPcore.NotifyObjective(_source, T.noManyQty, 5000)
        end
    end

    if not canContinue then
        return
    end

    if Config.Stores[storeId].DynamicStore then
        if not checkStoreLimits(storeId, ItemName, value.quantity, "sell") then
            return VORPcore.NotifyRightTip(_source, T.limitBuy, 3000)
        end
    end

    if value.currency == "cash" then
        Character.addCurrency(0, total)
        VORPcore.NotifyRightTip(_source,
            T.yousold .. value.quantity .. " " .. value.label .. T.frcash .. total2 .. T.ofcash, 3000)
        DiscordLog(fname ..
            " " .. lname .. T.hassold .. " " .. value.quantity .. value.label .. T.frcash .. total2 .. T.ofcash)
    end

    if value.currency == "gold" then
        Character.addCurrency(1, total)
        VORPcore.NotifyRightTip(_source, T.yousold .. value.quantity .. " " .. value.label .. T.fr .. total2 .. T.ofgold,
            3000)
        DiscordLog(fname ..
            " " .. lname .. T.hassold .. " " .. value.quantity .. value.label .. T.fr .. total2 .. T.ofgold)
    end
end

local function buyItems(_source, Character, value, ItemName, storeId)
    local fname = Character.firstname
    local lname = Character.lastname
    local money = Character.money
    local gold = Character.gold
    local total = value.price
    local total2 = (math.floor(total * 100) / 100)


    if value.currency == "cash" then
        if money < total then
            return VORPcore.NotifyRightTip(_source, T.youdontcash, 3000)
        end
        if value.weapon then
            for i = 1, value.quantity, 1 do
                Wait(100)
                VORPinv.createWeapon(_source, ItemName)
            end
        else
            VORPinv.addItem(_source, ItemName, value.quantity)
        end

        if Config.Stores[storeId].DynamicStore then
            if not checkStoreLimits(storeId, ItemName, value.quantity, "buy") then
                return VORPcore.NotifyRightTip(_source, T.limitBuy, 3000)
            end
        end

        Character.removeCurrency(0, total)
        VORPcore.NotifyRightTip(_source,
            T.youbought .. value.quantity .. " " .. value.label .. T.frcash .. total2 .. T.ofcash, 3000)
        DiscordLog(fname ..
            " " .. lname .. T.hasbought .. " " .. value.quantity .. value.label .. T.frcash .. total2 .. T.ofcash)
        return
    end


    if value.currency == "gold" then
        if gold < total then
            return VORPcore.NotifyRightTip(_source, T.youdontgold, 3000)
        end

        if value.weapon then
            VORPinv.createWeapon(_source, ItemName)
        else
            VORPinv.addItem(_source, ItemName, value.quantity)
        end
        Character.removeCurrency(1, total)

        VORPcore.NotifyRightTip(_source,
            T.youbought .. value.quantity .. " " .. value.label .. T.fr .. total2 .. T.ofgold, 3000)
        DiscordLog(fname ..
            " " .. lname .. T.hasbought .. " " .. value.quantity .. value.label .. T.fr .. total2 .. T.ofgold)

        if Config.Stores[storeId].DynamicStore then
            if not checkStoreLimits(storeId, ItemName, value.quantity, "buy") then
                return VORPcore.NotifyRightTip(_source, T.limitBuy, 3000)
            end
        end
    end
end



-- * EVENTS * --
RegisterServerEvent('vorp_stores:Client:sellItems', function(dataItems, storeId)
    local _source = source
    local User = VORPcore.getUser(_source)

    if not User then
        return print("User not found")
    end

    local Character = User.getUsedCharacter

    for ItemName, value in pairs(dataItems) do
        Wait(200)
        if value.quantity > 0 then
            sellItems(_source, Character, value, ItemName, storeId)
        end
    end
end)


RegisterServerEvent('vorp_stores:Client:buyItems', function(dataItems, storeId)
    local _source = source
    local User = VORPcore.getUser(_source)

    if not User then
        return print("User not found")
    end

    local Character = User.getUsedCharacter

    for ItemName, value in pairs(dataItems) do
        Wait(200)

        if not value.weapon then
            local quantity = value.quantity
            local canCarry = VORPinv.canCarryItems(_source, quantity)           --can carry inv space
            local canCarry2 = VORPinv.canCarryItem(_source, ItemName, quantity) --cancarry item limit
            local itemCheck = VORPinv.getDBItem(_source, ItemName)              --check items exist in DB

            if not itemCheck then
                return VORPcore.NotifyRightTip(_source, T.itemNotExist, 3000)
            end

            if not canCarry then
                return VORPcore.NotifyRightTip(_source, T.cantcarry, 3000)
            end

            if not canCarry2 then
                return VORPcore.NotifyRightTip(_source, T.cantcarryitem, 3000)
            end

            buyItems(_source, Character, value, ItemName, storeId)
        end

        if value.weapon then
            VORPinv.canCarryWeapons(_source, 1, function(cb) --can carry weapons
                local canCarryWep = cb
                if not canCarryWep then
                    return VORPcore.NotifyRightTip(_source, T.cantcarryweapon, 5000)
                end

                buyItems(_source, Character, value, ItemName, storeId)
            end, ItemName)
        end
    end
end)


-- * CALLBACKS * --
VORPcore.addRpcCallback('vorp_stores:callback:getShopStock', function(source, cb, args)
    local userInv = VORPinv.getUserInventory(source)
    local items = Config.SellItems[args]
    local ItemsFound = false
    local PlayerItems = {}

    for _, value in pairs(userInv) do
        for _, v in pairs(items) do
            if value.name == v.itemName then
                ItemsFound = true
                PlayerItems[value.name] = value.count
            end
        end
    end

    local userWeapons = VORPinv.getUserWeapons(source)

    for _, value in pairs(userWeapons) do
        for _, v in pairs(items) do
            if value.name == v.itemName then
                local count = 1
                ItemsFound = true
                if PlayerItems[value.name] == nil then
                    PlayerItems[value.name] = count
                else
                    PlayerItems[value.name] = PlayerItems[value.name] + count
                end
            end
        end
    end

    if not ItemsFound then
        ItemsFound = false
        VORPcore.NotifyRightTip(source, T.notAllowItem, 3000)
        return cb(false)
    end

    local data = {
        shopStocks = storeLimits,
        ItemsFound = PlayerItems
    }
    return cb(data)
end)

VORPcore.addRpcCallback('vorp_stores:callback:ShopStock', function(source, cb, args)
    local data = {
        shopStock = storeLimits
    }
    return cb(data)
end)

VORPcore.addRpcCallback('vorp_stores:callback:getPlayerJob', function(source, cb, args)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local CharacterJob = Character.job
    local CharacterGrade = Character.jobGrade
    for key, jobs in ipairs(args.joblist) do
        if jobs == CharacterJob then
            if args.grade <= CharacterGrade then
                return cb(true)
            end
        end
    end
    return cb(false)
end)
local storesInUse = {}
VORPcore.addRpcCallback("vorp_stores:callback:canOpenStore", function(source, cb, storeIndex)
    local _source = source

    if not storesInUse[storeIndex] then
        storesInUse[storeIndex] = true
        return cb(true)
    else
        return cb(false)
    end
end)

VORPcore.addRpcCallback("vorp_stores:callback:CloseStore", function(source, cb, storeIndex)
    local _source = source
    if storesInUse[storeIndex] then
        storesInUse[storeIndex] = nil
        return cb(true)
    end
end)
-- * LOGIC FOR RANDOM PRICES * --
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    for storeId, storeConfig in pairs(Config.Stores) do
        if storeConfig.RandomPrices then
            for index, storeItem in ipairs(Config.SellItems[storeId] or {}) do
                Config.SellItems[storeId][index].sellprice = storeItem.randomprice
            end
            for index, storeItem in ipairs(Config.BuyItems[storeId] or {}) do
                Config.BuyItems[storeId][index].buyprice = storeItem.randomprice
            end
        end
        if storeConfig.useRandomLocation then
            local randomLocation = math.random(1, #storeConfig.possibleLocations.OpenMenu)
            Config.Stores[storeId].Blip.Pos = storeConfig.possibleLocations.OpenMenu[randomLocation]
            Config.Stores[storeId].Npc.Pos = storeConfig.possibleLocations.Npcs[randomLocation]
        end
    end
end)

local function CheckTable(table, job)
    for index, value in ipairs(table) do
        if value == job then
            return true
        end
    end
end

RegisterServerEvent('vorp_stores:GetRefreshedPrices', function()
    local _source = source
    TriggerClientEvent('vorp_stores:RefreshStorePrices', _source, Config.SellItems, Config.BuyItems, Config.Stores)

    if not Config.DevMode then
        return
    end
    -- enable for tests
    local character = VORPcore.getUser(_source).getUsedCharacter
    local job = character.job
    local grade = character.jobGrade

    for key, value in pairs(Config.Stores) do
        if CheckTable(value.AllowedJobs, job) then
            if not Jobs[_source] then
                Jobs[_source] = {}
            end

            Jobs[_source] = {
                job = job,
                grade = grade
            }
        end
    end

    TriggerClientEvent("vorp_stores:Server:tableOfJobs", _source, Jobs)
end)


RegisterNetEvent("vorp:SelectedCharacter", function(source, character)
    local _source = source
    if Config.DevMode then
        return
    end

    local job = character.job
    local grade = character.jobGrade

    for key, value in pairs(Config.Stores) do
        if CheckTable(value.AllowedJobs, job) then
            if not Jobs[_source] then
                Jobs[_source] = {}
            end

            Jobs[_source] = {
                job = job,
                grade = grade
            }

            break
        end
    end
    TriggerClientEvent("vorp_stores:Server:tableOfJobs", _source, Jobs)
end)

-- event drrop player
AddEventHandler('vorp:playerDropped', function(source, reason)
    local _source = source
    if Jobs[_source] then
        Jobs[_source] = nil
    end
end)
