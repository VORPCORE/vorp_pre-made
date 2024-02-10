---@diagnostic disable: undefined-global
local isMale = true
local up
local left
local right
local down
local zoomin
local zoomout
local PromptGroup2 = GetRandomIntInRange(0, 0xffffff)

T = Translation.Langs[Lang]
InCharacterCreator = false
IsInCharCreation = false
FemalePed = nil
MalePed = nil


function SetupCameraCharacterCreationSelect()
	local camera = CreateCamera(`DEFAULT_SCRIPTED_CAMERA`, true)
	local pos = vec3(-562.15, -3776.22, 239.11)
	local rot = vec3(-4.71, 0.0, -93.14)
	SetCamParams(camera, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, 45.0, 0, 1, 1, 2, 1, 1)
	SetCamFocusDistance(camera, 4.0)
	RenderScriptCams(true, false, 3000, true, true, 0)
	return camera
end

-- request char creator imaps
local function Setup()
	Citizen.InvokeNative(0x513F8AA5BF2F17CF, -561.4, -3782.6, 237.6, 50.0, 20)                                 -- loadshpere
	Citizen.InvokeNative(0x9748FA4DE50CCE3E, "AZL_RDRO_Character_Creation_Area", true, true)                   -- load sound
	Citizen.InvokeNative(0x9748FA4DE50CCE3E, "AZL_RDRO_Character_Creation_Area_Other_Zones_Disable", false, true) -- load sound
	RequestImapCreator()
	NetworkClockTimeOverride(10, 0, 0, 0, true)
	SetTimecycleModifier('Online_Character_Editor')
	StartPlayerTeleport(PlayerId(), -561.22, -3776.26, 239.16, 93.2, true, true, true, true)

	repeat Wait(0) until not IsPlayerTeleportActive()

	if not HasCollisionLoadedAroundEntity(PlayerPedId()) then
		RequestCollisionAtCoord(-561.22, -3776.26, 239.16)
	end

	repeat Wait(0) until HasCollisionLoadedAroundEntity(PlayerPedId())

	local cam = SetupCameraCharacterCreationSelect()
	local animscene, peds = SetupAnimscene()

	LoadAnimScene(animscene)
	repeat Wait(0) until Citizen.InvokeNative(0x477122B8D05E7968, animscene)

	StartAnimScene(animscene)

	DoScreenFadeIn(3000)
	repeat Wait(0) until IsScreenFadedIn()

	repeat Wait(0) until Citizen.InvokeNative(0xCBFC7725DE6CE2E0, animscene)

	SetCamParams(cam, vec3(-562.15, -3776.22, 239.11), vec3(-4.71, 0.0, -93.14), 45.0, 0, 1, 1, 2, 1, 1)

	Wait(1000)
	exports[GetCurrentResourceName()]:_UI_FEED_POST_OBJECTIVE(-1,
		'~INPUT_CREATOR_MENU_TOGGLE~' .. T.Other.GenderChoice .. '~INPUT_CREATOR_ACCEPT~')
	SetCamFocusDistance(cam, 4.0)

	local char = 1
	while true do
		if IsControlJustPressed(0, `INPUT_CREATOR_MENU_TOGGLE`) then
			char = (char + 1) % 2
			local view = Config.Intro.views[char + 1]
			if view then
				SetCamParams(cam, view.pos.x, view.pos.y, view.pos.z, view.rot.x, view.rot.y, view.rot.z, view.fov, 1200,
					1, 1, 2, 1, 1)
				SetCamFocusDistance(cam, 4.0)

				local transEnd = false
				Citizen.SetTimeout(1200, function()
					transEnd = true
				end)

				while not transEnd do
					Citizen.Wait(0)
				end
			end
		end

		if IsControlJustPressed(0, `INPUT_CREATOR_ACCEPT`) then
			break
		end

		Wait(0)
	end

	UiFeedClearChannel()
	local ped = peds[char + 1]
	local gender = IsPedMale(ped) and "Male" or "Female"
	Citizen.InvokeNative(0xAB5E7CAB074D6B84, animscene, ("Pl_Start_to_Edit_%s"):format(gender))
	while not (Citizen.InvokeNative(0x3FBC3F51BF12DFBF, animscene, Citizen.ResultAsFloat()) > 0.2) do
		Citizen.Wait(0)
	end

	SetCamParams(cam, vec3(-561.82, -3780.97, 239.08), vec3(-4.21, 0.0, -87.88), 30.0, 0, 1, 1, 2, 1, 1)
	N_0x11f32bb61b756732(cam, 1.0)

	while not (N_0xd8254cb2c586412b(animscene) == 1) do
		Citizen.Wait(0)
	end
	Citizen.InvokeNative(0x84EEDB2C6E650000, animscene) -- delete animscene
	RegisterGenderPrompt()

	if gender ~= "Male" then
		CreatePlayerModel("mp_female", peds)
	else
		CreatePlayerModel("mp_male", peds)
	end
end

RegisterNetEvent("vorpcharacter:startCharacterCreator")
AddEventHandler("vorpcharacter:startCharacterCreator", function()
	exports.weathersync:setSyncEnabled(false)
	ShutdownLoadingScreen()
	ShowBusyspinnerWithText(T.Other.spinnertext2)
	Wait(500)
	InCharacterCreator = true
	Wait(2000)
	BusyspinnerOff()
	Setup()
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
	PromptSetControlAction(zoomout, `INPUT_CURSOR_ACCEPT_HOLD`)
	PromptSetControlAction(zoomout, `INPUT_INSPECT_ZOOM`)
	str = CreateVarString(10, 'LITERAL_STRING', str)
	PromptSetText(zoomout, str)
	PromptSetEnabled(zoomout, 0)
	PromptSetVisible(zoomout, 0)
	PromptSetStandardMode(zoomout, 1)
	PromptSetGroup(zoomout, PromptGroup2)
	PromptRegisterEnd(zoomout)
end

local function SetUpCameraCharacterMovement(x, y, z, heading, zoom)
	DestroyAllCams(true)
	local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", x, y, z, -11.32719, 0.0, heading, zoom, true, 0)
	SetCamActive(cam, true)
	RenderScriptCams(true, true, 500, true, true, 0)
	return cam
end

local function AdjustCharcaterHeading(heading, amount)
	heading = heading + amount
	SetPedDesiredHeading(PlayerPedId(), heading)
	return heading
end

function StartPrompts(value)
	local zoom = 55.00
	local locationx = value and value.Position.x or -560.1333
	local locationy = value and value.Position.y or -3780.923
	local heading = value and value.Heading or -90.96693
	local position = value and value.Position.z or 238.98
	local zoommin = 15.00
	local zoommax = 65.00
	local maxUp = value and value.MaxUp or 239.60
	local maxDown = value and value.MaxDown or 238.30
	local cam = SetUpCameraCharacterMovement(locationx, locationy, position, heading, zoom)
	local TotalToPay = ""
	local pocketMoney = value and LocalPlayer.state.Character.Money or 0

	while IsInCharCreation or IsInClothingStore do
		Wait(0)

		if IsInClothingStore and ShopType ~= "secondchance" then
			TotalToPay = T.Other.total .. GetCurrentAmmountToPay() .. T.Other.pocketmoney .. pocketMoney .. "~q~ "
		end

		local label = CreateVarString(10, "LITERAL_STRING", TotalToPay .. T.PromptLabels.CamAdjustments)
		PromptSetActiveGroupThisFrame(PromptGroup2, label)

		if IsControlPressed(2, Config.keys.prompt_camera_rotate.key) then --right
			heading = AdjustCharcaterHeading(heading, -1.5)
		end

		if IsControlPressed(2, Config.keys.prompt_camera_rotate.key2) then -- left
			heading = AdjustCharcaterHeading(heading, 1.5)
		end

		if IsControlPressed(2, Config.keys.prompt_camera_ws.key) then -- up
			position = math.min(position + 0.01, maxUp)
			SetCamCoord(cam, locationx, locationy, position)
		end

		if IsControlPressed(2, Config.keys.prompt_camera_ws.key2) then -- down
			position = math.max(position - 0.01, maxDown)
			SetCamCoord(cam, locationx, locationy, position)
		end

		if IsControlPressed(2, `INPUT_CONTEXT_ACTION`) then -- zoom out
			zoom = math.min(zoom + 0.5, zoommax)
			SetCamFov(cam, zoom)
		end

		if IsControlPressed(2, `INPUT_INSPECT_ZOOM`) then --zoom in
			zoom = math.max(zoom - 0.5, zoommin)
			SetCamFov(cam, zoom)
		end
	end
	DestroyCam(cam, false)
	RenderScriptCams(false, true, 500, true, true, 0)
end

-- set up a default ped with default values
function DefaultPedSetup(ped, male)
	local compEyes   = male and 612262189 or 928002221
	local compBody   = male and tonumber("0x" .. Config.DefaultChar.Male[3].Body[1]) or
		tonumber("0x" .. Config.DefaultChar.Female[3].Body[1])
	local compHead   = male and tonumber("0x" .. Config.DefaultChar.Male[3].Heads[9]) or
		tonumber("0x" .. Config.DefaultChar.Female[3].Heads[4])
	local compLegs   = male and tonumber("0x" .. Config.DefaultChar.Male[3].Legs[1]) or
		tonumber("0x" .. Config.DefaultChar.Female[3].Legs[1])
	local albedo     = male and joaat("mp_head_mr1_sc03_c0_000_ab") or joaat("mp_head_fr1_sc08_c0_000_ab")
	local body       = male and 2362013313 or 0x3F1F01E5
	local model      = male and "mp_male" or "mp_female"
	HeadIndexTracker = male and 9 or 4
	SkinColorTracker = male and 3 or 3

	if not male then
		EquipMetaPedOutfitPreset(ped, 7)
	end

	IsPedReadyToRender()
	EquipMetaPedOutfitPreset(ped, 3)
	UpdatePedVariation()

	if male then
		-- work around to fix skin on char creator
		IsPedReadyToRender()
		UpdateShopItemWearableState(-457866027, -425834297)
		UpdatePedVariation()
		IsPedReadyToRender()
		ApplyShopItemToPed(-218859683)
		ApplyShopItemToPed(male and 795591403 or 1511461630)
		UpdateShopItemWearableState(-218859683, -2081918609)
		UpdatePedVariation()
	end

	PlayerSkin.HeadType            = compHead
	PlayerSkin.BodyType            = compBody
	PlayerSkin.LegsType            = compLegs
	PlayerSkin.Body                = body
	PlayerSkin.Eyes                = compEyes
	PlayerSkin.sex                 = model
	PlayerSkin.albedo              = albedo
	PlayerClothing.Gunbelt.comp    = male and 795591403 or 1511461630
	PlayerSkin.Hair                = male and 2112480140 or 3887861344
	PlayerSkin.eyebrows_visibility = 1
	PlayerSkin.eyebrows_tx_id      = 1
	PlayerSkin.eyebrows_opacity    = 1.0
	PlayerSkin.eyebrows_color      = 0x3F6E70FF
	toggleOverlayChange("eyebrows", 1, 1, 1, 0, 0, 1.0, 0, 1, 0x3F6E70FF, 0, 0, 1, 1.0, albedo)
end

function EnableCharCreationPrompts(boolean)
	PromptSetEnabled(up, boolean)
	PromptSetVisible(up, boolean)
	PromptSetEnabled(down, boolean)
	PromptSetVisible(down, boolean)
	PromptSetEnabled(left, boolean)
	PromptSetVisible(left, boolean)
	PromptSetEnabled(right, boolean)
	PromptSetVisible(right, boolean)
	PromptSetEnabled(zoomin, boolean)
	PromptSetVisible(zoomin, boolean)
	PromptSetEnabled(zoomout, boolean)
	PromptSetVisible(zoomout, boolean)
end

function CreatePlayerModel(model, peds)
	local Gender = model == "mp_male" and "male" or "female"
	isMale = model == "mp_male" and true or false
	DoScreenFadeOut(0)
	repeat Wait(0) until IsScreenFadedOut()

	for key, value in pairs(peds) do
		DeleteEntity(value)
	end

	SetEntityCoords(PlayerPedId(), -558.3258, -3781.111, 237.60, true, true, true, false)
	SetEntityHeading(PlayerPedId(), 93.2)
	LoadPlayer(model)
	SetPlayerModel(PlayerId(), joaat(model), false)
	SetModelAsNoLongerNeeded(model)
	UpdatePedVariation(PlayerPedId())
	RenderScriptCams(false, true, 3000, true, true, 0)
	Wait(1000)
	DefaultPedSetup(PlayerPedId(), isMale)
	Wait(1000)
	IsInCharCreation = true
	RegisterGenderPrompt()
	CreateThread(function()
		StartPrompts()
	end)
	EnableCharCreationPrompts(true)
	local Clothing = OrganiseClothingData(Gender)
	RemoveTagFromMetaPed(0x3F1F01E5)
	UpdatePedVariation(PlayerPedId())
	SetEntityVisible(PlayerPedId(), true)
	SetEntityInvincible(PlayerPedId(), true)
	SetPedScale(PlayerPedId(), 1.0)
	RenderScriptCams(true, true, 1000, true, true, 0)
	CreateThread(function()
		DrawLight()
	end)
	Wait(2000)
	DoScreenFadeIn(3000)
	repeat Wait(0) until IsScreenFadedIn()
	ApplyDefaultClothing()
	PrepareCreatorMusic()
	OpenCharCreationMenu(Clothing, false)
end
