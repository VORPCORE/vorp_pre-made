local IsMedic, IsHerbalist, horseSpawned, jobSet, recipiesSent = false, false, false, false, false

AddEventHandler("playerSpawned", function(spawnInfo)
    local playerPed = GetPlayerPed(PlayerId())
    Wait(40000)
    if Config.ResetInnerCore then
        --print("reset inner core")
        Citizen.InvokeNative(0xC6258F41D86676E0, playerPed, 0, 1) -- SetAttributeCoreValue
    end
    if Config.DisableRecharge then
        --print("disable recharge")
        Citizen.InvokeNative(0xDE1B1907A83A1550, playerPed, 0) --SetHealthRechargeMultiplier
    end

    if IsMedic then
        TriggerServerEvent("vorpMed:FindHorse")
    end
end)

-------------------------------------------------------
---------------------- helpers ------------------------
function SetDoorSaintDenis()
    Citizen.InvokeNative(0xD99229FE93B46286, 586229709, 1, 1, 0, 0, 0, 0)
    DoorSystemSetDoorState(586229709, DOORSTATE_UNLOCKED)
    DoorSystemSetOpenRatio(586229709, 0.0, true)
    local obj = Citizen.InvokeNative(0xF7424890E4A094C0, 586229709, 0)
    SetEntityRotation(obj, 0.0, 0.0, 269.6, 2, true)
end

function AddBlips()
    if Config.BlipsActive.BlipsDoctors or
        Config.BlipsActive.BlipsDoctorsOnly and IsMedic then
        for k, v in pairs(Config.Locations) do

            Config.Locations[k].BlipHandler = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.x, v.y, v.z)
            SetBlipSprite(Config.Locations[k].BlipHandler, -1739686743, 1)
            SetBlipScale(Config.Locations[k].BlipHandler, 0.2)
            
            if Config.BlipsActive.BlipsMedicStables and Config.MedicCanSpawnHorse and IsMedic then
                v.Stable.BlipHandler = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.Stable.x, v.Stable.y,
                    v.Stable.z)
                SetBlipSprite(v.Stable.BlipHandler, 1220803671, 1)
                SetBlipScale(v.Stable.BlipHandler, 0.2)
            end
        end
    end

    if Config.BlipsActive.BlipsHerbalism or
        Config.BlipsActive.BlipsHerbalistsOnly and IsHerbalist then
        for k, v in pairs(Config.HerbalistLocations) do
            Config.HerbalistLocations[k].BlipHandler = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.x, v.y, v.z)
            SetBlipSprite(Config.HerbalistLocations[k].BlipHandler, -675651933, 1)
            SetBlipScale(Config.HerbalistLocations[k].BlipHandler, 0.2)
        end
    end


end

function RemoveBlips()
    for k, v in pairs(Config.Locations) do
        RemoveBlip(v.BlipHandler)
        RemoveBlip(v.Stable.BlipHandler)
    end
end

function GetJob()
    TriggerServerEvent("vorpMed:GetJobs")
end

function SendJob(isMedic, isHerbalist)
    IsMedic = isMedic
    IsHerbalist = isHerbalist
    if IsMedic or IsHerbalist then
        --print(jobSet)
        if not jobSet then
            jobSet = true
            AddBlips()
        end
    else
        if jobSet then
            jobSet = false
            RemoveBlips()
        end
    end
end

function GetClosestPlayer(DoctorPed)
    local players = GetActivePlayers()
    local closestDistance = 2.01
    local closestPlayer = -1

    for index, value in ipairs(players) do
        local target = GetPlayerPed(tonumber(value))
        if (target ~= DoctorPed) then
            local distance = #(GetEntityCoords(GetPlayerPed(value)) - GetEntityCoords(DoctorPed))
            if (closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end

    return closestPlayer
end

function PlayAnim(ped, dict, anim)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
    end

    while not HasAnimDictLoaded(dict) do
        Wait(500)
    end

    FreezeEntityPosition(ped, true)

    TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 0, 0, 0, 0, 0)

    FreezeEntityPosition(ped, false)
end

function PatientHealing(value)
    local playerPed = GetPlayerPed(PlayerId())

    SetEntityHealth(playerPed, value)
end

function SpawnHorse(x, y, z, h)
    if horseSpawned then
        TriggerEvent("vorp:Tip", _U("HorseSpawned"), 5000)
        return
    end
    local playerPed = GetPlayerPed(PlayerId())

    local model = GetHashKey(Config.HorseHash)
    RequestModel(model)

    while not HasModelLoaded(GetHashKey(Config.HorseHash)) do
        Wait(100)
    end

    local myHorse = Citizen.InvokeNative(0xD49F9B0955C367DE, model, x, y, z, h, true, true, true, true)
    --print(myHorse)
    SetModelAsNoLongerNeeded(model)
    Citizen.InvokeNative(0x283978A15512B2FE, myHorse, true)
    Citizen.InvokeNative(0xD3A7B003ED343FD9, myHorse, 0xD97573C1, true, true, true) --saddle
    Citizen.InvokeNative(0xD3A7B003ED343FD9, myHorse, 0x508B80B9, true, true, true) --blanket
    Citizen.InvokeNative(0xD3A7B003ED343FD9, myHorse, 0xF0C30271, true, true, true) --bag
    Citizen.InvokeNative(0xD3A7B003ED343FD9, myHorse, 0x12F0DF9F, true, true, true) --bedroll
    Citizen.InvokeNative(0xD3A7B003ED343FD9, myHorse, 0x67AF7302, true, true, true) --stirups
    if Config.BlipsActive.BlipsHorses then
        Citizen.InvokeNative(0x23f74c2fda6e7c61, -1230993421, myHorse)
    end
    TriggerServerEvent("vorpMed:saveHorse", myHorse)
    Citizen.InvokeNative(0x028F76B6E78246EB, playerPed, myHorse, -1, true)
    horseSpawned = true
end

function DespawnHorse()
    if not horseSpawned then
        TriggerEvent("vorp:Tip", _U("HorseDespawned"), 5000)
        return
    end

    local playerPed = GetPlayerPed(PlayerId())
    local playerCoord = GetEntityCoords(playerPed)

    if IsPedOnMount(playerPed) then
        local myHorse = GetMount(playerPed)
        DeletePed(myHorse)
        horseSpawned = false
        TriggerServerEvent("vorpMed:deleteHorse")
    else
        TriggerEvent("vorp:Tip", _U("NotOnHorse"), 5000)
    end
end

-------------------------------------------------------
------------------ items used -------------------------
function MedHealPlayerOuter(percent)
    local DoctorPed = GetPlayerPed(PlayerId())
    local closePlayer = GetClosestPlayer(DoctorPed)
    local closePed = GetPlayerPed(closePlayer)
    local nearestPlayer = GetNearestPlayerToEntity(closePed)
    local nearestPlayerServerId = GetPlayerServerId(nearestPlayer)
    local health = GetEntityHealth(closePed)
    local newHealth = health + percent * 5
    local doctorCoords = GetEntityCoords(DoctorPed)
    local targetPed = GetEntityCoords(closePed)
    local distance = #(doctorCoords - targetPed)

    if distance < 2.0 then
        PlayAnim(DoctorPed, "script_mp@player@healing", "healing_male")
        TriggerServerEvent("vorpMed:HealPatient", nearestPlayerServerId, newHealth)
    else
        PlayAnim(DoctorPed, "mech_inventory@item@stimulants@inject@quick", "quick_stimulant_inject_rhand")
        SetEntityHealth(DoctorPed, 500)
        --Citizen.InvokeNative(0xC6258F41D86676E0, DoctorPed, 0, 1)
    end
end

function MedHealPlayerInner(percent, item)
    local playerPed = GetPlayerPed(PlayerId())
    local innerHealth = Citizen.InvokeNative(0x36731AC041289BB1, playerPed, 0)
    local newHealth = tonumber(innerHealth) + percent

    if 100 - tonumber(innerHealth) < percent then
        TriggerEvent("vorp:TipBottom", _U("Overdose"), 5000)
        TriggerServerEvent("vorpMed:giveBack", item, 1)
    else
        PlayAnim(playerPed, "amb_rest_drunk@world_human_drinking@male_a@idle_a", "idle_a")
        Citizen.InvokeNative(0xC6258F41D86676E0, playerPed, 0, newHealth)
        Citizen.InvokeNative(0xDE1B1907A83A1550, playerPed, 1065352316)
        Wait(percent * 1000)
        if Config.ResetInnerCore then
            Citizen.InvokeNative(0xC6258F41D86676E0, playerPed, 0, 1) -- SetAttributeCoreValue
        end
        if Config.DisableRecharge then
            Citizen.InvokeNative(0xDE1B1907A83A1550, playerPed, 0) --SetHealthRechargeMultiplier
        end
    end
end

function MedRessurectPlayer()
    local DoctorPed = GetPlayerPed(PlayerId())
    local closePlayer = GetClosestPlayer(DoctorPed)
    local closePed = GetPlayerPed(closePlayer)
    if closePlayer ~= -1 and IsPedDeadOrDying(closePed, 1) then
        local id = GetPlayerServerId(closePlayer)
        PlayAnim(DoctorPed, "mech_revive@unapproved", "revive") --change
        TriggerServerEvent("vorpMed:resurrectPlayer", id)
    else
        TriggerEvent("vorp:Tip", _U("NoDeadPlayer"), 5000)
        --Wait(1)
        TriggerServerEvent("vorpMed:giveBack", "syringe", 1)
    end
end

-------------------------------------------------------
-------------------- At locations ---------------------
function Medics()
    --GetJob()
    if IsMedic then
        for k, v in pairs(Config.Locations) do
            local Office = vector3(v.x, v.y, v.z)
            local DoctorPed = GetPlayerPed(PlayerId())
            local DoctorPedCoord = GetEntityCoords(DoctorPed)

            local Stable = vector3(v.Stable.x, v.Stable.y, v.Stable.z)
            local Craft = vector3(v.Craft.x, v.Craft.y, v.Craft.z)
            local Storage = vector3(v.Inventory.x, v.Inventory.y, v.Inventory.z)

            --healing
            if #(Office - DoctorPedCoord) <= 2.0 then
                UIPrompt.activate(_U("HealPlayer") .. v.name)
                local nearestPlayer = GetClosestPlayer(DoctorPed)
                local closePed = GetPlayerPed(nearestPlayer)
                if Citizen.InvokeNative(0xC92AC953F0A982AE, MedPrompt) then
                    if GetEntityHealth(closePed) < 500 or GetEntityHealth(DoctorPed) < 500 then
                        MedHealPlayerOuter(100)
                    end
                end
                return
            end

            --stable
            if #(Stable - DoctorPedCoord) <= 2.0 then
                UIPrompt.activate(_U("MedicStables") .. v.name)
                if Citizen.InvokeNative(0xC92AC953F0A982AE, MedPrompt) then
                    if horseSpawned then
                        DespawnHorse()
                    else
                       SpawnHorse(v.Stable.x, v.Stable.y, v.Stable.z, v.Stable.h)
                    end
                end
                return
            end

            --Craft medicines
            if #(Craft - DoctorPedCoord) <= 0.5 then
                UIPrompt.activate(_U("MedicCrafting") .. v.name)
                if Citizen.InvokeNative(0xC92AC953F0A982AE, MedPrompt) then
                    OpenMenu(k)
                end
                return
            end
        end
    end
end

function StudyHerbalism()
    if not IsHerbalist then
        if recipiesSent then
            for k, v in pairs(Config.Recepies) do
                TriggerServerEvent("vorp:RemoveRecipes", v)
            end
            recipiesSent = false;
        end
        for k, v in pairs(Config.HerbalistLocations) do
            local Camp = vector3(v.x, v.y, v.z)
            local PlayerPed = GetPlayerPed(PlayerId())
            local PlayerPedCoords = GetEntityCoords(PlayerPed)
            if #(Camp - PlayerPedCoords) <= 5.0 then
                UIPrompt.activate(_U("StudyHerbals") .. v.name)
                if Citizen.InvokeNative(0xC92AC953F0A982AE, MedPrompt) then
                    TriggerServerEvent("vorpMed:BecomeHerbalist", k)
                end
                return
            end
        end
    else
        if not recipiesSent then
            for k, v in pairs(Config.Recepies) do
                TriggerClientEvent("vorp:AddRecipes", v)
            end
            recipiesSent = true;
        end
    end
end
