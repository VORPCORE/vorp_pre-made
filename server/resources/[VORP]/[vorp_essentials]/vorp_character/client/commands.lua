local function toggleComp(hash, item)
	local __player = PlayerPedId()
	if Citizen.InvokeNative(0xFB4891BD7578CDC1, __player, hash) then
		Citizen.InvokeNative(0xD710A5007C2AC539, __player, hash, 0)
	else
		Citizen.InvokeNative(0xD3A7B003ED343FD9, __player, item, false, false, false)
		Citizen.InvokeNative(0xD3A7B003ED343FD9, __player, item, true, true, true)
	end
	UpdateVariation(__player)
end


for key, v in pairs(Config.commands) do
	RegisterCommand(v.command, function()
		print(key, CachedComponents[key])
		toggleComp(Config.HashList[key], CachedComponents[key])
	end)
end

RegisterCommand("rings", function()
	toggleComp(0x7A6BBD0B, CachedComponents.RingLh)
	toggleComp(0xF16A1D23, CachedComponents.RingRh)
end)

RegisterCommand("belt", function()
	toggleComp(0x9B2C8B89, CachedComponents.Gunbelt)
	toggleComp(0xB6B6122D, CachedComponents.Holster)
	toggleComp(0xA6D134C6, CachedComponents.Belt)
end)

RegisterCommand("undress", function()
	local __player = PlayerPedId()
	for Category, Components in pairs(CachedComponents) do
		if Components ~= -1 then
			if Citizen.InvokeNative(0xFB4891BD7578CDC1, __player, Config.HashList[Category]) then
				Citizen.InvokeNative(0xD710A5007C2AC539, __player, Config.HashList[Category], 0)
			end
		end
	end
	UpdateVariation(__player)
end)

RegisterCommand("dress", function()
	local __player = PlayerPedId()
	for _, Components in pairs(CachedComponents) do
		if Components ~= -1 then
			Citizen.InvokeNative(0xD3A7B003ED343FD9, __player, Components, false, false, false)
			Citizen.InvokeNative(0xD3A7B003ED343FD9, __player, Components, true, true, false)
		end
	end
	UpdateVariation(__player)
end)



local InvokeNative = Citizen.InvokeNative
local BANDANA_COMPONENT = joaat("CLOTHING_ITEM_M_NECKERCHIEF_003_TINT_001")
local bandana = nil
local on = false

RegisterCommand('bandanaon', function(source, args, rawCommand)
	local __player = PlayerPedId()
	bandana = tonumber(args[1]) or bandana or BANDANA_COMPONENT
	if not on then
		on = true
		InvokeNative(0xD3A7B003ED343FD9, __player, bandana, true, true)
		InvokeNative(0xAE72E7DF013AAA61, __player, 0, joaat("BANDANA_ON_RIGHT_HAND"), 1, 0, -1.0) -- _TASK_ITEM_INTERACTION
		Citizen.Wait(750)
	end
	InvokeNative(0x66B957AAC2EAAEAB, __player, bandana, -1829635046, 0, true, 1)
	InvokeNative(0xAAB86462966168CE, __player, true)
	InvokeNative(0xCC8CA3E88256E58F, __player, false, true, true, true, false) -- _UPDATE_PED_VARIATION
end)

RegisterCommand('bandanaoff', function(source, args, rawCommand)
	local __player = PlayerPedId()
	bandana = tonumber(args[1]) or bandana or BANDANA_COMPONENT
	if on then
		on = false
		InvokeNative(0xAE72E7DF013AAA61, __player, 0, joaat("BANDANA_OFF_RIGHT_HAND"), 1, 0, -1.0) -- _TASK_ITEM_INTERACTION
		Citizen.Wait(750)
	end
	InvokeNative(0x66B957AAC2EAAEAB, __player, bandana, joaat("base"), 0, true, 1)
	InvokeNative(0xAAB86462966168CE, __player, true)
	InvokeNative(0xCC8CA3E88256E58F, __player, false, true, true, true, false) -- _UPDATE_PED_VARIATION
end)
