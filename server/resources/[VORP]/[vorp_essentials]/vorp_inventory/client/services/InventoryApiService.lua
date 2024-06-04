InventoryApiService = {}
InventoryApiService.addItem = function(itemData)
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


InventoryApiService.subItem = function(id, qty, metadata)
    if UserInventory[id] == nil then
        return
    end

    UserInventory[id]:setCount(qty)
    if UserInventory[id]:getCount() == 0 then
        UserInventory[id] = nil
    end
    NUIService.LoadInv()
end

InventoryApiService.SetItemMetadata = function(id, metadata)
    if UserInventory[id] == nil then
        return
    end
    UserInventory[id]:setMetadata(metadata)
    NUIService.LoadInv()
end


InventoryApiService.subWeapon = function(weaponId)
    if UserWeapons[weaponId] ~= nil then
        if UserWeapons[weaponId]:getUsed() then
            UserWeapons[weaponId]:setUsed(false)
            UserWeapons[weaponId]:UnequipWeapon()
        end
        Utils.TableRemoveByKey(UserWeapons, weaponId)
    end
    NUIService.LoadInv()
end


InventoryApiService.addWeaponBullets = function(bulletType, qty)
    SetPedAmmoByType(PlayerPedId(), joaat(bulletType), qty)
    NUIService.LoadInv()
end

InventoryApiService.subWeaponBullets = function(weaponId, bulletType, qty)
    if UserWeapons[weaponId] ~= nil then
        UserWeapons[weaponId]:subAmmo(bulletType, qty)
        if UserWeapons[weaponId]:getUsed() then
            SetPedAmmoByType(PlayerPedId(), joaat(bulletType), UserWeapons[weaponId]:getAmmo(bulletType))
        end
    end
    NUIService.LoadInv()
end


InventoryApiService.addComponent = function(weaponId, component)
    if UserWeapons[weaponId] ~= nil then
        for _, v in pairs(UserWeapons[weaponId]:getAllComponents()) do
            if v == component then
                return
            end
        end

        UserWeapons[weaponId]:setComponent(component)
        if UserWeapons[weaponId]:getUsed() then
            RemoveWeaponFromPed(PlayerPedId(), joaat(UserWeapons[weaponId]:getName()), true, 0) 
            UserWeapons[weaponId]:equipwep()
            UserWeapons[weaponId]:loadComponents()
        end
    end
end


InventoryApiService.subComponent = function(weaponId, component)
    if UserWeapons[weaponId] ~= nil then
        for _, v in pairs(UserWeapons[weaponId]:getAllComponents()) do
            if v == component then
                return
            end
        end

        UserWeapons[weaponId]:quitComponent(component)
        if UserWeapons[weaponId]:getUsed() then
            RemoveWeaponFromPed(PlayerPedId(), joaat(UserWeapons[weaponId]:getName()), true, 0)
            UserWeapons[weaponId]:equipwep()
            UserWeapons[weaponId]:loadComponents()
        end
    end
end
