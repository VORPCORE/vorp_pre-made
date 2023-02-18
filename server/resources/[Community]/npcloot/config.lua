-- by outsider

Config = {}

--name of items like in the DB
------------------------ ITEMS -----------------------------------
Config.canreceiveItems = false
Config.receiveItem = 20 -- percentage out of 100

Config.items = {
     { name = "Water", label = "Water" }, --you get a random item from the list
    { name = "ammorepeaternormal", label = "amoo repeater normal" },
    { name = "ammoriflenormal", label = "ammorifle normal" },
-- add more 
}


------------------------ MONEY -----------------------------------
Config.canreceiveMoney = false
Config.receiveMoney = 50 -- percentage out of 100

Config.money = { 0.5, 1,1.5} -- random amount from the list add more if needed 

------------------------ GOLD -----------------------------------
Config.canreceiveGold = false
Config.receiveGold = 5 -- percentage out of 100

Config.gold = {  1, 2, 3,}

----------------------- WEAPONS --------------------------------------
Config.canreceiveWeapons = true
Config.receiveWeapon = 10 -- percentage 1 out of 10
Config.weapons = {
    { name = "WEAPON_REVOLVER_CATTLEMAN", label = "Revolver cattleman" }, --you get a random weapon from the list
    { name = "WEAPON_REPEATER_CARBINE", label = "Repeater Carbine" },
    { name = "WEAPON_RIFLE_VARMINT", label = "Rifle Varmint" }
}
