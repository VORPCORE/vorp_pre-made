local CamWardrove, CamUp, CamMid, CamBot, playerSex
local outfits_db, MyOutfits, ClothesDB, SkinsDB, originalOutfit, VORPcore = {}, {}, {}, {}, {}, {}

T = TranslationCloth.Langs[Lang]

TriggerEvent("getCore", function(core) -- Only using for bucket routing ATM
	VORPcore = core
end)

local instanceNumber = 4957975

local clothesPlayer = {
	Hat = 0,
	Mask = 0,
	EyeWear = 0,
	NeckWear = 0,
	NeckTies = 0,
	Shirt = 0,
	Suspender = 0,
	Vest = 0,
	Coat = 0,
	Poncho = 0,
	Cloak = 0,
	Glove = 0,
	RingRh = 0,
	RingLh = 0,
	Bracelet = 0,
	Gunbelt = 0,
	Belt = 0,
	Buckle = 0,
	Holster = 0,
	Pant = 0,
	Skirt = 0,
	Chap = 0,
	Boots = 0,
	Spurs = 0,
	Spats = 0,
	Gauntlets = 0,
	Loadouts = 0,
	Accessories = 0,
	Satchels = 0,
	GunbeltAccs = 0,
	CoatClosed = 0,
	HairAccessories = 0
};

function LoadModel(model)
	if Citizen.InvokeNative(0x392C8D8E07B70EFC, model) then
		Citizen.InvokeNative(0xFA28FE3A6246FC30, model)
		while not HasModelLoaded(model) do
			Citizen.Wait(100)
		end
		PedManager(model)
	else
		print("Error: Model is not valid! If you changed pedModel revert to original or verify correct name.")
		return false
	end
end

function BlipManager(action)
	if action then
		for k, v in pairs(Config.Stores) do
			local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300,
				vector3(v.EnterStore[1], v.EnterStore[2], v.EnterStore[3]))
			SetBlipSprite(blip, v.BlipIcon)
			SetBlipScale(blip, 0.2)
			Citizen.InvokeNative(0x9CB1A1623062F402, blip, v.name)
			StoreBlips[#StoreBlips + 1] = blip
		end
	else
		for k, v in pairs(StoreBlips) do
			RemoveBlip(v)
		end
	end
end

function PedManager(action)
	if action then
		for k, v in pairs(Config.Stores) do
			local ped = CreatePed(action, vector4(v.NPCStore), false, true, true)
			Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
			SetEntityNoCollisionEntity(PlayerPedId(), ped, false)
			SetEntityCanBeDamaged(ped, false)
			SetEntityInvincible(ped, true)
			SetBlockingOfNonTemporaryEvents(ped, true)
			Citizen.Wait(1000)
			FreezeEntityPosition(ped, true)
			StorePeds[k] = ped
		end
		initComplete = true
	else
		for k, v in pairs(StorePeds) do
			DeletePed(v)
		end
	end
end

function EmergencyCleanup() -- Only called if the player dies inside the shops or is inside on resource restart
	if inShop then
		local PedExitx = Config.Stores[inShop].ExitWardrobe[1]
		local PedExity = Config.Stores[inShop].ExitWardrobe[2]
		local PedExitz = Config.Stores[inShop].ExitWardrobe[3]
		local PedExitheading = Config.Stores[inShop].ExitWardrobe[4]
		MenuData.CloseAll()
		SetCamActive(CamWardrove, false);
		RenderScriptCams(false, true, 1000, true, true, 0);
		Citizen.Wait(250);
		DestroyCam(CamWardrove, true);
		FreezeEntityPosition(PlayerPedId(), false);
		DisplayRadar(true)
		DisplayHud(true)
		TriggerEvent("vorp:showUi", true)
		SetEntityCoords(PlayerPedId(), PedExitx, PedExity, PedExitz, false, false, false, false);
		SetEntityHeading(PlayerPedId(), PedExitheading);
		VORPcore.instancePlayers(0)
		inShop, totalCost = false, 0
	end
end

function DrawText(text, x, y, fScale, fSize, rC, gC, bC, aC, tCentered, shadow)
	local str = CreateVarString(10, "LITERAL_STRING", text)
	SetTextScale(fScale, fSize)
	SetTextColor(rC, gC, bC, aC)
	SetTextCentre(tCentered)
	if shadow then SetTextDropshadow(1, 0, 0, 255); end
	Citizen.InvokeNative(0xADA9255D, 1)
	DisplayText(str, x, y)
end

function MoveToCoords(loc)
	inShop = loc
	local playerPed = PlayerPedId()
	local Pedx = Config.Stores[inShop].NPCStore[1]
	local Pedy = Config.Stores[inShop].NPCStore[2]
	local Pedz = Config.Stores[inShop].NPCStore[3]
	Pedheading = Config.Stores[inShop].NPCStore[4]
	local Doorx = Config.Stores[inShop].DoorRoom[1]
	local Doory = Config.Stores[inShop].DoorRoom[2]
	local Doorz = Config.Stores[inShop].DoorRoom[3]
	local Playerx = Config.Stores[inShop].StoreRoom[1]
	local Playery = Config.Stores[inShop].StoreRoom[2]
	local Playerz = Config.Stores[inShop].StoreRoom[3]
	local Playerheading = Config.Stores[inShop].StoreRoom[4]
	DressHeading = Playerheading;
	local CameraMainx = Config.Stores[inShop].Cameras[1][1]
	local CameraMainy = Config.Stores[inShop].Cameras[1][2]
	local CameraMainz = Config.Stores[inShop].Cameras[1][3]
	local CameraMainRotx = Config.Stores[inShop].Cameras[1][4]
	local CameraMainRoty = Config.Stores[inShop].Cameras[1][5]
	local CameraMainRotz = Config.Stores[inShop].Cameras[1][6]

	local CameraChestx = Config.Stores[inShop].Cameras[2][1]
	local CameraChesty = Config.Stores[inShop].Cameras[2][2]
	local CameraChestz = Config.Stores[inShop].Cameras[2][3]
	local CameraChestRotx = Config.Stores[inShop].Cameras[2][4]
	local CameraChestRoty = Config.Stores[inShop].Cameras[2][5]
	local CameraChestRotz = Config.Stores[inShop].Cameras[2][6]

	local CameraBeltx = Config.Stores[inShop].Cameras[3][1]
	local CameraBelty = Config.Stores[inShop].Cameras[3][2]
	local CameraBeltz = Config.Stores[inShop].Cameras[3][3]
	local CameraBeltRotx = Config.Stores[inShop].Cameras[3][4]
	local CameraBeltRoty = Config.Stores[inShop].Cameras[3][5]
	local CameraBeltRotz = Config.Stores[inShop].Cameras[3][6]

	local CameraBootsx = Config.Stores[inShop].Cameras[4][1]
	local CameraBootsy = Config.Stores[inShop].Cameras[4][2]
	local CameraBootsz = Config.Stores[inShop].Cameras[4][3]
	local CameraBootsRotx = Config.Stores[inShop].Cameras[4][4]
	local CameraBootsRoty = Config.Stores[inShop].Cameras[4][5]
	local CameraBootsRotz = Config.Stores[inShop].Cameras[4][6]

	VORPcore.instancePlayers(tonumber(GetPlayerServerId(PlayerId())) + instanceNumber)

	ClearPedTasksImmediately(StorePeds[inShop], 1, 1);
	FreezeEntityPosition(StorePeds[inShop], false);

	Citizen.Wait(1000);
	NetworkSetInSpectatorMode(true, playerPed);

	DisplayRadar(false)
	DisplayHud(false)
	TriggerEvent("vorp:showUi", false)

	local pedModel = GetHashKey("S_M_M_Tailor_01")
	local PedWardrobe = CreatePed(pedModel, Doorx, Doory, Doorz, 0.0, false, true, true, true);
	Citizen.InvokeNative(0x283978A15512B2FE, PedWardrobe, true);
	SetModelAsNoLongerNeeded(pedModel);
	SetEntityAlpha(PedWardrobe, 0, true);
	Citizen.Wait(1000);
	TaskGoToEntity(StorePeds[inShop], PedWardrobe, 15000, 0.5, 1.1, 1.0, 1);
	Citizen.Wait(4000);
	TaskGoToEntity(playerPed, PedWardrobe, 10000, 0.5, 0.8, 1.0, 1);
	Citizen.Wait(6500);

	DoScreenFadeOut(1800);
	Citizen.Wait(2000);
	ClearPedTasksImmediately(playerPed, 1, 1);

	SetEntityCoords(playerPed, Playerx, Playery, Playerz, false, false, false, false);
	SetEntityHeading(playerPed, Playerheading);
	Citizen.Wait(100);
	FreezeEntityPosition(playerPed, true);
	SetEntityCoords(StorePeds[inShop], Pedx, Pedy, Pedz, false, false, false, false);
	SetEntityHeading(StorePeds[inShop], Pedheading);

	Citizen.Wait(2000);

	CamWardrove = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", CameraMainx, CameraMainy, CameraMainz, CameraMainRotx,
		CameraMainRoty, CameraMainRotz, 50.00, false, 0);
	CamUp = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", CameraChestx, CameraChesty, CameraChestz, CameraChestRotx,
		CameraChestRoty, CameraChestRotz, 50.00, false, 0);
	CamMid = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", CameraBeltx, CameraBelty, CameraBeltz, CameraBeltRotx,
		CameraBeltRoty, CameraBeltRotz, 50.00, false, 0);
	CamBot = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", CameraBootsx, CameraBootsy, CameraBootsz, CameraBootsRotx,
		CameraBootsRoty, CameraBootsRotz, 50.00, false, 0);

	SetCamActive(CamWardrove, true);
	RenderScriptCams(true, true, 500, true, true, 0);
	FreezeEntityPosition(StorePeds[inShop], true);
	Citizen.Wait(1000);
	DoScreenFadeIn(1000);
	DeletePed(PedWardrobe);
	NetworkSetInSpectatorMode(false, playerPed);
	playerSex = string.gsub(tostring(SkinsDB["sex"]), "mp_", "")
	MainClothingMenu()
end

function SetOutfit(index)
	TriggerServerEvent("vorpclothingstore:setOutfit", MyOutfits[index].comps);
	-- for k,v in pairs(MyOutfits[index].comps) do
	-- clothesPlayer[k] = v
	-- end
	startBuyCloths(false)
end

function LoadYourCloths(cloths, skins)
	ClothesDB, SkinsDB = json.decode(cloths), json.decode(skins)
	for k, v in pairs(ClothesDB) do
		clothesPlayer[k] = v
		originalOutfit[k] = v
	end
end

function DeleteOutfit(index, dbId)
	TriggerServerEvent("vorpclothingstore:deleteOutfit", dbId);
	MyOutfits[index] = nil
end

function LoadYourOutfits(outfits)
	MyOutfits = {}
	for k, v in pairs(outfits) do
		MyOutfits[k] = { title = v.title, comps = v.comps, dbId = v.id }
	end
end

function SwapCameras(index)
	if index == 0 then
		SetCamActive(CamWardrove, true);
		SetCamActive(CamBot, false);
		SetCamActive(CamUp, false);
		RenderScriptCams(true, true, 200, true, true, 0);
	elseif index == 1 then
		SetCamActive(CamUp, true);
		SetCamActive(CamWardrove, false);
		SetCamActive(CamMid, false);
		RenderScriptCams(true, true, 200, true, true, 0);
	elseif index == 2 then
		SetCamActive(CamMid, true);
		SetCamActive(CamUp, false);
		SetCamActive(CamBot, false);
		RenderScriptCams(true, true, 200, true, true, 0);
	elseif index == 3 then
		SetCamActive(CamBot, true);
		SetCamActive(CamMid, false);
		SetCamActive(CamWardrove, false);
		RenderScriptCams(true, true, 200, true, true, 0);
	end
end

function FinishBuy(buy, cost)
	local saveOutfit, outfitName = false, ""
	if buy then
		TriggerEvent("vorpinputs:getInput", T.ButtonNewOutfit, T.PlaceHolderNewOutfit, function(result)
			if result ~= "" or result then
				outfitName = result
				saveOutfit = true
			end

			TriggerServerEvent("vorpclothingstore:buyPlayerCloths", cost, json.encode(clothesPlayer), saveOutfit,
				outfitName);
			return
		end)
	end
end

function startBuyCloths(state)
	if not state then
		MenuData.CloseAll()
	else
		--TriggerServerEvent("vorpcharacter:getPlayerSkin"); when finished its sending alreadu an event to characters
	end
	local PedExitx = Config.Stores[inShop].ExitWardrobe[1]
	local PedExity = Config.Stores[inShop].ExitWardrobe[2]
	local PedExitz = Config.Stores[inShop].ExitWardrobe[3]
	local PedExitheading = Config.Stores[inShop].ExitWardrobe[4]

	DoScreenFadeOut(1000);
	Citizen.Wait(2000);
	if not state then ExecuteCommand("rc"); end
	SetCamActive(CamWardrove, false);
	RenderScriptCams(false, true, 1000, true, true, 0);
	Citizen.Wait(1000);
	DestroyCam(CamWardrove, true);
	FreezeEntityPosition(PlayerPedId(), false);

	SetEntityCoords(PlayerPedId(), PedExitx, PedExity, PedExitz, false, false, false, false);
	SetEntityHeading(PlayerPedId(), PedExitheading);

	DisplayRadar(true)
	DisplayHud(true)
	TriggerEvent("vorp:showUi", true)

	VORPcore.instancePlayers(0)

	DoScreenFadeIn(1000);
	inShop = false
	totalCost = 0
end

function PreviewOutfit(index)
	local playerPed, clothData = PlayerPedId()
	loadingData = true

	if not index then -- When we return from a menu without confirming, set clothes back to original states
		clothData = clothesPlayer
	else
		clothData = json.decode(MyOutfits[index].comps)
	end

	for k, v in pairs(clothData) do
		local catHash = CategoryDBName[k]
		if playerSex == "male" then
			if v <= 0 then
				if catHash == 0xE06D30CE then
					Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, 0x662AC34, 0)
				end
				Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, catHash, 0);
				Citizen.InvokeNative(0xCC8CA3E88256E58F, playerPed, 0, 1, 1, 1, 0);
			else
				if catHash == 0xE06D30CE then
					Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, 0x662AC34, 0)
					Citizen.InvokeNative(0xCC8CA3E88256E58F, playerPed, 0, 1, 1, 1, 0);
				end
				Citizen.InvokeNative(0x59BD177A1A48600A, playerPed, catHash);
				Citizen.InvokeNative(0xD3A7B003ED343FD9, playerPed, v, true, false, false);
				Citizen.InvokeNative(0xD3A7B003ED343FD9, playerPed, v, true, true, false);
			end
		else
			if v <= 0 then
				Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, catHash, 0);
				Citizen.InvokeNative(0xCC8CA3E88256E58F, playerPed, 0, 1, 1, 1, 0);
			else
				Citizen.InvokeNative(0x59BD177A1A48600A, playerPed, catHash);
				Citizen.InvokeNative(0xD3A7B003ED343FD9, playerPed, v, true, false, true);
				Citizen.InvokeNative(0xD3A7B003ED343FD9, playerPed, v, true, true, true);
			end
		end
		Citizen.Wait(5)
	end
	loadingData = false
end

function SetPlayerComponent(menuVal, catName, rawCat)
	local catHash = CategoryHashes[catName]       -- Ex. "0x9925C067"
	local playerPed = PlayerPedId()
	local clothPlay = CategoryClothesPlayer[catName] -- Ex. "RingRh" - Match original category names in DB

	if clothPlay == "Coat" then                   -- Carried over from original code, probably necessary
		Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, 0x0662AC34, 0);
		Citizen.InvokeNative(0xCC8CA3E88256E58F, playerPed, 0, 1, 1, 1, 0);
		clothesPlayer["CoatClosed"] = -1
	elseif clothPlay == "CoatClosed" then
		if playerSex == "male" then Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, 0x662AC34, 0); end -- Only applies to males it seems
		Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, 0xE06D30CE, 0);
		Citizen.InvokeNative(0xCC8CA3E88256E58F, playerPed, 0, 1, 1, 1, 0);
		clothesPlayer["Coat"] = -1
	elseif clothPlay == "Spurs" then
		Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, 0x514ADCEA, 0);
		Citizen.InvokeNative(0xCC8CA3E88256E58F, playerPed, 0, 1, 1, 1, 0);
		clothesPlayer["Spats"] = -1
	elseif clothPlay == "Spats" then
		Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, 0x18729F39, 0);
		Citizen.InvokeNative(0xCC8CA3E88256E58F, playerPed, 0, 1, 1, 1, 0);
		clothesPlayer["Spurs"] = -1
	end

	if playerSex == "male" then
		if menuVal <= 0 then
			if catHash == 0xE06D30CE then
				Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, 0x662AC34, 0)
			end
			Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, catHash, 0);
			Citizen.InvokeNative(0xCC8CA3E88256E58F, playerPed, 0, 1, 1, 1, 0);
			clothesPlayer[clothPlay] = -1;
		else
			if catHash == 0xE06D30CE then
				Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, 0x662AC34, 0)
				Citizen.InvokeNative(0xCC8CA3E88256E58F, playerPed, 0, 1, 1, 1, 0);
			end
			Citizen.InvokeNative(0x59BD177A1A48600A, playerPed, catHash);
			Citizen.InvokeNative(0xD3A7B003ED343FD9, playerPed, ClothesUtils[rawCat][menuVal], true, false, false);
			Citizen.InvokeNative(0xD3A7B003ED343FD9, playerPed, ClothesUtils[rawCat][menuVal], true, true, false);
			clothesPlayer[clothPlay] = ClothesUtils[rawCat][menuVal]
		end
	else
		if menuVal <= 0 then
			Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, catHash, 0);
			Citizen.InvokeNative(0xCC8CA3E88256E58F, playerPed, 0, 1, 1, 1, 0);
			clothesPlayer[clothPlay] = -1;
		else
			Citizen.InvokeNative(0x59BD177A1A48600A, playerPed, catHash);
			Citizen.InvokeNative(0xD3A7B003ED343FD9, playerPed, ClothesUtils[rawCat][menuVal], true, false, true);
			Citizen.InvokeNative(0xD3A7B003ED343FD9, playerPed, ClothesUtils[rawCat][menuVal], true, true, true);
			clothesPlayer[clothPlay] = ClothesUtils[rawCat][menuVal]
		end
	end
end

function MainClothingMenu()
	MenuData.CloseAll()
	local cFG = Config.Stores[1]

	local elements = {
		{
			label = T.TitleMenuClothes,
			value = 'ClothingMenu',
			desc = T.SubTitleMenuClothes,
			image = "nui://vorp_clothingstores/images/clothing_purchase.png",
		},
		{
			label = T.TitleMenuOutfits,
			value = 'OutfitMenu',
			desc = T.SubTitleMenuOutfits,
			image = "nui://vorp_clothingstores/images/kit_wardrobe.png",
		},
	}

	MenuData.Open('default', GetCurrentResourceName(), "MainClothingMenu",
		{
			title    = cFG.name,
			subtext  = "",
			align    = 'top-left',
			elements = elements,
		},

		function(data, menu)
			if (data.current.value == 'ClothingMenu') then
				ClothingMenu()
			elseif (data.current.value == 'OutfitMenu') then
				OutfitMenu()
			end
		end,

		function(data, menu)
			MenuData.CloseAll()
			startBuyCloths(false)
		end)
end

function ClothingMenu()
	MenuData.CloseAll()
	local cFG = Config.Stores[1]
	local elements = {}
	local selectedComponents = {}


	for k, v in pairs(ClothesUtils) do
		if string.find(string.lower(k), "_" .. playerSex) then
			local labelForm, descForm, elmNum = "N/A", "N/A", (#elements + 1)
			if CategoryRawNames[k] then
				local convertedFormat = CategoryRawNames[k]
				labelForm = TranslationCloth.Langs[Lang].ClothingMenu[convertedFormat] -- Look up table to make the conversion in a loop
				descForm = TranslationCloth.Langs[Lang].Descriptions[convertedFormat] -- instead of each element being declared
			end

			elements[elmNum] = {
				label = labelForm,
				desc = descForm,
				type = "slider",
				value = 0,
				min = -1, -- True min is 0, when value hits -1 it rolls over to max
				max = (#v + 1),
				trueMax = #v,
				rawName = k,                            -- Ex. "RINGS_RH_MALE"
				catItem = CategoryRawNames[k],          -- Ex. "RINGS_RH_MALE" > "RightRings"
				dbName = CategoryClothesPlayer[CategoryRawNames[k]] -- Ex. RingRh
			}

			for k2, v2 in pairs(clothesPlayer) do
				if k2 == elements[elmNum].dbName then
					for y, z in pairs(ClothesUtils[elements[elmNum].rawName]) do
						if v2 == z then
							elements[elmNum].value = y -- If player has specified category equipped, set menu value to worn
							break
						end
					end
				end
			end
		end
	end

	elements[#elements + 1] = {
		label = T.Finish,
		value = "purchase",
		image = "nui://vorp_clothingstore/images/clothing_purchase.png"
	}

	MenuData.Open('default', GetCurrentResourceName(), "ClothingMenu",
		{
			title    = T.TitleMenuClothes,
			subtext  = T.SubTitleMenuClothes,
			align    = 'top-left',
			elements = elements,
		},

		function(data, menu)
			if data.current.value == "purchase" then
				FinishBuy(true, totalCost)
				menu.close()
			elseif data.current.type == "slider" and data.current.value < 0 then
				for k, v in pairs(menu.data.elements) do
					if v.rawName == data.current.rawName then
						data.current.value = data.current.trueMax
						menu.setElement(k, "value", data.current.trueMax)
						menu.refresh()
						SetPlayerComponent(data.current.value, data.current.catItem, data.current.rawName)
						if not selectedComponents[data.current.rawName] then
							totalCost = totalCost +
								Config.Cost[data.current.catItem];
						end
						selectedComponents[data.current.rawName] = data.current.value
						break
					end
				end
			elseif data.current.type == "slider" and data.current.value > data.current.trueMax then
				for k, v in pairs(menu.data.elements) do
					if v.rawName == data.current.rawName then
						data.current.value = 0
						menu.setElement(k, "value", 0)
						menu.refresh()
						SetPlayerComponent(0, data.current.catItem, data.current.rawName)
						selectedComponents[data.current.rawName] = nil
						totalCost = totalCost - Config.Cost[data.current.catItem]
						break
					end
				end
			else
				for k, v in pairs(data.elements) do
					if data.current.value > 0 and (selectedComponents[data.current.rawName] ~= data.current.value) then
						SetPlayerComponent(data.current.value, data.current.catItem, data.current.rawName)
						if not selectedComponents[data.current.rawName] then
							totalCost = totalCost +
								Config.Cost[data.current.catItem];
						end
						selectedComponents[data.current.rawName] = data.current.value
					elseif data.current.value == 0 and selectedComponents[data.current.rawName] then
						SetPlayerComponent(0, data.current.catItem, data.current.rawName)
						selectedComponents[data.current.rawName] = nil
						totalCost = totalCost - Config.Cost[data.current.catItem]
					end
				end
			end
		end,

		function(data, menu)
			totalCost = 0
			clothesPlayer = originalOutfit
			PreviewOutfit(false)
			MainClothingMenu()
		end)
end

function OutfitMenu()
	MenuData.CloseAll()
	local elements = {}

	for k, v in pairs(MyOutfits) do
		local outfitName
		if k == "" then outfitName = "Outfit"; else outfitName = v.title; end
		elements[#elements + 1] = {
			label = outfitName,
			value = k,
			dbId = v.dbId
		}
	end

	MenuData.Open('default', GetCurrentResourceName(), "OutfitMenu",
		{
			title    = T.TitleMenuOutfits,
			subtext  = T.SubTitleMenuOutfits,
			align    = 'top-left',
			elements = elements,
		},

		function(data, menu)
			if data.current.value and not loadingData then
				PreviewOutfit(data.current.value)
				OutfitSubMenu(data.current.value, data.current.dbId)
			end
		end,

		function(data, menu)
			PreviewOutfit(false)
			MainClothingMenu()
		end)
end

function OutfitSubMenu(index, outfitId)
	MenuData.CloseAll()
	local elements = {}
	local selectedOutfit, dbId = index, outfitId

	elements = {
		{
			label = T.TitleMenuOutfitsUseBtn,
			value = "wear",
			image = "nui://vorp_clothingstore/images/kit_wardrobe.png"
		},
		{ label = T.TitleMenuOutfitsDeleteBtn, value = "delete" }
	}
	MenuData.Open('default', GetCurrentResourceName(), "OutfitSubMenu",
		{
			title    = T.TitleMenuOutfits,
			subtext  = T.SubTitleMenuOutfits,
			align    = 'top-left',
			elements = elements,
		},

		function(data, menu)
			if data.current.value == "wear" then
				SetOutfit(selectedOutfit)
				menu.close()
				Wait(500)
			elseif data.current.value == "delete" then
				DeleteOutfit(selectedOutfit, dbId)
				PreviewOutfit(false)
				OutfitMenu()
				Wait(500)
			end
		end,

		function(data, menu)
			OutfitMenu()
		end)
end
