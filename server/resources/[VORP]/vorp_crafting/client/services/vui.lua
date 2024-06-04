uiopen = false

VUI = {}

-- openUI
VUI.OpenUI = function(location)
    local allText = _all()

    if allText then
        uiopen = true
        local Categories = {}

        if location.Categories == 0 or location.Categories == nil then
            Categories = Config.Categories
        else
            for keyloc, loccat in pairs(location.Categories) do
                for keycat, cat in ipairs(Config.Categories) do
                    if loccat == cat.ident then
                        Categories[#Categories + 1] = cat
                        break
                    end
                end
            end
        end

        if Config.KneelingAnimation then
            Animations.forceRestScenario(true)
        end
        SendNUIMessage({
            type = 'vorp-craft-open',
            craftables = Config.Crafting,
            categories = Categories,
            crafttime = Config.CraftTime,
            style = Config.Styles,
            language = allText,
            location = location,
            job = LocalPlayer.state.Character.Job
        })
        SetNuiFocus(true, true)
    end
end

VUI.Animate = function()
    SendNUIMessage({
        type = 'vorp-craft-animate'
    })
    SetNuiFocus(true, false)
end

VUI.Refocus = function()
    SetNuiFocus(true, true)
end

RegisterNUICallback('vorp-craft-close', function(args, cb)
    SetNuiFocus(false, false)
    uiopen = false
    if Config.KneelingAnimation then
        Animations.forceRestScenario(false)
    end
    cb('ok')
end)

RegisterNUICallback('vorp-openinv', function(args, cb)
    TriggerServerEvent('vorp:openInv')
    cb('ok')
end)

RegisterNUICallback('vorp-craftevent', function(args, cb)
    local count = tonumber(args.quantity)
    if count ~= nil and count ~= 'close' and count ~= '' and count > 0 then
        TriggerServerEvent('vorp:startcrafting', args.craftable, count, args.location)
        cb('ok')
    else
        TriggerEvent("vorp:TipBottom", _U('InvalidAmount'), 4000)
        cb('invalid')
    end
end)
