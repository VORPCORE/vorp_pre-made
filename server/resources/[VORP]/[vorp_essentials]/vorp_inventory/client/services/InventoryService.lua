---@diagnostic disable: undefined-global
---@class ClientItems @ InventoryService
---@class Weapon @Weapon
---@class Item @Item
---@field PullAllInventory fun():table
---@field receiveItem fun(name:string, id:string, amount:number, metadata:table)
---@field removeItem fun(name:string, id:string, count:number)
---@field receiveWeapon fun(id:string, propietary:string, name:string, ammos:table)
---@field onSelectedCharacter fun(charId:string)
---@field processItems fun(items:table)
---@field getLoadout fun(loadout:table)
---@field getWeapons fun():table
---@field getInventory fun(table:table)
---@field ClientItems table<string,Item>
---@field UserWeapons table<string,Weapon>
---@field UserInventory table<number,Item>
ClientItems = {}
InventoryService = {}
UserWeapons = {}
UserInventory = {}
local T = TranslationInv.Langs[Lang]

function InventoryService.PullAllInventory()
	return UserInventory
end

function InventoryService.getWeapons()
	return UserWeapons
end

function InventoryService.receiveItem(name, id, amount, metadata)
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
	if UserInventory[id] == nil then
		return
	end

	local item = UserInventory[id]

	if item ~= nil then
		item:quitCount(count)

		if item:getCount() <= 0 then
			UserInventory[id] = nil
		end

		NUIService.LoadInv()
	end
end

function InventoryService.receiveWeapon(id, propietary, name, ammos, label, serial_number, custom_label, source,
										custom_desc, weight)
	local weaponAmmo = {}
	local desc = ""
	for type, amount in pairs(ammos) do
		weaponAmmo[type] = tonumber(amount)
	end

	if custom_desc then
		local serial_number_str = "<br><br>" .. T.serialnumber .. serial_number
		if not string.find(custom_desc, serial_number_str, 1, true) and serial_number ~= "" then
			custom_desc = custom_desc .. serial_number_str
		end
	end
	if serial_number ~= "" then
		desc = custom_desc or Utils.GetWeaponDefaultDesc(name) .. "<br><br>" .. T.serialnumber .. serial_number
	else
		desc = custom_desc or Utils.GetWeaponDefaultDesc(name)
	end
	if UserWeapons[id] == nil then
		local newWeapon = Weapon:New({
			id = id,
			propietary = propietary,
			name = name,
			label = custom_label or label,
			ammo = weaponAmmo,
			used = false,
			used2 = false,
			desc = desc,
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
			local serialNumber = ""
			if Utils.filterWeaponsSerialNumber(weapon.name:upper()) and weapon.serial_number then
				serialNumber = "<br><br>" .. T.serialnumber .. weapon.serial_number
			end

			local custom_desc = nil
			if weapon.custom_desc then
				custom_desc = weapon.custom_desc .. serialNumber
			end

			local label = weapon.custom_label or Utils.GetWeaponDefaultLabel(weapon.name)
			local newWeapon = Weapon:New({
				id = tonumber(weapon.id),
				identifier = weapon.identifier,
				label = label,
				name = weapon.name,
				ammo = weaponAmmo,
				components = weapon.components,
				used = weaponUsed,
				used2 = weaponUsed2,
				desc = custom_desc or Utils.GetWeaponDefaultDesc(weapon.name) .. serialNumber,
				currInv = weapon.curr_inv,
				dropped = 0,
				group = 5,
				custom_label = weapon.custom_label,
				serial_number = weapon.serial_number,
				custom_desc = custom_desc,
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

		for _, item in pairs(inventoryItems) do
			if ClientItems[item.item] then
				local dbItem = ClientItems[item.item]

				local newItem = Item:New({
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

				UserInventory[item.id] = newItem
			end
		end
	end
end
