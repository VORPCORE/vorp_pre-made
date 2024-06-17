local Core               = exports.vorp_core:GetCore()
local InventoryBeingUsed = {}

if Config.DevMode then
    Log.Warning("^1[DEV] ^7You are in dev mode, dont use this in production live servers")
end

RegisterServerEvent("syn:stopscene")
AddEventHandler("syn:stopscene", function(x) -- new
    local _source = source
    TriggerClientEvent("inv:dropstatus", _source, x)
end)

RegisterServerEvent("vorpinventory:netduplog", function()
    local _source = source
    local playername = GetPlayerName(_source)
    local description = Logs.NetDupWebHook.Language.descriptionstart .. playername .. Logs.NetDupWebHook.Language.descriptionend

    if Logs.NetDupWebHook.Active then
        Info = {
            source = _source,
            title = Config.NetDupWebHook.Language.title,
            name = playername,
            description = description,
            webhook = Logs.NetDupWebHook.webhook,
            color = Logs.NetDupWebHook.color
        }
        SvUtils.SendDiscordWebhook(Info)
    else
        print('[' .. Logs.NetDupWebHook.Language.title .. '] ', description)
    end
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
    if _source then
        local char = Core.getUser(_source)
        local weapons = UsersWeapons.default
        AmmoData[_source] = nil

        for i, value in pairs(InventoryBeingUsed) do
            if value == _source then
                InventoryBeingUsed[i] = nil
                break
            end
        end

        if not char then
            return
        end

        local character = char.getUsedCharacter
        local charid = character.charIdentifier
        for key, value in pairs(weapons) do
            if value.charId == charid then
                UsersWeapons.default[key] = nil
                break
            end
        end
    end
end)

Core.Callback.Register("vorpinventory:get_slots", function(source, cb)
    local _source = source
    local User = Core.getUser(_source).getUsedCharacter
    local totalItems = InventoryAPI.getUserTotalCountItems(User.identifier, User.charIdentifier)
    local totalWeapons = InventoryAPI.getUserTotalCountWeapons(User.identifier, User.charIdentifier, true)
    local totalInvWeight = (totalItems + totalWeapons)
    return cb({
        totalInvWeight = totalInvWeight,
        slots = User.invCapacity,
        money = User.money,
        gold = User.gold,
        rol = User.rol
    })
end)


Core.Callback.Register("vorp_inventory:Server:CanOpenCustom", function(source, cb, id)
    local _source = source
    id = tostring(id)
    if not InventoryBeingUsed[id] then
        InventoryBeingUsed[id] = _source
        return cb(true)
    end

    Core.NotifyObjective(_source, "someone is using this stash, wait for your turn", 5000)
    return cb(false)
end)
