RegisterServerEvent("vorpinventory:getItemsTable")
AddEventHandler("vorpinventory:getItemsTable", InventoryService.getItemsTable)

RegisterServerEvent("vorpinventory:getInventory")
AddEventHandler("vorpinventory:getInventory", InventoryService.getInventory)

RegisterServerEvent("vorpinventory:serverGiveItem")
AddEventHandler("vorpinventory:serverGiveItem", InventoryService.GiveItem)

RegisterServerEvent("vorpinventory:serverGiveWeapon")
AddEventHandler("vorpinventory:serverGiveWeapon", InventoryService.GiveWeapon)

RegisterServerEvent("vorpinventory:serverDropItem")
AddEventHandler("vorpinventory:serverDropItem", InventoryService.DropItem)

RegisterServerEvent("vorpinventory:serverDropMoney")
AddEventHandler("vorpinventory:serverDropMoney", InventoryService.DropMoney)

RegisterServerEvent("vorpinventory:serverDropAllMoney")
AddEventHandler("vorpinventory:serverDropAllMoney", InventoryService.DropAllMoney)

RegisterServerEvent("vorpinventory:serverDropPartMoney")
AddEventHandler("vorpinventory:serverDropPartMoney", InventoryService.DropPartMoney)

RegisterServerEvent("vorpinventory:serverDropGold")
AddEventHandler("vorpinventory:serverDropGold", InventoryService.DropGold)

RegisterServerEvent("vorpinventory:serverDropAllGold")
AddEventHandler("vorpinventory:serverDropAllGold", InventoryService.DropAllGold)

RegisterServerEvent("vorpinventory:serverDropWeapon")
AddEventHandler("vorpinventory:serverDropWeapon", InventoryService.DropWeapon)

RegisterServerEvent("vorpinventory:sharePickupServer")
AddEventHandler("vorpinventory:sharePickupServer", InventoryService.sharePickupServer)

RegisterServerEvent("vorpinventory:shareMoneyPickupServer")
AddEventHandler("vorpinventory:shareMoneyPickupServer", InventoryService.shareMoneyPickupServer)

RegisterServerEvent("vorpinventory:shareGoldPickupServer")
AddEventHandler("vorpinventory:shareGoldPickupServer", InventoryService.shareGoldPickupServer)

RegisterServerEvent("vorpinventory:onPickup")
AddEventHandler("vorpinventory:onPickup", InventoryService.onPickup)

RegisterServerEvent("vorpinventory:onPickupMoney")
AddEventHandler("vorpinventory:onPickupMoney", InventoryService.onPickupMoney)

RegisterServerEvent("vorpinventory:onPickupGold")
AddEventHandler("vorpinventory:onPickupGold", InventoryService.onPickupGold)

RegisterServerEvent("vorpinventory:setUsedWeapon")
AddEventHandler("vorpinventory:setUsedWeapon", InventoryService.usedWeapon)

RegisterServerEvent("vorpinventory:setWeaponBullets")
AddEventHandler("vorpinventory:setWeaponBullets", InventoryService.setWeaponBullets)

RegisterServerEvent("vorpinventory:giveMoneyToPlayer")
AddEventHandler("vorpinventory:giveMoneyToPlayer", InventoryService.giveMoneyToPlayer)

RegisterServerEvent("vorpinventory:giveGoldToPlayer")
AddEventHandler("vorpinventory:giveGoldToPlayer", InventoryService.giveGoldToPlayer)

RegisterServerEvent("vorp_inventory:useItem")
AddEventHandler("vorp_inventory:useItem", InventoryService.UseItem)

RegisterServerEvent("vorp_inventory:getNearbyCharacters")
AddEventHandler("vorp_inventory:getNearbyCharacters", InventoryService.getNearbyCharacters)


RegisterServerEvent("vorp_inventory:MoveToCustom")
AddEventHandler("vorp_inventory:MoveToCustom", InventoryService.MoveToCustom)

RegisterServerEvent("vorp_inventory:TakeFromCustom")
AddEventHandler("vorp_inventory:TakeFromCustom", InventoryService.TakeFromCustom)

