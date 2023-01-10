local ActiveMissions = {}

function IsMissionActive(key)
    for _, mission in pairs(ActiveMissions) do
        if key == mission then

            return true
        end
    end
    return false
end

function RemoveFromTableByName(ActiveMissions, removeAmbush)
    local indexToRemove = 0

    for index, name in pairs(ActiveMissions) do
        if removeAmbush == name then
            indexToRemove = index
        end
    end
    if indexToRemove == 0 then
        return false
    end

    table.remove(ActiveMissions, indexToRemove)
    return true
end

RegisterServerEvent("vorp_outlaws:check", function(ambushLocation)
    local _source = source

    if IsMissionActive(ambushLocation) then
        CanStart = false
        TriggerClientEvent("vorp_outlaws:canstart", _source, CanStart)
        TriggerClientEvent('vorp:ShowTopNotification', _source, "~e~AMBUSH", "bandits are here run or fight", 2000) -- notify anyone in location if mission in on going
    else
        ActiveMissions[#ActiveMissions + 1] = ambushLocation
        CanStart = true
        TriggerClientEvent("vorp_outlaws:canstart", _source, CanStart)
    end


end)

RegisterServerEvent("vorp_outlaws:remove", function(removeAmbush)
    local _source = source
    RemoveFromTableByName(ActiveMissions, removeAmbush)
end)
