RegisterNetEvent("vorp:AddRecipes", function(recipe, all)
    local _source = source
    table.insert(Config.Crafting, recipe)
    local id = not all and _source or -1
    TriggerClientEvent("vorp:UpdateRecipes", id, recipe, false)
end)

RegisterNetEvent("vorp:RemoveRecipes", function(recipe, all)
    local _source = source
    for k, v in pairs(Config.Crafting) do
        if v.Text == recipe.Text then
            table.remove(Config.Crafting, k)
            local id = not all and _source or -1
            TriggerClientEvent("vorp:UpdateRecipes", id, k, true)
            return
        end
    end
end)

RegisterNetEvent("vorp:AddCraftLocation", function(location, all)
    local _source = source
    table.insert(Config.Locations, location)
    local id = not all and _source or -1
    TriggerClientEvent("vorp:UpdateLocations", id, location, false)
end)

RegisterNetEvent("vorp:RemoveCraftLocation", function(location, all)
    local _source = source
    for k, v in pairs(Config.Locations) do
        if v.id == location.id then
            table.remove(Config.Locations, k)
            local id = not all and _source or -1
            TriggerClientEvent("vorp:UpdateLocations", id, k, true)
            return
        end
    end
end)
