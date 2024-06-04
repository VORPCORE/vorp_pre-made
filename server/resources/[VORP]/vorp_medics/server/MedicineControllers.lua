VorpInv = exports.vorp_inventory:vorp_inventoryApi()

--return unused item
RegisterNetEvent("vorpMed:giveBack")
AddEventHandler("vorpMed:giveBack", function(item, qty)
    --print(item, qty)
    VorpInv.addItem(source, item, qty)
    --print("extra")
end)

-- get whether player has a medic job or herbalist
RegisterNetEvent("vorpMed:GetJobs")
AddEventHandler("vorpMed:GetJobs", function()
    local _source = source
    TriggerClientEvent("vorpMed:sendPlayerJob", _source, IsPlayerMedic(_source), IsPlayerHerbalist(_source))
end)

-- Become herbalist
RegisterNetEvent("vorpMed:BecomeHerbalist")
AddEventHandler("vorpMed:BecomeHerbalist", function(location)
    BecomeHerbalist(source, location)
end)

-- Heal Patient
RegisterNetEvent("vorpMed:HealPatient")
AddEventHandler("vorpMed:HealPatient", function(target, value)
    if target then
        TriggerClientEvent("vorpMed:PatientHealing", target, value)
    end
end)

-- ResurrectPatient
RegisterNetEvent("vorpMed:resurrectPlayer")
AddEventHandler("vorpMed:resurrectPlayer", function(id)
    if id then
        TriggerClientEvent("vorp:resurrectPlayer", id)
        TriggerClientEvent("vorp:TipBottom", id, _U("Resurrected"), 5000)
    end
end)

RegisterNetEvent("vorpMed:saveHorse")
AddEventHandler("vorpMed:saveHorse", function(horse)
    local _source = source
    SaveHorse(_source, horse)
end)

RegisterNetEvent("vorpMed:deleteHorse")
AddEventHandler("vorpMed:deleteHorse", function(horse)
    local _source = source
    DeleteHorse(_source)
end)

RegisterNetEvent("vorpMed:FindHorse")
AddEventHandler("vorpMed:FindHorse", function()
    local _source = source
    FindHorse(_source)
end)