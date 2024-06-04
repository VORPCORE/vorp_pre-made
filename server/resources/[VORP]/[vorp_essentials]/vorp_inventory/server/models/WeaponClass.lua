---@class Weapon : table @Weapon class
---@field id number @Weapon id
---@field propietary number @Weapon owner steam id
---@field name string @Weapon name
---@field ammo number @Weapon ammo
---@field components table @Weapon components
---@field used boolean @Weapon used
---@field used2 boolean @Weapon used2
---@field charId number @Weapon charid
---@field currInv string @Weapon current inventory
---@field dropped number @Weapon dropped
---@field group number @Weapon group type
---@field source number @Weapon player source
---@field weight number @Weapon weight

Weapon               = {}
Weapon.name          = nil
Weapon.id            = nil
Weapon.propietary    = nil
Weapon.charId        = nil
Weapon.used          = false
Weapon.used2         = false
Weapon.ammo          = {}
Weapon.components    = {}
Weapon.desc          = nil
Weapon.currInv       = ''
Weapon.dropped       = 0
Weapon.group         = 5
Weapon.source        = nil
Weapon.label         = nil
Weapon.serial_number = nil
Weapon.custom_label  = nil
Weapon.custom_desc   = nil
Weapon.weight        = nil

function Weapon:getLabel()
	return self.label
end

function Weapon:getSerialNumber()
	return self.serial_number
end

function Weapon:getCustomLabel()
	return self.custom_label
end

function Weapon:setCustomLabel(custom_label)
	self.custom_label = custom_label
end

function Weapon:setSerialNumber(serial_number)
	self.serial_number = serial_number
end

function Weapon:getCustomDesc()
	return self.custom_desc
end

function Weapon:setCustomDesc(custom_desc)
	self.custom_desc = custom_desc
end

function Weapon:setUsed(isUsed)
	self.used = isUsed
end

function Weapon:getUsed()
	return self.used
end

function Weapon:setUsed2(isUsed)
	self.used2 = isUsed
end

function Weapon:getUsed2()
	return self.used2
end

function Weapon:getSource()
	return self.source
end

function Weapon:setSource(source)
	self.source = source
end

function Weapon:setPropietary(propietary)
	self.propietary = propietary
end

function Weapon:getPropietary()
	return self.propietary
end

function Weapon:setCharId(charId)
	self.charId = charId
end

function Weapon:getCharId()
	return self.charId
end

function Weapon:setId(id)
	self.id = id
end

function Weapon:getId()
	return self.id
end

function Weapon:getGroup()
	return self.group
end

function Weapon:setName(name)
	self.name = name
end

function Weapon:getName()
	return self.name
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

function Weapon:setDropped(dropped)
	self.dropped = dropped
end

function Weapon:getDropped()
	return self.dropped
end

function Weapon:getAllAmmo()
	return self.ammo
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
		table.remove(self.components, componentExists)
		return true
	end
	return false
end

function Weapon:getAmmo(type)
	return self.ammo[type]
end

function Weapon:addAmmo(type, amount)
	if self.ammo[type] ~= nil then
		self.ammo[type] = self.ammo[type] + amount
	else
		self.ammo[type] = tonumber(amount)
	end
	DBService.updateAsync('UPDATE loadout SET ammo = @ammo WHERE id=@id',
		{ ammo = json.encode(self:getAllAmmo()), id = self.id }, function() end)
end

function Weapon:setAmmo(type, amount)
	self.ammo[type] = tonumber(amount)
	DBService.updateAsync('UPDATE loadout SET ammo = @ammo WHERE id=@id',
		{ ammo = json.encode(self:getAllAmmo()), id = self.id }, function() end)
end

function Weapon:subAmmo(type, amount)
	if self.ammo[type] ~= nil then
		self.ammo[type] = self.ammo[type] - amount

		if self.ammo[type] <= 0 then
			self.ammo[type] = nil
		end
		DBService.updateAsync('UPDATE loadout SET ammo = @ammo WHERE id=@id',
			{ ammo = json.encode(self:getAllAmmo()), id = self.id }, function() end)
	end
end

function Weapon:getWeight()
	return self.weight
end

---@return Weapon
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
