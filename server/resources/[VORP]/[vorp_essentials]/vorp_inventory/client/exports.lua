-- exports

exports('CloseInventory', function()
    return NUIService.CloseInv()
end)

exports('GetWeaponDefaultWeight', function(hash)
    return Utils.GetWeaponDefaultWeight(hash)
end)

exports('GetWeaponDefaultDesc', function(hash)
    return Utils.GetWeaponDefaultDesc(hash)
end)

exports('GetWeaponDefaultLabel', function(hash)
    return Utils.GetWeaponDefaultLabel(hash)
end)

exports('GetWeaponName', function(hash)
    return Utils.GetWeaponName(hash)
end)

exports('GetWeaponsDefaultData', function(request)
    return Utils.GetWeaponsDefaultData(request)
end)

exports('GetItem', function(name)
    return Utils.GetItem(name)
end)

exports('GetWeaponAmmoTypes', function(group)
    return SharedData.AmmoTypes[group]
end)

exports('GetAmmoLabel', function(ammo)
    return Utils.GetAmmoLabels(ammo)
end)
