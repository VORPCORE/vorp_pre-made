-- Ensures there is a default value set if there is no value given
function CheckVar(val, def)
    if val == nil then
        return def
    end
    
    return val
end

function IsEmpty(val)
    if val == nil then
        return true
    elseif  val == '' then
        return true
    end

    return false
end