---@class Item : table Item class
---@field count number @Item amount
---@field id number  @Item id
---@field name string @Item name
---@field createdAt string @Item creation date
---@field owner string @Item owner charid
---@field group number @Item group type
---@field limit number @Item limit
---@field label string @Item label
---@field metadata table @Item metadata
---@field item string @Item name
---@field type string @Item type
---@field canUse boolean  @Item can use
---@field canRemove boolean @Item can remove
---@field desc string @Item description
---@field weight number @Item weight
Item = {}

Item.id = nil
Item.item = nil
Item.name = nil
Item.label = nil
Item.type = nil
Item.model = nil
Item.metadata = {}
Item.createdAt = nil
Item.owner = nil
Item.desc = nil
Item.count = nil
Item.limit = nil
Item.weight = nil
Item.canUse = false
Item.canRemove = false
Item.dropOnDeath = false
Item.group = nil

-- ID
function Item:setId(id)
	self.id = id
end

function Item:getId()
	return self.id
end

-- NAME
function Item:setName(name)
	self.name = name
end

function Item:getGroup()
	return self.group
end

function Item:getName()
	return self.name
end

-- DESCRIPTION
function Item:getDesc()
	return self.desc
end

function Item:setDesc(desc)
	self.desc = desc
end

-- LABEL
function Item:setLabel(label)
	self.label = label
end

function Item:getLabel()
	return self.label
end

-- TYPE
function Item:setType(type)
	self.type = type
end

function Item:getType()
	return self.type
end

-- Model
function Item:setModel(model)
	self.model = model
end

function Item:getModel()
	return self.model
end

-- Metadata
function Item:setMetadata(metadata)
	if metadata then
		self.metadata = metadata
	end
end

function Item:getMetadata()
	return self.metadata
end

-- COUNT
function Item:setCount(amount)
	self.count = amount
end

function Item:getCount()
	return self.count
end

function Item:addCount(amount, ignoreStackLimit)
	if (self.count + amount <= self.limit) or ignoreStackLimit then
		self.count = self.count + amount
		return true
	end
	return false
end

function Item:quitCount(amount)
	if not amount then
		return
	end
	self.count = self.count - amount
end

-- LIMIT
function Item:setLimit(limit)
	self.limit = limit
end

function Item:getLimit()
	return self.limit
end

-- CanUse
function Item:setCanUse(canUse)
	self.canUse = canUse
end

function Item:getCanUse()
	return self.canUse
end

-- CanRemove
function Item:setCanRemove(canRemove)
	self.canRemove = canRemove
end

function Item:getCanRemove()
	return self.canRemove
end

function Item:getOwner()
	return self.owner
end

-- DropOnDeath
function Item:setDropOnDeath(dropOnDeath)
	self.dropOnDeath = dropOnDeath
end

function Item:getDropOnDeath()
	return self.dropOnDeath
end

function Item:getWeight()
	return self.weight
end

function Item:setWeight(weight)
	self.weight = weight
end

---@return Item Item class
function Item:New(t)
	t = t or {}
	setmetatable(t, self)
	self.__index = self
	return t
end
