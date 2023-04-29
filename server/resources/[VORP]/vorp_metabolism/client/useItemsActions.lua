RegisterNetEvent('vorpmetabolism:useItem', function(index, label)
    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)

    if (Config["ItemsToUse"][index]["Thirst"] ~= 0) then
        local newThirst = PlayerStatus["Thirst"] + Config["ItemsToUse"][index]["Thirst"]

        if (newThirst > 1000) then
            newThirst = 1000
        end

        if (newThirst < 0) then
            newThirst = 0
        end
        PlayerStatus["Thirst"] = newThirst
    end
    if (Config["ItemsToUse"][index]["Hunger"] ~= 0) then
        local newHunger = PlayerStatus["Hunger"] + Config["ItemsToUse"][index]["Hunger"]

        if (newHunger > 1000) then
            newHunger = 1000
        end

        if (newHunger < 0) then
            newHunger = 0
        end

        PlayerStatus["Hunger"] = newHunger
    end
    if (Config["ItemsToUse"][index]["Metabolism"] ~= 0) then
        local newMetabolism = PlayerStatus["Metabolism"] + Config["ItemsToUse"][index]["Metabolism"]

        if (newMetabolism > 10000) then
            newMetabolism = 10000
        end

        if (newMetabolism < -10000) then
            newMetabolism = -10000
        end

        PlayerStatus["Metabolism"] = newMetabolism
    end
    if (Config["ItemsToUse"][index]["Stamina"] ~= 0) then
        local stamina = GetAttributeCoreValue(PlayerPedId(), 1)
        local newStamina = stamina + Config["ItemsToUse"][index]["Stamina"]

        if (newStamina > 100) then
            newStamina = 100
        end

        Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 1, newStamina) -- SetAttributeCoreValue native
    end
    if (Config["ItemsToUse"][index]["InnerCoreHealth"] ~= 0) then
        local health = GetAttributeCoreValue(PlayerPedId(), 0)
        local newhealth = health + Config["ItemsToUse"][index]["InnerCoreHealth"]

        if (newhealth > 100) then
            newhealth = 100
        end

        Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 0, newhealth) -- SetAttributeCoreValue native
    end
    if (Config["ItemsToUse"][index]["OuterCoreHealth"] ~= 0) then
        local health = GetEntityHealth(PlayerPedId(), 0)
        local newhealth = health + Config["ItemsToUse"][index]["OuterCoreHealth"]

        if (newhealth > 150) then
            newhealth = 150
        end
        SetEntityHealth(PlayerPedId(), newhealth, 0)
    end
    -- Golds
    if (Config["ItemsToUse"][index]["OuterCoreHealthGold"] ~= 0.0) then
        EnableAttributeOverpower(PlayerPedId(), 0, Config["ItemsToUse"][index]["OuterCoreHealthGold"], true)
    end
    if (Config["ItemsToUse"][index]["InnerCoreHealthGold"] ~= 0.0) then
        EnableAttributeOverpower(PlayerPedId(), 0, Config["ItemsToUse"][index]["InnerCoreHealthGold"], true)
    end

    if (Config["ItemsToUse"][index]["OuterCoreStaminaGold"] ~= 0.0) then
        EnableAttributeOverpower(PlayerPedId(), 1, Config["ItemsToUse"][index]["OuterCoreStaminaGold"], true)
    end
    if (Config["ItemsToUse"][index]["InnerCoreStaminaGold"] ~= 0.0) then
        EnableAttributeOverpower(PlayerPedId(), 1, Config["ItemsToUse"][index]["InnerCoreStaminaGold"], true)
    end

    if (Config["ItemsToUse"][index]["Animation"]) == 'eat' then
        PlayAnimEat(Config["ItemsToUse"][index]["PropName"])
    else
        PlayAnimDrink(Config["ItemsToUse"][index]["PropName"])
    end

    if (Config["ItemsToUse"][index]["Effect"] ~= "") then
        ScreenEffect(Config["ItemsToUse"][index]["Effect"], Config["ItemsToUse"][index]["EffectDuration"])
    end
        
    TriggerEvent("vorp:Tip", string.format(Translation["OnUseItem"], label), 3000)
end)

function ScreenEffect(effect, time)
    AnimpostfxPlay(effect)
    Citizen.Wait(time)
    AnimpostfxStop(effect)
end

function PlayAnimDrink(propName)
    local playerCoords = GetEntityCoords(PlayerPedId(), true, true)
    local dict = "amb_rest_drunk@world_human_drinking@male_a@idle_a"
    local anim = "idle_a"

    if (not IsPedMale(PlayerPedId())) then
        dict = "amb_rest_drunk@world_human_drinking@female_a@idle_b"
        anim = "idle_b"
    end

    RequestAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        Wait(100)
    end

    local hashItem = GetHashKey(propName)

    local prop = CreateObject(hashItem, playerCoords.x, playerCoords.y, playerCoords.z + 0.2, true, true, false, false, true)
    local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_R_Finger12")

    Wait(1000)

    TaskPlayAnim(PlayerPedId(), dict, anim, 1.0, 8.0, 5000, 31, 0.0, false, false, false)
    AttachEntityToEntity(prop, PlayerPedId(), boneIndex, 0.02, 0.028, 0.001, 15.0, 175.0, 0.0, true, true, false, true, 1, true)
    Wait(6000)

    DeleteObject(prop)
    ClearPedSecondaryTask(PlayerPedId())
end

function PlayAnimEat(propName)
    local playerCoords = GetEntityCoords(PlayerPedId(), true, true)
    local dict = "mech_inventory@clothing@bandana"
    local anim = "NECK_2_FACE_RH"

    --if (!IsPedMale(PlayerPedId())) then
    --    dict = "amb_rest_drunk@world_human_drinking@female_a@idle_b"
    --    anim = "idle_b"
    --end

    RequestAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        Wait(100)
    end

    local hashItem = GetHashKey(propName)

    local prop = CreateObject(hashItem, playerCoords.x, playerCoords.y, playerCoords.z + 0.2, true, true, false, false, true)
    local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_R_Finger12")

    Wait(1000)

    TaskPlayAnim(PlayerPedId(), dict, anim, 1.0, 8.0, 5000, 31, 0.0, false, false, false)
    AttachEntityToEntity(prop, PlayerPedId(), boneIndex, 0.02, 0.028, 0.001, 15.0, 175.0, 0.0, true, true, false, true, 1, true)
    Wait(6000)

    DeleteObject(prop)
    ClearPedSecondaryTask(PlayerPedId())
end
