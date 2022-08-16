RegisterServerEvent("vorpCore:subWeapon")
AddEventHandler("vorpCore:subWeapon", InventoryAPI.subWeapon)

RegisterServerEvent("vorpCore:giveWeapon")
AddEventHandler("vorpCore:giveWeapon", InventoryAPI.giveWeapon)

RegisterServerEvent("vorpCore:registerWeapon")
AddEventHandler("vorpCore:registerWeapon", InventoryAPI.registerWeapon)

RegisterServerEvent("vorpCore:addItem")
AddEventHandler("vorpCore:addItem", InventoryAPI.addItem)

RegisterServerEvent("vorpCore:subItem")
AddEventHandler("vorpCore:subItem", InventoryAPI.subItem)

RegisterServerEvent("vorpCore:getItem")
AddEventHandler("vorpCore:getItem", InventoryAPI.getItem)

RegisterServerEvent("vorpCore:getItemByName")
AddEventHandler("vorpCore:getItemByName", InventoryAPI.getItemByName)

RegisterServerEvent("vorpCore:getcomps")
AddEventHandler("vorpCore:getcomps", InventoryAPI.getcomps)

RegisterServerEvent("vorpCore:deletegun")
AddEventHandler("vorpCore:deletegun", InventoryAPI.deletegun)

RegisterServerEvent("vorpCore:getItemContainingMetadata")
AddEventHandler("vorpCore:getItemContainingMetadata", InventoryAPI.getItemContainingMetadata)

RegisterServerEvent("vorpCore:getItemMatchingMetadata")
AddEventHandler("vorpCore:getItemMatchingMetadata", InventoryAPI.getItemMatchingMetadata)

RegisterServerEvent("vorpCore:getItemCount")
AddEventHandler("vorpCore:getItemCount", InventoryAPI.getItems)

RegisterServerEvent("vorpCore:getUserInventory")
AddEventHandler("vorpCore:getUserInventory", InventoryAPI.getInventory)

RegisterServerEvent("vorpCore:LoadAllAmmo")
AddEventHandler("vorpCore:LoadAllAmmo", InventoryAPI.LoadAllAmmo)

RegisterServerEvent("vorpCore:canCarryItems")
AddEventHandler("vorpCore:canCarryItems", InventoryAPI.canCarryAmountItem)

RegisterServerEvent("vorpCore:canCarryItem")
AddEventHandler("vorpCore:canCarryItem", InventoryAPI.canCarryItem)

RegisterServerEvent("vorpCore:canCarryWeapons")
AddEventHandler("vorpCore:canCarryWeapons", InventoryAPI.canCarryAmountWeapons)

RegisterServerEvent("vorpCore:subBullets")
AddEventHandler("vorpCore:subBullets", InventoryAPI.subBullets)

RegisterServerEvent("vorpCore:addBullets")
AddEventHandler("vorpCore:addBullets", InventoryAPI.addBullets)

RegisterServerEvent("vorpCore:getWeaponBullets")
AddEventHandler("vorpCore:getWeaponBullets", InventoryAPI.getWeaponBullets)

RegisterServerEvent("vorpCore:getUserWeapons")
AddEventHandler("vorpCore:getUserWeapons", InventoryAPI.getUserWeapons)

RegisterServerEvent("vorpCore:getUserWeapon")
AddEventHandler("vorpCore:getUserWeapon", InventoryAPI.getUserWeapon)

RegisterServerEvent("vorpCore:registerUsableItem")
AddEventHandler("vorpCore:registerUsableItem", InventoryAPI.registerUsableItem)

RegisterServerEvent("vorp_NewCharacter")
AddEventHandler("vorp_NewCharacter", InventoryAPI.onNewCharacter)

--#region Custom Inventory

RegisterServerEvent("vorpCore:registerInventory")
AddEventHandler("vorpCore:registerInventory", InventoryAPI.registerInventory)

RegisterServerEvent("vorpCore:removeInventory")
AddEventHandler("vorpCore:removeInventory", InventoryAPI.removeInventory)

RegisterServerEvent("vorpCore:openCustomInventory")
AddEventHandler("vorpCore:openCustomInventory", InventoryAPI.openCustomInventory)

RegisterServerEvent("vorpCore:closeCustomInventory")
AddEventHandler("vorpCore:closeCustomInventory", InventoryAPI.closeCustomInventory)

RegisterServerEvent("vorpCore:setInventoryItemLimit")
AddEventHandler("vorpCore:setInventoryItemLimit", InventoryAPI.setCustomInventoryItemLimit)

--#endregion

