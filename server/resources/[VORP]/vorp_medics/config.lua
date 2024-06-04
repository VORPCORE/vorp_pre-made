Config = {
    Job = {
        Doctor = "doctor",
        Police = "police",
        Sheriff = "sheriff"
    }, --Add or delete jobs to allow revive knocked players. ALL OTHER ACTIONS ARE ONLY FOR DOCTORS

    defaultlang = "en",
    Align = "center",

    Key = 0x760A9C6F, --[G]

    DisableRecharge = true, -- Disable health recharge on spawn/after self-healing with item
    ResetInnerCore = true, -- Reset inner core on spawn/after self-healing
    MedicCanSpawnHorse = true, --Allow doctor to have own stable and Spawn horse

    HorseHash = "a_c_horse_americanstandardbred_palominodapple", --horse spawned by doctor

    -- show blips on map
    BlipsActive = {
        BlipsDoctors = true, --Blips of Doctor's office on map for all players
        BlipsDoctorsOnly = false, --Blips of Doctor's office only for doctors
        BlipsHerbalism = true, --Blips of Locations to study herbalism
        BlipsHerbalistsOnly = false, --Only Herbalists have blips of herbalists' camps
        BlipsHorses = false, --Horses spawned by doctors
        BlipsMedicStables = true, --Medic stables
    },

    -- Doctor's offices
    Locations = {

        SaintDenis = {
            name = "Saint Denis", -- name of blip
            x = 2731.30, y = -1230.35, z = 50.37, -- position of blip and doctor office
            Stable = { x = 2732.35, y = -1220.67, z = 49.67, h = 90 }, -- position to take horse
            Craft = { x = 2721.35, y = -1232.12, z = 50.37 }, -- position to craft
            Inventory = { x = 2722.66, y = -1232.35, z = 50.37 } -- not available yet!
        },
        Valentine = {
            name = "Valentine",
            x = -289.48, y = 810.57, z = 119.39,
            Stable = { x = -275.99, y = 816.32, z = 119.08, h = 85 },
            Craft = { x = -289.57, y = 807.72, z = 119.39 },
            Inventory = { x = -289.07, y = 804.88, z = 119.39 } -- not available now!
        },
        Strawberry = {
            name = "Strawberry",
            x = -1804.22, y = -431.89, z = 158.83,
            Stable = { x = -1811.77, y = -433.35, z = 158.36, h = 353 },
            Craft = { x = -1806.11, y = -428.98, z = 158.83 },
            Inventory = { x = -1807.87, y = -431.13, z = 158.83 } -- not available now!
        },
    },

    --locations where to become herbalist (it is ONLY to become herbalist)
    HerbalistLocations = {
        NewHannover = {
            name = "New Hannover", -- name of blip
            x = 179.80, y = 339.98, z = 120.62, -- postion of blip and prompt to become herbalist
            maxAllowed = 4
        }, --maxAllowed is max number of players to become herbalist at location
        Lemoyne = {
            name = "Lemoyne",
            x = 909.28, y = -983.24, z = 57.96,
            maxAllowed = 4
        },
        WestElizabeth = {
            name = "West Elizabeth",
            x = -1563.58, y = -1681.67, z = 79.42,
            maxAllowed = 3
        },
        Ambarino = {
            name = "Ambarino",
            x = 710.14, y = 1881.43, z = 239.46,
            maxAllowed = 2
        },
        NewAustin = {
            name = "New Austin",
            x = -4585.95, y = -2738.66, z = -10.57,
            maxAllowed = 2
        }
    },

    -- Crafts for medics at offices
    MedicCraft = {
        { name = "syringe", desc = "syringe" },
        { name = "consumable_medicine", desc = "consumable_medicine" },
        { name = "bandage", desc = "bandage" }
    },

    -- Recepies to craft herbal medicines and tonics available ONLY for herbalists
    Recepies = {
        {
            Text = "Herbal Tonic ",
            SubText = "InvMax = 10",
            Desc = "Recipe: 2x Yarrow, 1x Alcohol",
            Items = {
                {
                    name = "Yarrow",
                    count = 2
                },
                {
                    name = "alcohol",
                    count = 1
                }
            },
            Reward = {
                {
                    name = "herbal_tonic",
                    count = 1
                }
            },
            Job = 0, -- set to 0 to allow any jobs, or like { "butcher" } to job restriction
            Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
            Category = "items"
        },
        {
            Text = "Herbal Medicine ",
            SubText = "InvMax = 10",
            Desc = "Recipe: 2x American Ginseng, 2x Blueberry, 1x Alcohol",
            Items = {
                {
                    name = "American_Ginseng",
                    count = 2
                },
                {
                    name = "blueberry",
                    count = 2
                },
                {
                    name = "alcohol",
                    count = 1
                }
            },
            Reward = {
                {
                    name = "herbal_medicine",
                    count = 1
                }
            },
            Job = 0, -- set to 0 to allow any jobs, or like { "butcher" } to job restriction
            Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
            Category = "items"
        }
    }
}
