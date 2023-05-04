exports('vorp_inventoryApi', function()
    local self = {}

    ---@param query string
    ---@param params table<string, string|number>|nil
    ---@return any
    local dbQuery = function(query, params)
        local query_promise = promise.new()

        params = params or {}

        local on_result = function(result)
            query_promise:resolve(result)
        end

        exports.oxmysql:execute(query, params, on_result)

        return Citizen.Await(query_promise)
    end

    self.registerInventory = function(...)
        TriggerEvent("vorpCore:registerInventory", ...)
    end

    self.removeInventory = function(id)
        TriggerEvent("vorpCore:removeInventory", id)
    end

    self.BlackListCustomAny = function(...) -- items or weapons
        TriggerEvent("vorp_inventory:Server:BlackListCustom", ...)
    end

    self.AddPermissionMoveToCustom = function(...)
        TriggerEvent("vorp_inventory:Server:AddPermissionMoveToCustom", ...)
    end

    self.AddPermissionTakeFromCustom = function(...)
        TriggerEvent("vorp_inventory:Server:AddPermissionTakeFromCustom", ...)
    end

    self.setInventoryItemLimit = function(id, itemName, limit)
        TriggerEvent("vorpCore:setInventoryItemLimit", id, itemName, limit)
    end

    self.setInventoryWeaponLimit = function(id, weaponName, limit)
        TriggerEvent("vorpCore:setInventoryWeaponLimit", id, weaponName, limit)
    end

    self.subWeapon = function(source, weaponid)
        TriggerEvent("vorpCore:subWeapon", source, tonumber(weaponid))
    end

    self.createWeapon = function(source, weaponName, ammoaux, compaux, comps)
        TriggerEvent("vorpCore:registerWeapon", source, tostring(string.upper(weaponName)), ammoaux, compaux, comps)
    end

    self.deletegun = function(source, id)
        local result_promise = promise.new()

        TriggerEvent("vorpCore:deletegun", source, tonumber(id), function(res)
            result_promise:resolve(res)
        end)

        return Citizen.Await(result_promise)

    end

    self.canCarryWeapons = function(source, amount, cb)
        TriggerEvent("vorpCore:canCarryWeapons", source, amount, cb)
    end

    self.getcomps = function(source, weaponid)
        local comps_promise = promise.new()

        TriggerEvent("vorpCore:getcomps", source, tonumber(weaponid), function(responseItem)
            comps_promise:resolve(responseItem)
        end)

        return Citizen.Await(comps_promise)
    end

    self.getItem = function(source, itemName, metadata)
        local item_promise = promise.new()

        TriggerEvent("vorpCore:getItem", source, tostring(itemName), function(responseItem)
            item_promise:resolve(responseItem)
        end, metadata)

        return Citizen.Await(item_promise)
    end

    self.getItemByMainId = function(source, mainid) --main id can be obtain by using an item.
        local item_promise = promise.new()
        TriggerEvent("vorpCore:getItemByMainId", source, mainid, function(responseItem)
            item_promise:resolve(responseItem)
        end)
        return Citizen.Await(item_promise)
    end

    self.giveWeapon = function(source, weaponid, target)
        TriggerEvent("vorpCore:giveWeapon", source, weaponid, target)
    end

    self.addItem = function(source, itemName, qty, metadata)
        local result_promise = promise.new()

        TriggerEvent("vorpCore:addItem", source, tostring(itemName), tonumber(qty), metadata, function(res)
            result_promise:resolve(res)
        end)

        return Citizen.Await(result_promise)
    end

    self.subItem = function(source, itemName, qty, metadata)
        local result_promise = promise.new()

        TriggerEvent("vorpCore:subItem", source, tostring(itemName), tonumber(qty), metadata, function(res)
            result_promise:resolve(res)
        end)

        return Citizen.Await(result_promise)
    end

    self.setItemMetadata = function(source, itemId, metadata, amount)
        local result_promise = promise.new()

        TriggerEvent("vorpCore:setItemMetadata", source, tonumber(itemId), metadata, amount, function(res)
            result_promise:resolve(res)
        end)

        return Citizen.Await(result_promise)
    end

    self.subItemID = function(source, id)
        local result_promise = promise.new()

        TriggerEvent("vorpCore:subItemID", source, id, function(res)
            result_promise:resolve(res)
        end)

        return Citizen.Await(result_promise)
    end

    self.getItemByName = function(source, itemName)
        local item_promise = promise.new()

        TriggerEvent("vorpCore:getItemByName", source, tostring(itemName), function(responseItem)
            item_promise:resolve(responseItem)
        end)

        return Citizen.Await(item_promise)
    end

    self.getItemContainingMetadata = function(source, itemName, metadata)
        local item_promise = promise.new()

        TriggerEvent("vorpCore:getItemContainingMetadata", source, tostring(itemName), metadata,
            function(responseItem)
                item_promise:resolve(responseItem)
            end)

        return Citizen.Await(item_promise)
    end

    self.getItemMatchingMetadata = function(source, itemName, metadata)
        local item_promise = promise.new()

        TriggerEvent("vorpCore:getItemMatchingMetadata", source, tostring(itemName), metadata, function(responseItem)
            item_promise:resolve(responseItem)
        end)

        return Citizen.Await(item_promise)
    end

    self.getItemCount = function(source, item, metadata)
        local count_promise = promise.new()

        TriggerEvent("vorpCore:getItemCount", source, function(itemcount)
            count_promise:resolve(itemcount)
        end, tostring(item), metadata)

        return Citizen.Await(count_promise)
    end

    ---@param source number
    ---@param itemName string
    ---@return table|nil
    self.getDBItem = function(source, itemName)
        local item
        local query = "SELECT * FROM items WHERE item=@id;"
        local params = { ['@id'] = itemName }
        local result = dbQuery(query, params)

        -- Add check for if the item exists.
        if result[1] then
            item = result[1]
        else
            print('Item does not exist in Items table. Item: ' .. tostring(itemName))
        end

        return item
    end

    self.addBullets = function(source, weaponId, type, qty)
        TriggerEvent("vorpCore:addBullets", source, weaponId, type, qty)
    end

    self.subBullets = function(source, weaponId, type, qty)
        TriggerEvent("vorpCore:subBullets", source, weaponId, type, qty)
    end

    self.getWeaponBullets = function(source, weaponId)
        local bullets_promise = promise.new()

        TriggerEvent("vorpCore:getWeaponBullets", source, function(bullets)
            bullets_promise:resolve(bullets)
        end, weaponId)

        return Citizen.Await(bullets_promise)
    end

    self.getWeaponComponents = function(source, weaponId)
        local components_promise = promise.new()

        TriggerEvent("vorpCore:getWeaponComponents", source, function(components)
            components_promise:resolve(components)
        end, weaponId)

        return Citizen.Await(components_promise)
    end

    self.getUserWeapons = function(source)
        local weapons_promise = promise.new()

        TriggerEvent("vorpCore:getUserWeapons", source, function(weapons)
            weapons_promise:resolve(weapons)
        end)

        return Citizen.Await(weapons_promise)
    end

    self.canCarryItems = function(source, amount)
        local can_promise = promise.new()

        TriggerEvent("vorpCore:canCarryItems", source, amount, function(data)
            can_promise:resolve(data)
        end)

        return Citizen.Await(can_promise)
    end

    self.canCarryItem = function(source, item, amount)
        local can = false

        -- Limit is a restricted field in sql. Query for it directly gives an error.
        local query = "SELECT * FROM items WHERE item=@id;"
        local params = { ['@id'] = item }
        local result = dbQuery(query, params)

        -- Add check for if the item exists.
        local itemcount = self.getItemCount(source, item)
        local reqCount = itemcount + amount

        if result and result[1] then
            local limit = tonumber(result[1].limit)
            can = reqCount <= limit
        else
            -- Object does not exist in inventory, it can not be added
            print('Item does not exist in Items table. Item: ' .. item)
        end

        return can
    end

    self.getUserWeapon = function(source, weaponId)
        local weapon_promise = promise.new()

        TriggerEvent("vorpCore:getUserWeapon", source, function(weapon)
            weapon_promise:resolve(weapon)
        end, weaponId)

        return Citizen.Await(weapon_promise)
    end

    self.RegisterUsableItem = function(itemName, cb)
        TriggerEvent("vorpCore:registerUsableItem", itemName, cb)
    end

    self.getUserInventory = function(source)
        local inventory_promise = promise.new()

        TriggerEvent("vorpCore:getUserInventory", source, function(invent)
            inventory_promise:resolve(invent)
        end)

        return Citizen.Await(inventory_promise)
    end

    self.CloseInv = function(source, invId)
        if invId then
            TriggerEvent("vorpCore:closeCustomInventory", source, invId)
        else
            TriggerClientEvent("vorp_inventory:CloseInv", source)
        end
    end

    self.OpenInv = function(source, invId)
        if invId then
            TriggerEvent("vorpCore:openCustomInventory", source, invId)
        else
            TriggerClientEvent("vorp_inventory:OpenInv", source)
        end
    end

    return self
end)
