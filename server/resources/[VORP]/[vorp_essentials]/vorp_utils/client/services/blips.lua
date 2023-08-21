BlipAPI = {}


---@param name string give a name to blip
---@param sprite type <string,number>  blip sprite
---@param scale number blip scale doesnt do anything
---@param x number 
---@param y number
---@param z number 
---@param BlipStyle type <string,number> sblip style
function BlipAPI:SetBlip(name, sprite, scale, x, y, z, BlipStyle)
    local BlipClass = {}
    
    if BlipStyle and type(BlipStyle) == "string" then
        BlipStyle = joaat(BlipStyle)
    end
    
     if type(sprite) == "string" then
        sprite = joaat(sprite)
    end
    
    BlipClass.rawblip =  Citizen.InvokeNative(0x554D9D53F696D002, BlipStyle or 1664425300, vector3(x, y, z))
    BlipClass.x = x
    BlipClass.y = y
    BlipClass.z = z
    BlipClass.RadiusBlip = nil
    
   
    SetBlipSprite(BlipClass.rawblip, sprite, true)
    SetBlipScale(BlipClass.rawblip, scale) -- this doesnt do anything  or it does but to a specified blip style ?
    Citizen.InvokeNative(0x9CB1A1623062F402, BlipClass.rawblip, name)

    function BlipClass:Get()
        return self.rawblip
    end

    function BlipClass:Remove()
        RemoveBlip(self.rawblip)
        self.rawblip = nil
        if self.RadiusBlip then
            RemoveBlip(self.RadiusBlip)
            self.RadiusBlip = nil
        end
    end

    function BlipClass:AddRadius(radius, hash)
        self.RadiusBlip = Citizen.InvokeNative(0x45f13b7e0a15c880, hash or -1282792512, self.x, self.y, self.z, radius)
    end

    return BlipClass
end

-- ! needs to be removed as its already being used in the class above no need to have duplicated code doing the same thing ! --
function BlipAPI:RemoveBlip(blip)
      print("dont use this, call the class instead this will be removed in the future")
        RemoveBlip(blip)
end

function BlipAPI:AddRadius(radius, x, y, z, hash)
    print("dont use this, call the class instead this will be removed in the future")
    return Citizen.InvokeNative(0x45f13b7e0a15c880, hash or -1282792512, x, y, z, radius)
end
