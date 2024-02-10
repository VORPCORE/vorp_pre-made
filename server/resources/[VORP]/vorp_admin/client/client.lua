local Key = Config.Key
local CanOpen = Config.CanOpenMenuWhenDead
local Inmenu
local spectating = false
local lastcoords = nil
local T = Translation.Langs[Config.Lang]

MenuData = exports.vorp_menu:GetMenuData()
VORP = exports.vorp_core:GetCore()


AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end
    local player = PlayerPedId()
    ClearPedTasksImmediately(player, true, true) -- clear tasks
    Closem()                                     --close menu
    AdminAllowed = false
end)

AddEventHandler("onClientResourceStart", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end
    --FOR TESTS ENABLED THIS
    if not Config.DevMode then
        return
    end
    AdminAllowed = false
    local player = GetPlayerServerId(tonumber(PlayerId()))
    Wait(100)
    TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.OpenMenu")
    TriggerServerEvent("vorp_admin:getStaffInfo", player)
end)

RegisterNetEvent('vorp:SelectedCharacter', function()
    AdminAllowed = false
    local player = GetPlayerServerId(tonumber(PlayerId()))
    Wait(100)
    TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.OpenMenu")
    TriggerServerEvent("vorp_admin:getStaffInfo", player)
end)

local function CanOpenUsersMenu()
    if Config.UseUsersMenu then
        TriggerServerEvent("vorp_admin:GetGroup") -- check permission
        OpenUsersMenu()
    end
end

local function OpenAdminMenu()
    TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.OpenMenu")
    Wait(100)
    if AdminAllowed then
        OpenMenu()
        return true
    end
    return false
end


if Config.useAdminCommand then
    TriggerEvent('chat:addSuggestion', '/' .. Config.commandAdmin, 'Open admin menu or use pagedown', {
        {}
    })

    RegisterCommand(Config.commandAdmin, function()
        TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.OpenMenu")
        Wait(200)
        if AdminAllowed then
            OpenMenu()
            return true
        end
    end, false)
end

--OPEN MENU
CreateThread(function()
    while true do
        local player = PlayerPedId()
        local isDead = IsPedDeadOrDying(player, false)
        if CanOpen then
            if IsControlJustPressed(0, Key) and not Inmenu then
                if not OpenAdminMenu() then
                    CanOpenUsersMenu()
                end
            end
        else
            if IsControlJustPressed(0, Key) and not isDead and not Inmenu then
                if not OpenAdminMenu() then
                    CanOpenUsersMenu()
                end
            end
        end
        Wait(0)
    end
end)

RegisterNetEvent("vorp_admin:OpenStaffMenu", function(perm)
    AdminAllowed = perm
end)

----- EVENTS
RegisterNetEvent("vorp_admin:Freezeplayer")
AddEventHandler("vorp_admin:Freezeplayer", function(state)
    FreezeEntityPosition(PlayerPedId(), state)
end)

RegisterNetEvent("vorp_admin:respawn", function(target)
    Wait(50)
    DoScreenFadeOut(1000)
    repeat Wait(0) until not IsScreenFadingOut()
    FreezeEntityPosition(PlayerPedId(), true)
    Wait(1000)
    DoScreenFadeIn(4000)
    repeat Wait(0) until not IsScreenFadingIn()
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerEvent('vorp:ShowBottomRight', T.Notify.reviseRules, 10000)
end)


RegisterNetEvent("vorp_admin:spectatePlayer", function(target, targetCoords)
    local admin = PlayerPedId()
    local ped = 0
    if not spectating then
        DoScreenFadeOut(2000)
        repeat Wait(0) until not IsScreenFadingOut()
        lastcoords = GetEntityCoords(admin)
        SetEntityVisible(admin, false)
        SetEntityCanBeDamaged(admin, false)
        SetEntityInvincible(admin, true)
        SetEntityCoords(admin, targetCoords.x + 15, targetCoords.y + 15, targetCoords.z, false, false, false, false)
        Wait(500)
        ped = GetPlayersClient(target)
        Wait(500)
        Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        AttachCamToEntity(Camera, ped, 0.0, -2.0, 1.0, false)
        SetCamActive(Camera, true)
        RenderScriptCams(true, true, 1, true, true, 0)
        DoScreenFadeIn(2000)
        repeat Wait(0) until IsScreenFadingIn()
        spectating = true
    else
        DoScreenFadeOut(2000)
        repeat Wait(0) until not IsScreenFadingOut()
        RenderScriptCams(true, false, 1, true, true, 0)
        DestroyCam(Camera, true)
        DestroyAllCams(true)
        SetEntityCoords(admin, lastcoords.x, lastcoords.y, lastcoords.z - 1, false, false, false, false)
        SetEntityVisible(admin, true)
        SetEntityCanBeDamaged(admin, false)
        SetEntityInvincible(admin, true)
        DoScreenFadeIn(2000)
        repeat Wait(0) until IsScreenFadingIn()
        spectating = false
    end
end)

------------------------- TELEPORT  EVENTS FROM SERVER  -------------------------------
RegisterNetEvent("vorp_admin:gotoPlayer", function(targetCoords)
    lastLocation = GetEntityCoords(PlayerPedId())
    SetEntityCoords(PlayerPedId(), targetCoords.x, targetCoords.y, targetCoords.z, false, false, false, false)
end)

RegisterNetEvent("vorp_admin:sendAdminBack", function()
    if lastLocation then
        SetEntityCoords(PlayerPedId(), lastLocation.x, lastLocation.y, lastLocation.z, false, false, false, false)
        lastLocation = nil
    end
end)

RegisterNetEvent("vorp_admin:Bring", function(adminCoords)
    lastLocation = GetEntityCoords(PlayerPedId())
    SetEntityCoords(PlayerPedId(), adminCoords.x, adminCoords.y, adminCoords.z, false, false, false, false)
end)

RegisterNetEvent("vorp_admin:TeleportPlayerBack", function()
    if lastLocation then
        SetEntityCoords(PlayerPedId(), lastLocation.x, lastLocation.y, lastLocation.z, false, false, false, false)
        lastLocation = nil
    end
end)
-----------------------------------------------------------------------------

-- show items inventory
RegisterNetEvent("vorp_admin:getplayerInventory", function(inventorydata)
    OpenInvnetory(inventorydata)
end)

--------------------------Troll Actions Events------------------------------
RegisterNetEvent('vorp_admin:ClientTrollKillPlayerHandler', function()
    SetEntityHealth(PlayerPedId(), 0, 0)
end)

RegisterNetEvent('vorp_admin:ClientTrollInvisbleHandler', function()
    local player = PlayerPedId()
    if IsEntityVisible(player) then
        SetEntityVisible(player, false)
    else
        SetEntityVisible(player, true)
    end
end)

RegisterNetEvent('vorp_admin:ClientTrollLightningStrikePlayerHandler', function(coords)
    ForceLightningFlashAtCoords(coords.x, coords.y, coords.z, -1.0)
end)

RegisterNetEvent('vorp_admin:ClientTrollSetPlayerOnFireHandler', function()
    local model = 'p_campfire02xb'
    if not HasModelLoaded(model) then
        RequestModel(model, false)
        repeat Wait(0) until HasModelLoaded(model)
    end
    local object = CreateObject(joaat(model), 0, 0, 0, false, false, false)
    repeat Wait(0) until DoesEntityExist(object)
    AttachEntityToEntity(object, PlayerPedId(), 41, 1000, 1000, 10000, 0, 0, 0, false, false, true, false, 1000, false,
        false, false)
    Wait(5000)
    DeleteObject(object)
end)

RegisterNetEvent('vorp_admin:ClientTrollTPToHeavenHandler', function()
    local pl = GetEntityCoords(PlayerPedId())
    SetEntityCoords(PlayerPedId(), pl.x, pl.y, pl.z + 200, false, false, false, false)
end)

RegisterNetEvent('vorp_admin:ClientTrollRagdollPlayerHandler', function()
    SetPedToRagdoll(PlayerPedId(), 5000, 5000, 0, false, false, false)
end)

RegisterNetEvent('vorp_admin:ClientDrainPlayerStamHandler', function()
    Citizen.InvokeNative(0xC3D4B754C0E86B9E, PlayerPedId(), -1000.0)
end)

RegisterNetEvent('vorp_admin:ClientHandcuffPlayerHandler', function()
    local player = PlayerPedId()
    if not IsPedCuffed(player) then
        SetEnableHandcuffs(player, true, false)
    else
        SetEnableHandcuffs(player, false, false)
    end
end)

RegisterNetEvent('vorp_admin:ClientTempHighPlayerHandler', function()
    AnimpostfxPlay('MP_BountyLagrasSwamp')
    Wait(15000)
    AnimpostfxStop('MP_BountyLagrasSwamp')
end)
