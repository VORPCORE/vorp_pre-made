local VorpCore = {}

TriggerEvent("getCore", function(core)
	VorpCore = core
end)

RegisterServerEvent("vorp_herbs:GiveReward")
AddEventHandler("vorp_herbs:GiveReward", function(destination, rewardAmount)
	local _source = source
	local coords = GetEntityCoords(GetPlayerPed(_source))
	local dist = #(coords - destination.coords)
	if dist <= 2.5 then
		if exports.vorp_inventory:canCarryItems(_source, rewardAmount) then
			if exports.vorp_inventory:canCarryItem(_source, destination.reward, rewardAmount) then
				exports.vorp_inventory:addItem(_source, destination.reward, rewardAmount)
				VorpCore.NotifyRightTip(_source, "You got "..rewardAmount.."x "..destination.name, 4000)
			else
				VorpCore.NotifyRightTip(_source, "Can't hold any more "..destination.name, 4000)
			end
		else
			VorpCore.NotifyRightTip(_source, "No more room in your bag", 4000)
		end
	end
end)