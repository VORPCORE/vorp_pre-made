
---@type table<string, Item> contains Database Server items
ServerItems = {}
---@type table<string, table<number, Weapon>> contain users weapons
UsersWeapons = { default = {} }

--- load all player weapons
---@param db_weapon table
local function loadAllWeapons(db_weapon)
	local ammo = json.decode(db_weapon.ammo)
	local comp = json.decode(db_weapon.components)

	if db_weapon.dropped == 0 then
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
	-- load all items from databse
	DBService.queryAsync("SELECT * FROM items", {}, function(result)
		for _, db_item in pairs(result) do
			if db_item.id  then
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
					group = db_item.groupId or 1
				})
				ServerItems[item.item] = item
			end
		end
	end)

	--load all secondary weapons from database
	DBService.queryAsync("SELECT * FROM loadout", {}, function(result)
		for _, db_weapon in pairs(result) do
			if db_weapon.curr_inv ~= "default" then
				loadAllWeapons(db_weapon)
			end
		end
	end)
end)

-- on player select character event
RegisterNetEvent("vorp:SelectedCharacter", loadPlayerWeapons)

-- reload on script restart
if Config.DevMode then
	RegisterNetEvent("DEV:loadweapons", function()
		local _source = source
		local character = Core.getUser(_source).getUsedCharacter
		loadPlayerWeapons(_source, character)
	end)
end
