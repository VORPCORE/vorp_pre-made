AddEventHandler("vorp:AddRecipes", function(userid, recipe)
    local _source = userid
    table.insert(Config.Crafting, recipe)
    TriggerClientEvent("vorp:UpdateRecipes", _source,  Config.Crafting)
end)

AddEventHandler("vorp:RemoveRecipes", function(userid, recipe)
    local _source = userid
    for k,v in pairs(Config.Crafting) do
        if v.Text == recipe.Text then
            table.remove(Config.Crafting, k)
            TriggerClientEvent("vorp:UpdateRecipes", _source,  Config.Crafting)
            break
        end
    end
end)