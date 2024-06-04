local campfire = 0
local progressbar = exports.vorp_progressbar:initiate()

local function placeCampfire()
    if campfire ~= 0 then
        SetEntityAsMissionEntity(campfire, false, false)
        DeleteObject(campfire)
        campfire = 0
    end

    local playerPed = PlayerPedId()
    Animations.playAnimation(playerPed, "campfire")

    progressbar.start(_U('PlaceFire'), 20000, function()
        Animations.endAnimation("campfire")
        Animations.endAnimations()
        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, -1.55))
        RequestModel(Config.PlaceableCampfire, false)
        repeat Wait(0) until HasModelLoaded(Config.PlaceableCampfire)
        local prop = CreateObject(GetHashKey(Config.PlaceableCampfire), x, y, z, true, false, false, false, false)
        repeat Wait(0) until DoesEntityExist(prop)
        SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
        PlaceObjectOnGroundProperly(prop, false)
        campfire = prop
    end)
end

RegisterNetEvent('vorp:campfire')
AddEventHandler('vorp:campfire', function()
    placeCampfire()
end)

if Config.Commands.campfire == true then
    RegisterCommand("campfire", function(source, args, rawCommand)
        placeCampfire()
    end, false)
end

if Config.Commands.extinguish == true then
    RegisterCommand('extinguish', function(source, args, rawCommand)
        if campfire ~= 0 then
            SetEntityAsMissionEntity(campfire, false, false)
            TaskStartScenarioInPlaceHash(PlayerPedId(), GetHashKey('WORLD_HUMAN_BUCKET_POUR_LOW'), 7000, true, 0, 0,   false)
            TriggerEvent("vorp:TipRight", _U('PutOutFire'), 7000)
            Wait(7000)
            ClearPedTasksImmediately(PlayerPedId())
            DeleteObject(campfire)
            campfire = 0
        end
    end, false)
end
