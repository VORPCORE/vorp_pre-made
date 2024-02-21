local storage = {
    x = nil,
    y = nil,
    z = nil,
    xr = nil,
    yr = nil,
    zr = nil,
    name = nil
}

exports('initiate', function()
    Animations = {}
    -- Props
    local mainprop
    local subprops = {}
    local Anims = Config.Animations

    local customprop
    local prop

    Animations.proptest = function() --USED FOR DEVTOOLS
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        if mainprop then
            DeleteObject(mainprop)
        end

        mainprop = CreateObject(prop.model, coords.x, coords.y, coords.z, true, true, false, false, true)
        local boneIndex = GetEntityBoneIndexByName(ped, prop.bone)
        AttachEntityToEntity(mainprop, ped, boneIndex, storage.x, storage.y, storage.z, storage.xr, storage.yr,
            storage.zr, true, true, false, true, 1, true)
    end

    Animations.startAnimation = function(anim)
        local ped = PlayerPedId()
        local animation = Anims[anim]
        if not DoesAnimDictExist(animation.dict) then
            return
        end

        prop = animation.prop

        if customprop then
            prop = customprop
        end

        if prop then
            local coords = GetEntityCoords(ped)
            mainprop = CreateObject(prop.model, coords.x, coords.y, coords.z, true, true, false, false, true)
            local boneIndex = GetEntityBoneIndexByName(ped, prop.bone)
            AttachEntityToEntity(mainprop, ped, boneIndex, prop.coords.x, prop.coords.y, prop.coords.z, prop.coords.xr,
                prop.coords.yr, prop.coords.zr, true, true, false, true, 1, true)

            if prop.subprops then
                for i, v in ipairs(prop.subprops) do
                    local pcoords = GetEntityCoords(subprops[i])
                    subprops[i] = CreateObject(v.model, pcoords.x, pcoords.y, pcoords.z, true, true, false, false, true)
                    AttachEntityToEntity(subprops[i], ped, boneIndex, v.coords.x, v.coords.y, v.coords.z, v.coords.xr,
                        v.coords.yr, v.coords.zr, true, true, false, true, 1, true)
                end
            end
        end

        if animation.type == 'scenario' then
            TaskStartScenarioInPlace(ped, GetHashKey(animation.hash), 12000, true, false, false, false)
        elseif animation.type == 'standard' then
            RequestAnimDict(animation.dict)

            while not HasAnimDictLoaded(animation.dict) do
                Wait(0)
            end
            TaskPlayAnim(ped, animation.dict, animation.name, 1.0, 1.0, -1, animation.flag, 1.0, false, false, false,
                '', false)
        end

        if Config.DevTools == true then
            storage = {
                x = prop.coords.x,
                y = prop.coords.y,
                z = prop.coords.z,
                xr = prop.coords.xr,
                yr = prop.coords.yr,
                zr = prop.coords.zr,
                name = anim
            }
        end
    end

    Animations.endAnimation = function(anim)
        local animation = Anims[anim]
        RemoveAnimDict(animation.dict)
        StopAnimTask(PlayerPedId(), animation.dict, animation.name, 1.0)

        if mainprop then
            DeleteObject(mainprop)
        end

        if #subprops > 0 then
            for i, subprop in ipairs(subprops) do
                DeleteObject(subprop)
            end
        end

        customprop = nil
    end

    Animations.endAnimations = function()
        ClearPedTasksImmediately(PlayerPedId())

        customprop = nil
    end

    Animations.forceRestScenario = function(val)
        Citizen.InvokeNative(0xE5A3DD2FF84E1A4B, val)
    end

    Animations.playAnimation = function(anim, time)
        if time == nil then
            time = 8000
        end

        Animations.startAnimation(anim)
        Citizen.Wait(time)

        Animations.endAnimation(anim)
    end

    Animations.setCustomProp = function(val)
        customprop = val
    end

    Animations.registerAnimation = function(name, animation)
        Anims[name] = animation
    end

    Animations.registerAnimations = function(animationTables)
        for name, animation in pairs(animationTables) do
            Anims[name] = animation
        end
    end

    return Animations
end)


if Config.DevTools == true then
    DevAnimations = exports.vorp_animations.initiate()

    RegisterCommand("testanimation", function(source, args, rawCommand)
        DevAnimations.playAnimation(args[1], 8000)
    end)

    function Dump(o)
        if type(o) == 'table' then
            local s = '{ '
            for k, v in pairs(o) do
                if type(k) ~= 'number' then
                    k = '"' .. k .. '"'
                end
                s = s .. '[' .. k .. '] = ' .. Dump(v) .. ','
            end
            return s .. '} '
        else
            return tostring(o)
        end
    end
    RegisterCommand("printcoords", function(source, args, rawCommand)
        print(Dump(storage))
    end)
    local toggle = false
    RegisterCommand("startanimation", function(source, args, rawCommand)
        DevAnimations.startAnimation(args[1])

        SendNUIMessage({
            type = 'open',
            storage = storage
        })
        toggle = true
        SetNuiFocus(true, true)
    end)

    RegisterCommand("endanimation", function(source, args, rawCommand)
        DevAnimations.endAnimation(args[1])

        SendNUIMessage({
            type = 'close',
            storage = storage
        })
        toggle = false
        SetNuiFocus(false, false)
    end)

    RegisterCommand("focus", function(source, args, rawCommand)
        toggle = not toggle
        SetNuiFocus(toggle, toggle)
    end)

    RegisterNUICallback('focus', function(args, cb)
        toggle = not toggle
        SetNuiFocus(toggle, toggle)
        cb('ok')
    end)

    RegisterNUICallback('stop', function(args, cb)
        toggle = false
        SetNuiFocus(false, false)

        DevAnimations.endAnimation(storage.name)
        cb('ok')
    end)

    -- DONT DO THIS< THIS IS JUST FOR TESTING
    RegisterNUICallback('pressed', function(args, cb)
        local what = args.what
        local type = args.type
        local modifier = args.mod

        if type == 'dec' then
            storage[what] = storage[what] - modifier
        else
            storage[what] = storage[what] + modifier
        end

        DevAnimations.proptest()

        SendNUIMessage({
            type = 'update',
            storage = storage
        })

        cb('ok')
    end)
end
