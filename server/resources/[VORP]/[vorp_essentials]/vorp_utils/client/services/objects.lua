ObjectAPI = {}



---comment
---@param modelhash type|<string, number>
---@param x any
---@param y any
---@param z any
---@param heading any
---@param networked type <boolean,nil>
---@param method type|<string>
---@return type <table,nil>
function ObjectAPI:Create(modelhash, x, y, z, heading, networked, method)
    local ObjClass = {}
    local hash = modelhash
    local isNetworked = networked

    if not Shared:LoadModel(hash) then
        return nil
    end

    if isNetworked == nil then
        isNetworked = false
    end

    ObjClass.Obj = CreateObject(hash, x, y, z, isNetworked, false, false, false, false)
    while not DoesEntityExist(ObjClass.Obj) do
        Wait(10)
    end
    SetEntityHeading(ObjClass.Obj, heading)

    if CheckVar(method, "standard") == "standard" then
        PlaceObjectOnGroundProperly(ObjClass.Obj, true)
        Wait(100)
        FreezeEntityPosition(ObjClass.Obj, true)
    end
    SetModelAsNoLongerNeeded(hash)

    function ObjClass:PickupLight(state)
        Citizen.InvokeNative(0x7DFB49BCDB73089A, self.Obj, CheckVar(state, true))
    end

    function ObjClass:Freeze(state)
        FreezeEntityPosition(self.Obj, CheckVar(state, true))
    end

    function ObjClass:SetHeading(state)
        SetEntityHeading(self.Obj, CheckVar(state, true))
    end

    function ObjClass:PlaceOnGround(state)
        PlaceObjectOnGroundProperly(self.Obj, CheckVar(state, true))
    end

    -- The engine will keep object when players leave the area
    function ObjClass:SetAsMission(state)
        SetEntityAsMissionEntity(self.Obj, CheckVar(state, true), true)
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
