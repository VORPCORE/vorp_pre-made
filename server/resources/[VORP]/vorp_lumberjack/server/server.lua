local VorpCore = exports.vorp_core:GetCore()
local T = Translation.Langs[Lang]

RegisterServerEvent("vorp_lumberjack:axecheck", function(tree)
	local _source = source
	local choppingtree = tree
	local axe = exports.vorp_inventory:getItem(_source, Config.Axe)

	if not axe then
		TriggerClientEvent("vorp_lumberjack:noaxe", _source)
		VorpCore.NotifyObjective(_source, T.NotifyLabels.notHaveAxe, 5000)
		return
	end

	local meta = axe.metadata
	if not next(meta) then
		local metadata = { description = T.NotifyLabels.descDurabilityOne, durability = 99 }
		exports.vorp_inventory:setItemMetadata(_source, axe.id, metadata, 1)
		TriggerClientEvent("vorp_lumberjack:axechecked", _source, choppingtree)
	else
		local durability = meta.durability - 1
		local description = T.NotifyLabels.descDurabilityTwo
		local metadata = { description = description, durability = durability }

		if durability < 20 then
			local random = math.random(1, 3)
			if random == 1 then
				VorpCore.NotifyObjective(_source, T.NotifyLabels.brokeAxe, 5000)
				exports.vorp_inventory:subItem(_source, Config.Axe, 1, meta)
				TriggerClientEvent("vorp_lumberjack:noaxe", _source)
			else
				exports.vorp_inventory:setItemMetadata(_source, axe.id, metadata, 1)
				TriggerClientEvent("vorp_lumberjack:axechecked", _source, choppingtree)
			end
		else
			exports.vorp_inventory:setItemMetadata(_source, axe.id, metadata, 1)
			TriggerClientEvent("vorp_lumberjack:axechecked", _source, choppingtree)
		end
	end
end)

local function keysx(table)
	local keys = 0
	for k, v in pairs(table) do
		keys = keys + 1
	end
	return keys
end

RegisterServerEvent('vorp_lumberjack:addItem', function()
	math.randomseed(os.time())
	local _source = source
	local chance = math.random(1, 10)
	local reward = {}
	for k, v in pairs(Config.Items) do
		if v.chance >= chance then
			table.insert(reward, v)
		end
	end
	local randomtotal = keysx(reward)
	if randomtotal == 0 then
		VorpCore.NotifyObjective(_source, T.NotifyLabels.gotNothing, 5000)
		return
	end
	local chance2 = math.random(1, randomtotal)
	local count = math.random(1, reward[chance2].amount)
	local canCarry = exports.vorp_inventory:canCarryItem(_source, reward[chance2].name, count)

	if not canCarry then
		return VorpCore.NotifyObjective(_source, T.NotifyLabels.fullBag .. reward[chance2].label, 5000)
	end

	exports.vorp_inventory:addItem(_source, reward[chance2].name, count)
	VorpCore.NotifyObjective(_source, T.NotifyLabels.yourGot .. reward[chance2].label, 3000)
end)
