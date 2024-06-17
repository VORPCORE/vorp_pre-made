local playerammoinfo   = {}
local updatedAmmoCache = {}
local Core             = exports.vorp_core:GetCore()

local function addAmmoToPed(ammoData)
    for ammoType, ammo in pairs(ammoData) do
        SetPedAmmoByType(PlayerPedId(), joaat(ammoType), ammo)
    end
end

local function contains(arr, element)
    for key, v in pairs(arr) do
        if key == element then
            return true
        end
    end
    return false
end


RegisterNetEvent("vorpinventory:recammo", function(ammoData)
    playerammoinfo.ammo = ammoData.ammo
end)

RegisterNetEvent("vorpinventory:loaded", function()
    SendNUIMessage({
        action = "reclabels",
        labels = SharedData.AmmoLabels
    })

    local result = Core.Callback.TriggerAwait("vorpinventory:getammoinfo")
    if not result then
        return
    end
    playerammoinfo = result or {}
    addAmmoToPed(playerammoinfo.ammo)
    SendNUIMessage({
        action = "updateammo",
        ammo   = playerammoinfo.ammo
    })
end)

RegisterNetEvent("vorpinventory:updateuiammocount", function(ammo)
    SendNUIMessage({
        action = "updateammo",
        ammo   = ammo
    })
    NUIService.LoadInv()
end)

RegisterNetEvent("vorpinventory:setammotoped", function(ammoData)
    local PlayerPedId = PlayerPedId()
    RemoveAllPedWeapons(PlayerPedId, true, true)
    RemoveAllPedAmmo(PlayerPedId)
    addAmmoToPed(ammoData)
end)

RegisterNetEvent("vorpinventory:updateinventory", function() -- new
    NUIService.LoadInv()
end)

-- AMMO SAVING THREAD
Citizen.CreateThread(function()
    repeat Wait(2000) until LocalPlayer.state.IsInSession

    while true do
        local sleep = 1000
        if not InInventory then
            local PlayerPedId = PlayerPedId()
            local isArmed = IsPedArmed(PlayerPedId, 4) == 1
            local wephash = GetPedCurrentHeldWeapon(PlayerPedId)
            local ismelee = IsWeaponMeleeWeapon(wephash) == 1

            if (isArmed or GetWeapontypeGroup(wephash) == 1548507267) and not ismelee then
                local wepgroup = GetWeapontypeGroup(wephash)
                local ammotypes = SharedData.AmmoTypes[wepgroup] or {}

                if playerammoinfo.ammo then
                    for k, v in pairs(ammotypes) do
                        if v and contains(playerammoinfo.ammo, v) then
                            local ammoQty = GetPedAmmoByType(PlayerPedId, joaat(v))
                            if (GetWeapontypeGroup(wephash) == 1548507267 or GetWeapontypeGroup(wephash) == -1241684019) and ammoQty == 1 then
                                ammoQty = 0
                            end

                            if playerammoinfo.ammo[v] ~= ammoQty then
                                --print("Ammo changed from " .. playerammoinfo.ammo[v] .. " to " .. ammoQty .. " for " .. v .. " ammo type.")
                                updatedAmmoCache[v] = ammoQty
                                playerammoinfo.ammo[v] = ammoQty
                                --print("Ammo is now " .. playerammoinfo.ammo[v] .. " for " .. v .. " ammo type.")
                            end
                        end
                    end

                    if next(updatedAmmoCache) then
                        SendNUIMessage({ action = "updateammo", ammo = playerammoinfo.ammo })
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

local ammoupdate = true
RegisterNetEvent("vorpinventory:ammoUpdateToggle", function(state)
    if not ammoupdate and state then
        local result = Core.Callback.TriggerAwait("vorpinventory:getammoinfo")

        if not result then
            return
        end
        playerammoinfo = result or {}
        addAmmoToPed(playerammoinfo.ammo)
        SendNUIMessage({
            action = "updateammo",
            ammo   = playerammoinfo.ammo
        })
    end
    ammoupdate = state
end)

-- AMMO UPDATE THREAD
Citizen.CreateThread(function()
    repeat Wait(2000) until LocalPlayer.state.IsInSession
    while true do
        if ammoupdate then
            if next(updatedAmmoCache) ~= nil then
                -- print("updatedAmmoCache", json.encode(updatedAmmoCache))
                TriggerServerEvent("vorpinventory:updateammo", playerammoinfo)
                updatedAmmoCache = {}
            end
        end
        Wait(10000)
    end
end)
