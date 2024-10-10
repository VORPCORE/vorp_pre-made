local isProcessingPay     = false
local timerUse            = 0
local candrop             = true
local cangive             = true
local CanOpen             = true
local InventoryIsDisabled = false
local T                   = TranslationInv.Langs[Lang]
local Core                = exports.vorp_core:GetCore()
StoreSynMenu              = false
GenSynInfo                = {}
InInventory               = false
NUIService                = {}
SynPending                = false

RegisterNetEvent('inv:dropstatus', function(x)
	candrop = x
end)

RegisterNetEvent('inv:givestatus')
AddEventHandler('inv:givestatus', function(x)
	cangive = x
end)

function ApplyPosfx()
	if Config.UseFilter then
		AnimpostfxPlay("OJDominoBlur")
		AnimpostfxSetStrength("OJDominoBlur", 0.5)
	end
end

function NUIService.ReloadInventory(inventory)
	local payload = json.decode(inventory)
	if payload.itemList == '[]' then
		payload.itemList = {}
	end

	for _, item in pairs(payload.itemList) do
		if item.type == "item_weapon" then
			item.label = item.custom_label or Utils.GetWeaponDefaultLabel(item.name)

			if item.desc and item.custom_desc then
				item.desc = item.custom_desc
			end

			if not item.desc then
				item.desc = Utils.GetWeaponDefaultDesc(item.name)
			end
		end
	end

	SendNUIMessage(payload)
	Wait(500)
	NUIService.LoadInv()
	SynPending = false
end

function NUIService.OpenCustomInventory(name, id, capacity, weight)
	CanOpen = Core.Callback.TriggerAwait("vorp_inventory:Server:CanOpenCustom", id)
	if not CanOpen then return end

	ApplyPosfx()
	DisplayRadar(false)
	CanOpen = false
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = "display",
		type = "custom",
		title = tostring(name),
		id = tostring(id),
		capacity = capacity,
		weight = weight,
	})
	InInventory = true
end

function NUIService.NUIMoveToCustom(obj)
	TriggerServerEvent("vorp_inventory:MoveToCustom", json.encode(obj))
end

function NUIService.NUITakeFromCustom(obj)
	TriggerServerEvent("vorp_inventory:TakeFromCustom", json.encode(obj))
end

function NUIService.OpenPlayerInventory(name, id)
	CanOpen = Core.Callback.TriggerAwait("vorp_inventory:Server:CanOpenCustom", id)
	if not CanOpen then return end

	CanOpen = false
	ApplyPosfx()
	DisplayRadar(false)
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = "display",
		type = "player",
		title = name,
		id = id,
	})
	InInventory = true
end

function NUIService.NUIMoveToPlayer(obj)
	TriggerServerEvent("vorp_inventory:MoveToPlayer", json.encode(obj))
end

function NUIService.NUITakeFromPlayer(obj)
	TriggerServerEvent("vorp_inventory:TakeFromPlayer", json.encode(obj))
end

function NUIService.CloseInv()
	if Config.UseFilter then
		AnimpostfxStop("OJDominoBlur")
	end
	if StoreSynMenu then
		StoreSynMenu = false
		GenSynInfo = {}
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

	if not CanOpen then
		TriggerServerEvent("vorp_inventory:Server:UnlockCustomInv")
	end
	DisplayRadar(true)
	SetNuiFocus(false, false)
	SendNUIMessage({ action = "hide" })
	InInventory = false
	TriggerEvent("vorp_stables:setClosedInv", false)
	TriggerEvent("syn:closeinv")
end

function NUIService.setProcessingPayFalse()
	isProcessingPay = false
end

function NUIService.NUIUnequipWeapon(obj)
	local data = obj

	if UserWeapons[tonumber(data.id)] then
		UserWeapons[tonumber(data.id)]:UnequipWeapon()
	end

	NUIService.LoadInv()
end

function NUIService.NUIGetNearPlayers(obj)
	local nearestPlayers = Utils.getNearestPlayers()

	local playerIds = {}
	for _, player in ipairs(nearestPlayers) do
		playerIds[#playerIds + 1] = GetPlayerServerId(player)
	end
	TriggerServerEvent('vorp_inventory:getNearbyCharacters', obj, playerIds)
end

function NUIService.NUISetNearPlayers(obj, nearestPlayers)
	local nuiReturn = {}
	local isAnyPlayerFound = next(nearestPlayers) ~= nil
	local itemId = obj.id or 0
	local itemCount = obj.count or 1
	local itemHash = obj.hash or 1

	if not isAnyPlayerFound then
		Core.NotifyRightTip(T.noplayersnearby, 5000)
		return
	end

	nuiReturn.action = "nearPlayers"
	nuiReturn.foundAny = isAnyPlayerFound
	nuiReturn.players = nearestPlayers
	nuiReturn.item = nuiReturn.item or obj.item
	nuiReturn.hash = itemHash
	nuiReturn.count = itemCount
	nuiReturn.id = itemId
	nuiReturn.type = obj.type
	nuiReturn.what = nuiReturn.what or obj.what

	SendNUIMessage(nuiReturn)
end

function NUIService.NUIGiveItem(obj)
	if not cangive then
		return Core.NotifyRightTip(T.cantgivehere, 5000)
	end

	local nearestPlayers = Utils.getNearestPlayers()
	local data = Utils.expandoProcessing(obj)
	local data2 = Utils.expandoProcessing(data.data)
	local isvalid = Validator.IsValidNuiCallback(data.hsn)

	if isvalid then
		for _, player in ipairs(nearestPlayers) do
			if player ~= PlayerId() then
				if GetPlayerServerId(player) == tonumber(data.player) then
					local itemId = data2.id
					local target = tonumber(data.player)

					if data2.type == "item_money" then
						if isProcessingPay then return end
						isProcessingPay = true
						TriggerServerEvent("vorpinventory:giveMoneyToPlayer", target, tonumber(data2.count))
					elseif Config.UseGoldItem and data2.type == "item_gold" then
						if isProcessingPay then return end
						isProcessingPay = true
						TriggerServerEvent("vorpinventory:giveGoldToPlayer", target, tonumber(data2.count))
					elseif data2.type == "item_ammo" then
						if isProcessingPay then return end
						isProcessingPay = true
						local amount = tonumber(data2.count)
						local ammotype = data2.item
						local maxcount = SharedData.MaxAmmo[ammotype]
						if amount > 0 and maxcount >= amount then
							TriggerServerEvent("vorpinventory:servergiveammo", ammotype, amount, target, maxcount)
						end
					elseif data2.type == "item_standard" then
						local amount = tonumber(data2.count)
						local item = UserInventory[itemId]

						if amount > 0 and item ~= nil and item:getCount() >= amount then
							local itemName = item:getName()

							TriggerServerEvent("vorpinventory:serverGiveItem", itemId, amount, target)
						end
					else
						TriggerServerEvent("vorpinventory:serverGiveWeapon", tonumber(itemId), target)
					end

					NUIService.LoadInv()
				end
			end
		end
	end
end

function NUIService.NUIDropItem(obj)
	if not candrop then return Core.NotifyRightTip(T.cantdrophere, 5000) end

	local aux = Utils.expandoProcessing(obj)
	local isvalid = Validator.IsValidNuiCallback(aux.hsn)

	if isvalid then
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
				local item = UserInventory[itemId]
				if not item then
					return
				end

				if qty <= 0 or qty > item:getCount() then
					return
				end

				TriggerServerEvent("vorpinventory:serverDropItem", itemName, itemId, qty, metadata)

				item:quitCount(qty)
				if item:getCount() == 0 then
					UserInventory[itemId] = nil
				end
			end
		end

		if type == "item_weapon" then
			TriggerServerEvent("vorpinventory:serverDropWeapon", aux.id)

			if UserWeapons[aux.id] then
				local weapon = UserWeapons[aux.id]

				if weapon:getUsed() then
					weapon:setUsed(false)
					weapon:UnequipWeapon()
				end

				UserWeapons[aux.id] = nil
			end
		end
		SetTimeout(100, function()
			NUIService.LoadInv()
		end)
	end
end

local function getGuidFromItemId(inventoryId, itemData, category, slotId)
	local outItem = DataView.ArrayBuffer(8 * 13)

	if not itemData then
		itemData = 0
	end
	--InventoryGetGuidFromItemid
	local success = Citizen.InvokeNative(0x886DFD3E185C8A89, inventoryId, itemData, category, slotId, outItem:Buffer())
	if success then
		return outItem:Buffer() --Seems to not return anythign diff. May need to pull from native above
	else
		return nil
	end
end

local function addWardrobeInventoryItem(itemName, slotHash)
	local itemHash    = joaat(itemName)
	local addReason   = joaat("ADD_REASON_DEFAULT")
	local inventoryId = 1

	-- _ITEMDATABASE_IS_KEY_VALID
	local isValid     = Citizen.InvokeNative(0x6D5D51B188333FD1, itemHash, 0) --ItemdatabaseIsKeyValid
	if not isValid then
		return false
	end

	local characterItem = getGuidFromItemId(inventoryId, nil, joaat("CHARACTER"), 0xA1212100)
	if not characterItem then
		return false
	end

	local wardrobeItem = getGuidFromItemId(inventoryId, characterItem, joaat("WARDROBE"), 0x3DABBFA7)
	if not wardrobeItem then
		return false
	end

	local itemData = DataView.ArrayBuffer(8 * 13)

	-- _INVENTORY_ADD_ITEM_WITH_GUID
	local isAdded = Citizen.InvokeNative(0xCB5D11F9508A928D, inventoryId, itemData:Buffer(), wardrobeItem, itemHash, slotHash, 1, addReason)
	if not isAdded then
		return false
	end

	-- _INVENTORY_EQUIP_ITEM_WITH_GUID
	local equipped = Citizen.InvokeNative(0x734311E2852760D0, inventoryId, itemData:Buffer(), true)
	return equipped;
end

local function useWeapon(data)
	data.type = data.type or "item_weapon"
	local ped = PlayerPedId()
	local _, weaponHash = GetCurrentPedWeapon(ped, false, 0, false)
	local weaponId = tonumber(data.id)
	if weaponId and not UserWeapons[weaponId] then
		return print("Weapon not found")
	end
	local weapName = joaat(UserWeapons[weaponId]:getName())
	local isWeaponAGun = Citizen.InvokeNative(0x705BE297EEBDB95D, weapName)
	local isWeaponOneHanded = Citizen.InvokeNative(0xD955FEE4B87AFA07, weapName)
	local isArmed = Citizen.InvokeNative(0xCB690F680A3EA971, ped, 4)
	local notdual = false

	if (isWeaponAGun and isWeaponOneHanded) and isArmed then
		addWardrobeInventoryItem("CLOTHING_ITEM_M_OFFHAND_000_TINT_004", 0xF20B6B4A)
		addWardrobeInventoryItem("UPGRADE_OFFHAND_HOLSTER", 0x39E57B01)
		UserWeapons[weaponId]:setUsed2(true)
		if weaponHash == weapName then
			UserWeapons[weaponId]:equipwep(true)
		else
			UserWeapons[weaponId]:equipwep()
		end
		UserWeapons[weaponId]:loadComponents()
		UserWeapons[weaponId]:setUsed(true)
		TriggerServerEvent("syn_weapons:weaponused", data)
	elseif not UserWeapons[weaponId]:getUsed() and not Citizen.InvokeNative(0x8DECB02F88F428BC, ped, weapName, 0, true) or Citizen.InvokeNative(0x30E7C16B12DA8211, weapName) then
		notdual = true
	end

	if notdual then
		UserWeapons[weaponId]:equipwep()
		UserWeapons[weaponId]:loadComponents()
		UserWeapons[weaponId]:setUsed(true)
		TriggerServerEvent("syn_weapons:weaponused", data)
	end
	if UserWeapons[weaponId]:getUsed() then
		local serial = UserWeapons[weaponId]:getSerialNumber()
		local info = { weaponId = weaponId, serialNumber = serial }
		local key = string.format("GetEquippedWeaponData_%d", weapName)
		LocalPlayer.state:set(key, info, false)
	end
	NUIService.LoadInv()
end

exports("useWeapon", useWeapon)

local function useItem(data)
	if timerUse <= 0 then
		TriggerServerEvent("vorp_inventory:useItem", data)
		timerUse = 2000
	else
		Core.NotifyRightTip(T.slow, 5000)
	end
end

function NUIService.NUIUseItem(data)
	if data.type == "item_standard" then
		useItem(data)
	elseif data.type == "item_weapon" then
		useWeapon(data)
	end
end

exports("useItem", useItem) -- not tested yet


function NUIService.NUISound()
	PlaySoundFrontend("BACK", "RDRO_Character_Creator_Sounds", true, 0)
end

function NUIService.NUIFocusOff()
	if Config.UseFilter then
		AnimpostfxStop("OJDominoBlur")
	end
	DisplayRadar(true)
	PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
	NUIService.CloseInv()
end

local function loadItems()
	local items = {}
	if not StoreSynMenu then
		for _, item in pairs(UserInventory) do
			--item.degradation = math.random(100, 1000) / 10 -- just for tests not implemented yet
			table.insert(items, item)
		end
	elseif StoreSynMenu then
		for _, item in pairs(UserInventory) do
			if item.metadata ~= nil and item.metadata.description ~= nil and item.metadata.orgdescription ~= nil then
				item.metadata.description = item.metadata.orgdescription
				item.metadata.orgdescription = nil
			end
		end

		if GenSynInfo.buyitems and next(GenSynInfo.buyitems) then
			local buyitems = GenSynInfo.buyitems
			for _, item in pairs(UserInventory) do
				for k, v in ipairs(buyitems) do
					if item.name == v.name then
						if item.metadata.description ~= nil then
							item.metadata.orgdescription = item.metadata.description
							item.metadata.description = item.metadata.description .. "<br><span style=color:Green;>" .. T.cansell .. v.price .. "</span>"
						else
							item.metadata.orgdescription = ""
							item.metadata.description = "<span style=color:Green;>" .. T.cansell .. v.price .. "</span>"
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
	return items
end

local function loadWeapons()
	local weapons = {}
	for _, currentWeapon in pairs(UserWeapons) do
		local weapon = {}
		weapon.count = currentWeapon:getTotalAmmoCount()
		weapon.limit = -1
		weapon.label = currentWeapon:getCustomLabel() or currentWeapon:getLabel()
		weapon.name = currentWeapon:getName()
		weapon.metadata = {}
		weapon.hash = GetHashKey(currentWeapon:getName())
		weapon.type = "item_weapon"
		weapon.canUse = true
		weapon.canRemove = true
		weapon.id = currentWeapon:getId()
		weapon.used = currentWeapon:getUsed()
		weapon.used2 = currentWeapon:getUsed2()
		weapon.desc = currentWeapon:getDesc()
		weapon.group = 5
		weapon.serial_number = currentWeapon:getSerialNumber()
		weapon.custom_label = currentWeapon:getCustomLabel()
		weapon.custom_desc = currentWeapon:getCustomDesc()
		weapon.weight = currentWeapon:getWeight()
		table.insert(weapons, weapon)
	end
	return weapons
end


local function loadItemsAndWeapons()
	local itemsToSend = {}
	local items = loadItems()
	local weapons = loadWeapons()

	-- merged items with weapons
	if Config.InventoryOrder == "items" then
		for _, item in pairs(items) do
			table.insert(itemsToSend, item)
		end
		for _, weapon in pairs(weapons) do
			table.insert(itemsToSend, weapon)
		end
	else
		for _, weapon in pairs(weapons) do
			table.insert(itemsToSend, weapon)
		end
		for _, item in pairs(items) do
			table.insert(itemsToSend, item)
		end
	end

	return itemsToSend
end

function NUIService.LoadInv()
	local payload = {}

	Core.Callback.TriggerAsync("vorpinventory:get_slots", function(result)
		SendNUIMessage({ action = "changecheck", check = string.format("%.1f", result.totalInvWeight), info = string.format("%.1f", result.slots) })
		SendNUIMessage({
			action = "updateStatusHud",
			show   = not IsRadarHidden(),
			money  = result.money,
			gold   = result.gold,
			rol    = result.rol,
			id     = GetPlayerServerId(PlayerId()),
		})
	end)

	local itemsAndWeapons = loadItemsAndWeapons()
	payload.action = "setItems"
	payload.itemList = itemsAndWeapons

	SendNUIMessage(payload)
end

function NUIService.OpenInv()
	ApplyPosfx()
	DisplayRadar(false)
	PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = "display",
		type = "main",
		search = Config.InventorySearchable,
		autofocus = Config.InventorySearchAutoFocus
	})
	InInventory = true -- internal
	NUIService.LoadInv()
end

function NUIService.TransactionStarted()
	SetNuiFocus(true, false)
	SendNUIMessage({ action = "transaction", type = "started", text = T.TransactionLoading })
end

function NUIService.TransactionComplete(keepInventoryOpen)
	keepInventoryOpen = keepInventoryOpen == nil and true or keepInventoryOpen
	SetNuiFocus(keepInventoryOpen, keepInventoryOpen)
	SendNUIMessage({ action = "transaction", type = "completed" })
end

function NUIService.initiateData()
	-- Add Locales
	SendNUIMessage({
		action = "initiate",
		language = {
			empty = T.emptyammo,
			prompttitle = T.prompttitle,
			prompttitle2 = T.prompttitle2,
			promptaccept = T.promptaccept,
			inventoryclose = T.inventoryclose,
			inventorysearch = T.inventorysearch,
			toplayerpromptitle = T.toplayerpromptitle,
			toplaterpromptaccept = T.toplaterpromptaccept,
			gunbeltlabel = T.gunbeltlabel,
			gunbeltdescription = T.gunbeltdescription,
			inventorymoneylabel = T.inventorymoneylabel,
			inventorymoneydescription = T.inventorymoneydescription,
			givemoney = T.givemoney,
			dropmoney = T.dropmoney,
			inventorygoldlabel = T.inventorygoldlabel,
			inventorygolddescription = T.inventorygolddescription,
			givegold = T.givegold,
			dropgold = T.dropgold,
			unequip = T.unequip,
			equip = T.equip,
			use = T.use,
			give = T.give,
			drop = T.drop,
			labels = T.labels
		},
		config = {
			UseGoldItem = Config.UseGoldItem,
			AddGoldItem = Config.AddGoldItem,
			AddDollarItem = Config.AddDollarItem,
			AddAmmoItem = Config.AddAmmoItem,
			DoubleClickToUse = Config.DoubleClickToUse,
			UseRolItem = Config.UseRolItem,
			WeightMeasure = Config.WeightMeasure or "Kg",
		}
	})
end

-- Main loop
CreateThread(function()
	local controlVar = false                     -- best to use variable than to check statebag every frame
	LocalPlayer.state:set("IsInvOpen", false, true) -- init
	repeat Wait(2000) until LocalPlayer.state.IsInSession
	NUIService.initiateData()

	while true do
		local sleep = 1000
		if not InInventory then
			sleep = 0
			if IsControlJustReleased(1, Config.OpenKey) then
				local player = PlayerPedId()
				local hogtied = IsPedHogtied(player) == 1
				local cuffed = IsPedCuffed(player)
				if not hogtied and not cuffed and not InventoryIsDisabled then
					NUIService.OpenInv()
				end
			end
		end

		if Config.DisableDeathInventory then
			if InInventory and IsPedDeadOrDying(PlayerPedId(), false) then
				NUIService.CloseInv()
			end
		end

		if InInventory then
			if not controlVar then
				controlVar = true
				LocalPlayer.state:set("IsInvActive", true, true) -- can also listen for statebag change
				TriggerEvent("vorp_inventory:Client:OnInvStateChange", true)
			end
		else
			if controlVar then
				controlVar = false
				LocalPlayer.state:set("IsInvActive", false, true)
				TriggerEvent("vorp_inventory:Client:OnInvStateChange", false)
			end
		end

		Wait(sleep)
	end
end)

-- Prevent Spam
CreateThread(function()
	repeat Wait(2000) until LocalPlayer.state.IsInSession
	while true do
		Wait(1000)
		if timerUse > 0 then
			timerUse = timerUse - 1000
		end
	end
end)

function NUIService.ChangeClothing(item)
	if item then
		ExecuteCommand(tostring(item))
	end
end

function NUIService.DisableInventory(param)
	InventoryIsDisabled = param
end

function NUIService.getActionsConfig(obj, cb)
	cb(Actions)
end

function NUIService.CacheImages(info)
	local unpack = msgpack.unpack(info)
	SendNUIMessage({ action = "cacheImages", info = unpack })
end
