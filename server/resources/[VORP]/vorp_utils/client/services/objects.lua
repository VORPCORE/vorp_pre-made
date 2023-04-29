ObjectAPI = {}

-- networked: Whether to create a network object for the object. If false, the object exists only locally.
function ObjectAPI:Create(modelhash, x, y, z, heading, networked, method)
    local ObjClass = {}

    local hash = GetHashKey(CheckVar(modelhash, "p_package09"))
    while not HasModelLoaded(hash) do
        Wait(10)
        RequestModel(hash)
    end

    ObjClass.Obj = CreateObject(hash, x, y, z, CheckVar(networked, true))
    SetEntityHeading(ObjClass.Obj, heading)

    if CheckVar(method, "standard") == standard then
        PlaceObjectOnGroundProperly(ObjClass.Obj, true)
        FreezeEntityPosition(ObjClass.Obj, true)
    end

    function ObjClass:PickupLight(state)
        Citizen.InvokeNative(0x7DFB49BCDB73089A, self.Obj,  CheckVar(state, true))
    end

    function ObjClass:Freeze(state) 
        FreezeEntityPosition(self.Obj, CheckVar(state, true))
    end

    function ObjClass:SetHeading(head) 
        SetEntityHeading(self.Obj, CheckVar(state, head))
    end

    function ObjClass:PlaceOnGround(state) 
        PlaceObjectOnGroundProperly(self.Obj, CheckVar(state, true))
    end

    -- The engine will keep object when players leave the area
    function ObjClass:SetAsMission(state) 
        SetEntityAsMissionEntity(self.Obj, CheckVar(state, true))
    end

    -- The engine will remove when players leave the area
    function ObjClass:SetAsNoLongerNeeded()
        SetModelAsNoLongerNeeded(self.Obj)
    end

    function ObjClass:Invincible(state)
        SetEntityInvincible(self.Obj, CheckVar(state, true))
    end

    -- Sets object as not jumpable by horse.
    function ObjClass:SetNotHorseJumpable(state)
        SetNotJumpableByHorse(self.Obj, CheckVar(state, true))
    end


    function ObjClass:Remove()
        DeleteObject(self.Obj)
    end

    function ObjClass:GetObj()
        return self.Obj
    end

    return ObjClass
end