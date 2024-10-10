local Core   = exports.vorp_core:GetCore()
ServerItems  = {}
UsersWeapons = { default = {} }

-- temporary just to assing serial numbers to old weapons and labels will be removed eventually
MySQL.ready(function()
	DBService.queryAsync('SELECT name,id,label,serial_number FROM loadout', {},
		function(result)
			if next(result) then
				for _, db_weapon in pairs(result) do
					local label = db_weapon.label or SvUtils.GenerateWeaponLabel(db_weapon.name)
					local serialNumber = db_weapon.serial_number or SvUtils.GenerateSerialNumber(db_weapon.name)
					if not db_weapon.serial_number then
						DBService.updateAsync('UPDATE loadout SET serial_number = @serial_number WHERE id = @id', { id = db_weapon.id, serial_number = serialNumber }, function() end)
					end
					if not db_weapon.label then
						DBService.updateAsync('UPDATE loadout SET label = @label WHERE id = @id', { id = db_weapon.id, label = label }, function() end)
					end
				end
			end
		end)
end)


--- load all player weapons
---@param db_weapon table
local function loadAllWeapons(db_weapon)
	local ammo = json.decode(db_weapon.ammo)
	local comp = json.decode(db_weapon.components)

	if db_weapon.dropped == 0 then
		local label = db_weapon.custom_label or db_weapon.label
		local weight = SvUtils.GetWeaponWeight(db_weapon.name)
		local weapon = Weapon:New({
			id = db_weapon.id,
			propietary = db_weapon.identifier,
			name = db_weapon.name,
			ammo = ammo,
			components = comp,
			used = false,
			used2 = false,
			charId = db_weapon.charidentifier,
			currInv = db_weapon.curr_inv,
			dropped = db_weapon.dropped,
			group = 5,
			label = label,
			serial_number = db_weapon.serial_number,
			custom_label = db_weapon.custom_label,
			custom_desc = db_weapon.custom_desc,
			weight = weight,
		})

		if not UsersWeapons[db_weapon.curr_inv] then
			UsersWeapons[db_weapon.curr_inv] = {}
		end

		UsersWeapons[db_weapon.curr_inv][weapon:getId()] = weapon
	else
		DBService.deleteAsync('DELETE FROM loadout WHERE id = @id', { id = db_weapon.id }, function() end)
	end
end




--- load player default inventory weapons
---@param source number
---@param character table character table data
local function loadPlayerWeapons(source, character)
	local _source = source
	DBService.queryAsync('SELECT * FROM loadout WHERE charidentifier = ? ', { character.charIdentifier },
		function(result)
			if next(result) then
				for _, db_weapon in pairs(result) do
					if db_weapon.charidentifier and db_weapon.curr_inv == "default" then -- only load default inventory
						loadAllWeapons(db_weapon)
					end
				end
			end
		end)
end


MySQL.ready(function()
	-- load all items from database
	DBService.queryAsync("SELECT * FROM items", {}, function(result)
		for _, db_item in pairs(result) do
			if db_item.id then
				local item = Item:New({
					id = db_item.id,
					item = db_item.item,
					metadata = db_item.metadata or {},
					label = db_item.label,
					limit = db_item.limit,
					type = db_item.type,
					canUse = db_item.usable,
					canRemove = db_item.can_remove,
					desc = db_item.desc,
					group = db_item.groupId or 1,
					weight = db_item.weight or 0.25,
				})
				ServerItems[item.item] = item
			end
		end
	end)

	--load all secondary inventory weapons from database
	DBService.queryAsync("SELECT * FROM loadout", {}, function(result)
		for _, db_weapon in pairs(result) do
			if db_weapon.curr_inv ~= "default" then
				loadAllWeapons(db_weapon)
			end
		end
	end)
end)


-- on player select character event
AddEventHandler("vorp:SelectedCharacter", function(source, char)
	loadPlayerWeapons(source, char)

	local newtable = {}
	for k, v in pairs(ServerItems) do
		newtable[k] = v.item
	end
	local packed = msgpack.pack(newtable)
	TriggerClientEvent("vorp_inventory:server:CacheImages", source, packed)
end)

-- reload on script restart
if Config.DevMode then
	RegisterNetEvent("DEV:loadweapons", function()
		local _source = source
		local character = Core.getUser(_source).getUsedCharacter
		loadPlayerWeapons(_source, character)

		local newtable = {}
		for k, v in pairs(ServerItems) do
			newtable[k] = v.item
		end
		local packed = msgpack.pack(newtable)
		TriggerClientEvent("vorp_inventory:server:CacheImages", source, packed)
	end)
end
