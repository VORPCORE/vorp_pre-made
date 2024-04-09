PickupsService = {}
local promptGroup = GetRandomIntInRange(0, 0xffffff)
local WorldPickups = {}
local dropAll = false
local lastCoords = {}

PickupsService.CreateObject = function(model, position)
	local objectHash = joaat(model)

	if not HasModelLoaded(objectHash) then
		RequestModel(objectHash, false)
	end

	while not HasModelLoaded(objectHash) do
		Wait(0)
	end

	local entityHandle = CreateObject(objectHash, position.x, position.y, position.z, true, true, true)
	while not DoesEntityExist(entityHandle) do
		Wait(20)
	end
	Citizen.InvokeNative(0x58A850EAEE20FAA3, entityHandle)           -- PlaceObjectOnGroundProperly
	Citizen.InvokeNative(0xDC19C288082E586E, entityHandle, true, false) -- SetEntityAsMissionEntity
	Citizen.InvokeNative(0x7D9EFB7AD6B19754, entityHandle, true)     -- FreezeEntityPosition
	Citizen.InvokeNative(0x7DFB49BCDB73089A, entityHandle, true)     -- SetPickupLight
	Citizen.InvokeNative(0xF66F820909453B8C, entityHandle, false, true) -- SetEntityCollision
	SetModelAsNoLongerNeeded(objectHash)

	return entityHandle
end

PickupsService.createPickup = function(name, amount, metadata, weaponId, id)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, true, true)
	local forward = GetEntityForwardVector(playerPed)
	local position = vector3(coords.x + forward.x * 1.6, coords.y + forward.y * 1.6, coords.z + forward.z * 1.6)
	local pickupModel = "P_COTTONBOX01X"

	if dropAll then
		local randomOffsetX = math.random(-35, 35)
		local randomOffsetY = math.random(-35, 35)
		position = vector3(lastCoords.x + (randomOffsetX / 10.0), lastCoords.y + (randomOffsetY / 10.0), lastCoords.z)
	end

	local entityHandle = PickupsService.CreateObject(pickupModel, position)

	local data = {
		name = name,
		obj = entityHandle,
		amount = amount,
		metadata = metadata,
		weaponId = weaponId,
		position = position,
		id = id,
	}
	if weaponId == 1 then
		TriggerServerEvent("vorpinventory:sharePickupServerItem", data)
	else
		TriggerServerEvent("vorpinventory:sharePickupServerWeapon", data)
	end
	PlaySoundFrontend("show_info", "Study_Sounds", true, 0)
end

PickupsService.createMoneyPickup = function(amount)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, true, true)
	local forward = GetEntityForwardVector(playerPed)
	local position = vector3(coords.x + forward.x * 1.6, coords.y + forward.y * 1.6, coords.z + forward.z * 1.6)
	local pickupModel = "p_moneybag02x"

	if dropAll then
		local randomOffsetX = math.random(-35, 35)
		local randomOffsetY = math.random(-35, 35)

		position = vector3(lastCoords.x + (randomOffsetX / 10.0), lastCoords.y + (randomOffsetY / 10.0), lastCoords.z)
	end

	local entityHandle = PickupsService.CreateObject(pickupModel, position)

	TriggerServerEvent("vorpinventory:shareMoneyPickupServer", entityHandle, amount, position)
	PlaySoundFrontend("show_info", "Study_Sounds", true, 0)
end

PickupsService.createGoldPickup = function(amount)
	if not Config.UseGoldItem then
		return
	end

	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, true, true)
	local forward = GetEntityForwardVector(playerPed)
	local position = vector3(coords.x + forward.x * 1.6, coords.y + forward.y * 1.6, coords.z + forward.z * 1.6)
	local pickupModel = "s_pickup_goldbar01x"

	if dropAll then
		local randomOffsetX = math.random(-35, 35)
		local randomOffsetY = math.random(-35, 35)

		position = vector3(lastCoords.x + (randomOffsetX / 10.0), lastCoords.y + (randomOffsetY / 10.0), lastCoords.z)
	end

	local entityHandle = PickupsService.CreateObject(pickupModel, position)

	TriggerServerEvent("vorpinventory:shareGoldPickupServer", entityHandle, amount, position)
	PlaySoundFrontend("show_info", "Study_Sounds", true, 0)
end

PickupsService.sharePickupClient = function(data, value)
	if value == 1 then
		if WorldPickups[data.obj] == nil then
			local label = Utils.GetHashreadableLabel(data.name, data.weaponId)

			local pickup = Pickup:New({
				name     = (data.amount > 1) and label .. " x " .. tostring(data.amount) or label,
				entityId = data.obj,
				amount   = data.amount,
				metadata = data.metadata,
				weaponId = data.weaponId,
				coords   = data.position,
				prompt   = Prompt:New(0xF84FA74F, T.TakeFromFloor, PromptType.StandardHold, promptGroup),
				uid      = data.uid

			})
			pickup.prompt:SetVisible(false)
			WorldPickups[data.obj] = pickup
			if Config.Debug then
				print('Item pickup added: ' .. tostring(pickup.name))
			end
		end
	else
		if WorldPickups[data.obj] ~= nil then
			WorldPickups[data.obj].prompt:Delete()
			Utils.TableRemoveByKey(WorldPickups, data.obj)
		end
	end
end

PickupsService.shareMoneyPickupClient = function(entityHandle, amount, position, value)
	if value == 1 then
		if WorldPickups[entityHandle] == nil then
			local pickup = Pickup:New({
				name = "Money (" .. tostring(amount) .. ")",
				entityId = entityHandle,
				amount = amount,
				isMoney = true,
				isGold = false,
				coords = position,
				prompt = Prompt:New(0xF84FA74F, T.TakeFromFloor, PromptType.StandardHold, promptGroup)
			})

			pickup.prompt:SetVisible(false)
			WorldPickups[entityHandle] = pickup
			if Config.Debug then
				print('Money pickup added: ' .. tostring(pickup.name))
			end
		end
	else
		if WorldPickups[entityHandle] ~= nil then
			WorldPickups[entityHandle].prompt:Delete()
			Utils.TableRemoveByKey(WorldPickups, entityHandle)
		end
	end
end

PickupsService.shareGoldPickupClient = function(entityHandle, amount, position, value)
	if value == 1 then
		if WorldPickups[entityHandle] == nil then
			local pickup = Pickup:New({
				name = "Gold (" .. tostring(amount) .. ")",
				entityId = entityHandle,
				amount = amount,
				isMoney = false,
				isGold = true,
				coords = position,
				prompt = Prompt:New(0xF84FA74F, T.TakeFromFloor, PromptType.StandardHold, promptGroup)
			})


			pickup.prompt:SetVisible(false)
			WorldPickups[entityHandle] = pickup
			if Config.Debug then
				print('Gold pickup added: ' .. tostring(pickup.name))
			end
		end
	else
		if WorldPickups[entityHandle] ~= nil then
			WorldPickups[entityHandle].prompt:Delete()
			Utils.TableRemoveByKey(WorldPickups, entityHandle)
		end
	end
end

PickupsService.removePickupClient = function(entityHandle)
	Citizen.InvokeNative(0xDC19C288082E586E, entityHandle, false, true) -- SetEntityAsMissionEntity
	NetworkRequestControlOfEntity(entityHandle)
	local timeout = 0

	while not NetworkHasControlOfEntity(entityHandle) and timeout < 5000 do
		timeout = timeout + 100
		if timeout == 5000 then
			if Config.Debug then
				print("Failed to get Control of the Entity")
			end
		end
		Wait(100)
	end

	FreezeEntityPosition(entityHandle, false)
	Citizen.InvokeNative(0x7DFB49BCDB73089A, entityHandle, false) -- SetPickupLight
	DeleteObject(entityHandle)
end

PickupsService.playerAnim = function(obj)
	local playerPed = PlayerPedId()
	local animDict = "amb_work@world_human_box_pickup@1@male_a@stand_exit_withprop"
	RequestAnimDict(animDict)

	while not HasAnimDictLoaded(animDict) do
		Wait(10)
	end

	TaskPlayAnim(playerPed, animDict, "exit_front", 1.0, 8.0, -1, 1, 0, false, false, false)
	Wait(1200)
	PlaySoundFrontend("CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", true, 1)
	Wait(1000)
	ClearPedTasks(playerPed)
end

PickupsService.DeadActions = function()
	local playerPed = PlayerPedId()
	lastCoords = GetEntityCoords(playerPed, true, true)
	dropAll = true
	PickupsService.dropAllPlease()
end

PickupsService.dropAllPlease = function()
	Wait(200)

	if Config.UseClearAll then
		return
	end

	if Config.DropOnRespawn.AllMoney then
		TriggerServerEvent("vorpinventory:serverDropAllMoney")
		Wait(200)
	end

	if Config.DropOnRespawn.PartMoney then
		TriggerServerEvent("vorpinventory:serverDropPartMoney")
		Wait(200)
	end

	if Config.UseGoldItem and Config.DropOnRespawn.Gold then
		TriggerServerEvent("vorpinventory:serverDropAllGold")
		Wait(200)
	end

	if Config.DropOnRespawn.Items then
		for _, item in pairs(UserInventory) do
			local itemName = item:getName()
			local itemCount = item:getCount()
			local itemMetadata = item:getMetadata()

			TriggerServerEvent("vorpinventory:serverDropItem", itemName, item.id, itemCount, itemMetadata)
			Wait(200)
		end
	end

	if Config.DropOnRespawn.Weapons then
		for index, weapon in pairs(UserWeapons) do
			TriggerServerEvent("vorpinventory:serverDropWeapon", index)

			if next(UserWeapons[index]) ~= nil then
				local currentWeapon = UserWeapons[index]

				if currentWeapon:getUsed() then
					currentWeapon:setUsed(false)
					RemoveWeaponFromPed(PlayerPedId(), joaat(currentWeapon:getName()), true, 0)
				end

				UserWeapons[index] = nil
				Wait(200)
			end
		end
	end

	Wait(200)
	dropAll = false
end

CreateThread(function()
	local function isAnyPlayerNear()
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed, true, true)
		local players = GetActivePlayers()
		local count = 0
		for _, player in ipairs(players) do
			local targetPed = GetPlayerPed(player)
			if player ~= PlayerId() then
				local targetCoords = GetEntityCoords(targetPed, true, true)
				local distance = #(playerCoords - targetCoords)
				if distance < 2.0 then
					count = count + 1
				end
			end
		end

		return count
	end

	repeat Wait(0) until LocalPlayer.state.IsInSession

	while true do
		local sleep = 1000
		if not InInventory then
			if next(WorldPickups) then
				local playerPed = PlayerPedId()
				local pickupsInRange = {}

				for key, value in pairs(WorldPickups) do
					if value:IsInRange() then
						table.insert(pickupsInRange, value)
					end
				end

				table.sort(pickupsInRange, function(left, right)
					return left:Distance() < right:Distance()
				end)

				for key, pickup in pairs(pickupsInRange) do
					if pickup:Distance() <= 1.2 then
						sleep = 0
						Citizen.InvokeNative(0x69F4BE8C8CC4796C, playerPed, pickup.entityId, 3000, 2048, 3) -- TaskLookAtEntity
						local isDead = IsEntityDead(playerPed)
						pickup.prompt:SetVisible(not isDead)

						local promptSubLabel = CreateVarString(10, "LITERAL_STRING", pickup.name)
						PromptSetActiveGroupThisFrame(promptGroup, promptSubLabel, 1)

						if pickup.prompt:HasHoldModeCompleted() then
							if isAnyPlayerNear() == 0 then
								if pickup.isMoney then
									TriggerServerEvent("vorpinventory:onPickupMoney", pickup.entityId)
								elseif Config.UseGoldItem and pickup.isGold then
									TriggerServerEvent("vorpinventory:onPickupGold", pickup.entityId)
								else
									local data = { data = pickupsInRange, key = key }
									TriggerServerEvent("vorpinventory:onPickup", data)
								end
							end
							Wait(1000)
						end
					else
						if pickup.prompt:GetEnabled() then
							pickup.prompt:SetVisible(false)
						end
					end
				end
			end
		end
		Wait(sleep)
	end
end)
