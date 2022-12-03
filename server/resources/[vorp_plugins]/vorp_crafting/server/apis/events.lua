RegisterNetEvent("vorp:AddRecipes")
AddEventHandler("vorp:AddRecipes", function(recipe)
    local _source = source
    table.insert(Config.Crafting, recipe)
    TriggerClientEvent("vorp:UpdateRecipes", _source,  Config.Crafting)
end)

RegisterNetEvent("vorp:RemoveRecipes")
AddEventHandler("vorp:RemoveRecipes", function(recipe)
    local _source = source
    for k,v in pairs(Config.Crafting) do
        if v.Text == recipe.Text then
            table.remove(Config.Crafting, k)
            TriggerClientEvent("vorp:UpdateRecipes", _source,  Config.Crafting)
            break
        end
    end
end)

RegisterNetEvent("vorp:AddCraftLocation")
AddEventHandler("vorp:AddCraftLocation", function(location)
    local _source = source
    table.insert(Config.Locations, location)
    TriggerClientEvent("vorp:UpdateLocations", _source, Config.Locations)
end)

RegisterNetEvent("vorp:RemoveCraftLocation")
AddEventHandler("vorp:RemoveCraftLocation", function(location)
    local _source = source
    for k,v in pairs(Config.Locations) do
        if v.id == location.id then
            table.remove(Config.Locations, k)
            TriggerClientEvent("vorp:UpdateLocations", _source, Config.Locations)
            break
        end
    end
end)