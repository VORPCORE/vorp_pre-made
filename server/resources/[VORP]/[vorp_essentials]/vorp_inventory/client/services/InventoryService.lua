ClientItems = {}
InventoryService = {}
UserWeapons = {}
UserInventory = {}


function InventoryService.receiveItem(name, id, amount, metadata)
	if not name or not ClientItems[name] then return end

	if UserInventory[id] ~= nil then
		UserInventory[id]:addCount(amount)
	else
		UserInventory[id] = Item:New({
			id = id,
			count = amount,
			limit = ClientItems[name].limit,
			label = ClientItems[name].label,
			name = name,
			metadata = SharedUtils.MergeTables(ClientItems[name].metadata, metadata),
			type = "item_standard",
			canUse = true,
			canRemove = ClientItems[name].canRemove,
			desc = ClientItems[name].desc,
			group = ClientItems[name].group or 1,
			weight = ClientItems[name].weight or 0.25
		})
	end
	NUIService.LoadInv()
end

function InventoryService.removeItem(name, id, count)
	local item = UserInventory[id]
	if not item then return end

	item:quitCount(count)

	if item:getCount() <= 0 then
		UserInventory[id] = nil
	end

	NUIService.LoadInv()
end

function InventoryService.receiveWeapon(id, propietary, name, ammos, label, serial_number, custom_label, source, custom_desc, weight)
	local weaponAmmo = {}

	for type, amount in pairs(ammos) do
		weaponAmmo[type] = tonumber(amount)
	end

	if not UserWeapons[id] then
		local newWeapon = Weapon:New({
			id = id,
			propietary = propietary,
			name = name,
			label = custom_label or label,
			ammo = weaponAmmo,
			used = false,
			used2 = false,
			desc = custom_desc or Utils.GetWeaponDefaultDesc(name),
			group = 5,
			source = source,
			serial_number = serial_number,
			custom_label = custom_label,
			custom_desc = custom_desc,
			weight = weight,

		})
		UserWeapons[newWeapon:getId()] = newWeapon
		NUIService.LoadInv()
	end
end

function InventoryService.setWeaponCustomLabel(id, label)
	if UserWeapons[id] then
		UserWeapons[id]:setLabel(label)
	end
end

function InventoryService.setWeaponCustomDesc(id, desc)
	if UserWeapons[id] then
		UserWeapons[id]:setDesc(desc)
	end
end

function InventoryService.setWeaponSerialNumber(id, serial_number)
	if UserWeapons[id] then
		UserWeapons[id]:setSerialNumber(serial_number)
	end
end

function InventoryService.onSelectedCharacter()
	SetNuiFocus(false, false)
	SendNUIMessage({ action = "hide" })
	print("Loading Inventory")
	TriggerServerEvent("vorpinventory:getItemsTable")
	Wait(300)
	TriggerServerEvent("vorpinventory:getInventory")
	Wait(1000)
	TriggerServerEvent("vorpCore:LoadAllAmmo")
	Wait(1000)
	print("ammo loaded")
	TriggerEvent("vorpinventory:loaded")
end

function InventoryService.processItems(items)
	ClientItems = {}
	local data = msgpack.unpack(items)
	for _, item in pairs(data) do
		ClientItems[item.item] = Item:New(item)
	end
end

-- Load inventory weapons on client start
function InventoryService.getLoadout(loadout)
	for _, weapon in ipairs(loadout) do
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
				label = weapon.custom_label or Utils.GetWeaponDefaultLabel(weapon.name),
				name = weapon.name,
				ammo = weaponAmmo,
				components = weapon.components,
				used = weaponUsed,
				used2 = weaponUsed2,
				desc = weapon.custom_desc or Utils.GetWeaponDefaultDesc(weapon.name),
				currInv = weapon.curr_inv,
				dropped = 0,
				group = 5,
				custom_label = weapon.custom_label,
				serial_number = weapon.serial_number,
				custom_desc = weapon.custom_desc,
				weight = weapon.weight

			})
			UserWeapons[newWeapon:getId()] = newWeapon

			if newWeapon:getUsed() then
				Utils.useWeapon(newWeapon:getId())
			end
		end
	end
end

function InventoryService.getInventory(inventory)
	if inventory and inventory ~= '' then
		UserInventory = {}
		local inventoryItems = json.decode(inventory)

		for _, item in ipairs(inventoryItems) do
			local dbItem = ClientItems[item.item]
			if dbItem then
				UserInventory[item.id] = Item:New(
					{
						id = item.id,
						count = tonumber(item.amount),
						limit = tonumber(dbItem.limit),
						label = dbItem.label,
						name = item.item,
						metadata = SharedUtils.MergeTables(dbItem.metadata, item.metadata),
						type = dbItem.type,
						canUse = dbItem.canUse,
						canRemove = dbItem.canRemove,
						desc = dbItem.desc,
						group = dbItem.group or 1,
						weight = dbItem.weight or 0.25
					})
			end
		end
	end
end
