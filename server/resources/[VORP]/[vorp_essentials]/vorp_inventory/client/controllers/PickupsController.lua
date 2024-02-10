-- PICKUPS CONTROLLER
-- server events
RegisterNetEvent("vorpInventory:createPickup", PickupsService.createPickup)
RegisterNetEvent("vorpInventory:createMoneyPickup", PickupsService.createMoneyPickup)
RegisterNetEvent("vorpInventory:createGoldPickup", PickupsService.createGoldPickup)
RegisterNetEvent("vorpInventory:sharePickupClient", PickupsService.sharePickupClient)  
RegisterNetEvent("vorpInventory:shareMoneyPickupClient", PickupsService.shareMoneyPickupClient)
RegisterNetEvent("vorpInventory:shareGoldPickupClient", PickupsService.shareGoldPickupClient)
RegisterNetEvent("vorpInventory:removePickupClient", PickupsService.removePickupClient)
RegisterNetEvent("vorpInventory:playerAnim", PickupsService.playerAnim)
-- shared
RegisterNetEvent("vorp:PlayerForceRespawn")
AddEventHandler("vorp:PlayerForceRespawn", PickupsService.DeadActions)
