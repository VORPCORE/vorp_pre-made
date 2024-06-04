---@class Pickup : table @Pickup class

Pickup = {}

Pickup.name = ''
Pickup.entityId = ''
Pickup.amount = ''
Pickup.metadata = {}
Pickup.isMoney = false
Pickup.isGold = false
Pickup.weaponId = ''
Pickup.coords = vector3(0, 0, 0)
Pickup.prompt = nil

function Pickup:Distance()
    local playerCoords = GetEntityCoords(PlayerPedId(), true, true)
    local distance = #(playerCoords - vector3(self.coords.x, self.coords.y, self.coords.z))
    return distance
end

function Pickup:IsWeapon()
    return self.weaponId > 0
end

function Pickup:IsInRange()
    return self:Distance() <= 5
end

function Pickup:New(t)
    t = t or {}
    setmetatable(t, self)
    self.__index = self
    return t
end
