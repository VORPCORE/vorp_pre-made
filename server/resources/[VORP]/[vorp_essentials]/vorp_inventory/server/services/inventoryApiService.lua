---@diagnostic disable: undefined-global
---@class InventoryAPI @Inventory API
InventoryAPI = {}

---@class CustomInventoryInfos @Custom Inventory Infos
---@field id string
---@field name string
---@field limit number
---@field acceptWeapons boolean
---@field shared boolean
---@field limitedItems table<string, integer>
---@field whitelistItems boolean
---@field ignoreItemStackLimit boolean
---@field PermissionTakeFrom table<string, integer>
---@field PermissionMoveTo table<string, integer>
---@field UsePermissions boolean
---@field UseBlackList boolean
---@field BlackListItems table<string, string>
---@field whitelistWeapons boolean
---@field limitedWeapons table<string, integer>
CustomInventoryInfos = {
	default = {
		id = "default",
		name = "Satchel",
		limit = Config.MaxItemsInInventory.Items,
		shared = false,
		limitedItems = {},
		ignoreItemStackLimit = false,
		whitelistItems = false,
		PermissionTakeFrom = {},
		PermissionMoveTo = {},
		UsePermissions = false,
		UseBlackList = false,
		BlackListItems = {},
		whitelistWeapons = false,
		limitedWeapons = {}
	}
}

---@type table<string,function> table of Registered items
UsableItemsFunctions = {}

---@type table<number,table<number,string>> contains players ammo
allplayersammo = {}

---@type table<string, table<number, table<number, Item>>> contain users inventory items
UsersInventories = { default = {} }

--- sync or async helper
local function respond(cb, result)
	if cb then
		cb(result)
	end
	return result
end

--- check inventory limit
---@param player number source
---@param amount number amount of items
---@param cb fun(canCarry: boolean)? async or sync callback
function InventoryAPI.canCarryAmountItem(player, amount, cb)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charid = sourceCharacter.charIdentifier
	local userInventory = UsersInventories.default[identifier]

	local function cancarryammount(identifier, charid, amount, limit)
		local totalAmount = InventoryAPI.getUserTotalCountItems(identifier, charid)
		return limit ~= -1 and totalAmount + amount <= limit and userInventory ~= nil
	end

	local canCarry = cancarryammount(identifier, charid, amount, Config.MaxItemsInInventory.Items)
	return respond(cb, canCarry)
end

exports("canCarryItem", InventoryAPI.canCarryAmountItem)


---check limit of item
---@param player number source
---@param itemName string item name
---@param amount number amount of item
---@param cb fun(canCarry: boolean)? async or sync callback
function InventoryAPI.canCarryItem(player, itemName, amount, cb)
	local function exceedsItemLimit(identifier, itemName, amount, limit)
		local items = SvUtils.FindAllItemsByName("default", identifier, itemName)
		local count = 0
		for _, item in pairs(items) do
			count = count + item:getCount()
		end
		return count + amount > limit
	end

	local function exceedsInventoryLimit(identifier, charid, amount)
		local totalAmount = InventoryAPI.getUserTotalCountItems(identifier, charid)
		return Config.MaxItemsInInventory.Items ~= -1 and totalAmount + amount > Config.MaxItemsInInventory.Items
	end

	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charid = sourceCharacter.charIdentifier
	local svItem = ServerItems[itemName]
	local canCarry = false

	if not SvUtils.DoesItemExist(itemName, "InventoryAPI.canCarryItem") then
		return respond(cb, false)
	end

	local limit = svItem.limit

	if limit ~= -1 and not exceedsItemLimit(identifier, itemName, amount, limit) then
		canCarry = not exceedsInventoryLimit(identifier, charid, amount)
	elseif limit == -1 then
		canCarry = not exceedsInventoryLimit(identifier, charid, amount)
	end

	return respond(cb, canCarry)
end

exports("canCarryItems", InventoryAPI.canCarryItem)

---get player inventory
---@param player number source
---@param cb fun(items: table)? async or sync callback
function InventoryAPI.getInventory(player, cb)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local userInventory = UsersInventories.default[identifier]

	if userInventory then
		local playerItems = {}

		for _, item in pairs(userInventory) do
			local newItem = {
				id = item:getId(),
				label = item:getLabel(),
				name = item:getName(),
				metadata = item:getMetadata(),
				type = item:getType(),
				count = item:getCount(),
				limit = item:getLimit(),
				canUse = item:getCanUse(),
				group = item:getGroup(),
			}
			table.insert(playerItems, newItem)
		end
		return respond(cb, playerItems)
	end
end

exports("getUserInventoryItems", InventoryAPI.getInventory)

--- register usable item
---@param name string item name
---@param cb function callback
function InventoryAPI.registerUsableItem(name, cb)
	if Config.Debug then
		SetTimeout(9000, function()
			Log.print("Callback for item[^3" .. name .. "^7] ^2Registered!^7")
		end)
	end

	UsableItemsFunctions[name] = cb
end

exports("registerUsableItem", InventoryAPI.registerUsableItem)

--- get user weapon
---@param player number player source
---@param cb fun(items: table)? async or sync callback
---@param weaponId number weapon id
---@return table
function InventoryAPI.getUserWeapon(player, cb, weaponId)
	local _source = player
	local weapon = {}
	local foundWeapon = UsersWeapons.default[weaponId]

	if not foundWeapon then
		return respond(cb, false)
	end

	weapon.name = foundWeapon:getName()
	weapon.id = foundWeapon:getId()
	weapon.propietary = foundWeapon:getPropietary()
	weapon.used = foundWeapon:getUsed()
	weapon.ammo = foundWeapon:getAllAmmo()
	weapon.desc = foundWeapon:getDesc()
	weapon.group = 5
	Weapon.source = foundWeapon:getSource()

	return respond(cb, weapon)
end

exports("getUserWeapon", InventoryAPI.getUserWeapon)

--- get all user weapons
---@param player number source
---@param cb fun(weapons: table)? async or sync callback
function InventoryAPI.getUserWeapons(player, cb)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charidentifier = sourceCharacter.charIdentifier
	local usersWeapons = UsersWeapons.default

	local userWeapons2 = {}

	for _, currentWeapon in pairs(usersWeapons) do
		if currentWeapon:getPropietary() == identifier and currentWeapon:getCharId() == charidentifier then
			local weapon = {
				name = currentWeapon:getName(),
				id = currentWeapon:getId(),
				propietary = currentWeapon:getPropietary(),
				used = currentWeapon:getUsed(),
				ammo = currentWeapon:getAllAmmo(),
				desc = currentWeapon:getDesc(),
				group = 5,
				source = currentWeapon:getSource(),
			}
			table.insert(userWeapons2, weapon)
		end
	end

	return respond(cb, userWeapons2)
end

exports("getUserInventoryWeapons", InventoryAPI.getUserWeapons)

--- get user weapon bullets
---@param player number source
---@param weaponId number weapon id
---@param cb fun(ammo: number)? async or sync callback
---@return number
function InventoryAPI.getWeaponBullets(player, weaponId, cb)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local userWeapons = UsersWeapons.default[weaponId]

	if userWeapons then
		if userWeapons:getPropietary() == identifier then
			return respond(cb, userWeapons:getAllAmmo())
		end
	end
	return respond(cb, 0)
end

exports("getWeaponBullets", InventoryAPI.getWeaponBullets)

--- remove all user ammo
---@param player number source
---@param cb fun(success: boolean)? async or sync callback
---@return boolean
function InventoryAPI.removeAllUserAmmo(player, cb)
	local _source = player
	allplayersammo[_source].ammo = {}
	TriggerClientEvent("vorpinventory:updateuiammocount", _source, allplayersammo[_source].ammo)
	return respond(cb, true)
end

exports("removeAllUserAmmo", InventoryAPI.removeAllUserAmmo)


--- add bullets to player
---@param player number source
---@param bulletType string bullet type
---@param amount number amount of bullets
---@param cb fun(success: boolean)? async or sync callback
---@return boolean
function InventoryAPI.addBullets(player, bulletType, amount, cb)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local charidentifier = sourceCharacter.charIdentifier
	local query = 'SELECT ammo FROM characters WHERE charidentifier = @charidentifier'
	local params = { charidentifier = charidentifier }

	DBService.queryAsync(query, params, function(result)
		local ammo = json.decode(result[1].ammo)
		if ammo[bulletType] then
			ammo[bulletType] = tonumber(ammo[bulletType]) + amount
		else
			ammo[bulletType] = amount
		end
		allplayersammo[_source].ammo = ammo
		TriggerClientEvent("vorpinventory:updateuiammocount", _source, allplayersammo[_source].ammo)
		TriggerClientEvent("vorpCoreClient:addBullets", _source, bulletType, ammo[bulletType])
		local query1 = 'UPDATE characters SET ammo = @ammo WHERE charidentifier = @charidentifier'
		local params1 = { charidentifier = charidentifier, ammo = json.encode(ammo) }
		DBService.updateAsync(query1, params1, function(r) end)
	end)
	return respond(cb, true)
end

exports("addBullets", InventoryAPI.addBullets)


---sub bullets from player
---@param weaponId number
---@param bulletType string
---@param amount number
---@param cb fun(success: boolean)? async or sync callback
---@return boolean
function InventoryAPI.subBullets(weaponId, bulletType, amount, cb)
	local _source = source
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local userWeapons = UsersWeapons.default[weaponId]

	if userWeapons then
		if userWeapons:getPropietary() == identifier then
			userWeapons:subAmmo(bulletType, amount)
			TriggerClientEvent("vorpCoreClient:subBullets", _source, bulletType, amount)
			return respond(cb, true)
		end
	end
	return respond(cb, false)
end

exports("subBullets", InventoryAPI.subBullets)


--- Get item count from player inventory
---@param player number source
---@param cb fun(count: number | nil)? async or sync callback
---@param itemName string item name
---@param metadata table? metadata
---@return number | nil
function InventoryAPI.getItemCount(player, cb, itemName, metadata)
	local _source = player
	local svItem = ServerItems[itemName]

	if not _source then
		Log.error("InventoryAPI.getItemCount: specify a source")
		return respond(cb, nil)
	end

	if not SvUtils.DoesItemExist(itemName, "getItemCount") then
		return respond(cb, nil)
	end

	local identifier = Core.getUser(_source).getUsedCharacter.identifier
	metadata = SharedUtils.MergeTables(svItem.metadata, metadata or {})

	local userInventory = UsersInventories.default[identifier]
	if not userInventory then
		Log.error("InventoryAPI.getItemCount: User doesn't have inventory")
		return respond(cb, nil)
	end

	local item = SvUtils.FindItemByNameAndMetadata("default", identifier, itemName, metadata)
		or SvUtils.FindItemByNameAndMetadata("default", identifier, itemName, nil)

	local count = item and item:getCount() or 0

	return respond(cb, count)
end

exports("getItemCount", InventoryAPI.getItemCount)

--- get item data from DB
---@param itemName string item name
---@param cb fun(item: table | nil)? async or sync callback
---@return table | nil
function InventoryAPI.getItemDB(itemName, cb)
	local svItem = ServerItems[itemName]
	if not svItem then
		return respond(cb, nil)
	end
	return respond(cb, svItem)
end

exports("getItemDB", InventoryAPI.getItemDB)


---get item data by item name
---@param player number source
---@param itemName string item name
---@param cb fun(item: table | nil)?
---@return table | nil
function InventoryAPI.getItemByName(player, itemName, cb)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier

	if not SvUtils.DoesItemExist(itemName, "getItemByName") then
		return respond(cb, nil)
	end

	local item = SvUtils.FindItemByNameAndMetadata("default", identifier, itemName, nil)

	if not item then
		return respond(cb, nil)
	end

	return respond(cb, item)
end

exports("getItemByName", InventoryAPI.getItemByName)

---get item data by item name and its metadata
---@param player number source
---@param itemName string item name
---@param metadata table metadata
---@param cb fun(item: table | nil)? async or sync callback
---@return table | nil
function InventoryAPI.getItemContainingMetadata(player, itemName, metadata, cb)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier

	if not SvUtils.DoesItemExist(itemName, "getItemContainingMetadata") then
		return respond(cb, nil)
	end

	local item = SvUtils.FindItemByNameAndContainingMetadata("default", identifier, itemName, metadata)

	if not item then
		return respond(cb, nil)
	end

	return respond(cb, item)
end

exports("getItemContainingMetadata", InventoryAPI.getItemContainingMetadata)

--- get item matching metadata
---@param player number source
---@param itemName string item name
---@param metadata table metadata
---@param cb fun(item: table | nil)? async or sync callback
function InventoryAPI.getItemMatchingMetadata(player, itemName, metadata, cb)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local svItem = ServerItems[itemName]

	if not SvUtils.DoesItemExist(itemName, "getItemContainingMetadata") then
		return respond(cb, nil)
	end

	metadata = SharedUtils.MergeTables(svItem.metadata or {}, metadata or {})
	local item = SvUtils.FindItemByNameAndMetadata("default", identifier, itemName, metadata)

	if not item then
		return respond(cb, nil)
	end

	return respond(cb, item)
end

exports("getItemMatchingMetadata", InventoryAPI.getItemMatchingMetadata)

---add item to player
---@param player number source
---@param name string item name
---@param amount number
---@param metadata table metadata
---@param cb fun(success: boolean)? async or sync callback
function InventoryAPI.addItem(player, name, amount, metadata, cb)
	local _source = player
	local svItem = ServerItems[name]

	if not _source then
		return Log.error("InventoryAPI.addItem: specify a source")
	end

	if not SvUtils.DoesItemExist(name, "addItem") then
		return respond(cb, false)
	end

	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charIdentifier = sourceCharacter.charIdentifier
	local userInventory = UsersInventories.default[identifier]

	if userInventory == nil then
		UsersInventories.default[identifier] = {}
		userInventory = UsersInventories.default[identifier]
	end

	if not userInventory or amount <= 0 then
		return respond(cb, false)
	end

	metadata = SharedUtils.MergeTables(svItem.metadata, metadata or {})
	local item = SvUtils.FindItemByNameAndMetadata("default", identifier, name, metadata)
	if item then -- Item already exist in inventory
		item:addCount(amount)
		DBService.SetItemAmount(charIdentifier, item:getId(), item:getCount())
		TriggerClientEvent("vorpCoreClient:addItem", _source, item)
		return respond(cb, true)
	else
		DBService.CreateItem(charIdentifier, svItem:getId(), amount, metadata, function(craftedItem)
			item = Item:New({
				id = craftedItem.id,
				count = amount,
				limit = svItem:getLimit(),
				label = svItem:getLabel(),
				metadata = SharedUtils.MergeTables(svItem:getMetadata(), metadata),
				name = name,
				type = svItem:getType(),
				canUse = true,
				canRemove = svItem:getCanRemove(),
				owner = charIdentifier,
				desc = svItem:getDesc(),
				group = svItem:getGroup() or 1
			})
			userInventory[craftedItem.id] = item
			TriggerClientEvent("vorpCoreClient:addItem", _source, item)
		end)
		return respond(cb, true)
	end
end

exports("addItem", InventoryAPI.addItem)

--- get item by its main id
---@param player number source
---@param mainid number item id
---@param cb fun(item: table | nil)? async or sync callback
---@return table | nil
function InventoryAPI.getItemByMainId(player, mainid, cb)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local userInventory = UsersInventories.default[identifier]

	if userInventory then
		local itemRequested = {}
		for _, item in pairs(userInventory) do
			if mainid == item:getId() then
				itemRequested = {
					id = item:getId(),
					label = item:getLabel(),
					name = item:getName(),
					metadata = item:getMetadata(),
					type = item:getType(),
					count = item:getCount(),
					limit = item:getLimit(),
					canUse = item:getCanUse(),
					group = item:getGroup(),
				}
				return respond(cb, itemRequested)
			end
		end
	end

	return respond(cb, nil)
end

exports("getItemByMainId", InventoryAPI.getItemByMainId)

--- sub item by its id
---@param player number source
---@param id number item id
---@param cb fun(success: boolean)? async or sync callback
---@return fun(success: boolean)
function InventoryAPI.subItemID(player, id, cb)
	local _source = player
	local sourceUser = Core.getUser(_source)
	local sourceCharacter = sourceUser.getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charIdentifier = sourceCharacter.charIdentifier
	local userInventory = UsersInventories.default[identifier]
	local item = userInventory[id]
	local itemid = item:getId()
	local itemCount = item:getCount()

	if not userInventory or not item or not item:getCount() then
		return respond(cb, false)
	end
	item:quitCount(1)

	TriggerClientEvent("vorpCoreClient:subItem", _source, itemid, item:getCount())

	if itemCount == 1 then
		userInventory[itemid] = nil
		DBService.DeleteItem(charIdentifier, itemid)
	else
		DBService.SetItemAmount(charIdentifier, itemid, item:getCount())
	end
	return respond(cb, true)
end

exports("subItemID", InventoryAPI.subItemID)


---sub item by name
---@param player number source
---@param name string item name
---@param amount number amount to sub
---@param metadata table metadata
---@param cb fun(success: boolean)? async or sync callback
---@return boolean
function InventoryAPI.subItem(player, name, amount, metadata, cb)
	local _source = player
	local sourceUser = Core.getUser(_source)
	local svItem = ServerItems[name]


	if not SvUtils.DoesItemExist(name, "subItem") then
		return respond(cb, false)
	end

	local sourceCharacter = sourceUser.getUsedCharacter
	local identifier = sourceCharacter.identifier

	metadata = SharedUtils.MergeTables(svItem.metadata, metadata or {})


	local item = SvUtils.FindItemByNameAndMetadata("default", identifier, name, metadata)
		or SvUtils.FindItemByName("default", identifier, name)

	if not item then
		return respond(cb, false)
	end

	local sourceItemCount = item:getCount()


	if amount > sourceItemCount then
		return respond(cb, false)
	end

	item:quitCount(amount)
	TriggerClientEvent("vorpCoreClient:subItem", _source, item:getId(), item:getCount())


	if item:getCount() == 0 then
		UsersInventories.default[identifier][item:getId()] = nil
		DBService.DeleteItem(sourceCharacter.charIdentifier, item:getId())
	else
		DBService.SetItemAmount(sourceCharacter.charIdentifier, item:getId(), item:getCount())
	end

	return respond(cb, true)
end

exports("subItem", InventoryAPI.subItem)

---set item metadata with item id
---@param player number source
---@param itemId number item id
---@param metadata table metadata
---@param amount number amount
---@param cb fun(success: boolean)? async or sync callback
---@return boolean
function InventoryAPI.setItemMetadata(player, itemId, metadata, amount, cb)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charId = sourceCharacter.charIdentifier
	local userInventory = UsersInventories.default[identifier]
	local amountRemove = amount or 1

	if not userInventory then
		return respond(cb, false)
	end

	local item = userInventory[itemId]

	if not item then
		return respond(cb, false)
	end

	local count = item:getCount()

	if amountRemove >= count then -- if greater or equals we set meta data
		DBService.SetItemMetadata(charId, item.id, metadata)
		item:setMetadata(metadata)
		TriggerClientEvent("vorpCoreClient:SetItemMetadata", _source, itemId, metadata)
	else
		item:quitCount(amountRemove)
		DBService.SetItemAmount(charId, item.id, item:getCount())
		TriggerClientEvent("vorpCoreClient:subItem", _source, item:getId(), item:getCount())
		DBService.CreateItem(charId, item:getId(), amount or 1, metadata, function(craftedItem)
			item = Item:New(
				{
					id = craftedItem.id,
					count = amount or 1,
					limit = item:getLimit(),
					label = item:getLabel(),
					metadata = SharedUtils.MergeTables(item:getMetadata(), metadata),
					name = item:getName(),
					type = item:getType(),
					canUse = true,
					canRemove = item:getCanRemove(),
					owner = charId,
					desc = item:getDesc(),
					group = item:getGroup(),
				})
			userInventory[craftedItem.id] = item
			TriggerClientEvent("vorpCoreClient:addItem", _source, item)
		end)
	end

	return respond(cb, true)
end

exports("setItemMetadata", InventoryAPI.setItemMetadata)



--- can carry ammount of weapons
---@param player number source
---@param amount number amount to check
---@param weaponName string |nil weapon name not neccesary but allows to check if weapon is in the list of not weapons
---@param cb fun(success: boolean)| nil   async or sync callback
---@return boolean
function InventoryAPI.canCarryAmountWeapons(player, amount, cb, weaponName)
	local _source = player
	-- if weapon name is function then its a cb and weapon name is nil
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charId = sourceCharacter.charIdentifier
	local job = sourceCharacter.job
	local DefaultAmount = Config.MaxItemsInInventory.Weapons

	if weaponName then
		-- if weapon is in the list of not weapons then return true
		if SharedUtils.IsValueInArray(weaponName:upper(), Config.notweapons) then
			return respond(cb, true)
		end
	end

	if Config.JobsAllowed[job] then
		DefaultAmount = Config.JobsAllowed[job]
	end

	if DefaultAmount ~= -1 then
		local sourceInventoryWeaponCount = InventoryAPI.getUserTotalCountWeapons(identifier, charId) + amount
		if sourceInventoryWeaponCount > DefaultAmount then
			return respond(cb, false)
		end
	end

	return respond(cb, true)
end

exports("canCarryWeapons", InventoryAPI.canCarryAmountWeapons)

---get item data
---@param player number source
---@param itemName string item name
---@param cb fun(success: boolean)| nil  async or sync callback
---@param metadata table | nil? metadata
---@return  table | nil
function InventoryAPI.getItem(player, itemName, cb, metadata)
	local _source = player
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local svItem = ServerItems[itemName]

	if not SvUtils.DoesItemExist(itemName, "getItem") then
		return respond(cb, nil)
	end

	metadata = SharedUtils.MergeTables(svItem.metadata or {}, metadata or {})
	local item = SvUtils.FindItemByNameAndMetadata("default", identifier, itemName, metadata) or
		SvUtils.FindItemByNameAndMetadata("default", identifier, itemName, nil)

	if not item then
		return respond(cb, nil)
	end

	return respond(cb, item)
end

exports("getItem", InventoryAPI.getItem)

--- get weapon components
---@param player number source
---@param weaponid number weapon id
---@param cb fun(comps: table)? async or sync callback
---@return table | nil
function InventoryAPI.getcomps(player, weaponid, cb)
	local _source = player
	local query = 'SELECT comps FROM loadout WHERE id = @id '
	local parameters = { id = weaponid }
	DBService.queryAsync(query, parameters, function(result)
		if result[1] then
			return respond(cb, json.decode(result[1].comps))
		end
		return respond(cb, nil)
	end)
end

exports("getWeaponComponents", InventoryAPI.getcomps)

---delete weapon from player using id
---@param player number source
---@param weaponid number weapon id
---@param cb fun(success: boolean)? async or sync callback
---@return nil | boolean
function InventoryAPI.deleteWeapon(player, weaponid, cb)
	local _source = player
	local userWeapons = UsersWeapons.default
	userWeapons[weaponid]:setPropietary('')
	local query = 'DELETE FROM loadout WHERE id = @id'
	local params = { id = weaponid }
	DBService.deleteAsync(query, params, function(r) end)
	return respond(cb, true)
end

exports("deleteWeapon", InventoryAPI.deleteWeapon)

--- registr weapon to player
---@param _target number source
---@param wepname string weapon name
---@param ammos table ammos
---@param components table components table
---@param comps table weapon components
---@param cb fun(success: boolean)? async or sync callback
---@return nil | boolean
function InventoryAPI.registerWeapon(_target, wepname, ammos, components, comps, cb)
	local targetUser = Core.getUser(_target)
	local targetCharacter = targetUser.getUsedCharacter
	local targetIdentifier = targetCharacter.identifier
	local targetCharId = targetCharacter.charIdentifier
	local job = targetCharacter.job
	local name = wepname:upper()
	local ammo = {}
	local component = {}
	local DefaultAmount = Config.MaxItemsInInventory.Weapons
	local canGive = false
	local notListed = false

	if not comps then
		comps = {}
	end

	-- does weapon exist
	for _, weapons in pairs(SharedData.Weapons) do
		if weapons.HashName == name then
			canGive = true
			break
		end
	end

	if Config.JobsAllowed[job] then
		DefaultAmount = Config.JobsAllowed[job]
	end

	if DefaultAmount ~= 0 then
		if name then
			-- does weapon given matches the list of weapons that do not count as weapons
			if SharedUtils.IsValueInArray(name, Config.notweapons) then
				notListed = true
			end
		end

		if not notListed then
			local targetTotalWeaponCount = InventoryAPI.getUserTotalCountWeapons(targetIdentifier, targetCharId) + 1
			if targetTotalWeaponCount > DefaultAmount then
				TriggerClientEvent("vorp:TipRight", _target, T.cantweapons2, 2000)
				if Config.Debug then
					Log.Warning(targetCharacter.firstname ..
						" " .. targetCharacter.lastname .. " ^1Can't carry more weapons^7")
				end
				return respond(cb, nil)
			end
		end
	end

	if ammos then
		for key, value in pairs(ammos) do
			ammo[key] = value
		end
	end

	-- components are not being used? comps table is and yet is by default to empty table ?
	if components then
		for key, _ in pairs(components) do
			component[#component + 1] = key
		end
	end

	if canGive then
		local query =
		'INSERT INTO loadout (identifier, charidentifier, name, ammo, components,comps) VALUES (@identifier, @charid, @name, @ammo, @components,@comps)'
		local params = {
			identifier = targetIdentifier,
			charid = targetCharId,
			name = name,
			ammo = json.encode(ammo),
			components = json.encode(component),
			comps = json.encode(comps),
		}
		DBService.insertAsync(query, params, function(result)
			local weaponId = result
			local newWeapon = Weapon:New({
				id = weaponId,
				propietary = targetIdentifier,
				name = name,
				ammo = ammo,
				used = false,
				used2 = false,
				charId = targetCharId,
				currInv = "default",
				dropped = 0,
				source = _target,
			})
			UsersWeapons.default[weaponId] = newWeapon
			TriggerEvent("syn_weapons:registerWeapon", weaponId)
			TriggerClientEvent("vorpInventory:receiveWeapon", _target, weaponId, targetIdentifier, name, ammo)
		end)

		return respond(cb, true)
	end

	Log.Warning("Weapon: [^2" .. name .. "^7] ^1 do not exist on the config or its a WRONG HASH")
	return respond(cb, nil)
end

exports("createWeapon", InventoryAPI.registerWeapon)


---give weapon to target
---@param player number source
---@param weaponId number weapon id
---@param target number target id
---@param cb fun(success: boolean)? async or sync callback
---@return  boolean
function InventoryAPI.giveWeapon(player, weaponId, target, cb)
	local _source = player
	if not Core.getUser(_source) then
		return respond(cb, false)
	end
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local sourceIdentifier = sourceCharacter.identifier
	local sourceCharId = sourceCharacter.charIdentifier
	local job = sourceCharacter.job
	local _target = target
	local userWeapons = UsersWeapons.default
	local DefaultAmount = Config.MaxItemsInInventory.Weapons
	local weapon = userWeapons[weaponId]
	local weaponName = weapon:getName()
	local notListed = false


	if Config.JobsAllowed[job] then
		DefaultAmount = Config.JobsAllowed[job]
	end

	if DefaultAmount ~= 0 then
		if weaponName then
			-- does weapon given matches the list of weapons that do not count as weapons
			if SharedUtils.IsValueInArray(weaponName:upper(), Config.notweapons) then
				notListed = true
			end
		end

		if not notListed then
			local sourceTotalWeaponCount = InventoryAPI.getUserTotalCountWeapons(sourceIdentifier, sourceCharId) + 1

			if sourceTotalWeaponCount > DefaultAmount then
				TriggerClientEvent("vorp:TipRight", _source, T.cantweapons, 2000)
				if Config.Debug then
					Log.print(sourceCharacter.firstname ..
						" " .. sourceCharacter.lastname .. " ^1Can't carry more weapons^7")
				end
				return respond(cb, false)
			end
		end
	end

	if weapon then
		weapon:setPropietary(sourceIdentifier)
		weapon:setCharId(sourceCharId)
		weapon:setSource(_target)
		local weaponPropietary = weapon:getPropietary()
		local weaponAmmo = weapon:getAllAmmo()
		local query = "UPDATE loadout SET identifier = @identifier, charidentifier = @charid WHERE id = @id"
		local params = {
			identifier = sourceIdentifier,
			charid = sourceCharId,
			id = weaponId
		}

		DBService.updateAsync(query, params, function(r)
			if not _target then
				TriggerClientEvent('vorp:ShowAdvancedRightNotification', _target, T.youGaveWeapon, "inventory_items",
					weaponName, "COLOR_PURE_WHITE", 4000)
				TriggerClientEvent("vorpCoreClient:subWeapon", _target, weaponId)
			end
			TriggerClientEvent('vorp:ShowAdvancedRightNotification', _source, T.youReceivedWeapon, "inventory_items",
				weaponName, "COLOR_PURE_WHITE", 4000)

			TriggerClientEvent("vorpInventory:receiveWeapon", _source, weaponId, weaponPropietary, weaponName, weaponAmmo)
		end)
	end
	return respond(cb, true)
end

exports("giveWeapon", InventoryAPI.giveWeapon)

--- sub weapon wont delete weapon it will set the propietary to empty
---@param player number source
---@param weaponId number weapon id
---@param cb fun(success: boolean)? async or sync callback
---@return  boolean
function InventoryAPI.subWeapon(player, weaponId, cb)
	local _source = player
	local User = Core.getUser(_source)
	local charId = User.getUsedCharacter.charIdentifier
	local userWeapons = UsersWeapons.default[weaponId]

	if userWeapons then
		userWeapons:setPropietary('')
		local query = "UPDATE loadout SET identifier = @identifier, charidentifier = @charid WHERE id = @id"
		local params = {
			identifier = '',
			charid = charId,
			id = weaponId
		}
		DBService.updateAsync(query, params, function(r)
			TriggerClientEvent("vorpCoreClient:subWeapon", _source, weaponId)
		end)
		TriggerClientEvent("vorpCoreClient:subWeapon", _source, weaponId)
		return respond(cb, true)
	end
	return respond(cb, false)
end

exports("subWeapon", InventoryAPI.subWeapon)


---get User by identifier total count of items
---@param identifier string user identifier
---@param charid number user charid
---@return integer
function InventoryAPI.getUserTotalCountItems(identifier, charid)
	local userTotalItemCount = 0
	local userInventory = UsersInventories.default[identifier]
	for _, item in pairs(userInventory) do
		if item:getCount() == nil then
			userInventory[item:getId()] = nil
			DBService.DeleteItem(charid, item:getId())
		else
			userTotalItemCount = userTotalItemCount + item:getCount()
		end
	end
	return userTotalItemCount
end

---get User by identifier total count of weapons
---@param identifier string user identifier
---@param charId number user charid
---@return integer
function InventoryAPI.getUserTotalCountWeapons(identifier, charId)
	local userTotalWeaponCount = 0
	for _, weapon in pairs(UsersWeapons.default) do
		local owner_identifier = weapon:getPropietary()
		local owner_charid = weapon:getCharId()

		if owner_identifier == identifier and owner_charid == charId then
			local weaponName = weapon:getName()
			if not SharedUtils.IsValueInArray(weaponName:upper(), Config.notweapons) then
				userTotalWeaponCount = userTotalWeaponCount + 1
			end
		end
	end
	return userTotalWeaponCount
end

--- Register custom inventory
---@param data table inventory data
function InventoryAPI.registerInventory(data)
	if CustomInventoryInfos[data.id] then
		return
	end

	local newInventory = CustomInventoryAPI:New(data)
	newInventory:Register()

	if Config.Debug then
		Log.print("Custom inventory[^3" .. id .. "^7] ^2Registered!^7")
	end
end

exports("registerInventory", InventoryAPI.registerInventory)

local function canContinue(id)
	if not CustomInventoryInfos[id] then
		return false
	end

	if not CustomInventoryInfos[id]:isPermEnabled() then
		return false
	end

	if not jobName and not grade then
		return false
	end
end
--- add permissions to move items to custom inventory
---@param id string inventory id
---@param jobName string job name
---@param grade number job grade
function InventoryAPI.AddPermissionMoveToCustom(id, jobName, grade)
	if not canContinue(id) then
		return
	end

	local data = {
		name = jobName,
		grade = grade
	}
	CustomInventoryInfos[id]:AddPermissionMoveTo(data)

	if Config.Debug then
		Log.print("AdPermsMoveTo  for [^3" .. jobName .. "^7] and grade [^3" .. grade .. "^7]")
	end
end

exports("AddPermissionMoveToCustom", InventoryAPI.AddPermissionMoveToCustom)

--- * add permissions to take items from custom inventory
---@param id string inventory id
---@param jobName string job name
---@param grade number job grade
function InventoryAPI.AddPermissionTakeFromCustom(id, jobName, grade)
	if not canContinue(id) then
		return
	end

	local data = {
		name = jobName,
		grade = grade
	}

	CustomInventoryInfos[id]:AddPermissionTakeFrom(data)

	if Config.Debug then
		Log.print("AdPermsTakeFrom  for [^3" .. jobName .. "^7] and grade [^3" .. grade .. "^7]")
	end
end

exports("AddPermissionTakeFromCustom", InventoryAPI.AddPermissionTakeFromCustom)

--- Black list weapons or items
---@param id string inventory id
---@param name string item or weapon name
function InventoryAPI.BlackListCustom(id, name)
	if not CustomInventoryInfos[id] then
		return
	end
	local data = {
		name = name
	}
	CustomInventoryInfos[id]:BlackList(data)

	if Config.Debug then
		Log.print("Blacklisted [^3" .. name .. "^7]")
	end
end

exports("BlackListCustomAny", InventoryAPI.BlackListCustom)

---Remove inventory by id from server
---@param id string inventory id
function InventoryAPI.removeInventory(id)
	if CustomInventoryInfos[id] == nil then
		return
	end
	CustomInventoryInfos[id]:removeCustomInventory()

	if Config.Debug then
		Log.print("Custom inventory[^3" .. id .. "^7] ^2Removed!^7")
	end
end

exports("removeInventory", InventoryAPI.removeInventory)

---update custom inventory slots
---@param id string inventory id
---@param slots number inventory slots
function InventoryAPI.updateCustomInventorySlots(id, slots)
	if not CustomInventoryInfos[id] or not slots then
		return
	end

	CustomInventoryInfos[id]:setCustomInventoryLimit(slots)

	if Config.Debug then
		Log.print("Custom inventory[^3" .. id .. "^7] set slots to ^2" .. slots .. "^7")
	end
end

exports("updateCustomInventorySlots", InventoryAPI.updateCustomInventorySlots)

---set custom inventory item limit
---@param id string inventory id
---@param itemName string item name
---@param limit number item limit
function InventoryAPI.setCustomInventoryItemLimit(id, itemName, limit)
	if CustomInventoryInfos[id] then
		return
	end

	if not itemName and not limit then
		return
	end

	local data = {
		name = itemName:lower(),
		limit = limit
	}
	CustomInventoryInfos[id]:setCustomItemLimit(data)
	if Config.Debug then
		Log.print("Custom inventory[^3" .. id .. "^7] set item[^3" .. itemName .. "^7] limit to ^2" .. limit .. "^7")
	end
end

exports("setCustomInventoryItemLimit", InventoryAPI.setCustomInventoryItemLimit)

--- set custom inventory weapon limit
---@param id string inventory id
---@param wepName string
---@param limit number
function InventoryAPI.setCustomInventoryWeaponLimit(id, wepName, limit)
	if not CustomInventoryInfos[id] then
		return
	end

	if not wepName and not limit then
		return
	end

	local data = {
		name = wepName:lower(),
		limit = limit
	}

	CustomInventoryInfos[id]:setCustomWeaponLimit(data)

	if Config.Debug then
		Log.print("Custom inventory[^3" .. id .. "^7] set item[^3" .. wepName .. "^7] limit to ^2" .. limit .. "^7")
	end
end

exports("setCustomInventoryWeaponLimit", InventoryAPI.setCustomInventoryWeaponLimit)

--- open inventory
---@param player number player
---@param id string? inventory id
function InventoryAPI.openInventory(player, id)
	if not id then
		return TriggerClientEvent("vorp_inventory:OpenInv", source)
	end

	local _source = player
	if not CustomInventoryInfos[id] or not UsersInventories[id] then
		return
	end

	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local capacity = CustomInventoryInfos[id]:getLimit() > 0 and tostring(CustomInventoryInfos[id]:getLimit()) or 'oo'

	local function createCharacterInventoryFromDB(inventory, owner)
		local characterInventory = {}
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
					owner = owner or item.character_id,
					desc = dbItem.desc,
					group = dbItem.group or 1,
				})
			end
		end
		return characterInventory
	end

	local function triggerAndReloadInventory()
		TriggerClientEvent("vorp_inventory:OpenCustomInv", _source, CustomInventoryInfos[id]:getName(), id, capacity)
		InventoryService.reloadInventory(_source, id)
	end

	if CustomInventoryInfos[id]:isShared() then
		if UsersInventories[id] and #UsersInventories[id] > 0 then
			triggerAndReloadInventory()
		else
			DBService.GetSharedInventory(id, function(inventory)
				UsersInventories[id] = createCharacterInventoryFromDB(inventory)
				triggerAndReloadInventory()
			end)
		end
	else
		if UsersInventories[id][identifier] then
			triggerAndReloadInventory()
		else
			DBService.GetInventory(identifier, id, function(inventory)
				UsersInventories[id][identifier] = createCharacterInventoryFromDB(inventory, identifier)
				triggerAndReloadInventory()
			end)
		end
	end
end

exports("openInventory", InventoryAPI.openInventory)

---close  inventory
---@param source number
---@param id string
function InventoryAPI.closeInventory(source, id)
	local _source = source
	if id and CustomInventoryInfos[id] then
		return TriggerClientEvent("vorp_inventory:CloseCustomInv", _source)
	end

	TriggerClientEvent("vorp_inventory:CloseInv", source)
end

exports("closeInventory", InventoryAPI.closeInventory)
