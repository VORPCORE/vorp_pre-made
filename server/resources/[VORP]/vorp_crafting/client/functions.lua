function whenKeyJustPressed(key)
    if Citizen.InvokeNative(0x580417101DDB492F, 0, key) then
        return true
    else
        return false
    end
end

function getCoordDistance(v1, v2) 
    local v = vector3(v1.x, v1.y, v1.z)
    local x = vector3(v2.x, v2.y, v2.z)
    return #(v - x)
end