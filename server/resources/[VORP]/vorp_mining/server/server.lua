VorpInv = exports.vorp_inventory:vorp_inventoryApi()

local VorpCore = {}

T = Translation.Langs[Lang]

TriggerEvent("getCore", function(core)
	VorpCore = core
end)

RegisterServerEvent("vorp_mining:pickaxecheck")
AddEventHandler("vorp_mining:pickaxecheck", function(rock)
	local _source = source
	local miningrock = rock
	local pickaxe = VorpInv.getItem(_source, Config.Pickaxe)
	if pickaxe ~= nil then
		local meta = pickaxe["metadata"]
		if next(meta) == nil then
			VorpInv.subItem(_source, Config.Pickaxe, 1, {})
			VorpInv.addItem(_source, Config.Pickaxe, 1,
				{ description = T.NotifyLabels.descDurabilityOne, durability = 99 })
			TriggerClientEvent("vorp_mining:pickaxechecked", _source, miningrock)
		else
			local durability = meta.durability - 1
			local description = T.NotifyLabels.descDurabilityTwo
			VorpInv.subItem(_source, Config.Pickaxe, 1, meta)
			if 0 >= durability then
				local random = math.random(1, 2)
				if random == 1 then
					TriggerClientEvent("vorp:TipRight", _source, T.NotifyLabels.brokePickaxe, 2000)
					TriggerClientEvent("vorp_mining:nopickaxe", _source)
				else
					VorpInv.addItem(_source, Config.Pickaxe, 1, { description = description .. "1", durability = 1 })
					TriggerClientEvent("vorp_mining:pickaxechecked", _source, miningrock)
				end
			else
				VorpInv.addItem(_source, Config.Pickaxe, 1,
					{ description = description .. durability, durability = durability })
				TriggerClientEvent("vorp_mining:pickaxechecked", _source, miningrock)
			end
		end
	else
		TriggerClientEvent("vorp_mining:nopickaxe", _source)
		TriggerClientEvent("vorp:TipRight", _source, T.NotifyLabels.notHavePickaxe, 2000)
	end
end)

local keysx = function(table)
	local keys = 0
	for k, v in pairs(table) do
		keys = keys + 1
	end
	return keys
end

RegisterServerEvent('vorp_mining:addItem')
AddEventHandler('vorp_mining:addItem', function()
	local _source = source
	local chance = math.random(1, 20)
	local reward = {}
	
	for k, v in pairs(Config.Items) do
		if v.chance >= chance then
			table.insert(reward, v)
		end
	end

	local randomtotal = keysx(reward)
	if randomtotal == 0 then
		TriggerClientEvent("vorp:TipRight", _source, T.NotifyLabels.gotNothing, 3000)
		return
	end

	local chance2 = math.random(1, randomtotal) -- if 0 the interval will be empty since minimum is 1
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
