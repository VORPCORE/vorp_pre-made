---@diagnostic disable: undefined-global
local isSelectSexActive
local camera
local cameraMale
local cameraFemale
local cameraEditor
local isMale = true
local up
local left
local right
local down
local zoomin
local zoomout
local selectLeft
local selectRight
local selectEnter
local PromptGroup1 = GetRandomIntInRange(0, 0xffffff)
local PromptGroup2 = GetRandomIntInRange(0, 0xffffff)
T = Translation.Langs[Lang]

--GLOBALS
VORPcore = {}
InCharacterCreator = false
IsInCharCreation = false
FemalePed = nil
MalePed = nil
IsInSecondChance = false


TriggerEvent("getCore", function(core)
	VORPcore = core
end)

--PROMPTS
CreateThread(function()
	local C = Config.keys
	local str = T.PromptLabels.promptsexMale
	selectLeft = PromptRegisterBegin()
	PromptSetControlAction(selectLeft, C.prompt_choose_gender_M.key) -- add to config
	str = CreateVarString(10, 'LITERAL_STRING', str)
	PromptSetText(selectLeft, str)
	PromptSetEnabled(selectLeft, 1)
	PromptSetVisible(selectLeft, 1)
	PromptSetStandardMode(selectLeft, 1)
	PromptSetGroup(selectLeft, PromptGroup1)
	PromptRegisterEnd(selectLeft)

	local str = T.PromptLabels.promptsexFemale
	selectRight = PromptRegisterBegin()
	PromptSetControlAction(selectRight, C.prompt_choose_gender_F.key)
	str = CreateVarString(10, 'LITERAL_STRING', str)
	PromptSetText(selectRight, str)
	PromptSetEnabled(selectRight, 1)
	PromptSetVisible(selectRight, 1)
	PromptSetStandardMode(selectRight, 1)
	PromptSetGroup(selectRight, PromptGroup1)
	PromptRegisterEnd(selectRight)


	local str = T.PromptLabels.promptselectConfirm
	selectEnter = PromptRegisterBegin()
	PromptSetControlAction(selectEnter, C.prompt_select_gender.key)
	str = CreateVarString(10, 'LITERAL_STRING', str)
	PromptSetText(selectEnter, str)
	PromptSetEnabled(selectEnter, 0)
	PromptSetVisible(selectEnter, 1)
	PromptSetStandardMode(selectEnter, 1)
	PromptSetGroup(selectEnter, PromptGroup1)
	PromptRegisterEnd(selectEnter)
end)



local defaultX, defaultY, defaultZ = -561.22, -3776.26, 239.16
local defaultPitch, defaultRoll, defaultHeading, defaultZoom = -12.0, 0.00, -88.74, 45.00

local function createCams()
	camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", defaultX, defaultY, defaultZ, defaultPitch, defaultRoll,
		defaultHeading, defaultZoom, false, 0)
	cameraMale = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -560.21, -3775.38, 239.16,
		-10.0, 0.0, -93.2, defaultZoom, false, 0)
	cameraFemale = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -560.21, -3776.57, 239.16,
		-10.0, 0.0, -93.2, defaultZoom, false, 0)
	cameraEditor = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -560.1333, -3780.923, 239.44,
		-11.32719, 0.0, -90.96, defaultZoom, false, 0)
end

-- request char creator imaps
local function Setup()
	Citizen.InvokeNative(0x513F8AA5BF2F17CF, -561.4, -3782.6, 237.6, 50.0, 20)                                 -- loadshpere
	Citizen.InvokeNative(0x9748FA4DE50CCE3E, "AZL_RDRO_Character_Creation_Area", true, true)                   -- load sound
	Citizen.InvokeNative(0x9748FA4DE50CCE3E, "AZL_RDRO_Character_Creation_Area_Other_Zones_Disable", false, true) -- load sound
	RequestImapCreator()
	SetClockTime(10, 00, 0)
	SetTimecycleModifier('Online_Character_Editor')
	SetEntityCoords(PlayerPedId(), -563.1345, -3775.811, 237.60, false, false, false, false) -- coords of where it spawns
	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		Wait(500)
	end
	SelectionPeds()
	createCams()
	SetCamActive(camera, true)
	RenderScriptCams(true, true, 1000, true, true, 0)
	isSelectSexActive = true
end

RegisterNetEvent("vorpcharacter:startCharacterCreator")
AddEventHandler("vorpcharacter:startCharacterCreator", function()
	PrepareMusicEvent("REHR_START")
	Wait(100)
	TriggerMusicEvent("REHR_START")
	Wait(500)
	InCharacterCreator = true
	DoScreenFadeOut(500)
	Wait(1000)
	RegisterGenderPrompt()
	Setup()
	Wait(2000)
	DoScreenFadeIn(1000)
	AnimpostfxPlay("RespawnPulse01")
	local Label
	Citizen.CreateThread(function()
		while InCharacterCreator do
			Wait(0)
			-- add prompts instead
			if not IsInCharCreation then
				if isSelectSexActive and not IsCamActive(cameraFemale) and not IsCamActive(cameraMale) then
					Label = CreateVarString(10, "LITERAL_STRING", T.PromptLabels.promptlabel_select)
				end

				if IsCamActive(cameraFemale) and isSelectSexActive then
					Label = CreateVarString(10, "LITERAL_STRING", T.PromptLabels.promptlabel_female)
				end

				if IsCamActive(cameraMale) and isSelectSexActive then
					Label = CreateVarString(10, "LITERAL_STRING", T.PromptLabels.promptlabel_male)
				end

				PromptSetActiveGroupThisFrame(PromptGroup1, Label)

				if Citizen.InvokeNative(0xC92AC953F0A982AE, selectLeft) then
					PlaySoundFrontend("gender_left", "RDRO_Character_Creator_Sounds", true, 0)
					PromptSetEnabled(selectEnter, 1)
					if IsCamActive(camera) then
						SetCamActiveWithInterp(cameraMale, camera, 2000, 0, 0)
						SetCamActive(camera, false)
					elseif IsCamActive(cameraMale) then
						SetCamActiveWithInterp(camera, cameraMale, 2000, 0, 0)
						SetCamActive(cameraMale, false)
						PromptSetEnabled(selectEnter, 0)
					elseif IsCamActive(cameraFemale) then
						SetCamActiveWithInterp(cameraMale, cameraFemale, 2000, 0, 0)
						SetCamActive(cameraFemale, false)
						PromptSetEnabled(selectEnter, 1)
					end
					Wait(2000)
					InCharacterCreator = true
				end

				if Citizen.InvokeNative(0xC92AC953F0A982AE, selectRight) then
					PlaySoundFrontend("gender_right", "RDRO_Character_Creator_Sounds", true, 0)
					PromptSetEnabled(selectEnter, 1)
					if IsCamActive(camera) then
						SetCamActiveWithInterp(cameraFemale, camera, 2000, 0, 0)
						SetCamActive(camera, false)
					elseif IsCamActive(cameraMale) then
						SetCamActiveWithInterp(cameraFemale, cameraMale, 2000, 0, 0)
						SetCamActive(cameraMale, false)
						PromptSetEnabled(selectEnter, 1)
					elseif IsCamActive(cameraFemale) then
						SetCamActiveWithInterp(camera, cameraFemale, 2000, 0, 0)
						SetCamActive(cameraFemale, false)
						PromptSetEnabled(selectEnter, 0)
					end
					Wait(2000)
				end


				if Citizen.InvokeNative(0xC92AC953F0A982AE, selectEnter) then
					Citizen.InvokeNative(0x706D57B0F50DA710, "MC_MUSIC_STOP")
					PlaySoundFrontend("SELECT", "RDRO_Character_Creator_Sounds", true, 0)
					AnimpostfxPlay("RespawnPulse01")
					if IsCamActive(cameraMale) then
						SetCamActiveWithInterp(camera, cameraMale, 2000, 0, 0)
						SetCamActive(cameraMale, false)
						CreatePlayerModel("mp_male", cameraMale)
						isSelectSexActive = false
					elseif IsCamActive(cameraFemale) then
						SetCamActiveWithInterp(camera, cameraFemale, 2000, 0, 0)
						SetCamActive(cameraFemale, false)
						CreatePlayerModel("mp_female", cameraFemale)
						isSelectSexActive = false
					end
					Wait(2000)
					CreateThread(StartPrompts)
					IsInCharCreation = true
				end
			else
				FreezeEntityPosition(PlayerPedId(), false)
				DrawLightWithRange(-560.1646, -3782.066, 238.5975, 250, 250, 250, 7.0, 130.0)
			end
		end
	end)
end)

function RegisterGenderPrompt()
	local C = Config.keys
	local str = T.PromptLabels.promptUpDownCam
	down = PromptRegisterBegin()
	PromptSetControlAction(down, C.prompt_camera_ws.key)
	PromptSetControlAction(down, C.prompt_camera_ws.key2)
	str = CreateVarString(10, 'LITERAL_STRING', str)
	PromptSetText(down, str)
	PromptSetEnabled(down, 0)
	PromptSetVisible(down, 0)
	PromptSetStandardMode(down, 1)
	PromptSetGroup(down, PromptGroup2)
	PromptRegisterEnd(down)


	str = T.PromptLabels.promptrotateCam
	right = PromptRegisterBegin()
	PromptSetControlAction(right, 0x7065027D)
	PromptSetControlAction(right, 0xB4E465B4)
	str = CreateVarString(10, 'LITERAL_STRING', str)
	PromptSetText(right, str)
	PromptSetEnabled(right, 0)
	PromptSetVisible(right, 0)
	PromptSetHoldMode(right, false)
	PromptSetStandardMode(right, 0)
	PromptSetGroup(right, PromptGroup2)
	PromptRegisterEnd(right)

	str = T.PromptLabels.promptzoomCam
	zoomout = PromptRegisterBegin()
	PromptSetControlAction(zoomout, C.prompt_zoom.key)
	PromptSetControlAction(zoomout, C.prompt_zoom.key2)
	str = CreateVarString(10, 'LITERAL_STRING', str)
	PromptSetText(zoomout, str)
	PromptSetEnabled(zoomout, 0)
	PromptSetVisible(zoomout, 0)
	PromptSetStandardMode(zoomout, 1)
	PromptSetGroup(zoomout, PromptGroup2)
	PromptRegisterEnd(zoomout)
end

function SelectionPeds()
	local fModel = "mp_female"
	local mModel = "mp_male"

	LoadPlayer(fModel)
	FemalePed = CreatePed(joaat(fModel), -558.43, -3776.65, 237.7, 93.2, false, true, true, true)
	TaskStandStill(FemalePed, -1)
	SetEntityInvincible(FemalePed, true)
	DefaultPedSetup(FemalePed, false)
	SetModelAsNoLongerNeeded(fModel)

	LoadPlayer(mModel)
	MalePed = CreatePed(joaat(mModel), -558.52, -3775.6, 237.7, 93.2, false, true, true, true)
	TaskStandStill(MalePed, -1)
	SetEntityInvincible(MalePed, true)
	DefaultPedSetup(MalePed, true)
	SetModelAsNoLongerNeeded(mModel)
end

local function StartCam(x, y, z, heading, zoom)
	Citizen.InvokeNative(0x17E0198B3882C2CB, PlayerPedId())
	DestroyAllCams(true)
	local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", x, y, z, -11.32719, 0.0, heading, zoom, true, 0)
	SetCamActive(cam, true)
	RenderScriptCams(true, true, 500, true, true)
end

local z_position = 239.4437
local heading = 93.2
local zoom = 45.00

local function adjustHeading(amount)
	heading = heading + amount
	SetPedDesiredHeading(PlayerPedId(), heading)
end

function AdjustZoom(amount)
	zoom = zoom + amount
	StartCam(-560.1333, -3780.923, z_position, -90.96693, zoom)
end

function StartPrompts()
	while IsInCharCreation do
		Wait(0)

		local label = CreateVarString(10, "LITERAL_STRING", T.PromptLabels.CamAdjustments)
		PromptSetActiveGroupThisFrame(PromptGroup2, label)

		if IsControlPressed(2, 0x7065027D) then --right
			adjustHeading(-5.0)
		end

		if IsControlPressed(2, 0xB4E465B4) then -- left
			adjustHeading(5.0)
		end

		if IsControlPressed(2, 0x8FD015D8) then -- up
			z_position = math.min(z_position + 0.02, 240.0)
			StartCam(-560.1333, -3780.923, z_position, -90.96693, zoom)
		end

		if IsControlPressed(2, 0xD27782E3) then -- down
			z_position = math.max(z_position - 0.02, 237.70)
			StartCam(-560.1333, -3780.923, z_position, -90.96693, zoom)
		end

		if IsControlPressed(2, 0x8BDE7443) then -- zoom out
			AdjustZoom(4.0)
		end

		if IsControlPressed(2, 0x62800C92) then --zoom in
			AdjustZoom(-4.0)
		end
	end
end

function DefaultPedSetup(ped, male)
	local compEyes
	local compBody
	local compHead
	local compLegs

	if male then
		Citizen.InvokeNative(0x77FF8D35EEC6BBC4, ped, 0, 0)
		compEyes = 612262189
		compBody = tonumber("0x" .. Config.DefaultChar.Male[1].Body[1])
		compHead = tonumber("0x" .. Config.DefaultChar.Male[1].Heads[1])
		compLegs = tonumber("0x" .. Config.DefaultChar.Male[1].Legs[1])
	else
		Citizen.InvokeNative(0x77FF8D35EEC6BBC4, ped, 7, true) -- female sync
		compEyes = 928002221
		compBody = tonumber("0x" .. Config.DefaultChar.Female[1].Body[1])
		compHead = tonumber("0x" .. Config.DefaultChar.Female[1].Heads[1])
		compLegs = tonumber("0x" .. Config.DefaultChar.Female[1].Legs[1])
	end

	Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
	Citizen.InvokeNative(0x77FF8D35EEC6BBC4, ped, 3, 0) -- outfits
	IsPedReadyToRender()
	ApplyComponentToPed(ped, compBody)
	ApplyComponentToPed(ped, compLegs)
	ApplyComponentToPed(ped, compHead)
	ApplyComponentToPed(ped, compEyes)

	PlayerSkin.HeadType = compHead
	PlayerSkin.BodyType = compBody
	PlayerSkin.LegsType = compLegs
	PlayerSkin.Eyes = compEyes
end

Clothing = {}
local function EnableCharCreationPrompts()
	PromptSetEnabled(up, 1)
	PromptSetVisible(up, 1)
	PromptSetEnabled(down, 1)
	PromptSetVisible(down, 1)
	PromptSetEnabled(left, 1)
	PromptSetVisible(left, 1)
	PromptSetEnabled(right, 1)
	PromptSetVisible(right, 1)
	PromptSetEnabled(zoomin, 1)
	PromptSetVisible(zoomin, 1)
	PromptSetEnabled(zoomout, 1)
	PromptSetVisible(zoomout, 1)
end
function CreatePlayerModel(model, cam)
	local Gender = "male"
	local ped = MalePed
	PlayerSkin.sex = model
	PlayerSkin.albedo = joaat("mp_head_mr1_sc08_c0_000_ab")
	isMale = true

	if model == 'mp_female' then
		isMale = false
		Gender = "female"
		ped = FemalePed
		PlayerSkin.sex = model
		PlayerSkin.albedo = joaat("mp_head_fr1_sc08_c0_000_ab")
	end

	Wait(1000)
	ClearPedTasksImmediately(ped, true)
	TaskGoStraightToCoord(ped, -558.3258, -3781.111, 237.60, 1.0, 1, 1, 1, 1)
	DoScreenFadeOut(3000)
	Wait(3000)
	SetEntityCoords(PlayerPedId(), -558.3258, -3781.111, 237.60, true, true, true, false) -- set player to start creation
	SetEntityHeading(PlayerPedId(), 93.2)
	LoadPlayer(model)
	SetPlayerModel(PlayerId(), joaat(model), false)
	SetModelAsNoLongerNeeded(model)
	Citizen.InvokeNative(0xCC8CA3E88256E58F, PlayerPedId(), false, true, true, true, false)
	RenderScriptCams(false, true, 3000, true, true, 0)
	Wait(1000)
	DefaultPedSetup(PlayerPedId(), isMale)
	SetCamActive(cam, false)
	Wait(1000)
	SetCamActive(cameraEditor, true)
	RenderScriptCams(true, true, 1000, true, true, 0)

	CreateThread(function()
		if DoesEntityExist(FemalePed) then
			DeletePed(FemalePed)
		end
		if DoesEntityExist(MalePed) then
			DeletePed(MalePed)
		end
	end)

	EnableCharCreationPrompts()

	IsInCharCreation = true -- enable light

	for category, value in pairs(Data.clothing[Gender]) do
		local categoryTable = {}

		for _, v in pairs(value) do
			local typeTable = {}

			for _, va in pairs(v) do
				local hash = va.hashname
				local hex = va.hash

				table.insert(typeTable, { hash = hash, hex = hex })
			end

			table.insert(categoryTable, typeTable)
		end
		Clothing[category] = categoryTable
	end

	Citizen.InvokeNative(0xD710A5007C2AC539, PlayerPedId(), 0x3F1F01E5, 0)        -- remove meta tag
	Citizen.InvokeNative(0xCC8CA3E88256E58F, PlayerPedId(), true, true, true, false) -- update variation
	SetEntityVisible(PlayerPedId(), true)
	SetEntityInvincible(PlayerPedId(), true)
	Citizen.InvokeNative(0x25ACFC650B65C538, PlayerPedId(), 1.0) -- scale
	DoScreenFadeIn(3000)
	OpenCharCreationMenu(Clothing)
end

RegisterNetEvent('vorp_character:Server:SecondChance', function(skin, comps)
	DoScreenFadeOut(3000)
	Wait(3000)
	IsInSecondChance = true
	local Gender = "male"
	if skin.sex == "mp_female" then
		Gender = "female"
	end
	PlayerSkin = skin
	PlayerClothing = comps
	local instanced = GetPlayerServerId(PlayerId()) + 456565
	VORPcore.instancePlayers(math.floor(instanced))
	RequestImapCreator()
	RegisterGenderPrompt()
	CreateThread(StartPrompts)
	EnableCharCreationPrompts()
	IsInCharCreation = true

	SetEntityCoords(PlayerPedId(), -558.3258, -3781.111, 237.60, true, true, true, false) -- set player to start creation
	SetEntityHeading(PlayerPedId(), 93.2)
	Wait(1000)
	cameraEditor = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -560.1333, -3780.923, 239.44,
		-11.32719, 0.0, -90.96, defaultZoom, false, 0)
	Wait(1000)
	SetCamActive(cameraEditor, true)
	RenderScriptCams(true, true, 1000, true, true, 0)

	Clothing = {}

	for category, value in pairs(Data.clothing[Gender]) do
		local categoryTable = {}

		for _, v in pairs(value) do
			local typeTable = {}

			for _, va in pairs(v) do
				local hash = va.hashname
				local hex = va.hash

				table.insert(typeTable, { hash = hash, hex = hex })
			end

			table.insert(categoryTable, typeTable)
		end
		Clothing[category] = categoryTable
	end
	DoScreenFadeIn(3000)
	CreateThread(function()
		while IsInCharCreation do
			Wait(0)
			FreezeEntityPosition(PlayerPedId(), false)
			DrawLightWithRange(-560.1646, -3782.066, 238.5975, 250, 250, 250, 7.0, 130.0)
		end
	end)
	OpenCharCreationMenu(Clothing)
end)
