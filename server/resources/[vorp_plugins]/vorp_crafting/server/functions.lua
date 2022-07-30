-- Security update to ensure no client modifies what a recipe is
function getServerCraftable(craftable)
    local crafting = nil
    for k,v in ipairs(Config.Crafting) do
        if v.Text == craftable.Text then
            crafting = v
            break
        end
    end

    return crafting
end