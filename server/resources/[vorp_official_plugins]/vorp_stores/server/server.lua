--------------------------------------------------------------------------------------------------------------
--------------------------------------------- SERVER SIDE ----------------------------------------------------
local VORPcore = {}
local VORPinv

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

VORPinv = exports.vorp_inventory:vorp_inventoryApi()

local storeLimits = {}

--------------------------------------------------------------------------------------------------------------
--------------------------------------------- Init Store Limits ----------------------------------------------
Citizen.CreateThread(function ()
    for k, v in pairs(Config.Stores) do
        if v.LimitedItems and k~=nil  then
            storeLimits[#storeLimits+1] = k
            storeLimits[k]= v.LimitedItems
        end  
    end
end)


--------------------------------------------------------------------------------------------------------------
--------------------------------------------- SELL -----------------------------------------------------------

RegisterServerEvent('vorp_stores:sell')
AddEventHandler('vorp_stores:sell', function(label, name, type, price, qty, storeId)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local ItemName = name
    local ItemPrice = price
    local ItemLabel = label
    local currencyType = type
    local count = VORPinv.getItemCount(_source, ItemName)
    local quantity = qty
    local total = ItemPrice * quantity
    local total2 = (math.floor(total * 100) / 100)
    local itemFound= false
    local storeconfig = Config.Stores[storeId]

    if count >= quantity then
        if not storeLimits[storeId] then --when store have no limited items
            sellItems(_source,Character,ItemName,quantity,ItemLabel,total,total2,currencyType)
        else --store have limited items
            for k, items in pairs(storeLimits[storeId]) do
                if items.itemName == ItemName and items.type == "sell" then
                    itemFound = true
                    if items.amount >= quantity then
                        sellItems(_source,Character,ItemName,quantity,ItemLabel,total,total2,currencyType)
                        items.amount = items.amount-quantity --update amount left for store
                    else
                        VORPcore.NotifyRightTip( _source, _U("limitSell"), 3000)
                    end
                end
            end
            if not itemFound then
                sellItems(_source,Character,ItemName,quantity,ItemLabel,total,total2,currencyType)
            end
        end
        if storeconfig.DynamicStore then
            dynamicStoreHandler(storeconfig,storeId,ItemName,quantity)
        end
    else
        VORPcore.NotifyRightTip( _source,_U("youdontsell"), 3000)
    end
end)


function sellItems(_source,Character,ItemName,quantity,ItemLabel,total,total2,currencyType)
    if currencyType == "cash" then
        VORPinv.subItem(_source, ItemName, quantity)
        Character.addCurrency(0, total)

        VORPcore.NotifyRightTip( _source, _U("yousold") .. quantity .. " " .. ItemLabel .. _U("frcash") .. total .. _U("ofcash"), 3000)
    end

    if currencyType == "gold" then

        VORPinv.subItem(_source, ItemName, quantity)
        Character.addCurrency(1, total)
        VORPcore.NotifyRightTip( _source, _U("yousold") .. quantity .. "" .. ItemLabel .. _U("fr") .. total .. _U("ofgold"), 3000)
    end
    
end

function dynamicStoreHandler(storeconfig,storeId,ItemName,quantity)

        for k, items in pairs(storeLimits[storeId]) do
            if items.itemName == ItemName and items.type == "buy" then
                items.amount = items.amount+quantity
            end
        end
end

------------------------------------------------------------------------------------------------------------------------
---------------------------------------------- BUY ---------------------------------------------------------------------


RegisterServerEvent('vorp_stores:buy')
AddEventHandler('vorp_stores:buy', function(label, name, type, price, qty,storeId)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local money = Character.money
    local gold = Character.gold
    local ItemName = name
    local ItemPrice = price
    local ItemLabel = label
    local currencyType = type
    local quantity = qty
    local total = ItemPrice * quantity
    local total2 = (math.floor(total * 100) / 100)
    local itemFound = false
    local canCarry = VORPinv.canCarryItems(_source, quantity) --can carry inv space
    local canCarry2 = VORPinv.canCarryItem(_source, ItemName, quantity) --cancarry item limit
    local itemCheck = VORPinv.getDBItem(_source, ItemName) --check items exist in DB
    if itemCheck then
        if canCarry and canCarry2 then
            if not storeLimits[storeId] then --when store have no limited items
                buyItems(_source,Character,money,gold,currencyType,ItemPrice, total,ItemName,quantity,ItemLabel,total2)
            else
                for k, items in pairs(storeLimits[storeId]) do
                    if items.itemName == ItemName and items.type == "buy" then
                        itemFound = true
                        if items.amount >= quantity then
                            buyItems(_source,Character,money,gold,currencyType,ItemPrice, total,ItemName,quantity,ItemLabel,total2)
                            items.amount = items.amount-quantity --update amount left for store
                        else
                            VORPcore.NotifyRightTip(_source, _U("limitBuy"), 3000)
                        end
                    end
                end
                if not itemFound then
                    buyItems(_source,Character,money,gold,currencyType,ItemPrice, total,ItemName,quantity,ItemLabel,total2)
                end
            end
        else
            VORPcore.NotifyRightTip(_source, _U("cantcarry"), 3000)
        end
    else
        VORPcore.NotifyRightTip(_source, "item does not exist", 3000)
    end
end)

function buyItems(_source,Character,money,gold,currencyType,ItemPrice, total,ItemName,quantity,ItemLabel,total2)
    if money >= total then
        if currencyType == "cash" then
            VORPinv.addItem(_source, ItemName, quantity)
            Character.removeCurrency(0, total)

            VORPcore.NotifyRightTip( _source, _U("youbought") .. quantity .. " " .. ItemLabel .. _U("frcash") .. total .. _U("ofcash"),3000)

        end
    else
        VORPcore.NotifyRightTip(_source, _U("youdontcash"), 3000)
    end

    if gold >= total then
        if currencyType == "gold" then
            if gold >= ItemPrice then
                VORPinv.addItem(_source, ItemName, quantity)
                Character.removeCurrency(1, total)
                VORPcore.NotifyRightTip(_source, _U("youbought") .. quantity .. "" .. ItemLabel .. _U("fr") .. total .. _U("ofgold"),3000)
            else
                VORPcore.NotifyRightTip(_source, _U("youdontgold"), 3000)
            end
        end
    end
    
end


-------------------- GetStocks --------------------
RegisterServerEvent('vorp_stores:getShopStock')
AddEventHandler('vorp_stores:getShopStock', function()
    local _source = source
    local stock =  storeLimits

    TriggerClientEvent('vorp_stores:sendShopStock', _source, stock)
end)

-------------------- GetJOB --------------------
RegisterServerEvent('vorp_stores:getPlayerJob')
AddEventHandler('vorp_stores:getPlayerJob', function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local CharacterJob = Character.job
    local CharacterGrade = Character.jobGrade

    TriggerClientEvent('vorp_stores:sendPlayerJob', _source, CharacterJob, CharacterGrade)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    for storeId, storeConfig in pairs(Config.Stores) do
        if storeConfig.RandomPrices then
            for index, storeItem in ipairs(Config.SellItems[storeId]) do
                Config.SellItems[storeId][index].sellprice = storeItem.randomprice

            end
            for index, storeItem in ipairs(Config.BuyItems[storeId]) do
                Config.BuyItems[storeId][index].buyprice = storeItem.randomprice
            end
        end
    end
end)

RegisterServerEvent('vorp_stores:GetRefreshedPrices')
AddEventHandler('vorp_stores:GetRefreshedPrices', function()
    local _source = source
    TriggerClientEvent('vorp_stores:RefreshStorePrices', _source, Config.SellItems, Config.BuyItems)
end)
