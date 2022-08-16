------------------------------------------------------------------------------------
------------------------------- CLIENT ---------------------------------------------
local Key = Config.Key
local CanOpen = Config.CanOpenMenuWhenDead
local Inmenu
local spectating = false
local lastcoords




-- get menu
TriggerEvent("menuapi:getData", function(call)
    MenuData = call
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        local player = PlayerPedId()
        ClearPedTasksImmediately(player, true, true) -- clear tasks
        Closem() --close menu
        AdminAllowed = false
    end
end)


RegisterNetEvent('vorp:SelectedCharacter', function()
    AdminAllowed = false
    local player = GetPlayerServerId(tonumber(PlayerId()))
    Wait(100)
    TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.OpenMenu")
    TriggerServerEvent("vorp_admin:getStaffInfo", player)
end)



Citizen.CreateThread(function()
    while true do
        local player = PlayerPedId()
        local isDead = IsPedDeadOrDying(player)
        if CanOpen then
            if IsControlJustPressed(0, Key) and not Inmenu then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.OpenMenu")
                Wait(100)
                if AdminAllowed then
                    MenuData.CloseAll()
                    OpenMenu()
                else
                    MenuData.CloseAll()
                    OpenUsersMenu()
                end
            end
        else
            if IsControlJustPressed(0, Key) and not isDead and not Inmenu then
                TriggerServerEvent("vorp_admin:opneStaffMenu", "vorp.staff.OpenMenu")
                Wait(100)
                if AdminAllowed then
                    MenuData.CloseAll()
                    OpenMenu()
                else
                    MenuData.CloseAll()
                    OpenUsersMenu()
                end
                TriggerServerEvent("vorp_admin:GetGroup") -- check permission
            end
        end
        Citizen.Wait(10)
    end
end)

-- perms
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
    FreezeEntityPosition(PlayerPedId(), true)
    Wait(1000)
    DoScreenFadeIn(4000)
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerEvent('vorp:ShowBottomRight', "Please revise our rules!", 10000)
end)


RegisterNetEvent("vorp_sdmin:spectatePlayer")
AddEventHandler("vorp_sdmin:spectatePlayer", function(target, targetCoords)
    local admin = PlayerPedId()
    local ped = 0
    if not spectating then
        DoScreenFadeOut(2000)
        lastcoords = GetEntityCoords(admin)
        SetEntityVisible(admin, false)
        SetEntityCanBeDamaged(admin, false)
        SetEntityInvincible(admin, true)
        SetEntityCoords(admin, targetCoords.x + 15, targetCoords.y + 15, targetCoords.z)
        Wait(500)
        ped = GetPlayersClient(target)
        Wait(500)
        Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        AttachCamToEntity(Camera, ped, 0.0, -2.0, 1.0, false)
        SetCamActive(Camera, true)
        RenderScriptCams(true, true, 1, true, true)
        DoScreenFadeIn(2000)
        spectating = true
    else
        DoScreenFadeOut(2000)
        RenderScriptCams(true, false, 1, true, true)
        DestroyCam(Camera, true)
        DestroyAllCams()
        SetEntityCoords(admin, lastcoords.x, lastcoords.y, lastcoords.z - 1)
        SetEntityVisible(admin, true)
        SetEntityCanBeDamaged(admin, false)
        SetEntityInvincible(admin, true)
        DoScreenFadeIn(2000)
        spectating = false
    end
end)

------------------------- TELEPORT  EVENTS FROM SERVER  -------------------------------
RegisterNetEvent("vorp_admin:gotoPlayer", function(targetCoords)

    lastLocation = GetEntityCoords(PlayerPedId())
    SetEntityCoords(PlayerPedId(), targetCoords)
end)

RegisterNetEvent("vorp_admin:sendAdminBack", function()
    if lastLocation then
        SetEntityCoords(PlayerPedId(), lastLocation, 0, 0, 0, false)
        lastLocation = nil
    end
end)

RegisterNetEvent("vorp_admin:Bring", function(adminCoords)
    lastLocation = GetEntityCoords(PlayerPedId())
    SetEntityCoords(PlayerPedId(), adminCoords, false, false, false, false)
end)

RegisterNetEvent("vorp_admin:TeleportPlayerBack", function()
    if lastLocation then
        SetEntityCoords(PlayerPedId(), lastLocation, 0, 0, 0, false)
        lastLocation = nil
    end
end)
-----------------------------------------------------------------------------

-- show items inventory
RegisterNetEvent("vorp_admin:getplayerInventory", function(inventorydata)
    OpenInvnetory(inventorydata)
end)
