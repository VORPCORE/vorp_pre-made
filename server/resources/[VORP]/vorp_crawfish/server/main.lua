
local VORP_INV = exports.vorp_inventory:vorp_inventoryApi()

RegisterServerEvent("vorp_crawfish:try_search")
RegisterServerEvent("vorp_crawfish:do_search")
RegisterServerEvent("vorp_crawfish:abort_search")
RegisterServerEvent("vorp_crawfish:harvest")

local holes_searched = {}
local holes_searching = {}

local function InventoryCheck(_source, item, count)
	local itemsAvailable = true
	local done = false
	TriggerEvent("vorpCore:canCarryItem", _source, item, count, function(canCarryItem)                
		if canCarryItem ~= true then
			itemsAvailable = false
		end
		done = true
	end)
	while done == false do
		Wait(500)
	end
	if not itemsAvailable then
		-- Carrying too many of item already.
		TriggerClientEvent("vorp:TipRight", _source, _U("inv_nospace"), 5000)
		return false
	end
	if not VORP_INV.canCarryItems(_source, count) then
		-- Not enough space available in inventory.
		TriggerClientEvent("vorp:TipRight", _source, _U("inv_nospace"), 5000)
		return false
	end
	return true
end

local function AbortSearch(_source)
	for k,v in ipairs(holes_searching) do
		if v then
			if v == _source then
				holes_searching[k] = false
			end
		end
	end
end

AddEventHandler("vorp_crawfish:try_search", function(holeIndex)
	local _source = source
	local allow = true
	local curtime = os.time()
	if holes_searching[holeIndex] then
		-- This hole is currently being searched.
		TriggerClientEvent("vorp:TipRight", _source, _U("search_current"), 5000)
		return
	end
	holes_searching[holeIndex] = _source
	if holes_searched[holeIndex] then
		if curtime < (holes_searched[holeIndex] + Config.SearchDelay) then
			-- Not enough time has passed since this hole was last searched.
			TriggerClientEvent("vorp:TipRight", _source, _U("search_recent"), 5000)
			allow = false
		end
	end
	if allow then
		-- Check that the player has enough inventory space to continue...
		local count
		if type(Config.SearchRewardCount) == "table" then
			count = math.max(1,Config.SearchRewardCount[1])
		else
			count = Config.SearchRewardCount
		end
		allow = InventoryCheck(_source, Config.CrawfishItemName, count)
	end
	if not allow then
		holes_searching[holeIndex] = false
		TriggerClientEvent("vorp_crawfish:try_search", _source) -- we're just doing this to ensure the client resets some local values allowing them to search again
		return
	end
	holes_searched[holeIndex] = curtime
	local searchTime = math.random(Config.SearchTimeMin, Config.SearchTimeMax) -- yes, we're even going to let the server determine the search time...
	TriggerClientEvent("vorp_crawfish:do_search",_source, holeIndex, searchTime)
end)

AddEventHandler("vorp_crawfish:do_search", function(holeIndex)
	local _source = source
	if (holes_searching[holeIndex] or 0) ~= _source then
		--[[
			This should never happen, but here we make sure that someone else has not come along and
			stolen the contents of a crawfish hole that someone else was already searching.
		]]
		TriggerClientEvent("vorp_crawfish:try_search", _source) -- we're just doing this to ensure the client resets some local values allowing them to search again
		return
	end
	holes_searching[holeIndex] = false
	local count
	if type(Config.SearchRewardCount) == "table" then
		count = math.random(Config.SearchRewardCount[1],Config.SearchRewardCount[2])
	else
		count = Config.SearchRewardCount
	end
	if not InventoryCheck(_source, Config.CrawfishItemName, count) then -- check their inventory space again for good measure...
		holes_searched[holeIndex] = false -- let's be nice and let players clear some inventory space then try again (if nobody beats them to it).
		TriggerClientEvent("vorp_crawfish:try_search", _source) -- we're just doing this to ensure the client resets some local values allowing them to search again
		return
	end
	VORP_INV.addItem(_source, Config.CrawfishItemName, count)
	TriggerClientEvent("vorp:TipRight", _source, _UP("search_found", {count=count,item=Config.CrawfishItemLabel}), 5000)
end)

AddEventHandler("vorp_crawfish:abort_search",function()
	AbortSearch(source)
end)

local harvesting = {}
AddEventHandler("vorp_crawfish:harvest", function()
	local _source = source
	if not harvesting[_source] then return end
	VORP_INV.addItem(_source, Config.CrawfishGivenItemName, harvesting[_source])
	TriggerClientEvent("vorp:TipRight", _source, _UP("harvested", {count=harvesting[_source],item=Config.CrawfishGivenItemLabel}), 5000)
	harvesting[_source] = nil
end)

if not Config.CrawfishCustomUseFunction then
	VORP_INV.RegisterUsableItem(Config.CrawfishItemName, function(data)
		if harvesting[data.source] then return end
		local count
		if type(Config.CrawfishGivenItemAmount) == "table" then
			count = math.random(Config.CrawfishGivenItemAmount[1],Config.CrawfishGivenItemAmount[2])
		else
			count = Config.CrawfishGivenItemAmount
		end
		VORP_INV.subItem(data.source, Config.CrawfishItemName, 1)
		if not InventoryCheck(data.source, Config.CrawfishGivenItemName, count) then
			VORP_INV.addItem(data.source, Config.CrawfishItemName, 1) -- return the crawfish if they didn't have space to complete the harvest (because we're that nice)
			return
		end
		harvesting[data.source] = count
		TriggerClientEvent("vorp_crawfish:harvest", data.source)
	end)
end

AddEventHandler("playerDropped", function(reason)
	AbortSearch(source)
end)

AddEventHandler("onResourceStart",function(resourceName)
	if resourceName == GetCurrentResourceName() then
		for k,v in ipairs(Config.CrawfishHoles) do
			holes_searched[k] = false
			holes_searching[k] = false
		end
	end
end)
