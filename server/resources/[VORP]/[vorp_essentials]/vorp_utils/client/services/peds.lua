PedAPI = {}

---@param modelhash type<string, number>
---@param x any
---@param y any
---@param z any
---@param heading any
---@param location type <string>
---@param safeground type <boolean>
---@param options type <table <string>>
---@param outfit type <boolean>
---@param networked type <boolean, nil>
---@param vector4 any
---@return type <table, nil>
function PedAPI:Create(modelhash, x, y, z, heading, location, safeground, options, outfit, networked, vector4)
    local PedClass = {}

    if not x and not y and not z and not heading then
        x, y, z, heading = table.unpack(vector4)
    end

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

    if not Shared:LoadModel(modelhash) then
        return nil
    end

    local hash
    if type(modelhash) == "string" then
        hash = joaat(modelhash)
    end


    if location == nil or location == 'world' then
        if networked == nil then
            networked = false
        end

        PedClass.Ped = CreatePed(hash, x, y, z, CheckVar(heading, 0), networked, true, false, false)

        while not DoesEntityExist(PedClass.Ped) do
            Wait(10)
        end
    elseif location == 'vehicle' then
        if options == nil or options.vehicle == nil then
            print('Vehicle is required to spawn a ped in a vehicle')
            return nil
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

        PedClass.Ped = CreatePedInsideVehicle(options.vehicle, hash, CheckVar(seats[options.seat], -2), networked or true,
            true, true)
        while not DoesEntityExist(PedClass.Ped) do
            Wait(10)
        end
    elseif location == 'mount' then
        if options == nil or options.mount == nil then
            print('mount is required to spawn a ped in a mount')
            return nil
        end

        PedClass.Ped = CreatePedOnMount(options.mount, hash, -1, true, true, true, true)
        while not DoesEntityExist(PedClass.Ped) do
            Wait(10)
        end
    else
        print("Error: Not a valid location for ped")
    end -- ApplyPedMetapedOutfit
    SetModelAsNoLongerNeeded(hash)
    Citizen.InvokeNative(0x58A850EAEE20FAA3, PedClass.Ped)
    Citizen.InvokeNative(0x9587913B9E772D29, PedClass.Ped, true) --place entity on ground


    if outfit then
        -- local metaped_outfit = Citizen.InvokeNative(0x13154A76CE0CF9AB, hash, outfit, Citizen.ResultAsInteger()) -- RequestMetapedOutfit
        Citizen.InvokeNative(0x283978A15512B2FE, PedClass.Ped, true)
        Citizen.InvokeNative(
            0x1902C4CFCC5BE57C,
            PedClass.Ped,
            outfit --[[ Hash ]]
        )

        Citizen.InvokeNative(
            0xCC8CA3E88256E58F,
            PedClass.Ped --[[ Ped ]]
        )
    else
        Citizen.InvokeNative(0x283978A15512B2FE, PedClass.Ped, true) --SetRandomOutfitVariation
    end


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
    function PedClass:GiveWeapon(weaponhash, ammocount, forceinhand, forceinholster, attachpoint, allowmultiplecopies,
                                 ignoreunlocks, permanentdegredation)
        --  (ped, weaponhash, ammocount, forceinhand, forceinholster, attachpoint, allowmultiplecopies, p7, p8, reason, ignoreunlocks, permanentdegredation, p12)
        GiveWeaponToPed_2(self.Ped, CheckVar(weaponhash, 0x64356159), CheckVar(ammocount, 500),
            CheckVar(forceinhand, true), CheckVar(forceinholster, false), CheckVar(attachpoint, 3),
            CheckVar(allowmultiplecopies, false), 0.5, 1.0, 752097756, CheckVar(ignoreunlocks, false),
            CheckVar(permanentdegredation, 0), false)
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


        SetPedCombatRange(self.Ped, CheckVar(attackrange, 1))
        SetPedCombatAbility(self.Ped, CheckVar(abilitylevel, 0))

        -- 0 - Stationary (Will just stand in place)
        -- 1 - Defensive (Will try to find cover and very likely to blind fire)
        -- 2 - Offensive (Will attempt to charge at enemy but take cover as well)
        -- 3 - Suicidal Offensive (Will try to flank enemy in a suicidal attack)
        SetPedCombatMovement(self.Ped, CheckVar(movement, 0)) --https://vespura.com/doc/natives/?_0x4D9CA1009AFBD057
    end

    -- https://github.com/femga/rdr3_discoveries/tree/master/AI/COMBAT_STYLES
    function PedClass:SetCombatStyle(combathash, duration)
        Citizen.InvokeNative(0x8ACC0506743A8A5C, self.Ped, GetHashKey(CheckVar(combathash, 'SituationAllStop')), 1,
            CheckVar(duration, 240.0))
    end

    function PedClass:ClearCombatStyle()
        Citizen.InvokeNative(0x78815FC52832B690, self.Ped, 1) -- clear previous applied combat style for ped
    end

    function PedClass:AttackTarget(target, style)
        --styles: GUARD, COMBAT_ANIMAL, LAW, LAW_SHERIFF
        Citizen.InvokeNative(0xBD75500141E4725C, self.Ped, GetHashKey(CheckVar(style, 'LAW')))     -- SetPedCombatAttributeHash
        Citizen.InvokeNative(0xF166E48407BAC484, self.Ped, CheckVar(target, PlayerPedId()), 0, 16) -- TaskCombatPed --Atacks target
    end

    function PedClass:Remove()
        DeletePed(self.Ped)
        DeleteEntity(self.Ped)
        Citizen.InvokeNative(0x5E94EA09E7207C16, self.Ped) --Delete Entity
    end

    function PedClass:GetPed()
        return self.Ped
    end

    function PedClass:AddPedToGroup(group)
        SetPedAsGroupMember(self.Ped, CheckVar(group, GetPedGroupIndex(PlayerPedId())))
        return self.Ped
    end

    function PedClass:FollowToOffsetOfEntity(entity, offsetX, offsetY, offsetZ, movementSpeed, timeout, stoppingRange,
                                             persistFollowing, p9, walkOnly)
        TaskFollowToOffsetOfEntity(self.Ped, CheckVar(entity, PlayerPedId()), offsetX, offsetY, offsetZ, movementSpeed,
            timeout, stoppingRange, persistFollowing, p9, walkOnly, 0, 0, 1)
        return self.Ped
    end

    function PedClass:SetRelationshipWithGroup(relationship, group)
        SetRelationshipBetweenGroups(relationship, GetPedRelationshipGroupHash(self.Ped), group)
    end

    function PedClass:SetAttributePoints(attribute, value)
        Citizen.InvokeNative(0x09A59688C26D88DF, self.Ped, attribute, value)
    end

    function PedClass:AddAttributePoints(attribute, value)
        Citizen.InvokeNative(0x75415EE0CB583760, self.Ped, attribute, value)
    end

    function PedClass:SetAttributeBaseRank(attribute, value)
        Citizen.InvokeNative(0x5DA12E025D47D4E5, self.Ped, attribute, value)
    end

    function PedClass:SetAttributeBonousRank(attribute, value)
        Citizen.InvokeNative(0x920F9488BD115EFB, self.Ped, attribute, value)
    end

    function PedClass:SetAttributeOverpower(attribute, value, makesound)
        Citizen.InvokeNative(0xF6A7C08DF2E28B28, self.Ped, attribute, value, makesound)
    end

    function PedClass:GetTaskStatus(task)
        return GetScriptTaskStatus(self.Ped, task)
    end

    function PedClass:ClearTasks()
        ClearPedTasks(self.Ped)
    end

    function PedClass:IsDead()
        IsEntityDead(self.Ped)
    end

    function PedClass:ChangeOutfit(outfit)
        Citizen.InvokeNative(0x283978A15512B2FE, self.Ped, true)
        Citizen.InvokeNative(
            0x1902C4CFCC5BE57C,
            self.Ped,
            outfit --[[ Hash ]]
        )

        Citizen.InvokeNative(
            0xCC8CA3E88256E58F,
            self.Ped --[[ Ped ]]
        )
    end

    return PedClass
end
