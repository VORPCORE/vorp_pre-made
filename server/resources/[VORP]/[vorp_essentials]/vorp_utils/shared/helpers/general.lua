Shared = {}

function CheckVar(val, def)
    if val == nil then
        return def
    end

    return val
end

function IsEmpty(val)
    if val == nil then
        return true
    elseif val == '' then
        return true
    end

    return false
end

function Shared:LoadModel(modelhash)
    if IsModelInCdimage(modelhash) then
        RequestModel(modelhash)
        local count = 0
        while not HasModelLoaded(modelhash) do
            Wait(10)
            count = count + 1
            if count > 1000 then
                print("Model could not load" .. modelhash)
                return false
            end
            RequestModel(modelhash)
        end
        return true
    end

    print("Model not found: " .. modelhash)
    return false
end
