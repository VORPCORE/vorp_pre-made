---@class DBService @DBService
DBService = {}

function DBService.GetSharedInventory(inventoryId, cb)
    MySQL.query("SELECT ci.character_id, ic.id, i.item, ci.amount, ic.metadata, ci.created_at FROM items_crafted ic\
		LEFT JOIN character_inventories ci on ic.id = ci.item_crafted_id\
		LEFT JOIN items i on ic.item_id = i.id\
		WHERE ci.inventory_type = @invType;", {
        ['invType'] = inventoryId,
    }, function(res)
        if res then
            cb(res)
        end
    end)
end

function DBService.GetInventory(charIdentifier, inventoryId, cb)
    MySQL.query("SELECT ic.id, i.item, ci.amount, ic.metadata, ci.created_at FROM items_crafted ic\
		LEFT JOIN character_inventories ci on ic.id = ci.item_crafted_id\
		LEFT JOIN items i on ic.item_id = i.id\
		WHERE ci.inventory_type = @invType\
		  AND ci.character_id = @charid;", {
        ['invType'] = inventoryId,
        ['charid'] = charIdentifier,
    }, function(res)
        if res then
            cb(res)
        end
    end)
end

function DBService.GiveItem(giverCharIdentifier, receiverCharIdentifier, itemCraftedId)
    MySQL.update(
        "UPDATE character_inventories SET character_id = @receiver WHERE character_id = @giver AND item_crafted_id = @itemid;"
        , {
            ['receiver'] = tonumber(giverCharIdentifier),
            ['giver'] = tonumber(receiverCharIdentifier),
            ['itemid'] = tonumber(itemCraftedId)
        })
end

function DBService.SetItemAmount(sourceCharIdentifier, itemCraftedId, amount)
    MySQL.update(
        "UPDATE character_inventories SET amount = @amount WHERE character_id = @charid AND item_crafted_id = @itemid;"
        , {
            ['amount'] = tonumber(amount),
            ['charid'] = tonumber(sourceCharIdentifier),
            ['itemid'] = tonumber(itemCraftedId)
        })
end

function DBService.SetItemMetadata(sourceCharIdentifier, itemCraftedId, metadata)
    MySQL.update(
        "UPDATE items_crafted SET metadata = @metadata WHERE character_id = @charid AND id = @itemid;"
        , {
            ['metadata'] = json.encode(metadata), -- Check if need to json.encode().
            ['charid'] = tonumber(sourceCharIdentifier),
            ['itemid'] = tonumber(itemCraftedId)
        })
end

function DBService.DropItem(sourceCharIdentifier, itemCraftedId)
    MySQL.update(
        "UPDATE character_inventories SET character_id = NULL WHERE character_id = @charid  AND item_crafted_id = @itemid;"
        , {
            ['charid'] = tonumber(sourceCharIdentifier),
            ['itemid'] = tonumber(itemCraftedId)
        })
end

function DBService.PickupItem(sourceCharIdentifier, itemCraftedId)
    MySQL.update("UPDATE character_inventories SET character_id = @charid WHERE item_crafted_id = @itemid;",
        {
            ['charid'] = tonumber(sourceCharIdentifier),
            ['itemid'] = tonumber(itemCraftedId)
        })
end

function DBService.DeleteItem(sourceCharIdentifier, itemCraftedId)
    MySQL.query(
        "DELETE FROM character_inventories WHERE character_id = @charid AND item_crafted_id = @itemid;"
        , {
            ['charid'] = tonumber(sourceCharIdentifier),
            ['itemid'] = tonumber(itemCraftedId)
        }, function()
            MySQL.query("DELETE FROM items_crafted WHERE id = @itemid;", {
                ['itemid'] = tonumber(itemCraftedId)
            })
        end)
end

function DBService.CreateItem(sourceCharIdentifier, itemId, amount, metadata, cb, invId)
    invId = invId or "default"
    MySQL.insert(
        "INSERT INTO items_crafted (character_id, item_id, metadata) VALUES (@charid, @itemid, @metadata);"
        , {
            ['charid'] = tonumber(sourceCharIdentifier),
            ['itemid'] = tonumber(itemId),
            ['metadata'] = json.encode(metadata)
        }, function()
            MySQL.query(
                "SELECT * FROM items_crafted WHERE character_id = @charid AND item_id = @itemid AND JSON_CONTAINS(metadata, @metadata);"
                , {
                    ['charid'] = tonumber(sourceCharIdentifier),
                    ['itemid'] = tonumber(itemId),
                    ['metadata'] = json.encode(metadata)
                }, function(result)
                    if result[1] and result[#result] then
                        local item = result[#result]
                        if item then
                            local itemCraftedId = item.id
                            MySQL.insert(
                                "INSERT INTO character_inventories (character_id, item_crafted_id, amount, inventory_type) VALUES (@charid, @itemid, @amount, @invId);"
                                , {
                                    ['charid'] = tonumber(sourceCharIdentifier),
                                    ['itemid'] = tonumber(itemCraftedId),
                                    ['amount'] = tonumber(amount),
                                    ['invId'] = invId
                                }, function()
                                    cb({ id = itemCraftedId })
                                end)
                        end
                    end
                end)
        end)
end

--- update asynchronously
---@param query string @SQL query
---@param params table @SQL params
---@param cb function @Callback function
function DBService.updateAsync(query, params, cb)
    MySQL.update(query, params, cb)
end

--- insert asynchronously
---@param query string @SQL query
---@param params table @SQL params
---@param cb function @Callback function
function DBService.insertAsync(query, params, cb)
    MySQL.insert(query, params, cb)
end

--- query asynchronously
---@param query string @SQL query
---@param params table @SQL params
---@param cb function @Callback function
function DBService.queryAsync(query, params, cb)
    MySQL.query(query, params, cb)
end

---delete asynchronously
---@param query string @SQL query
---@param params table @SQL params
---@param cb function @Callback function
function DBService.deleteAsync(query, params, cb)
    MySQL.query(query, params, cb)
end

--- query asynchronously
---@param query string @SQL query
---@param params table @SQL params
---return table
function DBService.queryAwait(query, params)
    local res = MySQL.query.await(query, params)
    return res
end

--- single synchrounously
---@param query string @SQL query
---@param params table @SQL params
---return table
function DBService.singleAwait(query, params)
    local res = MySQL.single.await(query, params)
    return res
end
