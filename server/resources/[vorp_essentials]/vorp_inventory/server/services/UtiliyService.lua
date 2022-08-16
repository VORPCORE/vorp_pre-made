SvUtils = {}
local processingUser = {}

SvUtils.FindAllWeaponsByName = function (invId, identifier, name)
    local userWeapons = UsersWeapons[invId]
	local weapons = {}

    if userWeapons == nil then
        return {}
    end

    for _, weapon in pairs(userWeapons) do
        if name == weapon:getName() then
            weapons[#weapons+1] = weapons
        end
    end
    return weapons
end

SvUtils.FindAllItemsByName = function (invId, identifier, name)
    local userInventory = nil
	local items = {}

	if CustomInventoryInfos[invId].shared then
		userInventory = UsersInventories[invId]
	else
		userInventory = UsersInventories[invId][identifier]
	end

    if userInventory == nil then
        return {}
    end

    for _, item in pairs(userInventory) do
        if name == item:getName() then
            items[#items+1] = item
        end
    end
    return items
end



SvUtils.FindItemByNameAndMetadata = function (invId, identifier, name, metadata)
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

SvUtils.FindItemByNameAndContainingMetadata = function (invId, identifier, name, metadata)
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


SvUtils.ProcessUser = function(id)
	TriggerClientEvent("vorp_inventory:transactionStarted", id)
	table.insert(processingUser, id)
	Log.print("Start Processing user " .. id)
end

SvUtils.InProcessing = function(id)
	for _, v in pairs(processingUser) do
		if v == id then
			return true
		end
	end
	return false
end

SvUtils.Trem = function(id, keepInventoryOpen)
	keepInventoryOpen = keepInventoryOpen == nil and true or keepInventoryOpen

	for k, v in pairs(processingUser) do
		if v == id then
			TriggerClientEvent("vorp_inventory:transactionCompleted", id, keepInventoryOpen)
			table.remove(processingUser, k)
			Log.print("Stop Processing user " .. id)
		end
	end
end
