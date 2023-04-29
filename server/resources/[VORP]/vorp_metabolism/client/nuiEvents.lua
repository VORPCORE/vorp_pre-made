NUIEvents = {}

NUIEvents.UpdateHUD = function()
    local thirst = PlayerStatus["Thirst"] / 1000;
    local hunger = PlayerStatus["Hunger"] / 1000;

    SendNUIMessage({
        action = "update",
        water = thirst,
        food = hunger
    })
end

NUIEvents.ShowHUD = function(show)
    SendNUIMessage({
        action = show and 'show' or 'hide'
    })
end