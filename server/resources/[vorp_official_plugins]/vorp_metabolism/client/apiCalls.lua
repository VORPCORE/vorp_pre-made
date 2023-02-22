ApiCalls = {
    APIShowOn = true
}

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

RegisterNetEvent("vorpmetabolism:changeValue", function(key, value)
    local newKey = firstToUpper(key) -- Fixed first char to upper case

    if (PlayerStatus[newKey]) then
        local newValue = PlayerStatus[newKey] + value
        if (newKey == "Metabolism") then
            if (newValue > 10000) then
                newValue = 10000
            elseif (newValue < -10000) then
                newValue = -10000
            end
        else
            if (newValue > 1000) then
                newValue = 1000
            elseif (newValue < 0) then
                newValue = 0
            end
        end

        PlayerStatus[newKey] = newValue
    end
end)
RegisterNetEvent("vorpmetabolism:setValue", function(key, value)
    local newKey = firstToUpper(key) -- Fixed first char to upper case
    if (PlayerStatus[newKey]) then
        local newValue = value
        if (newKey == "Metabolism") then
            if (newValue > 10000) then
                newValue = 10000
            elseif (newValue < -10000) then
                newValue = -10000
            end
        else
            if (newValue > 1000) then
                newValue = 1000
            elseif (newValue < -1000) then
                newValue = -1000
            end
        end

        PlayerStatus[newKey] = newValue
    end
end)
RegisterNetEvent("vorpmetabolism:getValue", function(key, cb)
    local newKey = firstToUpper(key) -- Fixed first char to upper case

    if (PlayerStatus[newKey]) then
        cb(PlayerStatus[newKey])
    else
        cb(nil)
    end
end)
RegisterNetEvent("vorpmetabolism:setHud", function(enable)
    ApiCalls.APIShowOn = enable
end)