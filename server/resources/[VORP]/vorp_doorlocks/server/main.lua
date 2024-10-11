local Core = exports.vorp_core:GetCore()

local function isCloseToDoor(playerPed, door)
    local coords = GetEntityCoords(playerPed)
    local distance = #(coords - door.Pos)
    return distance <= 3.0
end

RegisterNetEvent("vorp_doorlocks:Server:UpdateDoorState", function(door, state, isLockPicked)
    local _source <const> = source

    local value = Config.Doors[door]

    if value and not isCloseToDoor(GetPlayerPed(_source), value) then
        return print("Player was not close to the door possible hack attempt", "player id", _source, "playername", GetPlayerName(_source))
    end

    if not isLockPicked and value and value.Permissions then
        local user = Core.getUser(_source)
        if not user then return end
        local character = user.getUsedCharacter
        local job = character.job
        if not value.Permissions[job] then return Core.NotifyObjective(_source, Config.lang.NotAllowed, 5000) end
    end

    value.DoorState = state -- sync
    TriggerClientEvent("vorp_doorlocks:Client:UpdateDoorState", -1, door, state)
end)

CreateThread(function()
    for _, value in pairs(Config.Lockpicks) do
        for _, item in pairs(value) do
            exports.vorp_inventory:registerUsableItem(item, function(data)
                TriggerClientEvent("vorp_doorlocks:Client:lockpickdoor", data.source, item)
                exports.vorp_inventory:closeInventory(data.source)
            end)
        end
    end
end)

RegisterNetEvent("vorp_doorlocks:Server:AlertPolice", function()
    local _source <const> = source
    --TODO: only closest player ? show on map where it was?
    for index, value in ipairs(GetPlayers()) do
        if Player(tonumber(value)).state.isPoliceDuty then
            Core.NotifyLeft(tonumber(value), "Police Alert", "Someone lockpicked a door", "inventory_items", "provision_sheriff_star", 5000, "COLOR_WHITE")
        end
    end
end)

-- remove item
RegisterNetEvent("vorp_doorlocks:Server:RemoveLockpick", function(item)
    local _source <const> = source
    local user <const> = Core.getUser(_source)
    if not user then return end
    exports.vorp_inventory:subItem(_source, item, 1)
end)

AddEventHandler("vorp:SelectedCharacter", function(source, character)
    if Config.DevMode then return end

    -- Sync door states
    local gatherStates = {}
    for key, value in pairs(Config.Doors) do
        gatherStates[key] = value.DoorState
    end
    local data <const> = msgpack.pack(gatherStates)
    TriggerClientEvent("vorp_doorlocks:Client:Sync", source, data)
end)


AddEventHandler("vorp:playerJobChange", function(source, newjob, oldjob)
    SetTimeout(1000, function() -- wait for statebags to be available
        TriggerClientEvent("vorp_doorlocks:Client:UpdatePerms", source)
    end)
end)
