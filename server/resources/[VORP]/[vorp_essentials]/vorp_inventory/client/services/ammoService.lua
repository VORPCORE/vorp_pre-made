local getammoinfo = false
local playerammoinfo = {}
local updatedAmmoCache = {}
InvLoaded = false

local function addAmmoToPed(ammoData)
    for ammoType, ammo in pairs(ammoData) do
        SetPedAmmoByType(PlayerPedId(), joaat(ammoType), ammo)
    end
end

local function contains(arr, element)
    if next(arr) == nil then
        return false
    end

    for key, v in pairs(arr) do
        if key == element then
            return true
        end
    end
    return false
end

RegisterNetEvent("vorpinventory:loaded")
AddEventHandler("vorpinventory:loaded", function()
    SendNUIMessage({
        action = "reclabels",
        labels = SharedData.AmmoLabels
    })
    --TODO add callback here
    getammoinfo = true
    TriggerServerEvent("vorpinventory:getammoinfo")
    while getammoinfo do
        Wait(100)
    end

    addAmmoToPed(playerammoinfo.ammo)
    SendNUIMessage({
        action = "updateammo",
        ammo   = playerammoinfo.ammo
    })
    InvLoaded = true
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
    Citizen.InvokeNative(0xF25DF915FA38C5F3, PlayerPedId, 1, 1)
    Citizen.InvokeNative(0x1B83C0DEEBCBB214, PlayerPedId)
    addAmmoToPed(ammoData)
end)

RegisterNetEvent("vorpinventory:updateinventorystuff", function() -- new
    NUIService.LoadInv()
end)

RegisterNetEvent("vorpinventory:recammo", function(ammo)
    playerammoinfo = ammo
    getammoinfo = false
end)

-- AMMO SAVING THREAD
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if InvLoaded and not InInventory then
            local PlayerPedId = PlayerPedId()
            local isArmed = Citizen.InvokeNative(0xCB690F680A3EA971, PlayerPedId, 4)
            local wephash = Citizen.InvokeNative(0x8425C5F057012DAB, PlayerPedId)
            local ismelee = Citizen.InvokeNative(0x959383DCD42040DA, wephash)
            if (isArmed or GetWeapontypeGroup(wephash) == 1548507267) and not ismelee then
                local wepgroup = GetWeapontypeGroup(wephash)
                local ammotypes = SharedData.AmmoTypes[wepgroup]

                if ammotypes and playerammoinfo.ammo then
                    for k, v in pairs(ammotypes) do
                        if contains(playerammoinfo.ammo, v) then
                            local ammoQty = Citizen.InvokeNative(0x39D22031557946C1, PlayerPedId, joaat(v)) --GET_PED_AMMO_BY_TYPE
                            if not ammoQty or ((GetWeapontypeGroup(wephash) == 1548507267 or GetWeapontypeGroup(wephash) == -1241684019) and ammoQty == 1) then
                                ammoQty = 0
                            end

                            if playerammoinfo.ammo[v] ~= ammoQty then
                                updatedAmmoCache[v] = ammoQty
                                playerammoinfo.ammo[v] = ammoQty
                            end
                        end
                    end
                    if next(updatedAmmoCache) ~= nil then
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
        getammoinfo = true
        TriggerServerEvent("vorpinventory:getammoinfo")
        while getammoinfo do
            Wait(100)
        end
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
    while true do
        if ammoupdate then 
            if next(updatedAmmoCache) ~= nil then
                TriggerServerEvent("vorpinventory:updateammo", playerammoinfo)
                updatedAmmoCache = {}
            end
        end
        Wait(10000) -- every 10 seconds
    end
end)
