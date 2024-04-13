local MinePrompt
local active = false
local sleep = true
local tool, hastool, UsePrompt, PropPrompt
local swing = 0
local MinedRocks = {}
local nearby_rocks

local rockGroup = GetRandomIntInRange(0, 0xffffff)

T = Translation.Langs[Lang]

function CreateStartMinePrompt()
    Citizen.CreateThread(function()
        local str = T.PromptLabels.mineLabel
        MinePrompt = Citizen.InvokeNative(0x04F97DE45A519419)
        PromptSetControlAction(MinePrompt, Config.MinePromptKey)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(MinePrompt, str)
        PromptSetEnabled(MinePrompt, true)
        PromptSetVisible(MinePrompt, true)
        PromptSetHoldMode(MinePrompt, true)
        PromptSetGroup(MinePrompt, rockGroup)
        PromptRegisterEnd(MinePrompt)
    end)
end

function GetRockNearby(coords, radius, hash_filter)
    local itemSet = CreateItemset(true)
    local size = Citizen.InvokeNative(0x59B57C4B06531E1E, coords, radius, itemSet, 3, Citizen.ResultAsInteger())
    local found_entity

    if size > 0 then
        for index = 0, size - 1 do
            local entity = GetIndexedItemInItemset(index, itemSet)
            local model_hash = GetEntityModel(entity)

            if hash_filter[model_hash] then
                local rock_coords = GetEntityCoords(entity)
                local rock_x, rock_y, rock_z = table.unpack(rock_coords)

                found_entity = {
                    model_name = hash_filter[model_hash],
                    entity = entity,
                    model_hash = model_hash,
                    vector_coords = rock_coords,
                    x = rock_x,
                    y = rock_y,
                    z = rock_z,
                }

                break
            end
        end
    end

    if IsItemsetValid(itemSet) then
        DestroyItemset(itemSet)
    end

    return found_entity
end

function isPlayerReadyToMineRocks(player)
    if IsPedOnMount(player) then
        return false
    end

    if IsPedInAnyVehicle(player) then
        return false
    end

    if IsPedDeadOrDying(player) then
        return false
    end

    if IsEntityInWater(player) then
        return false
    end

    if IsPedClimbing(player) then
        return false
    end

    if not IsPedOnFoot(player) then
        return false
    end

    return true
end

function coordsToString(coords)
    return round(coords[1], 1) .. '-' .. round(coords[2], 1) .. '-' .. round(coords[3], 1)
end

function isRockAlreadyMined(coords)
    local coords_string = coordsToString(coords)
    local result = MinedRocks[coords_string] == true
    return result
end

function rememberRockAsMined(coords)
    local coords_string = coordsToString(coords)
    MinedRocks[coords_string] = true
end

function forgetRockAsMined(coords)
    local coords_string = coordsToString(coords)
    MinedRocks[coords_string] = nil
end

function isInRestrictedTown(restricted_towns, player_coords)
    player_coords = player_coords or GetEntityCoords(PlayerPedId())

    local x, y, z = table.unpack(player_coords)
    local town_hash = GetTown(x, y, z)

    if town_hash == false then
        return false
    end

    if restricted_towns[town_hash] then
        return true
    end

    return false
end

function getUnMinedNearbyRock(allowed_model_hashes, player, player_coords)
    player = player or PlayerPedId()

    if not isPlayerReadyToMineRocks(player) then
        return nil
    end

    player_coords = player_coords or GetEntityCoords(player)

    local found_nearby_rocks = GetRockNearby(player_coords, 1.3, allowed_model_hashes)

    if not found_nearby_rocks then
        return nil
    end

    if isRockAlreadyMined(found_nearby_rocks.vector_coords) then
        return nil
    end

    return found_nearby_rocks
end

function showStartMineBtn()
    local MiningGroupName = CreateVarString(10, 'LITERAL_STRING', T.PromptLabels.mineDesc)
    PromptSetActiveGroupThisFrame(rockGroup, MiningGroupName)
end

function checkStartMineBtnPressed(rock)
    if PromptHasHoldModeCompleted(MinePrompt) then
        active = true
        local player = PlayerPedId()
        SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true, 0, false, false)
        Citizen.Wait(500)
        TriggerServerEvent("vorp_mining:pickaxecheck", rock.vector_coords)
    end
end

function convertConfigRocksToHashRegister()
    local model_hashes = {}

    for _, model_name in pairs(Config.Rocks) do
        local model_hash = GetHashKey(model_name)
        model_hashes[model_hash] = model_name
    end

    return model_hashes
end

function doNothingAndWait()
    Citizen.Wait(500)
end

function waitForStartKey(rock)
    showStartMineBtn()

    checkStartMineBtnPressed(rock)

    Citizen.Wait(0)
end

function GetTown(x, y, z)
    return Citizen.InvokeNative(0x43AD8FC02B429D33, x, y, z, 1)
end

function convertConfigTownRestrictionsToHashRegister()
    local restricted_towns = {}

    for _, town_restriction in pairs(Config.TownRestrictions) do
        if not town_restriction.mine_allowed then
            local town_hash = GetHashKey(town_restriction.name)
            restricted_towns[town_hash] = town_restriction.name
        end
    end

    return restricted_towns
end

function manageStartMinePrompt(restricted_towns, player_coords)
    local is_promp_enabled = true

    if isInRestrictedTown(restricted_towns, player_coords) then
        is_promp_enabled = false
    end
    PromptSetEnabled(MinePrompt, is_promp_enabled)
end

Citizen.CreateThread(function()
    local allowed_rock_model_hashes = convertConfigRocksToHashRegister()

    local restricted_towns = convertConfigTownRestrictionsToHashRegister()

    while true do
        if active == false then
            local player = PlayerPedId()
            local player_coords = GetEntityCoords(player)

            nearby_rocks = getUnMinedNearbyRock(allowed_rock_model_hashes, player, player_coords)

            if nearby_rocks and not isRockAlreadyMined(nearby_rocks.vector_coords) then
                manageStartMinePrompt(restricted_towns, player_coords)
            end
        end

        doNothingAndWait()
    end
end)

Citizen.CreateThread(function()
    CreateStartMinePrompt()

    while true do
        if active == false and nearby_rocks then
            waitForStartKey(nearby_rocks)
        else
            doNothingAndWait()
        end
    end
end)

RegisterNetEvent("vorp_mining:pickaxechecked")
AddEventHandler("vorp_mining:pickaxechecked", function(rock)
    goMine(rock)
end)

RegisterNetEvent("vorp_mining:nopickaxe")
AddEventHandler("vorp_mining:nopickaxe", function()
    active = false
end)

function releasePlayer()
    if PropPrompt then
        PromptSetEnabled(PropPrompt, false)
        PromptSetVisible(PropPrompt, false)
    end

    if UsePrompt then
        PromptSetEnabled(UsePrompt, false)
        PromptSetVisible(UsePrompt, false)
    end

    FreezeEntityPosition(PlayerPedId(), false)
end

function removeMiningPrompt()
    if MinePrompt then
        PromptSetEnabled(MinePrompt, false)
        PromptSetVisible(MinePrompt, false)
    end
end

function rockFinished(rock)
    swing = 0

    rememberRockAsMined(rock)
    Wait(2300)
    removeToolFromPlayer()

    active = false

    Citizen.CreateThread(function()
        Citizen.Wait(1800000)
        forgetRockAsMined(rock)
    end)
end

function removeToolFromPlayer()
    hastool = false

    if not tool then
        return
    end

    Citizen.InvokeNative(0xED00D72F81CF7278, tool, 1, 1)
    DeleteObject(tool)
    Citizen.InvokeNative(0x58F7DB5BD8FA2288, PlayerPedId()) -- Cancel Walk Style

    tool = nil
end

function goMine(rock)
    EquipTool('p_pickaxe01x', 'Swing')
    local swingcount = math.random(Config.MinSwing, Config.MaxSwing)
    while hastool == true do
        FreezeEntityPosition(PlayerPedId(), true)
        if IsControlJustReleased(0, Config.StopMiningKey) or IsPedDeadOrDying(PlayerPedId()) then
            rockFinished(rock)
        elseif IsControlJustPressed(0, Config.MineRockKey) then
            PromptSetEnabled(UsePrompt, false)
            local randomizer = math.random(Config.maxDifficulty, Config.minDifficulty)
            swing = swing + 1
            Anim(ped, 'amb_work@world_human_pickaxe_new@working@male_a@trans', 'pre_swing_trans_after_swing', -1, 0)
            local testplayer = exports["syn_minigame"]:taskBar(randomizer, 7)
            if testplayer == 100 then
                TriggerServerEvent('vorp_mining:addItem')
            else
                local minning_fail_txt_index = math.random(1, #T)
                local minning_fail_txt = T[minning_fail_txt_index]
                TriggerEvent("vorp:TipRight", minning_fail_txt, 3000)
            end
            Wait(500)
            PromptSetEnabled(UsePrompt, true)
        end

        if swing == swingcount then
            PromptSetEnabled(UsePrompt, false)
            rockFinished(rock)
        end
        Wait(5)
    end
    releasePlayer()
    active = false
end

function EquipTool(toolhash, prompttext, holdtowork)
    hastool = false
    Citizen.InvokeNative(0x6A2F820452017EA2) -- Clear Prompts from Screen
    if tool then
        DeleteEntity(tool)
    end
    Wait(500)
    FPrompt()
    LMPrompt(prompttext, Config.MineRockKey, holdtowork)
    ped = PlayerPedId()
    tool = CreateObject(toolhash, GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 0.0), true, true, true)
    AttachEntityToEntity(tool, ped, GetPedBoneIndex(ped, 7966), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1, 0, 0);
    Citizen.InvokeNative(0x923583741DC87BCE, ped, 'arthur_healthy')
    Citizen.InvokeNative(0x89F5E7ADECCCB49C, ped, "carry_pitchfork")
    Citizen.InvokeNative(0x2208438012482A1A, ped, true, true)
    ForceEntityAiAndAnimationUpdate(tool, 1)
    Citizen.InvokeNative(0x3A50753042B6891B, ped, "PITCH_FORKS")

    Wait(500)
    PromptSetEnabled(PropPrompt, true)
    PromptSetVisible(PropPrompt, true)
    PromptSetEnabled(UsePrompt, true)
    PromptSetVisible(UsePrompt, true)

    hastool = true
end

function FPrompt(text, button, hold)
    Citizen.CreateThread(function()
        proppromptdisplayed = false
        PropPrompt = nil
        local str = T.PromptLabels.keepPickaxe
        local buttonhash = button or Config.StopMiningKey
        local holdbutton = hold or false
        PropPrompt = PromptRegisterBegin()
        PromptSetControlAction(PropPrompt, buttonhash)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(PropPrompt, str)
        PromptSetEnabled(PropPrompt, false)
        PromptSetVisible(PropPrompt, false)
        PromptSetHoldMode(PropPrompt, holdbutton)
        PromptRegisterEnd(PropPrompt)
        sleep = true
    end)
end

function LMPrompt(text, button, hold)
    Citizen.CreateThread(function()
        UsePrompt = nil
        local str = T.PromptLabels.usePickaxe
        local buttonhash = button or Config.MineRockKey
        local holdbutton = hold or false
        UsePrompt = PromptRegisterBegin()
        PromptSetControlAction(UsePrompt, buttonhash)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(UsePrompt, str)
        PromptSetEnabled(UsePrompt, false)
        PromptSetVisible(UsePrompt, false)
        if hold then
            PromptSetHoldIndefinitelyMode(UsePrompt)
        end
        PromptRegisterEnd(UsePrompt)
    end)
end

function Anim(actor, dict, body, duration, flags, introtiming, exittiming)
    Citizen.CreateThread(function()
        RequestAnimDict(dict)
        local dur = duration or -1
        local flag = flags or 1
        local intro = tonumber(introtiming) or 1.0
        local exit = tonumber(exittiming) or 1.0
        timeout = 5
        while (not HasAnimDictLoaded(dict) and timeout > 0) do
            timeout = timeout - 1
            if timeout == 0 then
                print("Animation Failed to Load")
            end
            Citizen.Wait(300)
        end
        TaskPlayAnim(actor, dict, body, intro, exit, dur, flag --[[1 for repeat--]], 1, false, false, false, 0, true)
    end)
end

function GetArrayKey(array, value)
    for k, v in pairs(array) do
        if v == value then
            return k
        end
    end
    return false
end

function InArray(array, item)
    for k, v in pairs(array) do
        if v == item then
            return true
        end
    end
    return false
end

function round(num, decimals)
    if type(num) ~= "number" then
        return num
    end

    local multiplier = 10 ^ (decimals or 0)
    return math.floor(num * multiplier + 0.5) / multiplier
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    removeToolFromPlayer()
    releasePlayer()
    removeMiningPrompt()
end)
