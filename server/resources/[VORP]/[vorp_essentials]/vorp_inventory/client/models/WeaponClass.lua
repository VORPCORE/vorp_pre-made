Weapon = {}
Weapon.name = nil
Weapon.label = nil
Weapon.id = nil
Weapon.propietary = nil
Weapon.ammo = {}
Weapon.components = {}
Weapon.used = false
Weapon.used2 = false
Weapon.desc = nil
Weapon.currInv = ''
Weapon.group = 5
Weapon.custom_label = nil
Weapon.serial_number = nil
Weapon.source = nil
Weapon.custom_desc = nil
Weapon.weight = nil

local equippedWeapons = {}

local function getGuidFromItemId(inventoryId, itemData, category, slotId)
	local outItem = DataView.ArrayBuffer(8 * 13)
	local success = Citizen.InvokeNative(0x886DFD3E185C8A89, inventoryId, itemData and itemData or 0, category, slotId,
		outItem:Buffer())
	return success and outItem or nil
end

local function moveInventoryItem(inventoryId, old, new, slot)
	local outGUID = DataView.ArrayBuffer(8 * 13)
	if not slot then slot = 1 end
	local sHash = "SLOTID_WEAPON_" .. tostring(slot)
	local success = Citizen.InvokeNative(0xDCCAA7C3BFD88862, inventoryId, old, new, joaat(sHash), 1,
		outGUID:Buffer())
	return success and outGUID or nil
end

local function addWeapon(weapon, slot, id)
	if slot == 0 and id then
		if #equippedWeapons > 0 then
			slot = 1
		end
	end
	local weaponHash  = joaat(weapon)
	local sHash       = "SLOTID_WEAPON_" .. tostring(slot)
	local reason      = joaat("ADD_REASON_DEFAULT")
	local inventoryId = 1
	local slotHash    = joaat(sHash)
	local move        = false
	local playerPedId = PlayerPedId()

	--Now add it to the characters inventory
	local isValid     = Citizen.InvokeNative(0x6D5D51B188333FD1, weaponHash, 0) --ItemdatabaseIsKeyValid
	if not isValid then
		print("Non valid weapon")
		return false
	end

	local characterItem = getGuidFromItemId(inventoryId, nil, joaat("CHARACTER"), 0xA1212100) --return func_1367(joaat("CHARACTER"), func_2485(), -1591664384, bParam0);
	if not characterItem then
		print("no characterItem")
		return false
	end

	local weaponItem = getGuidFromItemId(inventoryId, characterItem:Buffer(), 923904168, -740156546) --return func_1367(923904168, func_1889(1), -740156546, 0);
	if not weaponItem then
		print("no weaponItem")
		return false
	end

	if slot == 1 and id then
		if #equippedWeapons > 0 then
			--local newItemData = DataView.ArrayBuffer(8 * 13)
			local newGUID = moveInventoryItem(inventoryId, equippedWeapons[1].guid, weaponItem:Buffer())
			if not newGUID then
				print("can't move item")
				return false
			end
			slotHash = joaat('SLOTID_WEAPON_0')
			slot = 0
			move = true
		else
			slotHash = joaat('SLOTID_WEAPON_0')
			slot = 0
		end
	end

	local itemData = DataView.ArrayBuffer(8 * 13)
	local isAdded = Citizen.InvokeNative(0xCB5D11F9508A928D, inventoryId, itemData:Buffer(), weaponItem:Buffer(), weaponHash, slotHash, 1, reason) --Actually add the item now
	if not isAdded then
		print("Not added")
		return false
	end

	local equipped = Citizen.InvokeNative(0x734311E2852760D0, inventoryId, itemData:Buffer(), true)
	if not equipped then
		print("not able to equip")
		return false
	end

	Citizen.InvokeNative(0x12FB95FE3D579238, playerPedId, itemData:Buffer(), true, slot, false, false)
	if move then
		Citizen.InvokeNative(0x12FB95FE3D579238, playerPedId, equippedWeapons[1].guid, true, 1, false, false)
		TriggerServerEvent("syn_weapons:applyDupeTint", id, itemData:Buffer(), weaponHash)
	end
	if id then
		local nWeapon = {
			id = id,
			guid = itemData:Buffer(),
		}
		table.insert(equippedWeapons, nWeapon)
	end

	return true
end

function Weapon:UnequipWeapon()
	self:setUsed(false)
	self:setUsed2(false)
	TriggerServerEvent("vorpinventory:setUsedWeapon", self.id, self:getUsed(), self:getUsed2())
	self:RemoveWeaponFromPed()
	Utils.cleanAmmo(self.id)
end

function Weapon:RemoveWeaponFromPed()
	local isWeaponAGun = Citizen.InvokeNative(0x705BE297EEBDB95D, joaat(self.name))
	local isWeaponOneHanded = Citizen.InvokeNative(0xD955FEE4B87AFA07, joaat(self.name))
	local move = false
	local playerPedId = PlayerPedId()
	local inventoryId = 1

	if isWeaponAGun and isWeaponOneHanded then
		for k, v in pairs(equippedWeapons) do
			if v.id == self.id then
				if #equippedWeapons > 1 then
					Citizen.InvokeNative(0x3E4E811480B3AE79, 1, v.guid, 1, joaat("ADD_REASON_DEFAULT"))
					move = true
				end
				table.remove(equippedWeapons, k)
			end
		end
	end
	if move then
		local characterItem = getGuidFromItemId(1, nil, joaat("CHARACTER"), 0xA1212100)
		if not characterItem then
			return false
		end

		local weaponItem = getGuidFromItemId(1, characterItem:Buffer(), 923904168, -740156546)
		if not weaponItem then
			return false
		end
		moveInventoryItem(inventoryId, equippedWeapons[1].guid, weaponItem:Buffer(), 0)
		Citizen.InvokeNative(0x12FB95FE3D579238, playerPedId, equippedWeapons[1].guid, true, 0, false, false)
	else
		RemoveWeaponFromPed(playerPedId, joaat(self.name), true, 0)
	end
end

function Weapon:equipwep()
	local isWeaponMelee = Citizen.InvokeNative(0x959383DCD42040DA, joaat(self.name))
	local isWeaponThrowable = Citizen.InvokeNative(0x30E7C16B12DA8211, joaat(self.name))
	local isWeaponAGun = Citizen.InvokeNative(0x705BE297EEBDB95D, joaat(self.name))
	local isWeaponOneHanded = Citizen.InvokeNative(0xD955FEE4B87AFA07, joaat(self.name))
	local playerPedId = PlayerPedId()
	local ammoCount = 0
	-- is weapon assigned as no ammo needed then set to 1 so it can be used
	for k, v in pairs(Config.nonAmmoThrowables) do
		if tostring(v) == self.name then
			ammoCount = 1
		end
	end

	if isWeaponMelee or isWeaponThrowable then
		GiveDelayedWeaponToPed(playerPedId, joaat(self.name), ammoCount, true, 0)
	else
		if self.used2 then
			if isWeaponAGun and isWeaponOneHanded then
				addWeapon(self.name, 1, self.id)
			else
				local _, weaponHash = GetCurrentPedWeapon(playerPedId, false, 0, false)
				Citizen.InvokeNative(0x5E3BDDBCB83F3D84, playerPedId, weaponHash, 1, 1, 1, 2, false, 0.5, 1.0, 752097756, 0, true, 0.0)
				Citizen.InvokeNative(0x5E3BDDBCB83F3D84, playerPedId, joaat(self.name), 1, 1, 1, 3, false, 0.5, 1.0, 752097756, 0, true, 0.0)
				Citizen.InvokeNative(0xADF692B254977C0C, playerPedId, weaponHash, 0, 1, 0, 0)
				Citizen.InvokeNative(0xADF692B254977C0C, playerPedId, joaat(self.name), 0, 0, 0, 0)
			end
		else
			if isWeaponAGun and isWeaponOneHanded then
				addWeapon(self.name, 0, self.id)
			else
				GiveDelayedWeaponToPed(playerPedId, joaat(self.name), ammoCount, true, 0)
			end
		end
	end
end

function Weapon:loadComponents()
	local playerPedId = PlayerPedId()
	for _, value in pairs(self.components) do
		Citizen.InvokeNative(0x74C9090FDD1BB48E, playerPedId, joaat(value), joaat(self.name), true)
	end
end

function Weapon:getAllComponents()
	return self.components
end

function Weapon:setComponent(component)
	table.insert(self.components, component)
end

function Weapon:quitComponent(component)
	local componentExists = FindIndexOf(self.components, component)
	if componentExists then
		table.remove(self.component, componentExists)
		return true
	end
	return false
end

function Weapon:getUsed()
	return self.used
end

function Weapon:getUsed2()
	return self.used2
end

function Weapon:setUsed(used)
	self.used = used
	TriggerServerEvent("vorpinventory:setUsedWeapon", self.id, used, self.used2)
end

function Weapon:setUsed2(used2)
	self.used2 = used2
	TriggerServerEvent("vorpinventory:setUsedWeapon", self.id, self.used, used2)
end

function Weapon:getPropietary()
	return self.propietary
end

function Weapon:setPropietary(propietary)
	self.propietary = propietary
end

function Weapon:getId()
	return self.id
end

function Weapon:setId(id)
	self.id = id
end

function Weapon:getName()
	return self.name
end

function Weapon:setName(name)
	self.name = name
end

function Weapon:getAllAmmo()
	return self.ammo
end

function Weapon:getAmmo(type)
	if self.ammo[type] ~= nil then
		return self.ammo[type]
	end
	return 0
end

function Weapon:getTotalAmmoCount()
	local count = 0
	for type, value in pairs(self.ammo) do
		count = count + value
	end
	return count
end

function Weapon:setAmmo(type, amount) -- not being used?
	self.ammo[type] = tonumber(amount)
	TriggerServerEvent("vorpinventory:setWeaponBullets", self.id, type, amount)
end

function Weapon:addAmmo(type, amount) -- not being used?
	if self.ammo[type] ~= nil then
		self.ammo[type] = self.ammo[type] + tonumber(amount)
	else
		self.ammo[type] = tonumber(amount)
	end
end

function Weapon:subAmmo(type, amount)
	if self.ammo[type] ~= nil then
		self.ammo[type] = self.ammo[type] - tonumber(amount)

		if self.ammo[type] <= 0 then
			Utils.TableRemoveByKey(self.ammo, type)
		end
	end
end

function Weapon:getLabel()
	return self.label
end

function Weapon:New(t)
	t = t or {}
	setmetatable(t, self)
	self.__index = self
	return t
end

function FindIndexOf(table, value)
	for k, v in pairs(table) do
		if v == value then
			return k
		end
	end
	return false
end

function Weapon:setLabel(label)
	self.label = label
end

function Weapon:setDesc(desc)
	self.desc = desc
end

function Weapon:getDesc()
	return self.desc
end

function Weapon:setCurrInv(invId)
	self.currInv = invId
end

function Weapon:getCurrInv()
	return self.currInv
end

function Weapon:getGroup()
	self.group = self.group
end

function Weapon:getCustomLabel()
	return self.custom_label
end

function Weapon:setCustomLabel(custom_label)
	self.custom_label = custom_label
end

function Weapon:getSerialNumber()
	return self.serial_number
end

function Weapon:setSerialNumber(serial_number)
	self.serial_number = serial_number
end

function Weapon:setCustomDesc(custom_desc)
	self.custom_desc = custom_desc
end

function Weapon:getCustomDesc()
	return self.custom_desc
end

function Weapon:getWeight()
	return self.weight
end
