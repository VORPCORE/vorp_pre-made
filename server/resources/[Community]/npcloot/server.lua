local VORPcore = {}
local Inventory
local money = Config.money
local gold = Config.gold

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

Inventory = exports.vorp_inventory:vorp_inventoryApi()

local function Keysx(table)
    local keys = 0
    for k, v in pairs(table) do
        keys = keys + 1
    end
    return keys
end

RegisterServerEvent('npcloot:give_reward', function()
    local _source = source
    local chance = math.random(1, 100)
    local Character = VORPcore.getUser(_source).getUsedCharacter

    if not Config.canreceiveWeapons then
        goto continue
    end

    if chance < Config.receiveWeapon then
        local ammo = { ["nothing"] = 0 }
        local reward1 = {}

        for k, v in pairs(Config.weapons) do
            table.insert(reward1, v)
        end
        local chance1 = math.random(1, Keysx(reward1))
        local canCarry = Inventory.canCarryWeapons(_source, 1)

        if not canCarry then
            return VORPcore.NoifyRightTip(_source, "You can't carry any more WEAPONS", 3000)
        end

        Inventory.createWeapon(_source, reward1[chance1].name, ammo, {})
        VORPcore.NoifyRightTip(_source, "You got " .. reward1[chance1].label, 3000)
    end

    ::continue::

    if not Config.canreceiveMoney then
        goto continue1
    end

    if chance < Config.receiveMoney then
        local item_type = math.random(1, #money)
        Character.addCurrency(0, money[item_type])
        VORPcore.NoifyRightTip(_source, "you got " .. string.format("%.2f", money[item_type]) .. "$", 2000)
    end

    ::continue1::

    if not Config.canreceiveGold then
        goto continue2
    end

    if chance < Config.receiveGold then
        local item_type = math.random(1, #gold)
        Character.addCurrency(1, gold[item_type])
        VORPcore.NoifyRightTip(_source, "you got " .. gold[item_type] .. " nugget.", 2000)
    end

    ::continue2::

    if not Config.canreceiveItems then
        return
    end


    if chance < Config.receiveItem then
        local reward = {}

        for k, v in pairs(Config.items) do
            table.insert(reward, v)
        end

        local chance2 = math.random(1, Keysx(reward))
        local count = 1
        local canCarry = Inventory.canCarryItems(_source, count) --can carry inv space
        local canCarry2 = Inventory.canCarryItem(_source, reward[chance2].name, count) --cancarry item limit

        if not canCarry then
            return VORPcore.NoifyRightTip(_source, "You can't carry any more " .. reward[chance2].label, 30000)
        end

        if not canCarry2 then
            return VORPcore.NoifyRightTip(_source, "You can't carry any more " .. reward[chance2].label, 30000)
        end

        Inventory.addItem(_source, reward[chance2].name, count)
        VORPcore.NoifyRightTip(_source, "You got " .. reward[chance2].label, 3000)
    end
end)
