---@diagnostic disable: undefined-global
local selectedChar = 1
local myChars      = {}
local textureId    = -1
local MaxCharacters
local mainCam      = nil
local LastCam      = nil
local random
local canContinue  = false
local Custom       = nil
local Peds         = {}

-- GLOBALS
CachedSkin         = {}
CachedComponents   = {}
T                  = Translation.Langs[Lang]


AddEventHandler('onClientResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	end

	if Config.DevMode then
		print("^3VORP Character Selector is in ^1DevMode^7 dont use in live servers")
		TriggerServerEvent("vorp_GoToSelectionMenu", GetPlayerServerId(PlayerId()))
	end
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	end

	for _, value in pairs(Peds) do
		DeleteEntity(value)
	end
	Citizen.InvokeNative(0xB63B9178D0F58D82, textureId) -- reset texture
	Citizen.InvokeNative(0x6BEFAA907B076859, textureId) -- remove texture
	DeleteEntity(MalePed)
	DeleteEntity(FemalePed)
	DoScreenFadeIn(100)
	RemoveImaps()
	Citizen.InvokeNative(0x706D57B0F50DA710, "MC_MUSIC_STOP")
	MenuData.CloseAll()
	myChars[selectedChar] = {}
	DestroyAllCams(true)
end)


RegisterNetEvent("vorpcharacter:spawnUniqueCharacter", function(myChar)
	myChars = myChar
	CharSelect()
end)


-- player is already in an instance
RegisterNetEvent("vorpcharacter:selectCharacter")
AddEventHandler("vorpcharacter:selectCharacter", function(myCharacters, mc, rand)
	if #myCharacters < 1 then
		return TriggerEvent("vorpcharacter:startCharacterCreator") -- if no chars then send back to creator
	end
	random = rand
	myChars = myCharacters
	MaxCharacters = mc
	DoScreenFadeOut(1000)
	Wait(1000)
	StartSwapCharacters()
end)


-- send all components in a table and update core through server
RegisterNetEvent("vorpcharacter:updateCache")
AddEventHandler("vorpcharacter:updateCache", function(skin, comps)
	if skin then
		if type(skin) == "table" then
			CachedSkin = skin
		else
			CachedSkin = json.decode(skin)
		end
	end

	if comps then
		if type(comps) == "table" then
			CachedComponents = comps
		else
			CachedComponents = json.decode(comps)
		end
	end
	TriggerServerEvent("vorpcharacter:setPlayerCompChange", CachedSkin, CachedComponents)
end)

-- send components one by one
RegisterNetEvent("vorpcharacter:savenew")
AddEventHandler("vorpcharacter:savenew", function(comps, skin)
	if comps then
		local clothing
		if type(comps) == "table" then
			clothing = comps
		else
			clothing = json.decode(comps)
		end
		for k, v in pairs(clothing) do
			if CachedComponents[k] then
				CachedComponents[k] = v
			end
		end
	end
	if skin then
		local skinz
		if type(skin) == "table" then
			skinz = skin
		else
			skinz = json.decode(skin)
		end
		for k, v in pairs(skinz) do
			if CachedSkin[k] then
				CachedSkin[k] = v
			end
		end
	end
	TriggerServerEvent("vorpcharacter:setPlayerCompChange", CachedSkin, CachedComponents)
end)


local function LoadFaceFeatures(ped, skin)
	for key, value in pairs(FaceFeatures) do
		Citizen.InvokeNative(0x5653AB26C82938CF, ped, value, skin[key])
		Citizen.InvokeNative(0xAAB86462966168CE, ped, 1) --_CLEAR
	end
end

local function LoadComps(ped, components)
	for category, value in pairs(components) do
		if value ~= -1 then
			Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, value, false, false, false)
			Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, value, false, true, false)
			Citizen.InvokeNative(0x66b957aac2eaaeab, ped, value, 0, 0, 1, 1) -- _UPDATE_SHOP_ITEM_WEARABLE_STATE
			Citizen.InvokeNative(0xAAB86462966168CE, ped, 1)        --_CLEAR
		end
	end
end

local function LoadAll(gender, ped, pedskin, components)
	RemoveMetaTags(ped)
	IsPedReadyToRender()
	Citizen.InvokeNative(0x0BFA1BD465CDFEFD, ped) -- _RESET_PED_COMPONENTS
	local skin = SetDefaultSkin(gender, pedskin)
	--_APPLY_SHOP_ITEM_TO_PED
	Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, skin.HeadType, false, true, true)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, skin.BodyType, false, true, true)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, skin.LegsType, false, true, true)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, skin.Eyes, false, true, true)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, skin.Legs, true, true, true)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, skin.Hair, false, true, true)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, skin.Beard, false, true, true)
	-- _EQUIP_META_PED_OUTFIT
	Citizen.InvokeNative(0x1902C4CFCC5BE57C, ped, skin.Waist)
	Citizen.InvokeNative(0x1902C4CFCC5BE57C, ped, skin.Body)
	Citizen.InvokeNative(0x1902C4CFCC5BE57C, ped, skin.Torso)
	Citizen.InvokeNative(0xAAB86462966168CE, ped, 1) --_CLEAR

	LoadFaceFeatures(ped, skin)
	Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, false, true, true, true, false)
	LoadComps(ped, components)
	SetPedScale(ped, skin.Scale)
	UpdateVariation(ped)
	return skin
end

local function LoadCharacterSelect(ped, skin, components)
	local gender = "Male"

	if skin.sex and skin.sex ~= "mp_male" then
		gender = "Female"
	end

	LoadAll(gender, ped, skin, components)
	if skin.sex and skin.sex ~= "mp_male" then
		UpdateVariation(ped)
	end

	Citizen.InvokeNative(0xC6258F41D86676E0, ped, 1, 100)
	Citizen.InvokeNative(0xC6258F41D86676E0, ped, 0, 100)
end
-- if you have 3 positions here it means  you can olny have max characters of 3 or add more make sure you add 3 for each in case they only want females or only males


function StartSwapCharacters()
	local options = Config.SpawnPosition[random].options
	exports.weathersync:setMyWeather(options.weather.type, options.weather.transition, options.weather.snow) -- Disable weather and time sync and set a weather for this client.
	exports.weathersync:setMyTime(options.time.hour, 0, 0, options.time.transition, true)
	SetTimecycleModifier(options.timecycle.name)
	Citizen.InvokeNative(0xFDB74C9CC54C3F37, options.timecycle.strenght)
	FreezeEntityPosition(PlayerPedId(), true)
	SetEntityVisible(PlayerPedId(), false)
	SetEntityInvincible(PlayerPedId(), true)
	SetEntityCoords(PlayerPedId(), options.playerpos, false, false, false, false)

	if not HasCollisionLoadedAroundEntity(PlayerPedId()) then
		RequestCollisionAtCoord(options.playerpos.x, options.playerpos.y, options.playerpos.z)
		Wait(2000)
	end

	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		RequestCollisionAtCoord(options.playerpos.x, options.playerpos.y, options.playerpos.z)
		Wait(100)
	end

	PrepareMusicEvent(options.music)
	Wait(100)
	TriggerMusicEvent(options.music)

	Wait(2000)

	for key, value in pairs(myChars) do
		LoadPlayer(value.skin.sex)

		local data = Config.SpawnPosition[random].positions[key]
		data.PedHandler = CreatePed(joaat(value.skin.sex), data.spawn, false, true, true, true)

		while not DoesEntityExist(data.PedHandler) do
			Wait(100)
		end

		LoadCharacterSelect(data.PedHandler, value.skin, value.components)
		data.Cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",
			data.camera.x, data.camera.y, data.camera.z, data.camera.rotx, data.camera.roty, data.camera.rotz,
			data.camera.fov, false, 2)
		SetEntityInvincible(data.PedHandler, true)
		Wait(100)
		local randomScenario = math.random(1, #data.scenario[value.skin.sex])
		Citizen.InvokeNative(0x524B54361229154F, data.PedHandler, joaat(data.scenario[value.skin.sex][randomScenario]),
			-1, false, joaat(data.scenario[value.skin.sex][randomScenario]), -1.0, 0)
		Peds[#Peds + 1] = data.PedHandler
	end

	-- create main camera
	mainCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", options.mainCam.x, options.mainCam.y, options.mainCam.z,
		options.mainCam.rotx,
		options.mainCam.roty, options.mainCam.rotz, options.mainCam.fov, false, 0)
	SetCamActive(mainCam, true)
	RenderScriptCams(true, false, 0, true, true)
	Wait(2000)
	DoScreenFadeIn(4000)
	OpenMenuSelect()
end

local function finish(boolean)
	MenuData.CloseAll()
	--RenderScriptCams(false, true, 5000, true, true)
	if boolean then
		DoScreenFadeOut(1000)
		Wait(5000)
	end
	CreateThread(function()
		Wait(2000)
		for _, value in pairs(Peds) do
			DeleteEntity(value)
		end

		DestroyAllCams(true)
	end)
	ClearTimecycleModifier()
	Citizen.InvokeNative(0x706D57B0F50DA710, "MC_MUSIC_STOP")
	exports.weathersync:setSyncEnabled(true)
end
local imgPath = "<img style='max-height:532px;max-width:344px;float: center;'src='nui://vorp_character/images/%s.png'>"
local function addNewelements(menu)
	local available = MaxCharacters - #myChars
	for i = 1, available, 1 do
		menu.addNewElement({
			label = T.MainMenu.NewChar,
			value = "create",
			desc = imgPath:format("character_creator_appearance") .. " <br> " .. T.MainMenu.NewCharDesc,
			itemHeight = "2vh"

		})
	end
end

local function createMainCam()
	local data = Config.SpawnPosition[random].options
	mainCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", data.mainCam.x, data.mainCam.y, data.mainCam.z,
		data.mainCam.rotx, data.mainCam.roty,
		data.mainCam.rotz, data.mainCam.fov, false, 2)
	SetCamActive(mainCam, true)
	RenderScriptCams(true, false, 0, true, true)
end

function OpenMenuSelect()
	MenuData.CloseAll()
	local elements = {}
	local available = MaxCharacters - #myChars
	local created = true
	local pressed = false

	for key, value in pairs(myChars) do
		elements[#elements + 1] = {
			label = T.MainMenu.Name ..
				value.firstname .. " " .. value.lastname .. " <br> " .. T.MainMenu.Money .. " " .. value.money,
			value = "choose",
			desc = imgPath:format("character_creator_appearance") .. " <br> " .. T.MainMenu.NameDesc,
			char = value,
			index = key, -- selected character index
		}
	end

	for i = 1, available, 1 do
		elements[#elements + 1] = {
			label = T.MainMenu.CreateNewCharT,
			value = "create",
			desc = imgPath:format("character_creator_appearance") .. " <br> " .. T.MainMenu.CreateNewCharDesc,
			itemHeight = "2vh",
		}
	end
	Wait(1000)
	AnimpostfxPlay("RespawnPulse01")
	MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
		{
			title = T.MenuCreation.title,
			subtext = T.MenuCreation.subtitle,
			align = Config.Align,
			elements = elements,
			itemHeight = "4vh",
		},

		function(data, menu)
			if (data.current.value == "back") then -- go back
				createMainCam()
				addNewelements(menu)
				for key, value in pairs(menu.data.elements) do
					if value.value == "delete" or value.value == "back" or value.value == "select" then
						menu.removeElementByValue(value.value, false)
					end
				end
				menu.refresh()
				SetCamActiveWithInterp(mainCam, LastCam, 3000, 500, 500)
				created = true
			end

			if (data.current.value == "choose") then
				selectedChar = data.current.index
				--local char = data.current.char
				local dataConfig = Config.SpawnPosition[random].positions[selectedChar]
				local cam = dataConfig.Cam
				SetCamActiveWithInterp(cam, mainCam or LastCam, 3000, 500, 500)
				--local playername = char.firstname .. " " .. char.lastname
				LastCam = cam
				-- MOTION BLUR
				Citizen.InvokeNative(0x45FD891364181F9E, cam, 30.0)

				if IsCamActive(mainCam) then
					SetCamActive(mainCam, false)
					mainCam = nil
				end

				if created then
					created = false
					for _, value in pairs(menu.data.elements) do
						if value.value == "create" then
							menu.removeElementByValue(value.value, false)
						end
					end
					menu.addNewElement({
						label = T.MainMenu.Choose,
						value = "select",
						desc = imgPath:format("character_creator_appearance") .. " <br> " .. T.MainMenu.ChooseDesc,
						char = selectedChar,
						itemHeight = "2vh",
					})
					if Config.AllowPlayerDeleteCharacter then
						menu.addNewElement({
							label = T.MainMenu.Delete,
							value = "delete",
							desc = imgPath:format("character_creator_appearance") .. " <br> " .. T.MainMenu.DeleteDesc,
							char = selectedChar,
							Data = dataConfig,
							itemHeight = "2vh",
						})
					end
					menu.addNewElement({
						label = T.MainMenu.ReturnMenu,
						value = "back",
						desc = imgPath:format("character_creator_appearance") .. " <br> " .. T.MainMenu.ReturnMenuDesc,
						char = data.current.char,
						itemHeight = "2vh",
					})
					menu.refresh()
				else
					-- chane elements only
					for key, value in pairs(menu.data.elements) do
						if value.value == "delete" and Config.AllowPlayerDeleteCharacter then
							menu.setElement(key, "label", "Delete")
							menu.setElement(key, "char", selectedChar)
							menu.setElement(key, "Data", dataConfig)
							menu.refresh()
						elseif value.value == "select" then
							menu.setElement(key, "label", "Spawn")
							menu.setElement(key, "char", selectedChar)
							menu.refresh()
						end
					end
				end
			end

			if Config.AllowPlayerDeleteCharacter then
				if (data.current.value == "delete") and not pressed then
					pressed = true
					DisplayHud(true)
					exports[GetCurrentResourceName()]:_UI_FEED_POST_OBJECTIVE(-1,
						'Press Delete to erase this character , or  press backspace to cancel')
					while true do
						Wait(0)

						if IsControlJustPressed(0, joaat("INPUT_CREATOR_DELETE")) then
							N_0xdd1232b332cbb9e7(3, 1, 0)
							break
						end

						if IsControlJustPressed(0, joaat("INPUT_FRONTEND_CANCEL")) then
							N_0xdd1232b332cbb9e7(3, 1, 0)
							pressed = false
							return
						end
					end
					DeleteEntity(data.current.Data.PedHandler)

					-- * remove elements not needed * --
					for key, value in pairs(menu.data.elements) do
						if value.value == "choose" and key == selectedChar then
							menu.removeElementByIndex(key, true)
						end
						if value.value == "delete" or value.value == "back" or value.value == "select" then
							menu.removeElementByValue(value.value, false)
						end
					end
					menu.refresh()
					TriggerServerEvent("vorpcharacter:deleteCharacter", myChars[selectedChar].charIdentifier)
					table.remove(myChars, selectedChar)

					-- * if no characters left, go back to character creation * --
					if #myChars == 0 or myChars == nil then
						TriggerEvent("vorpcharacter:startCharacterCreator")
						return finish(false)
					end

					createMainCam()
					SetCamActiveWithInterp(mainCam, data.current.Data.Cam, 3000, 500, 500)
					addNewelements(menu)
					menu.refresh()
					created = true
					pressed = false
				end
			end

			if (data.current.value == "create") then
				finish(false)
				Wait(2000)
				TriggerEvent("vorpcharacter:startCharacterCreator")
			end

			if (data.current.value == "select") then
				AnimpostfxPlay("RespawnPulse01")
				selectedChar = data.current.char
				local dataConfig = Config.SpawnPosition[random].positions[selectedChar]
				Citizen.InvokeNative(0x524B54361229154F, dataConfig.PedHandler, "", -1, false, "", -1.0, 0)
				finish(true)
				CharSelect()
			end
		end, function(menu, data)

		end)
end

function CharSelect()
	Wait(1000)
	local charIdentifier = myChars[selectedChar].charIdentifier
	local nModel = tostring(myChars[selectedChar].skin.sex)
	CachedSkin = myChars[selectedChar].skin
	CachedComponents = myChars[selectedChar].components
	TriggerServerEvent("vorp_CharSelectedCharacter", charIdentifier)

	RequestModel(nModel)
	while not HasModelLoaded(nModel) do
		Wait(0)
	end
	Wait(1000)
	SetPlayerModel(PlayerId(), joaat(nModel), false)
	SetModelAsNoLongerNeeded(nModel)
	Wait(1000)
	LoadPlayerComponents(PlayerPedId(), CachedSkin, CachedComponents)
	NetworkClearClockTimeOverride()
	FreezeEntityPosition(PlayerPedId(), false)
	SetEntityVisible(PlayerPedId(), true)
	SetEntityInvincible(PlayerPedId(), false)
	local coords = myChars[selectedChar].coords
	local heading
	local playerCoords
	if not coords then
		playerCoords = Config.SpawnCoords.position
		heading = Config.SpawnCoords.heading
	else
		playerCoords = vector3(tonumber(coords.x), tonumber(coords.y), tonumber(coords.z))
		heading = coords.heading
	end
	local isDead = myChars[selectedChar].isDead
	TriggerEvent("vorp:initCharacter", playerCoords, heading, isDead) -- in here players will be removed from instance
	DoScreenFadeIn(1000)
end

RegisterNetEvent("vorpcharacter:reloadafterdeath")
AddEventHandler("vorpcharacter:reloadafterdeath", function()
	Wait(5000)
	LoadPlayer(joaat("CS_dutch"))
	SetPlayerModel(PlayerId(), joaat("CS_dutch"), false)
	IsPedReadyToRender()
	LoadPlayerComponents(PlayerPedId(), myChars[selectedChar].skin, myChars[selectedChar].components)
	SetModelAsNoLongerNeeded(joaat("CS_dutch"))
	--heal ped after death
	local ped = PlayerPedId()
	Citizen.InvokeNative(0xC6258F41D86676E0, ped, 0, 100)
	SetEntityHealth(ped, 600, 1)
	Citizen.InvokeNative(0xC6258F41D86676E0, ped, 1, 100)
	Citizen.InvokeNative(0x675680D089BFA21F, ped, 1065330373)
end)


function LoadPlayerComponents(ped, skin, components)
	local gender = "Male"

	if joaat(skin.sex) ~= GetEntityModel(ped) then
		local skinS
		if not Custom then
			skinS = skin.sex
		else
			skinS = Custom
		end
		-- then player is npc
		LoadPlayer(joaat(skinS))
		SetPlayerModel(PlayerId(), joaat(skinS), false)
		IsPedReadyToRender()
		Citizen.InvokeNative(0xA91E6CF94404E8C9, ped)
		ped = PlayerPedId()
		SetModelAsNoLongerNeeded(joaat(skinS))
		Custom = nil
	end

	if skin.sex ~= "mp_male" then
		Citizen.InvokeNative(0x77FF8D35EEC6BBC4, ped, 7, true)
		gender = "Female"
	else
		Citizen.InvokeNative(0x77FF8D35EEC6BBC4, ped, 4, true)
	end

	skin = LoadAll(gender, ped, skin, components)

	-- Load our face textures
	FaceOverlay("beardstabble", skin.beardstabble_visibility, 1, 1, 0, 0, 1.0, 0, 1, skin.beardstabble_color_primary, 0,
		0, 1, skin.beardstabble_opacity)
	FaceOverlay("hair", skin.hair_visibility, 1, 1, 0, 0, 1.0, 0, 1, skin.hair_color_primary, 0, 0, 1, skin.hair_opacity)
	FaceOverlay("scars", skin.scars_visibility, skin.scars_tx_id, 0, 0, 1, 1.0, 0, 0, 0, 0, 0, 1, skin.scars_opacity)
	FaceOverlay("spots", skin.spots_visibility, skin.spots_tx_id, 0, 0, 1, 1.0, 0, 0, 0, 0, 0, 1, skin.spots_opacity)
	FaceOverlay("disc", skin.disc_visibility, skin.disc_tx_id, 0, 0, 1, 1.0, 0, 0, 0, 0, 0, 1, skin.disc_opacity)
	FaceOverlay("complex", skin.complex_visibility, skin.complex_tx_id, 0, 0, 1, 1.0, 0, 0, 0, 0, 0, 1,
		skin.complex_opacity)
	FaceOverlay("acne", skin.acne_visibility, skin.acne_tx_id, 0, 0, 1, 1.0, 0, 0, 0, 0, 0, 1, skin.acne_opacity)
	FaceOverlay("ageing", skin.ageing_visibility, skin.ageing_tx_id, 0, 0, 1, 1.0, 0, 0, 0, 0, 0, 1, skin.ageing_opacity)
	FaceOverlay("freckles", skin.freckles_visibility, skin.freckles_tx_id, 0, 0, 1, 1.0, 0, 0, 0, 0, 0, 1,
		skin.freckles_opacity)
	FaceOverlay("moles", skin.moles_visibility, skin.moles_tx_id, 0, 0, 1, 1.0, 0, 0, 0, 0, 0, 1, skin.moles_opacity)
	FaceOverlay("shadows", skin.shadows_visibility, 1, 1, 0, 0, 1.0, 0, 1, skin.shadows_palette_color_primary,
		skin.shadows_palette_color_secondary, skin.shadows_palette_color_tertiary, skin.shadows_palette_id,
		skin.shadows_opacity)
	FaceOverlay("eyebrows", skin.eyebrows_visibility, skin.eyebrows_tx_id, 1, 0, 0, 1.0, 0, 1, skin.eyebrows_color, 0, 0,
		1, skin.eyebrows_opacity)
	FaceOverlay("eyeliners", skin.eyeliner_visibility, 1, 1, 0, 0, 1.0, 0, 1, skin.eyeliner_color_primary, 0, 0,
		skin.eyeliner_tx_id, skin.eyeliner_opacity)
	FaceOverlay("blush", skin.blush_visibility, skin.blush_tx_id, 1, 0, 0, 1.0, 0, 1, skin.blush_palette_color_primary, 0,
		0, 1, skin.blush_opacity)
	FaceOverlay("lipsticks", skin.lipsticks_visibility, 1, 1, 0, 0, 1.0, 0, 1, skin.lipsticks_palette_color_primary,
		skin.lipsticks_palette_color_secondary, skin.lipsticks_palette_color_tertiary, skin.lipsticks_palette_id,
		skin.lipsticks_opacity)
	canContinue = true
	FaceOverlay("grime", skin.grime_visibility, skin.grime_tx_id, 0, 0, 1, 1.0, 0, 0, 0, 0, 0, 1, skin.grime_opacity)
	Wait(200)
	TriggerServerEvent("vorpcharacter:reloadedskinlistener") -- this event can be listened to whenever u need to listen for rc
	Citizen.InvokeNative(0xD710A5007C2AC539, PlayerPedId(), 0x3F1F01E5, 0)
end

function FaceOverlay(name, visibility, tx_id, tx_normal, tx_material, tx_color_type, tx_opacity, tx_unk, palette_id,
					 palette_color_primary, palette_color_secondary, palette_color_tertiary, var, opacity)
	local visibility = visibility or 0
	local tx_id = tx_id or 0
	local palette_color_primary = palette_color_primary or 0
	local opacity = opacity or 1.0


	for k, v in pairs(Config.overlay_all_layers) do
		if v.name == name then
			v.visibility = visibility
			if visibility ~= 0 then
				v.tx_normal = tx_normal
				v.tx_material = tx_material
				v.tx_color_type = tx_color_type
				v.tx_opacity = tx_opacity
				v.tx_unk = tx_unk

				if tx_color_type == 0 then
					v.palette = Config.color_palettes[name][palette_id]
					v.palette_color_primary = palette_color_primary == 0 and 0x3F6E70FF or palette_color_primary
					v.palette_color_secondary = palette_color_secondary or 0
					v.palette_color_tertiary = palette_color_tertiary or 0
				end

				v.var = 0
				v.tx_id = tx_id == 0 and Config.overlays_info[name][1].id or Config.overlays_info[name][tx_id].id

				if name == "shadows" or name == "eyeliners" or name == "lipsticks" then
					v.var = var or 0
					v.tx_id = Config.overlays_info[name][1].id
				end

				v.opacity = opacity == 0 and 1.0 or opacity

				if name == "grime" then
					v.visibility = 0
				end
			end
		end
	end

	if canContinue then
		canContinue = false
		Citizen.CreateThread(StartOverlay)
	end
end

function StartOverlay()
	local ped = PlayerPedId()
	local current_texture_settings = Config.texture_types.Male

	if CachedSkin.sex ~= tostring("mp_male") then
		current_texture_settings = Config.texture_types.Female
	end

	if textureId ~= -1 then
		Citizen.InvokeNative(0xB63B9178D0F58D82, textureId) -- reset texture
		Citizen.InvokeNative(0x6BEFAA907B076859, textureId) -- remove texture
	end

	textureId = Citizen.InvokeNative(0xC5E7204F322E49EB, CachedSkin.albedo,
		current_texture_settings.normal, current_texture_settings.material)
	for k, v in pairs(Config.overlay_all_layers) do
		if v.visibility ~= 0 then
			local overlay_id = Citizen.InvokeNative(0x86BB5FF45F193A02, textureId, v.tx_id, v.tx_normal,
				v.tx_material, v.tx_color_type, v.tx_opacity, v.tx_unk)
			if v.tx_color_type == 0 then
				Citizen.InvokeNative(0x1ED8588524AC9BE1, textureId, overlay_id, v.palette); -- apply palette
				Citizen.InvokeNative(0x2DF59FFE6FFD6044, textureId, overlay_id, v.palette_color_primary,
					v.palette_color_secondary, v.palette_color_tertiary)        -- apply palette colours
			end
			Citizen.InvokeNative(0x3329AAE2882FC8E4, textureId, overlay_id, v.var) -- apply overlay variant
			Citizen.InvokeNative(0x6C76BC24F8BB709A, textureId, overlay_id, v.opacity) -- apply overlay opacity
		end
	end

	while not Citizen.InvokeNative(0x31DC8D3F216D8509, textureId) do -- wait till texture fully loaded
		Wait(0)
	end

	Citizen.InvokeNative(0x0B46E25761519058, ped, joaat("heads"), textureId) -- apply texture to current component in category "heads"
	Citizen.InvokeNative(0x92DAABA2C1C10B0E, textureId)                   -- update texture
	UpdateVariation(ped)
end

RegisterCommand("rc", function(source, args, rawCommand)
	local __player = PlayerPedId()
	local hogtied = Citizen.InvokeNative(0x3AA24CCC0D451379, __player)
	local cuffed = Citizen.InvokeNative(0x74E559B3BC910685, __player)
	local dead = IsEntityDead(__player)
	if not hogtied and not cuffed and not dead then
		if not next(CachedSkin) and not next(CachedComponents) then
			return
		end

		if args[1] ~= "" then
			Custom = args[1]
		end

		LoadPlayerComponents(__player, CachedSkin, CachedComponents)
	end
end)

-- work arround to fix scale issues
CreateThread(function()
	while true do
		local dead = IsEntityDead(PlayerPedId())
		if myChars[selectedChar] then
			if myChars[selectedChar].skin and not dead then
				SetPedScale(PlayerPedId(), myChars[selectedChar].skin.Scale)
			end
		end
		Wait(1000)
	end
end)
