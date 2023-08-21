---@diagnostic disable: undefined-global

Core = {}
TriggerEvent("getCore", function(core)
    Core = core
end)

T = TranslationInv.Langs[Lang]

if Config.DevMode then
    Log.Warning("^1[DEV] ^7You are in dev mode, dont use this in production live servers")
end

RegisterServerEvent("syn:stopscene")
AddEventHandler("syn:stopscene", function(x) -- new
    local _source = source
    TriggerClientEvent("inv:dropstatus", _source, x)
end)


RegisterServerEvent("vorpinventory:check_slots")
AddEventHandler("vorpinventory:check_slots", function()
    local _source = tonumber(source)
    local part2 = Config.MaxItemsInInventory.Items
    local User = Core.getUser(_source).getUsedCharacter
    local identifier = User.identifier
    local charid = User.charIdentifier
    local money = User.money
    local gold = User.gold
    local stufftosend = InventoryAPI.getUserTotalCountItems(identifier, charid)

    TriggerClientEvent("syn:getnuistuff", _source, stufftosend, part2, money, gold)
end)


RegisterServerEvent("vorpinventory:getLabelFromId")
AddEventHandler("vorpinventory:getLabelFromId", function(id, item2, cb)
    local _source = id
    InventoryAPI.getInventory(_source, function(inventory)
        local label = "not found"
        for i, item in ipairs(inventory) do
            if item.name == item2 then
                label = item.label
                break
            end
        end
        cb(label)
    end)
end)

RegisterServerEvent("vorpinventory:itemlog")
AddEventHandler("vorpinventory:itemlog", function(_source, targetHandle, itemName, amount)
    local name = GetPlayerName(_source)
    local name2 = GetPlayerName(targetHandle)
    local description = name .. T.transfered .. amount .. " " .. itemName .. T.to .. name2
    Core.AddWebhook(_source, Config.webhook, description, color, Name, logo, footerlogo, avatar)
end)

RegisterServerEvent("vorpinventory:weaponlog")
AddEventHandler("vorpinventory:weaponlog", function(targetHandle, data)
    local _source = source
    local name = GetPlayerName(_source)
    local name2 = GetPlayerName(targetHandle)
    local description = name .. T.transfered ..
        data.item .. T.to .. name2 .. T.withid .. data.id
    Core.AddWebhook(_source, Config.webhook, description, color, Name, logo, footerlogo, avatar) -- if undefined it will choose vorp default.
end)

RegisterServerEvent("vorpinventory:moneylog")
AddEventHandler("vorpinventory:moneylog", function(targetHandle, amount)
    local _source = source
    local name = GetPlayerName(_source)
    local name2 = GetPlayerName(targetHandle)
    local description = name .. T.transfered .. " $" .. amount .. " " .. T.to .. name2
    Core.AddWebhook(_source, Config.webhook, description, color, Name, logo, footerlogo, avatar)
end)

RegisterServerEvent("vorpinventory:netduplog")
AddEventHandler("vorpinventory:netduplog", function()
    local _source = source
    local name = GetPlayerName(_source)
    local description = Config.NetDupWebHook.Language.descriptionstart ..
        name .. Config.NetDupWebHook.Language.descriptionend

    if Config.NetDupWebHook.Active then
        Core.AddWebhook(Config.NetDupWebHook.Language.title, Config.webhook, description, color, name, logo, footerlogo,
            avatar)
    else
        print('[' .. Config.NetDupWebHook.Language.title .. '] ', description)
    end
end)



-- * CUSTOM INVENTORY CHECK IS OPEN * --
local InventoryBeingUsed = {}

Core.addRpcCallback("vorp_inventory:Server:CanOpenCustom", function(source, cb, id)
    local _source = source
    if not InventoryBeingUsed[id] then
        InventoryBeingUsed[id] = _source
        return cb(true)
    end

    return cb(false)
end)

RegisterServerEvent("vorp_inventory:Server:UnlockCustomInv", function()
    local _source = source
    for i, value in pairs(InventoryBeingUsed) do
        if value == _source then
            InventoryBeingUsed[i] = nil
            break
        end
    end
end)


AddEventHandler('playerDropped', function()
    local _source = source
    -- clear ammo
    allplayersammo[_source] = nil

    -- if player is stil in inventory check and remove
    for i, value in ipairs(InventoryBeingUsed) do
        if value == _source then
            table.remove(InventoryBeingUsed, i)
            break
        end
    end

    -- remove weapons from cache on player leave
    local weapons = UsersWeapons.default
    local char = Core.getUser(_source).getUsedCharacter
    if char then
        local charid = char.charIdentifier
        for key, value in pairs(weapons) do
            if value.charId == charid then
                UsersWeapons.default[key] = nil
                break
            end
        end
    end
end)

