PickupsService                        = {}
local promptGroup                     = GetRandomIntInRange(0, 0xffffff)
local T                               = TranslationInv.Langs[Lang]
local WorldPickups                    = {}
local dropAll                         = false
local lastCoords                      = {}

PickupsService.CreateObject           = function(objectHash, position)
	--TODO make it server side
	if not HasModelLoaded(objectHash) then
		RequestModel(objectHash, false)
		repeat Wait(0) until HasModelLoaded(objectHash)
	end

	local entityHandle = CreateObject(joaat(objectHash), position.x, position.y, position.z, true, false, false, false)
	repeat Wait(0) until DoesEntityExist(entityHandle)
	PlaceObjectOnGroundProperly(entityHandle, false)
	SetEntityAsMissionEntity(entityHandle, true, false)
	FreezeEntityPosition(entityHandle, true)
	SetPickupLight(entityHandle, true)
	SetEntityCollision(entityHandle, false, true)
	SetModelAsNoLongerNeeded(objectHash)
	return entityHandle
end

PickupsService.createPickup           = function(name, amount, metadata, weaponId, id)
	local playerPed   = PlayerPedId()
	local coords      = GetEntityCoords(playerPed, true, true)
	local forward     = GetEntityForwardVector(playerPed)
	local position    = vector3(coords.x + forward.x * 1.6, coords.y + forward.y * 1.6, coords.z + forward.z * 1.6)
	local pickupModel = "P_COTTONBOX01X"

	if dropAll then
		local randomOffsetX = math.random(-35, 35)
		local randomOffsetY = math.random(-35, 35)
		position = vector3(lastCoords.x + (randomOffsetX / 10.0), lastCoords.y + (randomOffsetY / 10.0), lastCoords.z)
	end

	local entityHandle = PickupsService.CreateObject(pickupModel, position)
	local data = { name = name, obj = entityHandle, amount = amount, metadata = metadata, weaponId = weaponId, position = position, id = id }

	if weaponId == 1 then
		TriggerServerEvent("vorpinventory:sharePickupServerItem", data)
	else
		TriggerServerEvent("vorpinventory:sharePickupServerWeapon", data)
	end
	PlaySoundFrontend("show_info", "Study_Sounds", true, 0)
end

PickupsService.createMoneyPickup      = function(amount)
	local playerPed   = PlayerPedId()
	local coords      = GetEntityCoords(playerPed, true, true)
	local forward     = GetEntityForwardVector(playerPed)
	local position    = vector3(coords.x + forward.x * 1.6, coords.y + forward.y * 1.6, coords.z + forward.z * 1.6)
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

PickupsService.createGoldPickup       = function(amount)
	if not Config.UseGoldItem then
		return
	end

	local playerPed   = PlayerPedId()
	local coords      = GetEntityCoords(playerPed, true, true)
	local forward     = GetEntityForwardVector(playerPed)
	local position    = vector3(coords.x + forward.x * 1.6, coords.y + forward.y * 1.6, coords.z + forward.z * 1.6)
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

PickupsService.sharePickupClient      = function(data, value)
	if value == 1 then
		if WorldPickups[data.obj] == nil then
			local label = Utils.GetLabel(data.name, data.weaponId)

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
				name = "Money ($" .. tostring(amount) .. ")",
				entityId = entityHandle,
				amount = amount,
				isMoney = true,
				isGold = false,
				coords = position,
				prompt = Prompt:New(0xF84FA74F, T.TakeFromFloor, PromptType.StandardHold, promptGroup)
			})

			pickup.prompt:SetVisible(false)
			WorldPickups[entityHandle] = pickup
		end
	else
		if WorldPickups[entityHandle] ~= nil then
			WorldPickups[entityHandle].prompt:Delete()
			Utils.TableRemoveByKey(WorldPickups, entityHandle)
		end
	end
end

PickupsService.shareGoldPickupClient  = function(entityHandle, amount, position, value)
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
		end
	else
		if WorldPickups[entityHandle] ~= nil then
			WorldPickups[entityHandle].prompt:Delete()
			Utils.TableRemoveByKey(WorldPickups, entityHandle)
		end
	end
end

PickupsService.removePickupClient     = function(entityHandle)
	SetEntityAsMissionEntity(entityHandle, false, true)
	NetworkRequestControlOfEntity(entityHandle)

	local timeout = 0
	while not NetworkHasControlOfEntity(entityHandle) and timeout < 5000 do
		timeout = timeout + 100
		if timeout >= 5000 then
			print("Failed to get Control of the Entity" .. entityHandle)
			break
		end
		Wait(100)
	end
	DeleteObject(entityHandle)
end

PickupsService.playerAnim             = function()
	local playerPed = PlayerPedId()
	local animDict  = "amb_work@world_human_box_pickup@1@male_a@stand_exit_withprop"
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)
		repeat Wait(0) until HasAnimDictLoaded(animDict)
	end

	TaskPlayAnim(playerPed, animDict, "exit_front", 1.0, 8.0, -1, 1, 0, false, false, false)
	Wait(1200)
	PlaySoundFrontend("CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", true, 1)
	Wait(1000)
	ClearPedTasks(playerPed)
end

PickupsService.DeadActions            = function()
	local playerPed = PlayerPedId()
	lastCoords = GetEntityCoords(playerPed, true, true)
	dropAll = true
	PickupsService.dropAllPlease()
end

PickupsService.dropAllPlease          = function()
	if Config.UseClearAll then
		return
	end

	if Config.DropOnRespawn.AllMoney then
		TriggerServerEvent("vorpinventory:serverDropAllMoney")
	end

	if Config.DropOnRespawn.PartMoney then
		TriggerServerEvent("vorpinventory:serverDropPartMoney")
	end

	if Config.UseGoldItem and Config.DropOnRespawn.Gold then
		TriggerServerEvent("vorpinventory:serverDropAllGold")
	end

	if Config.DropOnRespawn.Items then
		for _, item in pairs(UserInventory) do
			local itemName = item:getName()
			local itemCount = item:getCount()
			local itemMetadata = item:getMetadata()

			TriggerServerEvent("vorpinventory:serverDropItem", itemName, item.id, itemCount, itemMetadata)
		end
	end

	if Config.DropOnRespawn.Weapons then
		for index, weapon in pairs(UserWeapons) do
			TriggerServerEvent("vorpinventory:serverDropWeapon", index)

			if next(UserWeapons[index]) then
				local currentWeapon = UserWeapons[index]

				if currentWeapon:getUsed() then
					currentWeapon:setUsed(false)
					RemoveWeaponFromPed(PlayerPedId(), joaat(currentWeapon:getName()), true, 0)
				end

				UserWeapons[index] = nil
			end
		end
	end

	SetTimeout(500, function()
		dropAll = false
	end)
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

	repeat Wait(2000) until LocalPlayer.state.IsInSession

	local pressed = false
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

						TaskLookAtEntity(playerPed, pickup.entityId, 1500, 2048, 3, 0)
						local isDead = IsEntityDead(playerPed)
						pickup.prompt:SetVisible(not isDead)

						local promptSubLabel = CreateVarString(10, "LITERAL_STRING", pickup.name)
						UiPromptSetActiveGroupThisFrame(promptGroup, promptSubLabel, 0, 0, 0, 0)

						if pickup.prompt:HasHoldModeCompleted() then
							if isAnyPlayerNear() == 0 then
								if not pressed then
									pressed = true
									if pickup.isMoney then
										TriggerServerEvent("vorpinventory:onPickupMoney", pickup.entityId)
									elseif Config.UseGoldItem and pickup.isGold then
										TriggerServerEvent("vorpinventory:onPickupGold", pickup.entityId)
									else
										local data = { data = pickupsInRange, key = key }
										TriggerServerEvent("vorpinventory:onPickup", data)
									end
								end
							end
							SetTimeout(4000, function()
								pressed = false
							end)
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
