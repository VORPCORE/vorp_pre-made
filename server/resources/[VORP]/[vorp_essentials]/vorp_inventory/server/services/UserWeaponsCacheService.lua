-- The array UserWeaponsByCharId is optimized to allow fast access instead of looping through all the weapons to filter
-- them by the identifier and char id. If the server knows thousands of weapons (cached in UsersWeapons) each time if
-- e.g. InventoryAPI.getUserWeapons() is called, it would have to loop through all the weapons to filter them and this
-- would take a lot of time.
--
-- Important: UserWeaponsByCharId store the weaponId instead of the whole weapon object. This is because the weapon
-- object is already stored in UsersWeapons and it would be redundant to store it again.

---@class UserWeaponsCacheService
---@field _userWeapons table<invId, table<weaponId, Weapon>>
---@field _userWeaponsByCharId table<invId, table<charId, table<weaponId,boolean>>>
UserWeaponsCacheService = {
    _userWeapons = {},
    _userWeaponsByCharId = {}
}

---@param invId invId
---@param weapon Weapon
function UserWeaponsCacheService:add(invId, weapon)

    local weaponId = weapon:getId()
    local charId = weapon:getCharId()

    if not self._userWeapons[invId] then
        self._userWeapons[invId] = {}
    end

    self._userWeapons[invId][weaponId] = weapon

    if not self._userWeaponsByCharId[invId] then
        self._userWeaponsByCharId[invId] = {}
    end

    if not self._userWeaponsByCharId[invId][charId] then
        self._userWeaponsByCharId[invId][charId] = {}
    end

    self._userWeaponsByCharId[invId][charId][weaponId] = true
end

---@param invId invId
---@param weapon Weapon|string
---@param keepWithoutOwnerUntilServerRestart boolean|nil Set to true if e.g. weapon was dropped.
function UserWeaponsCacheService:remove(invId, weapon, keepWithoutOwnerUntilServerRestart)

    if type(weapon) == 'number' then
        weapon = self:getWeapon(invId, weapon)
    end

    if not weapon then
        print('^3UserWeaponsCacheService:remove: Unknown weapon^7')
        return
    end

    local weaponId = weapon:getId()
    local charId = weapon:getCharId()

    weapon:setPropietary('') -- Reset identifier (old way to delete weapons) e.g. if another one uses the object outside of the cache
    weapon:setCharId(0)

    if not keepWithoutOwnerUntilServerRestart then
        self._userWeapons[invId][weaponId] = nil
    end

    if self:existsInChar(invId, charId, weaponId) then
        self._userWeaponsByCharId[invId][charId][weaponId] = nil
    end
end

---@param invId invId
---@param weapon Weapon
function UserWeaponsCacheService:removeAfterServerRestart(invId, weapon)
    self:remove(invId, weapon, true)
end

---@param invId invId
---@param weaponId weaponId
---@return Weapon|nil
function UserWeaponsCacheService:getWeapon(invId, weaponId)
    return (self._userWeapons[invId] or {})[weaponId] or nil
end

---@param invId invId
---@return Weapon|nil
function UserWeaponsCacheService:getInv(invId)
    return self._userWeapons[invId] or nil
end

---@param invId invId
---@param charId charId
---@param identifier identifier|nil
---@return Weapon[]
function UserWeaponsCacheService:getByCharId(invId, charId, identifier)

    local weaponsIdsOfChar = (self._userWeaponsByCharId[invId] or {})[charId] or {}

    ---@type Weapon[]
    local charWeapons = {}

    for weaponId, _ in pairs(weaponsIdsOfChar) do

        local weapon = self:getWeapon(invId, weaponId)

        if weapon then
            if not identifier or weapon:getPropietary() == identifier then
                table.insert(charWeapons, weapon)
            end
        end
    end

    return charWeapons
end

---@param invId invId
---@return boolean
function UserWeaponsCacheService:existsInv(invId)
    return self._userWeapons[invId] ~= nil
end

---@param invId invId
---@param weaponId weaponId
---@return boolean
function UserWeaponsCacheService:existsWeapon(invId, weaponId)
    return self._userWeapons[invId] ~= nil and self._userWeapons[invId][weaponId] ~= nil
end

---@param invId invId
---@param charId charId
---@param weaponId weaponId
---@return boolean
function UserWeaponsCacheService:existsInChar(invId, charId, weaponId)
    return self._userWeaponsByCharId[invId] ~= nil and self._userWeaponsByCharId[invId][charId] ~= nil and self._userWeaponsByCharId[invId][charId][weaponId] == true
end

---@param weaponId weaponId
---@param sourceInvId invId
---@param targetInvId invId
---@param targetCharId charId
---@param targetIdentifier identifier|nil
function UserWeaponsCacheService:transfer(weaponId, sourceInvId, targetInvId, targetCharId, targetIdentifier)

    local weapon = self:getWeapon(sourceInvId, weaponId)

    self:remove(sourceInvId, weapon)

    if weapon then

        weapon:setCurrInv(targetInvId)
        weapon:setCharId(targetCharId)

        if targetIdentifier then
            weapon:setPropietary(targetIdentifier)
        end

        self:add(targetInvId, weapon)
    end
end

---@param invId invId
function UserWeaponsCacheService:registerInv(invId)

    if not self._userWeapons[invId] then
        self._userWeapons[invId] = {}
    end

    if not self._userWeaponsByCharId[invId] then
        self._userWeaponsByCharId[invId] = {}
    end
end

---@param invId invId
function UserWeaponsCacheService:removeInv(invId)

    if invId == 'default' then
        error('Cannot remove default inventory!')
        return
    end

    self._userWeapons[invId] = nil
    self._userWeaponsByCharId[invId] = nil
end

---@param player number
---@return charId|nil
function UserWeaponsCacheService:getCharId(player)
    return ((Core.getUser(player) or {}).getUsedCharacter or {}).charIdentifier or nil
end

---@param player number
---@return identifier|nil
function UserWeaponsCacheService:getIdentifier(player)
    return ((Core.getUser(player) or {}).getUsedCharacter or {}).identifier or nil
end