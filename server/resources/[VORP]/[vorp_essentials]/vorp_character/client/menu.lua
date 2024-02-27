---@diagnostic disable: undefined-global
local Divider =
    "<img style='margin-top: 10px;margin-bottom: 10px; margin-left: -10px;'src='nui://" ..
    GetCurrentResourceName() .. "/images/divider_line.png'>"
local imgPath = "<img style='max-height:500px;max-width:300px;float: center;'src='nui://" ..
    GetCurrentResourceName() .. "/images/%s.png'>"
local imgPath1 =
    "<img style='max-height:20px;max-width:20px;margin-left: 10px;' src='nui://" ..
    GetCurrentResourceName() .. "/images/%s.png'>"
local path =
    "<img style='max-height:532px;max-width:344px;float: center;'src='nui://" ..
    GetCurrentResourceName() .. "/clothingfemale/%s.png'>"
local __CHARNAME = nil
local __DESC = nil
local __VALUE = nil
local __VALUE1 = nil
local __LABEL = nil
local __NickName = nil
local __Age = nil
local __CharDescription = nil
local Playerdata = {}
local Title = T.MenuCreation.title
local MenuData = exports.vorp_menu:GetMenuData()
local PlayerFixClothing = {}
PlayerTrackingData = {}
SkinColorTracker = 1
HeadIndexTracker = 9


function HasBuggedShirt()
    if PlayerClothing.Vest.data then
        if PlayerClothing.Vest.data.needFix then
            if PlayerClothing.Vest.comp ~= -1 then
                IsPedReadyToRender()
                UpdateShopItemWearableState(PlayerClothing.Shirt.comp, -130653580)
                UpdatePedVariation()
            end
        end
    end

    if PlayerClothing.Coat.data then
        if PlayerClothing.Coat.data.needFix then
            if PlayerClothing.Coat.comp ~= -1 then
                IsPedReadyToRender()
                UpdateShopItemWearableState(PlayerClothing.Shirt.comp, -130653580)
                UpdatePedVariation()
            end
        end
    end

    if PlayerClothing.CoatClosed.data then
        if PlayerClothing.CoatClosed.data.needFix then
            if PlayerClothing.CoatClosed.comp ~= -1 then
                IsPedReadyToRender()
                UpdateShopItemWearableState(PlayerClothing.Shirt.comp, -130653580)
                UpdatePedVariation()
            end
        end
    end
end

function ReloadAllComponents()
    for key, value in pairs(PlayerClothing) do
        if value.comp ~= -1 then
            if not value.data then
                PlayerClothing[key].data = {}
            end

            if not PlayerFixClothing[key] then
                PlayerFixClothing[key] = {}
            end

            if key == "Boots" then
                local v = PlayerFixClothing[key][value.comp]
                if v and value.showSkin then
                    RemoveTagFromMetaPed(Config.HashList.Boots)
                end
            end


            local isMpComponent = true
            local wearable, compHash = GetComponentsWithWearableState(key, isMpComponent)
            PlayerClothing[key].data.wearable = wearable
            IsPedReadyToRender()
            ApplyShopItemToPed(value.comp)
            UpdateShopItemWearableState(compHash or value.comp, value.data.wearable)
            UpdatePedVariation()
            if key == "Shirt" then
                HasBuggedShirt()
            end
            --APPLY TINT LOGIC
            if PlayerTrackingData[key] then
                local data = PlayerTrackingData[key][value.comp]
                if data then
                    if data.tint0 ~= 0 or data.tint1 ~= 0 or data.tint2 ~= 0 or data.palette ~= 0 then
                        local TagData = GetMetaPedData(key == "Boots" and "boots" or key)
                        if TagData then
                            local palette = (data.palette ~= 0) and data.palette or TagData.palette
                            SetMetaPedTag(PlayerPedId(), TagData.drawable, TagData.albedo, TagData.normal,
                                TagData.material, palette, data.tint0, data.tint1, data.tint2)
                        end
                    end
                end
            end
        end
    end
end

function Applycomponents(comp, category)
    if comp then
        PlayerClothing[category].comp = comp.hex

        if not PlayerClothing[category].data then
            PlayerClothing[category].data = {}
        end

        if comp.needsFix or comp.showSkin then
            if not PlayerFixClothing[category] then
                PlayerFixClothing[category] = {}
            end

            PlayerFixClothing[category][comp.hex] = { needsFix = comp.needsFix, showSkin = comp.showSkin }
            PlayerClothing[category].data.showSkin = comp.showSkin
        end

        if comp.remove then
            PlayerClothing[category].data.remove = comp.remove
        end

        RemoveSpecifiedCompByCategory(comp)
        ApplyShopItemToPed(comp.hex)
        UpdatePedVariation()

        if not comp.remove then
            ReloadAllComponents()
            RemoveCompsCantWearTogether(category)
            UpdatePedVariation()
        end
    else
        ReloadAllComponents()
        UpdatePedVariation()
    end
end

--CLEAN UP
local function FinishCreation(anim, anim1)
    local __player = PlayerPedId()
    DoScreenFadeOut(0)
    repeat Wait(0) until IsScreenFadedOut()
    exports.weathersync:setSyncEnabled(true)
    Citizen.InvokeNative(0x706D57B0F50DA710, "MC_MUSIC_STOP")                                              -- STOP_AUDIO
    Citizen.InvokeNative(0x5A8B01199C3E79C3)                                                               -- LOAD_SCENE_STOP
    Citizen.InvokeNative(0x120C48C614909FA4, "AZL_RDRO_Character_Creation_Area", true)                     -- CLEAR_AMBIENT_ZONE_LIST_STATE
    Citizen.InvokeNative(0x9D5A25BADB742ACD, "AZL_RDRO_Character_Creation_Area_Other_Zones_Disable", true) -- CLEAR_AMBIENT_ZONE_LIST_STATE
    Core.instancePlayers(0)                                                                                -- remove instance
    DestroyAllCams(true)
    IsInCharCreation = false
    InCharacterCreator = false
    RemoveImaps()
    ClearTimecycleModifier()
    N_0xdd1232b332cbb9e7(3, 1, 0)
    AnimpostfxStopAll()
    if anim and anm1 then
        Citizen.InvokeNative(0x84EEDB2C6E650000, anim)
        Citizen.InvokeNative(0x84EEDB2C6E650000, anim1)
    end
    TriggerEvent("vorp:initNewCharacter")
    SetEntityInvincible(__player, false)
    SetEntityVisible(__player, true)
    FreezeEntityPosition(__player, false)
    ClearPedTasksImmediately(__player, true)
    NetworkEndTutorialSession()
    RemoveAnimDict("FACE_HUMAN@GEN_MALE@BASE")
end
local TotalAmountToPay = {}
function GetDescriptionLayout(value, price)
    local desc = imgPath:format(value.img) ..
        "<br><br>" .. value.desc .. "<br><br><br><br>" .. Divider ..
        "<br><span style='font-family:crock; float:left; font-size: 22px;'>" ..
        T.PayToShop.Total .. " </span><span style='font-family:crock;float:right; font-size: 22px;'>"

    if ShopType == "secondchance" then
        if ConfigShops.SecondChanceCurrency == 0 then
            desc = desc .. T.PayToShop.Currency
        elseif ConfigShops.SecondChanceCurrency == 1 then
            desc = desc .. T.Other.Gold
        elseif ConfigShops.SecondChanceCurrency == 2 then
            desc = desc .. T.PayToShop.Tokens
        end
        desc = desc .. (price or GetCurrentAmmountToPay()) .. "</span><br>" .. Divider
        return desc
    end
end

function OpenCharCreationMenu(clothingtable, value)
    Title = IsInClothingStore and "Clothing Store" or T.MenuCreation.title
    local SubTitle = "<span style='font-size:25px;'>" .. T.MenuCreation.subtitle .. "</span><br><br>"
    if Resolution.width <= 1920 then
        SubTitle = T.MenuCreation.subtitle
    end
    MenuData.CloseAll()

    local elements = {}

    if IsInCharCreation or ShopType == "secondchance" then
        elements[#elements + 1] = {
            label = T.MenuCreation.element.label .. "<br><span style='opacity:0.6;'>" .. T.Secondchance.DescAppearance .. "</span>",
            value = "appearance",
            desc = imgPath:format("character_creator_head") .. "<br>" .. T.MenuCreation.element.desc .. "<br><br>" .. Divider .. "<br><br>"
        }

        elements[#elements + 1] = {
            label = T.MenuCreation.element2.label .. "<br><span style='opacity:0.6;'>" .. T.Secondchance.DescClothing .. "</span>",
            value = "clothing",
            desc = imgPath:format("clothing_generic_outfit") .. "<br> " .. T.MenuCreation.element2.desc .. "<br><br>" .. Divider .. "<br><br>",
        }
        -- confirm pay
        if not IsInCharCreation then
            local descLayout = GetDescriptionLayout({ img = "menu_icon_tick", desc = T.Inputs.confirmpurchase }, ConfigShops.SecondChancePrice)
            elements[#elements + 1] = {
                label = T.Inputs.confirmpurchase,
                value = "buy",
                desc = descLayout
            }
        end
    end


    if IsInCharCreation then
        elements[#elements + 1] = {
            label = __Age or T.MenuCreation.element5.label .. "<br><span style='opacity:0.6;'>" .. T.MenuCreation.none .. "</span>",
            value = "age",
            desc = imgPath:format("emote_greet_hey_you") .. "<br> " .. T.MenuCreation.element5.desc .. "<br><br>" .. Divider .. "<br><br>",

        }
        elements[#elements + 1] = {
            label = __CharDescription or T.MenuCreation.element6.label .. "<br><span style='opacity:0.6;'>" .. T.MenuCreation.none .. "</span>",
            value = "desc",
            desc = imgPath:format("emote_greet_hey_you") .. "<br>" .. T.MenuCreation.element6.desc .. "<br><br>" .. Divider .. "<br><br>",
        }
        elements[#elements + 1] = {
            label = __NickName or T.MenuCreation.element7.label .. "<br><span style='opacity:0.6;'>" .. T.MenuCreation.none .. "</span>",
            value = "nickname",
            desc = imgPath:format("emote_greet_hey_you") .. "<br> " .. T.MenuCreation.element7.desc .. "<br>" .. T.MenuCreation.element7.desc2 .. "<br><br>" .. Divider .. "<br><br>",
        }
        elements[#elements + 1] = {
            label = __CHARNAME or T.MenuCreation.element3.label .. "<br><span style='opacity:0.6;'>" .. "" .. T.MenuCreation.none .. "" .. "</span>",
            value = __VALUE1 or "name",
            desc = __DESC or imgPath:format("emote_greet_hey_you") .. "<br> " .. T.MenuCreation.element3.desc .. "<br><br>" .. Divider .. "<br><br>",

        }
        elements[#elements + 1] = {
            label = __LABEL or ("<span style='color: Grey;'>" .. T.MenuCreation.element4.label .. "<br>" .. T.MenuCreation.finish .. "" .. "</span>"),
            value = __VALUE or "not",
            desc = imgPath:format("generic_walk_style") .. "<br> " .. "<br><br>" .. Divider .. "<br><br>" .. T.MenuCreation.element4.desc,

        }
    end
    MenuData.Open('default', GetCurrentResourceName(), 'OpenCharCreationMenu',
        {
            title = Title,
            subtext = SubTitle,
            align = Config.Align,
            elements = elements,
            itemHeight = "4vh",
        },

        function(data, menu)
            if (data.current.value == "buy") then
                local NewTable = GetNewCompOldStructure(PlayerClothing)
                local result = Core.Callback.TriggerAwait("vorp_character:callback:PayForSecondChance", { skin = PlayerSkin, comps = NewTable, compTints = PlayerTrackingData })
                if result then
                    CachedComponents = ConvertTableComps(PlayerClothing, PlayerTrackingData)
                    CachedSkin = PlayerSkin
                end
                menu.close()
                return BackFromMenu(value)
            end
            if (data.current.value == "clothing") then
                return OpenClothingMenu(clothingtable, value)
            end

            if (data.current.value == "appearance") then
                return OpenAppearanceMenu(clothingtable, value)
            end

            if (data.current.value == "desc") then
                local MyInput = {
                    type = "enableinput",
                    inputType = "textarea",
                    button = T.Inputs.confirm,
                    placeholder = T.Placeholder.CharDesc,
                    style = "block",
                    attributes = {
                        inputHeader = T.Inputs.inputHeadertype,
                        type = "text",
                        pattern = T.Inputs.imputlangdesc,
                        title = T.Inputs.title,
                        style = "border-radius: 10px; background-color: ; border:none;"
                    }
                }
                TriggerEvent("vorpinputs:advancedInput", json.encode(MyInput), function(result)
                    local Result = tostring(result)
                    if Result ~= nil and Result ~= "" then
                        __CharDescription = T.MenuCreation.element6.label ..
                            "<br><span style='opacity:0.6;'>" ..
                            T.MenuCreation.element6.desc2 .. "</span>" .. imgPath1:format("menu_icon_tick")
                        Playerdata.desc = Result
                        menu.setElement(4, "desc", imgPath:format("emote_greet_hey_you") .. "<br><br>" .. Result)
                        menu.setElement(4, "label", __CharDescription)
                        menu.setElement(4, "itemHeight", "4vh")
                        menu.refresh()
                    end
                end)
            end

            -- nick name
            if (data.current.value == "nickname") then
                local MyInput = {
                    type = "enableinput",
                    inputType = "input",
                    button = T.Inputs.confirm,
                    placeholder = T.Placeholder.NickName,
                    style = "block",
                    attributes = {
                        inputHeader = T.Inputs.inputHeadertype,
                        type = "text",
                        pattern = T.Inputs.imputlang, -- can change here for your language
                        title = T.Inputs.title,
                        style = "border-radius: 10px; background-color: ; border:none;"
                    }
                }
                TriggerEvent("vorpinputs:advancedInput", json.encode(MyInput), function(result)
                    local Result = tostring(result)
                    if Result ~= nil and Result ~= "" then
                        __NickName = T.MenuCreation.element7.nickname .. "<br> <span style='opacity:0.6;'>" .. Result .. "</span>" .. imgPath1:format("menu_icon_tick")
                        Playerdata.nickname = Result
                        menu.setElement(5, "label", __NickName)
                        menu.setElement(5, "itemHeight", "4vh")
                        menu.refresh()
                    end
                end)
            end

            if (data.current.value == "age") then
                local MyInput = {
                    type = "enableinput",
                    inputType = "input",
                    button = T.Inputs.confirm,
                    placeholder = T.Placeholder.SetAge,
                    style = "block",
                    attributes = {
                        inputHeader = T.Inputs.inputHeadertype,
                        type = "text",
                        -- dont allow negative numbers
                        min = "0",
                        title = T.Inputs.title,
                        style = "border-radius: 10px; background-color: ; border:none;",
                    }
                }
                TriggerEvent("vorpinputs:advancedInput", json.encode(MyInput), function(result)
                    local Result = tostring(result)
                    if Result ~= nil and Result ~= "" then
                        __Age = T.MenuCreation.element5.label .. "<br><span style='opacity:0.6;'>" .. Result .. "</span>" .. imgPath1:format("menu_icon_tick")
                        Playerdata.age = Result
                        menu.setElement(3, "label", __Age)
                        menu.setElement(3, "itemHeight", "4vh")
                        menu.refresh()
                    end
                end)
            end

            if (data.current.value == "name") then -- check if it has been built
                local MyInput = {
                    type = "enableinput",
                    inputType = "input",
                    button = T.Inputs.confirm,
                    placeholder = T.Placeholder.FirstLastName,
                    style = "block",
                    attributes = {
                        inputHeader = T.Inputs.inputHeadertype,
                        type = "text",
                        pattern = T.Inputs.imputlang, -- can change here for your language
                        title = T.Inputs.title,
                        style = "border-radius: 10px; background-color: ; border:none;"
                    }
                }
                TriggerEvent("vorpinputs:advancedInput", json.encode(MyInput), function(result)
                    local Result = tostring(result)
                    if Result ~= nil and Result ~= "" then
                        if GetName(Result) == nil then
                            return TriggerEvent("vorp:TipRight", T.Inputs.banned, 4000)
                        end

                        if GetName(Result) == false then
                            return TriggerEvent("vorp:TipRight", T.Inputs.fristlast, 4000)
                        end

                        local FirstName, LastName = GetName(Result)
                        Playerdata.firstname = FirstName
                        Playerdata.lastname = LastName
                        __CHARNAME = T.MenuCreation.charname .. "<br><span style='opacity:0.6;'>" .. FirstName .. " " .. LastName .. "</span>" .. imgPath1:format("menu_icon_tick")
                        __DESC = imgPath:format("emote_greet_hey_you") .. "<br>" .. T.MenuCreation.label .. "<br> " .. FirstName .. " " .. LastName .. "<br><br>" .. Divider .. "<br><br>"
                        __VALUE = "save"
                        __VALUE1 = "not"
                        __LABEL = T.MenuCreation.element4.label
                        menu.setElement(6, "label", __CHARNAME)
                        menu.setElement(6, "value", __VALUE1)
                        menu.setElement(6, "desc", __DESC)
                        menu.setElement(6, "itemHeight", "4vh")
                        menu.removeElementByIndex(7)
                        menu.addNewElement({
                            label = T.MenuCreation.element4.label,
                            value = __VALUE,
                            desc = imgPath:format("generic_walk_style") .. "<br> " .. T.MenuCreation.element4.desc .. "<br><br>" .. Divider .. "<br><br>",
                        })
                        menu.refresh()
                    end
                end)
            end

            if (data.current.value == "save") then
                menu.close()
                local NewTable = GetNewCompOldStructure(PlayerClothing)
                -- save data
                Playerdata.skin = json.encode(PlayerSkin)
                Playerdata.comps = json.encode(NewTable)
                Playerdata.compTints = json.encode(PlayerTrackingData)
                Playerdata.gender = GetGender()
                Playerdata.age = Playerdata.age or 30
                Playerdata.nickname = Playerdata.nickname or "none"
                Playerdata.charDescription = Playerdata.desc or "none"
                -- start scenes
                EnableCharCreationPrompts(false)
                local animscene = SetupScenes("Pl_Edit_to_Photo_" .. GetGender())
                StartAnimScene(animscene)
                repeat Wait(0) until Citizen.InvokeNative(0xCBFC7725DE6CE2E0, animscene)
                local NewCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -560.55, -3782.15, 238.93, -5.73, 0.00, -96.05, 45, false, 0)
                SetCamFov(NewCam, 40.0)
                RenderScriptCams(true, false, 0, true, true, 0)
                Wait(2100)
                SetCamActive(NewCam, true)
                Wait(500)
                DoScreenFadeOut(50)
                SetCamFocusDistance(NewCam, 4.0)
                AnimpostfxPlay("CameraViewfinderStudioPosse")
                DoScreenFadeIn(0)
                local animscene1 = SetupScenes("PI_Show_Hands_" .. GetGender())
                StartAnimScene(animscene1)
                repeat Wait(0) until Citizen.InvokeNative(0xCBFC7725DE6CE2E0, animscene1)
                Wait(4000)
                AnimpostfxPlay("l_00078a17dm")
                Wait(2000)
                CreateThread(function()
                    while InCharacterCreator do
                        Wait(0)
                        DrawText3D(-558.64, -3782.30, 238.5, Playerdata.firstname .. " " .. Playerdata.lastname, { 255, 255, 255, 255 })
                    end
                end)
                ShowBusyspinnerWithText(T.Other.spinnertext3)
                PlaySoundFrontend("Ready_Up_Flash", "RDRO_In_Game_Menu_Sounds", true, 0)
                TakePhoto()
                Wait(7000)
                BusyspinnerOff()
                TriggerServerEvent("vorpcharacter:saveCharacter", Playerdata)
                CachedComponents = ConvertTableComps(PlayerClothing, PlayerTrackingData)
                CachedSkin = PlayerSkin
                SetCamFocusDistance(NewCam, 1.0)
                FinishCreation(animscene, animscene1)
            end
        end, function(data, menu)

        end)
end

function BackFromMenu(value)
    DoScreenFadeOut(1000)
    repeat Wait(0) until IsScreenFadedOut()
    Core.instancePlayers(0)
    IsInClothingStore = false
    DisplayRadar(true)
    SetEntityInvincible(PlayerPedId(), false)
    SetEntityVisible(PlayerPedId(), true)
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), value.SpawnBack.Position.x, value.SpawnBack.Position.y, value.SpawnBack.Position.z, true, true, true, false)
    SetEntityHeading(PlayerPedId(), value.SpawnBack.Position.w)
    FreezeEntityPosition(PlayerPedId(), false)
    ExecuteCommand("rc")
    Wait(3000)
    SetGameplayCamRelativeHeading(0.0, 1.0)
    ClearPedTasksImmediately(PlayerPedId(), true)
    DoScreenFadeIn(1500)
    repeat Wait(0) until IsScreenFadedIn()
    PlayerTrackingData = {}
    TotalAmountToPay = {}
    HairIndexTracker = {}
    HairColorIndexTracker = {}
    LocalPlayer.state:set('PlayerIsInCharacterShops', false, true)
end

--* CLOTHING MENU
function OpenClothingMenu(Table, value, Outfits)
    Title = IsInClothingStore and "Clothing Store" or T.MenuClothes.title
    MenuData.CloseAll()

    local menuSpace = "<br><br><br><br><br><br><br><br><br><br><br>"
    local SubTitle = "<span style='font-size: 25px;'>" .. T.MenuClothes.subtitle .. "</span><br><br>"

    if Resolution.width <= 1920 then
        menuSpace = "<br><br>"
        SubTitle = T.MenuClothes.subtitle
    end

    local gender       = GetGender()
    local ClothingData = SortData(Table)
    local elements     = {}

    if Outfits and ShopType == "clothing" and not IsInCharCreation then
        elements[#elements + 1] = {
            label = T.MenuOutfits.title .. "<br><span style='opacity:0.6;'>" .. #Outfits .. ' ' .. T.MenuOutfits.title .. "</span>",
            value = 'Outfits',
            desc = imgPath:format('clothing_generic_outfit') .. menuSpace .. Divider .. "<br> " .. T.MenuOutfits.option,
        }
    end

    for index, category in ipairs(ClothingData) do
        local ToLabel = T.MenuClothes
        if ToLabel[category] then
            elements[#elements + 1] = {
                label = ToLabel[category] .. "<br><span style='opacity:0.6;'>" .. #Table[category] .. ' ' .. T.MenuComponents.title .. "</span>",
                value = category,
                desc = gender == "female" and path:format(category) .. menuSpace .. Divider .. "<br><br> " .. T.MenuClothes.option or imgPath:format(category) .. menuSpace .. Divider .. "<br> " .. T.MenuClothes.option,
            }
        end
    end

    if ShopType == "clothing" and not IsInCharCreation then
        local descLayout = GetDescriptionLayout({ img = "menu_icon_tick", desc = T.Inputs.confirmpurchase })
        elements[#elements + 1] = {
            label = T.Inputs.confirmpurchase,
            value = "buy",
            desc = descLayout
        }
        -- close
        elements[#elements + 1] = {
            label = T.MainMenu.close,
            value = "close",
            desc = imgPath:format("cross") .. "<br><br>" .. T.MainMenu.closemenu .. "<br><br>" .. Divider .. "<br><br>",
        }
    end

    local lastmenu = (IsInCharCreation or ShopType == "secondchance") and "OpenCharCreationMenu" or nil

    MenuData.Open('default', GetCurrentResourceName(), 'OpenClothingMenu',
        {
            title = Title,
            subtext = SubTitle,
            align = Config.Align,
            elements = elements,
            lastmenu = lastmenu,
            itemHeight = "4vh",
        },

        function(data, menu)
            if IsInCharCreation or ShopType == "secondchance" then
                if (data.current == "backup") then -- go back
                    return _G[data.trigger](Table, value)
                end
            end

            if data.current.value == "Outfits" and #Outfits > 0 then
                OpenOutfitsMenu(Table, value, Outfits)
                return
            end

            if data.current.value == "close" then
                menu.close()
                return BackFromMenu(value)
            end

            if data.current.value == "buy" then
                if GetCurrentAmmountToPay() > 0 then
                    local MyInput = {
                        type = "enableinput",
                        inputType = "input",
                        button = T.Inputs.confirm,
                        placeholder = T.MenuOutfits.outfitName,
                        style = "block",
                        attributes = {
                            inputHeader = T.MenuOutfits.inputHeader2,
                            type = "textarea",
                            pattern = ".*",
                            title = T.Inputs.title,
                            style = "border-radius: 10px; background-color: ; border:none;"
                        }
                    }
                    TriggerEvent("vorpinputs:advancedInput", json.encode(MyInput), function(result)
                        local Result = tostring(result)
                        local NewTable = GetNewCompOldStructure(PlayerClothing)
                        local resultCb = Core.Callback.TriggerAwait("vorp_character:callback:PayToShop", { comps = NewTable, skin = CachedSkin, compTints = PlayerTrackingData, amount = GetCurrentAmmountToPay(), Result = Result, })
                        if resultCb then
                            AssertCachedComponents()
                            menu.close()
                            BackFromMenu(value)
                        end
                    end)
                end
            end

            if (data.current.value and data.current.value ~= "buy" and data.current.value ~= "Outfits") then
                if PlayerClothing.Dress.comp ~= -1 and gender == "Male" then
                    -- dont allow use these categories if player has dress on
                    if data.current.value == "Coat" or data.current.value == "Shirt" or data.current.value == "Vest" or data.current.value == "CoatClosed" then
                        return Core.NotifyObjective("You can't wear " .. data.current.value .. " with a Dress", 5000)
                    end
                end

                OpenComponentMenu(Table, data.current.value, value, Outfits)
            end
        end,
        function(data, menu)

        end)
end

function GetExtraPrice(category, comp)
    for categoryIndex, value in pairs(ConfigShops.Prices.clothing) do
        if category == categoryIndex then
            if value.extra and next(value.extra) then
                for index, v in ipairs(value.extra) do
                    if v.comp == comp then
                        return v.price
                    end
                end
            end
        end
    end
    return nil
end

function GetCurrentAmmountToPay()
    local Total = 0
    for _, value in pairs(TotalAmountToPay) do
        Total = Total + value
    end
    return Total
end

local TagData = {}

function OpenComponentMenu(table, category, value, Outfits)
    MenuData.CloseAll()
    local ToLabel = T.MenuClothes
    local label = ToLabel[category]
    local imgPath = "<img style='max-height:532px;max-width:380px; float: center; ' src='nui://" .. GetCurrentResourceName() .. "/images/%s.png'>"
    local elements = {}

    TagData = GetMetaPedData(category == "Boots" and "boots" or category)
    local InnitComp = -1

    if CachedComponents[category] then
        InnitComp = CachedComponents[category].comp
    else
        CachedComponents[category] = { comp = -1 }
    end

    local indexComp, indexColor, tint0, tint1, tint2, palette = GetTrackedData(category)

    local colorValue = 0
    if table[category] and table[category][indexColor] then
        colorValue = #table[category][indexColor]
    end

    local menuSpace = "<br><br><br><br><br><br><br>"
    local SubTitle = "<span style='font-size: 25px;'>" .. T.MenuComponents.subtitle .. "</span><br><br>"
    if Resolution.width <= 1920 then
        imgPath = "<img style='max-height:332px;max-width:280px; float: center; ' src='nui://" .. GetCurrentResourceName() .. "/images/%s.png'>"
        menuSpace = "<br><br>"
        SubTitle = T.MenuComponents.subtitle
    end

    if not PlayerTrackingData[category] then
        PlayerTrackingData[category] = {}
    end

    elements[#elements + 1] = {
        label = label .. "<br><span style='opacity:0.6;'>" .. #table[category] .. ' ' .. T.MenuComponents.element.label .. "</span>",
        type = "slider",
        value = indexComp or 0,
        info = true,
        min = -1,
        max = #table[category] + 1,
        desc = "<br><br>" .. imgPath:format(category) .. "<br><br><br>" .. T.MenuComponents.element3.desc .. #table[category] .. T.MenuComponents.element3.label .. category .. T.MenuComponents.element3.desc2 .. menuSpace .. Divider .. T.MenuComponents.scroll,
        itemHeight = "4vh",
    }

    elements[#elements + 1] = {
        label = label .. "<br><span style='opacity:0.6;'>" .. colorValue .. T.MenuComponents.element2.label .. "</span>",
        type = "slider",
        value = indexColor or 0,
        comp = table[category][(indexColor or 1)],
        min = indexColor and -1 or 0,
        max = indexColor and (colorValue + 1) or 0,
        desc = "<br><br>" .. imgPath:format(category) .. "<br><br><br>" .. T.MenuComponents.element2.desc .. menuSpace .. Divider .. T.MenuComponents.scroll,
        itemHeight = "4vh",
    }

    elements[#elements + 1] = {
        label = T.MenuComponents.element4.label,
        type = "remove",
        desc = "<br><br>" .. imgPath:format(category) .. "<br><br><br>" .. T.MenuComponents.element4.desc2 .. menuSpace .. Divider .. "<br>" .. T.MenuComponents.element4.desc3,
    }

    elements[#elements + 1] = {
        label = T.MenuComponents.tint.label,
        type = "slider",
        action = "tint0",
        value = tint0 or 0,
        min = 0,
        comp = InnitComp,
        max = 255,
        desc = "<br><br>" .. imgPath:format(category) .. "<br><br><br>" .. T.MenuComponents.tint.desc .. menuSpace .. Divider .. T.MenuComponents.scroll
    }

    elements[#elements + 1] = {
        label = T.MenuComponents.tint2.label,
        type = "slider",
        action = "tint1",
        value = tint1 or 0,
        comp = InnitComp,
        min = 0,
        max = 255,
        desc = "<br><br>" .. imgPath:format(category) .. "<br><br><br>" .. T.MenuComponents.tint2.desc .. menuSpace .. Divider .. T.MenuComponents.scroll
    }

    elements[#elements + 1] = {
        label = T.MenuComponents.tint3.label,
        type = "slider",
        action = "tint2",
        value = tint2 or 0,
        comp = InnitComp,
        min = 0,
        max = 255,
        desc = "<br><br>" .. imgPath:format(category) .. "<br><br><br>" .. T.MenuComponents.tint3.desc .. menuSpace .. Divider .. T.MenuComponents.scroll
    }


    local paletteId = 0
    if palette then
        for id, paletteHash in pairs(Config.clothesPalettes) do
            if paletteHash == palette then
                paletteId = id
                break
            end
        end
        if paletteId == 0 then
            Config.clothesPalettes[#Config.clothesPalettes + 1] = palette
            paletteId = #Config.clothesPalettes
        end
    end

    elements[#elements + 1] = {
        label = T.MenuComponents.palette.label,
        type = "slider",
        action = "swapPalette",
        value = paletteId,
        comp = InnitComp,
        min = 1,
        max = #Config.clothesPalettes,
        desc = T.MenuComponents.palette.desc
    }

    MenuData.Open('default', GetCurrentResourceName(), 'OpenComponentMenu',
        {
            title = Title,
            subtext = SubTitle,
            align = Config.Align,
            elements = elements,
            lastmenu = "OpenClothingMenu"
        },

        function(data, menu)
            if (data.current == "backup") then
                _G[data.trigger](table, value, Outfits)
            end

            if data.current.action == "swapPalette" and data.current.comp ~= -1 and TagData and next(TagData) then
                IsPedReadyToRender()
                local comp = data.current.comp
                local palette = Config.clothesPalettes[data.current.value]
                SetMetaPedTag(PlayerPedId(), TagData.drawable, TagData.albedo, TagData.normal, TagData.material, palette, 0, 0, 0)
                UpdatePedVariation()
                menu.setElement(4, "value", 0)
                menu.setElement(5, "value", 0)
                menu.setElement(6, "value", 0)
                menu.refresh()
                PlayerTrackingData[category][comp] = { tint0 = 0, tint1 = 0, tint2 = 0, palette = palette }
                return
            end

            if data.current.action == "tint0" and data.current.comp ~= -1 and TagData and next(TagData) then
                IsPedReadyToRender()
                local comp = data.current.comp
                local tint0, tint1, tint2 = data.current.value, PlayerTrackingData[category][comp].tint1,
                    PlayerTrackingData[category][comp].tint2
                local palette = PlayerTrackingData[category][comp].palette
                SetMetaPedTag(PlayerPedId(), TagData.drawable, TagData.albedo, TagData.normal, TagData.material, palette, tint0, tint1, tint2)
                UpdatePedVariation()
                menu.refresh()
                if not PlayerTrackingData[category][comp] then
                    PlayerTrackingData[category][comp] = { tint1 = tint1, tint2 = tint2, palette = palette }
                end
                PlayerTrackingData[category][comp].tint0 = tint0
                return
            end

            if data.current.action == "tint1" and data.current.comp ~= -1 and TagData and next(TagData) then
                IsPedReadyToRender()
                local comp = data.current.comp
                local tint0, tint1, tint2 = PlayerTrackingData[category][comp].tint0, data.current.value,
                    PlayerTrackingData[category][comp].tint2
                local palette = PlayerTrackingData[category][comp].palette
                SetMetaPedTag(PlayerPedId(), TagData.drawable, TagData.albedo, TagData.normal, TagData.material, palette, tint0, tint1, tint2)
                UpdatePedVariation()
                menu.refresh()
                if not PlayerTrackingData[category][comp] then
                    PlayerTrackingData[category][comp] = { tint0 = tint0, tint2 = tint2, palette = palette }
                end
                PlayerTrackingData[category][comp].tint1 = tint1
                return
            end

            if data.current.action == "tint2" and data.current.comp ~= -1 and TagData and next(TagData) then
                IsPedReadyToRender()
                local comp = data.current.comp
                local tint0, tint1, tint2 = PlayerTrackingData[category][comp].tint0,
                    PlayerTrackingData[category][comp].tint1, data.current.value
                local palette = PlayerTrackingData[category][comp].palette
                SetMetaPedTag(PlayerPedId(), TagData.drawable, TagData.albedo, TagData.normal, TagData.material, palette, tint0, tint1, tint2)
                UpdatePedVariation()
                menu.refresh()
                if not PlayerTrackingData[category][comp] then
                    PlayerTrackingData[category][comp] = { tint0 = tint0, tint1 = tint1, palette = palette }
                end
                PlayerTrackingData[category][comp].tint2 = tint2
                return
            end

            if data.current.type == "remove" or (data.current.type == "slider" and data.current.info and not data.current.action and (data.current.value == 0 or data.current.value == #table[category] + 1)) then
                RemoveTagFromMetaPed(Config.HashList[category])
                UpdatePedVariation()
                PlayerClothing[category].comp = -1
                Applycomponents(false, category)
                menu.setElement(1, "value", 0)
                menu.setElement(2, "label", label .. "<br><span style='opacity:0.6;'>" .. '0' .. T.MenuComponents.element2.label .. "</span>")
                menu.setElement(2, "max", 0)
                menu.setElement(2, "min", 0)
                menu.setElement(2, "value", 0)
                menu.setElement(4, "value", 0)
                menu.setElement(5, "value", 0)
                menu.setElement(6, "value", 0)
                menu.setElement(7, "value", 0)
                menu.refresh()
                PlayerTrackingData[category] = {}
                if IsInClothingStore then
                    TotalAmountToPay[category] = 0
                    CachedComponents[category].comp = -1
                end
                return
            end

            -- * component varitaion
            if data.current.type == "slider" and not data.current.info and not data.current.action and data.current.comp then
                if data.current.value == 0 then
                    menu.setElement(2, "value", #data.current.comp)
                    data.current.value = #data.current.comp
                    menu.refresh()
                elseif data.current.value == #data.current.comp + 1 then
                    menu.setElement(2, "value", 1)
                    data.current.value = 1
                    menu.refresh()
                end

                if data.current.value > 0 and data.current.comp[data.current.value] then
                    Applycomponents(data.current.comp[data.current.value], category)
                    local index = GetTrackedData(category)

                    TagData = GetMetaPedData(category == "Boots" and "boots" or category)

                    if not PlayerTrackingData[category][data.current.comp[data.current.value].hex] then
                        PlayerTrackingData[category] = {}
                        PlayerTrackingData[category][data.current.comp[data.current.value].hex] = {
                            tint0 = TagData and TagData.tint0 or 0,
                            tint1 = TagData and TagData.tint1 or 0,
                            tint2 = TagData and TagData.tint2 or 0,
                            palette = TagData and TagData.palette or 0,
                            color = data.current.value,
                            index = index,
                        }
                    end

                    -- need to reset tings of elements
                    menu.setElement(4, "value", TagData and TagData.tint0 or 0)
                    menu.setElement(5, "value", TagData and TagData.tint1 or 0)
                    menu.setElement(6, "value", TagData and TagData.tint2 or 0)
                    if TagData and TagData.palette then
                        local paletteId = 0
                        for id, palette in pairs(Config.clothesPalettes) do
                            if TagData.palette == palette then
                                paletteId = id
                                break
                            end
                        end
                        if paletteId == 0 then
                            Config.clothesPalettes[#Config.clothesPalettes + 1] = TagData.palette
                            paletteId = #Config.clothesPalettes
                            menu.setElement(7, "max", #Config.clothesPalettes)
                        end
                        menu.setElement(7, "value", paletteId)
                    else
                        menu.setElement(7, "value", 0)
                    end
                    menu.setElement(4, "comp", data.current.comp[data.current.value].hex)
                    menu.setElement(5, "comp", data.current.comp[data.current.value].hex)
                    menu.setElement(6, "comp", data.current.comp[data.current.value].hex)
                    menu.setElement(7, "comp", data.current.comp[data.current.value].hex)
                    menu.refresh()

                    if not IsInClothingStore then
                        CachedComponents[category].comp = data.current.comp[data.current.value].hex
                    else
                        if data.current.comp[data.current.value].hex ~= InnitComp then
                            TotalAmountToPay[category] = GetExtraPrice(category,
                                    data.current.comp[data.current.value].hex) or ConfigShops.Prices.clothing[category]
                                .price
                        else
                            TotalAmountToPay[category] = 0
                        end
                    end
                end
                return
            end

            -- * component type
            if data.current.type == "slider" and data.current.info and not data.current.action then
                if data.current.value == -1 then
                    menu.setElement(1, "value", #table[category])
                    data.current.value = #table[category]
                    menu.refresh()
                end

                local total = table[category][data.current.value]
                local component = table[category][data.current.value][1]

                if component then
                    Applycomponents(component, category)

                    TagData = GetMetaPedData(category == "Boots" and "boots" or category)

                    -- we need to keep track of the index where comp is so when we come back we start there
                    if not PlayerTrackingData[category][component.hex] then
                        PlayerTrackingData[category] = {}
                        PlayerTrackingData[category][component.hex] = {
                            tint0 = TagData and TagData.tint0 or 0,
                            tint1 = TagData and TagData.tint1 or 0,
                            tint2 = TagData and TagData.tint2 or 0,
                            palette = TagData and TagData.palette or 0,
                            index = data.current.value,
                            color = 0,
                        }
                    end

                    menu.setElement(2, "comp", total)
                    menu.setElement(2, "desc", "<br><br>" .. imgPath:format(category) .. "<br><br><br>" .. T.MenuComponents.element2.desc .. " " .. #total .. " " .. T.MenuComponents.element2.desc2 .. menuSpace .. Divider .. T.MenuComponents.scroll)
                    menu.setElement(2, "max", #total + 1)
                    menu.setElement(2, "value", 1)
                    menu.setElement(2, "label", label .. "<br><span style='opacity:0.6;'>" .. #total .. T.MenuComponents.element2.label .. "</span>")
                    menu.setElement(4, "comp", component.hex)
                    menu.setElement(5, "comp", component.hex)
                    menu.setElement(6, "comp", component.hex)
                    menu.setElement(7, "comp", component.hex)
                    menu.setElement(4, "value", TagData and TagData.tint0 or 0)
                    menu.setElement(5, "value", TagData and TagData.tint1 or 0)
                    menu.setElement(6, "value", TagData and TagData.tint2 or 0)
                    if TagData and TagData.palette then
                        local paletteId = 0
                        for id, palette in pairs(Config.clothesPalettes) do
                            if TagData.palette == palette then
                                paletteId = id
                                break
                            end
                        end
                        if paletteId == 0 then
                            Config.clothesPalettes[#Config.clothesPalettes + 1] = TagData.palette
                            paletteId = #Config.clothesPalettes
                            menu.setElement(7, "max", #Config.clothesPalettes)
                        end
                        menu.setElement(7, "value", paletteId)
                    else
                        menu.setElement(7, "value", 0)
                    end
                    menu.refresh()

                    if not IsInClothingStore then
                        CachedComponents[category].comp = component.hex
                    else
                        if ShopType == "clothing" then
                            if component.hex ~= InnitComp then
                                TotalAmountToPay[category] = GetExtraPrice(category, component.hex) or
                                    ConfigShops.Prices.clothing[category].price
                            else
                                TotalAmountToPay[category] = 0
                            end
                        end
                    end
                end
            end
        end, function(data, menu)

        end)
end

local HeightChosen = 2
local heightLabel = T.MenuAppearance.element5.label .. "<br><span style='opacity:0.6;'>" .. T.MenuAppearance.normal .. "</span>"
function OpenAppearanceMenu(clothingtable, value)
    Title = IsInClothingStore and "Main Menu" or T.MenuAppearance.title
    local SubTitle = "<span style='font-size: 25px;'>" .. T.MenuAppearance.subtitle .. "</span><br><br>"
    local imgPath = "<img style='max-height:532px;max-width:380px; float: center; ' src='nui://" .. GetCurrentResourceName() .. "/images/%s.png'>"
    if Resolution.width <= 1920 then
        SubTitle = T.MenuAppearance.subtitle
        imgPath = "<img style='max-height:332px;max-width:280px; float: center; ' src='nui://" .. GetCurrentResourceName() .. "/images/%s.png'>"
    end
    MenuData.CloseAll()
    local elements = {
        {
            label = T.MenuAppearance.element.label .. "<br><span style='opacity:0.6;'>body types </span>",
            value = "body",
            desc = imgPath:format("character_creator_build") .. "<br>" .. T.MenuAppearance.element.desc .. "<br><br>" .. Divider .. "<br><br>"
        },

        {
            label = T.MenuAppearance.element2.label .. "<br><span style='opacity:0.6;'>" .. T.MenuAppearance.element2.desc2 .. "</span>",
            value = "heritage",
            desc = imgPath:format("character_creator_heritage") .. "<br>" .. T.MenuAppearance.element2.desc .. "<br><br>" .. Divider .. "<br><br>"
        },

        {
            label = T.MenuAppearance.element3.label .. "<br><span style='opacity:0.6;'>" .. T.MenuAppearance.element3.desc2 .. "</span>",
            value = "hair",
            desc = imgPath:format("character_creator_hair") .. "<br>" .. T.MenuAppearance.element3.desc .. "<br><br>" .. Divider .. "<br><br>"
        },
        {
            label = T.MenuAppearance.element4.label .. "<br><span style='opacity:0.6;'>" .. T.MenuAppearance.element4.desc2 .. "</span>",
            value = "age",
            desc = imgPath:format("character_creator_appearance") .. "<br>" .. T.MenuAppearance.element4.desc .. "<br><br>" .. Divider .. "<br><br>"
        },

        {
            label = heightLabel,
            tag = "height",
            type = "slider",
            min = 0,
            comp = nil,
            max = 3,
            value = HeightChosen,
            short = 1,
            tall = 3,
            normal = 2,
            desc = imgPath:format("character_creator_appearance") .. "<br>" .. T.MenuAppearance.element5.desc .. "<br><br>" .. Divider .. "<br><br>"
        },

        {
            label = T.MenuAppearance.element6.label .. "<br><span style='opacity:0.6;'>" .. T.MenuAppearance.element6.desc2 .. " </span>",
            value = "face",
            desc = imgPath:format("character_creator_head") .. "<br>" .. T.MenuAppearance.element6.desc .. "<br><br>" .. Divider .. "<br><br>"
        },

        {
            label = T.MenuAppearance.element7.label .. "<br><span style='opacity:0.6;'>" .. T.MenuAppearance.element7.desc .. "</span>",
            value = "lifestyle",
            desc = imgPath:format("character_creator_lifestyle") .. "<br>" .. T.MenuAppearance.element7.desc .. "<br><br>" .. Divider .. "<br><br>"
        },

        {
            label = T.MenuAppearance.element8.label .. "<br><span style='opacity:0.6;'>" .. T.MenuAppearance.element8.desc .. "</span>",
            value = "makeup",
            desc = imgPath:format("character_creator_makeup") .. "<br>" .. T.MenuAppearance.element8.desc .. "<br><br>" .. Divider .. "<br><br>"
        },
    }

    MenuData.Open('default', GetCurrentResourceName(), 'OpenAppearanceMenu',
        {
            title = Title,
            subtext = SubTitle,
            align = Config.Align,
            elements = elements,
            lastmenu = "OpenCharCreationMenu",
            itemHeight = "4vh",
        },

        function(data, menu)
            if (data.current == "backup") then -- go back
                return _G[data.trigger](clothingtable, value)
            end
            if (data.current.value == "body") then
                return OpenBodyMenu(clothingtable, value)
            end
            if (data.current.value == "heritage") then
                return OpenHerritageMenu(clothingtable, value)
            end
            if (data.current.value == "hair") then
                return OpenHairMenu(clothingtable, value)
            end

            if (data.current.value == "age") then
                return OpenAgeMenu(clothingtable, value)
            end
            if (data.current.type == "slider" and not data.current.info) then
                local height = 0
                -- this is necessary changing heiht on players breaks animations etc
                for key, value in pairs(menu.data.elements) do
                    if value.tag == data.current.tag then
                        if data.current.value == data.current.short then
                            height = 0.95
                            heightLabel = T.MenuAppearance.element5.label .. "<br><span style='opacity:0.6;'>" .. T.MenuAppearance.short .. "</span>"
                            HeightChosen = 1
                        end
                        if data.current.value == data.current.normal then
                            height = 1.0
                            heightLabel = T.MenuAppearance.element5.label .. "<br><span style='opacity:0.6;'>" .. T.MenuAppearance.normal .. "</span>"
                            HeightChosen = 2
                        end
                        if data.current.value == data.current.tall then
                            height = 1.05
                            heightLabel = T.MenuAppearance.element5.label .. "<br><span style='opacity:0.6;'>" .. T.MenuAppearance.tall .. "</span>"
                            HeightChosen = 3
                        end
                        SetPedScale(PlayerPedId(), height)
                        menu.setElement(key, "label", heightLabel)
                        menu.refresh()
                        PlayerSkin.Scale = height

                        break
                    end
                end
                return
            end

            if (data.current.value == "face") then
                return OpenFaceMenu(clothingtable, value)
            end

            if data.current.value == "lifestyle" then
                return OpenLifeStyleMenu(clothingtable, value)
            end

            if (data.current.value == "makeup") then
                OpenMakeupMenu(clothingtable, value)
            end
        end,
        function(data, menu)

        end)
end

local AgingOpacityTracker = 0
local AgingTextureTracker = 0
function OpenAgeMenu(table, value)
    local SubTitle = "<span style='font-size:25px;'>" .. T.MenuAge.subtitle .. "</span><br><br>"
    local MenuSpace = "<br><br><br><br><br><br><br><br><br><br><br><br><br><br>"
    if Resolution.width <= 1920 then
        SubTitle = T.MenuAge.subtitle
        MenuSpace = "<br><br><br><br><br><br><br><br><br><br>"
    end
    MenuData.CloseAll()
    local elements = {
        {
            label = T.MenuAge.element.label .. "<br><span style='opacity:0.6;'> wrinkles " .. #Config.overlays_info.ageing .. "</span>",
            type = "slider",
            min = 0,
            info = Config.overlay_all_layers,
            comp = Config.overlay_all_layers,
            compname = Config.overlay_all_layers[9].name,
            max = #Config.overlays_info.ageing,
            value = AgingTextureTracker,
            desc = MenuSpace .. Divider .. "<br><br>" .. T.MenuAge.element.desc
        },
        {
            label = T.MenuAge.element2.label .. "<br><span style='opacity:0.6;'>" .. T.MenuAge.element2.desc3 .. "</span>",
            type = "slider",
            value = AgingOpacityTracker,
            info = nil,
            comp = Config.overlay_all_layers,
            min = 0,
            max = 10,
            desc = MenuSpace .. Divider .. "<br><br>" .. T.MenuAge.element2.desc2
        },
    }

    MenuData.Open('default', GetCurrentResourceName(), 'OpenAgeMenu',
        {
            title = Title,
            subtext = SubTitle,
            align = Config.Align,
            elements = elements,
            lastmenu = "OpenAppearanceMenu",
            itemHeight = "4vh",
        },

        function(data, menu)
            if (data.current == "backup") then -- go back
                return _G[data.trigger](table, value)
            end

            if data.current.type == "slider" and not data.current.info then -- * opacity
                if data.current.value > 0 then
                    PlayerSkin.ageing_opacity = data.current.value / 10
                    PlayerSkin.ageing_visibility = 1
                    toggleOverlayChange("ageing", 1, PlayerSkin.ageing_tx_id, 0, 0, 1, 1.0, 0, 0, 0, 0, 0, 1, PlayerSkin.ageing_opacity, PlayerSkin.albedo)
                else
                    PlayerSkin.ageing_visibility = 0
                    if PlayerSkin.ageing_tx_id == 1 then
                        PlayerSkin.ageing_tx_id = 0
                    end
                end
                AgingOpacityTracker = data.current.value
                return
            end

            if data.current.type == "slider" and data.current.value > 0 and data.current.info then -- * texture id
                PlayerSkin.ageing_tx_id = data.current.value
                toggleOverlayChange("ageing", PlayerSkin.ageing_visibility, PlayerSkin.ageing_tx_id, 0, 0, 1, 1.0, 0, 0, 0, 0, 0, 1, PlayerSkin.ageing_opacity, PlayerSkin.albedo)
                AgingTextureTracker = data.current.value
            end
        end, function(data, menu)

        end)
end

BodyTypeTracker = 1
LegsTypeTracker = 1
WaistTracker = 1
BodyTracker = 1

function OpenBodyMenu(table, value)
    local SubTitle = "<span style='font-size:25px;'>" .. T.MenuBody.subtitle .. "</span><br><br>"

    if Resolution.width <= 1920 then
        SubTitle = T.MenuBody.subtitle
    end
    MenuData.CloseAll()
    local gender = GetGender()
    local elements = {

        {
            label = T.MenuBody.element.label .. "<br><span style='opacity:0.6;'>" .. T.MenuBody.Ammount .. ' ' .. #Config.BodyType.Body .. "</span>",
            type = "slider",
            value = BodyTracker,
            tag = "body",
            min = -1,
            max = #Config.BodyType.Body,
            desc = imgPath:format("character_creator_build") .. "<br>" .. T.MenuBody.element.desc .. #Config.BodyType.Body .. ' ' .. T.MenuBody.element.label .. "<br><br>" .. Divider .. "<br><br>",
            itemHeight = "4vh",
        },

        {

            label = T.MenuBody.element2.label .. "<br><span style='opacity:0.6;'>" .. T.MenuBody.Ammount .. ' ' .. #Config.BodyType.Waist .. "</span>",
            type = "slider",
            value = WaistTracker,
            tag = "waist",
            comp = Config.BodyType.Waist,
            min = -1,
            max = #Config.BodyType.Waist,
            desc = imgPath:format("character_creator_build") .. "<br>" .. T.MenuBody.element2.desc .. #Config.BodyType.Waist .. ' ' .. T.MenuBody.element2.desc2 .. "<br><br>" .. Divider .. "<br><br>",
            itemHeight = "4vh",
        },

        {

            label = T.MenuBody.element3.label .. "<br><span style='opacity:0.6;'>" .. T.MenuBody.Ammount .. ' ' .. #Config.DefaultChar[gender][SkinColorTracker].Body .. "</span>",
            type = "slider",
            value = BodyTypeTracker,
            comp = Config.DefaultChar[gender],
            min = 0,
            max = #Config.DefaultChar[gender][SkinColorTracker].Body,
            desc = imgPath:format("character_creator_build") .. "<br>" .. T.MenuBody.element3.desc .. #Config.DefaultChar[gender][SkinColorTracker].Body .. ' ' .. T.MenuBody.element.label .. "<br><br>" .. Divider .. "<br><br>",
            tag = "Body",
            option = "type",
            itemHeight = "4vh",
        },

        {

            label = T.MenuBody.element4.label .. "<br><span style='opacity:0.6;'>" .. T.MenuBody.Ammount .. ' ' .. #Config.DefaultChar[gender][SkinColorTracker].Legs .. "</span>",
            type = "slider",
            value = LegsTypeTracker,
            comp = Config.DefaultChar[gender],
            min = 0,
            max = #Config.DefaultChar[gender][SkinColorTracker].Legs,
            desc = imgPath:format("character_creator_build") .. "<br>" .. T.MenuBody.element4.desc .. #Config.DefaultChar[gender][SkinColorTracker].Legs .. ' ' .. T.MenuBody.element.label .. "<br><br>" .. Divider .. "<br><br>",
            tag = "Legs",
            option = "type",
            itemHeight = "4vh",
        },

        {
            label = T.Other.undress.label,
            value = "undress",
            desc = "<br><br>" .. imgPath:format("character_creator_build") .. "<br><br><br>" .. T.Other.undress.desc .. "<br><br>" .. Divider .. "<br><br>",
        },

        {
            label = T.Other.dress.label,
            value = "dress",
            desc = "<br><br>" .. imgPath:format("character_creator_build") .. "<br><br><br>" .. T.Other.dress.desc .. "<br><br>" .. Divider .. "<br><br>",
        }
    }

    MenuData.Open('default', GetCurrentResourceName(), 'OpenBodyMenu',
        {
            title = Title,
            subtext = SubTitle,
            align = Config.Align,
            elements = elements,
            lastmenu = "OpenAppearanceMenu"
        },

        function(data, menu)
            if (data.current == "backup") then
                return _G[data.trigger](table, value)
            end

            if data.current.option == "type" then
                if data.current.value > 0 then
                    local index    = data.current.value
                    local Comp     = Config.DefaultChar[gender][SkinColorTracker]
                    local compType = tonumber("0x" .. Comp[data.current.tag][index])

                    if data.current.tag == "Body" then
                        PlayerSkin.Torso = compType
                        BodyTypeTracker = data.current.value
                    else
                        PlayerSkin[data.current.tag] = compType
                        LegsTypeTracker = data.current.value
                    end
                    IsPedReadyToRender()
                    ApplyShopItemToPed(compType)
                    UpdatePedVariation()
                end
                return
            end

            if data.current.tag == "waist" then
                if data.current.value > 0 then
                    local Waist = data.current.comp[data.current.value]
                    IsPedReadyToRender()
                    EquipMetaPedOutfit(Waist)
                    UpdatePedVariation()
                    PlayerSkin.Waist = Waist
                    WaistTracker = data.current.value
                end
                return
            end

            if data.current.tag == "body" then
                if data.current.value > 0 then
                    local Body = Config.BodyType.Body[data.current.value]
                    IsPedReadyToRender()
                    EquipMetaPedOutfit(Body)
                    UpdatePedVariation()
                    PlayerSkin.Body = Body
                    BodyTracker = data.current.value
                end
                return
            end

            if data.current.value == "undress" or data.current.value == "dress" then
                if data.current.value == "undress" then
                    -- apply body
                    SkinColorTracker  = SkinColorTracker
                    local SkinColor   = Config.DefaultChar[gender][SkinColorTracker]
                    local legs        = tonumber("0x" .. SkinColor.Legs[LegsTypeTracker])
                    local bodyType    = tonumber("0x" .. SkinColor.Body[BodyTypeTracker])
                    local heads       = tonumber("0x" .. SkinColor.Heads[HeadIndexTracker])
                    local headtexture = joaat(SkinColor.HeadTexture[1])
                    local albedo      = Config.texture_types[gender].albedo
                    IsPedReadyToRender()
                    ApplyShopItemToPed(heads)
                    ApplyShopItemToPed(bodyType)
                    ApplyShopItemToPed(legs)
                    Citizen.InvokeNative(0xC5E7204F322E49EB, albedo, headtexture, 0x7FC5B1E1)
                    UpdatePedVariation()
                end
                ExecuteCommand(data.current.value)
            end
        end, function(data, menu)

        end)
end

-- * Heritage Menu


function OpenHerritageMenu(table, value)
    local SubTitle = "<span style='font-size:25px;'>" .. T.MenuHeritage.subtitle .. "</span><br><br>"

    if Resolution.width <= 1920 then
        SubTitle = T.MenuHeritage.subtitle
    end
    MenuData.CloseAll()
    local elements = {}
    local gender = GetGender()

    elements[#elements + 1] = {
        label = T.MenuHeritage.element.label,
        type = "slider",
        value = SkinColorTracker,
        info = Config.DefaultChar[gender],
        min = 1,
        max = #Config.DefaultChar[gender],
        desc = T.MenuHeritage.element.desc .. #Config.DefaultChar[gender] .. ' ' .. T.MenuHeritage.element.desc2 .. "<br><br>" .. Divider .. "<br><br>",
        tag = "heritage"
    }

    elements[#elements + 1] = {
        label = T.MenuHeritage.element2.label,
        type = "slider",
        value = HeadIndexTracker,
        info = nil,
        comp = Config.DefaultChar[gender][SkinColorTracker].Heads,
        min = 1,
        max = #Config.DefaultChar[gender][SkinColorTracker].Heads,
        desc = T.MenuHeritage.element3.desc,
        tag = "color"
    }

    -- add elements to remove or put clothes in
    elements[#elements + 1] = {
        label = T.Other.undress.label,
        value = "undress",
        desc = "<br><br>" .. imgPath:format("character_creator_build") .. "<br><br><br>" .. T.Other.undress.desc .. "<br><br>" .. Divider .. "<br><br>",
    }

    elements[#elements + 1] = {
        label = T.Other.dress.label,
        value = "dress",
        desc = "<br><br>" .. imgPath:format("character_creator_build") .. "<br><br><br>" .. T.Other.dress.desc .. "<br><br>" .. Divider .. "<br><br>",
    }

    MenuData.Open('default', GetCurrentResourceName(), 'OpenHerritageMenu',
        {
            title = Title,
            subtext = SubTitle,
            align = Config.Align,
            elements = elements,
            lastmenu = "OpenAppearanceMenu"
        },

        function(data, menu)
            if (data.current == "backup") then
                return _G[data.trigger](table, value)
            end

            if data.current.value == "undress" or data.current.value == "dress" then
                if data.current.value == "undress" then
                    -- apply body
                    SkinColorTracker  = SkinColorTracker
                    local SkinColor   = Config.DefaultChar[gender][SkinColorTracker]
                    local legs        = tonumber("0x" .. SkinColor.Legs[LegsTypeTracker])
                    local bodyType    = tonumber("0x" .. SkinColor.Body[BodyTypeTracker])
                    local heads       = tonumber("0x" .. SkinColor.Heads[HeadIndexTracker])
                    local headtexture = joaat(SkinColor.HeadTexture[1])
                    local albedo      = Config.texture_types[gender].albedo
                    IsPedReadyToRender()
                    ApplyShopItemToPed(heads)
                    ApplyShopItemToPed(bodyType)
                    ApplyShopItemToPed(legs)
                    Citizen.InvokeNative(0xC5E7204F322E49EB, albedo, headtexture, 0x7FC5B1E1)
                    UpdatePedVariation()
                end
                return ExecuteCommand(data.current.value)
            end

            if data.current.tag == "color" then -- * component varitaion
                if data.current.value > 0 then
                    local heads = tonumber("0x" .. Config.DefaultChar[gender][SkinColorTracker].Heads
                        [data.current.value])
                    IsPedReadyToRender()
                    ApplyShopItemToPed(heads)
                    UpdatePedVariation()
                    PlayerSkin.HeadType = heads
                    HeadIndexTracker = data.current.value
                end
                return
            end

            if data.current.tag == "heritage" then -- * component type
                if data.current.value > 0 then
                    SkinColorTracker    = data.current.value
                    local SkinColor     = Config.DefaultChar[gender][data.current.value]
                    local legs          = tonumber("0x" .. SkinColor.Legs[LegsTypeTracker])
                    local bodyType      = tonumber("0x" .. SkinColor.Body[BodyTypeTracker])
                    local heads         = tonumber("0x" .. SkinColor.Heads[HeadIndexTracker])
                    local headtexture   = joaat(SkinColor.HeadTexture[1])
                    local albedo        = Config.texture_types[gender].albedo

                    PlayerSkin.HeadType = heads
                    PlayerSkin.BodyType = bodyType
                    PlayerSkin.LegsType = legs
                    PlayerSkin.albedo   = headtexture
                    menu.setElement(2, "max", #Config.DefaultChar[gender][data.current.value].Heads)
                    menu.refresh()
                    IsPedReadyToRender()
                    ApplyShopItemToPed(heads)
                    ApplyShopItemToPed(bodyType)
                    ApplyShopItemToPed(legs)
                    Citizen.InvokeNative(0xC5E7204F322E49EB, albedo, headtexture, 0x7FC5B1E1)
                    UpdatePedVariation()
                end
            end
        end, function(data, menu)

        end)
end

--* Hair menu
function OpenHairMenu(table, value)
    Title = IsInClothingStore and "Hair Menu" or T.MenuCreation.title

    local SubTitle = "<span style='font-size:25px;'>" .. T.MenuHair.subtitle .. "</span><br><br>"

    if Resolution.width <= 1920 then
        SubTitle = T.MenuHair.subtitle
    end
    MenuData.CloseAll()

    local elements = {
        {
            label = T.MenuHair.element.label .. "<br><span style='opacity:0.6;'>" .. T.MenuHair.element.desc2 .. "</span>",
            value = "hair",
            desc = imgPath:format("character_creator_hair") .. "<br>" .. T.MenuHair.element.desc .. "<br><br>" .. Divider .. "<br><br>",
        }
    }

    if GetGender() == "Male" then
        elements[#elements + 1] = {
            label = T.MenuHair.element2.label .. "<br><span style='opacity:0.6;'>" .. T.MenuHair.element2.desc2 .. "</span>",
            value = "beard",
            desc = imgPath:format("character_creator_facial_hair") .. "<br>" .. T.MenuHair.element2.desc .. "<br><br>" .. Divider .. "<br><br>",
        }
        elements[#elements + 1] = {
            label = T.MenuHair.element3.label .. "<br><span style='opacity:0.6;'>" .. T.MenuHair.element3.desc2 .. "</span>",
            value = "beardstabble",
            desc = imgPath:format("character_creator_facial_hair") .. "<br>" .. T.MenuHair.element3.desc .. "<br><br>" .. Divider .. "<br><br>"
        }
    else
        elements[#elements + 1] = {
            label = T.MenuHair.element4.label .. "<br><span style='opacity:0.6;'>" .. T.MenuHair.element4.desc2 .. "</span>",
            value = "bow",
            desc = T.MenuHair.element4.desc .. "<br><br>" .. Divider .. "<br><br>"
        }
    end
    elements[#elements + 1] = {
        label = T.MenuHair.element5.label .. "<br><span style='opacity:0.6;'>" .. T.MenuHair.element5.desc2 .. "</span>",
        value = "eyebrows",
        desc = imgPath:format("character_creator_eyebrows") .. "<br>" .. T.MenuHair.element5.desc .. "<br><br>" .. Divider .. "<br><br>"
    }
    elements[#elements + 1] = {
        label = T.MenuHair.element6.label .. "<br><span style='opacity:0.6;'>" .. T.MenuHair.element6.desc2 .. "</span>",
        value = "overlay",
        desc = imgPath:format("character_creator_hair") .. "<br>" .. T.MenuHair.element6.desc .. "<br><br>" .. Divider .. "<br><br>"
    }
    -- got add element to confimr pay
    if ShopType == "hair" then
        elements[#elements + 1] = {
            label = "Confirm" .. "<br><span style='opacity:0.6;'>" .. T.Inputs.confirmpurchase .. "</span>",
            value = "confirm",
            desc = "<br><br>" .. imgPath:format("character_creator_hair") .. "<br><br><br>" .. T.Inputs.confirmpurchase .. "<br><br>" .. Divider .. "<br><br>"
        }
        -- close
        elements[#elements + 1] = {
            label = T.MainMenu.close .. "<br><span style='opacity:0.6;'>" .. T.MainMenu.closemenu .. "</span>",
            value = "close",
            desc = "<br><br>" .. imgPath:format("character_creator_hair") .. "<br><br><br>" .. T.MainMenu.closemenu .. "<br><br>" .. Divider .. "<br><br>"
        }
    end
    local lastmenu = (IsInCharCreation or ShopType == "secondchance") and "OpenAppearanceMenu" or nil

    MenuData.Open('default', GetCurrentResourceName(), 'OpenHairMenu',
        {
            title = Title,
            subtext = SubTitle,
            align = Config.Align,
            elements = elements,
            lastmenu = lastmenu,
            itemHeight = "4vh",
        },

        function(data, menu)
            if IsInCharCreation or ShopType == "secondchance" then
                if (data.current == "backup") then
                    return _G[data.trigger](table, value)
                end
            end

            if data.current.value == "close" then
                menu.close()
                return BackFromMenu(value)
            end

            if data.current.value == "confirm" then
                if GetCurrentAmmountToPay() > 0 then
                    local NewTable = GetNewCompOldStructure(PlayerClothing)
                    local result = Core.Callback.TriggerAwait("vorp_character:callback:PayToShop",
                        { skin = PlayerSkin, comps = NewTable, amount = GetCurrentAmmountToPay() })
                    if result then
                        CachedSkin = PlayerSkin
                        UpdateCache(NewTable)
                    end
                end
                menu.close()
                return BackFromMenu(value)
            end

            if (data.current.value == "hair") then
                local TableHair = GetHair(GetGender(), data.current.value)
                return OpenHairSelectionMenu(TableHair, table, data.current.label, "Hair", value)
            end
            if (data.current.value == "bow") then
                local TableBow = GetHair(GetGender(), data.current.value)
                return OpenHairSelectionMenu(TableBow, table, data.current.label, "bow", value)
            end
            if (data.current.value == "beard") then
                local TableBeard = GetHair("Male", data.current.value)
                return OpenHairSelectionMenu(TableBeard, table, data.current.label, "Beard", value)
            end

            if (data.current.value == "eyebrows") then
                return OpenBeardEyebrowMenu(table, "eyebrows_opacity", "eyebrows_tx_id", "eyebrows", 1, data.current.label, "eyebrows_color", value)
            end

            if (data.current.value == "overlay") then
                return OpenBeardEyebrowMenu(table, "hair_opacity", "hair_tx_id", "hair", 4, data.current.label, "hair_color_primary", value)
            end

            if (data.current.value == "beardstabble") then
                OpenBeardEyebrowMenu(table, "beardstabble_opacity", "beardstabble_tx_id", "beardstabble", 7, data.current.label, "beardstabble_color_primary", value)
            end
        end,

        function(data, menu)

        end)
end

local HairIndexTracker = {}
local HairColorIndexTracker = {}
--* Hair menu
function OpenHairSelectionMenu(tablehair, table, label, category, value)
    MenuData.CloseAll()
    local SubTitle = "<span style='font-size:25px;'>" .. T.MenuHairSelection.subtitle .. "</span><br><br>"

    if Resolution.width <= 1920 then
        SubTitle = T.MenuHairSelection.subtitle
    end

    local InnitComp = nil
    local hairIndex, hairColorIndex = 1, 1

    if not IsInCharCreation then
        hairIndex, hairColorIndex = GetHairIndex(category, tablehair)
        if category == "bow" then
            InnitComp = PlayerClothing[category].comp
        else
            InnitComp = CachedSkin[category]
        end
    end

    if not HairColorIndexTracker[category] then
        HairColorIndexTracker[category] = hairColorIndex
    end

    if not HairIndexTracker[category] then
        HairIndexTracker[category] = hairIndex
    end

    local elements = {
        {
            label = label,
            type = "slider",
            value = HairIndexTracker[category],
            info = tablehair,
            min = 0,
            max = #tablehair,
            desc = T.MenuHairSelection.element.desc .. #tablehair .. ' ' .. T.MenuHairSelection.element.desc2 .. label .. "<br><br>" .. Divider .. "<br><br>",
            tag = "component",
            itemHeight = "4vh",
        },
        {
            label = T.MenuHairSelection.element2.label .. "<br><span style='opacity:0.6;'>" .. "" .. T.MenuBody.Ammount .. ' ' .. #tablehair[HairIndexTracker[category]] .. "</span>",
            type = "slider",
            value = HairColorIndexTracker[category],
            min = 0,
            max = #tablehair[HairIndexTracker[category]],
            desc = T.MenuHairSelection.element2.desc .. #tablehair[HairIndexTracker[category]] .. ' ' .. T.MenuHairSelection.element2.desc2,
            tag = "color",
            itemHeight = "4vh",
        },
        {
            label = T.MenuHairSelection.element3.label,
            value = 1,
            desc = "<br><br>" .. imgPath:format("character_creator_hair") .. "<br><br><br>" .. T.MenuHairSelection.element3.desc .. "<br><br>" .. Divider .. "<br><br>",
            tag = "remove"
        }
    }

    MenuData.Open('default', GetCurrentResourceName(), 'OpenHairSelectionMenu',
        {
            title = Title,
            subtext = SubTitle,
            align = Config.Align,
            elements = elements,
            lastmenu = "OpenHairMenu"
        },

        function(data, menu)
            if (data.current == "backup") then -- go back
                return _G[data.trigger](table, value)
            end

            if data.current.value and data.current.value > 0 and data.current.tag == "color" then
                local comp = tablehair[HairIndexTracker[category]][data.current.value]
                IsPedReadyToRender()
                ApplyShopItemToPed(comp)
                UpdatePedVariation()
                if category == "bow" then
                    PlayerClothing[category].comp = comp
                else
                    PlayerSkin[category] = comp
                end

                HairColorIndexTracker[category] = data.current.value
                return
            end

            if data.current.tag == "remove" then
                IsPedReadyToRender()
                RemoveTagFromMetaPed(Config.HashList[category])
                UpdatePedVariation()
                if category == "bow" then
                    PlayerClothing[category].comp = -1
                else
                    PlayerSkin[category] = -1
                end
                HairColorIndexTracker[category] = 1
                HairIndexTracker[category] = 1
                menu.setElement(1, "value", 1)
                menu.setElement(2, "value", 1)
                menu.refresh()
                if IsInClothingStore then
                    TotalAmountToPay[category] = 0
                    if CachedComponents[category] then
                        CachedComponents[category].comp = -1
                    end
                end
                return
            end

            if data.current.tag == "component" and data.current.value > 0 then
                local COMP = tablehair[data.current.value][HairColorIndexTracker[category]]
                local total = tablehair[data.current.value]
                HairIndexTracker[category] = data.current.value
                if category == "bow" then
                    PlayerClothing[category].comp = COMP
                else
                    PlayerSkin[category] = COMP
                end
                IsPedReadyToRender()
                ApplyShopItemToPed(COMP)
                UpdatePedVariation()
                menu.setElement(2, "label", T.MenuHairSelection.element2.label .. "<br><span style='opacity:0.6;'>" .. "" .. T.MenuBody.Ammount .. ' ' .. #total .. "</span>")
                menu.setElement(2, "max", #total)
                menu.refresh()

                if InnitComp then
                    if COMP ~= InnitComp then
                        TotalAmountToPay[category] = ConfigShops.Prices.hair[category].price
                    else
                        TotalAmountToPay[category] = 0
                    end
                end
            end
        end, function(data, menu)

        end)
end

local MakeupIndexTracker = {}
local MakeupColorIndexTracker = {}
local MakeupOpacityTracker = {}
--* Beard menu and eye brow
function OpenBeardEyebrowMenu(table, opacity, txt_id, category, index, label, color, value)
    local SubTitle = "<span style='font-size:25px;'>" .. T.MenuBeardEyeBrows.subtitle .. "</span><br><br>"

    if Resolution.width <= 1920 then
        SubTitle = T.MenuBeardEyeBrows.subtitle
    end
    MenuData.CloseAll()

    if not MakeupIndexTracker[category] then
        MakeupIndexTracker[category] = 0
    end
    if not MakeupColorIndexTracker[category] then
        MakeupColorIndexTracker[category] = 0
    end
    if not MakeupOpacityTracker[category] then
        MakeupOpacityTracker[category] = 0
    end

    local elements = {
        {
            label = label,
            type = "slider",
            tag = "type",
            min = 0,
            value = MakeupIndexTracker[category],
            comp = Config.overlay_all_layers,
            compname = Config.overlay_all_layers[index].name,
            max = #Config.overlays_info[category],
            desc = T.MenuBeardEyeBrows.element.desc .. "<br><br>" .. Divider .. "<br><br>",
            color = color,
            txt_id = txt_id,
            opac = opacity,
            category = category
        },

        {
            label = T.MenuBeardEyeBrows.element2.label .. "<br><span style='opacity:0.6;'>" .. T.MenuBody.Ammount .. ' ' .. #Config.color_palettes[category] .. "</span>",
            type = "slider",
            tag = "color",
            value = MakeupColorIndexTracker[category],
            comp = Config.color_palettes[category],
            min = 0,
            max = #Config.color_palettes[category],
            desc = T.MenuBeardEyeBrows.element2.desc .. "<br><br>" .. Divider .. "<br><br>",
            color = color,
            txt_id = txt_id,
            opac = opacity,
            category = category
        },
        {
            label = T.MenuBeardEyeBrows.element3.label .. "<br><span style='opacity:0.6;'>" .. T.MenuBeardEyeBrows.element3.desc2 .. "</span>",
            type = "slider",
            tag = "opacity",
            value = MakeupOpacityTracker[category],
            comp = Config.overlay_all_layers,
            min = 0,
            max = 10,
            desc = T.MenuBeardEyeBrows.element3.desc .. "<br><br>" .. Divider .. "<br><br>",
            color = color,
            txt_id = txt_id,
            opac = opacity,
            category = category
        },
        {
            label = T.MenuBeardEyeBrows.element4.label,
            value = 1,
            desc = "<br><br>" .. imgPath:format("character_creator_hair") .. "<br><br><br>" .. T.MenuBeardEyeBrows.element4.desc .. "<br><br>" .. Divider .. "<br><br>",
            tag = "remove",
            color = color,
            txt_id = txt_id,
            opac = opacity,
            category = category
        }

    }

    MenuData.Open('default', GetCurrentResourceName(), 'OpenBeardEyebrowMenu',
        {
            title = Title,
            subtext = SubTitle,
            align = Config.Align,
            elements = elements,
            lastmenu = "OpenHairMenu",
            itemHeight = "4vh",
        },

        function(data, menu)
            if (data.current == "backup") then
                _G[data.trigger](table, value)
            end

            if data.current.tag == "remove" then
                PlayerSkin[data.current.txt_id] = 0
                PlayerSkin[data.current.color] = 0
                PlayerSkin[data.current.opac] = 0
                PlayerSkin[data.current.category .. "_visibility"] = 0
                MakeupColorIndexTracker[category] = 0
                MakeupIndexTracker[category] = 0
                MakeupOpacityTracker[category] = 0
                menu.setElement(1, "value", 0)
                menu.setElement(2, "value", 0)
                menu.refresh()
                toggleOverlayChange(data.current.category, 0, PlayerSkin[data.current.txt_id], 1, 0, 0, 1.0, 0, 1, PlayerSkin[data.current.color], 0, 0, 1, PlayerSkin[data.current.opac], PlayerSkin.albedo)
                if IsInClothingStore then
                    TotalAmountToPay[category] = 0
                    CachedComponents[category].comp = -1
                end
            end

            if data.current.tag == "type" then
                PlayerSkin[data.current.category .. "_visibility"] = 1
                PlayerSkin[data.current.opac] = 1

                MakeupIndexTracker[category] = data.current.value
                PlayerSkin[data.current.txt_id] = data.current.value
                toggleOverlayChange(data.current.category, 1, PlayerSkin[data.current.txt_id], 1, 0, 0, 1.0, 0, 1, PlayerSkin[data.current.color], 0, 0, 1, PlayerSkin[data.current.opac], PlayerSkin.albedo)
            end

            if data.current.tag == "color" then
                MakeupColorIndexTracker[category] = data.current.value
                PlayerSkin[data.current.color] = data.current.comp[data.current.value]
                toggleOverlayChange(data.current.category, 1, PlayerSkin[data.current.txt_id], 1, 0, 0, 1.0, 0, 1, PlayerSkin[data.current.color], 0, 0, 1, PlayerSkin[data.current.opac], PlayerSkin.albedo)
            end

            if data.current.tag == "opacity" then
                if data.current.value > 0.2 then
                    PlayerSkin[data.current.category .. "_visibility"] = 1
                    TotalAmountToPay[category] = ConfigShops.Prices.hair[category].price
                else
                    PlayerSkin[data.current.category .. "_visibility"] = 0
                    TotalAmountToPay[category] = 0
                end
                MakeupOpacityTracker[category] = data.current.value
                PlayerSkin[data.current.opac] = data.current.value / 10
                toggleOverlayChange(data.current.category, 1, PlayerSkin[data.current.txt_id], 1, 0, 0, 1.0, 0, 1, PlayerSkin[data.current.color], 0, 0, 1, PlayerSkin[data.current.opac], PlayerSkin.albedo)
            end
        end, function(data, menu)

        end)
end

local EyeColorIndexTracker = 1
local TheethIndexTracker = 1

--* Face features menu
function OpenFaceMenu(table, value)
    local SubTitle = "<span style='font-size:25px;'>" .. T.MenuFacial.subtitle .. "</span><br><br>"
    Title = IsInClothingStore and "Face Menu" or T.MenuCreation.title

    if Resolution.width <= 1920 then
        SubTitle = T.MenuFacial.subtitle
    end
    MenuData.CloseAll()
    local gender = GetGender()

    local elements = {
        {
            label = T.MenuFacial.element2.label .. "<br><span style='opacity:0.6;'>" .. T.MenuFacial.amount .. #Config.Teeth[gender] .. "</span>",
            value = TheethIndexTracker,
            type = "slider",
            min = -1,
            max = #Config.Teeth[gender],
            tag = "teeth",
            desc = imgPath:format("character_creator_teeth") .. "<br>" .. T.MenuFacial.element2.desc .. "<br><br><br>" .. Divider .. "<br><br>",
        },

        {
            label = T.MenuFacial.element3.label .. "<br><span style='opacity:0.6;'> " .. T.MenuFacial.element3.desc2 .. "</span>",
            value = 0,
            tag = "jaw",
            desc = imgPath:format("character_creator_jaw") .. "<br>" .. T.MenuFacial.element3.desc .. "<br><br><br>" .. Divider .. "<br><br>",
            option = "facefeatures",
            img = "character_creator_jaw"
        },
        {
            label = T.MenuFacial.element4.label .. "<br><span style='opacity:0.6;'> " .. T.MenuFacial.element3.desc2 .. "</span>",
            value = 0,
            tag = "chin",
            desc = imgPath:format("character_creator_jaw") .. "<br>" .. T.MenuFacial.element4.desc .. "<br><br><br>" .. Divider .. "<br><br>",
            option = "facefeatures",
            img = "character_creator_jaw"
        },
        {
            label = T.MenuFacial.element5.label .. "<br><span style='opacity:0.6;'> " .. T.MenuFacial.element5.desc2 .. "</span>",
            value = "life",
            tag = "head",
            desc = imgPath:format("character_creator_cranial_proportions") .. "<br>" .. T.MenuFacial.element5.desc .. "<br><br><br>" .. Divider .. "<br><br>",
            option = "facefeatures",
            img = "character_creator_cranial_proportions"
        },

        {
            label = T.MenuFacial.element6.label .. "<br><span style='opacity:0.6;'> " .. T.MenuFacial.element6.desc2 .. "</span>",
            value = "life",
            tag = "nose",
            desc = imgPath:format("character_creator_nose") .. "<br>" .. T.MenuFacial.element6.desc .. "<br><br><br>" .. Divider .. "<br><br>",
            option = "facefeatures",
            img = "character_creator_nose"
        },
        {
            label = T.MenuFacial.element7.label .. "<br><span style='opacity:0.6;'> " .. T.MenuFacial.element7.desc2 .. "</span>",
            value = "life",
            tag = "ears",
            desc = imgPath:format("character_creator_ears") .. "<br>" .. T.MenuFacial.element7.desc .. "<br><br><br>" .. Divider .. "<br><br>",
            option = "facefeatures",
            img = "character_creator_ears"
        },
        {
            label = T.MenuFacial.element8.label .. "<br><span style='opacity:0.6;'> " .. T.MenuFacial.element8.desc2 .. "</span>",
            value = "life",
            tag = "mouthandlips",
            desc = imgPath:format("character_creator_mouth") .. "<br>" .. T.MenuFacial.element8.desc .. "<br><br><br>" .. Divider .. "<br><br>",
            option = "facefeatures",
            img = "character_creator_mouth"
        },

        {
            label = T.MenuFacial.element9.label .. "<br><span style='opacity:0.6;'> " .. T.MenuFacial.element9.desc2 .. "</span>",
            value = "life",
            tag = "cheek",
            desc = imgPath:format("character_creator_cheeks") .. "<br>" .. T.MenuFacial.element9.desc .. "<br><br><br>" .. Divider .. "<br><br>",
            option = "facefeatures",
            img = "character_creator_cheeks"
        },
        {
            label = T.MenuFacial.element10.label .. "<br><span style='opacity:0.6;'> " .. T.MenuFacial.element10.desc2 .. "</span>",
            value = "life",
            tag = "eyesandbrows",
            desc = imgPath:format("character_creator_eyebrows") .. "<br>" .. T.MenuFacial.element10.desc .. "<br><br><br>" .. Divider .. "<br><br>",
            option = "facefeatures",
            img = "character_creator_eyebrows"
        },
        {
            label = "Upper Body" .. "<br><span style='opacity:0.6;'> " .. T.MenuFacial.element11.desc2 .. "</span>",
            value = "life",
            tag = "upperbody",
            desc = imgPath:format("character_creator_eyebrows") .. "<br>" .. T.MenuFacial.element11.desc .. "<br><br><br>" .. Divider .. "<br><br>",
            option = "facefeatures",
            img = "character_creator_eyebrows"
        },
        {
            label = "Lower body" .. "<br><span style='opacity:0.6;'> " .. T.MenuFacial.element12.desc2 .. "</span>",
            value = "life",
            tag = "lowerbody",
            desc = imgPath:format("character_creator_eyebrows") .. "<br>" .. T.MenuFacial.element12.desc .. "<br><br><br>" .. Divider .. "<br><br>",
            option = "facefeatures",
            img = "character_creator_eyebrows"
        },

    }

    if IsInCharCreation or ShopType == "secondchance" then
        elements[#elements + 1] = {
            label = T.MenuFacial.element.label .. T.MenuFacial.amount .. #Config.Eyes[gender] .. "<br><span style='opacity:0.6;'> " .. Config.EyeImgColor[EyeColorIndexTracker] .. "</span>",
            value = EyeColorIndexTracker,
            type = "slider",
            max = #Config.Eyes[gender],
            min = 0,
            tag = "eyes",
            desc = imgPath:format("character_creator_eyes") .. "<br>" .. T.MenuFacial.element.desc .. "<br><br><br>" .. Divider .. "<br><br>",
        }
    end

    if ShopType == "face" then
        elements[#elements + 1] = {
            label = T.Inputs.confirm .. "<br><span style='opacity:0.6;'>" .. T.Inputs.confirmpurchase .. "</span>",
            value = "confirm",
            desc = "<br><br>" .. imgPath:format("character_creator_hair") .. "<br><br><br>" .. T.Inputs.confirmpurchase .. "<br><br>" .. Divider .. "<br><br>"
        }
        -- close
        elements[#elements + 1] = {
            label = T.MainMenu.close .. "<br><span style='opacity:0.6;'>" .. T.MainMenu.closemenu .. "</span>",
            value = "close",
            desc = "<br><br>" .. imgPath:format("character_creator_hair") .. "<br><br><br>" .. T.MainMenu.closemenu .. "<br><br>" .. Divider .. "<br><br>"
        }
    end

    MenuData.Open('default', GetCurrentResourceName(), 'OpenFaceMenu',
        {
            title = Title,
            subtext = SubTitle,
            align = Config.Align,
            elements = elements,
            lastmenu = (IsInCharCreation or ShopType == "secondchance") and "OpenAppearanceMenu" or nil,
            itemHeight = "4vh",
        },

        function(data, menu)
            if IsInCharCreation or ShopType == "secondchance" then
                if (data.current == "backup") then
                    ClearPedTasksImmediately(PlayerPedId())
                    _G[data.trigger](table, value)
                end
            end

            if data.current.value == "close" then
                menu.close()
                return BackFromMenu(value)
            end

            if data.current.value == "confirm" then
                if GetCurrentAmmountToPay() > 0 then
                    local NewTable = GetNewCompOldStructure(PlayerClothing)
                    local result = Core.Callback.TriggerAwait("vorp_character:callback:PayToShop", { skin = PlayerSkin, comps = NewTable, amount = GetCurrentAmmountToPay() })
                    if result then
                        CachedSkin = PlayerSkin
                        UpdateCache(NewTable)
                    end
                end
                menu.close()
                BackFromMenu(value)
            end


            if data.current.tag == "eyes" and data.current.value > 0 then
                StartAnimation("mood_normal_eyes_wide")
                IsPedReadyToRender()
                PlayerSkin.Eyes = Config.Eyes[gender][data.current.value]
                ApplyShopItemToPed(PlayerSkin.Eyes)
                UpdatePedVariation()
                EyeColorIndexTracker = data.current.value
                menu.setElement(1, "label", T.MenuFacial.element.label .. T.MenuFacial.amount .. #Config.Eyes[gender] .. "<br><span style='opacity:0.6;'> " .. Config.EyeImgColor[EyeColorIndexTracker] .. "</span>")
                menu.refresh()
            end

            if data.current.tag == "teeth" then
                IsPedReadyToRender()
                if data.current.value > 0 then
                    StartAnimation("Face_Dentistry_Loop")
                    PlayerClothing.Teeth.comp = Config.Teeth[gender][data.current.value].hash
                    ApplyShopItemToPed(PlayerClothing.Teeth.comp)
                    TheethIndexTracker = data.current.value
                    TotalAmountToPay.Teeth = ConfigShops.Prices.face.Teeth.price
                else
                    StartAnimation("Face_Dentistry_Out")
                    TotalAmountToPay.Teeth = 0
                end
                UpdatePedVariation()
            end

            if data.current.option == "facefeatures" then
                OpenFaceModificationMenu(table, data.current.tag, data.current.img, value)
            end
        end, function(data, menu)

        end)
end

function OpenFaceModificationMenu(table, comp, img, value)
    MenuData.CloseAll()
    local elements = {}
    local __player = PlayerPedId()

    for key, value in pairs(Config.FaceFeatures[comp]) do
        elements[#elements + 1] = {
            label = key .. "<br><span style='opacity:0.6;'>" .. T.MenuFacial.minmax .. "</span>",
            value = PlayerSkin[value.comp],
            type = "slider",
            min = -1.0,
            max = 1.0,
            hop = 0.1,
            comp = value.comp,
            hash = value.hash,
            desc = imgPath:format(img) .. "<br><br><br><br><br><br><br><br><br><br>" .. Divider .. "<br><br>",
            tag = key
        }
    end

    MenuData.Open('default', GetCurrentResourceName(), 'OpenFaceModificationMenu',
        {
            title = Title,
            subtext = "<span style='font-size:25px;'>" .. T.MenuFaceModify.subtitle .. "</span><br><br>",
            align = Config.Align,
            elements = elements,
            lastmenu = "OpenFaceMenu",
            itemHeight = "4vh",
        },

        function(data, menu)
            if (data.current == "backup") then
                _G[data.trigger](table, value)
            end

            if data.current.tag then
                local value = data.current.value == -1 and -1.0 or data.current.value
                value = data.current.value == 1 and 1.0 or value
                PlayerSkin[data.current.comp] = value
                IsPedReadyToRender()
                SetCharExpression(__player, data.current.hash, PlayerSkin[data.current.comp])
                UpdatePedVariation()
                if data.current.value == 0 then
                    TotalAmountToPay[comp] = 0
                else
                    TotalAmountToPay[comp] = ConfigShops.Prices.face[comp].price
                end
            end
        end, function(data, menu)

        end)
end

--* HELPER
local labelLookup = {
    moles = {
        label = T.MenuLifeStyle.element.label,
        txt_id = "moles_tx_id",
        opacity = "moles_opacity",
        vis = "moles_visibility"
    },
    spots = {
        label = T.MenuLifeStyle.element2.label,
        txt_id = "spots_tx_id",
        opacity = "spots_opacity",
        vis = "spots_visibility"
    },
    complex = {
        label = T.MenuLifeStyle.element3.label,
        txt_id = "complex_tx_id",
        opacity = "complex_opacity",
        vis = "complex_visibility"
    },
    acne = {
        label = T.MenuLifeStyle.element4.label,
        txt_id = "acne_tx_id",
        opacity = "acne_opacity",
        vis = "acne_visibility"
    },
    freckles = {
        label = T.MenuLifeStyle.element5.label,
        txt_id = "freckles_tx_id",
        opacity = "freckles_opacity",
        vis = "freckles_visibility"
    },
    disc = {
        label = T.MenuLifeStyle.element6.label,
        txt_id = "disc_tx_id",
        opacity = "disc_opacity",
        vis = "disc_visibility"
    },
    scars = {
        label = T.MenuLifeStyle.element7.label,
        txt_id = "scars_tx_id",
        opacity = "scars_opacity",
        vis = "scars_visibility"
    },
    grime = {
        label = T.MenuLifeStyle.element8.label,
        txt_id = "grime_tx_id",
        opacity = "grime_opacity",
        vis = "grime_visibility"
    },
}


function OpenLifeStyleMenu(table, value)
    Title = IsInClothingStore and "Life Style Menu" or T.MenuCreation.title

    MenuData.CloseAll()
    local elements = {}

    for key, value in pairs(Config.overlays_info) do
        if labelLookup[key] then
            elements[#elements + 1] = {
                label = labelLookup[key].label .. "<br><span style='opacity:0.6;'>texture</span>",
                value = PlayerSkin[labelLookup[key].txt_id],
                min = 0,
                max = #value,
                type = "slider",
                txt_id = labelLookup[key].txt_id,
                opac = labelLookup[key].opacity,
                visibility = labelLookup[key].vis,
                desc = T.MenuLifeStyle.element.desc .. "<br><br><br><br><br><br>" .. Divider .. "<br><br>" .. T.MenuLifeStyle.scroll,
                name = key,
                tag = "texture"
            }
            elements[#elements + 1] = {
                label = labelLookup[key].label .. T.MenuLifeStyle.label .. "<br><span style='opacity:0.6;'>" .. T.MenuLifeStyle.label .. "</span>",
                value = PlayerSkin[labelLookup[key].opacity],
                min = 0,
                max = 10,
                type = "slider",
                txt_id = labelLookup[key].txt_id,
                opac = labelLookup[key].opacity,
                visibility = labelLookup[key].vis,
                desc = T.MenuLifeStyle.desc .. "<br><br><br><br><br><br>" .. Divider .. "<br><br>" .. T.MenuLifeStyle.scroll,
                name = key,
                tag = "opacity"
            }
        end
    end
    if ShopType == "lifestyle" then
        elements[#elements + 1] = {
            label = T.Inputs.confirm .. "<br><span style='opacity:0.6;'>" .. T.Inputs.confirmpurchase .. "</span><br><br>",
            value = "confirm",
            desc = "<br><br>" .. imgPath:format("character_creator_hair") .. "<br><br><br>" .. T.Inputs.confirmpurchase .. "<br><br>" .. Divider .. "<br><br>"
        }
        -- close
        elements[#elements + 1] = {
            label = T.MainMenu.close .. "<br><span style='opacity:0.6;'>" .. T.MainMenu.closemenu .. "</span>",
            value = "close",
            desc = "<br><br>" .. imgPath:format("character_creator_hair") .. "<br><br><br>" .. T.MainMenu.closemenu .. "<br><br>" .. Divider .. "<br><br>"
        }
    end
    MenuData.Open('default', GetCurrentResourceName(), 'OpenLifeStyleMenu',
        {
            title = Title,
            subtext = "<span style='font-size:25px;'>" .. T.MenuLifeStyle.subtitle .. "</span><br><br>",
            align = Config.Align,
            elements = elements,
            lastmenu = (IsInCharCreation or ShopType == "secondchance") and "OpenAppearanceMenu" or nil,
            itemHeight = "4vh",
        },

        function(data, menu)
            if (data.current == "backup") then
                _G[data.trigger](table, value)
            end

            if data.current.value == "close" then
                menu.close()
                return BackFromMenu(value)
            end

            if data.current.value == "confirm" then
                if GetCurrentAmmountToPay() > 0 then
                    local result = Core.Callback.TriggerAwait("vorp_character:callback:PayToShop", { amount = GetCurrentAmmountToPay(), skin = PlayerSkin })
                    if result then
                        CachedSkin = PlayerSkin
                    end
                end
                menu.close()
                BackFromMenu(value)
            end
        
  
            if data.current.tag == "texture" then
                local color = data.current.name == "grime" and 1 or 0
                local colortype = data.current.name == "grime" and 0 or 1
                if data.current.value > 0 then
                    PlayerSkin[data.current.txt_id] = data.current.value
                    toggleOverlayChange(data.current.name, PlayerSkin[data.current.visibility], PlayerSkin[data.current.txt_id], 0, 0, colortype, 1.0, 0, color, 0, 0, 0, 1, PlayerSkin[data.current.opac], PlayerSkin.albedo)
                    TotalAmountToPay[data.current.name] = ConfigShops.Prices.lifestyle[data.current.name].price

                else
                    PlayerSkin[data.current.txt_id] = 0
                    toggleOverlayChange(data.current.name, PlayerSkin[data.current.visibility], PlayerSkin[data.current.txt_id], 0, 0, colortype, 1.0, 0, color, 0, 0, 0, 1, PlayerSkin[data.current.opac], PlayerSkin.albedo)
                    TotalAmountToPay[data.current.name] = 0

                end
            end


            if data.current.tag == "opacity" then
                local color = data.current.name == "grime" and 1 or 0
                local colortype = data.current.name == "grime" and 0 or 1
                if data.current.value > 0 then
                    PlayerSkin[data.current.visibility] = 1
                    PlayerSkin[data.current.opac] = data.current.value / 10
                    toggleOverlayChange(data.current.name, PlayerSkin[data.current.visibility], PlayerSkin[data.current.txt_id], 0, 0, colortype, 1.0, 0, color, 0, 0, 0, 1, PlayerSkin[data.current.opac], PlayerSkin.albedo)
                    TotalAmountToPay[data.current.name] = ConfigShops.Prices.lifestyle[data.current.name].price
                else
                    PlayerSkin[data.current.visibility] = 0
                    PlayerSkin[data.current.opac] = 0
                    toggleOverlayChange(data.current.name, PlayerSkin[data.current.visibility], PlayerSkin[data.current.txt_id], 0, 0, colortype, 1.0, 0, color, 0, 0, 0, 1, PlayerSkin[data.current.opac], PlayerSkin.albedo)
                    TotalAmountToPay[data.current.name] = 0
                end
                

            end
        end, 
        function(data, menu)
        if IsInClothingStore and ShopType ~= "secondchance" then
            menu.close()
            BackFromMenu(value)
        end
    end)
end


local overlayLookup = {
    lipsticks = {
        label = T.MenuMakeup.element.label,
        txt_id = "lipsticks_tx_id",
        color = "lipsticks_palette_color_primary",
        color2 = "lipsticks_palette_color_secondary",
        color3 = "lipsticks_palette_color_tertiary",
        variant = "lipsticks_palette_id",
        varvalue = 7,
        opacity = "lipsticks_opacity",
        visibility = "lipsticks_visibility"
    },
    blush = {
        label = T.MenuMakeup.element2.label,
        txt_id = "blush_tx_id",
        color = "blush_palette_color_primary",
        opacity = "blush_opacity",
        visibility = "blush_visibility"
    },
    eyeliners = {
        label = T.MenuMakeup.element3.label,
        txt_id = "eyeliner_tx_id",
        variant = "eyeliner_palette_id",
        varvalue = 15,
        color = "eyeliner_color_primary",
        opacity = "eyeliner_opacity",
        visibility = "eyeliner_visibility"
    },
    shadows = {
        label = T.MenuMakeup.element4.label,
        txt_id = "shadows_tx_id",
        color = "shadows_palette_color_primary",
        color2 = "shadows_palette_color_secondary",
        color3 = "shadows_palette_color_tertiary",
        variant = "shadows_palette_id",
        varvalue = 5,
        opacity = "shadows_opacity",
        visibility = "shadows_visibility"
    },
    foundation = {
        label = T.MenuMakeup.Foundation,
        txt_id = "foundation_tx_id",
        color = "foundation_palette_color_primary",
        color2 = "foundation_palette_color_secondary",
        color3 = "foundation_palette_color_tertiary",
        opacity = "foundation_opacity",
        visibility = "foundation_visibility",
        variant = "foundation_palette_id",
        varvalue = 5,
    },

}


function OpenMakeupMenu(table, value)
    Title = IsInClothingStore and "Makeup Menu" or T.MenuCreation.title
    MenuData.CloseAll()
    local elements = {}

    for key, value in pairs(Config.overlays_info) do
        if overlayLookup[key] then
            elements[#elements + 1] = {
                label = overlayLookup[key].label .. "<br><span style='opacity:0.6;'>" .. T.MenuMakeup.element5.label .. T.MenuMakeup.element5.desc2 .. #value .. "</span>",
                value = PlayerSkin[overlayLookup[key].txt_id],
                min = 0,
                max = #value,
                type = "slider",
                txt_id = overlayLookup[key].txt_id,
                opac = overlayLookup[key].opacity,
                color = overlayLookup[key].color,
                variant = overlayLookup[key].variant,
                visibility = overlayLookup[key].visibility,
                desc = T.MenuMakeup.element5.desc .. "<br><br><br><br><br><br>" .. Divider .. "<br><br>" .. T.MenuLifeStyle.scroll,
                name = key,
                tag = "texture"
            }

            local ColorValue = 0
            for x, color in pairs(Config.color_palettes[key]) do
                if joaat(color) == PlayerSkin[overlayLookup[key].color] then
                    ColorValue = x
                end
            end

            elements[#elements + 1] = {
                label = overlayLookup[key].label .. "<br><span style='opacity:0.6;'>" .. T.MenuMakeup.element6.label .. T.MenuMakeup.element7.desc2 .. "</span>",
                value = ColorValue,
                min = 0,
                max = 10,
                comp = Config.color_palettes[key],
                type = "slider",
                txt_id = overlayLookup[key].txt_id,
                opac = overlayLookup[key].opacity,
                color = overlayLookup[key].color,
                visibility = overlayLookup[key].visibility,
                variant = overlayLookup[key].variant,
                desc = T.MenuMakeup.element6.desc .. "<br><br><br><br><br><br>" .. Divider .. "<br><br>" .. T.MenuLifeStyle.scroll,
                name = key,
                tag = "color"
            }


            if key == "lipsticks" then
                local Color2Value = 0
                for x, color in pairs(Config.color_palettes[key]) do
                    if joaat(color) == PlayerSkin[overlayLookup[key].color2] then
                        Color2Value = x
                    end
                end

                elements[#elements + 1] = {
                    label = overlayLookup[key].label .. "<br><span style='opacity:0.6;'>" .. T.MenuMakeup.element7.label .. T.MenuMakeup.element7.desc2 .. "</span>",
                    value = Color2Value,
                    min = 0,
                    max = 10,
                    type = "slider",
                    comp = Config.color_palettes[key],
                    txt_id = overlayLookup[key].txt_id,
                    opac = overlayLookup[key].opacity,
                    color = overlayLookup[key].color,
                    color2 = overlayLookup[key].color2,
                    color3 = overlayLookup[key].color3,
                    variant = overlayLookup[key].variant,
                    visibility = overlayLookup[key].visibility,
                    desc = T.MenuMakeup.element7.desc .. "<br><br><br><br><br><br>" .. Divider .. "<br><br>" .. T.MenuLifeStyle.scroll,
                    name = key,
                    tag = "color2"
                }
            end

            if key == "lipsticks" or key == "shadows" or key == "eyeliners" or key == "foundation" then
                elements[#elements + 1] = {
                    label = overlayLookup[key].label .. "<br><span style='opacity:0.6;'>" .. T.MenuMakeup.element8.label .. " max " .. overlayLookup[key].varvalue .. "</span>",
                    value = PlayerSkin[overlayLookup[key].variant] or 0,
                    min = 0,
                    max = overlayLookup[key].varvalue,
                    type = "slider",
                    comp = Config.color_palettes[key],
                    txt_id = overlayLookup[key].txt_id,
                    opac = overlayLookup[key].opacity,
                    color = overlayLookup[key].color,
                    color2 = overlayLookup[key].color2,
                    color3 = overlayLookup[key].color3,
                    variant = overlayLookup[key].variant,
                    visibility = overlayLookup[key].visibility,
                    desc = T.MenuMakeup.element8.desc .. "<br><br><br><br><br><br>" .. Divider .. "<br><br>" .. T.MenuLifeStyle.scroll,
                    name = key,
                    tag = "variant"
                }
            end

            elements[#elements + 1] = {
                label = overlayLookup[key].label .. "<br><span style='opacity:0.6;'>" .. T.MenuMakeup.element9.label .. T.MenuMakeup.element9.desc2 .. "</span>",
                value = PlayerSkin[overlayLookup[key].opacity],
                min = 0,
                max = 0.9,
                hop = 0.1,
                type = "slider",
                txt_id = overlayLookup[key].txt_id,
                opac = overlayLookup[key].opacity,
                color = overlayLookup[key].color,
                variant = overlayLookup[key].variant,
                visibility = overlayLookup[key].visibility,
                desc = T.MenuMakeup.element9.desc .. "<br><br><br><br><br><br>" .. Divider .. "<br><br>" .. T.MenuLifeStyle.scroll,
                name = key,
                tag = "opacity"
            }
        end
    end

    if ShopType == "makeup" then
        elements[#elements + 1] = {
            label = T.Inputs.confirm .. "<br><span style='opacity:0.6;'>" .. T.Inputs.confirmpurchase .. "</span><br><br>",
            value = "confirm",
            desc = "<br><br>" .. imgPath:format("character_creator_hair") .. "<br><br><br>" .. T.Inputs.confirmpurchase .. "<br><br>" .. Divider .. "<br><br>"
        }
        -- close
        elements[#elements + 1] = {
            label = T.MainMenu.close .. "<br><span style='opacity:0.6;'>" .. T.MainMenu.closemenu .. "</span>",
            value = "close",
            desc = "<br><br>" .. imgPath:format("character_creator_hair") .. "<br><br><br>" .. T.MainMenu.closemenu .. "<br><br>" .. Divider .. "<br><br>"
        }
    end

    MenuData.Open('default', GetCurrentResourceName(), 'OpenMakeupMenu',
        {
            title = Title,
            subtext = "<span style='font-size:25px;'>" .. T.MenuMakeup.subtitle .. "</span><br><br>",
            align = Config.Align,
            elements = elements,
            lastmenu = (IsInCharCreation or ShopType == "secondchance") and "OpenAppearanceMenu" or nil,
            itemHeight = "4vh",
        },


        function(data, menu)
            if IsInCharCreation or ShopType == "secondchance" then
                if (data.current == "backup") then
                    _G[data.trigger](table, value)
                end
            end

            if data.current.value == "close" then
                menu.close()
                return BackFromMenu(value)
            end

            if data.current.value == "confirm" then
                if GetCurrentAmmountToPay() > 0 then
                    local result = Core.Callback.TriggerAwait("vorp_character:callback:PayToShop", { amount = GetCurrentAmmountToPay(), skin = PlayerSkin })
                    if result then
                        CachedSkin = PlayerSkin
                    end
                end
                menu.close()
                BackFromMenu(value)
            end

            if data.current.tag == "texture" then
                if data.current.value == 0 then
                    PlayerSkin[data.current.visibility] = 0
                    TotalAmountToPay[data.current.name] = 0
                else
                    TotalAmountToPay[data.current.name] = ConfigShops.Prices.makeup[data.current.name].price
                    PlayerSkin[data.current.visibility] = 1
                end
                PlayerSkin[data.current.txt_id] = data.current.value
                toggleOverlayChange(data.current.name, PlayerSkin[data.current.visibility],
                    PlayerSkin[data.current.txt_id], 1, 0, 0,
                    1.0, 0, 1, PlayerSkin[data.current.color], PlayerSkin[data.current.color2] or 0,
                    PlayerSkin[data.current.color3] or 0, PlayerSkin[data.current.variant] or 1,
                    PlayerSkin[data.current.opac], PlayerSkin.albedo)
            end

            if data.current.tag == "color" then
                PlayerSkin[data.current.color] = data.current.comp[data.current.value]
                toggleOverlayChange(data.current.name, PlayerSkin[data.current.visibility],
                    PlayerSkin[data.current.txt_id], 1, 0, 0,
                    1.0, 0, 1, PlayerSkin[data.current.color], PlayerSkin[data.current.color2] or 0,
                    PlayerSkin[data.current.color3] or 0, PlayerSkin[data.current.variant] or 1,
                    PlayerSkin[data.current.opac], PlayerSkin.albedo)
            end

            if data.current.tag == "color2" then
                PlayerSkin[data.current.color2] = data.current.comp[data.current.value]
                toggleOverlayChange(data.current.name, PlayerSkin[data.current.visibility],
                    PlayerSkin[data.current.txt_id], 1, 0, 0,
                    1.0, 0, 1, PlayerSkin[data.current.color], PlayerSkin[data.current.color2] or 0,
                    PlayerSkin[data.current.color3] or 0, PlayerSkin[data.current.variant] or 1, PlayerSkin
                    [data.current.opac], PlayerSkin.albedo)
            end

            if data.current.tag == "variant" then
                PlayerSkin[data.current.variant] = data.current.value
                toggleOverlayChange(data.current.name, PlayerSkin[data.current.visibility],
                    PlayerSkin[data.current.txt_id], 1, 0, 0,
                    1.0, 0, 1, PlayerSkin[data.current.color], PlayerSkin[data.current.color2] or 0,
                    PlayerSkin[data.current.color3] or 0, PlayerSkin[data.current.variant] or 1,
                    PlayerSkin[data.current.opac], PlayerSkin.albedo)
            end

            if data.current.tag == "opacity" then
                if data.current.value == 0 then
                    PlayerSkin[data.current.visibility] = 0
                    TotalAmountToPay[data.current.name] = 0
                else
                    PlayerSkin[data.current.visibility] = 1
                    TotalAmountToPay[data.current.name] = ConfigShops.Prices.makeup[data.current.name].price
                end

                PlayerSkin[data.current.opac] = data.current.value
                toggleOverlayChange(data.current.name, PlayerSkin[data.current.visibility],
                    PlayerSkin[data.current.txt_id], 1, 0, 0,
                    1.0, 0, 1, PlayerSkin[data.current.color], PlayerSkin[data.current.color2] or 0,
                    PlayerSkin[data.current.color3] or 0, PlayerSkin[data.current.variant] or 1,
                    PlayerSkin[data.current.opac], PlayerSkin.albedo)
            end
        end, function(data, menu)
            if IsInClothingStore and ShopType ~= "secondchance" then
                menu.close()
                BackFromMenu(value)
            end
        end)
end

--* OUTFITS MENU
function OpenOutfitsMenu(Table, value, Outfits)
    MenuData.CloseAll()

    TotalAmountToPay = {}

    for i, tag in pairs(Config.HashList) do
        if i ~= 'Hair' and i ~= 'Beard' then
            RemoveTagFromMetaPed(tag)
            UpdatePedVariation()
        end
    end
    LoadComps(PlayerPedId(), CachedComponents)
    SetCachedClothingIndex()

    local menuSpace = "<br><br><br><br><br><br><br><br><br><br><br>"

    if Resolution.width <= 1920 then
        menuSpace = "<br><br>"
    end

    local elements = {}

    for i, v in ipairs(Outfits) do
        elements[#elements + 1] = {
            label = v.title,
            value = v,
            desc = imgPath:format('clothing_generic_outfit') .. menuSpace .. Divider .. "<br> " .. T.MenuOutfits.option,
        }
    end

    MenuData.Open('default', GetCurrentResourceName(), 'OpenOutfitsMenu',
        {
            title = T.MenuOutfits.title,
            subtext = T.MenuOutfits.subtitle,
            align = Config.Align,
            elements = elements,
            lastmenu = "OpenClothingMenu",
        },

        function(data, menu)
            if (data.current == "backup") then -- go back
                return _G[data.trigger](Table, value, Outfits)
            end

            if data.current.value then
                OpenOutfitMenu(Table, value, Outfits, data.current.value)
            end
        end,
        function(data, menu)

        end)
end

function OpenOutfitMenu(Table, value, Outfits, Outfit)
    MenuData.CloseAll()

    local comps = {}

    for k, v in pairs(Outfit.comps and json.decode(Outfit.comps) or {}) do
        comps[k] = { comp = v }
    end

    local compTints = Outfit.compTints and json.decode(Outfit.compTints) or {}

    for i, tag in pairs(Config.HashList) do
        if i ~= 'Hair' and i ~= 'Beard' then
            RemoveTagFromMetaPed(tag)
            UpdatePedVariation()
        end
    end
    LoadComps(PlayerPedId(), ConvertTableComps(comps, IndexTintCompsToNumber(compTints)))

    local menuSpace = "<br><br><br><br><br><br><br><br><br><br><br>"

    if Resolution.width <= 1920 then
        menuSpace = "<br><br>"
    end

    local elements = {}

    elements[#elements + 1] = {
        label = T.MenuOutfits.Select,
        value = "Select",
        desc = imgPath:format('clothing_generic_outfit') .. menuSpace .. Divider .. "<br> " .. T.MenuOutfits.option,
    }

    elements[#elements + 1] = {
        label = T.MenuOutfits.Delete,
        value = "Delete",
        desc = imgPath:format('clothing_generic_outfit') .. menuSpace .. Divider .. "<br> " .. T.MenuOutfits.option,
    }

    MenuData.Open('default', GetCurrentResourceName(), 'OpenOutfitMenu',
        {
            title = T.MenuOutfits.title,
            subtext = Outfit.title,
            align = Config.Align,
            elements = elements,
            lastmenu = "OpenOutfitsMenu",
        },

        function(data, menu)
            if (data.current == "backup") then -- go back
                return _G[data.trigger](Table, value, Outfits)
            end

            if data.current.value == "Select" then
                local result = Core.Callback.TriggerAwait("vorp_character:callback:SetOutfit", { Outfit = Outfit, })
                if result then
                    local comps = {}

                    for k, v in pairs(Outfit.comps and json.decode(Outfit.comps) or {}) do
                        comps[k] = { comp = v }
                    end

                    local compTints = Outfit.compTints and json.decode(Outfit.compTints) or {}

                    CachedComponents = ConvertTableComps(comps, IndexTintCompsToNumber(compTints))

                    menu.close()
                    return BackFromMenu(value)
                end
            end

            if data.current.value == "Delete" then
                local MyInput = {
                    type = "enableinput",
                    inputType = "input",
                    button = T.Inputs.confirm,
                    placeholder = Outfit.title,
                    style = "block",
                    attributes = {
                        inputHeader = T.MenuOutfits.inputHeader,
                        type = "textarea",
                        pattern = ".*",
                        title = T.Inputs.title,
                        style = "border-radius: 10px; background-color: ; border:none;"
                    }
                }
                TriggerEvent("vorpinputs:advancedInput", json.encode(MyInput), function(result)
                    local Result = tostring(result)
                    if Result ~= nil and Result ~= "" and Result == Outfit.title then
                        local result = Core.Callback.TriggerAwait("vorp_character:callback:DeleteOutfit",
                            {
                                Outfit = Outfit,
                            })

                        if result then
                            for i, v in pairs(Outfits) do
                                if v.id == Outfit.id then
                                    table.remove(Outfits, i)
                                    break
                                end
                            end

                            OpenOutfitsMenu(Table, value, Outfits)
                        end
                    end
                end)
            end
        end,
        function(data, menu)

        end)
end
