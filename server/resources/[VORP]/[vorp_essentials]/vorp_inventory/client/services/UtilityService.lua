Utils = {}

function Utils.cleanAmmo(id)
	local PlayerPedId = PlayerPedId()
	if UserWeapons[id] and next(UserWeapons[id]) then
		SetPedAmmo(PlayerPedId, joaat(UserWeapons[id]:getName()), 0)
		for k, _ in pairs(UserWeapons[id]:getAllAmmo()) do
			SetPedAmmoByType(PlayerPedId, joaat(k), 0)
		end
	end
end

function Utils.useWeapon(id)
	local PlayerPedId = PlayerPedId()
	if UserWeapons[id]:getUsed2() then
		local weaponHash = joaat(UserWeapons[id]:getName())
		GiveWeaponToPed(PlayerPedId, weaponHash, 0, true, true, 3, false, 0.5, 1.0, 752097756, false, 0, false)
		SetCurrentPedWeapon(PlayerPedId, weaponHash, false, 0, false, false)
		SetPedAmmo(PlayerPedId, weaponHash, 0)
		for _, ammo in pairs(UserWeapons[id]:getAllAmmo()) do
			SetPedAmmoByType(PlayerPedId, joaat(_), ammo)
		end
	else
		Utils.oldUseWeapon(id)
	end
end

function Utils.oldUseWeapon(id)
	local PlayerPedId = PlayerPedId()
	local weaponHash = joaat(UserWeapons[id]:getName())
	GiveWeaponToPed(PlayerPedId, weaponHash, 0, true, true, 2, false, 0.5, 1.0, 752097756, false, 0, false)
	SetCurrentPedWeapon(PlayerPedId, weaponHash, false, 1, false, false)
	SetPedAmmo(PlayerPedId, weaponHash, 0)
	for type, amount in pairs(UserWeapons[id]:getAllAmmo()) do
		SetPedAmmoByType(PlayerPedId, joaat(type), amount)
	end
	UserWeapons[id]:setUsed(true)
	TriggerServerEvent("vorpinventory:setUsedWeapon", id, UserWeapons[id]:getUsed(), UserWeapons[id]:getUsed2())
end

function Utils.addItems(name, id, amount)
	if next(UserInventory[id]) ~= nil then
		UserInventory[id]:addCount(amount)
	else
		UserInventory[id] = Item:New({
			id = id,
			count = amount,
			name = name,
			limit = ClientItems[name].limit,
			label = ClientItems[name].label,
			type = "item_standard",
			canUse = true,
			canRemove = ClientItems[name].can_remove,
			desc = ClientItems[name].desc,
			group = ClientItems[name].group or 1,
			weight = ClientItems[name].weight or 0.25,
		})
	end
end

function Utils.expandoProcessing(object)
	local _obj = {}
	for _, row in pairs(object) do
		_obj[_] = row
	end
	return _obj
end

function Utils.getNearestPlayers()
	local closestDistance = 5.0
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, true, true)
	local closestPlayers = {}

	for _, player in pairs(GetActivePlayers()) do
		local target = GetPlayerPed(player)

		if target ~= playerPed then
			local targetCoords = GetEntityCoords(target, true, true)
			local distance = #(targetCoords - coords)

			if distance < closestDistance then
				table.insert(closestPlayers, player)
			end
		end
	end
	return closestPlayers
end

function Utils.GetWeaponDefaultLabel(hash)
	for _, wp in ipairs(SharedData.Weapons) do
		if wp.HashName == hash then
			return wp.Name
		end
	end
	return hash
end

function Utils.GetWeaponDefaultDesc(hash)
	for k, v in ipairs(SharedData.Weapons) do
		if v.HashName == hash then
			return v.Desc
		end
	end
	return hash
end

function Utils.GetWeaponDefaultWeight(hash)
	for k, v in ipairs(SharedData.Weapons) do
		if joaat(v.HashName) == hash then
			return v.Weight
		end
	end
	return 0.25
end

function Utils.GetWeaponName(hash)
	for k, v in ipairs(SharedData.Weapons) do
		if joaat(v.HashName) == hash then
			return v.HashName
		end
	end
	return hash
end

function Utils.GetWeaponsDefaultData(request)
	local weapons = {}
	for _, v in ipairs(SharedData.Weapons) do
		for _, value in ipairs(request) do
			if v.HashName == value then
				table.insert(weapons, v)
			end
		end
	end
	return weapons
end

function Utils.GetAmmoLabel(ammo)
	if type(ammo) == "string" then
		return SharedData.AmmoLabels[ammo]
	end

	if type(ammo) ~= "number" then
		return false
	end

	for key, value in pairs(SharedData.AmmoLabels) do
		if joaat(value) == ammo then
			return value
		end
	end
end

function Utils.GetItem(name)
	if not UserInventory or not name then
		return false
	end

	for _, item in pairs(UserInventory) do
		if name == item:getName() then
			return {
				label = item:getLabel(),
				count = item:getCount(),
				limit = item:getLimit(),
				weight = item:getWeight()
			}
		end
	end

	return false
end

function Utils.TableRemoveByKey(table, key)
	local element = table[key]
	table[key] = nil
	return element
end

function Utils.GetLabel(hash, id)
	if id <= 1 then
		if ClientItems[hash] then
			return ClientItems[hash].label
		end
		return hash
	else
		return Utils.GetWeaponDefaultLabel(hash)
	end
end

function Utils.filterWeaponsSerialNumber(name)
	for _, weapon in ipairs(Config.noSerialNumber) do
		if weapon == name then
			return false
		end
	end
	return true
end
