-- InventoryApiController server to client events
RegisterNetEvent("vorpCoreClient:addItem", InventoryApiService.addItem)
RegisterNetEvent("vorpCoreClient:subItem", InventoryApiService.subItem)
RegisterNetEvent("vorpCoreClient:subWeapon", InventoryApiService.subWeapon)
RegisterNetEvent("vorpCoreClient:addBullets", InventoryApiService.addWeaponBullets)
RegisterNetEvent("vorpCoreClient:subBullets", InventoryApiService.subWeaponBullets)
RegisterNetEvent("vorpCoreClient:addComponent", InventoryApiService.addComponent)
RegisterNetEvent("vorpCoreClient:subComponent", InventoryApiService.subComponent)
