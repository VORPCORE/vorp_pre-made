VorpInv = exports.vorp_inventory:vorp_inventoryApi()

local VorpCore = {}

T = Translation.Langs[Lang]

TriggerEvent("getCore", function(core)
	VorpCore = core
end)

RegisterServerEvent("vorp_lumberjack:axecheck")
AddEventHandler("vorp_lumberjack:axecheck", function(tree)
	local _source = source
	local choppingtree = tree
	local Axe = VorpInv.getItem(_source, Config.Axe)
	if Axe ~= nil then
		local meta = Axe["metadata"]
		if next(meta) == nil then
			VorpInv.subItem(_source, Config.Axe, 1, {})
			VorpInv.addItem(_source, Config.Axe, 1, { description = T.NotifyLabels.descDurabilityOne, durability = 99 })
			TriggerClientEvent("vorp_lumberjack:axechecked", _source, choppingtree)
		else
			local durability = meta.durability - 1
			local description = T.NotifyLabels.descDurabilityTwo
			VorpInv.subItem(_source, Config.Axe, 1, meta)
			if 0 >= durability then
				local random = math.random(1, 2)
				if random == 1 then
					TriggerClientEvent("vorp:TipRight", _source, T.NotifyLabels.brokeAxe, 2000)
					TriggerClientEvent("vorp_lumberjack:noaxe", _source)
				else
					VorpInv.addItem(_source, Config.Axe, 1, { description = description .. "1", durability = 1 })
					TriggerClientEvent("vorp_lumberjack:axechecked", _source, choppingtree)
				end
			else
				VorpInv.addItem(_source, Config.Axe, 1, {
					description = description .. durability,
					durability = durability
				})
				TriggerClientEvent("vorp_lumberjack:axechecked", _source, choppingtree)
			end
		end
	else
		TriggerClientEvent("vorp_lumberjack:noaxe", _source)
		TriggerClientEvent("vorp:TipRight", _source, T.NotifyLabels.notHaveAxe, 2000)
	end
end)

local keysx = function(table)
	local keys = 0
	for k, v in pairs(table) do
		keys = keys + 1
	end
	return keys -- if 0 will throw error
end

RegisterServerEvent('vorp_lumberjack:addItem')
AddEventHandler('vorp_lumberjack:addItem', function()
	math.randomseed(os.time())
	local _source = source
	local Character = VorpCore.getUser(_source).getUsedCharacter
	local chance = math.random(1, 10)
	local reward = {}
	for k, v in pairs(Config.Items) do
		if v.chance >= chance then
			table.insert(reward, v)
		end
	end
	local randomtotal = keysx(reward)                                           -- localize
	if randomtotal == 0 then                                                    -- if 0 add at least 1 or maybe do a return
		--randomtotal = 1 -- ensure its not 0 so it doesnt throw error, you can uncomment so players get at least one
		TriggerClientEvent("vorp:TipRight", _source, T.NotifyLabels.gotNothing, 3000) -- remove if you want to allow players to receive at least 1 ?
		return                                                                  -- dont run amount is 0 , comment if the top one is uncommented
	end
	local chance2 = math.random(1, randomtotal)                                 -- if 0 the interval will be empty since minimum is 1
	local count = math.random(1, reward[chance2].amount)
	TriggerEvent("vorpCore:canCarryItems", tonumber(_source), count, function(canCarry)
		TriggerEvent("vorpCore:canCarryItem", tonumber(_source), reward[chance2].name, count, function(canCarry2)
			if canCarry and canCarry2 then
				VorpInv.addItem(_source, reward[chance2].name, count)
				TriggerClientEvent("vorp:TipRight", _source, T.NotifyLabels.yourGot .. reward[chance2].label, 3000)
			else
				TriggerClientEvent("vorp:TipRight", _source, T.NotifyLabels.fullBag .. reward[chance2].label, 3000)
			end
		end)
	end)
end)
