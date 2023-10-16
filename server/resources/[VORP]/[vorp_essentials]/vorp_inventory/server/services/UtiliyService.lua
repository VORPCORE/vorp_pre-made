---@diagnostic disable: undefined-global

---@class SvUtils @Server Utility Service
---@field FindAllWeaponsByName fun(invId: string, name: string): table<number, Weapon>
---@field FindAllItemsByName fun(invId: string, identifier: string, name: string): table<number, Item>
---@field FindItemByName fun(invId: string, identifier: string, name: string): Item
---@field FindItemByNameAndMetadata fun(invId: string, identifier: string, name: string, metadata: table): Item
---@field FindItemByNameAndContainingMetadata fun(invId: string, identifier: string, name: string, metadata: table): Item
---@field ProcessUser fun(id: number)
---@field InProcessing fun(id: number): boolean
---@field Trem fun(id: string, keepInventoryOpen: boolean)
---@field DoesItemExist fun(itemName:string,api:string): boolean
SvUtils = {}

--@Processing user when making inventory transactions
local processingUser = {}
math.randomseed(GetGameTimer())

---return a table will all weapons that match the name
---@param invId string
---@param name string
---@return table
function SvUtils.FindAllWeaponsByName(invId, name)
    local userWeapons = UsersWeapons[invId]
    local weapons = {}

    if userWeapons == nil then
        return {}
    end

    for _, weapon in pairs(userWeapons) do
        if name == weapon:getName() then
            weapons[#weapons + 1] = weapons
        end
    end

    return weapons
end

--- return a table will all items that match the name
---@param invId string
---@param identifier string
---@param name string
---@return table
function SvUtils.FindAllItemsByName(invId, identifier, name)
    local userInventory = nil
    local items = {}
    if CustomInventoryInfos[invId].shared then
        userInventory = UsersInventories[invId]
    else
        userInventory = UsersInventories[invId][identifier]
    end

    if userInventory == nil then
        return items
    end

    for _, item in pairs(userInventory) do
        if name == item:getName() then
            items[#items + 1] = item
        end
    end

    return items
end

--- return a item that match the name
---@param invId string
---@param identifier string
---@param name string
---@return nil
function SvUtils.FindItemByName(invId, identifier, name)
    local userInventory = nil
    if CustomInventoryInfos[invId].shared then
        userInventory = UsersInventories[invId]
    else
        userInventory = UsersInventories[invId][identifier]
    end

    if userInventory == nil then
        return nil
    end

    for _, item in pairs(userInventory) do
        if name == item:getName() then
            return item
        end
    end

    return nil
end

--- returns a item that match the name and metadata
---@param invId string
---@param identifier string
---@param name string
---@param metadata table | nil
---@return nil
function SvUtils.FindItemByNameAndMetadata(invId, identifier, name, metadata)
    local userInventory = nil

    if CustomInventoryInfos[invId].shared then
        userInventory = UsersInventories[invId]
    else
        userInventory = UsersInventories[invId][identifier]
    end

    if userInventory == nil then
        return nil
    end

    if metadata then
        for _, item in pairs(userInventory) do
            if name == item:getName() and SharedUtils.Table_equals(metadata, item:getMetadata()) then
                return item
            end
        end
    else
        for _, item in pairs(userInventory) do
            if name == item:getName() then
                return item
            end
        end
    end

    return nil
end

--- returns a item that match the name and containing metadata
---@param invId string
---@param identifier string
---@param name string
---@param metadata table | nil
---@return nil
function SvUtils.FindItemByNameAndContainingMetadata(invId, identifier, name, metadata)
    local userInventory = nil

    if CustomInventoryInfos[invId].shared then
        userInventory = UsersInventories[invId]
    else
        userInventory = UsersInventories[invId][identifier]
    end

    if userInventory == nil then
        return nil
    end

    for _, item in pairs(userInventory) do
        if name == item:getName() and SharedUtils.Table_contains(item:getMetadata(), metadata) then
            return item
        end
    end

    return nil
end

---PoccessUser when in transaction
---@param id number user id
function SvUtils.ProcessUser(id)
    TriggerClientEvent("vorp_inventory:transactionStarted", id)
    table.insert(processingUser, id)
end

--- is user in processing transaction
---@param id number user id
---@return boolean
function SvUtils.InProcessing(id)
    for _, v in pairs(processingUser) do
        if v == id then
            return true
        end
    end
    return false
end

--- Transaction Ended
---@param id number user id
---@param keepInventoryOpen? boolean keep inventory open
function SvUtils.Trem(id, keepInventoryOpen)
    keepInventoryOpen = keepInventoryOpen == nil and true or keepInventoryOpen
    for k, v in pairs(processingUser) do
        if v == id then
            TriggerClientEvent("vorp_inventory:transactionCompleted", id, keepInventoryOpen)
            table.remove(processingUser, k)
        end
    end
end

--- does item exist in server items table meaning databse
---@param itemName string item name
---@param api string name
---@return boolean
function SvUtils.DoesItemExist(itemName, api)
    if ServerItems[itemName] then
        return true
    else
        Log.error("[^2" .. api .. "7] Item [^3" .. tostring(itemName) .. "^7] does not exist in DB.")
        return false
    end
end

--- generate a weapon label
---@param name string weapon name
---@return string
function SvUtils.GenerateWeaponLabel(name)
    for key, value in ipairs(SharedData.Weapons) do
        if value.HashName == name then
            return value.Name
        end
    end
    return ""
end

--- filter weapons that should not have a serial number
---@param name string weapon name
---@return boolean
function SvUtils.filterWeaponsSerialNumber(name)
    for _, weapon in pairs(Config.noSerialNumber) do
        if weapon == name then
            return false
        end
    end
    return true
end

--- generate a unique serial number
---@return string
function SvUtils.GenerateSerialNumber(name)
    if SvUtils.filterWeaponsSerialNumber(name) then
        return ""
    end
    local timeStamp = os.time()
    local randomNumber = math.random(1000, 9999)
    return string.format("%s-%s", timeStamp, randomNumber)
end