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

-- ! no point in using this when theres a class for it, its duplicated code , and also natives are named just called them ! --

function DestructionAPI:DoesExist(object)
      print("dont use this it will be removed, use the class instead")
    return DoesRayfireMapObjectExist(object.rawobject)
end

function DestructionAPI:SetState(object, state)
      print("dont use this it will be removed, use the class instead")
    SetStateOfRayfireMapObject(object.rawobject, state or 6)
end

function DestructionAPI:resetState(object)
      print("dont use this it will be removed, use the class instead")
    SetStateOfRayfireMapObject(object.rawobject, 4)
end

function DestructionAPI:GetState(object)
    print("dont use this it will be removed, use the class instead")
    return GetStateOfRayfireMapObject(object.rawobject)
end 
