---@diagnostic disable: undefined-global
T = TranslationInv.Langs[Lang]
Core = exports.vorp_core:GetCore()


RegisterNetEvent('syn:getnuistuff')
AddEventHandler('syn:getnuistuff', function(x, y, mon, gol, rol)
    local nuistuff = x
    local player = PlayerPedId()
    SendNUIMessage({
        action = "changecheck",
        check = nuistuff,
        info = y,
    })
    SendNUIMessage({
        action = "updateStatusHud",
        show   = not IsRadarHidden(),
        money  = mon,
        gold   = gol,
        rol  = rol,
        id     = GetPlayerServerId(NetworkGetEntityOwner(player)),
    })
end)

if Config.DevMode then
    AddEventHandler('onClientResourceStart', function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        print('loading resource ^1DEV MODE IS ENABLED')
        SetNuiFocus(false, false)
        SendNUIMessage({ action = "hide" })
        TriggerServerEvent("DEV:loadweapons")
        print("Loading Inventory")
        TriggerServerEvent("vorpinventory:getItemsTable")
        Wait(1000)
        TriggerServerEvent("vorpinventory:getInventory")
        Wait(2000)
        TriggerServerEvent("vorpCore:LoadAllAmmo")
        print("inventory loaded")
        Wait(100)
        TriggerEvent("vorpinventory:loaded")
        InvLoaded = true
    end)
end

-- DISABLE INVENTORY OPENING KEY
Citizen.CreateThread(function()
    repeat
        Wait(0)
        if not InvLoaded then
            DisableControlAction(0, 0xC1989F95, true)
        else
            DisableControlAction(0, 0xC1989F95, false)
            return
        end
    until false
end)
