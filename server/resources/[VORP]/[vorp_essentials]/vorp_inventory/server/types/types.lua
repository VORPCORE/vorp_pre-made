-- Credits to OX team for the types idea
---@meta

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- checks item limit
---@param source integer player id
---@param item string item name
---@param amount number amount of item
---@param callback fun(canCarry:boolean)?  callback function async or sync leave nil
---@return boolean
function exports.vorp_inventory:canCarryItem(source, item, amount, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- can carry weapons
---@param source integer player id
---@param amount number amount of weapons
---@param weaponName string | number weapon name or hash names needs to be passed to allow inv weight check
---@param callback fun(canCarry: boolean)? callback function async or sync leave nil
---@return boolean
function exports.vorp_inventory:canCarryWeapons(source, amount, callback, weaponName) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- gets user inventory items
---@param source integer player id
---@param callback fun(canCarry:boolean)? callback function async or sync leave nil
---@return table items table
function exports.vorp_inventory:getUserInventoryItems(source, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
---@param item string item name
---@param callback fun(item:table)
---@return string the callbackId to be used to cancel the callback
function exports.vorp_inventory:registerUsableItem(item, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- remove callback for item
---@param name string item name
---@param uniqueId string id generated when registering the item callback
function exports.vorp_inventory:unRegisterUsableItem(name, uniqueId) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- get user inventory weapon
---@param source integer player id
---@param callback fun(weapon:table)? callback function async or sync leave nil
---@param weaponId number weapon id
---@return table weapon data
function exports.vorp_inventory:getUserWeapon(source, callback, weaponId) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- get user inventory weapons
---@param source integer player id
---@param callback fun(weapons:table)? callback function async or sync leave nil
---@return table weapons table
function exports.vorp_inventory:getUserInventoryWeapons(source, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- get weapon bullets
---@param source integer player id
---@param weaponID number weapon id
---@param callback fun(ammo:number)? callback function async or sync leave nil
---@return number
function exports.vorp_inventory:getWeaponBullets(source, weaponID, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- remove all user ammo
---@param source integer player id
---@param callback fun(success: boolean)? async or sync callback
---@return boolean
function exports.vorp_inventory:removeAllUserAmmo(source, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- add bullets
---@param source integer player id
---@param bulletType string bullet type
---@param amount number amount of bullets
---@param callback fun(success: boolean)? async or sync callback
---@return boolean
function exports.vorp_inventory:addBullets(source, bulletType, amount, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- remove bullets from weapon
---@param weaponId number weapon id
---@param bulletType string bullet type
---@param amount number amount of bullets
---@param callback fun(success: boolean)? async or sync callback
---@return boolean
function exports.vorp_inventory:subBullets(weaponId, bulletType, amount, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- get user ammo
---@param source integer player id
---@param callback fun(success: boolean)? async or sync callback
---@return boolean
function exports.vorp_inventory:getUserAmmo(source, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- get item amount
---@param source integer player id
---@param item string item name
---@param metadata table |nil  item metadata
---@param callback fun(amount:number)? callback function async or sync leave nil
---@return number
function exports.vorp_inventory:getItemCount(source, callback, item, metadata) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- get item amount by name
---@param source integer player id
---@param item string item name
---@param callback fun(item:table)? callback function async or sync leave nil
---@return table item data
function exports.vorp_inventory:getItemByName(source, item, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- get item containing metadata
---@param source integer player id
---@param item string item name
---@param metadata table item metadata
---@param callback fun(item:table)? callback function async or sync leave nil
---@return table item data
function exports.vorp_inventory:getItemContainingMetadata(source, item, metadata, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- get item matching metdata
---@param source integer player id
---@param item string item name
---@param metadata table item metadata
---@param callback fun(item:table)? callback function async or sync leave nil
---@return table item data
function exports.vorp_inventory:getItemMatchingMetadata(source, item, metadata, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- get DB item
---@param item string item name
---@param callback fun(item:table)? callback function async or sync leave nil
---@return table| nil item data
function exports.vorp_inventory:getItemDB(item, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- set weapon custom serial number
---@param weaponId number weapon id
---@param serial string serial number
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
---@return boolean
function exports.vorp_inventory:setWeaponSerialNumber(weaponId, serial, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- set weapon custom label
---@param weaponId number weapon id
---@param label string label
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
---@return boolean
function exports.vorp_inventory:setWeaponCustomLabel(weaponId, label, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- set weapon custom description
---@param weaponId number weapon id
---@param desc string description
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
---@return boolean
function exports.vorp_inventory:setWeaponCustomDesc(weaponId, desc, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- add item to user
---@param source integer player id
---@param item string item name
---@param amount number amount of item
---@param metadata table?  item metadata
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
function exports.vorp_inventory:addItem(source, item, amount, metadata, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- get item by main id
---@param source integer player id
---@param mainid number main id
---@param callback fun(item:table)? callback function async or sync leave nil
function exports.vorp_inventory:getItemByMainId(source, mainid, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- sun item by item id
---@param source integer player id
---@param id number item id
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
function exports.vorp_inventory:subItemID(source, id, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- sub item
---@param source integer player id
---@param item string item name
---@param amount number amount of item
---@param metadata table |nil item metadata
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
function exports.vorp_inventory:subItem(source, item, amount, metadata, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- set item metadata
---@param source integer player id
---@param itemId number item id
---@param metadata table `{ description:string?, image:string?}` **description** and **image** are reserved keys if they are not defined they will be ignored, image is the image name to apply
---@param amount number? amount of item
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
function exports.vorp_inventory:setItemMetadata(source, itemId, metadata, amount, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- get item data
---@param source integer player id
---@param item string item name
---@param callback fun(item:table)? callback function async or sync leave nil
---@param metadata table |nil item metadata
---@return table item data
function exports.vorp_inventory:getItem(source, item, callback, metadata) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- get wweapon components
---@param source integer player id
---@param weaponId number weapon id
---@param callback fun(components:table)? callback function async or sync leave nil
---@return table weapon components
function exports.vorp_inventory:getWeaponComponents(source, weaponId, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- delete weapon
---@param source integer player id
---@param weaponId number weapon id
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
function exports.vorp_inventory:deleteWeapon(source, weaponId, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- create Weapon
---@param source integer player id
---@param weaponName string weapon name
---@param ammo table ammo
---@param components table? weapon components
---@param comps table? weapon components
---@param custom_serial string? weapon serial number
---@param custom_label string? weapon custom label
---@param custom_desc? string? weapon custom description
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
function exports.vorp_inventory:createWeapon(source, weaponName, ammo, components, comps, callback, custom_serial, custom_label, custom_desc) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- give weapon
---@param source integer player id
---@param weaponId number weapon id
---@param target number target id
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
---@return boolean
function exports.vorp_inventory:giveWeapon(source, weaponId, target, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- sub weapon
---@param source integer player id
---@param weaponId number weapon id
---@param callback fun(boolean:boolean)? callback function async or sync leave nil
---@return boolean
function exports.vorp_inventory:subWeapon(source, weaponId, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- register custom inventory
---@param data { id:string, name:string, limit:number, acceptWeapons:boolean, shared:boolean, ignoreItemStackLimit:boolean, whitelistItems:boolean, UsePermissions:boolean, UseBlackList:boolean, whitelistWeapons:boolean,webhook:string }
---@return table methods to interact with the inventory
function exports.vorp_inventory:registerInventory(data) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- add permissions to move item to inventory
---@param invId string inventory id
---@param jobName string job name
---@param jobgrade number job grade
function exports.vorp_inventory:AddPermissionMoveToCustom(invId, jobName, jobgrade) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- add permissions to take item from inventory
---@param invId string inventory id
---@param jobName string job name
---@param jobgrade number job grade
function exports.vorp_inventory:AddPermissionTakeFromCustom(invId, jobName, jobgrade) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- add char id permissions to move item to inventories
---@param invId string inventory id
---@param charId number char id
---@param state boolean | nil state of permission nil will remove the permission if char id exists true or false will set the permission
function exports.vorp_inventory:AddCharIdPermissionMoveToCustom(invId, charId, state) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- add char id permissions to take item from inventories
---@param invId string inventory id
---@param charId number char id
---@param state boolean | nil state of permission nil will remove the permission if char id exists true or false will set the permission
function exports.vorp_inventory:AddCharIdPermissionTakeFromCustom(invId, charId, state) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- black list items or weapons
---@param invId string inventory id
---@param item string item name | weapon name
function exports.vorp_inventory:BlackListCustomAny(invId, item) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- remove inventory from session
---@param invId string inventory id
function exports.vorp_inventory:removeInventory(invId) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- update inventory slots
---@param invId string inventory id
---@param slots number inventory slots
function exports.vorp_inventory:updateCustomInventorySlots(invId, slots) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- item limit
---@param invId string inventory id
---@param item string item name
---@param limit number item limit
function exports.vorp_inventory:setCustomInventoryItemLimit(invId, item, limit) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- weapon limit
---@param invId string inventory id
---@param weapon string weapon name
---@param limit number weapon limit
function exports.vorp_inventory:setCustomInventoryWeaponLimit(invId, weapon, limit) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- open inventory
---@param source integer player id
---@param invId string? inventory id
function exports.vorp_inventory:openInventory(source, invId) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- close inventory
---@param source integer player id
---@param invId string? inventory id
function exports.vorp_inventory:closeInventory(source, invId) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
---check if inventory is registered
---@param id string inventory id
---@param callback fun()? callback function async or sync leave nil
function exports.vorp_inventory:isCustomInventoryRegistered(id, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- get all custom inventory data
---@param id string inventory id
---@param callback fun(data:table)? callback function async or sync leave nil
function exports.vorp_inventory:getCustomInventoryData(id, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- update custom inventory data
---@param data table data to update
---@param callback fun(success:boolean)? callback function async or sync leave nil
function exports.vorp_inventory:updateCustomInvData(data, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- open player inventory
---@param data table data to update
function exports.vorp_inventory:openPlayerInventory(data) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- add items to custom inventory
---@param invId string inventory id
---@param item {name:string, amount:number, metadata:table?}[]
---@param charId number char id
---@param callback fun(success:boolean)? callback function async or sync leave nil
function exports.vorp_inventory:addItemsToCustomInventory(invId, item, charId, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- add weapons to custom inventory
---@param invId string inventory id
---@param weapons {name:string, custom_serial:string?, custom_label:string?, custom_desc:string?}[]
---@param charId number char id
---@param callback fun(success:boolean)? callback function async or sync leave nil
function exports.vorp_inventory:addWeaponsToCustomInventory(invId, weapons, charId, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- get amount of item in custom inventory
---@param invId string inventory id
---@param item string item name
---@param callback fun(amount:number)? callback function async or sync leave nil
---@return number
function exports.vorp_inventory:getCustomInventoryItemCount(invId, item, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- get amount weapon in custom inventory
---@param invId string inventory id
---@param weaponName string weapon name
---@param callback fun(amount:number)? callback function async or sync leave nil
---@return number
function exports.vorp_inventory:getCustomInventoryWeaponCount(invId, weaponName, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- remove item from custom inventory
---@param invid string inventory id
---@param itemName string item name
---@param callback fun(result:number)? async or sync callback
---@return boolean
function exports.vorp_inventory:removeItemFromCustomInventory(invid, itemName, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- remove weapon from custom inventory
---@param invid string inventory id
---@param weaponName string weapon name
---@param callback fun(result:number)? async or sync callback
---@return boolean
function exports.vorp_inventory:removeWeaponFromCustomInventory(invid, weaponName, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- get all items in custom inventory
--- @param invId string inventory id
--- @param callback fun(items:table)? async or sync callback
--- @return table items
function exports.vorp_inventory:getCustomInventoryItems(invId, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- get all weapons in custom inventory
--- @param invId string inventory id
--- @param callback fun(weapons:table)? async or sync callback
--- @return table weapons
function exports.vorp_inventory:getCustomInventoryWeapons(invId, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- update item in custom inventory
--- @param invId string inventory id
--- @param item_id number item id
--- @param metadata table metadata to update
--- @param amount number? amount of item
--- @param callback fun(success:boolean)? async or sync callback
--- @return boolean
function exports.vorp_inventory:updateCustomInventoryItem(invId, item_id, metadata, amount, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- remove/update item/amount from custom inventory by item id
--- @param invId string inventory id
--- @param item_id number item id
--- @param callback fun(success:boolean)? async or sync callback
--- @return boolean
function exports.vorp_inventory:removeCustomInventoryItemById(invId, item_id, callback) end

--- see [documentation](https://vorpcore.github.io/VORP_Documentation/api/inventory#inventory-exports)<br>
--- remove weapon from custom inventory by weapon id
--- @param invId string inventory id
--- @param weapon_id number weapon id
--- @param callback fun(success:boolean)? async or sync callback
--- @return boolean
function exports.vorp_inventory:removeCustomInventoryWeaponById(invId, weapon_id, callback) end
