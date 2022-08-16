---@type table<string, Item>
svItems = {}
InventoryService = {}
UserWeapons = {}
---@class UserInventory: table<string, Item>
UserInventory = {}
bulletsHash = {}


InventoryService.PullAllInventory = function ()
    return UserInventory
end


InventoryService.receiveItem = function (name, id, amount, metadata)
	if UserInventory[id] ~= nil then
		UserInventory[id]:addCount(amount)
	else
		UserInventory[id] = Item:New({
			id = id,
			count = amount,
			limit = svItems[name].limit,
			label = svItems[name].label,
			name = name,
			metadata = SharedUtils.MergeTables(svItems[name].metadata, metadata),
			type = "item_standard",
			canUse = true,
			canRemove = svItems[name].canRemove
		})
	end

	NUIService.LoadInv()
end

InventoryService.removeItem = function (name, id, count)
	if UserInventory[id] == nil then
		return
	end

	local item = UserInventory[id]

	if item ~= nil then
		print("[^2removeItem^7] ^1Debug^7: Going to call Item:quitCount with amount = ^3" .. tonumber(count) .. "^7.")
		item:quitCount(count)

		if item:getCount() <= 0 then
			UserInventory[id] = nil
		end

		NUIService.LoadInv()
	end
end

InventoryService.receiveWeapon = function (id, propietary, name, ammos)
	local weaponAmmo = {}

	for type, amount in pairs(ammos) do
		weaponAmmo[type] = tonumber(amount)
	end


	if UserWeapons[id] == nil then
		local newWeapon = Weapon:New({
			id = id,
			propietary = propietary,
			name = name,
			label = Utils.GetWeaponLabel(name),
			ammo = weaponAmmo,
			used = false,
			used2 = false,
			desc = Utils.GetWeaponDesc(name)
		})

		UserWeapons[newWeapon:getId()] = newWeapon
		NUIService.LoadInv()
	end

end

InventoryService.onSelectedCharacter = function (charId)
	SetNuiFocus(false, false)
	SendNUIMessage({action= "hide"})
	print("Loading Inventory")
	TriggerServerEvent("vorpinventory:getItemsTable")
	Wait(300)
	TriggerServerEvent("vorpinventory:getInventory")
	Wait(5000)
	TriggerServerEvent("vorpCore:LoadAllAmmo")
	Wait(2500)
	print("ammo loaded")
	TriggerEvent("vorpinventory:loaded")
end

InventoryService.processItems = function (items)
	svItems = {}
	for _, item in pairs(items) do
		svItems[item.item] = Item:New(item)
	end
end

InventoryService.getLoadout = function (loadout)
	for _, weapon in pairs(loadout) do

		local weaponAmmo = weapon.ammo

		for type, amount in pairs(weaponAmmo) do
			weaponAmmo[type] = tonumber(amount)
		end

		local weaponUsed = false
		local weaponUsed2 = false

		if weapon.used == 1 then weaponUsed = true end
		if weapon.used2 == 1 then weaponUsed2 = true end

		if weapon.currInv == "default" and (weapon.dropped == nil or weapon.dropped == 0) then
			local newWeapon = Weapon:New({
				id = tonumber(weapon.id),
				identifier = weapon.identifier,
				label = Utils.GetWeaponLabel(weapon.name),
				name = weapon.name,
				ammo = weaponAmmo,
				components = weapon.components,
				used = weaponUsed,
				used2 = weaponUsed2,
				desc = Utils.GetWeaponDesc(weapon.name),
				currInv = weapon.curr_inv,
				dropped = 0,
			})
	
			UserWeapons[newWeapon:getId()] = newWeapon
	
			if newWeapon:getUsed() then
				Utils.useWeapon(newWeapon:getId())
			end
		end
	end
end

InventoryService.getInventory = function (inventory)
	if inventory ~= nil and inventory ~= '' then
		UserInventory = {}
		local inventoryItems = json.decode(inventory)

		for _, item in pairs(inventoryItems) do
			if svItems[item.item] ~= nil then
				local dbItem = svItems[item.item]
				local itemAmount = tonumber(item.amount)
				local itemLimit = tonumber(dbItem.limit)
				local itemCreatedAt = item.created_at
				local itemLabel = dbItem.label
				local itemCanRemove = dbItem.canRemove
				local itemType = dbItem.type
				local itemCanUse = dbItem.canUse
				local itemDefaultMetadata = dbItem.metadata

				local newItem = Item:New({
					id = item.id,
					count = itemAmount,
					limit = itemLimit,
					label = itemLabel,
					name = item.item,
					metadata = SharedUtils.MergeTables(itemDefaultMetadata, item.metadata),
					type = itemType,
					canUse = itemCanUse,
					canRemove = itemCanRemove,
				})

				UserInventory[item.id] = newItem
			end
		end
	end
end