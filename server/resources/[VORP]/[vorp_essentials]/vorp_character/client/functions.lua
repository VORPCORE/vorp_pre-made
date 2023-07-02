--LOAD COMPS
function ApplyComponentToPed(ped, comp)
    Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, comp, false, true, true)
    Citizen.InvokeNative(0x66b957aac2eaaeab, ped, comp, 0, 0, 1, 1) -- _UPDATE_SHOP_ITEM_WEARABLE_STATE
    Citizen.InvokeNative(0xAAB86462966168CE, ped, 1)
    UpdateVariation(ped)
end

function UpdateVariation(ped)
    Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, false, true, true, true, false)
    IsPedReadyToRender()
end

function IsPedReadyToRender()
    Citizen.InvokeNative(0xA0BC8FAED8CFEB3C, PlayerPedId())
    while not Citizen.InvokeNative(0xA0BC8FAED8CFEB3C, PlayerPedId()) do
        Citizen.InvokeNative(0xA0BC8FAED8CFEB3C, PlayerPedId())
        Wait(0)
    end
end

---Remove all meta tags from ped
---@param ped number ped id
function RemoveMetaTags(ped)
    for _, tag in pairs(Config.HashList) do
        Citizen.InvokeNative(0xD710A5007C2AC539, ped, tag, 0)
        UpdateVariation(ped)
    end
end

--- set to all white if values are 0
---@param gender string ped gender
---@param skin table skin data
---@return table skin data
function SetDefaultSkin(gender, skin)
    local __data = {}
    for _, value in pairs(Config.DefaultChar[gender]) do
        for key, _ in pairs(value) do
            if key == "HeadTexture" then
                local headtext = joaat(value.HeadTexture[1])
                if headtext == skin.albedo then
                    __data = value
                    break
                end
            end
        end
    end

    if skin.HeadType == 0 then
        skin.HeadType = tonumber("0x" .. __data.Heads[1])
    end

    if skin.BodyType == 0 then
        skin.BodyType = tonumber("0x" .. __data.Body[1])
    end

    if skin.LegsType == 0 then
        skin.LegsType = tonumber("0x" .. __data.Legs[1])
    end

    if skin.Torso == 0 or nil then
        skin.Torso = tonumber("0x" .. __data.Body[1])
    end

    return skin
end

--CREATOR
function RemoveImaps()
    if IsImapActive(183712523) then
        RequestImap(183712523)
    end

    if IsImapActive(-1699673416) then
        RemoveImap(-1699673416)
    end

    if IsImapActive(1679934574) then
        RemoveImap(1679934574)
    end
end

function RequestImapCreator()
    if not IsImapActive(183712523) then
        RequestImap(183712523)
    end
    if not IsImapActive(-1699673416) then
        RequestImap(-1699673416)
    end
    if not IsImapActive(1679934574) then
        RequestImap(1679934574)
    end
end

function LoadPlayer(sex)
    RequestModel(sex)
    while not HasModelLoaded(sex) do
        Wait(10)
    end
end

function DeleteNpc(pedHandler)
    if pedHandler then
        while DoesEntityExist(pedHandler) do
            DeleteEntity(pedHandler)
            Wait(0)
        end
    end
end

TableHair = {}

function GetHair(gender, category)
    TableHair = {}
    for key, value in pairs(HairComponents[gender][category]) do
        for k, v in pairs(value) do
            if not TableHair[key] then
                TableHair[key] = {}
            end
            if TableHair[key] then
                TableHair[key][k] = v.hash
            end
        end
    end
end

function GetGender()
    if not IsPedMale(PlayerPedId()) then
        return "Female"
    end

    return "Male"
end

local textureId = -1

function toggleOverlayChange(name, visibility, tx_id, tx_normal, tx_material, tx_color_type, tx_opacity, tx_unk,
                             palette_id, palette_color_primary, palette_color_secondary, palette_color_tertiary, var,
                             opacity, albedo)
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
                    v.palette_color_primary = palette_color_primary
                    v.palette_color_secondary = palette_color_secondary
                    v.palette_color_tertiary = palette_color_tertiary
                end
                if name == "shadows" or name == "eyeliners" or name == "lipsticks" then
                    v.var = var
                    if tx_id ~= 0 then
                        v.tx_id = Config.overlays_info[name][1].id
                    end
                else
                    v.var = 0
                    if tx_id ~= 0 then
                        v.tx_id = Config.overlays_info[name][tx_id].id
                    end
                end
                v.opacity = opacity
            end
        end
    end

    local ped = PlayerPedId()
    local gender = GetGender()
    local current_texture_settings = Config.texture_types[gender]

    if textureId ~= -1 then
        Citizen.InvokeNative(0xB63B9178D0F58D82, textureId) -- reset texture
        Citizen.InvokeNative(0x6BEFAA907B076859, textureId) -- remove texture
    end

    textureId = Citizen.InvokeNative(0xC5E7204F322E49EB, albedo, current_texture_settings.normal,
        current_texture_settings.material) -- create texture

    for k, v in pairs(Config.overlay_all_layers) do
        if v.visibility ~= 0 then
            local overlay_id = Citizen.InvokeNative(0x86BB5FF45F193A02, textureId, v.tx_id, v.tx_normal,
                v.tx_material, v.tx_color_type, v.tx_opacity, v.tx_unk)                    -- create overlay
            if v.tx_color_type == 0 then
                Citizen.InvokeNative(0x1ED8588524AC9BE1, textureId, overlay_id, v.palette) -- apply palette
                Citizen.InvokeNative(0x2DF59FFE6FFD6044, textureId, overlay_id, v.palette_color_primary,
                    v.palette_color_secondary, v.palette_color_tertiary)                   -- apply palette colours
            end

            Citizen.InvokeNative(0x3329AAE2882FC8E4, textureId, overlay_id, v.var);     -- apply overlay variant
            Citizen.InvokeNative(0x6C76BC24F8BB709A, textureId, overlay_id, v.opacity); -- apply overlay opacity
        end
    end

    while not Citizen.InvokeNative(0x31DC8D3F216D8509, textureId) do -- wait till texture fully loaded
        Citizen.Wait(0)
    end

    Citizen.InvokeNative(0x92DAABA2C1C10B0E, textureId)                           -- update texture
    Citizen.InvokeNative(0x0B46E25761519058, ped, joaat("heads"), textureId)      -- apply texture to current component in category "heads"
    Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, false, true, true, true, false) -- refresh ped components
end
