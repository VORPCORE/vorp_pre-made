---@diagnostic disable: undefined-global
-- Credits to OX team for the types idea
---@meta


--- check inventory limit
---@param source number player id
---@param amount number amount of item
---@param callback fun(canCarry:boolean)?  callback function async or sync leave nil
---@return boolean
function exports.vorp_inventory:canCarryItems(source, amount, callback) end

--- checks item limit
---@param source number player id
---@param item string item name
---@param amount number amount of item
---@param callback fun(canCarry:boolean)?  callback function async or sync leave nil
---@return boolean
function exports.vorp_inventory:canCarryItem(source, item, amount, callback) end

--- can carry weapons
---@param source number player id
---@param amount number amount of weapons
---@param weaponName string? weapon name not neccesary but allows to check if weapon is in the list of not weapons
---@param callback fun(canCarry: boolean)? callback function async or sync leave nil
---@return boolean
function exports.vorp_inventory:canCarryWeapons(source, amount, callback, weaponName) end

--- gets user inventory items
---@param source number player id
---@param callback fun(canCarry:boolean)? callback function async or sync leave nil
---@return table items table
function exports.vorp_inventory:getUserInventoryItems(source, callback) end

---@param item string item name
---@param callback fun(item:table)
---@return string the callbackId to be used to cancel the callback
function exports.vorp_inventory:registerUsableItem(item, callback) end

--- remove callback for item
---@param name string item name
---@param uniqueId string id generated when registering the item callback
function exports.vorp_inventory:unRegisterUsableItem(name, uniqueId) end

--- get user inventory weapon
---@param source number player id
---@param callback fun(weapon:table)? callback function async or sync leave nil
---@param weaponId number weapon id
---@return table weapon data
function exports.vorp_inventory:getUserWeapon(source, callback, weaponId) end

--- get user inventory weapons
---@param source number player id
---@param callback fun(weapons:table)? callback function async or sync leave nil
---@return table weapons table
function exports.vorp_inventory:getUserInventoryWeapons(source, callback) end

--- get weapon bullets
---@param source number player id
---@param weaponID number weapon id
---@param callback fun(ammo:number)? callback function async or sync leave nil
---@return number
function exports.vorp_inventory:getWeaponBullets(source, weaponID, callback) end

--- remove all user ammo
---@param source number player id
---@param callback fun(success: boolean)? async or sync callback
---@return boolean
function exports.vorp_inventory:removeAllUserAmmo(source, callback) end

--- add bullets
---@param source number player id
---@param bulletType string bullet type
---@param amount number amount of bullets
---@param callback fun(success: boolean)? async or sync callback
---@return boolean
function exports.vorp_inventory:addBullets(source, bulletType, amount, callback) end

--- remove bullets from weapon
---@param weaponId number weapon id
---@param bulletType string bullet type
---@param amount number amount of bullets
---@param callback fun(success: boolean)? async or sync callback
---@return boolean
function exports.vorp_inventory:subBullets(weaponId, bulletType, amount, callback) end

--- get item amount
---@param source number player id
---@param item string item name
---@param metadata table |nil  item metadata
---@param callback fun(amount:number)? callback function async or sync leave nil
---@return number
function exports.vorp_inventory:getItemCount(source, callback, item, metadata) end

--- get item amount by name
---@param source number player id
---@param item string item name
---@param callback fun(item:table)? callback function async or sync leave nil
---@return table item data
function exports.vorp_inventory:getItemByName(source, item, callback) end

--- get item containing metadata
---@param source number player id
---@param item string item name
---@param metadata table item metadata
---@param callback fun(item:table)? callback function async or sync leave nil
---@return table item data
function exports.vorp_inventory:getItemContainingMetadata(source, item, metadata, callback) end

--- get item matching metdata
---@param source number player id
---@param slot number slot id
---@param metadata table item metadata
---@param callback fun(item:table)? callback function async or sync leave nil
---@return table item data
function exports.vorp_inventory:getItemMatchingMetadata(source, slot, metadata, callback) end

--- get DB item
---@param item string item name
---@param callback fun(item:table)? callback function async or sync leave nil
---@return table| nil item data
function exports.vorp_inventory:getItemDB(item, callback) end

--- set weapon custom serial number
---@param weaponId number weapon id
---@param serial string serial number
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
---@return boolean
function exports.vorp_inventory:setWeaponSerialNumber(weaponId, serial, callback) end

--- set weapon custom label
---@param weaponId number weapon id
---@param label string label
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
---@return boolean
function exports.vorp_inventory:setWeaponCustomLabel(weaponId, label, callback) end

--- set weapon custom description
---@param weaponId number weapon id
---@param desc string description
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
---@return boolean
function exports.vorp_inventory:setWeaponCustomDesc(weaponId, desc, callback) end

--- add item to user
---@param source number player id
---@param item string item name
---@param amount number amount of item
---@param metadata table?  item metadata
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
function exports.vorp_inventory:addItem(source, item, amount, metadata, callback) end

--- get item by main id
---@param source number player id
---@param mainid number main id
---@param callback fun(item:table)? callback function async or sync leave nil
function exports.vorp_inventory:getItemByMainId(source, mainid, callback) end

--- sun item by item id
---@param source number player id
---@param id number item id
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
function exports.vorp_inventory:subItemID(source, id, callback) end

--- sub item
---@param source number player id
---@param item string item name
---@param amount number amount of item
---@param metadata table |nil item metadata
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
function exports.vorp_inventory:subItem(source, item, amount, metadata, callback) end

--- set item metadata
---@param source number player id
---@param itemId number item id
---@param metadata table item metadata
---@param amount number amount of item
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
function exports.vorp_inventory:setItemMetadata(source, itemId, metadata, amount, callback) end

--- get item data
---@param source number player id
---@param item string item name
---@param callback fun(item:table)? callback function async or sync leave nil
---@param metadata table |nil item metadata
---@return table item data
function exports.vorp_inventory:getItem(source, item, callback, metadata) end

--- get wweapon components
---@param source number player id
---@param weaponId number weapon id
---@param callback fun(components:table)? callback function async or sync leave nil
---@return table weapon components
function exports.vorp_inventory:getWeaponComponents(source, weaponId, callback) end

--- delete weapon
---@param source number player id
---@param weaponId number weapon id
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
function exports.vorp_inventory:deleteWeapon(source, weaponId, callback) end

--- create Weapon
---@param source number player id
---@param weaponName string weapon name
---@param ammo table ammo
---@param components table? weapon components
---@param comps table? weapon components
---@param custom_serial string? weapon serial number
---@param custom_label string? weapon custom label
---@param custom_desc? string? weapon custom description
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
function exports.vorp_inventory:createWeapon(source, weaponName, ammo, components, comps, callback, custom_serial,
                                             custom_label, custom_desc)
end

--- give weapon
---@param source number player id
---@param weaponId number weapon id
---@param target number target id
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
---@return boolean
function exports.vorp_inventory:giveWeapon(source, weaponId, target, callback) end

--- sub weapon
---@param source number player id
---@param weaponId number weapon id
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
---@return boolean
function exports.vorp_inventory:subWeapon(source, weaponId, callback) end

--- register custom inventory
---@param data { id:string, name:string, limit:number, acceptWeapons:boolean, shared:boolean, ignoreItemStackLimit:boolean, whitelistItems:boolean, UsePermissions:boolean, UseBlackList:boolean, whitelistWeapons:boolean }
function exports.vorp_inventory:registerInventory(data) end

--- add permissions to move item to inventory
---@param invId string inventory id
---@param jobName string job name
---@param jobgrade number job grade
function exports.vorp_inventory:AddPermissionMoveToCustom(invId, jobName, jobgrade) end

--- add permissions to take item from inventory
---@param invId string inventory id
---@param jobName string job name
---@param jobgrade number job grade
function exports.vorp_inventory:AddPermissionTakeFromCustom(invId, jobName, jobgrade) end

--- black list items or weapons
---@param invId string inventory id
---@param item string item name | weapon name
function exports.vorp_inventory:blackListCustomAny(invId, item) end

--- remove inventory from session
---@param invId string inventory id
function exports.vorp_inventory:removeInventory(invId) end

--- update inventory slots
---@param invId string inventory id
---@param slots number inventory slots
function exports.vorp_inventory:updateCustomInventorySlots(invId, slots) end

--- item limit
---@param invId string inventory id
---@param item string item name
---@param limit number item limit
function exports.vorp_inventory:setCustomInventoryItemLimit(invId, item, limit) end

--- weapon limit
---@param invId string inventory id
---@param weapon string weapon name
---@param limit number weapon limit
function exports.vorp_inventory:setCustomInventoryWeaponLimit(invId, weapon, limit) end

--- open inventory
---@param source number player id
---@param invId string? inventory id
function exports.vorp_inventory:openInventory(source, invId) end

--- close inventory
---@param source number player id
---@param invId string? inventory id
function exports.vorp_inventory:closeInventory(source, invId) end

---check if inventory is registered
---@param id string inventory id
---@param callback fun()? callback function async or sync leave nil
function exports.vorp_inventory:isCustomInventoryRegistered(id, callback) end

--- get all custom inventory data
---@param id string inventory id
---@param callback fun(data:table)? callback function async or sync leave nil
function exports.vorp_inventory:getCustomInventoryData(id, callback) end

--- update custom inventory data
---@param data table data to update
---@param callback fun(success:boolean)? callback function async or sync leave nil
function exports.vorp_inventory:updateCustomInvData(data, callback) end
