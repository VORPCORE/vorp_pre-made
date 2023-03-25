VorpInv = exports.vorp_inventory:vorp_inventoryApi()

local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

RegisterServerEvent("vorp_mining:pickaxecheck")
AddEventHandler("vorp_mining:pickaxecheck", function(rock)
	local _source = source
	local miningrock = rock
	local pickaxe = VorpInv.getItem(_source, Config.Pickaxe)
	if pickaxe ~= nil then
		local meta =  pickaxe["metadata"]
		if next(meta) == nil then 
			VorpInv.subItem(_source, Config.Pickaxe, 1,{})
			VorpInv.addItem(_source, Config.Pickaxe, 1,{description = "Durability = 98",durability = 99})
			TriggerClientEvent("vorp_mining:pickaxechecked", _source, miningrock)
		else
			local durability = meta.durability - 1
			local description = "Durability = "
			VorpInv.subItem(_source, Config.Pickaxe, 1,meta)
			if 0 >= durability then 
				local random = math.random(1,2)
				if random == 1 then 
					TriggerClientEvent("vorp:TipRight", _source, "Your pickaxe broke", 2000)
					TriggerClientEvent("vorp_mining:nopickaxe", _source)
				else
					VorpInv.addItem(_source, Config.Pickaxe, 1,{description = description.."1",durability = 1})
					TriggerClientEvent("vorp_mining:pickaxechecked", _source, miningrock)
				end
			else
				VorpInv.addItem(_source, Config.Pickaxe, 1,{description = description..durability,durability = durability})
				TriggerClientEvent("vorp_mining:pickaxechecked", _source, miningrock)
			end
		end
	else
		TriggerClientEvent("vorp_mining:nopickaxe", _source)
		TriggerClientEvent("vorp:TipRight", _source, "You don't have a pickaxe", 2000)
	end
end)

function keysx(table)
    local keys = 0
    for k,v in pairs(table) do
       keys = keys + 1
    end
    return keys
end

RegisterServerEvent('vorp_mining:addItem')
AddEventHandler('vorp_mining:addItem', function()
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
				TriggerClientEvent("vorp:TipRight", _source, "You found "..reward[chance2].label, 3000)
			else
				TriggerClientEvent("vorp:TipRight", _source, "You can't carry any more "..reward[chance2].label, 3000)
			end
		end)
	end) 
end)