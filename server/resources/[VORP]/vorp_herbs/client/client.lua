local isPicking = false
local Prompt
local Group = GetRandomIntInRange(0, 0xffffff)
local GroupName
local usedPoints = {}

local function contains(table, element)
	if table ~= 0 then
		for k, v in pairs(table) do
			if v == element then
				return true
			end
		end
	end
	return false
end

local function roundCoords(coords, decimal)
	local multiplier = 10 ^ decimal
	local x = math.floor(coords.x * multiplier + 0.5) / multiplier
	local y = math.floor(coords.y * multiplier + 0.5) / multiplier
	local z = math.floor(coords.z * multiplier + 0.5) / multiplier
	return vec3(x, y, z)
end

local function isUsedNode(coords)
	return contains(usedPoints, roundCoords(coords, 2))
end

local function GetArrayKey(array, value)
    for k,v in pairs(array) do
        if v == value then
            return k
        end
    end
end

local function CreateVarString(p0, p1, variadic)
	return Citizen.InvokeNative(0xFA925AC00EB830B9, p0, p1, variadic, Citizen.ResultAsLong())
end

local function CreatePickPrompt(promptText, controlAction)
	local str = promptText
	Prompt = PromptRegisterBegin()
	PromptSetControlAction(Prompt, controlAction)
	str = CreateVarString(10, "LITERAL_STRING", str)
	PromptSetText(Prompt, str)
	PromptSetEnabled(Prompt, false)
	PromptSetVisible(Prompt, false)
	PromptSetHoldMode(Prompt, 1000)
	PromptSetGroup(Prompt, Group)
	PromptRegisterEnd(Prompt)
end

local function PlayerPick(destination)
	if destination then
		table.insert(usedPoints, roundCoords(destination.coords, 2))
		local ped = PlayerPedId()
		TaskTurnPedToFaceCoord(ped, destination.coords, -1)
		Wait(2000)
		ClearPedTasks(ped)
		local dict = "mech_ransack@shelf@h150cm@d80cm@reach_up@pickup@vertical@right_50cm@a"
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do
			Wait(0)
		end
		TaskPlayAnim(ped, dict, "enter_rf", 8.0, 8.0, -1, 1, 0, false, false, false)
		TaskPlayAnim(ped, dict, "base", 8.0, 8.0, -1, 1, 0, false, false, false)
		RemoveAnimDict(dict)
		Wait(700)
		ClearPedTasks(ped)
		local rewardAmount = 1
		if destination.minReward and destination.maxReward then
			rewardAmount = GetRandomIntInRange(destination.minReward, destination.maxReward)
		end
		TriggerServerEvent("vorp_herbs:GiveReward", destination, rewardAmount)
		isPicking = false
		CreateThread(function()
			if destination.timeout then
				Wait(destination.timeout * 60000)
			else
				Wait(Config.Timeout * 60000)
			end
			table.remove(usedPoints, GetArrayKey(usedPoints, destination.coords))
		end)
	else

	end
end

local function CreatePlant(destination)
	if not DoesEntityExist(destination.plant) and not isUsedNode(destination.coords) then
		local plantModel = joaat(destination.plantModel)
		RequestModel(plantModel)
		while not HasModelLoaded(plantModel) do
			Citizen.Wait(0)
		end
		local plantModelObject = CreateObject(plantModel, destination.coords.x, destination.coords.y, destination.coords.z, true, true, true)
		Wait(500)
		Citizen.InvokeNative(0x9587913B9E772D29, plantModelObject, true)
		SetEntityAsMissionEntity(plantModelObject, true, true)
		destination.plant = plantModelObject
	end
end

CreateThread(function()

	CreatePickPrompt(Config.Language.PromptText, Config.ControlAction)

	while true do

		Wait(1000)

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		for k, v in pairs(Config.Locations) do
			if v.plantModel and GetDistanceBetweenCoords(pedCoords, v.coords) < 100 then
				if not DoesEntityExist(v.plant) and Citizen.InvokeNative(0xDA8B2EAF29E872E2, v.coords) then
					CreatePlant(v)
					Wait(250)
					if GetEntityHeightAboveGround(v.plant) > 0.0 then
						Citizen.InvokeNative(0x9587913B9E772D29, v.plant, true)
					end
				end
			end
			while GetDistanceBetweenCoords(pedCoords, v.coords) <= Config.MinimumDistance and not isPicking and not isUsedNode(v.coords) do
				Wait(1)
				pedCoords = GetEntityCoords(ped)
				GroupName = Config.Language.PromptGroupName .. " - " .. v.name
				GroupName = CreateVarString(10, "LITERAL_STRING", GroupName)
				PromptSetActiveGroupThisFrame(Group, GroupName)
				PromptSetEnabled(Prompt, true)
				PromptSetVisible(Prompt, true)

				if PromptHasHoldModeCompleted(Prompt) then
					isPicking = true
					PlayerPick(v)
				end

				print("test")
			end

			while GetDistanceBetweenCoords(pedCoords, v.coords) <= Config.MinimumDistance and not isPicking and isUsedNode(v.coords) do
				Wait(1)
				pedCoords = GetEntityCoords(ped)
				GroupName = Config.Language.PromptGroupName .. " - " .. v.name
				GroupName = CreateVarString(10, "LITERAL_STRING", GroupName)
				PromptSetActiveGroupThisFrame(Group, GroupName)
				PromptSetEnabled(Prompt, false)
				PromptSetVisible(Prompt, Config.ShowUsedNodePrompt)

				print("test")
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(1000)
		local itemSet = CreateItemset(true)

		local size = Citizen.InvokeNative(0x59B57C4B06531E1E, GetEntityCoords(PlayerPedId()), Config.MinimumDistance, itemSet, 3, Citizen.ResultAsInteger())

		if size > 0 then
			for index = 0, size do
				local entity = GetIndexedItemInItemset(index, itemSet)
				local coords = GetEntityCoords(entity)
				local model_hash = GetEntityModel(entity)
				for k, v in ipairs(Config.Plants) do
					local pedCoords = GetEntityCoords(PlayerPedId())
					while Config.Plants[k].hash == model_hash and not isUsedNode(coords) and GetDistanceBetweenCoords(pedCoords, coords) < Config.MinimumDistance do
						Wait(1)
						pedCoords = GetEntityCoords(PlayerPedId())
						GroupName = Config.Language.PromptGroupName .. " - " .. Config.Plants[k].name
						GroupName = CreateVarString(10, "LITERAL_STRING", GroupName)
						PromptSetActiveGroupThisFrame(Group, GroupName)
						PromptSetEnabled(Prompt, true)
						PromptSetVisible(Prompt, true)
						if PromptHasHoldModeCompleted(Prompt) then
							isPicking = true
							local fakeDestination
							if Config.Plants[k].minReward and Config.Plants[k].maxReward then
								fakeDestination = {
									coords = coords,
									minReward = Config.Plants[k].minReward,
									maxReward = Config.Plants[k].maxReward,
									reward = Config.Plants[k].reward,
									name = Config.Plants[k].name
								}
							else
								fakeDestination = {
									coords = coords,
									reward = Config.Plants[k].reward,
									name = Config.Plants[k].name
								}
							end
							PlayerPick(fakeDestination)
						end
					end
					while Config.Plants[k].hash == model_hash and isUsedNode(coords) and GetDistanceBetweenCoords(pedCoords, coords) < Config.MinimumDistance do
						Wait(1)
						pedCoords = GetEntityCoords(PlayerPedId())
						GroupName = Config.Language.PromptGroupName .. " - " .. Config.Plants[k].name
						GroupName = CreateVarString(10, "LITERAL_STRING", GroupName)
						PromptSetActiveGroupThisFrame(Group, GroupName)
						PromptSetEnabled(Prompt, false)
						PromptSetVisible(Prompt, Config.ShowUsedNodePrompt)
					end
				end
			end
		end
		if IsItemsetValid(itemSet) then
			DestroyItemset(itemSet)
		end
	end
end)