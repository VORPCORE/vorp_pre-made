local Core = exports.vorp_core:GetCore()
local VorpInv = exports.vorp_inventory:vorp_inventoryApi()

CreateThread(function()
    local item = Config.CampFireItem
    exports.vorp_inventory:registerUsableItem(item, function(data)
        VorpInv.subItem(data.source, item, 1)
        TriggerClientEvent("vorp:campfire", data.source)
    end)
end)


Core.Callback.Register("vorp_crafting:GetJob", function(source, cb)
    local Character = Core.getUser(source).getUsedCharacter
    local job = Character.job
    cb(job)
end)

RegisterNetEvent('vorp:openInv', function()
    local _source = source
    exports.vorp_inventory:openInventory(_source)
end)

RegisterNetEvent('vorp:startcrafting', function(craftable, countz)
    local _source = source
    local Character = Core.getUser(_source).getUsedCharacter

    local function getServerCraftable(craftable)
        local crafting = nil
        for k, v in ipairs(Config.Crafting) do
            if v.Text == craftable.Text then
                crafting = v
                break
            end
        end

        return crafting
    end

    local crafting = getServerCraftable(craftable)

    if not crafting then
        print("Recipe not found on server")
        return
    end

    local playerjob = Character.job
    local job = crafting.Job
    local craft = false

    if job == 0 then
        craft = true
    end

    if job ~= 0 then
        for k, v in pairs(job) do
            if v == playerjob then
                craft = true
            end
        end
    end

    if not craft then
        Core.NotifyObjective(_source, _U('NotJob'), 5000)
        return
    end

    if not crafting then
        return
    end

    local reward = crafting.Reward

    local craftcheck = true
    for index, item in pairs(crafting.Items) do
        local pcount = exports.vorp_inventory:getItemCount(_source, nil, item.name)
        local icount = item.count * countz
        if pcount < icount then
            craftcheck = false
            break
        end
    end

    if not craftcheck then
        return Core.NotifyObjective(_source, _U('NotEnough'), 5000)
    end

    -- Get Totals
    local subcount = 0
    local cancarry = false
    for index, item in pairs(crafting.Items) do
        local itemcount = item.count * countz
        subcount = subcount + itemcount
    end

    -- Differentiate between items and weapons
    if crafting.Type == "weapon" then
        local ammo = { ["nothing"] = 0 }
        local components = {}

        local count = 0

        for k, rwd in pairs(crafting.Reward) do
            count = count + rwd.count
        end
        local canCarry = exports.vorp_inventory:canCarryWeapons(_source, count * countz)
        if not canCarry then
            return Core.NotifyObjective(_source, _U('WeaponsFull'), 5000)
        end

        if crafting.TakeItems == nil or crafting.TakeItems == true then
            for index, item in pairs(crafting.Items) do
                if item.take == nil or item.take == true then
                    exports.vorp_inventory:subItem(_source, item.name, item.count * countz)
                end
            end
        end

        -- Give weapons from the crafting list
        for i = 1, countz do
            for k, v in pairs(reward) do
                for i = 1, v.count do
                    exports.vorp_inventory:createWeapon(_source, v.name, ammo, components)
                    Core.AddWebhook(GetPlayerName(_source), Config.Webhook, _U('WebhookWeapon') .. ' ' .. v.name)
                end
            end
        end

        TriggerClientEvent("vorp:crafting", _source, crafting.Animation)
    elseif crafting.Type == "item" then
        local addcount = 0

        if not crafting.UseCurrencyMode then
            for k, rwd in pairs(reward) do
                local counta = rwd.count * countz
                addcount     = addcount + counta
                cancarry     = exports.vorp_inventory:canCarryItem(_source, rwd.name, counta)
            end
        end

        if crafting.UseCurrencyMode or cancarry then
            if crafting.TakeItems == nil or crafting.TakeItems == true then
                -- Loop through and remove each item
                for index, item in pairs(crafting.Items) do
                    if item.take == nil or item.take == true then
                        exports.vorp_inventory:subItem(_source, item.name, item.count * countz)
                    end
                end
            end

            -- Give crafted item(s) to player
            for k, v in pairs(crafting.Reward) do
                local countx = v.count * countz
                if crafting.UseCurrencyMode ~= nil and crafting.CurrencyType ~= nil and crafting.UseCurrencyMode then
                    Character.addCurrency(crafting.CurrencyType, countx)
                else
                    exports.vorp_inventory:addItem(_source, v.name, countx)
                    Core.AddWebhook(GetPlayerName(_source), Config.Webhook,
                        _U('WebhookItem') .. ' x' .. countx .. ' ' .. v.name)
                end
            end

            TriggerClientEvent("vorp:crafting", _source, crafting.Animation)
        else
            TriggerClientEvent("vorp:TipRight", _source, _U('TooFull'), 3000)
        end
    end
end)
