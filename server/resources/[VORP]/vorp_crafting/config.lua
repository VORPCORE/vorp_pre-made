Config = {}

Config.defaultlang = "en_lang"

Config.Webhook = '' -- WEBHOOK VORPCORE

-- Crafting Key
Config.Keys = {
    G = 0x760A9C6F
}

-- Options: s, m, l
Config.Styles = {
    fontSize = 'm',
    descriptionsidebar = true
}

Config.Commands = {
    campfire = true,
    extinguish = true
}

-- distance to interact with Locations and campfires
Config.Distances = {
    campfire = 1.5,
    locations = 2.5
}

-- Craftable Locations
--EXAMPLE: 
-- {
--     name = 'Blackwater Crafting Express',
--     id = 'blackwater',
--     Job = { 'butcher' }, -- set to 0 to allow any jobs, or like { "butcher" } to job restriction
--     x = -872.222, 
--     y = -1390.924, 
--     z = 43.573
-- }
Config.Locations = {
    {
        name = 'Blackwater Crafting Station',
        id = 'blackwater',
        Job = 0, -- set to 0 to allow any jobs, or like { "butcher" } to job restriction
        x = -872.222, 
        y = -1390.924, 
        z = 43.573,
        Blip = {
            enable = true,
            Hash = 1754365229
        },
        Categories = 0, -- set to 0 to allow all categories or like {"food"} to restrict
    }
}

Config.PlaceableCampfire = "p_campfire05x"

-- Restrict campfire usage to specific roles or set to 0 to allow any role
-- Example: { "butcher" }
-- set to 0 to allow any jobs, or like { "butcher" } to job restriction
Config.CampfireJobLock = 0

-- Disables/Enables the kneeling animation when crafting
Config.KneelingAnimation = true

-- Crafting Prop Location is resource intensive, turn this to false if you want to use less resources.
-- Disables/Enables Crafting Props
Config.CraftingPropsEnabled = true

-- Props for the player to craft at
-- List of porps you can use for crafting
-- "P_CAMPFIRECOMBINED01X","p_campfirefresh01x","p_fireplacelogs01x","p_woodstove01x","p_stove04x","p_campfire04x","p_campfire05x","p_campfire02x","p_campfirecombined02x","p_campfirecombined03x","p_kettle03x","p_campfirecombined04x", "P_CAMPFIRECOOK02X","P_CAMPFIRE_WIN2_01X","P_CRAFTINGPOT01X"
Config.CraftingProps = {
    {
        title = "Campfire",
        prop = "p_campfire05x"
    },
    {
        title = "Oven",
        prop = "p_furnace01x"
    }
}
-- How long the progressbar will show when crafting
Config.CraftTime = 15000

-- Craftable item categories. ident and Config.crafting.Category must equal eachother.
--EXAMPLE: 
-- {
--     ident = 'food', 
--     text = 'Craft Food',
--     Location = { 'campfire' }, -- set to 0 to allow any locations from Config.Locations
--     Job = { 'butcher' } -- set to 0 to allow any jobs, or like { "butcher" } to job restriction
-- },
Config.Categories = {
    {
        ident = 'food', 
        text = 'Craft Food',
        Location = 0,
        Job = 0
    },
    {
        ident = 'items',
        text = 'Craft Item',
        Location = 0,
        Job = 0
    },
    {
        ident = 'weapons',
        text = 'Weapons',
        Location = 0,
        Job = 0
    },
    {
        ident = 'meleeweapons',
        text = 'Melee weapons',
        Location = 0,
        Job = 0
    },
}

-- Craftable Items/Rewards And their Recipes
--EXAMPLE: 
-- {
--     Text = "Meat Bfast ",
--     SubText = "InvMax = 10",
--     Desc = "Recipe: 1x Meat, 1x Salt",
--     Items = {
--         {
--             name = "meat",
--             count = 1
--         },
--         {
--             name = "salt",
--             count = 1
--         }
--     },
--     Reward = {
--         {
--             name = "consumable_breakfast", -- if you use the currency mode, you don't need a name section inside the reward section
--             count = 1
--         }
--     },
--     Job = { 'butcher' }, -- set to 0 to allow any jobs, or like { "butcher" } to job restriction
--     Location = { 'blackwater' }, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
--     UseCurrencyMode = false, -- true if you want to use the currency mode otherwise set this to false
--     CurrencyType = 0, -- 0 => money, 1 => gold
--     Category = "food",
--     Animation = 'knifecooking' -- set what animation should play when crafting (if this is not set it has a default animation). Animations can be found below in Config.Animations
-- }
Config.Crafting = {
    {
        Text = "Meat Bfast ",
        SubText = "InvMax = 10",
        Desc = "Recipe: 1x Meat, 1x Salt",
        Items = {
            {
                name = "meat",
                count = 1,
                take = true -- This determines if recipe items will be taken from inventory after crafting. If ommited, it will default to true.
            },
            {
                name = "salt",
                count = 1,
                take = false -- This determines if recipe items will be taken from inventory after crafting. If ommited, it will default to true.
            }
        },
        Reward = {
            {
                name = "consumable_breakfast",
                count = 1
            }
        },
        Type = "item", -- indicate if it is 'weapon' or 'item'
        Job = 0, -- set to 0 to allow any jobs, or like { "butcher" } to job restriction
        Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
        UseCurrencyMode = false,
        CurrencyType = 0, -- 0 = money, 1 = gold
        Category = "food",
        Animation = 'knifecooking',
        TakeItems = true -- This determines if recipe items will be taken from inventory after crafting. If ommited, it will default to true.
    },
    {
        Text = "Seasoned Small Game ",
        SubText = "InvMax = 10",
        Desc = "Recipe: 1 x SGM, 1 x Salt",
        Items = {
            {
                name = "consumable_game",
                count = 1
            },
            {
                name = "salt",
                count = 1
            }
        },
        Reward ={
            {
                name = "cookedsmallgame",
                count = 2
            }
        },
        Type = "item", -- indicate if it is 'weapon' or 'item'
        Job = 0,
        Location = 0,
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "food",
        Animation = 'knifecooking'
    }, 
    {
        Text = "Apple Pie ",
        SubText = "InvMax = 10",
        Desc = "Recipe: 1x Apple, 1x Water, 1x Sugar, 1x Egg, 1x Flour",
        Items = {
            {
                name = "apple",
                count = 1
            },
            {
                name = "water",
                count = 1
            },
            {
                name = "sugar",
                count = 1
            },
            {
                name = "flour",
                count = 1
            },
            {
                name = "eggs",
                count = 1
            }
        },
        Reward = {
            {
                name = "consumable_applepie",
                count = 1
            }
        },
        Type = "item", -- indicate if it is 'weapon' or 'item'
        Job = 0,
        Location = 0,
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "food"

    },
    {
        Text = "Steak ",
        SubText = "InvMax = 10",
        Desc = "Recipe: 1x Meat",
        Items = {
            {
                name = "meat",
                count = 1
            }
        },
        Reward = {
            {
                name = "steak",
                count = 1
            }
        },
        Type = "item",
        Job = 0,
        Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "food",
        Animation = 'spindlecook'
    },
    {
        Text = "Breakfast ",
        SubText = "InvMax = 5",
        Desc = "Recipe: 1x Pork, 2x Eggs",
        Items = {
            {
                name = "Pork",
                count = 1
            },
            {
                name = "eggs",
                count = 2
            }
        }, 
        Reward = {
            {
                name = "consumable_breakfast",
                count = 1
            }
        },
        Type = "item",
        Job = 0,
        Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "food"
    },
    {
        Text = "Blueberry Pie ",
        SubText = "InvMax = 10",
        Desc = "Recipe: 6x BlueBerry, 1 x Water, 1x Sugar, 1x Egg, 1x Flour",
        Items = {
            {
                name = "blueberry",
                count = 6
            },
            {
                name = "water",
                count = 1
            },
            {
                name = "sugar",
                count = 1
            },
            {
                name = "eggs",
                count = 1
            },
            {
                name = "flour",
                count = 1
            }
        }, 
        Reward = {
            {
                name = "consumable_blueberrypie",
                count = 1
            }
        },
        Type = "item",
        Job = 0,
        Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "food"
    },
    {
        Text = "Seasoned Porkchop",
        SubText = "InvMax = 10 ",
        Desc = "Recipe: 1x Pork, 1x Salt",
        Items = {
            {
                name = "Pork",
                count = 1
            },
            {
                name = "salt",
                count = 1
            }
        },
        Reward ={
            {
                name = "knifecooking",
                count = 1
            }
        },
        Type = "item", -- indicate if it is 'weapon' or 'item'
        Job = 0,
        Location = 0,
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "food",
        Animation = 'spindlecook'
    },
    {
        Text = "Seasoned Big Game",
        SubText = "InvMax = 10",
        Desc = "Recipe 1x Big Game Meat, 1x Salt",
        Items = {
            {
                name = "BigGameMeat",
                count = 1
            },
            {
                name = "salt",
                count = 1
            }
        },
        Reward = {
            {
                name = "SaltedCookedBigGameMeat",
                count = 1
            }
        },
        Type = "item", -- indicate if it is 'weapon' or 'item'
        Job = 0,
        Location = 0,
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "food",
        Animation = 'spindlecook'
    },
    {
        Text = "Plain Big Game Meat",
        SubText = "InvMax = 10",
        Desc = "Recipe: 1x Big Game Meat",
        Items = {
            {
                name = "BigGameMeat",
                count = 1
            }
        },
        Reward = {
            {
                name = "CookedBigGameMeat",
                count = 1
            }
        },
        Type = "item", -- indicate if it is 'weapon' or 'item'
        Job = 0,
        Location = 0,
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "food",
        Animation = 'spindlecook'
    },
    {
        Text = "PorkChop ",
        SubText = "InvMax = 10",
        Desc = "Recipe: 1x Pork",
        Items = {
            {
                name = "Pork",
                count = 1
            }
        },
        Reward = {
            {
                name = "cookedpork",
                count = 1
            }
        },
        Type = "item", -- indicate if it is 'weapon' or 'item'
        Job = 0,
        Location = 0,
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "food",
        Animation = 'knifecooking'
    },
    {
        Text = "PickAxe ",
        SubText = "InvMax = 5",
        Desc = "Recipe: 10x Iron, 2x Wood",
        Items = {
            {
                name = "iron",
                count = 10
            },
            {
                name = "wood",
                count = 2
            }
        },
        Reward = {
            {
                name = "pickaxe",
                count = 1
            }
        },
        Type = "item", -- indicate if it is 'weapon' or 'item'
        Job = 0,
        Location = 0,
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "items"
    },
    {
        Text = "Axe ",
        SubText = "InvMax = 5",
        Desc = "Recipe: 10x Iron, 2x Wood",
        Items = {
            {
                name = "iron",
                count = 10
            },
            {
                name = "wood",
                count = 2
            }
        },
        Reward ={
            {
                name = "Axe",
                count = 1
            }
        },
        Type = "item", -- indicate if it is 'weapon' or 'item'
        Job = 0,
        Location = 0,
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "items"
    },
    {
        Text = "Campfire ",
        SubText = "InvMax = 5",
        Desc = "Recipe: 10x Rock, 5x Wood, 4x Coal",
        Items = {
            {
                name = "rock",
                count = 10
            },
            {
                name = "wood",
                count = 5
            },
            {
                name = "coal",
                count = 4
            }
        },
        Reward ={
            {
                name = "campfire",
                count = 1
            }
        },
        Type = "item", -- indicate if it is 'weapon' or 'item'
        Job = 0,
        Location = 0,
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "items"
    },
    {
        Text = "Plain Cooked Bird ",
        SubText = "InvMax = 10",
        Desc = "Recipe: 1x Raw Bird Meat",
        Items = {
            {
                name = "rawbirdmeat",
                count = 1
            }
        },
        Reward ={
            {
                name = "cookedbird",
                count = 1
            }
        },
        Type = "item", -- indicate if it is 'weapon' or 'item'
        Job = 0,
        Location = 0,
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "food"
    },
    {
        Text = "Refined Gold Ore ",
        SubText = "InvMax = 15",
        Desc = "Recipe: 1x Gold Ore",
        Items = {
            {
                name = "goldnugget",
                count = 14
            }
        },
        Reward ={
            {
                --name = "gold", -- if you use the currency mode, you don't need a name section inside the reward section
                count = 1
            }
        },
        Type = "item", -- indicate if it is 'weapon' or 'item'
        Job = 0,
        Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
        UseCurrencyMode = true,
        CurrencyType = 1,
        Category = "items"
    },
    {
        Text = "Plain Small Game ",
        SubText = "InvMax = 10 ",
        Desc = "Recipe: 1x Small Game Meat",
        Items = {
            {
                name = "consumable_game",
                count = 1
            }
        },
        Reward ={
            {
                name = "plainsmallgame",
                count = 1
            }
        },
        Type = "item",
        Job = 0,
        Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "food"
    },
    {
        Text = "Rope ",
        SubText = "InvMax = 10",
        Desc = "Recipe: 10x Fibers",
        Items = {
            {
                name = "fibers",
                count = 10
            }
        },
        Reward ={
            {
                name = "rope",
                count = 1
            }
        },
        Type = "item",
        Job = 0,
        Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "items"
    },
    {
        Text = "Cloth ",
        SubText = "InvMax = 10",
        Desc = "Recipe: 10x Wool",
        Items = {
            {
                name = "wool",
                count = 10
            }
        },
        Reward ={
            {
                name = "cloth",
                count = 1
            }
        },
        Type = "item",
        Job = 0,
        Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "items"
    },
    {
        Text = "Tent ",
        SubText = "InvMax = 5 ",
        Desc = "Recipe: 4x Cloth, 3x Rope, 2x Wood",
        Items = {
            {
                name = "cloth",
                count = 4
            },
            {
                name = "rope",
                count = 3
            },
            {
                name = "wood",
                count = 2
            }
        },
        Reward ={
            {
                name = "tent",
                count = 1
            }
        },
        Type = "item",
        Job = 0,
        Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "items"
    },
    {
        Text = "Bedroll ",
        SubText = "InvMax = 5",
        Desc = "Recipe: 4x Pelt, 1x Cloth, 2x Wood",
        Items = {
            {
                name = "pelt",
                count = 4
            },
            {
                name = "cloth",
                count = 1
            },
            {
                name = "wood",
                count = 2
            }
        },
        Reward ={
            {
                name = "bedroll",
                count = 1
            }
        },
        Type = "item",
        Job = 0,
        Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "items"
    }, 
    {
        Text = "Cigar",
        SubText = "InvMax = 20",
        Desc = "Recipe: 1x Indian Tobacco, 1x Fiber",
        Items = {
            {
                name = "Indian_Tobbaco",
                count = 1
            },
            {
                name = "fibers",
                count = 1
            }
        },
        Reward ={
            {
                name = "cigar",
                count = 1
            }
        },
        Type = "item",
        Job = 0,
        Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "items"
    },
    {
        Text = "Cigarette ",
        SubText = "InvMax = 20",
        Desc = "Recipe: 1x Indian Tobacco, 1x Fiber",
        Items = {
            {
                name = "Indian_Tobbaco",
                count = 1
            },
            {
                name = "fibers",
                count = 1
            }
        },
        Reward ={
            {
                name = "cigarette",
                count = 1
            }
        },
        Type = "item",
        Job = 0,
        Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "items"
    }, 
    {
        Text = "Steak n' Eggs ",
        SubText = "InvMax = 10",
        Desc = "Recipe: 2x Meat, 2x Eggs, 2x potatoes",
        Items = {
            {
                name = "meat",
                count = 2
            },
            {
                name = "eggs",
                count = 2
            },
            {
                name = "potato",
                count = 2
            }
        },
        Reward ={
            {
                name = "steakeggs",
                count = 1
            }
        },
        Type = "item",
        Job = 0,
        Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "food"
    }, 
    {
        Text = "Veggie Stew ",
        SubText = "InvMax = 10",
        Desc = "Recipe: 2x Carrots, 2x Corn, 2x Potatoes, 1xwater, 2x Salt",
        Items = {
            {
                name = "carrot",
                count = 2
            },
            {
                name = "corn",
                count = 2
            },
            {
                name = "potato",
                count = 2
            },
            {
                name = "water",
                count = 1
            },
            {
                name = "salt",
                count = 2
            }
        },
        Reward ={
            {
                name = "vegstew",
                count = 1
            }
        },
        Type = "item",
        Job = 0,
        Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "food"
    },   
    {
        Text = "Porkchops and Applesauce ",
        SubText = "InvMax = 10",
        Desc = "Recipe: 1x Pork, 2x Apples",
        Items = {
            {
                name = "Pork",
                count = 1
            },
            {
                name = "apple",
                count = 2
            }
        },
        Reward ={
            {
                name = "porknapples",
                count = 1
            }
        },
        Type = "item",
        Job = 0,
        Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "food"
    },
    {
        Text = "Bird Stew ",
        SubText = "InvMax = 10",
        Desc = "Recipe: 2x Raw Bird, 2x Carrots, 1x Corn, 2x Water, 2x Salt",
        Items = {
            {
                name = "rawbirdmeat",
                count = 2
            },
            {
                name = "carrot",
                count = 2
            },
            {
                name = "corn",
                count = 1
            },
            {
                name = "water",
                count = 2
            },
            {
                name = "salt",
                count = 2
            }
        },
        Reward ={
            {
                name = "birdstew",
                count = 1
            }
        },
        Type = "item",
        Job = 0,
        Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "food"
    },
    {
        Text = "Bird Stew ",
        SubText = "InvMax = 10",
        Desc = "Recipe: 2x Raw Bird, 2x Carrots, 1x Corn, 2x Water, 2x Salt",
        Items = {
            {
                name = "rawbirdmeat",
                count = 2
            },
            {
                name = "carrot",
                count = 2
            },
            {
                name = "corn",
                count = 1
            },
            {
                name = "water",
                count = 2
            },
            {
                name = "salt",
                count = 2
            }
        },
        Reward ={
            {
                name = "birdstew",
                count = 1
            }
        },
        Type = "item",
        Job = 0,
        Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "food"
    },

    {
        Text = "Bow ",
        SubText = "InvMax = 1",
        Desc = "Recipe: 2x Hard wood, 4x Fibers",
        Items = {
            {
                name = "hwood",
                count = 2
            },
            {
                name = "fibers",
                count = 4
            },
        },
        Reward ={
            {
                name = "WEAPON_BOW_IMPROVED",
                count = 1
            }
        },
        Type = "weapon", -- indicate if it is 'weapon' or 'item'
        Job = 0, 
        Location = 0,
        Category = "weapons",
        Animation = 'craft' -- set what animation should play when crafting (if this is not set it has a default animation). Animations can be found below in Config.Animations
    },
    {
        Text = "Revolver Navy ",
        SubText = "InvMax = 1",
        Desc = "Recipe 1x Revolver barrel, 1x Revolver cylinder, 1x Revolver handle",
        Items = {
            {
                name = "revolverbarrel",
                count = 1
            },
            {
                name = "revolvercylinder",
                count = 1
            },
            {
                name = "revolverhandle",
                count = 1
            },
        },
        Reward = {
            {
                name = "WEAPON_REVOLVER_NAVY",
                count = 1
            }
        },
        Type = "weapon", -- indicate if it is 'weapon' or 'item'
        Job = 0, -- set to 0 to allow any jobs, or like { "butcher" } to job restriction
        Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
        Category = "weapons",
        Animation = 'craft' -- set what animation should play when crafting (if this is not set it has a default animation). Animations can be found below in Config.Animations
    },
    {
        Text = "Knife ",
        SubText = "InvMax = 1",
        Desc = "Recipe 1x Iron, 1x Soft wood",
        Items = {
            {
                name = "iron",
                count = 1
            },
            {
                name = "wood",
                count = 1
            },
        },
        Reward = {
            {
                name = "WEAPON_MELEE_KNIFE",
                count = 1
            }
        },
        Type = "weapon", -- indicate if it is 'weapon' or 'item'
        Job = 0, -- set to 0 to allow any jobs, or like { "butcher" } to job restriction
        Location = 0, -- set to 0 to allow any locations from Config.Locations, or like { "butcher" } to job restriction
        Category = "meleeweapons",
        Animation = 'craft' -- set what animation should play when crafting (if this is not set it has a default animation). Animations can be found below in Config.Animations
    },
}

Config.Animations = {
    ["craft"] = { --Default Animation
        dict = "mech_inventory@crafting@fallbacks",
        name = "full_craft_and_stow", 
        flag = 27,
        type = 'standard'
    },
    ["spindlecook"] = {
        dict = "amb_camp@world_camp_fire_cooking@male_d@wip_base",
        name = "wip_base",
        flag = 17,
        type = 'standard',
        prop = {
            model = 'p_stick04x',
            coords = {
                x = 0.2, 
                y = 0.04,
                z = 0.12,
                xr = 170.0,
                yr = 50.0,
                zr = 0.0
            },
            bone = 'SKEL_R_Finger13',
            subprop = {
                model = 's_meatbit_chunck_medium01x',
                coords = {
                    x = -0.30, 
                    y = -0.08,
                    z = -0.30,
                    xr = 0.0,
                    yr = 0.0,
                    zr = 70.0
                }
            }
        }
    },
    ["knifecooking"] = {
        dict = "amb_camp@world_player_fire_cook_knife@male_a@wip_base",
        name = "wip_base", 
        flag = 17,
        type = 'standard',
        prop = {
            model = 'w_melee_knife06',
            coords = {
                x = -0.01, 
                y = -0.02,
                z = 0.02,
                xr = 190.0,
                yr = 0.0,
                zr = 0.0
            },
            bone = 'SKEL_R_Finger13',
            subprop = {
                model = 'p_redefleshymeat01xa',
                coords = {
                    x = 0.00, 
                    y = 0.02,
                    z = -0.20,
                    xr = 0.0,
                    yr = 0.0,
                    zr = 0.0
                }
            }
        }
    },
    ["campfire"] = {
        dict = "script_campfire@lighting_fire@male_male",
        name = "light_fire_b_p2_male_b", 
        flag = 17,
        type = 'standard'
	}
}