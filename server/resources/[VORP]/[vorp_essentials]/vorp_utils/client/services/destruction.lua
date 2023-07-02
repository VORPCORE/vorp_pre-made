DestructionAPI = {}

function DestructionAPI:GetMapObject(x, y, z, radius, objectname)
    local destruct = {}
    destruct.rawobject = GetRayfireMapObject(x, y, z, radius, objectname)

    function destruct:DoesExist()
        return DoesRayfireMapObjectExist(self.rawobject)
    end
    
    function destruct:SetState(state)
        SetStateOfRayfireMapObject(self.rawobject, state or 6)
    end

    function destruct:GetState()
        return GetStateOfRayfireMapObject(self.rawobject)
    end
    
    function destruct:resetState()
        SetStateOfRayfireMapObject(self.rawobject, 4)
    end

    return destruct
end

function DestructionAPI:DoesExist(object)
    return DoesRayfireMapObjectExist(object.rawobject)
end

function DestructionAPI:SetState(object, state)
    SetStateOfRayfireMapObject(object.rawobject, state or 6)
end

function DestructionAPI:resetState(object)
    SetStateOfRayfireMapObject(object.rawobject, 4)
end

function DestructionAPI:GetState(object)
    return GetStateOfRayfireMapObject(object.rawobject)
end