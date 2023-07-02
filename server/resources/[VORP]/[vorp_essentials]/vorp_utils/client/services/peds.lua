PedAPI = {}

function PedAPI:Create(modelhash, x, y, z, heading, location, safeground, options)
    local PedClass = {}

    if CheckVar(safeground, true) then
        local valid, outPosition = GetSafeCoordForPed(x, y, z, false, 16)
        if valid then
            x = outPosition.x
            y = outPosition.y
            z = outPosition.z
        else
            print('Trying to spawn Ped in invalid location!')
            return nil
        end
    
        local foundground, groundZ, normal = GetGroundZAndNormalFor_3dCoord(x, y, z)
    
        if foundground then 
            z = groundZ
        else
            print("Trying to spawn Ped with no ground!")
            return nil
        end
    end

    local hash = GetHashKey(CheckVar(modelhash, "s_m_m_valdeputy_01"))
    while not HasModelLoaded(hash) do
        Wait(10)
        RequestModel(hash)
    end

    if location == nil or location == 'world' then
        PedClass.Ped = CreatePed(hash, x, y, z, CheckVar(heading, 0), true, true, 0, 0)
    elseif location == 'vehicle' then
        if options == nil or options.vehicle == nil then
            print('Vehicle is required to spawn a ped in a vehicle')
            return
        end

        local seats = {
            VS_ANY_PASSENGER = -2,
            VS_DRIVER = 0,
            VS_FRONT_RIGHT = 1,
            VS_BACK_LEFT = 2,
            VS_BACK_RIGHT = 3,
            VS_EXTRA_LEFT_1 = 4,
            VS_EXTRA_RIGHT_1 = 5,
            VS_EXTRA_LEFT_2 = 6,
            VS_EXTRA_RIGHT_2 = 6,
            VS_EXTRA_LEFT_3 = 7,
            VS_EXTRA_RIGHT_3 = 8,
            VS_NUM_SEATS = 8
        }

        PedClass.Ped = CreatePedInsideVehicle(options.vehicle, hash,  CheckVar(seats[options.seat], -2), 1, 1, 1)
    elseif location == 'mount' then
        if options == nil or options.mount == nil then
            print('mount is required to spawn a ped in a mount')
            return
        end

        PedClass.Ped = CreatePedOnMount(options.mount, hash, -1, true, true, true, true)
    else
        print("Error: Not a valid location for ped")
    end
    
    Citizen.InvokeNative(0x58A850EAEE20FAA3, PedClass.Ped)
    Citizen.InvokeNative(0x9587913B9E772D29, PedClass.Ped, true) --place entity on ground
    Citizen.InvokeNative(0x283978A15512B2FE, PedClass.Ped, true) --SetRandomOutfitVariation


    function PedClass:Freeze(state)
        FreezeEntityPosition(self.Ped, CheckVar(state, true))
    end

    function PedClass:Invincible(state)
        SetEntityInvincible(self.Ped, CheckVar(state, true))
    end

    function PedClass:CanBeDamaged(state)
        SetEntityCanBeDamaged(self.Ped, CheckVar(state, true))
    end

    function PedClass:SetHeading(head)
        SetEntityHeading(self.Ped, CheckVar(head, 0))
    end

    function PedClass:SeeingRange(range)
        SetPedSeeingRange(self.Ped, CheckVar(range, 70.0))
    end

    function PedClass:HearingRange(range)
        SetPedHearingRange(self.Ped, CheckVar(range, 80.0))
    end

    function PedClass:CanBeMounted(state)
        Citizen.InvokeNative(0x2D64376CF437363E, self.Ped, CheckVar(state, true)) --CanPedBeMounted
    end

    function PedClass:SetBlip(bliphash, title)
        local blip = Citizen.InvokeNative(0x23f74c2fda6e7c61, CheckVar(bliphash, 953018525), self.Ped)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, CheckVar(title, 'Ped'))
    end

    -- https://github.com/femga/rdr3_discoveries/blob/f729ba03f75a591ce5c841642dc873345242f612/weapons/weapons.lua
    function PedClass:GiveWeapon(weaponhash, ammocount, forceinhand, forceinholster, attachpoint, allowmultiplecopies, ignoreunlocks, permanentdegredation)
                     --  (ped, weaponhash, ammocount, forceinhand, forceinholster, attachpoint, allowmultiplecopies, p7, p8, reason, ignoreunlocks, permanentdegredation, p12)
        GiveWeaponToPed_2(self.Ped, CheckVar(weaponhash, 0x64356159), CheckVar(ammocount, 500), CheckVar(forceinhand, true), CheckVar(forceinholster, false), CheckVar(attachpoint, 3), CheckVar(allowmultiplecopies, false), 0.5, 1.0, 752097756,  CheckVar(ignoreunlocks, false), CheckVar(permanentdegredation, 0), false)
    end

    -- https://github.com/femga/rdr3_discoveries/tree/master/AI/FLEE_ATTRIBUTES
    function PedClass:FleeAtribute(flag, enabled)
        local options = {
            DISABLE_ENTER_VEHICLES = 4194304,
            DISABLE_MOUNT_USAGE = 1048576,
            FORCE_EXIT_VEHICLE = 65536,
            FLEE_ALL = 0
        }

        SetPedFleeAttributes(self.Ped, CheckVar(options[flag], 0), CheckVar(enabled, 0))
    end

    -- https://github.com/femga/rdr3_discoveries/tree/master/AI/COMBAT_ATTRIBUTES
    function PedClass:SetPedCombatAttributes(attributes, attackrange, abilitylevel, movement)
        if attributes == nil then
            attributes = {}
        end

        for index, attribute in ipairs(attributes) do
            -- SetPedCombatAttributes(self.Ped, 46, 1)
            -- https://vespura.com/doc/natives/?_0x9F7794730795E019
            SetPedCombatAttributes(self.Ped, attribute.flag, attribute.enabled)
        end


        SetPedCombatRange(self.Ped,  CheckVar(attackrange, 1))
        SetPedCombatAbility(self.Ped, CheckVar(abilitylevel, 0))

        -- 0 - Stationary (Will just stand in place)
        -- 1 - Defensive (Will try to find cover and very likely to blind fire)
        -- 2 - Offensive (Will attempt to charge at enemy but take cover as well)
        -- 3 - Suicidal Offensive (Will try to flank enemy in a suicidal attack)
        SetPedCombatMovement(self.Ped, CheckVar(movement, 0)) --https://vespura.com/doc/natives/?_0x4D9CA1009AFBD057
    end

    -- https://github.com/femga/rdr3_discoveries/tree/master/AI/COMBAT_STYLES
    function PedClass:SetCombatStyle(combathash, duration)
        Citizen.InvokeNative(0x8ACC0506743A8A5C, self.Ped, GetHashKey(CheckVar(combathash, 'SituationAllStop')), 1, CheckVar(duration, 240.0))
    end

    function PedClass:ClearCombatStyle()
        Citizen.InvokeNative(0x78815FC52832B690, self.Ped, 1) -- clear previous applied combat style for ped
    end

    function PedClass:AttackTarget(target, style)
        --styles: GUARD, COMBAT_ANIMAL, LAW, LAW_SHERIFF
        Citizen.InvokeNative(0xBD75500141E4725C, self.Ped, GetHashKey(CheckVar(style, 'LAW'))) -- SetPedCombatAttributeHash
        Citizen.InvokeNative(0xF166E48407BAC484, self.Ped, CheckVar(target, PlayerPedId()), 0, 16) -- TaskCombatPed --Atacks target
    end

    function PedClass:Remove()
        DeletePed(self.Ped)
        DeleteEntity(self.Ped)
    end

    function PedClass:GetPed()
        return self.Ped
    end

    return PedClass
end