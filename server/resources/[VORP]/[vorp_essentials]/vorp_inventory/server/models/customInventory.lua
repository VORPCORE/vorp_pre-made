CustomInventoryAPI = {}
CustomInventoryAPI.__index = CustomInventoryAPI
CustomInventoryAPI.__call = function()
    return "CustomInventoryAPI"
end

function CustomInventoryAPI:New(data)
    ---@constructor
    local instance = setmetatable({}, self)
    instance.id = data.id
    instance.name = data.name
    instance.limit = data.limit or 10
    instance.acceptWeapons = data.acceptWeapons or false
    instance.shared = data.shared or false
    instance.ignoreItemStackLimit = data.ignoreItemStackLimit or false
    instance.limitedItems = {}
    instance.whitelistItems = data.whitelistItems or false
    instance.PermissionTakeFrom = {}
    instance.PermissionMoveTo = {}
    instance.CharIdPermissionTakeFrom = {}
    instance.CharIdPermissionMoveTo = {}
    instance.UsePermissions = data.UsePermissions or false
    instance.UseBlackList = data.UseBlackList or false
    instance.BlackListItems = {}
    instance.whitelistWeapons = data.whitelistWeapons or false
    instance.limitedWeapons = {}
    instance.useweight = data.useWeight or false
    instance.weight = data.weight or 0.0
    instance.webhook = data.webhook or false
    return instance
end

---@methods
--- register inventor
function CustomInventoryAPI:Register()
    CustomInventoryInfos[self.id] = self

    UsersInventories[self.id] = {}
    if not UsersWeapons[self.id] then
        UsersWeapons[self.id] = {}
    end
end

--- set custom inventory limit
---@param limit number @inventory limit
function CustomInventoryAPI:setCustomInventoryLimit(limit)
    self.limit = limit
end

--- remove inventory from session
function CustomInventoryAPI:removeCustomInventory()
    CustomInventoryInfos[self.id] = nil
    UsersInventories[self.id] = nil
    UsersWeapons[self.id] = nil
end

--- black list item
---@param data table<string, string> @data table with name
function CustomInventoryAPI:BlackList(data)
    self.BlackListItems[data.name] = data.name
end

--- add permission move to custom inventory
---@param data table<string, integer> @data table with name and grade
function CustomInventoryAPI:AddPermissionMoveTo(data)
    self.PermissionMoveTo[data.name] = data.grade
end

--- add permission take from custom inventory
---@param data table<string, integer> @data table with name and grade
function CustomInventoryAPI:AddPermissionTakeFrom(data)
    self.PermissionTakeFrom[data.name] = data.grade
end

-- update charid permission
---@param charid number @charid
---@param state boolean | nil  remove add or update
function CustomInventoryAPI:AddCharIdPermissionTakeFrom(charid, state)
    if self.CharIdPermissionTakeFrom[charid] then
        self.CharIdPermissionTakeFrom[charid] = state
    else
        if state == nil then state = true end
        self.CharIdPermissionTakeFrom[charid] = state
    end
end

-- update charid permission move to
---@param charid number @charid
---@param state boolean | nil  remove add or update
function CustomInventoryAPI:AddCharIdPermissionMoveTo(charid, state)
    if self.CharIdPermissionMoveTo[charid] then
        self.CharIdPermissionMoveTo[charid] = state
    else
        if state == nil then state = true end
        self.CharIdPermissionMoveTo[charid] = state
    end
end

--- set custom item limit
---@param data table<string,number> @data table with name and limit
function CustomInventoryAPI:setCustomItemLimit(data)
    self.limitedItems[data.name] = data.limit
end

--- set custom weapon limit
---@param data table<string,number> @data table with name and limit
function CustomInventoryAPI:setCustomWeaponLimit(data)
    self.limitedWeapons[data.name] = data.limit
end

--- get limit
---@return integer @inventory limit
function CustomInventoryAPI:getLimit()
    return self.limit
end

--- get name
---@return string @name inventory name
function CustomInventoryAPI:getName()
    return self.name
end

--- is shared inventory
---@return boolean
function CustomInventoryAPI:isShared()
    return self.shared
end

--- is permission enabled for this inventory
---@return boolean
function CustomInventoryAPI:isPermEnabled()
    return self.UsePermissions
end

--- get ignore item stack
---@return boolean
function CustomInventoryAPI:getIgnoreItemStack()
    return self.ignoreItemStackLimit
end

--- is weapon in list
---@param name string @weapon name
---@return boolean
function CustomInventoryAPI:isWeaponInList(name)
    if self.limitedWeapons[name:lower()] then
        return true
    end
    return false
end

--- is item in list
---@param name string @item name
---@return boolean
function CustomInventoryAPI:isItemInList(name)
    if self.limitedItems[name:lower()] then
        return true
    end
    return false
end

--- is item black listed
---@param name string @item name
---@return boolean
function CustomInventoryAPI:isItemInBlackList(name)
    if self.BlackListItems[name:lower()] then
        return true
    end
    return false
end

--- get weapon limit
---@param name string @weapon name
---@return integer @weapon limit
function CustomInventoryAPI:getWeaponLimit(name)
    return self.limitedWeapons[name:lower()]
end

--- get item limit
---@param name string @item name
---@return integer @item limit
function CustomInventoryAPI:getItemLimit(name)
    return self.limitedItems[name:lower()]
end

--- is whitelist weapons enabled
---@return boolean
function CustomInventoryAPI:iswhitelistWeaponsEnabled()
    return self.whitelistWeapons
end

--- is whitelist items enabled
---@return boolean
function CustomInventoryAPI:iswhitelistItemsEnabled()
    return self.whitelistItems
end

--- is blacklist enabled
---@return boolean
function CustomInventoryAPI:isBlackListEnabled()
    return self.UseBlackList
end

--- get blacklist items table
---@return table<string> @table with blacklisted items
function CustomInventoryAPI:getBlackList()
    return self.BlackListItems
end

--- get permission move to custom inventory
---@return table<string, integer>, table<number, boolean> @table with inventory name and grade
function CustomInventoryAPI:getPermissionMoveTo()
    return self.PermissionMoveTo, self.CharIdPermissionMoveTo
end

--- get permission take from custom inventory
---@return table<string, integer>, table<number, boolean> @table with inventory name and grade
function CustomInventoryAPI:getPermissionTakeFrom()
    return self.PermissionTakeFrom, self.CharIdPermissionTakeFrom
end

--- does accept weapons
---@return boolean
function CustomInventoryAPI:doesAcceptWeapons()
    return self.acceptWeapons
end

--- get all custom inventory data
---@return  table
function CustomInventoryAPI:getAllCustomInvData()
    return self
end

--- get log name
---@return string
function CustomInventoryAPI:getWebhook()
    return self.webhook
end

---does it use weight or slots
---@return boolean
function CustomInventoryAPI:useWeight()
    return self.useweight
end

--- weight of inventory
---@param value number
function CustomInventoryAPI:setWeight(value)
    if self.useweight then
        self.weight = value
    end
end

--- update any custom inventory data
---@param data table @table with all custom inventory data
function CustomInventoryAPI:updateCustomInvData(data)
    self.name = data.name or self.name
    self.limit = data.limit or self.limit
    self.acceptWeapons = data.acceptWeapons or self.acceptWeapons
    self.shared = data.shared or self.shared
    self.ignoreItemStackLimit = data.ignoreItemStackLimit or self.ignoreItemStackLimit
    self.limitedItems = data.limitedItems or self.limitedItems
    self.whitelistItems = data.whitelistItems or self.whitelistItems
    self.PermissionTakeFrom = data.PermissionTakeFrom or self.PermissionTakeFrom
    self.PermissionMoveTo = data.PermissionMoveTo or self.PermissionMoveTo
    self.UsePermissions = data.UsePermissions or self.UsePermissions
    self.UseBlackList = data.UseBlackList or self.UseBlackList
    self.BlackListItems = data.BlackListItems or self.BlackListItems
    self.whitelistWeapons = data.whitelistWeapons or self.whitelistWeapons
    self.limitedWeapons = data.limitedWeapons or self.limitedWeapons
    self.webhook = data.webhook or self.webhook
end
