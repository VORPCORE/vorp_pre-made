local CuttingPrompt
local active = false
local sleep = true
local tool, hastool, UsePrompt, PropPrompt
local swing = 0
local ChoppedTrees = {}
local nearby_tree

T = Translation.Langs[Lang]

local TreeGroup = GetRandomIntInRange(0, 0xffffff)

function CreateStartChopPrompt()
    Citizen.CreateThread(function()
        local str = T.PromptLabels.cutLabel
        CuttingPrompt = Citizen.InvokeNative(0x04F97DE45A519419)
        PromptSetControlAction(CuttingPrompt, Config.ChopPromptKey)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(CuttingPrompt, str)
        PromptSetEnabled(CuttingPrompt, true)
        PromptSetVisible(CuttingPrompt, true)
        PromptSetHoldMode(CuttingPrompt, true)
        PromptSetGroup(CuttingPrompt, TreeGroup)
        PromptRegisterEnd(CuttingPrompt)
    end)
end

function GetTreeNearby(coords, radius, hash_filter)
    local itemSet = CreateItemset(true)
    local size = Citizen.InvokeNative(0x59B57C4B06531E1E, coords, radius, itemSet, 3, Citizen.ResultAsInteger())
    local found_entity

    if size > 0 then
        for index = 0, size - 1 do
            local entity = GetIndexedItemInItemset(index, itemSet)
            local model_hash = GetEntityModel(entity)

            if hash_filter[model_hash] then
                local tree_coords = GetEntityCoords(entity)
                local tree_x, tree_y, tree_z = table.unpack(tree_coords)

                found_entity = {
                    model_name = hash_filter[model_hash],
                    entity = entity,
                    model_hash = model_hash,
                    vector_coords = tree_coords,
                    x = tree_x,
                    y = tree_y,
                    z = tree_z,
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

function isPlayerReadyToChopTrees(player)
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

function isTreeAlreadyChopped(coords)
    local coords_string = coordsToString(coords)

    local result = ChoppedTrees[coords_string] == true

    return result
end

function rememberTreeAsChopped(coords)
    local coords_string = coordsToString(coords)
    ChoppedTrees[coords_string] = true
end

function forgetTreeAsChopped(coords)
    local coords_string = coordsToString(coords)
    ChoppedTrees[coords_string] = nil
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

function getUnChoppedNearbyTree(allowed_model_hashes, player, player_coords)
    player = player or PlayerPedId()

    if not isPlayerReadyToChopTrees(player) then
        return nil
    end

    player_coords = player_coords or GetEntityCoords(player)

    local found_nearby_tree = GetTreeNearby(player_coords, 1.4, allowed_model_hashes)

    if not found_nearby_tree then
        return nil
    end

    if isTreeAlreadyChopped(found_nearby_tree.vector_coords) then
        return nil
    end

    return found_nearby_tree
end

function showStartChopBtn()
    local ChoppingGroupName = CreateVarString(10, 'LITERAL_STRING', T.PromptLabels.cutDesc)
    PromptSetActiveGroupThisFrame(TreeGroup, ChoppingGroupName)
end

function checkStartChopBtnPressed(tree)
    if PromptHasHoldModeCompleted(CuttingPrompt) then
        active = true
        local player = PlayerPedId()
        SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true, 0, false, false)
        Citizen.Wait(500)
        TriggerServerEvent("vorp_lumberjack:axecheck", tree.vector_coords)
    end
end

function convertConfigTreesToHashRegister()
    local model_hashes = {}

    for _, model_name in pairs(Config.Trees) do
        local model_hash = GetHashKey(model_name)
        model_hashes[model_hash] = model_name
    end

    return model_hashes
end

function doNothingAndWait()
    Citizen.Wait(1000)
end

function waitForStartKey(tree)
    showStartChopBtn()

    checkStartChopBtnPressed(tree)

    Citizen.Wait(0)
end

function GetTown(x, y, z)
    return Citizen.InvokeNative(0x43AD8FC02B429D33, x, y, z, 1)
end

function convertConfigTownRestrictionsToHashRegister()
    local restricted_towns = {}

    for _, town_restriction in pairs(Config.TownRestrictions) do
        if not town_restriction.chop_allowed then
            local town_hash = GetHashKey(town_restriction.name)
            restricted_towns[town_hash] = town_restriction.name
        end
    end

    return restricted_towns
end

function manageStartChopPrompt(restricted_towns, player_coords)
    local is_promp_enabled = true

    if isInRestrictedTown(restricted_towns, player_coords) then
        is_promp_enabled = false
    end
    PromptSetEnabled(CuttingPrompt, is_promp_enabled)
end

Citizen.CreateThread(function()
    local allowed_tree_model_hashes = convertConfigTreesToHashRegister()

    local restricted_towns = convertConfigTownRestrictionsToHashRegister()

    while true do
        if active == false then
            local player = PlayerPedId()
            local player_coords = GetEntityCoords(player)

            nearby_tree = getUnChoppedNearbyTree(allowed_tree_model_hashes, player, player_coords)

            if nearby_tree and not isTreeAlreadyChopped(nearby_tree.vector_coords) then
                manageStartChopPrompt(restricted_towns, player_coords)
            end
        end

        doNothingAndWait()
    end
end)

Citizen.CreateThread(function()
    CreateStartChopPrompt()

    while true do
        if active == false and nearby_tree then
            waitForStartKey(nearby_tree)
        else
            doNothingAndWait()
        end
    end
end)

RegisterNetEvent("vorp_lumberjack:axechecked")
AddEventHandler("vorp_lumberjack:axechecked", function(tree)
    goChop(tree)
end)

RegisterNetEvent("vorp_lumberjack:noaxe")
AddEventHandler("vorp_lumberjack:noaxe", function()
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

function removeCuttingPrompt()
    if CuttingPrompt then
        PromptSetEnabled(CuttingPrompt, false)
        PromptSetVisible(CuttingPrompt, false)
    end
end

function treeFinished(tree)
    swing = 0

    rememberTreeAsChopped(tree)
    Wait(2000)
    removeToolFromPlayer()

    active = false

    Citizen.CreateThread(function()
        Citizen.Wait(900000)
        forgetTreeAsChopped(tree)
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

function goChop(tree)
    EquipTool('p_axe02x', 'Swing')
    local swingcount = math.random(Config.MinSwing, Config.MaxSwing)
    while hastool == true do
        FreezeEntityPosition(PlayerPedId(), true)
        if IsControlJustReleased(0, Config.CancelChopKey) or IsPedDeadOrDying(PlayerPedId()) then
            treeFinished(tree)
        elseif IsControlJustPressed(0, Config.ChopTreeKey) then
            local randomizer = math.random(Config.maxDifficulty, Config.minDifficulty)
            PromptSetEnabled(UsePrompt, false)
            swing = swing + 1
            Anim(ped, "amb_work@world_human_tree_chop_new@working@pre_swing@male_a@trans", "pre_swing_trans_after_swing",
                -1, 0)
            local testplayer = exports["syn_minigame"]:taskBar(randomizer, 7)
            if testplayer == 100 then
                TriggerServerEvent('vorp_lumberjack:addItem')
            else
                local lumberjack_fail_txt_index = math.random(1, #T)
                local lumberjack_fail_txt = T[lumberjack_fail_txt_index]
                TriggerEvent("vorp:TipRight", lumberjack_fail_txt, 3000)
            end
            Wait(500)
            PromptSetEnabled(UsePrompt, true)
        end

        if swing == swingcount then
            PromptSetEnabled(UsePrompt, false)
            treeFinished(tree)
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
    LMPrompt(prompttext, Config.ChopTreeKey, holdtowork)
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
        local str = T.PromptLabels.keepHatchet
        local buttonhash = button or Config.CancelChopKey
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
        local str = T.PromptLabels.useHatchet
        local buttonhash = button or Config.ChopTreeKey
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
    removeCuttingPrompt()
end)
