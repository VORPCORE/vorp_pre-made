--######################### edit for VORP by: outsider ########################
local prompts = GetRandomIntInRange(0, 0xffffff)
local openmenu
local inmenu = false
local stops = Config.Stops
CURRENT_TRAIN = nil
local trainspawned = false
local trainrunning = false
local npcs = {}
MenuData = {}
local PlayerJob

TriggerEvent("menuapi:getData", function(call)
	MenuData = call
end)

AddEventHandler('menuapi:closemenu', function()
	if inmenu then
		inmenu = false
	end
end)

function InsertNpcs()
	for z, x in pairs(Config.RailroadNpc) do
		while not HasModelLoaded(GetHashKey(Config.RailroadNpc[z]["Model"])) do
			Wait(500)
			Modelrequest(GetHashKey(Config.RailroadNpc[z]["Model"]))
		end
		local npc = CreatePed(GetHashKey(Config.RailroadNpc[z]["Model"]), Config.RailroadNpc[z]["Pos"].x, Config.RailroadNpc[z]["Pos"].y, Config.RailroadNpc[z]["Pos"].z, Config.RailroadNpc[z]["Heading"], false, false, 0, 0)
		while not DoesEntityExist(npc) do
			Wait(300)
		end
		Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
		FreezeEntityPosition(npc, false)
		SetEntityInvincible(npc, true)
		TaskStandStill(npc, -1)
		Wait(100)
		SET_PED_RELATIONSHIP_GROUP_HASH(npc, GetHashKey(Config.RailroadNpc[z]["Model"]))
		SetEntityCanBeDamagedByRelationshipGroup(npc, false, GetHashKey("PLAYER"))
		SetEntityAsMissionEntity(npc, true, true)
		SetModelAsNoLongerNeeded(GetHashKey(Config.RailroadNpc[z]["Model"]))
		table.insert(npcs, { npc = npc, coords = x.Pos })
	end
end

Citizen.CreateThread(function()
	Citizen.Wait(5000)
	local str = Press
	openmenu = PromptRegisterBegin()
	PromptSetControlAction(openmenu, 0x760A9C6F) -- G
	str = CreateVarString(10, 'LITERAL_STRING', str)
	PromptSetText(openmenu, str)
	PromptSetEnabled(openmenu, 1)
	PromptSetVisible(openmenu, 1)
	PromptSetStandardMode(openmenu, 1)
	PromptSetHoldMode(openmenu, 1)
	PromptSetGroup(openmenu, prompts)
	Citizen.InvokeNative(0xC5F428EE08FA7F2C, openmenu, true)
	PromptRegisterEnd(openmenu)
end)



Citizen.CreateThread(function()
	InsertNpcs()
	while true do
		Citizen.Wait(0)

		local player = PlayerPedId()
		local sleep = true
		local playercoords = GetEntityCoords(player)


		if not inmenu then
			TriggerServerEvent("get:PlayerJob") -- run client side check before check for distance. no need to run code that is not meant for the client its optimized this way
			if PlayerJob == Config.Job then
				local dist = Vdist2(playercoords, Config.Location, true) --location
				if 2.0 > dist then
					sleep = false
					local label = CreateVarString(10, 'LITERAL_STRING', TrainPrompt)
					PromptSetActiveGroupThisFrame(prompts, label)
					if Citizen.InvokeNative(0xC92AC953F0A982AE, openmenu) then
						inmenu = true
						--TriggerServerEvent("get:PlayerJob")
						TrainMenu()

					end
				end
			end
		end
		if sleep then
			Citizen.Wait(500)
		end
	end
end)

function TrainMenu()
	MenuData.CloseAll()
	local elements = Config.Elements

	MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
		{
			title    = MenuTittle,
			subtext  = MenuSubTittle,
			align    = 'top-left',
			elements = elements,
		},

			function(data, menu)
			if (data.current.value == 'hash1') then
				StartTrain(data.current.info)
			elseif (data.current.value == 'hash2') then
				StartTrain(data.current.info)
			elseif (data.current.value == 'hash3') then
				StartTrain(data.current.info)
			elseif (data.current.value == 'hash4') then
				StartTrain(data.current.info)
			elseif (data.current.value == 'hash5') then
				StartTrain(data.current.info)
			elseif (data.current.value == 'hash6') then
				StartTrain(data.current.info)
			elseif (data.current.value == 'hash7') then
				StartTrain(data.current.info)
			elseif (data.current.value == 'hash8') then
				StartTrain(data.current.info)
			elseif (data.current.value == 'hash9') then
				StartTrain(data.current.info)
			elseif (data.current.value == 'hash10') then
				StartTrain(data.current.info)
			elseif (data.current.value == 'hash11') then
				StartTrain(data.current.info)
			elseif (data.current.value == 'hash12') then
				StartTrain(data.current.info)
			elseif (data.current.value == 'hash13') then
				StartTrain(data.current.info)
			elseif (data.current.value == 'hash14') then
				StartTrain(data.current.info)
			end
		
		end,


		function(data, menu)
			menu.close()

		end)
end

function StartTrain(hash)

	if trainspawned == false then
		SetRandomTrains(false)
		--requestmodel--
		local trainWagons = N_0x635423d55ca84fc8(hash)
		for wagonIndex = 0, trainWagons - 1 do
			local trainWagonModel = N_0x8df5f6a19f99f0d5(hash, wagonIndex)
			while not HasModelLoaded(trainWagonModel) do
				Citizen.InvokeNative(0xFA28FE3A6246FC30, trainWagonModel, 1)
				Citizen.Wait(100)
			end
		end
		--spawn train--
		local train = N_0xc239dbd9a57d2a71(hash, GetEntityCoords(PlayerPedId()), 0, 1, 1, 1)
		SetTrainSpeed(train, 0.0)
		local coords = GetEntityCoords(train)
		local trainV = vector3(coords.x, coords.y, coords.z)
		-- warp ped into train (valentine)
		DoScreenFadeOut(500)
		Wait(1000)
		Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), -167.4587, 622.33398, 114.6397 - 1, 141.77737)
		Wait(1000)
		DoScreenFadeIn(500)
		SetModelAsNoLongerNeeded(train)
		--blip--
		local bliphash = -399496385
		local blip = Citizen.InvokeNative(0x23f74c2fda6e7c61, bliphash, train) -- blip for train
		SetBlipScale(blip, 1.5)
		CURRENT_TRAIN = train
		trainspawned = true
		trainrunning = true
	else
		TriggerEvent("vorp:TipRight", "train is already out, check map!", 3000)
	end

end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if trainrunning == true then
			for i = 1, #stops do
				local coords = GetEntityCoords(CURRENT_TRAIN)
				local trainV = vector3(coords.x, coords.y, coords.z)
				local distance = #(vector3(stops[i]["x"], stops[i]["y"], stops[i]["z"]) - trainV)

				--speed--
				local stopspeed = 0.0
				local cruisespeed = 5.0
				local fullspeed = 15.0
				

				if distance < stops[i]["dst"] then
					SetTrainCruiseSpeed(CURRENT_TRAIN, cruisespeed)
					Wait(200)
					if distance < stops[i]["dst2"] then
						SetTrainCruiseSpeed(CURRENT_TRAIN, stopspeed)
						Wait(stops[i]["time"])
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 10, 'allaboard', 1.0)
						Wait(10000)
						SetTrainCruiseSpeed(CURRENT_TRAIN, cruisespeed)
						Wait(10000)
					end
				elseif distance > stops[i]["dst"] then
					SetTrainCruiseSpeed(CURRENT_TRAIN, fullspeed)
					Wait(25)
				end
			end
		end
	end
end)

RegisterNetEvent("send:PlayerJob")
AddEventHandler("send:PlayerJob", function(Job)
	PlayerJob = Job

end)
-- delete all
AddEventHandler("onResourceStop", function(resourceName)
	if resourceName == GetCurrentResourceName() then
		if inmenu == true then
			PromptDelete(openmenu) -- delete prompt
			MenuData.CloseAll() --close menu
		end

		for _, v in pairs(npcs) do
			DeleteEntity(v.npc)
			DeletePed(v.npc)
			SetEntityAsNoLongerNeeded(v.npc)
		end

		DeleteEntity(CURRENT_TRAIN) --delete train
		trainspawned = false
		trainrunning = false
	end
end)

-- delete train
RegisterCommand('deletetrain', function()
	if PlayerJob == Config.Job then
		DeleteEntity(CURRENT_TRAIN)
		trainspawned = false
		trainrunning = false
	end
end)

-- reset train
RegisterCommand('resettrain', function()
	if PlayerJob == Config.Job then
		DeleteEntity(CURRENT_TRAIN)
		trainspawned = false
		trainrunning = false
		DoScreenFadeOut(500)
		Wait(1000)
		Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), -163.1477, 637.15832, 114.03209 - 1, 337.03866) --tp back to valentine
		Wait(1000)
		DoScreenFadeIn(500)
	end
end)


RegisterCommand('fullspeed', function()
	local stopspeed = 0.0
	local cruisespeed = 25.0
	SetTrainCruiseSpeed(CURRENT_TRAIN, cruisespeed)
end)

RegisterCommand("stoptrain", function()
	local stopspeed = 0.0
	SetTrainCruiseSpeed(CURRENT_TRAIN, stopspeed)
end)

RegisterCommand("halfspeed", function()
	local stopspeed = 17.0
	SetTrainCruiseSpeed(CURRENT_TRAIN, stopspeed)
end)

RegisterCommand("slowspeed", function()
	local stopspeed = 10.0
	SetTrainCruiseSpeed(CURRENT_TRAIN, stopspeed)
end)

RegisterCommand("reverse", function()
	local stopspeed = -15.0
	SetTrainCruiseSpeed(CURRENT_TRAIN, stopspeed)
end)