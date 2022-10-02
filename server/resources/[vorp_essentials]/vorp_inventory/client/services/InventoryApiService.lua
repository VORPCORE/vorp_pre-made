InventoryApiService = {}

---@param count number
---@param limit number
---@param label string
---@param name string
---@param type string
---@param canUse boolean
---@param canRemove boolean
InventoryApiService.addItem = function (itemData)
    local itemId = itemData.id
    local itemAmount = itemData.count

    local item = UserInventory[itemId]

    if item ~= nil then
        item:setCount(itemAmount)
    else
        UserInventory[itemId] = Item:New(itemData)
    end
    NUIService.LoadInv()
end

---@param id number
---@param qty number
---@param metadata table
InventoryApiService.subItem = function (id, qty, metadata)
    if UserInventory[id] == nil then
        return
    end


    UserInventory[id]:setCount(qty)
    if UserInventory[id]:getCount() == 0 then
        UserInventory[id] = nil
    end
    NUIService.LoadInv()
end

---@param weaponId number
InventoryApiService.subWeapon = function (weaponId)
    if UserWeapons[weaponId] ~= nil then
        if UserWeapons[weaponId]:getUsed() then
            RemoveWeaponFromPed(PlayerPedId(), GetHashKey(UserWeapons[weaponId]:getName()),true, 0)
        end
        Utils.TableRemoveByKey(UserWeapons, weaponId)
    end
    NUIService.LoadInv()
end

---@param weaponId number
---@param bulletType string
---@param qty number
InventoryApiService.addWeaponBullets = function (bulletType, qty)
    SetPedAmmoByType(PlayerPedId(), GetHashKey(bulletType), qty)
    --[[ if UserWeapons[weaponId] ~= nil then
        UserWeapons[weaponId]:addAmmo(bulletType, qty)
        if UserWeapons[weaponId]:getUsed() then
            SetPedAmmoByType(PlayerPedId(), GetHashKey(bulletType), UserWeapons[weaponId]:getAmmo(bulletType))
        end
    end ]]
    NUIService.LoadInv()
end

---@param weaponId number
---@param bulletType string
---@param qty number
InventoryApiService.subWeaponBullets = function (weaponId, bulletType, qty)
    if UserWeapons[weaponId] ~= nil then
        UserWeapons[weaponId]:subAmmo(bulletType, qty)
        if UserWeapons[weaponId]:getUsed() then
            SetPedAmmoByType(PlayerPedId(), GetHashKey(bulletType), UserWeapons[weaponId]:getAmmo(bulletType))
        end
    end
    NUIService.LoadInv()
end

---@param weaponId number
---@param component string
InventoryApiService.addComponent = function (weaponId, component)
    if UserWeapons[weaponId] ~= nil then
        for _,v in pairs(UserWeapons[weaponId]:getAllComponents()) do
            if v == component then
                return
            end
        end

        UserWeapons[weaponId]:setComponent(component)
        if UserWeapons[weaponId]:getUsed() then
            Citizen.InvokeNative(0x4899CB088EDF59B8, PlayerPedId(), GetHashKey(UserWeapons[weaponId]:getName()), true, 0)
            UserWeapons[weaponId]:equipwep()
            UserWeapons[weaponId]:loadComponents()
        end
    end
end

---@param weaponId number
---@param component string
InventoryApiService.subComponent = function (weaponId, component)
    if UserWeapons[weaponId] ~= nil then
        for _,v in pairs(UserWeapons[weaponId]:getAllComponents()) do
            if v == component then
                return
            end
        end

        UserWeapons[weaponId]:quitComponent(component)
        if UserWeapons[weaponId]:getUsed() then
            Citizen.InvokeNative(0x4899CB088EDF59B8, PlayerPedId(), GetHashKey(UserWeapons[weaponId]:getName()), true, 0)
            UserWeapons[weaponId]:equipwep()
            UserWeapons[weaponId]:loadComponents()
        end
    end
end