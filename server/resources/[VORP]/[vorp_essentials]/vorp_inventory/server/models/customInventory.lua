---@class CustomInventory @Custom Inventory Info
---@field id string
---@field name string
---@field limit number
---@field acceptWeapons boolean
---@field shared boolean
---@field ignoreItemStackLimit boolean
---@field whitelistItems boolean
---@field limitedItems table<string, integer>
---@field PermissionTakeFrom table<string, integer>
---@field PermissionMoveTo table<string, integer>
---@field UsePermissions boolean
---@field UseBlackList boolean
---@field BlackListItems table<string, string>
---@field whitelistWeapons boolean
---@field limitedWeapons table<string, integer>
---@field setCustomInventoryLimit fun(self : CustomInventory, limit : number) @Set Custom Inventory Limit
---@field removeCustomInventory fun(self : CustomInventory) @Remove Custom Inventory
---@field BlackList fun(self : CustomInventory, data : table) @Black List
---@field AddPermissionMoveTo fun(self : CustomInventory, data : table) @Add Permission Move To
---@field AddPermissionTakeFrom fun(self : CustomInventory, data : table) @Add Permission Take From
---@field setCustomItemLimit fun(self : CustomInventory, data : table) @Set Custom Item Limit
---@field setCustomWeaponLimit fun(self : CustomInventory, data : table) @Set Custom Weapon Limit
---@field register fun(self : CustomInventory) @Register Inventory
---@field getLimit fun(self : CustomInventory) : number @Get Limit
---@field isShared fun(self : CustomInventory) : boolean @Get Shared
---@field getName  fun (self : CustomInventory) : string @Get Name
---@field isPermEnabled fun(self : CustomInventory) : boolean @Get Perm Enabled
---@field getIgnoreItemStack fun(self : CustomInventory) : boolean @Get Ignore Item Stack
---@field isWeaponInList fun(self : CustomInventory, name : string) : boolean @Is Weapon In List
---@field isItemInList fun(self : CustomInventory, name : string) : boolean @Is Item In List
---@field isItemInBlackList fun(self : CustomInventory, name : string) : boolean @Is Item In Black List
---@field getWeaponLimit fun(self : CustomInventory, name : string) : number @Get Weapon Limit
---@field getItemLimit fun(self : CustomInventory, name : string) : number @Get Item Limit
---@field iswhitelistWeaponsEnabled fun(self : CustomInventory) : boolean @Is Whitelist Weapons Enabled
---@field iswhitelistItemsEnabled fun(self : CustomInventory) : boolean @Is Whitelist Items Enabled
---@field isBlackListEnabled fun(self : CustomInventory) : boolean @Is Black List Enabled
---@field getBlackList fun(self : CustomInventory) : table<string, boolean> @Get Black List
---@field getPermissionMoveTo fun(self : CustomInventory) : table<string, integer> @Get Permission Move To
---@field getPermissionTakeFrom fun(self : CustomInventory) : table<string, integer> @Get Permission Take From
---@field doesAcceptWeapons fun(self : CustomInventory) : boolean @Does Accept Weapons
CustomInventoryAPI = {}

CustomInventoryAPI.__index = CustomInventoryAPI
CustomInventoryAPI.__call = function()
    return "CustomInventoryAPI"
end


function CustomInventoryAPI:New(data)
    local obj = setmetatable({}, self)
    obj.id = data.id
    obj.name = data.name
    obj.limit = data.limit or 10
    obj.acceptWeapons = data.acceptWeapons or false
    obj.shared = data.shared or false
    obj.ignoreItemStackLimit = data.ignoreItemStackLimit or false
    obj.limitedItems = {}
    obj.whitelistItems = data.whitelistItems or false
    obj.PermissionTakeFrom = {}
    obj.PermissionMoveTo = {}
    obj.UsePermissions = data.UsePermissions or false
    obj.UseBlackList = data.UseBlackList or false
    obj.BlackListItems = {}
    obj.whitelistWeapons = data.whitelistWeapons or false
    obj.limitedWeapons = {}

    return obj
end

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
---@return table<string, integer> @table with inventory name and grade
function CustomInventoryAPI:getPermissionMoveTo()
    return self.PermissionMoveTo
end

--- get permission take from custom inventory
---@return table<string, integer> @table with inventory name and grade
function CustomInventoryAPI:getPermissionTakeFrom()
    return self.PermissionTakeFrom
end

--- does accept weapons
---@return boolean
function CustomInventoryAPI:doesAcceptWeapons()
    return self.acceptWeapons
end
