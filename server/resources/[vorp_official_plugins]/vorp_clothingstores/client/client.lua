StoreBlips, StorePeds, initComplete = {}, {}, false
Pedheading, DressHeading, cameraIndex = 0.0, 0.0, 0
inShop, loadingData, totalCost = false, false, 0

MenuData = {}
TriggerEvent("menuapi:getData",function(call)
    MenuData = call
end)

Citizen.CreateThread(function()
	while true do
		local delayThread, playerPed = 500, PlayerPedId()
		if initComplete and not inShop then
			local playerCoords = GetEntityCoords(playerPed)
			for k,v in pairs(Config.Stores) do
				if #(playerCoords - vector3(v.EnterStore[1], v.EnterStore[2], v.EnterStore[3])) < v.EnterStore[4] then
					delayThread = 5
					DrawText(_("PressToOpen"), 0.5, 0.9, 0.7, 0.7, 255, 255, 255, 255, true, true);
					if IsControlJustPressed(2, 0xD9D0E1C0) then
						inShop = true
						TriggerServerEvent("vorpclothingstore:getPlayerCloths");
						MoveToCoords(k)
					end
					break
				end
			end
		elseif inShop and inShop > 0 then
			delayThread = 2
			if loadingData then
				DrawText(_("LoadingOverlay"), 0.5, 0.9, 0.7, 0.7, 255, 84, 84, 255, true, true)
			else
				DrawText(_("PressGuide"), 0.5, 0.9, 0.7, 0.7, 255, 255, 255, 255, true, true);
			end
			if totalCost > 0 then; DrawText(_("CostOverlay") .. totalCost, 0.95, 0.9, 0.4, 0.4, 255, 250, 184, 255, false, true); end
			
			DisableAllControlActions(0)
			
			if IsControlJustPressed(0, 0x8FD015D8) or IsDisabledControlJustPressed(0, 0x8FD015D8) then
				cameraIndex = cameraIndex + 1;
				if (cameraIndex > 4) then
					cameraIndex = 0;
				end

				SwapCameras(cameraIndex);
			end
			if IsControlJustPressed(0, 0xD27782E3) or IsDisabledControlJustPressed(0, 0xD27782E3) then
				cameraIndex = cameraIndex - 1;
				if (cameraIndex < 0) then
					cameraIndex = 4;
				end

				SwapCameras(cameraIndex);
			end
			if IsControlPressed(0, 0x7065027D) or IsDisabledControlPressed(0, 0x7065027D) then
				DressHeading = DressHeading + 1.0;
				SetEntityHeading(playerPed, DressHeading);
			end
			if IsControlPressed(0, 0xB4E465B4) or IsDisabledControlPressed(0, 0xB4E465B4) then
				DressHeading = DressHeading - 1.0;
				SetEntityHeading(playerPed, DressHeading);
			end
			
			if IsPedDeadOrDying(playerPed) then
				EmergencyCleanup()
			end
		end
		Citizen.Wait(delayThread)
	end
end)

RegisterNetEvent("vorp:SelectedCharacter")
AddEventHandler("vorp:SelectedCharacter", function()
	local pedModel = GetHashKey("S_M_M_Tailor_01")
	LoadModel(pedModel)
	Wait(1000)
	BlipManager(true)
end)

RegisterNetEvent('vorpclothingstore:LoadYourCloths')
AddEventHandler('vorpclothingstore:LoadYourCloths', function(comps, skin)
	LoadYourCloths(comps, skin)
end)

RegisterNetEvent('vorpclothingstore:LoadYourOutfits')
AddEventHandler('vorpclothingstore:LoadYourOutfits', function(result)
	LoadYourOutfits(result)
end)

RegisterNetEvent('vorpclothingstore:startBuyCloths')
AddEventHandler('vorpclothingstore:startBuyCloths', function(state)
	startBuyCloths(state)
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		BlipManager(false)
		PedManager(false)
		EmergencyCleanup()
		Citizen.Wait(1500)
	end
end)

if Config.debugMode then -- Only called during debugMode being on, this is so we skip vorp:SelectedCharacter
	Citizen.CreateThread(function()
		Citizen.Wait(1000)
		local pedModel = GetHashKey("S_M_M_Tailor_01")
		LoadModel(pedModel)
		BlipManager(true)
	end)
end