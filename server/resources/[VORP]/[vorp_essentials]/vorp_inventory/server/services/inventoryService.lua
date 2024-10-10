local T          = TranslationInv.Langs[Lang]
local Core       = exports.vorp_core:GetCore()
local timer      = Config.CoolDownNewPlayer or 120
local newchar    = {}
InventoryService = {}
ItemPickUps      = {}
MoneyPickUps     = {}
GoldPickUps      = {}
math.randomseed(GetGameTimer())
ItemUids = {}


function InventoryService.CheckNewPlayer(_source, charid)
	if Config.NewPlayers then
		if SharedUtils.IsValueInArray(charid, newchar) then
			Core.NotifyRightTip(_source, "in cool down", 5000)
			SvUtils.Trem(_source)
			return false
		end
	end
	return true
end

local function getSourceInfo(_source)
	local user = Core.getUser(_source)
	if not user then
		return
	end
	local sourceCharacter = user.getUsedCharacter
	local charname = sourceCharacter.firstname .. ' ' .. sourceCharacter.lastname
	local sourceIdentifier = sourceCharacter.charIdentifier
	local steamname = GetPlayerName(_source)
	return charname, sourceIdentifier, steamname
end


function InventoryService.UseItem(data)
	local _source = source
	local sourceCharacter = Core.getUser(_source)
	local itemId = data.id
	local itemName = data.item

	if not sourceCharacter then
		return
	end

	local identifier = sourceCharacter.getUsedCharacter.identifier
	local userInventory = UsersInventories.default[identifier]


	if not SvUtils.DoesItemExist(itemName, "UseItem") then
		return
	end

	if not UsableItemsFunctions[itemName] then
		return
	end

	local item = userInventory[itemId]
	if not item then
		return
	end

	local svItem = ServerItems[itemName]
	local itemArgs = json.decode(json.encode(svItem))
	itemArgs.metadata = item:getMetadata()
	itemArgs.mainid = itemId
	local arguments = { source = _source, item = itemArgs }

	TriggerEvent("vorp_inventory:Server:OnItemUse", arguments)

	local success, result = pcall(UsableItemsFunctions[itemName], arguments)

	if not success then
		return print("Function call failed with error:", result, "a usable item :", itemName, " have an error in the callback function")
	end
end

function InventoryService.DropMoney(amount)
	local _source = source
	if not SvUtils.InProcessing(_source) then
		SvUtils.ProcessUser(_source)
		local userCharacter = Core.getUser(_source).getUsedCharacter
		local userMoney = userCharacter.money
		local charid = userCharacter.charIdentifier -- new line

		if not InventoryService.CheckNewPlayer(_source, charid) then
			return
		end -- new line

		if amount <= 0 then
			Core.NotifyRightTip(_source, T.TryExploits, 3000)
		elseif userMoney < amount then
			Core.NotifyRightTip(_source, T.NotEnoughMoney, 3000)
		else
			if not Config.DeleteOnlyDontDrop then
				TriggerClientEvent("vorpInventory:createMoneyPickup", _source, amount)
			else
				userCharacter.removeCurrency(0, amount)
			end
			local charname, _, steamname = getSourceInfo(_source)
			local title = T.dropmoney
			local description = "**" .. T.WebHookLang.money .. ":** `" .. amount .. "` `$` \n**" .. T.WebHookLang.charname .. ":** `" .. charname .. "`\n**" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "`\n"

			if amount < amount then
				return
			end

			local info = { source = _source, name = Logs.WebHook.webhookname, title = title, description = description, webhook = Logs.WebHook.webhook, color = Logs.WebHook.colorDropMoney, }
			SvUtils.SendDiscordWebhook(info)
		end
		SvUtils.Trem(_source)
	end
end

function InventoryService.giveMoneyToPlayer(target, amount)
	local _source = source
	if not SvUtils.InProcessing(_source) then
		SvUtils.ProcessUser(_source)
		local _target = target

		if Core.getUser(_source) == nil or Core.getUser(_target) == nil then
			SvUtils.Trem(_source)
			TriggerClientEvent("vorp_inventory:ProcessingReady", _source)
			return
		end
		local sourceCharacter = Core.getUser(_source).getUsedCharacter
		local targetCharacter = Core.getUser(_target).getUsedCharacter
		local sourceMoney = sourceCharacter.money
		local charid = sourceCharacter.charIdentifier -- new line

		if not InventoryService.CheckNewPlayer(_source, charid) then
			TriggerClientEvent("vorp_inventory:ProcessingReady", _source)
			return
		end

		if amount <= 0 then
			Core.NotifyRightTip(_source, T.TryExploits, 3000)
			Wait(3000)
			TriggerClientEvent("vorp_inventory:ProcessingReady", _source)
		elseif sourceMoney < amount then
			Core.NotifyRightTip(_source, T.NotEnoughMoney, 3000)
			Wait(3000)
			TriggerClientEvent("vorp_inventory:ProcessingReady", _source)
		else
			sourceCharacter.removeCurrency(0, amount)
			targetCharacter.addCurrency(0, amount)
			Core.NotifyRightTip(_source, T.YouPaid .. amount .. " ID: " .. _target, 3000)
			Core.NotifyRightTip(_target, T.YouReceived .. amount .. " ID: " .. _source, 3000)
			Wait(3000)
			TriggerClientEvent("vorp_inventory:ProcessingReady", _source)

			local charname, identifier, steamname = getSourceInfo(_source)
			local charname2, identifier2, steamname2 = getSourceInfo(_target)
			local title = T.givemoney
			local description = "**" .. T.WebHookLang.amount .. "**: `" .. amount .. "`\n **" .. T.WebHookLang.charname .. ":** `" .. charname .. "` \n**" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "` \n**" .. T.to .. "** `" .. charname2 .. "`\n**" .. T.WebHookLang.Steamname .. "** `" .. steamname2 .. "` \n"
			local info = { source = _source, name = Logs.WebHook.webhookname, title = title, description = description, webhook = Logs.WebHook.webhook, color = Logs.WebHook.colorgiveMoney, }
			SvUtils.SendDiscordWebhook(info)
		end

		SvUtils.Trem(_source)
	end
end

function InventoryService.DropGold(amount)
	local _source = source
	if SvUtils.InProcessing(_source) then
		return
	end

	SvUtils.ProcessUser(_source)
	local userCharacter = Core.getUser(_source).getUsedCharacter
	local userGold = userCharacter.gold

	if amount <= 0 then
		Core.NotifyRightTip(_source, T.TryExploits, 3000)
	elseif userGold < amount then
		Core.NotifyRightTip(_source, T.NotEnoughGold, 3000)
	else
		if not Config.DeleteOnlyDontDrop then
			TriggerClientEvent("vorpInventory:createGoldPickup", _source, amount)
		else
			userCharacter.removeCurrency(1, amount)
		end
		local charname, scourceidentifier, steamname = getSourceInfo(_source)
		local title = T.dropgold
		local description = "**" .. T.WebHookLang.gold .. ":** `" .. amount .. "` \n**" .. T.WebHookLang.charname .. ":** `" .. charname .. "`\n**" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "`\n"
		local info = { source = _source, name = Logs.WebHook.webhookname, title = title, description = description, webhook = Logs.WebHook.webhook, color = Logs.WebHook.colorDropGold, }
		SvUtils.SendDiscordWebhook(info)
	end
	SvUtils.Trem(_source)
end

function InventoryService.giveGoldToPlayer(target, amount)
	local _source = source
	if SvUtils.InProcessing(_source) then
		return
	end

	if Core.getUser(_source) == nil or Core.getUser(target) == nil then
		return
	end

	SvUtils.ProcessUser(_source)
	local _target = target
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local targetCharacter = Core.getUser(_target).getUsedCharacter
	local sourceGold = sourceCharacter.gold

	if amount <= 0 then
		Core.NotifyRightTip(_source, T.TryExploits, 3000)
		TriggerClientEvent("vorp_inventory:ProcessingReady", _source)
		Wait(3000)
	elseif sourceGold < amount then
		Core.NotifyRightTip(_source, T.NotEnoughGold, 3000)
		TriggerClientEvent("vorp_inventory:ProcessingReady", _source)
		Wait(3000)
	else
		sourceCharacter.removeCurrency(1, amount)
		targetCharacter.addCurrency(1, amount)

		Core.NotifyRightTip(_source, T.YouPaid .. amount .. "ID: " .. _target, 3000)
		Core.NotifyRightTip(_target, T.YouReceived .. amount .. "ID: " .. _source, 3000)
		TriggerClientEvent("vorp_inventory:ProcessingReady", _source)

		local charname, scourceidentifier, steamname = getSourceInfo(_source)
		local charname2, scourceidentifier2, steamname2 = getSourceInfo(_source)
		local title = T.givegold
		local description = "**" .. T.WebHookLang.amount .. "**: `" .. amount .. "`\n **" .. T.WebHookLang.charname .. ":** `" .. charname .. "` \n**" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "` \n**" .. T.to .. "** `" .. charname2 .. "`\n**" .. T.WebHookLang.Steamname .. " `" .. steamname2 .. "` \n**"

		local info = { source = _source, name = Logs.WebHook.webhookname, title = title, description = description, webhook = Logs.WebHook.webhook, color = Logs.WebHook.colorgiveGold, }
		SvUtils.SendDiscordWebhook(info)

		Wait(3000)
	end
	SvUtils.Trem(_source)
end

function InventoryService.setWeaponBullets(weaponId, type, amount)
	local userWeapons = UsersWeapons.default

	if userWeapons[weaponId] ~= nil then
		userWeapons[weaponId]:setAmmo(type, amount)
	end
end

function InventoryService.usedWeapon(id, _used, _used2)
	local used = 0
	local used2 = 0

	if _used then used = 1 end

	if _used2 then used2 = 1 end
	local query = 'UPDATE loadout SET used = @used, used2 = @used2 WHERE id = @id'
	local params = {
		used = used,
		used2 = used2,
		id = id
	}
	DBService.updateAsync(query, params, function(r) end)
end

function InventoryService.subItem(target, invId, itemId, amount)
	local _source = target
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local userInventory = nil

	if CustomInventoryInfos[invId].shared then
		userInventory = UsersInventories[invId]
	else
		userInventory = UsersInventories[invId][identifier]
	end

	if userInventory ~= nil then
		if userInventory[itemId] ~= nil then
			local item = userInventory[itemId]
			if item ~= nil then
				if amount <= item:getCount() then
					item:quitCount(amount)
				end

				if item:getCount() == 0 then
					if invId == "default" then
						local data = { name = item:getName(), id = item:getId(), metadata = item:getMetadata() }
						TriggerEvent("vorp_inventory:Server:OnItemRemoved", data, _source)
					end
					userInventory[itemId] = nil
					DBService.DeleteItem(item:getOwner(), itemId)
				else
					DBService.SetItemAmount(item:getOwner(), itemId, item:getCount())
				end

				return true
			end
		end
	end

	return false
end

function InventoryService.addItem(target, invId, name, amount, metadata, cb)
	local _source = target
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charIdentifier = sourceCharacter.charIdentifier
	local svItem = ServerItems[name]

	if not SvUtils.DoesItemExist(name, "addItem") then
		return cb(nil)
	end

	metadata = SharedUtils.MergeTables(svItem.metadata, metadata or {})
	local userInventory = nil

	if CustomInventoryInfos[invId].shared then
		userInventory = UsersInventories[invId]
	else
		userInventory = UsersInventories[invId][identifier]
	end

	if not userInventory then
		return cb(nil)
	end

	local item = SvUtils.FindItemByNameAndMetadata(invId, identifier, name, metadata)
	if item then
		if amount > 0 then
			item:addCount(amount, CustomInventoryInfos[invId].ignoreItemStackLimit)
			DBService.SetItemAmount(item:getOwner(), item:getId(), item:getCount())
			return cb(item)
		end
		return cb(nil)
	else
		-- listen on item given
		DBService.CreateItem(charIdentifier, svItem:getId(), amount, metadata, name, function(craftedItem)
			item = Item:New({
				id = craftedItem.id,
				count = amount,
				limit = svItem:getLimit(),
				label = svItem:getLabel(),
				metadata = SharedUtils.MergeTables(svItem.metadata, metadata),
				name = name,
				type = "item_standard",
				canUse = svItem:getCanUse(),
				canRemove = svItem:getCanRemove(),
				owner = charIdentifier,
				desc = svItem:getDesc(),
				group = svItem:getGroup(),
				weight = svItem:getWeight() or 0.25,
			})
			userInventory[craftedItem.id] = item
			if invId == "default" then
				TriggerEvent("vorp_inventory:Server:OnItemCreated", item, _source)
			end
			return cb(item)
		end, invId)
	end
end

function InventoryService.addWeapon(target, weaponId)
	local _source = target
	local userWeapons = UsersWeapons.default
	local weaponcomps = {}
	local query = 'SELECT comps FROM loadout WHERE id = @id'
	local result = DBService.queryAwait(query, { id = weaponId })

	if result[1] then
		weaponcomps = json.decode(result[1].comps)
	end

	local weaponname = userWeapons[weaponId]:getName()
	local ammo = { ["nothing"] = 0 }
	local components = { ["nothing"] = 0 }
	InventoryAPI.registerWeapon(_source, weaponname, ammo, components, weaponcomps, function()
	end, weaponId)
	InventoryAPI.deleteWeapon(_source, weaponId, function()
	end)
end

function InventoryService.subWeapon(target, weaponId)
	local _source = target
	local User = Core.getUser(_source)

	if not User then
		return false
	end

	local sourceCharacter = User.getUsedCharacter
	local charId = sourceCharacter.charIdentifier
	local userWeapons = UsersWeapons.default

	if weaponId and userWeapons[weaponId] then
		userWeapons[weaponId]:setPropietary('')
		local query = 'UPDATE loadout SET identifier = "", dropped = 1, charidentifier = @charId WHERE id = @id'
		local params = {
			charId = charId,
			id = weaponId,
		}
		DBService.updateAsync(query, params, function(r) end)
		return true
	end
	return false
end

function InventoryService.onPickup(data)
	local _source = source
	local pickups = data.data[data.key]
	local uid = pickups.uid
	local user = Core.getUser(_source)
	if not ItemUids[uid] or not user or SvUtils.InProcessing(_source) then
		return
	end

	local pickup = ItemPickUps[uid]
	if not pickup then return end

	SvUtils.ProcessUser(_source)

	local character = user.getUsedCharacter
	local identifier = character.identifier
	local charId = character.charIdentifier
	local invCapacity = character.invCapacity
	local job = character.job
	local userInventory = UsersInventories.default[identifier]


	if not userInventory then
		SvUtils.Trem(_source, false)
		return
	end

	-- is item
	if ItemPickUps[uid].weaponid == 1 then
		local canCarryWeight = InventoryAPI.canCarryAmountItem(_source, pickup.amount)
		local canCarryLimit = InventoryAPI.canCarryItem(_source, pickup.name, pickup.amount)

		if not canCarryWeight or not canCarryLimit then
			Core.NotifyRightTip(_source, T.fullInventory, 2000)
			SvUtils.Trem(_source, false)
			return
		end

		InventoryService.addItem(_source, "default", pickup.name, pickup.amount, pickup.metadata, function(item)
			if item ~= nil then
				local dataItem = { name = pickup.name, obj = ItemPickUps[uid].obj, amount = pickup.amount, metadata = pickup.metadata, position = ItemPickUps[uid].coords, id = ItemPickUps[uid].id }
				ItemPickUps[uid] = nil
				ItemUids[uid] = nil
				local charname, scourceidentifier, steamname = getSourceInfo(_source)
				local title = T.itempickup
				local description = "**" .. T.WebHookLang.amount .. "** `" .. pickup.amount .. "`\n **" .. T.WebHookLang.item .. "** `" .. pickup.name .. "` \n**" .. T.WebHookLang.charname .. ":** `" .. charname .. "`\n**" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "`"
				local info = { source = _source, name = Logs.WebHook.webhookname, title = title, description = description, webhook = Logs.WebHook.webhook, color = Logs.WebHook.coloritempickup, }
				TriggerClientEvent("vorpInventory:sharePickupClient", -1, dataItem, 2)
				TriggerClientEvent("vorpInventory:removePickupClient", -1, dataItem.obj)
				TriggerClientEvent("vorpInventory:receiveItem", _source, pickup.name, item:getId(), pickup.amount, pickup.metadata)
				TriggerClientEvent("vorpInventory:playerAnim", _source, uid)
				SvUtils.SendDiscordWebhook(info)
			end
		end)
	else
		-- weapons
		local notListed = false
		local totalInvWeight = 0
		local sourceInventoryWeaponCount = 0
		local DefaultAmount = Config.MaxItemsInInventory.Weapons
		local weaponId = ItemPickUps[uid].weaponid
		local userWeapons = UsersWeapons.default
		local weapon = userWeapons[weaponId]
		if weapon then
			local serialNumber = weapon:getSerialNumber()
			local weaponCustomDesc = weapon:getCustomDesc()

			if Config.JobsAllowed[job] then
				DefaultAmount = Config.JobsAllowed[job]
			end

			if DefaultAmount ~= 0 then
				if weapon:getName() then
					if SharedUtils.IsValueInArray(string.upper(weapon:getName()), Config.notweapons) then
						notListed = true
					end
				end

				if not notListed then
					local itemsToTalWeight = InventoryAPI.getUserTotalCountItems(identifier, charId)
					local sourceInventoryWeaponWeight = InventoryAPI.getUserTotalCountWeapons(identifier, charId, true)
					totalInvWeight = (itemsToTalWeight + weapon:getWeight() + sourceInventoryWeaponWeight)
					sourceInventoryWeaponCount = InventoryAPI.getUserTotalCountWeapons(identifier, charId) + 1
				end

				if totalInvWeight <= invCapacity or sourceInventoryWeaponCount <= DefaultAmount then
					local weaponObj = ItemPickUps[uid].obj

					weapon:setDropped(0)
					local dataweapon = { name = weapon:getName(), obj = weaponObj, amount = pickup.amount, metadata = {}, weaponId = weaponId, position = ItemPickUps[uid].coords, custom_label = weapon:getCustomLabel(), serial_number = serialNumber, custom_desc = weaponCustomDesc, id = nil }
					ItemPickUps[uid] = nil
					if weaponCustomDesc == nil then
						weaponCustomDesc = "Custom Description not set"
					end
					if serialNumber == nil then
						serialNumber = "Serial Number not set"
					end
					local charname, scourceidentifier, steamname = getSourceInfo(_source)
					local title = T.weppickup
					local description = "**" .. T.WebHookLang.Weapontype .. ":** `" .. weapon:getName() .. "`\n**" .. T.WebHookLang.charname .. ":** `" .. charname .. "`\n**" .. T.WebHookLang.serialnumber .. "** `" .. serialNumber .. "`\n **" .. T.WebHookLang.Desc .. "** `" .. weaponCustomDesc .. "` \n **" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "`"
					local info = { source = _source, name = Logs.WebHook.webhookname, title = title, description = description, webhook = Logs.WebHook.webhook, color = Logs.WebHook.colorweppickupd }
					TriggerClientEvent("vorpInventory:sharePickupClient", -1, dataweapon, 2)
					TriggerClientEvent("vorpInventory:removePickupClient", -1, weaponObj)
					TriggerClientEvent("vorpInventory:playerAnim", _source, uid)
					InventoryService.addWeapon(_source, weaponId)
					SvUtils.SendDiscordWebhook(info)
				end
			else
				Core.NotifyRightTip(_source, T.fullInventoryWeapon, 2000)
			end
		end
	end

	SvUtils.Trem(_source, false)
end

function InventoryService.onPickupMoney(obj)
	local _source = source
	local charname, scourceidentifier, steamname = getSourceInfo(_source)

	if not SvUtils.InProcessing(_source) then
		if MoneyPickUps[obj] ~= nil then
			SvUtils.ProcessUser(_source)
			local moneyObj = MoneyPickUps[obj].obj
			local moneyAmount = MoneyPickUps[obj].amount
			local moneyCoords = MoneyPickUps[obj].coords
			local title = T.WebHookLang.moneypickup
			local description = "**" .. T.WebHookLang.money .. ":** `" .. moneyAmount .. "` `$` \n**" .. T.WebHookLang.charname .. ":** `" .. charname .. "`\n**" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "`\n"
			local info = { source = _source, name = Logs.WebHook.webhookname, title = title, description = description, webhook = Logs.WebHook.webhook, color = Logs.WebHook.colorDropGold }
			SvUtils.SendDiscordWebhook(info)
			TriggerClientEvent("vorpInventory:shareMoneyPickupClient", -1, moneyObj, moneyAmount, moneyCoords, 2)
			TriggerClientEvent("vorpInventory:removePickupClient", -1, moneyObj)
			TriggerClientEvent("vorpInventory:playerAnim", _source, moneyObj)
			TriggerEvent("vorp:addMoney", _source, 0, moneyAmount)
			MoneyPickUps[obj] = nil

			SvUtils.Trem(_source, false)
		end
	end
end

function InventoryService.onPickupGold(obj)
	local _source = source
	if not SvUtils.InProcessing(_source) then
		if GoldPickUps[obj] ~= nil then
			SvUtils.ProcessUser(_source)
			local goldObj = GoldPickUps[obj].obj
			local goldAmount = GoldPickUps[obj].amount
			local goldCoords = GoldPickUps[obj].coords
			TriggerClientEvent("vorpInventory:shareGoldPickupClient", -1, goldObj, goldAmount, goldCoords, 2)
			TriggerClientEvent("vorpInventory:removePickupClient", -1, goldObj)
			TriggerClientEvent("vorpInventory:playerAnim", _source, goldObj)
			TriggerEvent("vorp:addMoney", _source, 1, goldAmount)
			GoldPickUps[obj] = nil
			SvUtils.Trem(_source, false)
		end
	end
end

local function shareData(data)
	local uid = SvUtils.GenerateUniqueID()
	ItemUids[uid] = uid

	ItemPickUps[uid] = {
		name = data.name,
		obj = data.obj,
		amount = data.amount,
		metadata = data.metadata,
		weaponid = data.weaponId,
		inRange = false,
		coords = data.position,
		id = data.id,
	}
	data.uid = uid
	TriggerClientEvent("vorpInventory:sharePickupClient", -1, data, 1)
end


function InventoryService.sharePickupServerWeapon(data)
	local _source = source
	local weapon = UsersWeapons.default[data.weaponId]

	if not weapon and data.weaponId > 1 then
		return
	end

	local result = InventoryService.subWeapon(_source, data.weaponId)
	if not result then
		return
	end

	local wepname = weapon:getName()
	local serialNumber = weapon:getSerialNumber()
	local desc = weapon:getCustomDesc()
	local charname, scourceidentifier, steamname = getSourceInfo(_source)
	local title = T.WebHookLang.dropedwep
	if not desc or desc == "" then
		desc = "Custom Description not set"
	end
	if not serialNumber or serialNumber == "" then
		serialNumber = "Serial Number not set"
	end
	local description = "**" .. T.WebHookLang.Weapontype .. ":** `" .. wepname .. "`\n**" .. T.WebHookLang.charname .. ":** `" .. charname .. "`\n**" .. T.WebHookLang.serialnumber .. "** ` " .. serialNumber .. " ` \n **" .. T.WebHookLang.Desc .. "** `" .. desc .. "` \n **" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "`"
	local info = {
		source = _source,
		name = Logs.WebHook.webhookname,
		title = title,
		description = description,
		webhook = Logs.WebHook.webhook,
		color = Logs.WebHook.colordropedwep,
	}
	SvUtils.SendDiscordWebhook(info)
	UsersWeapons.default[data.weaponId]:setDropped(1)
	shareData(data)
end

function InventoryService.sharePickupServerItem(data)
	local _source = source
	local Character = Core.getUser(_source).getUsedCharacter
	local sourceInventory = UsersInventories.default[Character.identifier]
	local item = sourceInventory[data.id]
	if not item and data.weaponId == 1 then
		return
	end
	local result = InventoryService.subItem(_source, "default", data.id, data.amount)
	if not result then
		return
	end
	local charname, _, steamname = getSourceInfo(_source)
	local title = T.WebHookLang.itemDrop
	local description = "**" .. T.WebHookLang.amount .. "** `" .. data.amount .. "`\n **" .. T.WebHookLang.itemDrop .. "**: `" .. data.name .. "`" .. "\n**" .. T.WebHookLang.charname .. ":** `" .. charname .. "`\n**" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "`"
	local info = {
		source = _source,
		name = Logs.WebHook.webhookname,
		title = title,
		description = description,
		webhook = Logs.WebHook.webhook,
		color = Logs.WebHook.coloritemDrop,
	}

	SvUtils.SendDiscordWebhook(info)
	shareData(data)
end

function InventoryService.shareMoneyPickupServer(obj, amount, position)
	local _source = source
	local Character = Core.getUser(_source).getUsedCharacter
	local money = Character.money

	if money < amount then
		return
	end

	Character.removeCurrency(0, amount)
	TriggerClientEvent("vorpInventory:shareMoneyPickupClient", -1, obj, amount, position, 1)
	MoneyPickUps[obj] = {
		name = T.inventorymoneylabel,
		obj = obj,
		amount = amount,
		inRange = false,
		coords = position
	}
end

function InventoryService.shareGoldPickupServer(obj, amount, position)
	local _source = source
	local Character = Core.getUser(_source).getUsedCharacter
	local gold = Character.gold

	if gold < amount then
		return
	end

	local charname, scourceidentifier, steamname = getSourceInfo(_source)
	local title = T.WebHookLang.pickedgold
	local description = "**" .. T.WebHookLang.gold .. ":** `" .. amount .. "` \n**" .. T.WebHookLang.charname .. ":** `" .. charname .. "`\n**" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "`\n"
	local info = { source = _source, name = Logs.WebHook.webhookname, title = title, description = description, webhook = Logs.WebHook.webhook, color = Logs.WebHook.colorpickedgold }

	Character.removeCurrency(1, amount)
	TriggerClientEvent("vorpInventory:shareGoldPickupClient", -1, obj, amount, position, 1)
	SvUtils.SendDiscordWebhook(info)
	GoldPickUps[obj] = { name = T.inventorygoldlabel, obj = obj, amount = amount, inRange = false, coords = position }
end

function InventoryService.DropWeapon(weaponId)
	local _source = source
	if not SvUtils.InProcessing(_source) then
		SvUtils.ProcessUser(_source)
		local userWeapons = UsersWeapons.default
		local weapon = userWeapons[weaponId]
		local wepName = weapon:getName()
		if not Config.DeleteOnlyDontDrop then
			TriggerClientEvent("vorpInventory:createPickup", _source, wepName, 1, {}, weaponId)
		else
			InventoryService.subWeapon(_source, weaponId)
		end
		SvUtils.Trem(_source)
	end
end

function InventoryService.DropItem(itemName, itemId, amount, metadata)
	local _source = source
	if not SvUtils.InProcessing(_source) then
		SvUtils.ProcessUser(_source)

		if not Config.DeleteOnlyDontDrop then
			TriggerClientEvent("vorpInventory:createPickup", _source, itemName, amount, metadata, 1, itemId)
		else
			InventoryService.subItem(_source, "default", itemId, amount)
		end
		SvUtils.Trem(_source)
	end
end

function InventoryService.GiveWeapon(weaponId, target)
	local _source = source
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local charid = sourceCharacter.charIdentifier

	if not InventoryService.CheckNewPlayer(_source, charid) then
		TriggerClientEvent("vorp_inventory:transactionCompleted", _source)
		return
	end

	if not SvUtils.InProcessing(_source) then
		TriggerClientEvent("vorp_inventory:transactionStarted", _source)
		SvUtils.ProcessUser(_source)

		if UsersWeapons.default[weaponId] ~= nil then
			InventoryService.giveWeapon2(target, weaponId, _source)
		end
		TriggerClientEvent("vorp_inventory:transactionCompleted", _source)
		SvUtils.Trem(_source)
	end
end

function InventoryService.giveWeapon2(player, weaponId, target)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local sourceIdentifier = sourceCharacter.identifier
	local sourceCharId = sourceCharacter.charIdentifier
	local invCapacity = sourceCharacter.invCapacity
	local job = sourceCharacter.job
	local _target = target
	local userWeapons = UsersWeapons.default
	local DefaultAmount = Config.MaxItemsInInventory.Weapons
	local weaponName = userWeapons[weaponId]:getName()
	local serialNumber = userWeapons[weaponId]:getSerialNumber()
	local desc = userWeapons[weaponId]:getCustomDesc()
	local newWeight = userWeapons[weaponId]:getWeight()
	local charname, _, steamname = getSourceInfo(_source)
	local charname2, _, steamname2 = getSourceInfo(_target)
	local notListed = false

	if not desc then
		desc = userWeapons[weaponId]:getDesc()
	end

	if Config.JobsAllowed[job] then
		DefaultAmount = Config.JobsAllowed[job]
	end

	if DefaultAmount ~= 0 then
		if weaponName then
			if SharedUtils.IsValueInArray(string.upper(weaponName), Config.notweapons) then
				notListed = true
			end
		end

		if not notListed then
			local sourceTotalWeaponCount = InventoryAPI.getUserTotalCountWeapons(sourceIdentifier, sourceCharId) + 1
			if sourceTotalWeaponCount > DefaultAmount then
				Core.NotifyRightTip(_source, T.cantweapons, 2000)
				return
			end
		end
	end

	local function canCarryWeapons()
		local itemsTotalWeight = InventoryAPI.getUserTotalCountItems(sourceIdentifier, sourceCharId)
		local sourceTotalWeaponsWeight = InventoryAPI.getUserTotalCountWeapons(sourceIdentifier, sourceCharId, true)
		local totalInvWeight = itemsTotalWeight + sourceTotalWeaponsWeight + newWeight
		if totalInvWeight > invCapacity then
			return false
		end
		return true
	end

	if not canCarryWeapons() then
		return Core.NotifyRightTip(_source, "player can carry more weapons", 2000)
	end


	local weaponcomps = {}
	local query = 'SELECT comps FROM loadout WHERE id = @id'
	local params = { id = weaponId }
	local result = DBService.singleAwait(query, params)
	if result then
		weaponcomps = json.decode(result.comps)
	end

	userWeapons[weaponId]:setPropietary('')
	local ammo = { ["nothing"] = 0 }
	local components = { ["nothing"] = 0 }
	InventoryAPI.registerWeapon(_source, weaponName, ammo, components, weaponcomps, nil, weaponId)
	InventoryAPI.deleteWeapon(_source, weaponId)
	TriggerClientEvent("vorpinventory:updateinventory", _target)
	TriggerClientEvent("vorpinventory:updateinventory", _source)
	TriggerClientEvent("vorpCoreClient:subWeapon", _target, weaponId)


	if not serialNumber or serialNumber == "" then
		serialNumber = "Serial Number not set"
	end
	local title = T.WebHookLang.gavewep
	local description = "**" .. T.WebHookLang.charname .. ":** `" .. charname2 .. "`\n**" .. T.WebHookLang.Steamname .. "** `" .. steamname2 .. "` \n**" .. T.WebHookLang.give .. "**  **" .. 1 .. "** \n**" .. T.WebHookLang.Weapontype .. ":** `" .. weaponName .. "` \n**" .. T.WebHookLang.Desc .. "** `" .. (desc or "") .. "`\n **" .. T.WebHookLang.serialnumber .. "** `" .. serialNumber .. "`\n **" .. T.to .. ":** ` " .. charname .. "` \n**" .. T.WebHookLang.Steamname .. "** ` " .. steamname .. "` "
	local info = { source = _source, name = Logs.WebHook.webhookname, title = title, description = description, webhook = Logs.WebHook.webhook, color = Logs.WebHook.colorgiveWep }
	SvUtils.SendDiscordWebhook(info)
	-- notify
	Core.NotifyRightTip(_target, T.youGaveWeapon, 2000)
	Core.NotifyRightTip(_source, T.youReceivedWeapon, 2000)
end

function InventoryService.GiveItem(itemId, amount, target)
	local _source = source
	local _target = target
	local user = Core.getUser(_source)
	local user1 = Core.getUser(_target)

	if not user or not user1 then
		return
	end

	local character = user.getUsedCharacter
	local targetCharacter = user1.getUsedCharacter
	local charid = character.charIdentifier
	local targetCharId = targetCharacter.charIdentifier
	local sourceInventory = UsersInventories.default[character.identifier]
	local targetInventory = UsersInventories.default[targetCharacter.identifier]

	if not InventoryService.CheckNewPlayer(_source, charid) or not sourceInventory or not targetInventory or not sourceInventory[itemId] then
		return
	end

	if SvUtils.InProcessing(_source) then
		return
	end

	TriggerClientEvent("vorp_inventory:transactionStarted", _source)
	SvUtils.ProcessUser(_source)

	local item = sourceInventory[itemId]
	local itemName = item:getName()
	local svItem = ServerItems[itemName]
	if not svItem then
		return
	end

	local charname, _, steamname = getSourceInfo(_source)
	local charname2, _, steamname2 = getSourceInfo(_target)
	local title = T.gaveitem
	local description = "**" .. T.WebHookLang.amount .. "**: `" .. amount .. "`\n **" .. T.WebHookLang.item .. "** : `" .. itemName .. "`" .. "\n**" .. T.WebHookLang.charname .. ":** `" .. charname .. "` \n**" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "` \n**" .. T.to .. "** `" .. charname2 .. "`\n**" .. T.WebHookLang.Steamname .. "** `" .. steamname2 .. "` \n"
	local info = { source = _source, name = Logs.WebHook.webhookname, title = title, description = description, webhook = Logs.WebHook.webhook, color = Logs.WebHook.colorgiveitem }


	local function updateClient(addedItem)
		TriggerClientEvent("vorpInventory:receiveItem", _target, itemName, addedItem:getId(), amount, item:getMetadata())
		TriggerClientEvent("vorpInventory:removeItem", _source, itemName, item:getId(), amount)
		local data = { name = itemName, id = item:getId(), metadata = item:getMetadata() }
		TriggerEvent("vorp_inventory:Server:OnItemRemoved", data, _source)
		if item:getCount() - amount <= 0 then
			DBService.DeleteItem(charid, item:getId())
			sourceInventory[item:getId()] = nil
		else
			item:quitCount(amount)
			DBService.SetItemAmount(charid, item:getId(), item:getCount())
		end
		local ItemsLabel = svItem:getLabel()
		Core.NotifyRightTip(_source, T.yougive .. amount .. T.of .. ItemsLabel, 2000)
		Core.NotifyRightTip(_target, T.youreceive .. amount .. T.of .. ItemsLabel, 2000)
	end

	local canCarryItems = InventoryAPI.canCarryAmountItem(_target, amount)
	local canCarryItem = InventoryAPI.canCarryItem(_target, itemName, amount)

	if not canCarryItems or not canCarryItem then
		Core.NotifyRightTip(_source, T.fullInventoryGive, 2000)
		TriggerClientEvent("vorp_inventory:transactionCompleted", _source)
		SvUtils.Trem(_source)
		return
	end

	local targetItem = SvUtils.FindItemByNameAndMetadata("default", targetCharacter.identifier, itemName, item:getMetadata())
	if targetItem ~= nil then
		targetItem:addCount(amount)
		DBService.SetItemAmount(targetCharId, targetItem:getId(), targetItem:getCount())
		updateClient(targetItem)
	else
		DBService.CreateItem(targetCharId, svItem:getId(), amount, item:getMetadata(), itemName, function(craftedItem)
			targetItem = Item:New({
				id = craftedItem.id,
				count = amount,
				limit = svItem:getLimit(),
				label = svItem:getLabel(),
				name = itemName,
				type = "item_inventory",
				metadata = item:getMetadata(),
				canUse = svItem:getCanUse(),
				canRemove = svItem:getCanRemove(),
				owner = targetCharId,
				desc = svItem:getDesc(),
				group = svItem:getGroup(),
				weight = svItem:getWeight()
			})
			targetInventory[craftedItem.id] = targetItem
			updateClient(targetItem)
			TriggerEvent("vorp_inventory:Server:OnItemCreated", targetItem, _target)
		end)
	end

	SvUtils.SendDiscordWebhook(info)
	TriggerClientEvent("vorp_inventory:transactionCompleted", _source)
	SvUtils.Trem(_source)
end

function InventoryService.getItemsTable()
	local _source = source

	if ServerItems then
		local data = msgpack.pack(ServerItems)
		TriggerClientEvent("vorpInventory:giveItemsTable", _source, data)
	end
end

function InventoryService.getInventory()
	local _source = source
	local sourceCharacter = Core.getUser(_source).getUsedCharacter

	if sourceCharacter == nil then
		return
	end
	local sourceIdentifier = sourceCharacter.identifier
	local sourceCharId = sourceCharacter.charIdentifier

	local characterInventory = {}

	if sourceCharId ~= nil then
		DBService.GetInventory(sourceCharId, "default", function(inventory)
			for _, item in pairs(inventory) do
				if ServerItems[item.item] then
					local dbItem = ServerItems[item.item]
					characterInventory[item.id] = Item:New({
						count = tonumber(item.amount),
						id = item.id,
						limit = dbItem.limit,
						label = dbItem.label,
						metadata = SharedUtils.MergeTables(dbItem.metadata, item.metadata),
						name = dbItem.item,
						type = dbItem.type,
						canUse = dbItem.canUse,
						canRemove = dbItem.canRemove,
						createdAt = item.created_at,
						owner = sourceCharId,
						desc = dbItem.desc,
						group = dbItem.group,
						weight = dbItem.weight
					})
				end
			end
			UsersInventories.default[sourceIdentifier] = characterInventory
			TriggerClientEvent("vorpInventory:giveInventory", _source, json.encode(inventory))
		end)


		local userWeapons = {}
		for _, weapon in pairs(UsersWeapons.default) do
			if weapon.propietary == sourceIdentifier and weapon.charId == sourceCharId and weapon.currInv == "default" and weapon.dropped == 0 then
				userWeapons[#userWeapons + 1] = weapon
			end
		end
		TriggerClientEvent("vorpInventory:giveLoadout", _source, userWeapons)

		for id, _ in pairs(CustomInventoryInfos) do
			if UsersInventories[id][sourceIdentifier] then
				UsersInventories[id][sourceIdentifier] = nil
			end
		end
	end
end

Core.Callback.Register("vorpinventory:getammoinfo", function(source, cb)
	if not AmmoData[source] then
		print("AmmoData not found")
		return cb(false)
	end

	return cb(AmmoData[source])
end)

-- give ammo to player
function InventoryService.serverGiveAmmo(ammotype, amount, target, maxcount)
	local _source = source
	local player1ammo = AmmoData[_source].ammo[ammotype]
	local player2ammo = AmmoData[target].ammo[ammotype]

	if player2ammo == nil then
		AmmoData[target].ammo[ammotype] = 0
	end

	if player1ammo == nil or player2ammo == nil then
		TriggerClientEvent("vorp_inventory:ProcessingReady", _source)
		return
	end

	if 0 > (player1ammo - amount) then
		Core.NotifyRightTip(_source, T.notenoughammo, 2000)
		TriggerClientEvent("vorp_inventory:ProcessingReady", _source)
		return
	elseif (player2ammo + amount) > maxcount then
		Core.NotifyRightTip(_source, T.fullammoyou, 2000)
		Core.NotifyRightTip(target, T.fullammo, 2000)
		TriggerClientEvent("vorp_inventory:ProcessingReady", _source)
		return
	end

	AmmoData[_source].ammo[ammotype] = AmmoData[_source].ammo[ammotype] - amount
	AmmoData[target].ammo[ammotype] = AmmoData[target].ammo[ammotype] + amount
	local charidentifier = AmmoData[_source].charidentifier
	local charidentifier2 = AmmoData[target].charidentifier

	local query = "UPDATE characters Set ammo=@ammo WHERE charidentifier=@charidentifier"
	local params = { charidentifier = charidentifier, ammo = json.encode(AmmoData[_source].ammo) }
	local params2 = { charidentifier = charidentifier2, ammo = json.encode(AmmoData[target].ammo) }
	DBService.updateAsync(query, params, function(r) end)
	DBService.updateAsync(query, params2, function(r) end)

	TriggerClientEvent("vorpinventory:updateuiammocount", _source, AmmoData[_source].ammo)
	TriggerClientEvent("vorpinventory:updateuiammocount", target, AmmoData[target].ammo)
	TriggerClientEvent("vorpinventory:setammotoped", _source, AmmoData[_source].ammo)
	TriggerClientEvent("vorpinventory:setammotoped", target, AmmoData[target].ammo)
	-- notify
	Core.NotifyRightTip(_source, T.transferedammo .. SharedData.AmmoLabels[ammotype] .. " : " .. amount, 2000)
	Core.NotifyRightTip(target, T.recammo .. SharedData.AmmoLabels[ammotype] .. " : " .. amount, 2000)
	TriggerClientEvent("vorp_inventory:ProcessingReady", _source)
	-- update players client side
	TriggerClientEvent("vorpinventory:recammo", _source, AmmoData[_source])
	TriggerClientEvent("vorpinventory:recammo", target, AmmoData[target])
end

function InventoryService.updateAmmo(ammoinfo)
	local _source = source
	local query = "UPDATE characters Set ammo=@ammo WHERE charidentifier=@charidentifier"
	local params = { charidentifier = ammoinfo.charidentifier, ammo = json.encode(ammoinfo.ammo) }
	DBService.updateAsync(query, params, function(result)
		if result and _source then
			AmmoData[_source] = ammoinfo
		end
	end)
end

function InventoryService.LoadAllAmmo()
	local _source = source
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local charidentifier = sourceCharacter.charIdentifier
	local query = "SELECT ammo FROM characters WHERE charidentifier=@charidentifier"
	local params = { charidentifier = charidentifier }
	DBService.queryAsync(query, params, function(result)
		if result[1] then
			local ammo = json.decode(result[1].ammo)
			AmmoData[_source] = { charidentifier = charidentifier, ammo = ammo }
			if next(ammo) then
				for k, v in pairs(ammo) do
					local ammocount = tonumber(v)
					if ammocount and ammocount > 0 then
						TriggerClientEvent("vorpCoreClient:addBullets", _source, k, ammocount)
					end
				end
				-- update players client side
				TriggerClientEvent("vorpinventory:recammo", _source, AmmoData[_source])
			end
		end
	end)
end

function InventoryService.onNewCharacter(source)
	Wait(5000)
	local player = Core.getUser(source)

	for key, value in pairs(Config.startItems) do
		InventoryAPI.addItem(source, tostring(key), value, {})
	end

	for _, value in ipairs(Config.startWeapons) do
		InventoryAPI.registerWeapon(source, value, {}, {}, {})
	end

	if Config.NewPlayers then
		CreateThread(function()
			local Character = player.getUsedCharacter
			local charid = Character.charIdentifier
			table.insert(newchar, charid)
			Wait(timer * 60000) -- waiting time is in minutes so 120 minutes = 2 hours until player can give or drop
			for k, v in pairs(newchar) do
				if v == charid then
					table.remove(newchar, k)
				end
			end
		end)
	end
end

function InventoryService.reloadInventory(player, id, type, source)
	local invData = CustomInventoryInfos[id]
	local sourceCharacter = Core.getUser(player).getUsedCharacter
	local sourceIdentifier = sourceCharacter.identifier
	local sourceCharIdentifier = sourceCharacter.charIdentifier
	type = type or "custom"
	local userInventory = {}
	local itemList = {}
	if type == "custom" then
		if invData:isShared() then
			userInventory = UsersInventories[id]
		else
			userInventory = UsersInventories[id][sourceIdentifier]
		end

		for weaponId, weapon in pairs(UsersWeapons[id]) do
			if invData:isShared() or weapon.charId == sourceCharIdentifier then
				itemList[#itemList + 1] = Item:New({
					id            = weaponId,
					count         = 1,
					name          = weapon.name,
					label         = weapon.custom_label or weapon.name,
					limit         = 1,
					type          = "item_weapon",
					desc          = weapon.desc,
					group         = 5,
					serial_number = weapon.serial_number,
					custom_label  = weapon.custom_label,
					custom_desc   = weapon.custom_desc,
				})
			end
		end
	elseif type == "player" then
		userInventory = UsersInventories.default[sourceIdentifier]
		for weaponId, weapon in pairs(UsersWeapons.default) do
			if weapon.charId == sourceCharIdentifier and weapon:getPropietary() == sourceIdentifier then
				itemList[#itemList + 1] = Item:New({
					id            = weaponId,
					count         = 1,
					name          = weapon.name,
					label         = weapon.custom_label or weapon.name,
					limit         = 1,
					type          = "item_weapon",
					desc          = weapon.desc,
					group         = 5,
					serial_number = weapon.serial_number,
					custom_label  = weapon.custom_label,
					custom_desc   = weapon.custom_desc,
					weight        = weapon.weight,
				})
			end
		end
	end

	for _, value in pairs(userInventory) do
		itemList[#itemList + 1] = value
	end

	local payload = {
		itemList = itemList,
		action = "setSecondInventoryItems",
		info = {
			target = player,
			source = source,
		},
	}

	TriggerClientEvent("vorp_inventory:ReloadCustomInventory", source or player, json.encode(payload))
end

--amount of custom inventories dont need weight check
function InventoryService.getInventoryTotalCount(identifier, charIdentifier, invId)
	invId = invId ~= nil and invId or "default"
	local userTotalItemCount = 0
	local userInventory = {}
	local userWeapons = UsersWeapons[invId]
	if CustomInventoryInfos[invId]:isShared() then
		userInventory = UsersInventories[invId]
	else
		userInventory = UsersInventories[invId][identifier]
	end

	for _, item in pairs(userInventory) do
		userTotalItemCount = userTotalItemCount + item:getCount()
	end
	for _, weapon in pairs(userWeapons) do
		if CustomInventoryInfos[invId]:isShared() or weapon.charId == charIdentifier then
			userTotalItemCount = userTotalItemCount + 1
		end
	end
	return userTotalItemCount
end

function InventoryService.canStoreWeapon(identifier, charIdentifier, invId, name, amount)
	local invData = CustomInventoryInfos[invId]

	if invData:getLimit() > 0 then
		local sourceInventoryItemCount = InventoryService.getInventoryTotalCount(identifier, charIdentifier, invId)
		sourceInventoryItemCount = sourceInventoryItemCount + amount
		if sourceInventoryItemCount > invData:getLimit() then
			return false
		end
	end

	if invData:isWeaponInList(name) then
		local weapons = SvUtils.FindAllWeaponsByName(invId, name)
		local weaponCount = #weapons + amount
		if weaponCount > invData:getWeaponLimit(name) then
			return false
		end
	elseif invData:iswhitelistWeaponsEnabled() then
		return false
	end
	return true
end

function InventoryService.canStoreItem(identifier, charIdentifier, invId, name, amount)
	local invData = CustomInventoryInfos[invId]


	if invData:getLimit() > 0 then
		local sourceInventoryItemCount = InventoryService.getInventoryTotalCount(identifier, charIdentifier, invId)
		sourceInventoryItemCount = sourceInventoryItemCount + amount
		if sourceInventoryItemCount > invData:getLimit() then
			return false, "Inventory limit reached"
		end
	end

	if invData:isItemInList(name) then
		local items = SvUtils.FindAllItemsByName(invId, identifier, name)

		if #items ~= 0 then
			local itemCount = 0
			for _, item in pairs(items) do
				itemCount = itemCount + item:getCount()
			end
			local totalAmount = amount + itemCount

			if totalAmount > invData:getItemLimit(name) then
				return false, "Item limit reached"
			end
		elseif amount > invData:getItemLimit(name) then
			return false, "Item limit reached"
		end
		return true
	elseif invData:iswhitelistItemsEnabled() then
		return false, "Item not in whitelist"
	end

	if not invData:getIgnoreItemStack() then
		local item = SvUtils.FindItemByNameAndMetadata(invId, identifier, name, nil)
		if item ~= nil then
			local totalCount = item:getCount() + amount

			if totalCount > item:getLimit() then
				return false, "Item limit reached"
			end
		end
	end
	return true, nil
end

function InventoryService.getNearbyCharacters(obj, sources)
	local _source = source

	local characters = {}
	for _, playerId in pairs(sources) do
		if Config.ShowCharacterNameOnGive then
			local character = Core.getUser(playerId).getUsedCharacter
			characters[#characters + 1] = {
				label = character.firstname .. ' ' .. character.lastname,
				player = playerId
			}
		else
			characters[#characters + 1] = {
				label = tostring(playerId),
				player = playerId
			}
		end
	end

	TriggerClientEvent('vorp_inventory:setNearbyCharacters', _source, obj, characters)
end

--* CUSTOM INVENTORY *--


function InventoryService.DoesHavePermission(invId, job, grade, Table)
	if not CustomInventoryInfos[invId]:isPermEnabled() then
		return true
	end

	if not Table or not next(Table) then
		return true
	end

	if Table[job] and Table[job] >= grade then
		return true
	end

	return false
end

function InventoryService.DoesCharIdHavePermission(invId, charid, Table)
	if not CustomInventoryInfos[invId]:isPermEnabled() then
		return true
	end

	if not Table or not next(Table) then
		return true
	end

	if Table[charid] then
		return true
	end

	return false
end

function InventoryService.CheckIsBlackListed(invId, ItemName)
	if not CustomInventoryInfos[invId]:isBlackListEnabled() then
		return true
	end

	local ItemsTable = CustomInventoryInfos[invId]:getBlackList()

	if next(ItemsTable) then
		for item, _ in pairs(ItemsTable) do
			if item == ItemName then
				return false
			end
		end
	end
	return true
end

function InventoryService.DiscordLogs(inventory, itemName, amount, playerName, type)
	local title = Logs.WebHook.custitle
	local color = Logs.WebHook.cuscolor
	local logo = Logs.WebHook.cuslogo
	local footerlogo = Logs.WebHook.cusfooterlogo
	local avatar = Logs.WebHook.cusavatar
	local names = Logs.WebHook.cuswebhookname
	local webhook = CustomInventoryInfos[inventory]:getWebhook()
	if type == "Move" then
		webhook = webhook or Logs.WebHook.CustomInventoryMoveTo
		local description = "**Player:**`" .. playerName .. "`\n **Moved to:** `" .. inventory .. "` \n**Weapon** `" .. itemName .. "`\n **Count:** `" .. amount .. "`"
		Core.AddWebhook(title, webhook, description, color, names, logo, footerlogo, avatar)
	end

	if type == "Take" then
		webhook = webhook or Logs.WebHook.CustomInventoryTakeFrom
		local description = "**Player:**`" .. playerName .. "`\n **Took from:** `" .. inventory .. "`\n **item** `" .. itemName .. "`\n **amount:** `" .. amount .. "`"
		Core.AddWebhook(title, webhook, description, color, names, logo, footerlogo, avatar)
	end
end

local function CanProceed(item, amount, sourceIdentifier, sourceName)
	if item.type == "item_weapon" then
		if not UsersWeapons.default[item.id] then
			print("Player: " .. sourceName .. " is trying to add weapons to a custom inventory that he does not have, possible Cheat!!")
			return false
		end
		local weaponCount = 0
		for _, weapon in pairs(UsersWeapons.default) do
			if weapon.name == item.name then
				weaponCount = weaponCount + 1
			end
		end
		if weaponCount < amount then
			print("Player: " .. sourceName .. " is trying to add ammount of weapons to a custom inventory that he does not have, possible Cheat!!")
			return false
		end
	else
		local inventory = UsersInventories.default[sourceIdentifier]
		if not inventory or not inventory[item.id] then
			print("Player: " .. sourceName .. " is trying to add items to a custom inventory that he does not have, possible Cheat!!")
			return false
		end

		if inventory[item.id]:getCount() < amount then
			print("Player: " .. sourceName .. " is trying to add ammount of items to a custom inventory that he does not have, possible Cheat!!")
			return false
		end
	end

	return true
end

function InventoryService.MoveToCustom(obj)
	local _source = source

	local data = json.decode(obj)
	local invId <const> = tostring(data.id)
	if not CustomInventoryInfos[invId] then return end

	local item = data.item
	local amount = tonumber(data.number)
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local sourceIdentifier = sourceCharacter.identifier
	local sourceName = sourceCharacter.firstname .. ' ' .. sourceCharacter.lastname
	local job = sourceCharacter.job
	local grade = sourceCharacter.jobGrade
	local sourceCharIdentifier = sourceCharacter.charIdentifier
	local Table, Table1 = CustomInventoryInfos[invId]:getPermissionMoveTo()
	local CanMove = InventoryService.DoesHavePermission(invId, job, grade, Table)
	local CanMove1 = InventoryService.DoesCharIdHavePermission(invId, sourceCharIdentifier, Table1)
	local IsBlackListed = InventoryService.CheckIsBlackListed(invId, string.lower(item.name)) -- lower so we can checkitems and weapons


	if not CanProceed(item, amount, sourceIdentifier, sourceName) then
		return
	end

	if not IsBlackListed then
		return Core.NotifyObjective(_source, "Item is blackListed", 5000)
	end

	if not CanMove and not CanMove1 then -- either job or char id
		return Core.NotifyObjective(_source, "You dont have permision to move into the storage", 5000)
	end


	if item.type == "item_weapon" then
		if not CustomInventoryInfos[invId]:doesAcceptWeapons() then
			return Core.NotifyRightTip(_source, "This storage does not accept weapons", 2000)
		end

		if not InventoryService.canStoreWeapon(sourceIdentifier, sourceCharIdentifier, invId, item.name, amount) then
			return Core.NotifyRightTip(_source, T.fullInventory, 2000)
		end

		local query = "UPDATE loadout SET identifier = '',curr_inv = @invId WHERE charidentifier = @charid AND id = @weaponId"
		local params = { invId = invId, charid = sourceCharIdentifier, weaponId = item.id }
		DBService.updateAsync(query, params, function(r) end)
		UsersWeapons.default[item.id]:setCurrInv(invId)
		UsersWeapons[invId][item.id] = UsersWeapons.default[item.id]
		UsersWeapons.default[item.id] = nil
		TriggerClientEvent("vorpCoreClient:subWeapon", _source, item.id)
		InventoryService.reloadInventory(_source, invId)
		InventoryService.DiscordLogs(invId, item.name, amount, sourceName, "Move")
		local text = "you have moved to storage"

		if string.lower(item.name) == "weapon_revolver_lemat" then
			Icon = "weapon_revolver_doubleaction" -- theres no revolver lemat texture
		else
			Icon = item.name
		end
		Core.NotifyAvanced(_source, text, "inventory_items", Icon, "COLOR_PURE_WHITE", 4000)
	else
		if item.count and amount and item.count < amount then
			return print("Error: Amount is greater than item count")
		end
		local result, message = InventoryService.canStoreItem(sourceIdentifier, sourceCharIdentifier, invId, item.name, amount)
		if not result then
			return Core.NotifyRightTip(_source, message, 2000)
		end

		InventoryService.addItem(_source, invId, item.name, amount, item.metadata, function(itemAdded)
			if not itemAdded then
				return print("Error: Could not add item to inventory")
			end

			InventoryService.subItem(_source, "default", item.id, amount)
			TriggerClientEvent("vorpInventory:removeItem", _source, item.name, item.id, amount)
			Core.NotifyRightTip(_source, "you have Moved " .. amount .. " " .. item.label .. " to storage", 2000)
			InventoryService.reloadInventory(_source, invId)
			InventoryService.DiscordLogs(invId, item.name, amount, sourceName, "Move")
		end)
	end
end

function InventoryService.TakeFromCustom(obj)
	local _source = source

	local data = json.decode(obj)
	local invId <const> = tostring(data.id)
	if not CustomInventoryInfos[invId] then return end

	local item = data.item
	local amount = tonumber(data.number)
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local sourceName = sourceCharacter.firstname .. ' ' .. sourceCharacter.lastname
	local sourceIdentifier = sourceCharacter.identifier
	local sourceCharIdentifier = sourceCharacter.charIdentifier
	local job = sourceCharacter.job
	local grade = sourceCharacter.jobGrade
	local Table, Table1 = CustomInventoryInfos[invId]:getPermissionTakeFrom()
	local CanMove = InventoryService.DoesHavePermission(invId, job, grade, Table)
	local CanMove1 = InventoryService.DoesCharIdHavePermission(invId, sourceCharIdentifier, Table1)

	if not CanMove and not CanMove1 then
		return Core.NotifyObjective(_source, "you dont have permmissions to take from this storage", 5000) -- add your own notifications
	end

	if item.type == "item_weapon" then
		local canCarryWeapon = InventoryAPI.canCarryAmountWeapons(_source, 1, nil, item.name)

		if not canCarryWeapon then
			return Core.NotifyRightTip(_source, T.fullInventory, 2000)
		end

		local query = "UPDATE loadout SET curr_inv = 'default', charidentifier = @charid, identifier = @identifier WHERE id = @weaponId"
		local params = { identifier = sourceIdentifier, weaponId = item.id, charid = sourceCharIdentifier, }
		DBService.updateAsync(query, params, function(r) end)
		UsersWeapons[invId][item.id]:setCurrInv("default")
		UsersWeapons.default[item.id] = UsersWeapons[invId][item.id]
		UsersWeapons.default[item.id].propietary = sourceIdentifier
		UsersWeapons.default[item.id].charId = sourceCharIdentifier
		UsersWeapons[invId][item.id] = nil
		local weapon = UsersWeapons.default[item.id]
		local name = weapon:getName()
		local ammo = weapon:getAllAmmo()
		local label = weapon:getLabel()
		local serial = weapon:getSerialNumber()
		local custom = weapon:getCustomLabel()
		local customDesc = weapon:getCustomDesc()
		local weight = weapon:getWeight()
		TriggerClientEvent("vorpInventory:receiveWeapon", _source, item.id, sourceIdentifier, name, ammo, label, serial, custom, _source, customDesc, weight)
		InventoryService.reloadInventory(_source, invId)
		InventoryService.DiscordLogs(invId, item.name, amount, sourceName, "Take")
		local text = " you have Taken From storage "

		if string.lower(item.name) == "weapon_revolver_lemat" then
			Icon = "weapon_revolver_doubleaction" -- theres no revolver lemat texture
		else
			Icon = item.name
		end

		Core.NotifyAvanced(_source, text, "inventory_items", Icon, "COLOR_PURE_WHITE", 4000)
	else
		if item.count and amount > item.count then
			return print("Error: Amount is greater than item count")
		end

		local canCarryItem = InventoryAPI.canCarryItem(_source, item.name, amount)

		if not canCarryItem then
			return Core.NotifyRightTip(_source, "Cant carry more of this item stack limit achieved or inv is full", 2000)
		end

		InventoryService.addItem(_source, "default", item.name, amount, item.metadata, function(itemAdded)
			if not itemAdded then
				return print("Error: Could not add item to inventory")
			end
			local result = InventoryService.subItem(_source, invId, item.id, amount)

			if not result then
				return print("Error: Could not remove item from inventory")
			end

			TriggerClientEvent("vorpInventory:receiveItem", _source, item.name, itemAdded:getId(), amount, itemAdded:getMetadata())
			InventoryService.reloadInventory(_source, invId)
			InventoryService.DiscordLogs(invId, item.name, amount, sourceName, "Take")
			Core.NotifyRightTip(_source, "you have Taken " .. amount .. " " .. item.label .. " from storage ", 2000)
		end)
	end
end

local function HandleLimits(item, amount, target, _source, messages)
	local label = item.type == "item_weapon" and "weapons" or "items"
	if PlayerItemsLimit[target] and PlayerItemsLimit[target][item.type] then
		if PlayerItemsLimit[target][item.type].limit >= amount then
			if PlayerItemsLimit[target][item.type].limit - amount <= 0 then
				Core.NotifyObjective(_source, "You're about to reach your limit for " .. label .. ".", 2000)
				if PlayerItemsLimit[target][item.type].timeout and not CoolDownStarted[_source][item.type] then
					CoolDownStarted[_source][item.type] = os.time() + PlayerItemsLimit[target][item.type].timeout
				end
			end

			PlayerItemsLimit[target][item.type].limit = PlayerItemsLimit[target][item.type].limit - amount

			return true
		else
			Core.NotifyObjective(_source, messages[label], 2000)
			return false
		end
	elseif CoolDownStarted[_source] and CoolDownStarted[_source][item.type] and os.time() < CoolDownStarted[_source][item.type] then
		Core.NotifyObjective(_source, messages.cooldown .. label, 2000)
		return false
	else
		return true
	end
end

function InventoryService.MoveToPlayer(obj)
	local _source = source

	local data = json.decode(obj)
	local item = data.item
	local amount = tonumber(data.number)
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local sourceName = sourceCharacter.firstname .. ' ' .. sourceCharacter.lastname
	local invId = "default"
	local target = data.info.target
	local messages = {
		weapons = "You cannot give this amount of weapons to this player. Limit exceeded.",
		items = "You cannot give this amount of items to this player. Limit exceeded.",
		cooldown = "In cooldown, Player cant accept more "
	}


	if not CanProceed(item, amount, sourceCharacter.identifier, sourceName) then
		return
	end

	local IsBlackListed = PlayerBlackListedItems[string.lower(item.name)]

	if IsBlackListed then
		Core.NotifyObjective(_source, "blackListed", 5000) -- add your own notifications
		return
	end

	if not HandleLimits(item, amount, target, _source, messages) then
		return
	end

	if item.type == "item_weapon" then
		InventoryAPI.canCarryAmountWeapons(target, 1, function(res)
			if res then
				InventoryAPI.giveWeapon(target, item.id, _source, function(result)
					if result then
						InventoryService.reloadInventory(target, "default", "player", _source)
						InventoryService.DiscordLogs("default", item.name, amount, sourceName, "Move")
					end
				end)
			else
				return Core.NotifyObjective(_source, "Can't cary more weapons", 2000)
			end
		end, item.name)
	else
		if not item.count or not amount then
			return
		end

		local res = InventoryAPI.canCarryItem(target, item.name, amount)
		if not res then
			return Core.NotifyObjective(_source, "Cant carry more of this item", 2000)
		end

		if amount > item.count then
			return Core.NotifyObjective(_source, " dont have that amount of items", 2000)
		end

		InventoryAPI.addItem(target, item.name, amount, item.metadata, function(res)
			if res then
				InventoryAPI.subItem(_source, item.name, amount, item.metadata, function(result)
					if result then
						SetTimeout(400, function()
							InventoryService.reloadInventory(target, "default", "player", _source)
							InventoryService.DiscordLogs(invId, item.name, amount, sourceName, "Move")
							Core.NotifyRightTip(_source, "you have Moved" .. amount .. " " .. item.label .. " to player", 2000)
							Core.NotifyRightTip(target, "Item" .. item.label .. " was given to you", 2000)
						end)
					end
				end, true)
			end
		end, true)
	end
end

function InventoryService.TakeFromPlayer(obj)
	local _source = source
	local data = json.decode(obj)
	local item = data.item
	local amount = tonumber(data.number)
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local sourceName = sourceCharacter.firstname .. ' ' .. sourceCharacter.lastname
	local invId = "default"
	local target = data.info.target -- needs to remove from this target the items that are taken to source
	local IsBlackListed = PlayerBlackListedItems[string.lower(item.name)]
	local messages = {
		weapons = "You cannot remove this amount of weapons from this player. Limit exceeded.",
		items = "You cannot remove this amount of items from this player. Limit exceeded.",
		cooldown = "In cooldown, Player cant accept more "
	}

	if IsBlackListed then
		Core.NotifyObjective(_source, "BlackListed", 5000) -- add your own notifications
		return
	end

	if not HandleLimits(item, amount, target, _source, messages) then
		return
	end

	if item.type == "item_weapon" then
		InventoryAPI.canCarryAmountWeapons(_source, 1, function(res)
			if res then
				InventoryAPI.giveWeapon(_source, item.id, target, function(result)
					if result then
						InventoryService.reloadInventory(target, "default", "player", source)
						InventoryService.DiscordLogs("default", item.name, amount, sourceName, "Take")
					end
				end)
			else
				Core.NotifyObjective(_source, "You Can't cary more weapons", 2000)
			end
		end, item.name)
	else
		local res = InventoryAPI.canCarryItem(_source, item.name, amount)
		if not res then
			return Core.NotifyObjective(_source, "Cant carry more of this item", 2000)
		end

		if amount > item.count then
			return Core.NotifyObjective(_source, "You dont have that amount of items", 2000)
		end

		InventoryAPI.addItem(_source, item.name, amount, item.metadata, function(res)
			if res then
				InventoryAPI.subItem(target, item.name, amount, item.metadata, function(result)
					if result then
						InventoryService.reloadInventory(target, "default", "player", source)
						InventoryService.DiscordLogs(invId, item.name, amount, sourceName, "Take")
						Core.NotifyRightTip(_source, "you have Taken " .. amount .. " " .. item.label .. " from player", 2000)
						Core.NotifyRightTip(target, "Item" .. item.label .. " was taken from you", 2000)
					end
				end, true)
			end
		end, true)
	end
end

function InventoryService.addItemsToCustomInventory(id, items, charid)
	local newTable = {}
	local result = DBService.queryAwait("SELECT inventory_type FROM character_inventories WHERE inventory_type = @id", { id = id })

	if not result[1] then
		for _, value in ipairs(items) do
			local item = ServerItems[value.name]
			DBService.CreateItem(charid, item:getId(), value.amount, (value.metadata or {}), value.name, function()
			end, id)
		end
	else
		for _, value in ipairs(items) do
			local item = ServerItems[value.name]
			local itemMetadata = value.metadata or {}
			local result1 = DBService.queryAwait("SELECT amount, item_crafted_id FROM character_inventories WHERE item_name =@itemname AND inventory_type = @inventory_type", { itemname = value.name, inventory_type = id })

			if not result1[1] then
				DBService.CreateItem(charid, item:getId(), value.amount, itemMetadata, value.name, function()
				end, id)
			else
				local resulItems = {}
				for k, v in ipairs(result1) do -- if there is more than one apple we need to check which ones have metadata
					local result2 = DBService.queryAwait("SELECT metadata FROM items_crafted WHERE id =@id", { id = v.item_crafted_id })
					local hasMetadata = result2[1] and json.decode(result2[1].metadata) or {}
					if next(hasMetadata) then
						resulItems[#resulItems + 1] = v
					end
				end

				if #resulItems == 0 then
					if next(itemMetadata) then
						DBService.CreateItem(charid, item:getId(), value.amount, itemMetadata, value.name, function()
						end, id)
					else
						DBService.updateAsync("UPDATE character_inventories SET amount = amount + @amount WHERE item_name = @itemname AND inventory_type = @inventory_type", { amount = value.amount, itemname = value.name, inventory_type = id })
					end
				else
					for _, v in ipairs(resulItems) do
						local result2 = DBService.queryAwait("SELECT metadata FROM items_crafted WHERE id =@id", { id = v.item_crafted_id })
						local metadata = json.decode(result2[1].metadata)
						local result3 = SharedUtils.Table_equals(metadata, itemMetadata)
						if result3 then
							newTable[#newTable + 1] = v
						end
					end

					if #newTable == 0 then -- metadata of any of the items dont match new one so we create new one
						DBService.CreateItem(charid, item:getId(), value.amount, itemMetadata, value.name, function()
						end, id)
					else
						-- means we have a match so we update the amount
						DBService.updateAsync("UPDATE character_inventories SET amount = amount + @amount WHERE item_name = @itemname AND inventory_type = @inventory_type", { amount = value.amount, itemname = value.name, inventory_type = id })
					end
				end
			end
		end
	end
end

function InventoryService.addWeaponsToCustomInventory(id, weapons, charid)
	for _, value in ipairs(weapons) do
		local label = SvUtils.GenerateWeaponLabel(value.name)
		local serial_number = value.serial_number or SvUtils.GenerateSerialNumber(value.name)
		local custom_label = value.custom_label or SvUtils.GenerateWeaponLabel(value.name)
		local weight = SvUtils.GetWeaponWeight(value.name)
		local params = {
			curr_inv = id,
			charidentifier = charid,
			name = value.name,
			serial_number = serial_number,
			label = label,
			custom_label = custom_label,
			custom_desc = value.custom_desc or nil
		}

		DBService.insertAsync("INSERT INTO loadout (identifier, curr_inv, charidentifier, name,serial_number,label,custom_label,custom_desc) VALUES ('', @curr_inv, @charidentifier, @name, @serial_number, @label, @custom_label, @custom_desc)", params, function(result)
			local weaponId = result
			local newWeapon = Weapon:New({
				id = weaponId,
				propietary = "",
				name = value.name,
				ammo = {},
				used = false,
				used2 = false,
				charId = charid,
				currInv = id,
				dropped = 0,
				source = 0,
				label = label,
				serial_number = serial_number,
				custom_label = label,
				custom_desc = value.custom_desc or nil,
				group = 5,
				weight = weight
			})
			if not UsersWeapons[id] then
				UsersWeapons[id] = {}
			end
			UsersWeapons[id][weaponId] = newWeapon
		end)
	end
end

function InventoryService.removeItemFromCustomInventory(invId, item_name, amount)
	local result = DBService.queryAwait("SELECT amount, item_crafted_id FROM character_inventories WHERE item_name =@itemname AND inventory_type = @inventory_type", { itemname = item_name, inventory_type = invId })
	if not result[1] then
		return false
	end

	local item = result[1]
	local item_crafted_id = item.item_crafted_id
	local itemAmount = item.amount
	if itemAmount < amount then
		return false
	end

	if amount <= itemAmount then
		-- if its less than what we have or equals then we update its count
		if amount == itemAmount then
			DBService.updateAsync("DELETE FROM character_inventories WHERE item_name = @itemname AND inventory_type = @inventory_type", { itemname = item_name, inventory_type = invId })
			DBService.updateAsync("DELETE FROM items_crafted WHERE id = @id", { id = item_crafted_id })
		else
			DBService.updateAsync("UPDATE character_inventories SET amount = amount - @amount WHERE item_name = @itemname AND inventory_type = @inventory_type", { amount = amount, itemname = item_name, inventory_type = invId })
		end
	end
	return true
end

function InventoryService.removeWeaponFromCustomInventory(invId, weapon_name)
	local result = DBService.queryAwait("SELECT id FROM loadout WHERE curr_inv = @invId AND name = @name", { invId = invId, name = weapon_name })
	if not result[1] then
		return false
	end

	local weaponId = result[1].id
	DBService.updateAsync("DELETE FROM loadout WHERE id = @id", { id = weaponId })
	if UsersWeapons[invId] then
		UsersWeapons[invId][weaponId] = nil
	end
	return true
end

function InventoryService.getAllItemsFromCustomInventory(invId)
	local result = DBService.queryAwait("SELECT item_name, amount, item_crafted_id FROM character_inventories WHERE inventory_type = @inventory_type", { inventory_type = invId })
	local items = {}
	for _, value in ipairs(result) do
		local item = ServerItems[value.item_name]
		if item then
			local itemMetadata = {}
			local result1 = DBService.queryAwait("SELECT metadata FROM items_crafted WHERE id =@id", { id = value.item_crafted_id })
			if result1[1] then
				itemMetadata = result1[1].metadata and json.decode(result1[1].metadata) or {}
			end
			items[#items + 1] = {
				name = value.item_name,
				amount = value.amount,
				metadata = itemMetadata,
				id = value.item_crafted_id
			}
		end
	end
	return items
end

function InventoryService.getAllWeaponsFromCustomInventory(invId)
	local result = DBService.queryAwait("SELECT id, name, serial_number, label, custom_label, custom_desc FROM loadout WHERE curr_inv = @invId", { invId = invId })
	local weapons = {}
	for _, value in ipairs(result) do
		weapons[#weapons + 1] = {
			name = value.name,
			serial_number = value.serial_number or "",
			label = value.label,
			custom_label = value.custom_label or "",
			custom_desc = value.custom_desc or "",
			id = value.id
		}
	end
	return weapons
end

function InventoryService.removeItemsByIdFromCustomInventory(invId, item_crafted_id, amount)
	local result = DBService.queryAwait("SELECT item_name, amount FROM character_inventories WHERE item_crafted_id = @item_crafted_id AND inventory_type = @inventory_type", { item_crafted_id = item_crafted_id, inventory_type = invId })
	if not result[1] then
		return false
	end

	local item = result[1]
	local itemAmount = item.amount
	if amount >= itemAmount then
		DBService.updateAsync("DELETE FROM character_inventories WHERE item_crafted_id = @item_crafted_id AND inventory_type = @inventory_type", { item_crafted_id = item_crafted_id, inventory_type = invId })
		DBService.updateAsync("DELETE FROM items_crafted WHERE id = @id", { id = item_crafted_id })
	else
		DBService.updateAsync("UPDATE character_inventories SET amount = amount - @amount WHERE item_crafted_id = @item_crafted_id AND inventory_type = @inventory_type", { amount = amount, item_crafted_id = item_crafted_id, inventory_type = invId })
	end

	return true
end

function InventoryService.removeWeaponsByIdFromCustomInventory(invId, weaponId)
	local result = DBService.queryAwait("SELECT id FROM loadout WHERE id = @id AND curr_inv = @invId", { id = weaponId, invId = invId })
	if not result[1] then
		return false
	end

	DBService.updateAsync("DELETE FROM loadout WHERE id = @id", { id = weaponId })
	if UsersWeapons[invId] then
		UsersWeapons[invId][weaponId] = nil
	end
	return true
end

function InventoryService.updateItemInCustomInventory(invId, item_crafted_id, metadata, amount)
	local result = DBService.queryAwait("SELECT amount FROM character_inventories WHERE item_crafted_id = @item_crafted_id AND inventory_type = @inventory_type", { item_crafted_id = item_crafted_id, inventory_type = invId })
	if not result[1] or not metadata then
		return false
	end

	local item = result[1]
	local itemAmount = amount or item.amount

	if metadata and type(metadata) == "table" then
		metadata = json.encode(metadata)
	end

	DBService.updateAsync("UPDATE character_inventories SET amount = @amount WHERE item_crafted_id = @item_crafted_id AND inventory_type = @inventory_type", { amount = itemAmount, item_crafted_id = item_crafted_id, inventory_type = invId })


	if metadata then
		DBService.updateAsync("UPDATE items_crafted SET metadata = @metadata WHERE id = @id", { metadata = metadata, id = item_crafted_id })
	end
	return true
end

function InventoryService.deleteCustomInventory(invId)
	local result = DBService.queryAwait("SELECT item_crafted_id FROM character_inventories WHERE inventory_type = @inventory_type", { inventory_type = invId })
	if not result[1] then
		return false
	end

	for _, value in ipairs(result) do
		DBService.updateAsync("DELETE FROM items_crafted WHERE id = @id", { id = value.item_crafted_id })
	end

	DBService.updateAsync("DELETE FROM character_inventories WHERE inventory_type = @inventory_type", { inventory_type = invId })
	DBService.updateAsync("DELETE FROM loadout WHERE curr_inv = @invId", { invId = invId })

	if UsersWeapons[invId] then
		UsersWeapons[invId] = nil
	end
end
