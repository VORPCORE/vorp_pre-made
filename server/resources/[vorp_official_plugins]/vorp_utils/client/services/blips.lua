BlipAPI = {}

function BlipAPI:SetBlip(name, sprite, scale, x, y, z)
    local BlipClass = {}

    BlipClass.rawblip =  Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, vector3(x, y, z))
    BlipClass.x = x
    BlipClass.y = y
    BlipClass.z = z
    BlipClass.RadiusBlip = nil

    SetBlipSprite(BlipClass.rawblip, GetHashKey(sprite), true)
    SetBlipScale(BlipClass.rawblip, scale)
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

function BlipAPI:RemoveBlip(blip)
    RemoveBlip(blip)
end

function BlipAPI:AddRadius(radius, x, y, z, hash)
    return Citizen.InvokeNative(0x45f13b7e0a15c880, hash or -1282792512, x, y, z, radius)
end