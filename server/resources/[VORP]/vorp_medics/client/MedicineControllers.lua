-- resource start
Citizen.CreateThread(function()
    AddBlips()
    SetDoorSaintDenis()
    UIPrompt.initialize()
    
    GetJob()

    while true do
        Wait(1)
        Medics()
        StudyHerbalism()
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(60000)
        GetJob()
    end
end)

--using items from inventory
RegisterNetEvent("vorpMed:revive")
AddEventHandler("vorpMed:revive", function()
    MedRessurectPlayer()
end)

RegisterNetEvent("vorpMed:healOuter")
AddEventHandler("vorpMed:healOuter", function(percent)
    MedHealPlayerOuter(tonumber(percent))
end)

RegisterNetEvent("vorpMed:healInner")
AddEventHandler("vorpMed:healInner", function(percent, item)
    MedHealPlayerInner(tonumber(percent), tostring(item))
end)

RegisterNetEvent("vorpMed:sendPlayerJob")
AddEventHandler("vorpMed:sendPlayerJob", function(isMedic, isHerbalist)
    SendJob(isMedic, isHerbalist)
end)

RegisterNetEvent("vorpMed:PatientHealing")
AddEventHandler("vorpMed:PatientHealing", function(value)
    PatientHealing(value)
end)

RegisterNetEvent("vorpMed:horseFound")
AddEventHandler("vorpMed:horseFound", function()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local playerHeading = GetEntityHeading(PlayerPedId())
    SpawnHorse(playerCoords.x, playerCoords.y, playerCoords.z, playerHeading)
end)