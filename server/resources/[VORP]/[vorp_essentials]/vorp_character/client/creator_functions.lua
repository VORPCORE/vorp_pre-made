MetaPedCategoryTags = {
    maleTags = {
        [`accessories`]         = "Accessories",
        [`ammo_pistols`]        = "ammo_pistols",
        [`ammo_rifles`]         = "ammo_rifles",
        [`ankle_bindings`]      = "ankle_bindings",
        [`aprons`]              = "aprons",
        [`armor`]               = "Armor",
        [`badges`]              = "Badge",
        [`beards_chin`]         = "beards_chin",
        [`beards_chops`]        = "beards_chops",
        [`beards_complete`]     = "beards_complete",
        [`beards_mustache`]     = "beards_mustache",
        [`belts`]               = "Belts",
        [`belt_buckles`]        = "Buckle",
        [`bodies_lower`]        = "Boots",
        [`bodies_upper`]        = "bodies_upper",
        [`boots`]               = "boots",
        [`boot_accessories`]    = "Spurs",
        [`chaps`]               = "Chap",
        [`cloaks`]              = "Cloak",
        [`coats`]               = "Coat",
        [`coats_closed`]        = "CoatClosed",
        [`coats_heavy`]         = "coats_heavy",
        [`dresses`]             = "Dress",
        [`eyebrows`]            = "eyebrows",
        [`eyes`]                = "eyes",
        [`eyewear`]             = "EyeWear",
        [`gauntlets`]           = "Gauntlets",
        [`gloves`]              = "Glove",
        [`gunbelt_accs`]        = "GunbeltAccs",
        [`gunbelts`]            = "Gunbelt",
        [`hair`]                = "hair",
        [`hair_accessories`]    = "hair_accessories",
        [`hats`]                = "Hat",
        [`heads`]               = "heads",
        [`holsters_crossdraw`]  = "holsters_crossdraw",
        [`holsters_knife`]      = "holsters_knife",
        [`holsters_left`]       = "Holster",
        [`holsters_right`]      = "holsters_right",
        [`jewelry_bracelets`]   = "Vracelet",
        [`jewelry_rings_left`]  = "RingLh",
        [`jewelry_rings_right`] = "RingRh",
        [`loadouts`]            = "Loadouts",
        [`masks`]               = "Mask",
        [`masks_large`]         = "masks_large",
        [`neckties`]            = "NeckTies",
        [`neckwear`]            = "NeckWear",
        [`outfits`]             = "outfits",
        [`pants`]               = "Pant",
        [`ponchos`]             = "Poncho",
        [`satchels`]            = "Satchels",
        [`shirts_full`]         = "Shirt",
        [`skirts`]              = "Skirt",
        [`spats`]               = "Spats",
        [`suspenders`]          = "Suspenders",
        [`teeth`]               = "teeth",
        [`vests`]               = "Vest",
        [`wrist_bindings`]      = "wrist_bindings",
    },

    femaleTags = {
        [`accessories`]         = "Accessories",
        [`ammo_pistols`]        = "ammo_pistols",
        [`ammo_rifles`]         = "ammo_rifles",
        [`ankle_bindings`]      = "ankle_bindings",
        [`aprons`]              = "aprons",
        [`armor`]               = "Armor",
        [`badges`]              = "Badge",
        [`beards_chin`]         = "beards_chin",
        [`beards_chops`]        = "beards_chops",
        [`beards_complete`]     = "beards_complete",
        [`beards_mustache`]     = "beards_mustache",
        [`belts`]               = "Belts",
        [`belt_buckles`]        = "Buckle",
        [`bodies_lower`]        = "Boots",
        [`bodies_upper`]        = "bodies_upper",
        [`boots`]               = "boots",
        [`boot_accessories`]    = "Spurs",
        [`chaps`]               = "Chap",
        [`cloaks`]              = "Cloak",
        [`coats`]               = "Coat",
        [`coats_closed`]        = "CoatClosed",
        [`coats_heavy`]         = "coats_heavy",
        [`dresses`]             = "Dress",
        [`eyebrows`]            = "eyebrows",
        [`eyes`]                = "eyes",
        [`eyewear`]             = "EyeWear",
        [`gauntlets`]           = "Gauntlets",
        [`gloves`]              = "Glove",
        [`gunbelt_accs`]        = "GunbeltAccs",
        [`gunbelts`]            = "Gunbelt",
        [`hair`]                = "hair",
        [`hair_accessories`]    = "hair_accessories",
        [`hats`]                = "Hat",
        [`heads`]               = "heads",
        [`holsters_crossdraw`]  = "holsters_crossdraw",
        [`holsters_knife`]      = "holsters_knife",
        [`holsters_left`]       = "Holster",
        [`holsters_right`]      = "holsters_right",
        [`jewelry_bracelets`]   = "Vracelet",
        [`jewelry_rings_left`]  = "RingLh",
        [`jewelry_rings_right`] = "RingRh",
        [`loadouts`]            = "Loadouts",
        [`masks`]               = "Mask",
        [`masks_large`]         = "masks_large",
        [`neckties`]            = "NeckTies",
        [`neckwear`]            = "NeckWear",
        [`outfits`]             = "outfits",
        [`pants`]               = "Pant",
        [`ponchos`]             = "Poncho",
        [`satchels`]            = "Satchels",
        [`shirts_full`]         = "Shirt",
        [`skirts`]              = "Skirt",
        [`spats`]               = "Spats",
        [`suspenders`]          = "Suspenders",
        [`teeth`]               = "teeth",
        [`vests`]               = "Vest",
        [`wrist_bindings`]      = "wrist_bindings",
    },

}

function IsPedReadyToRender(ped)
    repeat Wait(0) until Citizen.InvokeNative(0xA0BC8FAED8CFEB3C, ped or PlayerPedId())
end

function SetRandomOutfitVariation(ped, p1)
    Citizen.InvokeNative(0x283978A15512B2FE, ped, p1)
end

function EquipMetaPedOutfitPreset(ped, value)
    Citizen.InvokeNative(0x77FF8D35EEC6BBC4, ped, value, true)
end

function ResetPedComponents(ped)
    Citizen.InvokeNative(0x8507BCB710FA6DC0, ped or PlayerPedId())
end

function EquipMetaPedOutfit(hash, ped)
    Citizen.InvokeNative(0x1902C4CFCC5BE57C, ped or PlayerPedId(), hash)
end

function RemoveShopItemFromPed(comp)
    Citizen.InvokeNative(0x0D7FFA1B2F69ED82, PlayerPedId(), comp, 0, false)
end

function RefreshMetaPedShopItems()
    Citizen.InvokeNative(0x59BD177A1A48600A, PlayerPedId(), 1)
end

function RemoveTagFromMetaPed(hash, ped)
    Citizen.InvokeNative(0xD710A5007C2AC539, ped or PlayerPedId(), hash, 0)
end

function UpdatePedVariation(ped)
    Citizen.InvokeNative(0xCC8CA3E88256E58F, ped or PlayerPedId(), false, true, true, true, false)
    Citizen.InvokeNative(0xAAB86462966168CE, ped or PlayerPedId(), true)
end

function ApplyShopItemToPed(comp, ped)
    Citizen.InvokeNative(0xD3A7B003ED343FD9, ped or PlayerPedId(), comp, false, false, false)
    Citizen.InvokeNative(0xD3A7B003ED343FD9, ped or PlayerPedId(), comp, false, true, false)
end

function UpdateShopItemWearableState(comp, wearable)
    Citizen.InvokeNative(0x66B957AAC2EAAEAB, PlayerPedId(), comp, wearable, 0, 1, 1)
end

function SetCharExpression(ped, value, expression)
    Citizen.InvokeNative(0x5653AB26C82938CF, ped, value, expression)
end

function IsMetaPedUsingComponent(comp)
    return Citizen.InvokeNative(0xFB4891BD7578CDC1, PlayerPedId(), comp)
end

function GetShopPedComponentAtIndex(ped, index, bool, struct1, struct2)
    return Citizen.InvokeNative(0x77BA37622E22023B, ped, index, bool, struct1, struct2)
end

function GetComponentAtIndex(ped, componentIndex, isMultiplayer)
    local dataStruct = DataView.ArrayBuffer(6 * 8)
    local componentHash = GetShopPedComponentAtIndex(ped, componentIndex, isMultiplayer, dataStruct:Buffer(), dataStruct:Buffer(), Citizen.ResultAsInteger())
    return componentHash
end

function GetNumComponentsInPed(ped)
    return Citizen.InvokeNative(0x90403E8107B60E81, ped, Citizen.ResultAsInteger())
end

function GetCategoryOfComponentAtIndex(ped, componentIndex)
    return Citizen.InvokeNative(0x9b90842304c938a7, ped, componentIndex, 0, Citizen.ResultAsInteger())
end

function GetMetaPedAssetGuids(ped, index)
    return Citizen.InvokeNative(0xA9C28516A6DC9D56, ped, index, Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt())
end

function GetMetaPedAssetTint(ped, index)
    return Citizen.InvokeNative(0xE7998FEC53A33BBE, ped, index, Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt())
end

function SetMetaPedTag(ped, drawable, albedo, normal, material, palette, tint0, tint1, tint2)
    Citizen.InvokeNative(0xBC6DF00D7A4A6819, ped, drawable, albedo, normal, material, palette, tint0, tint1, tint2)
end

function SetTextureOutfitTints(ped, category, data)
    Citizen.InvokeNative(0x4EFC1F8FF1AD94DE, ped, joaat(category), data.palette, data.tint0, data.tint1, data.tint2)
end

function RemoveSpecifiedCompByCategory(comp)
    if comp.remove then
        for k, v in ipairs(comp.remove) do
            RemoveTagFromMetaPed(Config.HashList[v])
            UpdatePedVariation()
        end
    end
end

--* remove components when they cant be worn together
function RemoveCompsCantWearTogether(category)
    if category == "Coat" then
        if PlayerClothing.CoatClosed.comp ~= -1 then
            RemoveTagFromMetaPed(Config.HashList.CoatClosed)
            PlayerClothing.CoatClosed.comp = -1
        end
        return
    end

    if category == "Cloak" then
        if PlayerClothing.Poncho.comp ~= -1 then
            RemoveTagFromMetaPed(Config.HashList.Poncho)
            PlayerClothing.Poncho.comp = -1
        end
        return
    end

    if category == "Poncho" then
        if PlayerClothing.Cloak.comp ~= -1 then
            RemoveTagFromMetaPed(Config.HashList.Cloak)
            PlayerClothing.Cloak.comp = -1
        end
        return
    end

    if category == "CoatClosed" then
        if PlayerClothing.Coat.comp ~= -1 then
            RemoveTagFromMetaPed(Config.HashList.Coat)
            PlayerClothing.Coat.comp = -1
        end
        if PlayerClothing.Vest.comp ~= -1 then
            RemoveTagFromMetaPed(Config.HashList.Vest)
            PlayerClothing.Vest.comp = -1
        end
        return
    end

    if category == "Pant" and GetGender() == "Female" and PlayerClothing.Skirt.comp ~= -1 then
        RemoveTagFromMetaPed(Config.HashList.Skirt)
        PlayerClothing.Skirt.comp = -1
        return
    end

    if category == "Skirt" and GetGender() == "Female" and PlayerClothing.Pant.comp ~= -1 then
        RemoveTagFromMetaPed(Config.HashList.Pant)
        PlayerClothing.Pant.comp = -1
    end
end

function GetComponentsWithWearableState(category, isMultiplayer)
    local ped = PlayerPedId()
    local isPedMale = IsPedMale(ped)
    local numComponents = GetNumComponentsInPed(ped)
    if not numComponents or numComponents < 1 then
        return `base`, nil
    end
    for componentIndex = 0, numComponents - 1, 1 do
        local componentHash = GetComponentAtIndex(ped, componentIndex, isMultiplayer)
        local componentCategory = GetCategoryOfComponentAtIndex(ped, componentIndex)
        if componentHash ~= 0 and MetaPedCategoryTags[isPedMale and "maleTags" or "femaleTags"][componentCategory] == category then
            local wearableStates = `base`
            return wearableStates, componentHash
        end
    end

    return `base`, nil
end

function GetComponentIndexByCategory(ped, category)
    ped = ped or PlayerPedId()
    local isPedMale = IsPedMale(ped)

    local numComponents = GetNumComponentsInPed(ped)
    for i = 0, numComponents - 1, 1 do
        local componentCategory = GetCategoryOfComponentAtIndex(ped, i)
        if MetaPedCategoryTags[isPedMale and "maleTags" or "femaleTags"][componentCategory] == category then
            return i
        end
    end
    return nil
end

function GetMetaPedData(category, ped)
    local playerPed = ped or PlayerPedId()
    local componentIndex = GetComponentIndexByCategory(playerPed, category)
    if not componentIndex then
        return nil
    end
    local drawable, albedo, normal, material = GetMetaPedAssetGuids(playerPed, componentIndex)
    local palette, tint0, tint1, tint2 = GetMetaPedAssetTint(playerPed, componentIndex)

    return { drawable = drawable, albedo = albedo, normal = normal, material = material, palette = palette, tint0 = tint0, tint1 = tint1, tint2 = tint2 }
end

function IndexTintCompsToNumber(table)
    local NewComps = {}
    
    for i, v in pairs(table) do
        NewComps[i] = {}
        for k, x in pairs(v) do
            NewComps[i][tonumber(k)] = x
        end
    end

    return NewComps
end

function ConvertTableComps(comps, compTints)
    local NewComps = {}
    for k, v in pairs(comps) do
        NewComps[k] = { comp = v.comp, tint0 = 0, tint1 = 0, tint2 = 0, palette = 0 }
        if compTints and compTints[k] then
            if v.comp ~= -1 and compTints[k][v.comp] then
                local compTint = compTints[k][v.comp]
                NewComps[k].tint0 = compTint.tint0 or 0
                NewComps[k].tint1 = compTint.tint1 or 0
                NewComps[k].tint2 = compTint.tint2 or 0
                NewComps[k].palette = compTint.palette or 0
            end
        end
    end
    return NewComps
end

function SetCachedClothingIndex()
    for i, v in pairs(PlayerClothing) do
        PlayerClothing[i] = { comp = -1 }
    end

    local gender = GetGender() == "Male" and "male" or "female"
    for key, value in pairs(CachedComponents) do
        local Data = Data.clothing[gender][key]
        if Data then
            for indexCategory, info in ipairs(Data) do
                for indexComp, va in ipairs(info) do
                    if value.comp ~= -1 and va.hash then
                        if value.comp == va.hash then
                            PlayerTrackingData[key] = {}
                            PlayerTrackingData[key][value.comp] = { index = indexCategory, color = indexComp, tint0 = value.tint0 or 0, tint1 = value.tint1 or 0, tint2 = value.tint2 or 0, palette = value.palette or 0 }
                            PlayerClothing[key].comp = value.comp
                        end
                    end
                end
            end
        end
    end
end

function GetTrackedData(category)
    if PlayerTrackingData[category] and #PlayerTrackingData[category] then
        for component, value in pairs(PlayerTrackingData[category]) do
            if value.index then
                return value.index, value.color, value.tint0, value.tint1, value.tint2, value.palette
            end
        end
    end

    return nil, nil
end
