VorpInv = exports.vorp_inventory:vorp_inventoryApi()

local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

RegisterServerEvent("vorp_lumberjack:axecheck")
AddEventHandler("vorp_lumberjack:axecheck", function(tree)
	local _source = source
	local choppingtree = tree
	local Axe = VorpInv.getItem(_source, Config.Axe)
	local Axe2 = VorpInv.getItem(_source, "lumberaxe")
	if Axe ~= nil then
		local meta =  Axe["metadata"]
		if next(meta) == nil then 
			VorpInv.subItem(_source, Config.Axe, 1,{})
			VorpInv.addItem(_source, Config.Axe, 1,{description = "Durability = 98",durability = 99})
			TriggerClientEvent("vorp_lumberjack:axechecked", _source, choppingtree)
		else
			local durability = meta.durability - 1
			local description = "Durability = "
			VorpInv.subItem(_source, Config.Axe, 1,meta)
			if 0 >= durability then 
				local random = math.random(1,2)
				if random == 1 then 
					TriggerClientEvent("vorp:TipRight", _source, "Your Axe broke", 2000)
				else
					VorpInv.addItem(_source, Config.Axe, 1,{description = description.."1",durability = 1})
					TriggerClientEvent("vorp_lumberjack:axechecked", _source, choppingtree)
				end
			else
				VorpInv.addItem(_source, Config.Axe, 1,{description = description..durability,durability = durability})
				TriggerClientEvent("vorp_lumberjack:axechecked", _source, choppingtree)
			end
		end
	elseif Axe2 ~= nil then 
		local meta =  Axe2["metadata"]
		if next(meta) == nil then 
			VorpInv.subItem(_source, "lumberaxe", 1,{})
			VorpInv.addItem(_source, "lumberaxe", 1,{description = "Durability = 98",durability = 99})
			TriggerClientEvent("vorp_lumberjack:axechecked", _source, choppingtree)
		else
			local durability = meta.durability - 1
			local description = "Durability = "
			VorpInv.subItem(_source, "lumberaxe", 1,meta)
			if 0 >= durability then 
				local random = math.random(1,2)
				if random == 1 then 
					TriggerClientEvent("vorp:TipRight", _source, "Your Axe broke", 2000)
					TriggerClientEvent("vorp_lumberjack:noaxe", _source)
				else
					VorpInv.addItem(_source, "lumberaxe", 1,{description = description.."1",durability = 1})
					TriggerClientEvent("vorp_lumberjack:axechecked", _source, choppingtree)
				end
			else
				VorpInv.addItem(_source, "lumberaxe", 1,{description = description..durability,durability = durability})
				TriggerClientEvent("vorp_lumberjack:axechecked", _source, choppingtree)
			end
		end
	else
		TriggerClientEvent("vorp_lumberjack:noaxe", _source)
		TriggerClientEvent("vorp:TipRight", _source, "You don't have an axe", 2000)
	end

end)

function keysx(table)
    local keys = 0
    for k,v in pairs(table) do
       keys = keys + 1
    end
    return keys
end

RegisterServerEvent('vorp_lumberjack:addItem')
AddEventHandler('vorp_lumberjack:addItem', function()
	local _source = source
	local Character = VorpCore.getUser(_source).getUsedCharacter
	local chance =  math.random(1,10)
	local reward = {}
	for k,v in pairs(Config.Items) do 
		if v.chance >= chance then
			table.insert(reward,v)
		end
	end
	local chance2 = math.random(1,keysx(reward))
	local count = math.random(1,reward[chance2].amount)
	TriggerEvent("vorpCore:canCarryItems", tonumber(_source), count, function(canCarry)
		TriggerEvent("vorpCore:canCarryItem", tonumber(_source), reward[chance2].name,count, function(canCarry2)
			if canCarry and canCarry2 then
				VorpInv.addItem(_source, reward[chance2].name, count)
				TriggerClientEvent("vorp:TipRight", _source, "You got "..reward[chance2].label, 3000)
			else
				TriggerClientEvent("vorp:TipRight", _source, "You can't carry any more "..reward[chance2].label, 3000)
			end
		end)
	end) 
end)