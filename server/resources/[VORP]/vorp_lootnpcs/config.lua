Config = {}

-- Enable or disable the chance to receive ITEMS
Config.canReceiveItems = false -- true | false
Config.receiveItem = 20        -- If below this number, then can receive
Config.chanceGettingItem = 100 -- Percentage out of 100
Config.items = {               -- You will receive a random item from the list
    { name = "Water",              label = "Water",                amount = 1 },
    { name = "ammorepeaternormal", label = "Normal Ammo Repeater", amount = 1 },
    { name = "ammoriflenormal",    label = "Normal Ammo Rifle",    amount = 1 },
}

-- Enable or disable the chance to receive MONEY
Config.canReceiveMoney = false  -- true | false
Config.receiveMoney = 50        -- If below this number, then can receive
Config.chanceGettingMoney = 100 -- Percentage out of 100
Config.money = { 0.5, 1, 1.5 }  -- You will receive a random value from the list

-- Enable or disable the chance to receive GOLD
Config.canReceiveGold = false -- true | false
Config.receiveGold = 5        -- If below this number, then can receive
Config.chanceGettingGold = 10 -- Percentage out of 100
Config.gold = { 1, 2, 3 }     -- You will receive a random value from the list

-- Enable or disable the chance to receive WEAPONS
Config.canReceiveWeapons = true  -- true | false
Config.receiveWeapon = 10        -- If below this number, then can receive
Config.chanceGettingWeapon = 100 -- Percentage out of 100
Config.weapons = {               -- You will receive a random weapon from the list
    { name = "WEAPON_REVOLVER_CATTLEMAN", label = "Cattleman Revolver" },
    { name = "WEAPON_REPEATER_CARBINE",   label = "Carbine Repeater" },
    { name = "WEAPON_RIFLE_VARMINT",      label = "Varmint Rifle" }
}

-- Translations
Config.Translate = {
    invFullWeapon = "You can't carry any more WEAPONS",
    invFullItems = "You can't carry any more ITEMS",
    youGot = "You got",
    nugget = "nugget"
}
