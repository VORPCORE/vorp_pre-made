local Core = exports.vorp_core:GetCore()

-- * CLEAR ITEMS WEAPONS AND MONEY * --
RegisterNetEvent("vorp:PlayerForceRespawn", function()
    local _source = source
    local User = Core.getUser(_source).getUsedCharacter
    local _value = Config.OnPlayerRespawn
    local job = User.job

    if not User then
        return
    end

    if not Config.UseClearAll then
        return
    end

    --MONEY
    if _value.Money.ClearMoney then
        if not SharedUtils.IsValueInArray(job, _value.Money.JobLock) then
            if not _value.Money.MoneyPercentage then
                User.removeCurrency(0, User.money)
            else
                User.removeCurrency(0, User.money * _value.Money.MoneyPercentage)
            end
        end
    end

    -- GOLD
    if _value.Gold.ClearGold then
        if not SharedUtils.IsValueInArray(job, _value.Gold.JobLock) then
            if not _value.Gold.GoldPercentage then
                User.removeCurrency(1, User.gold)
            else
                User.removeCurrency(1, User.gold * _value.Gold.GoldPercentage)
            end
        end
    end

    -- ITEMS
    CreateThread(function()
        if _value.Items.AllItems then
            if not SharedUtils.IsValueInArray(job, _value.Items.JobLock) then
                InventoryAPI.getInventory(_source, function(Userinventory)
                    for i, item in pairs(Userinventory) do
                        Wait(20)
                        if next(_value.Items.itemWhiteList) then
                            for index, value in ipairs(_value.Items.itemWhiteList) do
                                if item.name ~= value then
                                    InventoryAPI.subItem(_source, item.name, item.count, item.metadata)
                                end
                            end
                        else
                            InventoryAPI.subItem(_source, item.name, item.count, item.metadata)
                        end
                    end
                end)
            end
        end
    end)

    -- WEAPONS
    CreateThread(function()
        if _value.Weapons.AllWeapons then
            if not SharedUtils.IsValueInArray(job, _value.Weapons.JobLock) then
                InventoryAPI.getUserWeapons(_source, function(Userweapons)
                    for i, weapon in pairs(Userweapons) do
                        if next(_value.Weapons.WeaponWhitelisted) then
                            for index, value in ipairs(_value.Weapons.WeaponWhitelisted) do
                                if value ~= weapon.name then
                                    InventoryAPI.subWeapon(_source, weapon.id)
                                    InventoryAPI.deleteWeapon(_source, weapon.id)
                                end
                            end
                        else
                            InventoryAPI.subWeapon(_source, weapon.id)
                            InventoryAPI.deleteWeapon(_source, weapon.id)
                        end
                    end
                end)
            end
        end
    end)

    --AMMO
    if _value.Ammo.AllAmmo then
        if not SharedUtils.IsValueInArray(job, _value.Ammo.JobLock) then
            TriggerClientEvent('syn_weapons:removeallammo', _source)  -- syn script
            TriggerClientEvent('vorp_weapons:removeallammo', _source) -- vorp script
            InventoryAPI.removeAllUserAmmo(_source)
        end
    end
end)
