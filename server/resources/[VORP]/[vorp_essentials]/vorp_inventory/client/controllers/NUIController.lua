--=========================== NUI CALL BACKS  ===========================--
RegisterNUICallback('NUIFocusOff', NUIService.NUIFocusOff)
RegisterNUICallback('DropItem', NUIService.NUIDropItem)
RegisterNUICallback('UseItem', NUIService.NUIUseItem)
RegisterNUICallback('sound', NUIService.NUISound)
RegisterNUICallback('GiveItem', NUIService.NUIGiveItem)
RegisterNUICallback('GetNearPlayers', NUIService.NUIGetNearPlayers)
RegisterNUICallback('UnequipWeapon', NUIService.NUIUnequipWeapon)
RegisterNUICallback('TakeFromCustom', NUIService.NUITakeFromCustom)
RegisterNUICallback('MoveToCustom', NUIService.NUIMoveToCustom)
RegisterNUICallback("ChangeClothing", NUIService.ChangeClothing)
RegisterNUICallback("TakeFromPlayer", NUIService.NUITakeFromPlayer)
RegisterNUICallback("MoveToPlayer", NUIService.NUIMoveToPlayer)
RegisterNUICallback('getActionsConfig', NUIService.getActionsConfig)
--========================================================================--
-- shared
RegisterNetEvent("vorp_inventory:CloseInv")
AddEventHandler("vorp_inventory:CloseInv", NUIService.CloseInv)

-- client
AddEventHandler("vorp_inventory:Client:DisableInventory", NUIService.DisableInventory)
-- server
RegisterNetEvent("vorp_inventory:ProcessingReady", NUIService.setProcessingPayFalse)
RegisterNetEvent("vorp_inventory:OpenInv", NUIService.OpenInv)
RegisterNetEvent("vorp_inventory:setNearbyCharacters", NUIService.NUISetNearPlayers)
RegisterNetEvent("vorp_inventory:OpenCustomInv", NUIService.OpenCustomInventory)
RegisterNetEvent("vorp_inventory:CloseCustomInv", NUIService.CloseInv)
RegisterNetEvent("vorp_inventory:ReloadCustomInventory", NUIService.ReloadInventory)
RegisterNetEvent("vorp_inventory:transactionStarted", NUIService.TransactionStarted)
RegisterNetEvent("vorp_inventory:transactionCompleted", NUIService.TransactionComplete)
RegisterNetEvent("vorp_inventory:OpenPlayerInventory", NUIService.OpenPlayerInventory)
RegisterNetEvent("vorp_inventory:server:CacheImages", NUIService.CacheImages)
-- SYN SCRIPT EVENTS
-- Store Module
RegisterNetEvent("vorp_inventory:OpenStoreInventory")
AddEventHandler("vorp_inventory:OpenStoreInventory", NUIService.OpenStoreInventory)
RegisterNetEvent("vorp_inventory:ReloadStoreInventory")
AddEventHandler("vorp_inventory:ReloadStoreInventory", NUIService.ReloadInventory)
RegisterNUICallback('TakeFromStore', NUIService.NUITakeFromStore)
RegisterNUICallback('MoveToStore', NUIService.NUIMoveToStore)

-- Horse Module
RegisterNetEvent("vorp_inventory:OpenHorseInventory")
AddEventHandler("vorp_inventory:OpenHorseInventory", NUIService.OpenHorseInventory)
RegisterNetEvent("vorp_inventory:ReloadHorseInventory")
AddEventHandler("vorp_inventory:ReloadHorseInventory", NUIService.ReloadInventory)
RegisterNUICallback('TakeFromHorse', NUIService.NUITakeFromHorse)
RegisterNUICallback('MoveToHorse', NUIService.NUIMoveToHorse)

-- Steal
RegisterNetEvent("vorp_inventory:OpenstealInventory")
AddEventHandler("vorp_inventory:OpenstealInventory", NUIService.OpenstealInventory)
RegisterNetEvent("vorp_inventory:ReloadstealInventory")
AddEventHandler("vorp_inventory:ReloadstealInventory", NUIService.ReloadInventory)
RegisterNUICallback('TakeFromsteal', NUIService.NUITakeFromsteal)
RegisterNUICallback('MoveTosteal', NUIService.NUIMoveTosteal)

-- Cart Module
RegisterNetEvent("vorp_inventory:OpenCartInventory")
AddEventHandler("vorp_inventory:OpenCartInventory", NUIService.OpenCartInventory)
RegisterNetEvent("vorp_inventory:ReloadCartInventory")
AddEventHandler("vorp_inventory:ReloadCartInventory", NUIService.ReloadInventory)
RegisterNUICallback('TakeFromCart', NUIService.NUITakeFromCart)
RegisterNUICallback('MoveToCart', NUIService.NUIMoveToCart)

-- House Module
RegisterNetEvent("vorp_inventory:OpenHouseInventory")
AddEventHandler("vorp_inventory:OpenHouseInventory", NUIService.OpenHouseInventory)
RegisterNetEvent("vorp_inventory:ReloadHouseInventory")
AddEventHandler("vorp_inventory:ReloadHouseInventory", NUIService.ReloadInventory)
RegisterNUICallback('TakeFromHouse', NUIService.NUITakeFromHouse)
RegisterNUICallback('MoveToHouse', NUIService.NUIMoveToHouse)

-- Bank Module
RegisterNetEvent("vorp_inventory:OpenBankInventory")
AddEventHandler("vorp_inventory:OpenBankInventory", NUIService.OpenBankInventory)
RegisterNetEvent("vorp_inventory:ReloadBankInventory")
AddEventHandler("vorp_inventory:ReloadBankInventory", NUIService.ReloadInventory)
RegisterNUICallback('TakeFromBank', NUIService.NUITakeFromBank)
RegisterNUICallback('MoveToBank', NUIService.NUIMoveToBank)

--Hideout Module
RegisterNetEvent("vorp_inventory:OpenHideoutInventory")
AddEventHandler("vorp_inventory:OpenHideoutInventory", NUIService.OpenHideoutInventory)

RegisterNetEvent("vorp_inventory:ReloadHideoutInventory")
AddEventHandler("vorp_inventory:ReloadHideoutInventory", NUIService.ReloadInventory)
RegisterNUICallback("TakeFromHideout", NUIService.NUITakeFromHideout)
RegisterNUICallback("MoveToHideout", NUIService.NUIMoveToHideout)

-- Clan Module
RegisterNetEvent("vorp_inventory:OpenClanInventory")
AddEventHandler("vorp_inventory:OpenClanInventory", NUIService.OpenClanInventory)
RegisterNetEvent("vorp_inventory:ReloadClanInventory")
AddEventHandler("vorp_inventory:ReloadClanInventory", NUIService.ReloadInventory)
RegisterNUICallback("TakeFromClan", NUIService.NUITakeFromClan)
RegisterNUICallback("MoveToClan", NUIService.NUIMoveToClan)

-- Container Module
RegisterNetEvent("vorp_inventory:OpenContainerInventory")
AddEventHandler("vorp_inventory:OpenContainerInventory", NUIService.OpenContainerInventory)
RegisterNetEvent("vorp_inventory:ReloadContainerInventory")
AddEventHandler("vorp_inventory:ReloadContainerInventory", NUIService.ReloadInventory)
RegisterNUICallback("TakeFromContainer", NUIService.NUITakeFromContainer);
RegisterNUICallback("MoveToContainer", NUIService.NUIMoveToContainer);
