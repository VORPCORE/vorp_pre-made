Config = {}

Config.languageCode = "en";

Config.banks = {
    Valentine = {
        name = "Valentine Bank",
        x = -308.50, y = 776.24, z = 118.75,
        city = "Valentine",
        blipsprite = -2128054417,
        blipAllowed = true,
        NpcAllowed = true,
        NpcModel = "S_M_M_BankClerk_01",
        Nx = -308.02, Ny = 773.82, Nz = 116.7, Nh = 18.69, --npc positions {x = -308.02, y = 773.82, z = 118.7}
        StoreHoursAllowed = true,
        StoreOpen = 7, -- am
        StoreClose = 22, -- pm
        distOpen = 1.5,
        gold = true, -- if you want deposit and withdraw gold
        items = true, -- if you want use safebox
        upgrade = true, -- if you want upgrade safebox
        costslot = 10, -- choose price for upgrade + 1 slot
        maxslots = 100, -- choose max slots for upgrade

        --------------------- 
        --ONLY ONE CAN BE TRUE 
        useitemlimit = false, -- if TRUE you can store any items and the items in the list will have a limit. can be weapons too if false will use without limit and you can ignore the list
        usespecificitem = false, -- if TRUE only the items in the list will work any other items not in the list wont be able to store in the safebox SET THE ABOVE TO FALSE
        -----------------------------------------

        itemlist = { 
            ammorevolvernormal = 3, -- name = count
            WEAPON_MELEE_KNIFE = 1
        },

    },
    Blackwater = {
        name = "Blackwater Bank",
        x = -813.18, y = -1277.60,
        z = 43.68,
        city = "Blackwater",
        blipsprite = -2128054417,
        blipAllowed = true,
        NpcAllowed = true,
        NpcModel = "S_M_M_BankClerk_01",
        Nx = -813.18, Ny = -1275.42, Nz = 42.64, Nh = 176.86, --npc positions
        StoreHoursAllowed = true,
        StoreOpen = 7, -- am
        StoreClose = 21, -- pm
        distOpen = 1.5,
        gold = true,
        items = true,
        upgrade = true,
        costslot = 10,
        maxslots = 100,

        --------------------- ONLY 1 MUST BE TRUE or ALL 2 FALSE(no limits in bank)
        useitemlimit = false, -- if TRUE limit only items above
        usespecificitem = false, -- if TRUE deposit only items above
        -----------------------------------------

        itemlist = { 
            ammorevolvernormal = 3, -- name = count
            WEAPON_MELEE_KNIFE = 1
        },

    },
    STdenis = {
        name = "Saint Denis Bank",
        x = 2644.08, y = -1292.21, z = 52.29,
        city = "Saint Denis",
        blipsprite = -2128054417,
        blipAllowed = true,
        NpcAllowed = true,
        NpcModel = "S_M_M_BankClerk_01",
        Nx = 2645.12, Ny = -1294.37, Nz = 51.25, Nh = 30.64, --npc positions
        StoreHoursAllowed = true,
        StoreOpen = 7, -- am
        StoreClose = 23, -- pm
        distOpen = 1.5,
        gold = true,
        items = true,
        upgrade = true,
        costslot = 10,
        maxslots = 100,

        --------------------- ONLY 1 MUST BE TRUE or ALL 2 FALSE(no limits in bank)
        useitemlimit = false, -- if TRUE limit only items above
        usespecificitem = false, -- if TRUE deposit only items above
        -----------------------------------------

        itemlist = { 
            ammorevolvernormal = 3, -- name = count
            WEAPON_MELEE_KNIFE = 1
        },

    },
    Rhodes = {
        name = "Rhodes Bank",
        x = 1294.14, y = -1303.06, z = 77.04,
        city = "Rhodes",
        blipsprite = -2128054417,
        blipAllowed = true,
        NpcAllowed = true,
        NpcModel = "S_M_M_BankClerk_01",
        Nx = 1292.84, Ny = -1304.74, Nz = 76.04, Nh = 327.08, --npc positions
        StoreHoursAllowed = true,
        StoreOpen = 7, -- am
        StoreClose = 21, -- pm
        distOpen = 1.5,
        gold = false,
        items = false,
        upgrade = false,
        costslot = 10,
        maxslots = 50,

        --------------------- ONLY 1 MUST BE TRUE or ALL 2 FALSE(no limits in bank)
        useitemlimit = false, -- if TRUE limit only items above
        usespecificitem = false, -- if TRUE deposit only items above
        -----------------------------------------

        itemlist = { 
            ammorevolvernormal = 3, -- name = count
            WEAPON_MELEE_KNIFE = 1
        },

    },
}

Config.adminwebhook  = ""
Config.webhookavatar = "https://www.pngmart.com/files/5/Bank-PNG-Transparent-Picture.png"

Config.Key  = 0x760A9C6F --[G]

-- Set correct language table
Config.language = Languages[Config.languageCode]

Config.Doors = {
    [2642457609] = 0, -- Valentine bank, front entrance, left door
    [3886827663] = 0, -- Valentine bank, front entrance, right door
    [1340831050] = 0, -- Valentine bank, gate to tellers
    [576950805]  = 0, -- Valentine bank, vault door
    [3718620420] = 0, -- Valentine bank, door behind tellers
    [2343746133] = 0, -- Valentine bank, door to backrooms
    [2307914732] = 0, -- Valentine bank, back door
    [334467483]  = 0, -- Valentine bank, door to hall in vault antechamber

    [1733501235] = 0, -- Saint Denis bank, west entrance, right door
    [2158285782] = 0, -- Saint Denis bank, west entrance, left door
    [1634115439] = 0, -- Saint Denis bank, manager's office, right door
    [965922748]  = 0, -- Saint Denis bank, manager's office, left door
    [2817024187] = 0, -- Saint Denis bank, north entrance, left door
    [2089945615] = 0, -- Saint Denis bank, north entrance, right door
    [1751238140] = 0, -- Saint Denis bank, vault

    [531022111]  = 0, -- Blackwater bank, entrance
    [2817192481] = 0, -- Blackwater bank, office
    [2117902999] = 0, -- Blackwater bank, teller gate
    [1462330364] = 0, -- Blackwater bank, vault

    [3317756151] = 0, -- Rhodes bank, front entrance, left door
    [3088209306] = 0, -- Rhodes bank, front entrance, right door
    [2058564250] = 0, -- Rhodes bank, door to backrooms
    [1634148892] = 0, -- Rhodes bank, teller gate
    [3483244267] = 0, -- Rhodes bank, vault
    [3142122679] = 1, -- Rhodes bank, back entrance

    [2446974165] = 0, -- Rhodes saloon, bath room door

    [340151973]  = 0, -- Saint Denis theatre, right door
    [544106233]  = 0, -- Saint Denis theatre, left door
    [1457151494] = 0, -- Saint Denis theatre, behind counter, right door
    [1688533403] = 0, -- Saint Denis theatre, behind counter, left door

    [1239033969] = 0, -- Farm house outside emerald ranch, bedroom door

    [3074790964] = 0, -- Geddes ranch house

    [3101287960] = 0, -- Armadillo bank, front door
    [3550475905] = 0, -- Armadillo bank, teller gate
    [1366165179] = 0, -- Armadillo bank, back door

    [772977516] = 0, -- Slaver catcher house, north door
    [527767089] = 0, -- Slaver catcher house, south door

    [3804893186] = 0, -- Saint Denis tailor, dressing room
    [2432590327] = 0, -- Rhodes general store, dressing room
    [3554893730] = 0, -- Valentine general store, dressing room
    [94437577]   = 0, -- Strawberry general store, dressing room
    [3277501452] = 0, -- Blackwater tailor, dressing room
    [3208189941] = 0, -- Tumbleweed tailor, dressing room
    [3142465793] = 0, -- Wallace Station general store, dressing room

    [1962482653] = 0, -- River boat, upper deck vault room, east door
    [2181772801] = 0, -- River boat, upper deck vault room, west door
    [1275379652] = 0, -- River boat, upper deck cabin, east door
    [4267779198] = 0, -- River boat, upper deck cabin, west door
    [1509055391] = 0, -- River boat, upper deck cabin, south doors, right door
    [2811033299] = 0, -- River boat, upper deck cabin, south doors, left door

    [586229709] = 0, -- Saint Denis doctor, door between store and waiting room

    [1707768866] = 0, -- Galarie Laurent, manager's office

    [1657401918] = 1, -- Annesburg sheriff's office, left cell
    [1502928852] = 1, -- Annesburg sheriff's office, right cell

    [202296518] = 0, -- Six Point Cabin

    [3782668011] = 0, -- Aberdeen Pig Farm south door

    [1423877126] = 0, -- Tumbleweed bath room door
    [3013877606] = 0, -- Tumbleweed bath, side room door

    [553939906] = 0, -- Shady Belle, upstairs, right door
    [357129292] = 0, -- Shady Belle, upstairs, left door

    [1523300673] = 0, -- Blackwater bath, north door

    [1915401053] = 0, -- Saint Denis tram station, east counter door
    [187523632]  = 0, -- Saint Denis tram station, west counter door

    [831345624]  = 1, -- Tumbleweed jail cell
    [2984805596] = 1, -- Tumbleweed jail, left cell door
    [2677989449] = 1, -- Tumbleweed jail, right cell door

    [1711767580] = 1, -- Saint Denis jail cell

    [193903155] = 1, -- Valentine jail cell
    [295355979] = 1, -- Valentine jail cell

    [1878514758] = 1, -- Rhodes jail cell

    [2514996158] = 1, -- Blackwater jail cell
    [2167775834] = 1, -- Blackwater jail cell

    [902070893]  = 1, -- Strawberry jail cell
    [1207903970] = 1, -- Strawberry jail cell

    [4016307508] = 1, -- Armadillo jail cell
    [4235597664] = 1, -- Amradillo jail cell
}

