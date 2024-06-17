---@deprecated
exports('vorp_inventoryApi', function()
    local INV = {}

    local dbQuery = function(query, params)
        local query_promise = promise.new()

        params = params or {}

        local on_result = function(result)
            query_promise:resolve(result)
        end

        MySQL.query(query, params, on_result)

        return Citizen.Await(query_promise)
    end

    INV.registerInventory = function(id, name, limit, acceptWeapons, shared, ignoreItemStackLimit, whitelistItems, UsePermissions, UseBlackList, whitelistWeapons)
        local data = {
            id = id,
            name = name,
            limit = limit,
            acceptWeapons = acceptWeapons,
            shared = shared,
            ignoreItemStackLimit = ignoreItemStackLimit,
            whitelistItems = whitelistItems,
            UsePermissions = UsePermissions,
            UseBlackList = UseBlackList,
            whitelistWeapons = whitelistWeapons,
        }
        TriggerEvent("vorpCore:registerInventory", data)
    end

    INV.removeInventory = function(...)
        TriggerEvent("vorpCore:removeInventory", ...)
    end

    INV.BlackListCustomAny = function(...)
        TriggerEvent("vorp_inventory:Server:BlackListCustom", ...)
    end

    INV.AddPermissionMoveToCustom = function(...)
        TriggerEvent("vorp_inventory:Server:AddPermissionMoveToCustom", ...)
    end

    INV.AddPermissionTakeFromCustom = function(...)
        TriggerEvent("vorp_inventory:Server:AddPermissionTakeFromCustom", ...)
    end

    INV.setInventoryItemLimit = function(...)
        TriggerEvent("vorpCore:setInventoryItemLimit", ...)
    end

    INV.setInventoryWeaponLimit = function(...)
        TriggerEvent("vorpCore:setInventoryWeaponLimit", ...)
    end

    INV.updateCustomInventorySlots = function(...)
        TriggerEvent("vorp_inventory:Server:updateCustomInventorySlots", ...)
    end

    -- * WEAPONS * --
    INV.subWeapon = function(source, weaponid)
        TriggerEvent("vorpCore:subWeapon", source, tonumber(weaponid))
    end

    INV.createWeapon = function(source, weaponName, ammoaux, compaux, comps, custom_serial, custom_label, custom_desc)
        local result_promise = promise.new()
        TriggerEvent("vorpCore:registerWeapon", source, tostring(string.upper(weaponName)), ammoaux, compaux, comps,
            function(res)
                result_promise:resolve(res)
            end, nil, custom_serial, custom_label, custom_desc)
        return Citizen.Await(result_promise)
    end

    INV.deletegun = function(source, id)
        local result_promise = promise.new()
        TriggerEvent("vorpCore:deletegun", source, tonumber(id), function(res)
            result_promise:resolve(res)
        end)
        return Citizen.Await(result_promise)
    end

    INV.canCarryWeapons = function(source, amount, cb, weaponName)
        TriggerEvent("vorpCore:canCarryWeapons", source, amount, cb, weaponName)
    end

    INV.getcomps = function(source, weaponid)
        local comps_promise = promise.new()
        TriggerEvent("vorpCore:getcomps", source, tonumber(weaponid), function(responseItem)
            comps_promise:resolve(responseItem)
        end)
        return Citizen.Await(comps_promise)
    end

    INV.giveWeapon = function(source, weaponid, target)
        TriggerEvent("vorpCore:giveWeapon", source, weaponid, target)
    end

    INV.addBullets = function(source, weaponId, type, qty)
        TriggerEvent("vorpCore:addBullets", source, weaponId, type, qty)
    end

    INV.subBullets = function(source, weaponId, type, qty)
        TriggerEvent("vorpCore:subBullets", source, weaponId, type, qty)
    end

    INV.getWeaponBullets = function(source, weaponId)
        local bullets_promise = promise.new()
        TriggerEvent("vorpCore:getWeaponBullets", source, function(bullets)
            bullets_promise:resolve(bullets)
        end, weaponId)
        return Citizen.Await(bullets_promise)
    end

    INV.getWeaponComponents = function(source, weaponId)
        local components_promise = promise.new()
        TriggerEvent("vorpCore:getWeaponComponents", source, function(components)
            components_promise:resolve(components)
        end, weaponId)
        return Citizen.Await(components_promise)
    end

    INV.getUserWeapons = function(source)
        local weapons_promise = promise.new()
        TriggerEvent("vorpCore:getUserWeapons", source, function(weapons)
            weapons_promise:resolve(weapons)
        end)
        return Citizen.Await(weapons_promise)
    end

    INV.getUserWeapon = function(source, weaponId)
        local weapon_promise = promise.new()
        TriggerEvent("vorpCore:getUserWeapon", source, function(weapon)
            weapon_promise:resolve(weapon)
        end, weaponId)
        return Citizen.Await(weapon_promise)
    end

    INV.removeAllUserAmmo = function(source)
        TriggerEvent("vorpinventory:removeammo", source)
    end

    -- * ITEMS * --
    INV.getItem = function(source, itemName, metadata)
        local item_promise = promise.new()
        TriggerEvent("vorpCore:getItem", source, itemName, function(responseItem)
            item_promise:resolve(responseItem)
        end, metadata)
        return Citizen.Await(item_promise)
    end

    INV.getItemByMainId = function(source, mainid) --main id can be obtain by using an item.
        local item_promise = promise.new()
        TriggerEvent("vorpCore:getItemByMainId", source, mainid, function(responseItem)
            item_promise:resolve(responseItem)
        end)
        return Citizen.Await(item_promise)
    end

    INV.addItem = function(source, itemName, qty, metadata)
        local result_promise = promise.new()
        TriggerEvent("vorpCore:addItem", source, tostring(itemName), tonumber(qty), metadata, function(res)
            result_promise:resolve(res)
        end)
        return Citizen.Await(result_promise)
    end

    INV.subItem = function(source, itemName, qty, metadata)
        local result_promise = promise.new()
        TriggerEvent("vorpCore:subItem", source, tostring(itemName), tonumber(qty), metadata, function(res)
            result_promise:resolve(res)
        end)
        return Citizen.Await(result_promise)
    end

    INV.setItemMetadata = function(source, itemId, metadata, amount)
        local result_promise = promise.new()
        TriggerEvent("vorpCore:setItemMetadata", source, tonumber(itemId), metadata, amount, function(res)
            result_promise:resolve(res)
        end)
        return Citizen.Await(result_promise)
    end

    INV.subItemID = function(source, id)
        local result_promise = promise.new()
        TriggerEvent("vorpCore:subItemID", source, id, function(res)
            result_promise:resolve(res)
        end)
        return Citizen.Await(result_promise)
    end

    INV.getItemByName = function(source, itemName)
        local item_promise = promise.new()
        TriggerEvent("vorpCore:getItemByName", source, tostring(itemName), function(responseItem)
            item_promise:resolve(responseItem)
        end)
        return Citizen.Await(item_promise)
    end

    INV.getItemContainingMetadata = function(source, itemName, metadata)
        local item_promise = promise.new()
        TriggerEvent("vorpCore:getItemContainingMetadata", source, tostring(itemName), metadata,
            function(responseItem)
                item_promise:resolve(responseItem)
            end)
        return Citizen.Await(item_promise)
    end

    INV.getItemMatchingMetadata = function(source, itemName, metadata)
        local item_promise = promise.new()
        TriggerEvent("vorpCore:getItemMatchingMetadata", source, tostring(itemName), metadata, function(responseItem)
            item_promise:resolve(responseItem)
        end)
        return Citizen.Await(item_promise)
    end

    INV.getItemCount = function(source, item, metadata)
        local count_promise = promise.new()
        TriggerEvent("vorpCore:getItemCount", source, function(itemcount)
            count_promise:resolve(itemcount)
        end, item, metadata)
        return Citizen.Await(count_promise)
    end

    INV.getDBItem = function(target, itemName)
        local query = "SELECT * FROM items WHERE item= @item;"
        local params = { item = itemName }
        local itemDBTable = dbQuery(query, params)

        if not itemDBTable[1] then
            print('Item does not exist in Items table. Item:' .. itemName)
            return nil
        end

        return itemDBTable[1]
    end

    INV.canCarryItems = function(source, amount)
        local can_promise = promise.new()
        TriggerEvent("vorpCore:canCarryItems", source, amount, function(data)
            can_promise:resolve(data)
        end)
        return Citizen.Await(can_promise)
    end

    INV.canCarryItem = function(source, item, amount)
        local can_promise = promise.new()
        TriggerEvent("vorpCore:canCarryItem", source, item, amount, function(data)
            can_promise:resolve(data)
        end)
        return Citizen.Await(can_promise)
    end

    INV.RegisterUsableItem = function(itemName, cb)
        TriggerEvent("vorpCore:registerUsableItem", itemName, cb)
    end

    INV.getUserInventory = function(source)
        local inventory_promise = promise.new()
        TriggerEvent("vorpCore:getUserInventory", source, function(invent)
            inventory_promise:resolve(invent)
        end)
        return Citizen.Await(inventory_promise)
    end

    INV.CloseInv = function(source, invId)
        if invId then
            return TriggerEvent("vorpCore:closeCustomInventory", source, invId)
        end
        TriggerClientEvent("vorp_inventory:CloseInv", source)
    end

    INV.OpenInv = function(source, invId)
        if invId then
            return TriggerEvent("vorpCore:openCustomInventory", source, invId)
        end
        TriggerClientEvent("vorp_inventory:OpenInv", source)
    end

    return INV
end)
