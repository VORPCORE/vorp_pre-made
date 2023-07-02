---@diagnostic disable: undefined-global
local VorpInv = {}

VorpInv = exports.vorp_inventory:vorp_inventoryApi()

T = TranslationInv.Langs[Lang]

function getIdentity(source)
    local identifiers = {}

    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)

        if string.find(id, "discord:") then
            identifiers['discord'] = id
        end
    end

    return identifiers
end

RegisterServerEvent("vorpinventory:check_slots")
AddEventHandler("vorpinventory:check_slots", function()
    local _source = tonumber(source)
    local part2 = Config.MaxItemsInInventory.Items
    local User = Core.getUser(_source).getUsedCharacter
    local identifier = User.identifier
    local charid = User.charIdentifier
    local money = User.money
    local gold = User.gold
    local stufftosend = InventoryAPI.getUserTotalCount(identifier, charid)

    TriggerClientEvent("syn:getnuistuff", _source, stufftosend, part2, money, gold)
end)


RegisterServerEvent("vorpinventory:getLabelFromId")
AddEventHandler("vorpinventory:getLabelFromId", function(id, item2, cb)
    local _source = id
    local inventory = VorpInv.getUserInventory(_source)
    local label = "not found"
    for i, item in ipairs(inventory) do
        if item.name == item2 then
            label = item.label
            break
        end
    end
    cb(label)
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


if Config.DevMode then
    RegisterCommand("getInv", function(source, args, rawCommand)
        -- If the source is > 0, then that means it must be a player.
        if (source > 0) then
            local characterId = Core.getUser(source).getUsedCharacter

            TriggerClientEvent("vorp:SelectedCharacter", source, characterId)
            LoadDatabase(charid)
            -- If it's not a player, then it must be RCON, a resource, or the server console directly.
        else
            print("This command was executed by the server console, RCON client, or a resource.")
        end
    end, false --[[this command is not restricted, everyone can use this.]])
end

--============================  CUSTOM INVENTORY CHECK UP ====================================--
local InventoryBeingUsed = {}

RegisterServerEvent("vorp_inventory:Server:LockCustomInv", function(id)
    local _source = source
    local CanOpen = true

    for _, value in pairs(InventoryBeingUsed) do
        if value.invid == id then -- does this id exists
            CanOpen = false
            break
        end
    end

    if CanOpen then
        InventoryBeingUsed[#InventoryBeingUsed + 1] = { invid = id, playerid = _source } -- insert player and inv he is in
    end

    TriggerClientEvent("vorp_inventory:Client:CanOpenCustom", _source, CanOpen)
end)

RegisterServerEvent("vorp_inventory:Server:UnlockCustomInv", function()
    local _source = source
    for i, value in ipairs(InventoryBeingUsed) do
        if value.playerid == _source then
            table.remove(InventoryBeingUsed, i) -- remove index from table without creating a hole, this is why  should use table.remove
            break
        end
    end
end)

-- for safe case
AddEventHandler('playerDropped', function()
    local _source = source
    for i, value in ipairs(InventoryBeingUsed) do
        if value.playerid == _source then
            table.remove(InventoryBeingUsed, i)
            break
        end
    end
end)


--=================================== CLEAR ITEMS WEAPONS AND MONEY=====================================--


RegisterNetEvent("vorp:PlayerForceRespawn", function()
    local _source = source
    local User = Core.getUser(_source).getUsedCharacter
    local _value = Config.OnPlayerRespawn
    local job = User.job

    if not User then
        return
    end

    if not Config.UseClearAll then
        return
    end

    --MONEY
    if _value.Money.ClearMoney then
        if not SharedUtils.IsValueInArray(job, _value.Money.JobLock) then
            if not _value.Money.MoneyPercentage then
                User.removeCurrency(0, User.money)
            else
                User.removeCurrency(0, User.money * _value.Money.MoneyPercentage)
            end
        end
    end

    -- GOLD
    if _value.Gold.ClearGold then
        if not SharedUtils.IsValueInArray(job, _value.Gold.JobLock) then
            if not _value.Gold.GoldPercentage then
                User.removeCurrency(1, User.gold)
            else
                User.removeCurrency(1, User.gold * _value.Gold.GoldPercentage)
            end
        end
    end

    -- ITEMS
    CreateThread(function()
        if _value.Items.AllItems then
            if not SharedUtils.IsValueInArray(job, _value.Items.JobLock) then
                local Userinventory = VorpInv.getUserInventory(_source)
                for i, item in pairs(Userinventory) do
                    for index, value in ipairs(_value.Items.itemWhiteList) do
                        if item.name ~= value then
                            InventoryAPI.subItem(_source, item.name, item.count, item.metadata, function()
                            end)
                        end
                    end
                end
            end
        end
    end)

    -- WEAPONS
    CreateThread(function()
        if _value.Weapons.AllWeapons then
            if not SharedUtils.IsValueInArray(job, _value.Weapons.JobLock) then
                local Userweapons = VorpInv.getUserWeapons(_source)

                for i, weapon in pairs(Userweapons) do
                    for index, value in ipairs(_value.Weapons.WeaponWhitelisted) do
                        if value ~= weapon.name then
                            InventoryAPI.subWeapon(_source, weapon.id)
                            InventoryAPI.deletegun(_source, weapon.id, function()
                            end)
                        end
                    end
                end
            end
        end
    end)

    --AMMO
    if _value.Ammo.AllAmmo then
        if not SharedUtils.IsValueInArray(job, _value.Ammo.JobLock) then
            TriggerClientEvent('syn_weapons:removeallammo', _source)  -- syn script
            TriggerClientEvent('vorp_weapons:removeallammo', _source) -- vorp script
        end
    end
end)
