---@diagnostic disable: undefined-global
InventoryService = {}
ItemPickUps = {}
MoneyPickUps = {}
GoldPickUps = {}
math.randomseed(GetGameTimer())
ItemUids = {}
local newchar = {} -- new
local timer = 120  -- in minutes

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
			local charname, scourceidentifier, steamname = getSourceInfo(_source)
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

function InventoryService.DropAllMoney()
	local _source = source
	if not SvUtils.InProcessing(_source) then
		SvUtils.ProcessUser(_source)
		local userCharacter = Core.getUser(_source).getUsedCharacter
		local userMoney = userCharacter.money
		local charid = userCharacter.charIdentifier

		if not InventoryService.CheckNewPlayer(_source, charid) then
			return
		end

		if userMoney > 0 then
			TriggerClientEvent("vorpInventory:createMoneyPickup", _source, userMoney)
		end
		SvUtils.Trem(_source)
	end
end

function InventoryService.DropPartMoney()
	local _source = source
	local userCharacter = Core.getUser(_source).getUsedCharacter
	local userMoney = userCharacter.money
	local userPartMoney = userMoney - (userMoney * Config.DropOnRespawn.PartPercentage / 100)
	local userMoneyDef = userMoney - userPartMoney
	local charid = userCharacter.charIdentifier

	if not InventoryService.CheckNewPlayer(_source, charid) then
		return
	end

	if userMoney > 0 then
		TriggerClientEvent("vorpInventory:createMoneyPickup", _source, userMoneyDef)
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

function InventoryService.DropAllGold()
	local _source = source
	if SvUtils.InProcessing(_source) then
		return
	end

	SvUtils.ProcessUser(_source)
	local userCharacter = Core.getUser(_source).getUsedCharacter
	local userGold = userCharacter.gold

	if userGold > 0 then
		TriggerClientEvent("vorpInventory:createGoldPickup", _source, userGold)
	end
	SvUtils.Trem(_source, false)
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
						TriggerEvent("vorp_inventory:Server:OnItemRemoved", data)
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
		DBService.CreateItem(charIdentifier, svItem:getId(), amount, metadata, function(craftedItem)
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
				group = svItem:getGroup()
			})
			userInventory[craftedItem.id] = item
			if invId == "default" then
				TriggerEvent("vorp_inventory:Server:OnItemCreated", item)
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
		return Log.error("User not found")
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

	if not ItemUids[uid] then
		return
	end

	if SvUtils.InProcessing(_source) then
		return
	end

	SvUtils.ProcessUser(_source)
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charId = sourceCharacter.charIdentifier
	local job = sourceCharacter.job
	local userInventory = UsersInventories.default[identifier]
	local userWeapons = UsersWeapons.default

	if ItemPickUps[uid] ~= nil then
		local name = ItemPickUps[uid].name
		local amount = ItemPickUps[uid].amount
		local metadata = ItemPickUps[uid].metadata

		if ItemPickUps[uid].weaponid == 1 then
			if userInventory ~= nil then
				InventoryAPI.canCarryItem(_source, name, amount, function(canAdd)
					if canAdd and ItemPickUps[uid] then
						InventoryService.addItem(_source, "default", name, amount, metadata, function(item)
							if item ~= nil then
								local dataItem = { name = name, obj = ItemPickUps[uid].obj, amount = amount, metadata = metadata, position = ItemPickUps[uid].coords, id = ItemPickUps[uid].id }
								ItemPickUps[uid] = nil
								ItemUids[uid] = nil
								local charname, scourceidentifier, steamname = getSourceInfo(_source)
								local title = T.itempickup
								local description = "**" .. T.WebHookLang.amount .. "** `" .. amount .. "`\n **" .. T.WebHookLang.item .. "** `" .. name .. "` \n**" .. T.WebHookLang.charname .. ":** `" .. charname .. "`\n**" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "`"
								local info = { source = _source, name = Logs.WebHook.webhookname, title = title, description = description, webhook = Logs.WebHook.webhook, color = Logs.WebHook.coloritempickup, }
								TriggerClientEvent("vorpInventory:sharePickupClient", -1, dataItem, 2)
								TriggerClientEvent("vorpInventory:removePickupClient", -1, dataItem.obj)
								TriggerClientEvent("vorpInventory:receiveItem", _source, name, item:getId(), amount, metadata)
								TriggerClientEvent("vorpInventory:playerAnim", _source, uid)
								SvUtils.SendDiscordWebhook(info)
							end
						end)
					else
						Core.NotifyRightTip(_source, T.fullInventory, 2000)
						SvUtils.Trem(_source, false)
					end
				end)
			end
		else
			-- weapons
			local notListed = false
			local sourceInventoryWeaponCount = 0
			local DefaultAmount = Config.MaxItemsInInventory.Weapons
			local weaponId = ItemPickUps[uid].weaponid
			local weapon = userWeapons[weaponId]
			local wepname = weapon:getName()
			local weaponCustomLabel = weapon:getCustomLabel()
			local serialNumber = weapon:getSerialNumber()
			local weaponCustomDesc = weapon:getCustomDesc()

			if Config.JobsAllowed[job] then
				DefaultAmount = Config.JobsAllowed[job]
			end

			if DefaultAmount ~= 0 then
				if wepname then
					if SharedUtils.IsValueInArray(string.upper(wepname), Config.notweapons) then
						notListed = true
					end
				end
				if not notListed then
					sourceInventoryWeaponCount = InventoryAPI.getUserTotalCountWeapons(identifier, charId) + 1
				end
				if sourceInventoryWeaponCount <= DefaultAmount then
					local weaponObj = ItemPickUps[uid].obj
					weapon:setDropped(0)

					local dataweapon = { name = wepname, obj = weaponObj, amount = amount, metadata = metadata, weaponId = weaponId, position = ItemPickUps[uid].coords, custom_label = weaponCustomLabel, serial_number = serialNumber, custom_desc = weaponCustomDesc, id = nil }
					ItemPickUps[uid] = nil
					if weaponCustomDesc == nil then
						weaponCustomDesc = "Custom Description not set"
					end
					if serialNumber == nil then
						serialNumber = "Serial Number not set"
					end
					local charname, scourceidentifier, steamname = getSourceInfo(_source)
					local title = T.weppickup
					local description = "**" .. T.WebHookLang.Weapontype .. ":** `" .. wepname .. "`\n**" .. T.WebHookLang.charname .. ":** `" .. charname .. "`\n**" .. T.WebHookLang.serialnumber .. "** `" .. serialNumber .. "`\n **" .. T.WebHookLang.Desc .. "** `" .. weaponCustomDesc .. "` \n **" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "`"
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
	local charname, scourceidentifier, steamname = getSourceInfo(_source)
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
		local userWeapons = UsersWeapons.default
		TriggerClientEvent("vorp_inventory:transactionCompleted", _source)
		SvUtils.Trem(_source)
	end
end

function InventoryService.giveWeapon2(player, weaponId, target)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local sourceIdentifier = sourceCharacter.identifier
	local sourceCharId = sourceCharacter.charIdentifier
	local job = sourceCharacter.job
	local _target = tonumber(target)
	local userWeapons = UsersWeapons.default
	local DefaultAmount = Config.MaxItemsInInventory.Weapons
	local weaponName = userWeapons[weaponId]:getName()
	local serialNumber = userWeapons[weaponId]:getSerialNumber()
	local desc = userWeapons[weaponId]:getCustomDesc()
	local charname, scourceidentifier, steamname = getSourceInfo(_source)
	local charname2, scourceidentifier2, steamname2 = getSourceInfo(target)
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
				if Config.Debug then
					Log.print(sourceCharacter.firstname .. " " .. sourceCharacter.lastname .. " ^1Can't carry more weapons^7")
				end
				return
			end
		end
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
	InventoryAPI.registerWeapon(_source, weaponName, ammo, components, weaponcomps, function()
	end, weaponId)
	InventoryAPI.deleteWeapon(_source, weaponId, function()
	end)
	TriggerClientEvent("vorpinventory:updateinventorystuff", _target)
	TriggerClientEvent("vorpinventory:updateinventorystuff", _source)
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

	if SvUtils.InProcessing(_source) then
		return
	end

	TriggerClientEvent("vorp_inventory:transactionStarted", _source)
	SvUtils.ProcessUser(_source)

	local user = Core.getUser(_source)
	local user1 = Core.getUser(_target)
	if not user or not user1 then
		TriggerClientEvent("vorp_inventory:transactionCompleted", _source)
		SvUtils.Trem(_source)
		return
	end

	local sourceCharacter = user.getUsedCharacter
	local targetCharacter = user1.getUsedCharacter
	local charid = sourceCharacter.charIdentifier -- new line

	if not InventoryService.CheckNewPlayer(_source, charid) then
		TriggerClientEvent("vorp_inventory:transactionCompleted", _source)
		return
	end
	local sourceInventory = UsersInventories.default[sourceCharacter.identifier]
	local targetInventory = UsersInventories.default[targetCharacter.identifier]
	local targetIdentifier = targetCharacter.identifier
	local sourceCharIdentifier = sourceCharacter.charIdentifier
	local targetCharIdentifier = targetCharacter.charIdentifier

	if sourceInventory == nil or targetInventory == nil then
		TriggerClientEvent("vorp_inventory:transactionCompleted", _source)
		SvUtils.Trem(_source)
		return
	end

	if sourceInventory[itemId] == nil then
		Core.NotifyRightTip(_source, T.itemerror, 2000)
		if Config.Debug then
			Log.error("ServerGiveItem: User " .. sourceCharacter.firstname .. ' ' .. sourceCharacter.lastname .. '#' .. _source .. ' ' .. 'inventory item  not found')
		end
		TriggerClientEvent("vorp_inventory:transactionCompleted", _source)
		SvUtils.Trem(_source)
		return
	end
	local item = sourceInventory[itemId]
	local itemMetadata = item:getMetadata()
	local itemName = item:getName()
	local svItem = ServerItems[itemName]

	local charname, scourceidentifier, steamname = getSourceInfo(_source)
	local charname2, scourceidentifier2, steamname2 = getSourceInfo(_target)

	local title = T.gaveitem
	local description = "**" .. T.WebHookLang.amount .. "**: `" .. amount .. "`\n **" .. T.WebHookLang.item .. "** : `" .. itemName .. "`" .. "\n**" .. T.WebHookLang.charname .. ":** `" .. charname .. "` \n**" .. T.WebHookLang.Steamname .. "** `" .. steamname .. "` \n**" .. T.to .. "** `" .. charname2 .. "`\n**" .. T.WebHookLang.Steamname .. "** `" .. steamname2 .. "` \n"
	local info = { source = _source, name = Logs.WebHook.webhookname, title = title, description = description, webhook = Logs.WebHook.webhook, color = Logs.WebHook.colorgiveitem }

	if not svItem then
		if Config.Debug then
			Log.error("[^2GiveItem^7] ^1Error^7: Item [^3" .. itemName .. "^7] does not exist in DB.")
		end
		TriggerClientEvent("vorp_inventory:transactionCompleted", _source)
		SvUtils.Trem(_source)
		return
	end

	local function updateClient(addedItem)
		TriggerClientEvent("vorpInventory:receiveItem", _target, itemName, addedItem:getId(), amount, itemMetadata)
		TriggerClientEvent("vorpInventory:removeItem", _source, itemName, item:getId(), amount)
		if item:getCount() - amount <= 0 then
			DBService.DeleteItem(sourceCharIdentifier, item:getId())
			sourceInventory[item:getId()] = nil
		else
			item:quitCount(amount)
			DBService.SetItemAmount(sourceCharIdentifier, item:getId(), item:getCount())
		end
		local ItemsLabel = svItem:getLabel()
		Core.NotifyRightTip(_source, T.yougive .. amount .. T.of .. ItemsLabel .. "", 2000)
		Core.NotifyRightTip(_target, T.youreceive .. amount .. T.of .. ItemsLabel .. "", 2000)
	end

	InventoryAPI.canCarryItem(_target, itemName, amount, function(canGive)
		if canGive then
			local targetItem = SvUtils.FindItemByNameAndMetadata("default", targetIdentifier, itemName, itemMetadata)
			if targetItem ~= nil then
				targetItem:addCount(amount)
				DBService.SetItemAmount(targetCharIdentifier, targetItem:getId(), targetItem:getCount())
				updateClient(targetItem)
			else
				DBService.CreateItem(targetCharIdentifier, svItem:getId(), amount, itemMetadata, function(craftedItem)
					targetItem = Item:New({
						id = craftedItem.id,
						count = amount,
						limit = svItem:getLimit(),
						label = svItem:getLabel(),
						name = itemName,
						type = "item_inventory",
						metadata = itemMetadata,
						canUse = svItem:getCanUse(),
						canRemove = svItem:getCanRemove(),
						owner = targetCharIdentifier,
						desc = svItem:getDesc(),
						group = svItem:getGroup(),
					})
					targetInventory[craftedItem.id] = targetItem
					updateClient(targetItem)
				end)
			end
			SvUtils.SendDiscordWebhook(info)
		else
			Core.NotifyRightTip(_source, T.fullInventoryGive, 2000)
			Core.NotifyRightTip(_target, T.fullInventory, 2000)
		end
	end)
	TriggerClientEvent("vorp_inventory:transactionCompleted", _source)
	SvUtils.Trem(_source)
end

function InventoryService.getItemsTable()
	local _source = source

	if ServerItems ~= nil then
		TriggerClientEvent("vorpInventory:giveItemsTable", _source, ServerItems)
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

function InventoryService.getAmmoInfo()
	local _source = source
	if allplayersammo[_source] then
		TriggerClientEvent("vorpinventory:recammo", _source, allplayersammo[_source])
	end
end

-- give ammo to player
function InventoryService.serverGiveAmmo(ammotype, amount, target, maxcount)
	local _source = source
	local player1ammo = allplayersammo[_source].ammo[ammotype]
	local player2ammo = allplayersammo[target].ammo[ammotype]

	if player2ammo == nil then
		allplayersammo[target].ammo[ammotype] = 0
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

	allplayersammo[_source].ammo[ammotype] = allplayersammo[_source].ammo[ammotype] - amount
	allplayersammo[target].ammo[ammotype] = allplayersammo[target].ammo[ammotype] + amount
	local charidentifier = allplayersammo[_source].charidentifier
	local charidentifier2 = allplayersammo[target].charidentifier

	local query = "UPDATE characters Set ammo=@ammo WHERE charidentifier=@charidentifier"
	local params = { charidentifier = charidentifier, ammo = json.encode(allplayersammo[_source].ammo) }
	local params2 = { charidentifier = charidentifier2, ammo = json.encode(allplayersammo[target].ammo) }
	DBService.updateAsync(query, params, function(r) end)
	DBService.updateAsync(query, params2, function(r) end)

	TriggerClientEvent("vorpinventory:updateuiammocount", _source, allplayersammo[_source].ammo)
	TriggerClientEvent("vorpinventory:updateuiammocount", target, allplayersammo[target].ammo)
	TriggerClientEvent("vorpinventory:setammotoped", _source, allplayersammo[_source].ammo)
	TriggerClientEvent("vorpinventory:setammotoped", target, allplayersammo[target].ammo)
	-- notify
	Core.NotifyRightTip(_source, T.transferedammo .. SharedData.AmmoLabels[ammotype] .. " : " .. amount, 2000)
	Core.NotifyRightTip(target, T.recammo .. SharedData.AmmoLabels[ammotype] .. " : " .. amount, 2000)
	TriggerClientEvent("vorp_inventory:ProcessingReady", _source)
	-- update players client side
	TriggerClientEvent("vorpinventory:recammo", _source, allplayersammo[_source])
	TriggerClientEvent("vorpinventory:recammo", target, allplayersammo[target])
end

function InventoryService.updateAmmo(ammoinfo)
	local _source = source
	local query = "UPDATE characters Set ammo=@ammo WHERE charidentifier=@charidentifier"
	local params = { charidentifier = ammoinfo.charidentifier, ammo = json.encode(ammoinfo.ammo) }
	DBService.updateAsync(query, params, function(result)
		if result then
			allplayersammo[_source] = ammoinfo
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
			allplayersammo[_source] = { charidentifier = charidentifier, ammo = ammo }
			if next(ammo) then
				for k, v in pairs(ammo) do
					local ammocount = tonumber(v)
					if ammocount and ammocount > 0 then
						TriggerClientEvent("vorpCoreClient:addBullets", _source, k, ammocount)
					end
				end
				-- update players client side
				TriggerClientEvent("vorpinventory:recammo", _source, allplayersammo[_source])
			end
		end
	end)
end

function InventoryService.onNewCharacter(source)
	Wait(5000)
	local player = Core.getUser(source)

	for key, value in pairs(Config.startItems) do
		InventoryAPI.addItem(source, tostring(key), value, {}, function() end)
	end

	for _, value in ipairs(Config.startWeapons) do
		InventoryAPI.registerWeapon(source, value, {}, {}, {}, function() end)
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
		for weaponId, weapon in pairs(UsersWeapons[id]) do
			if weapon.charId == sourceCharIdentifier then
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
	end

	-- arrange userInventory as a list
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

--- can store item
---@return boolean
function InventoryService.canStoreItem(identifier, charIdentifier, invId, name, amount)
	local invData = CustomInventoryInfos[invId]


	if invData:getLimit() > 0 then
		local sourceInventoryItemCount = InventoryService.getInventoryTotalCount(identifier, charIdentifier, invId)
		sourceInventoryItemCount = sourceInventoryItemCount + amount


		if sourceInventoryItemCount > invData:getLimit() then
			return false
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
				return false
			end
		elseif amount > invData:getItemLimit(name) then
			return false
		end
		return true
	elseif invData:iswhitelistItemsEnabled() then
		return false
	end

	if not invData:getIgnoreItemStack() then
		local item = SvUtils.FindItemByNameAndMetadata(invId, identifier, name, metadata)
		if item ~= nil then
			local totalCount = item:getCount() + amount

			if totalCount > item:getLimit() then
				return false
			end
		end
	end
	return true
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
				label = tostring(playerId), -- show server id instead of steam name
				player = playerId
			}
		end
	end

	TriggerClientEvent('vorp_inventory:setNearbyCharacters', _source, obj, characters)
end

--* CUSTOM INVENTORY *--
---@return boolean
function InventoryService.DoesHavePermission(invId, job, grade, Table)
	if not CustomInventoryInfos[invId]:isPermEnabled() then
		return true
	end

	if not next(Table) then -- if empty allow anyone, by default is empty
		return true
	end

	for jobname, jobgrade in pairs(Table) do
		if jobname == job then
			if grade >= jobgrade then
				return true
			end
		end
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

	if type == "Move" then
		local webhook = Logs.WebHook.CustomInventoryMoveTo
		local description = "**Player:**`" .. playerName .. "`\n **Moved to:** `" .. inventory .. "` \n**Weapon** `" .. itemName .. "`\n **Count:** `" .. amount .. "`"
		Core.AddWebhook(title, webhook, description, color, names, logo, footerlogo, avatar)
	end

	if type == "Take" then
		local webhook = Logs.WebHook.CustomInventoryTakeFrom
		local description = "**Player:**`" .. playerName .. "`\n **Took from:** `" .. inventory .. "`\n **item** `" .. itemName .. "`\n **amount:** `" .. amount .. "`"
		Core.AddWebhook(title, webhook, description, color, names, logo, footerlogo, avatar)
	end
end

function InventoryService.MoveToCustom(obj)
	local _source = source
	local data = json.decode(obj)
	local invId = tostring(data.id)
	local item = data.item
	local amount = tonumber(data.number)
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local sourceIdentifier = sourceCharacter.identifier
	local sourceName = sourceCharacter.firstname .. ' ' .. sourceCharacter.lastname
	local job = sourceCharacter.job
	local grade = sourceCharacter.jobGrade
	local sourceCharIdentifier = sourceCharacter.charIdentifier
	local Table = CustomInventoryInfos[invId]:getPermissionMoveTo()
	local CanMove = InventoryService.DoesHavePermission(invId, job, grade, Table)
	local IsBlackListed = InventoryService.CheckIsBlackListed(invId, string.lower(item.name)) -- lower so we can checkitems and weapons

	local function CanProceed()
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

	if not CanProceed() then
		return
	end

	if not IsBlackListed then
		return Core.NotifyObjective(_source, "Item is blackListed", 5000)
	end

	if not CanMove then
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

		if not InventoryService.canStoreItem(sourceIdentifier, sourceCharIdentifier, invId, item.name, amount) then
			return Core.NotifyRightTip(_source, T.fullInventory, 2000)
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
	local invId = tostring(data.id)
	local item = data.item
	local amount = tonumber(data.number)
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local sourceName = sourceCharacter.firstname .. ' ' .. sourceCharacter.lastname
	local sourceIdentifier = sourceCharacter.identifier
	local sourceCharIdentifier = sourceCharacter.charIdentifier
	local job = sourceCharacter.job
	local grade = sourceCharacter.jobGrade
	local Table = CustomInventoryInfos[invId]:getPermissionTakeFrom()
	local CanMove = InventoryService.DoesHavePermission(invId, job, grade, Table)

	if not CanMove then
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
		TriggerClientEvent("vorpInventory:receiveWeapon", _source, item.id, sourceIdentifier, name, ammo, label, serial, custom, _source)
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
		local invHasSpace = InventoryAPI.canCarryAmountItem(_source, amount)

		if not canCarryItem then
			return Core.NotifyRightTip(_source, "Cant carry more of this item stack limit achieved", 2000)
		end

		if not invHasSpace then
			return Core.NotifyRightTip(_source, T.fullInventory, 2000)
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

		local res = InventoryAPI.canCarryAmountItem(target, amount)
		if not res then
			return Core.NotifyObjective(_source, T.fullInventory, 2000)
		end

		res = InventoryAPI.canCarryItem(target, item.name, amount)
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
				end)
			end
		end)
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
		local res = InventoryAPI.canCarryAmountItem(_source, amount)
		if not res then
			return Core.NotifyObjective(_source, T.fullInventory, 2000)
		end

		res = InventoryAPI.canCarryItem(_source, item.name, amount)
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
				end)
			end
		end)
	end
end
