NUIService = {}
isProcessingPay = false
InInventory = false
timerUse = 0
local candrop = true 
local storemenu = false 
local geninfo = {}


RegisterNetEvent('inv:dropstatus')
AddEventHandler('inv:dropstatus', function(x)
	candrop = x
end)

NUIService.ReloadInventory = function(inventory)
    local payload = json.decode(inventory)
    for _, item in pairs(payload.itemList) do
        if item.type == "item_weapon" then
            item.label = Utils.GetWeaponLabel(item.name)
            if item.desc == nil then 
                item.desc = Utils.GetWeaponDesc(item.name)
            end
        end
    end

    SendNUIMessage(payload)
    Wait(500)
    NUIService.LoadInv()
end


NUIService.OpenCustomInventory = function(name, id, capacity)
	SetNuiFocus(true, true)
	print(capacity)
	SendNUIMessage({ action = "display", type = "custom", title = tostring(name), id = tostring(id), capacity = capacity })
	InInventory = true
end

NUIService.NUIMoveToCustom = function(obj)
	TriggerServerEvent("vorp_inventory:MoveToCustom", json.encode(obj))
end

NUIService.NUITakeFromCustom = function(obj)
	TriggerServerEvent("vorp_inventory:TakeFromCustom", json.encode(obj))
end

NUIService.OpenClanInventory = function(clanName, clanId, capacity)
	SetNuiFocus(true, true)
	SendNUIMessage({ action = "display", type = "clan", title = "" .. clanName .. "", clanid = clanId, capacity = capacity, search = Config.InventorySearchable })
	InInventory = true
end

NUIService.NUIMoveToClan = function(obj)
	TriggerServerEvent("syn_clan:MoveToClan", json.encode(obj))
end

NUIService.NUITakeFromClan = function(obj)
	TriggerServerEvent("syn_clan:TakeFromClan", json.encode(obj))
end

NUIService.OpenContainerInventory = function(ContainerName, Containerid, capacity)
	SetNuiFocus(true, true)
	SendNUIMessage({ action = "display", type = "Container", title = "" .. ContainerName .. "", Containerid = Containerid,
		capacity = capacity, search = Config.InventorySearchable })
	InInventory = true
end

NUIService.NUIMoveToContainer = function(obj)
	TriggerServerEvent("syn_Container:MoveToContainer", json.encode(obj))
end

NUIService.NUITakeFromContainer = function(obj)
	TriggerServerEvent("syn_Container:TakeFromContainer", json.encode(obj))
end

NUIService.CloseInventory = function()
	if storemenu then 
		storemenu = false 
		geninfo = {}
		for _, item in pairs(UserInventory) do
			if item.metadata ~= nil and item.metadata.description ~= nil and (item.metadata.orgdescription ~= nil or item.metadata.orgdescription == "") then 
				if item.metadata.orgdescription == "" then 
					item.metadata.description = nil
				else
					item.metadata.description = item.metadata.orgdescription 
				end
				item.metadata.orgdescription = nil 
			end
		end
	end
	SetNuiFocus(false, false)
	SendNUIMessage({ action = "hide" })
	InInventory = false
	TriggerEvent("vorp_stables:setClosedInv", false)
	TriggerEvent("syn:closeinv")
end
NUIService.CloseInv = function()
	if storemenu then 
		storemenu = false 
		geninfo = {}
		for _, item in pairs(UserInventory) do
			if item.metadata ~= nil and item.metadata.description ~= nil and (item.metadata.orgdescription ~= nil or item.metadata.orgdescription == "") then 
				if item.metadata.orgdescription == "" then 
					item.metadata.description = nil
				else
					item.metadata.description = item.metadata.orgdescription 
				end
				item.metadata.orgdescription = nil 
			end
		end
	end
	SetNuiFocus(false, false)
	SendNUIMessage({ action = "hide" })
	InInventory = false
	TriggerEvent("vorp_stables:setClosedInv", false)
	TriggerEvent("syn:closeinv")
end
NUIService.OpenHorseInventory = function(horseTitle, horseId, capacity)
	SetNuiFocus(true, true)
	SendNUIMessage({ action = "display", type = "horse", title = horseTitle, horseid = horseId, capacity = capacity, search = Config.InventorySearchable })
	InInventory = true
	TriggerEvent("vorp_stables:setClosedInv", true)
end

NUIService.NUIMoveToHorse = function(obj)
	TriggerServerEvent("vorp_stables:MoveToHorse", json.encode(obj))
end

NUIService.NUITakeFromHorse = function(obj)
	TriggerServerEvent("vorp_stables:TakeFromHorse", json.encode(obj))
end

NUIService.NUIMoveToStore = function(obj)
	TriggerServerEvent("syn_store:MoveToStore", json.encode(obj))
end

NUIService.NUITakeFromStore = function(obj)
	TriggerServerEvent("syn_store:TakeFromStore", json.encode(obj))
end


NUIService.OpenStoreInventory = function(StoreName, StoreId, capacity,geninfox)
	storemenu = true
	geninfo = geninfox
	SetNuiFocus(true, true)
	SendNUIMessage({ action = "display", type = "store", title = StoreName, StoreId = StoreId, capacity = capacity,geninfo=geninfo,search = Config.InventorySearchable })
	InInventory = true
	TriggerEvent("syn_store:setClosedInv", true)
end





NUIService.OpenstealInventory = function(stealName, stealId, capacity)
	SetNuiFocus(true, true)
	SendNUIMessage({ action = "display", type = "steal", title = stealName, stealId = stealId, capacity = capacity, search = Config.InventorySearchable })
	InInventory = true
	TriggerEvent("vorp_stables:setClosedInv", true)
end

NUIService.NUIMoveTosteal = function(obj)
	TriggerServerEvent("syn_search:MoveTosteal", json.encode(obj))
end

NUIService.NUITakeFromsteal = function(obj)
	TriggerServerEvent("syn_search:TakeFromsteal", json.encode(obj))
end

NUIService.OpenCartInventory = function(cartName, wagonId, capacity)
	SetNuiFocus(true, true)
	SendNUIMessage({ action = "display", type = "cart", title = cartName, wagonid = wagonId, capacity = capacity, search = Config.InventorySearchable })
	InInventory = true

	TriggerEvent("vorp_stables:setClosedInv", true)
end

NUIService.NUIMoveToCart = function(obj)
	TriggerServerEvent("vorp_stables:MoveToCart", json.encode(obj))
end

NUIService.NUITakeFromCart = function(obj)
	TriggerServerEvent("vorp_stables:TakeFromCart", json.encode(obj))
end


NUIService.OpenHouseInventory = function(houseName, houseId, capacity)
	SetNuiFocus(true, true)
	SendNUIMessage({ action = "display", type = "house", title = houseName, houseId = houseId, capacity = capacity, search = Config.InventorySearchable })
	InInventory = true
end

NUIService.NUIMoveToHouse = function(obj)
	TriggerServerEvent("vorp_housing:MoveToHouse", json.encode(obj))
end

NUIService.NUITakeFromHouse = function(obj)
	TriggerServerEvent("vorp_housing:TakeFromHouse", json.encode(obj))
end

NUIService.OpenBankInventory = function(bankName, bankId, capacity)
	SetNuiFocus(true, true)
	SendNUIMessage({ action = "display", type = "bank", title = bankName, bankId = bankId, capacity = capacity, search = Config.InventorySearchable })
	InInventory = true
end

NUIService.NUIMoveToBank = function (obj)
	TriggerServerEvent("vorp_bank:MoveToBank", json.encode(obj))
end

NUIService.NUITakeFromBank = function (obj)
	TriggerServerEvent("vorp_bank:TakeFromBank", json.encode(obj))
end

NUIService.OpenHideoutInventory = function(hideoutName, hideoutId, capacity)
	SetNuiFocus(true, true)
	SendNUIMessage({ action = "display", type = "hideout", title = hideoutName, hideoutId = hideoutId, capacity = capacity, search = Config.InventorySearchable })
	InInventory = true
end

NUIService.NUIMoveToHideout = function(obj)
	TriggerServerEvent("syn_underground:MoveToHideout", json.encode(obj))
end

NUIService.NUITakeFromHideout = function(obj)
	TriggerServerEvent("syn_underground:TakeFromHideout", json.encode(obj))
end

NUIService.setProcessingPayFalse = function()
	isProcessingPay = false
end

NUIService.NUIUnequipWeapon = function(obj)
	local data = obj

	if UserWeapons[tonumber(data.id)] then
		UserWeapons[tonumber(data.id)]:UnequipWeapon()
	end

	NUIService.LoadInv()
end

NUIService.NUIGetNearPlayers = function(obj)
	local nearestPlayers = Utils.getNearestPlayers()

	local playerIds = {}
	for _, player in pairs(nearestPlayers) do
		playerIds[#playerIds+1] = GetPlayerServerId(player)
	end
	TriggerServerEvent('vorp_inventory:getNearbyCharacters', obj, playerIds)
end

NUIService.NUISetNearPlayers = function(obj, nearestPlayers)
	local nuiReturn = {}
	local isAnyPlayerFound = #nearestPlayers > 0

	if next(nearestPlayers) == nil then
		print("No Near Players")
		return
	end
	
	print('[^NUISetNearPlayers^7] ^2Info^7: players found = ' .. json.encode(nearestPlayers));

	local item = {}

	for k, v in pairs(obj) do
		item[k] = v
	end

	if item.id == nil then
		item.id = 0
	end

	if item.count == nil then
		item.count = 1
	end

	if item.hash == nil then
		item.hash = 1
	end

	nuiReturn.action = "nearPlayers"
	nuiReturn.foundAny = isAnyPlayerFound
	nuiReturn.players = nearestPlayers
	nuiReturn.item = item.item
	nuiReturn.hash = item.hash
	nuiReturn.count = item.count
	nuiReturn.id = item.id
	nuiReturn.type = item.type
	nuiReturn.what = item.what


	SendNUIMessage(nuiReturn)
end

NUIService.NUIGiveItem = function(obj)
	local nearestPlayers = Utils.getNearestPlayers()

	local data = Utils.expandoProcessing(obj)
	local data2 = Utils.expandoProcessing(data.data)

	for _, player in pairs(nearestPlayers) do
		if player ~= PlayerId() then
			if GetPlayerServerId(player) == tonumber(data.player) then
				local itemName = data2.item
				local itemId = data2.id
				local metadata = data2.metadata
				local target = tonumber(data.player)
				print(data2.type)

				if data2.type == "item_money" then
					if isProcessingPay then return end
					isProcessingPay = true
					TriggerServerEvent("vorpinventory:giveMoneyToPlayer", target, tonumber(data2.count))
					TriggerServerEvent("vorpinventory:moneylog", target, tonumber(data2.count))
				elseif Config.UseGoldItem and data2.type == "item_gold" then
					if isProcessingPay then return end
					isProcessingPay = true
					TriggerServerEvent("vorpinventory:giveGoldToPlayer", target, tonumber(data2.count))
				elseif data2.type == "item_ammo" then 
					if isProcessingPay then return end
					isProcessingPay = true
					local amount = tonumber(data2.count)
					local ammotype = data2.item 
					local maxcount = Config.maxammo[ammotype]
					if amount > 0 and maxcount >= amount then 
						TriggerServerEvent("vorpinventory:servergiveammo", ammotype, amount, target,maxcount)
					end
				elseif data2.type == "item_standard" then
					local amount = tonumber(data2.count)
					local item =  UserInventory[itemId]
					
					if amount > 0 and item ~= nil and item:getCount() >= amount then
						TriggerServerEvent("vorpinventory:serverGiveItem", itemId, amount, target)
					else
						-- TODO error message: Invalid amount of item
					end
				else
					TriggerServerEvent("vorpinventory:serverGiveWeapon", tonumber(itemId), target)
					TriggerServerEvent("vorpinventory:weaponlog", target, data2)
				end

				print('[^NUIGiveItem^7] ^2Info^7: Reloading inv after sending info of giving item ?');
				NUIService.LoadInv()
			end
		end
	end
end

NUIService.NUIDropItem = function (obj)
	if candrop then 
		local aux = Utils.expandoProcessing(obj)
		local itemName = aux.item
		local itemId = aux.id
		local metadata = aux.metadata
		local type = aux.type
		local qty = tonumber(aux.number)

		if type == "item_money" then
			TriggerServerEvent("vorpinventory:serverDropMoney", qty)
		end

		if Config.UseGoldItem then
			if type == "item_gold" then
				TriggerServerEvent("vorpinventory:serverDropGold", qty)
			end
		end

		if type == "item_standard" then
			if aux.number ~= nil and aux.number ~= '' then
				local item =  UserInventory[itemId]

				if  qty > 0 and item ~= nil and item:getCount() >= qty then
					TriggerServerEvent("vorpinventory:serverDropItem", itemName, itemId, qty, metadata)
					item:quitCount(qty)
					if item:getCount() == 0 then
						UserInventory[itemId] = nil
					end
				end
			end
		end

		if type == "item_weapon" then
			TriggerServerEvent("vorpinventory:serverDropWeapon", aux.id)

			if UserWeapons[aux.id] then
				local weapon = UserWeapons[aux.id]

				if weapon:getUsed() then
					weapon:setUsed(false)
					RemoveWeaponFromPed(PlayerPedId(), GetHashKey(weapon:getName()), true, 0)
				end

				UserWeapons[aux.id] = nil
			end
		end

		NUIService.LoadInv()
	else
		TriggerEvent('vorp:TipRight', "cant drop here", 5000)
	end
end


local function getGuidFromItemId(inventoryId, itemData, category, slotId)
	local outItem = DataView.ArrayBuffer(8 * 13)

	if not itemData then
		itemData = 0
	end

	local success = Citizen.InvokeNative("0x886DFD3E185C8A89", inventoryId, itemData, category, slotId, outItem:Buffer()) --InventoryGetGuidFromItemid
	if success then
		return outItem:Buffer() --Seems to not return anythign diff. May need to pull from native above
	else
		return nil
	end
end

local function addWardrobeInventoryItem(itemName, slotHash)
	local itemHash = GetHashKey(itemName)
	local addReason = GetHashKey("ADD_REASON_DEFAULT")
	local inventoryId = 1

	-- _ITEMDATABASE_IS_KEY_VALID
	local isValid = Citizen.InvokeNative("0x6D5D51B188333FD1", itemHash, 0) --ItemdatabaseIsKeyValid
	if not isValid then
		return false
	end

	local characterItem = getGuidFromItemId(inventoryId, nil, GetHashKey("CHARACTER"), 0xA1212100)
	if not characterItem then
		return false
	end

	local wardrobeItem = getGuidFromItemId(inventoryId, characterItem, GetHashKey("WARDROBE"), 0x3DABBFA7)
	if not wardrobeItem then
		return false
	end

	local itemData = DataView.ArrayBuffer(8 * 13)

	-- _INVENTORY_ADD_ITEM_WITH_GUID
	local isAdded = Citizen.InvokeNative("0xCB5D11F9508A928D", inventoryId, itemData:Buffer(), wardrobeItem, itemHash,
		slotHash, 1, addReason)
	if not isAdded then
		return false
	end

	-- _INVENTORY_EQUIP_ITEM_WITH_GUID
	local equipped = Citizen.InvokeNative("0x734311E2852760D0", inventoryId, itemData:Buffer(), true)
	return equipped;
end

NUIService.NUIUseItem = function(data)
	--print("Timer before trigger - " .. timerUse)
	if data["type"] == "item_standard" then
		if timerUse <= 0 then
			TriggerServerEvent("vorp_inventory:useItem", data["item"], data["id"])
			timerUse = 4000
		else
			TriggerEvent('vorp:TipRight', _U("slow"), 5000)
		end
	elseif data["type"] == "item_weapon" then

		local _, weaponHash = GetCurrentPedWeapon(PlayerPedId(), false, 0, false)
		local weaponId = tonumber(data["id"])
		local isWeaponARevolver = Citizen.InvokeNative(0xC212F1D05A8232BB, GetHashKey(UserWeapons[weaponId]:getName()))
		local isWeaponAPistol = Citizen.InvokeNative(0xDDC64F5E31EEDAB6, GetHashKey(UserWeapons[weaponId]:getName()))
		local isArmed = Citizen.InvokeNative(0xCB690F680A3EA971, PlayerPedId(), 4)
		local notdual = false

		if (isWeaponARevolver or isWeaponAPistol) and isArmed then

			local isWeaponUsedARevolver = Citizen.InvokeNative(0xC212F1D05A8232BB, weaponHash)
			local isWeaponUsedAPistol = Citizen.InvokeNative(0xDDC64F5E31EEDAB6, weaponHash)

			if isWeaponUsedAPistol or isWeaponUsedARevolver then
				addWardrobeInventoryItem("CLOTHING_ITEM_M_OFFHAND_000_TINT_004", 0xF20B6B4A)
				addWardrobeInventoryItem("UPGRADE_OFFHAND_HOLSTER", 0x39E57B01)
				UserWeapons[weaponId]:setUsed2(true)
				UserWeapons[weaponId]:equipwep()
				UserWeapons[weaponId]:loadComponents()
				UserWeapons[weaponId]:setUsed(true)
				TriggerServerEvent("syn_weapons:weaponused", data)
			else
				notdual = true
			end
		elseif not UserWeapons[weaponId]:getUsed() and not Citizen.InvokeNative(0x8DECB02F88F428BC, PlayerPedId(), GetHashKey(UserWeapons[weaponId]:getName()), 0, true) then
			notdual = true
		end

		if notdual then
			UserWeapons[weaponId]:equipwep()
			UserWeapons[weaponId]:loadComponents()
			UserWeapons[weaponId]:setUsed(true)
			TriggerServerEvent("syn_weapons:weaponused", data)
		end
		NUIService.LoadInv()
	end
end

NUIService.NUISound = function(obj)
	PlaySoundFrontend("BACK", "RDRO_Character_Creator_Sounds", true, 0)
end

NUIService.NUIFocusOff = function(obj)
	NUIService.CloseInv()
end

NUIService.OnKey = function()
	if IsControlJustReleased(1, Config.openKey) and IsInputDisabled(0) then
		if InInventory then
			NUIService.CloseInv()
			Wait(1000)
		else
			NUIService.OpenInv()
			Wait(1000)
		end
	end
end

NUIService.LoadInv = function()
	local payload = {}
	local items = {}

	TriggerServerEvent("vorpinventory:check_slots")

	if not storemenu then 
		for _, item in pairs(UserInventory) do
			table.insert(items, item)
		end
	elseif storemenu then 
		for _, item in pairs(UserInventory) do
			if item.metadata ~= nil and item.metadata.description ~= nil and item.metadata.orgdescription ~= nil then 
				item.metadata.description = item.metadata.orgdescription 
				item.metadata.orgdescription = nil 
			end
		end
		if geninfo.buyitems ~= nil and next(geninfo.buyitems) ~= nil then 
			local buyitems = geninfo.buyitems
			for _, item in pairs(UserInventory) do
				for k, v in ipairs(buyitems) do 
					if item.name == v.name then 
						if item.metadata.description ~= nil then 
							item.metadata.orgdescription = item.metadata.description
							item.metadata.description = item.metadata.description.."<br><span style=color:Green;>".._U("cansell")..v.price.."</span>"
						else
							item.metadata.orgdescription = ""
							item.metadata.description = "<span style=color:Green;>".._U("cansell")..v.price.."</span>"
						end
					end
				end
				table.insert(items, item)
			end
		else
			for _, item in pairs(UserInventory) do
				table.insert(items, item)
			end
		end
	end
	for _, currentWeapon in pairs(UserWeapons) do
		local weapon = {}
		weapon.count = currentWeapon:getTotalAmmoCount()
		weapon.limit = -1
		weapon.label = currentWeapon:getLabel()
		weapon.name = currentWeapon:getName()
		weapon.metadata = {}
		weapon.hash = GetHashKey(currentWeapon:getName())
		weapon.type = "item_weapon"
		weapon.canUse = true
		weapon.canRemove = true
		weapon.id = currentWeapon:getId()
		weapon.used = currentWeapon:getUsed()
		weapon.desc = currentWeapon:getDesc()

		table.insert(items, weapon)
	end

	payload.action = "setItems"
	payload.itemList = items

	SendNUIMessage(payload)
end

NUIService.OpenInv = function()
	SetNuiFocus(true, true)
	SendNUIMessage({ action = "display", type = "main", search = Config.InventorySearchable, autofocus = Config.InventorySearchAutoFocus})
	InInventory = true

	NUIService.LoadInv()
end



NUIService.TransactionStarted = function()
	SetNuiFocus(true, false)
	SendNUIMessage({ action = "transaction", type = "started", text = _U("TransactionLoading") })
end

NUIService.TransactionComplete = function(keepInventoryOpen)
	keepInventoryOpen = keepInventoryOpen == nil and true or keepInventoryOpen

	SetNuiFocus(keepInventoryOpen, keepInventoryOpen)
	SendNUIMessage({ action = "transaction", type = "completed" })
end

NUIService.initiateData = function()
	-- Add Locales
	SendNUIMessage({ action = "initiate", language = {
		empty = _U("emptyammo"),
		prompttitle = _U("prompttitle"),
		prompttitle2 = _U("prompttitle2"),
		promptaccept = _U("promptaccept"),
		inventoryclose = _U("inventoryclose"),
		inventorysearch = _U("inventorysearch"),
		toplayerpromptitle = _U("toplayerpromptitle"),
		toplaterpromptaccept = _U("toplaterpromptaccept"),
		gunbeltlabel = _U("gunbeltlabel"),
		gunbeltdescription = _U("gunbeltdescription"),
		inventorymoneylabel = _U("inventorymoneylabel"),
		inventorymoneydescription = _U("inventorymoneydescription"),
		givemoney = _U("givemoney"),
		dropmoney = _U("dropmoney"),
		inventorygoldlabel =  _U("inventorygoldlabel"),
		inventorygolddescription =  _U("inventorygolddescription"),
		givegold = _U("givegold"),
		dropgold = _U("dropgold"),
		unequip = _U("unequip"),
		use = _U("use"),
		give = _U("give"),
		drop = _U("drop")
	}})
end

-- Main loop
Citizen.CreateThread(function()
	Wait(5000)
	NUIService.initiateData()

	while true do
		if IsControlJustReleased(0, Config.OpenKey) and IsInputDisabled(0) then
			if InInventory then
				NUIService.CloseInv()
			else
				NUIService.OpenInv()
			end
		end

		if Config.DisableDeathInventory then
			if InInventory and IsPedDeadOrDying(PlayerPedId()) then
				NUIService.CloseInv()
			end
		end
		Wait(1)
	end
end)

-- Prevent Spam
Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if timerUse > 0 then
			timerUse = timerUse - 1000
		end
	end
end)
