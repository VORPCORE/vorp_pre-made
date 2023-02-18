VorpCore = {}
local VorpInv

TriggerEvent("getCore", function(core)
    VorpCore = core
end)

VorpInv = exports.vorp_inventory:vorp_inventoryApi()


-- Register usable Campfire
VorpInv.RegisterUsableItem("campfire", function(data)
    VorpInv.subItem(data.source, "campfire", 1)
    TriggerClientEvent("vorp:campfire", data.source)
end)

RegisterServerEvent('vorp:findjob')
AddEventHandler('vorp:findjob', function()
    local _source = source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local job = Character.job
    TriggerClientEvent("vorp:setjob", _source, job)
end)

RegisterServerEvent('vorp:openInv')
AddEventHandler('vorp:openInv', function()
    local _source = source
    VorpInv.OpenInv(_source)
end)

RegisterServerEvent('vorp:startcrafting')
AddEventHandler('vorp:startcrafting', function(craftable, countz)
    local _source = source
    local Character = VorpCore.getUser(_source).getUsedCharacter

    local crafting = getServerCraftable(craftable)

    if not crafting then
        print("Recipe not found on server")
        return
    end

    local playerjob = Character.job
    local job = crafting['Job']

    local craft = false

    -- No job restriction
    if job == 0 then
        craft = true
    end

    -- Job restrictions active
    if job ~= 0 then
        for k, v in pairs(job) do
            if v == playerjob then
                craft = true
            end
        end
    end

    if craft then
        if crafting then
            -- Check that the user has all crafting items available
            local reward = crafting['Reward']

            local craftcheck = true
            for index, item in pairs(crafting.Items) do
                local pcount = VorpInv.getItemCount(source, item.name)
                local icount = item.count * countz

                if pcount < icount then
                    craftcheck = false
                    break
                end
            end

            if craftcheck == true then
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

                    -- Check that the user can carry weapons
                    VorpInv.canCarryWeapons(_source, count * countz, function(canCarryWeapons)
                        if canCarryWeapons  then
                            -- Delete items to crafting

                            if crafting.TakeItems == nil or crafting.TakeItems == true then
                                for index, item in pairs(crafting.Items) do
                                    if item.take == nil or item.take == true then
                                        VorpInv.subItem(_source, item.name, item.count * countz)
                                    end
                                end
                            end

                            -- Give weapons from the crafting list
                            for i = 1, countz do
                                for k, v in pairs(reward) do
                                    for i = 1, v.count do
                                        VorpInv.createWeapon(_source, v.name, ammo, components)
                                        VorpCore.AddWebhook(GetPlayerName(_source), Config.Webhook, _U('WebhookWeapon')..' '..v.name)
                                    end
                                end
                            end

                            TriggerClientEvent("vorp:crafting", _source, crafting.Animation)
                        else
                            TriggerClientEvent("vorp:TipRight", _source, _U('WeaponsFull'), 3000)

                        end
                    end)
                elseif crafting.Type == "item" then
                    local addcount = 0

                    if not crafting.UseCurrencyMode then
                        for k, rwd in pairs(reward) do
                            local counta = rwd.count * countz
                            addcount = addcount + counta
                            cancarry = VorpInv.canCarryItem(_source, rwd.name, counta)
                        end
                    end

                    -- Check if there is enought room in inventory in general
                    local invAvailable = VorpInv.canCarryItems(_source, addcount - subcount)
                    if crafting.UseCurrencyMode or (invAvailable and cancarry) then

                        if crafting.TakeItems == nil or crafting.TakeItems == true then
                            -- Loop through and remove each item
                            for index, item in pairs(crafting.Items) do
                                if item.take == nil or item.take == true then
                                    VorpInv.subItem(_source, item.name, item.count * countz)
                                end
                            end
                        end

                        -- Give crafted item(s) to player
                        for k, v in pairs(crafting.Reward) do
                            local countx = v.count * countz
                            if crafting.UseCurrencyMode ~= nil and crafting.CurrencyType ~= nil and crafting.UseCurrencyMode then
                                Character.addCurrency(crafting.CurrencyType, countx)
                            else
                                VorpInv.addItem(_source, v.name, countx)
                                VorpCore.AddWebhook(GetPlayerName(_source), Config.Webhook, _U('WebhookItem')..' x'..countx..' '..v.name)
                            end
                        end

                        TriggerClientEvent("vorp:crafting", _source, crafting.Animation)
                    else
                        TriggerClientEvent("vorp:TipRight", _source, _U('TooFull'), 3000)
                    end
                end
            else
                TriggerClientEvent("vorp:TipRight", _source, _U('NotEnough'), 3000)
            end
        end
        
    else
        TriggerClientEvent("vorp:TipRight", _source, _U('NotJob'), 3000)
    end
end)