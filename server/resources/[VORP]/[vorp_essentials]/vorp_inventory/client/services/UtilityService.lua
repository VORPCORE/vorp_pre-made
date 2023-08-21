Utils = {}

function Utils.FindItemByNameAndMetadata(identifier, name, metadata)
	if UserInventory == nil then
		return nil
	end

	for _, item in pairs(UserInventory) do
		if name == item:getName() and SharedUtils.Table_equals(metadata, item:getMetadata()) then
			return item
		end
	end
	return nil
end

function Utils.cleanAmmo(id)
	local PlayerPedId = PlayerPedId()
	if next(UserWeapons[id]) ~= nil then
		SetPedAmmo(PlayerPedId, joaat(UserWeapons[id]:getName()), 0)

		for _, ammo in pairs(UserWeapons[id]:getAllAmmo()) do
			SetPedAmmoByType(PlayerPedId, joaat(_), 0)
		end
	end
end

function Utils.useWeapon(id)
	local PlayerPedId = PlayerPedId()
	if UserWeapons[id]:getUsed2() then
		local weaponHash = joaat(UserWeapons[id]:getName())
		GiveWeaponToPed_2(PlayerPedId, weaponHash, 0, true, true, 3, false, 0.5, 1.0, 752097756, false, 0, false)
		SetCurrentPedWeapon(PlayerPedId, weaponHash, 0, 0, 0, 0)
		SetPedAmmo(PlayerPedId, weaponHash, 0)

		for _, ammo in pairs(UserWeapons[id]:getAllAmmo()) do
			SetPedAmmoByType(PlayerPedId, joaat(_), ammo)
			if Config.Debug then
				print(joaat(_) .. ": " .. _ .. " " .. ammo)
			end
		end
	else
		Utils.oldUseWeapon(id)
	end
end

function Utils.oldUseWeapon(id)
	local PlayerPedId = PlayerPedId()
	local weaponHash = joaat(UserWeapons[id]:getName())

	GiveWeaponToPed_2(PlayerPedId, weaponHash, 0, true, true, 2, false, 0.5, 1.0, 752097756, false, 0, false)
	SetCurrentPedWeapon(PlayerPedId, weaponHash, 0, 1, 0, 0)
	SetPedAmmo(PlayerPedId, weaponHash, 0)
	for type, amount in pairs(UserWeapons[id]:getAllAmmo()) do
		SetPedAmmoByType(PlayerPedId, joaat(type), amount)
		if Config.Debug then
			print(joaat(type) .. ": " .. type .. " " .. amount)
		end
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
			limit = svItems[name].limit,
			label = svItems[name].label,
			type = "item_standard",
			canUse = true,
			canRemove = svItems[name].can_remove,
			desc = svItems[name].desc,
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

function Utils.GetWeaponLabel(hash)
	for _, wp in pairs(SharedData.Weapons) do
		if wp.HashName == hash then
			return wp.Name
		end
	end
	return hash
end

function Utils.GetWeaponDesc(hash)
	for k, v in pairs(SharedData.Weapons) do
		if v.HashName == hash then
			return v.Desc
		end
	end
	return hash
end

function Utils.TableRemoveByKey(table, key)
	local element = table[key]
	table[key] = nil
	return element
end

function Utils.GetHashreadableLabel(hash, weaponId)
	if weaponId <= 1 then
		if svItems[hash] ~= nil then
			return svItems[hash].label
		end
		return hash
	else
		return Utils.GetWeaponLabel(hash)
	end
end
