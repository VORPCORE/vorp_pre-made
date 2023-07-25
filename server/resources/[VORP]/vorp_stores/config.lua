Config = {}

Lang = "English"

-- menu position
-- "center" / "top-left" / "top-right"
Config.Align = "top-left"
Config.DevMode = false -- if true you can use /reload to reload the script

-- Webhook Section, description is in translation
Config.UseWebhook = false -- Use webhook
Config.WebhookLanguage = {
    WebhookUrl = "",
    WebhookTitle = "",
    WebhookColor = "",
    WebhookName = "",
    WebhookLogo = "",
    WebhookLogo2 = "",
    WebhookAvatar = ""
}
-- if you have UI you want to hid use it in this function
-- remove what you dont use
Config.UI = function(state)
    if state then
        --ExecuteCommand("hideneeds hidden")
        ExecuteCommand("hideui")
        TriggerEvent('vorpmetabolism:setHud', false)
    else
        -- ExecuteCommand("hideneeds visible")
        ExecuteCommand("showui")
        TriggerEvent('vorpmetabolism:setHud', true)
    end
end


-- open stores
Config.Key = 0x760A9C6F --[G] open stores

Config.Stores = {
    -- any name you want sell items and buy items must have same name
    Valentine = {

        useRandomLocation = false, -- if true it will pick a random location from the list bellow, good thing for a store that can move and not always in the same place and npc
        possibleLocations = {
            OpenMenu = {
                -- vector3(-324.628, 803.9818, 116.88), -- valentine
                -- add more it will pick a random location from the list
            },
            Npcs = {
                -- vector4(-324.628, 803.9818, 116.88, -81.17), --valentine
                -- add more it will pick a random location from the list
            }

        },

        Blip = {
            Allowed = true,                            -- allow blip to show on map?
            Name = "valentine store",                  -- blip name
            sprite = 1475879922,                       -- blip sprite
            Pos = vector3(-324.628, 803.9818, 116.88), -- blip position and prompt press open position
        },

        Npc = {
            Pos = vector4(-324.628, 803.9818, 116.88, -81.17), -- npc position
            distanceRemoveNpc = 20.0,                          -- distance to remove npc
            Allowed = true,                                    -- allow npc to spawn?
            Model = "U_M_M_NbxGeneralStoreOwner_01",           -- npc model to spawn
        },

        -- * store categories allow which category to show in the store
        category = {
            { label = "food",    Type = "food",    desc = "delicious food", img = "consumable_bread_roll" },
            { label = "tools",   Type = "tools",   desc = "useful tools",   img = "butcher_table_production" },
            { label = "Weapons", Type = "weapons", desc = "buy weapons",    img = "butcher_table_production" },
        },
        -- * store type allow which type of store to show in the store
        -- * buy and sell USE ENGLISH ONLY
        storeType = {
            { label = "Buy", Type = "buy", desc = "Buy from store", img = "consumable_bread_roll" },
            --{ label = "Sell", Type = "sell", desc = "Sell to store",  img = "butcher_table_production" },
        },

        storeName = "valentine",      -- menu name
        PromptName = "general store", -- prompt name
        AllowedJobs = {},             -- if empty everyone can use or do {"police", "sheriff"}
        JobGrade = 1,                 -- use ranks
        StoreHoursAllowed = true,     -- if you want the stores to use opening and closed hours
        RandomPrices = true,          -- prices of items will be random every restart if set to true based on the prices you added in the config items
        distanceOpenStore = 3.0,      -- distance to open store
        StoreOpen = 7,                -- am
        StoreClose = 21,              -- pm
        DynamicStore = true,          -- if true what you sell to the store will increase the stock of the store if in each item you add a value for stock

    },

    Rhodes = {

        useRandomLocation = false, -- if true it will pick a random location from the list bellow, good thing for a store that can move and not always in the same place and npc
        possibleLocations = {
            OpenMenu = {
                -- vector3(-324.628, 803.9818, 116.88), -- valentine
                -- add more it will pick a random location from the list
            },
            Npcs = {
                -- vector4(-324.628, 803.9818, 116.88, -81.17), --valentine
                -- add more it will pick a random location from the list
            }

        },
        Blip = {
            Allowed = true,
            Name = "rhodes store",
            sprite = 1475879922,
            Pos = vector3(1330.227, -1293.41, 76.021),
        },
        Npc = {
            Pos = vector4(1330.227, -1293.41, 76.021, 68.88),
            distanceRemoveNpc = 20.0,
            Allowed = true,
            Model = "S_M_M_UNIBUTCHERS_01",
        },

        storeName = "Rhodes",
        PromptName = " general store",
        distanceOpenStore = 5.0,
        AllowedJobs = {},
        JobGrade = 0,
        -- * store categories allow which category to show in the store
        category = {
            { label = "food",  Type = "food",  desc = "delicious food", img = "consumable_bread_roll" },
            { label = "tools", Type = "tools", desc = "useful tools",   img = "butcher_table_production" },
        },
        -- * store type allow which type of store to show in the store
        storeType = {
            { label = "Buy ",  Type = "buy",  desc = "Buy from store", img = "consumable_bread_roll" },
            { label = "Sell ", Type = "sell", desc = "Sell to store",  img = "butcher_table_production" }

        },
        StoreHoursAllowed = true,
        RandomPrices = true,
        StoreOpen = 8,
        StoreClose = 20,
        DynamicStore = true,

    },
    Strawberry = {
        useRandomLocation = false, -- if true it will pick a random location from the list bellow, good thing for a store that can move and not always in the same place and npc
        possibleLocations = {
            OpenMenu = {
                -- vector3(-324.628, 803.9818, 116.88), -- valentine
                -- add more it will pick a random location from the list
            },
            Npcs = {
                -- vector4(-324.628, 803.9818, 116.88, -81.17), --valentine
                -- add more it will pick a random location from the list
            }

        },

        Blip = {
            Allowed = true,
            Name = "strawberry store",
            sprite = 1475879922,
            Pos = vector3(-1789.66, -387.918, 159.32),

        },

        Npc = {
            Pos = vector4(-1789.66, -387.918, 159.32, 56.96),
            distanceRemoveNpc = 20.0,
            Allowed = true,
            Model = "S_M_M_UNIBUTCHERS_01",
        },
        storeName = "Strawberry",
        PromptName = "general store",
        distanceOpenStore = 3.0,
        AllowedJobs = {},
        JobGrade = 0,
        -- * store categories allow which category to show in the store
        category = {
            { label = "food",  Type = "food",  desc = "delicious food", img = "consumable_bread_roll" },
            { label = "tools", Type = "tools", desc = "useful tools",   img = "butcher_table_production" },
        },
        -- * store type allow which type of store to show in the store
        storeType = {
            { label = "Buy ",  Type = "buy",  desc = "Buy from store", img = "consumable_bread_roll" },
            { label = "Sell ", Type = "sell", desc = "Sell to store",  img = "butcher_table_production" }

        },
        StoreHoursAllowed = true,
        RandomPrices = true,
        StoreOpen = 6,
        StoreClose = 23,
        DynamicStore = true,

    },
    Blackwater = {
        useRandomLocation = false, -- if true it will pick a random location from the list bellow, good thing for a store that can move and not always in the same place and npc
        possibleLocations = {
            OpenMenu = {
                -- vector3(-324.628, 803.9818, 116.88), -- valentine
                -- add more it will pick a random location from the list
            },
            Npcs = {
                -- vector4(-324.628, 803.9818, 116.88, -81.17), --valentine
                -- add more it will pick a random location from the list
            }

        },
        Blip = {
            Allowed = true,
            Name = "Blackwater Store",
            sprite = 1475879922,
            Pos = vector3(-784.738, -1321.73, 42.884),
        },
        Npc = {
            Pos = vector4(-784.738, -1321.73, 42.884, 179.63),
            distanceRemoveNpc = 20.0,
            Allowed = true,
            Model = "S_M_M_UNIBUTCHERS_01",
        },
        storeName = "Blackwater",
        PromptName = "general store",
        distanceOpenStore = 5.0,
        AllowedJobs = {},
        JobGrade = 0,
        -- * store categories allow which category to show in the store
        category = {
            { label = "food",  Type = "food",  desc = "delicious food", img = "consumable_bread_roll" },
            { label = "tools", Type = "tools", desc = "useful tools",   img = "butcher_table_production" },
        },
        -- * store type allow which type of store to show in the store
        storeType = {
            { label = "Buy ",  Type = "buy",  desc = "Buy from store", img = "consumable_bread_roll" },
            { label = "Sell ", Type = "sell", desc = "Sell to store",  img = "butcher_table_production" }

        },
        StoreHoursAllowed = true,
        RandomPrices = true,
        StoreOpen = 7,
        StoreClose = 21,
        DynamicStore = true,

    },
    Armadillo = {
        useRandomLocation = false, -- if true it will pick a random location from the list bellow, good thing for a store that can move and not always in the same place and npc
        possibleLocations = {
            OpenMenu = {
                -- vector3(-324.628, 803.9818, 116.88), -- valentine
                -- add more it will pick a random location from the list
            },
            Npcs = {
                -- vector4(-324.628, 803.9818, 116.88, -81.17), --valentine
                -- add more it will pick a random location from the list
            }

        },
        Blip = {
            Allowed = true,
            Name = "Armadillo Store",
            sprite = 1475879922,
            Pos = vector3(-3687.34, -2623.53, -13.43),
        },
        Npc = {
            Pos = vector4(-3687.34, -2623.53, -13.43, -85.32),
            distanceRemoveNpc = 20.0,
            Allowed = true,
            Model = "S_M_M_UNIBUTCHERS_01",
        },

        storeName = "Armadillo",
        PromptName = "general store",
        distanceOpenStore = 3.0,
        AllowedJobs = {},
        JobGrade = 0,
        -- * store categories allow which category to show in the store
        category = {
            { label = "food",  Type = "food",  desc = "delicious food", img = "consumable_bread_roll" },
            { label = "tools", Type = "tools", desc = "useful tools",   img = "butcher_table_production" },
        },
        -- * store type allow which type of store to show in the store
        storeType = {
            { label = "Buy ",  Type = "buy",  desc = "Buy from store", img = "consumable_bread_roll" },
            { label = "Sell ", Type = "sell", desc = "Sell to store",  img = "butcher_table_production" }

        },
        StoreHoursAllowed = true,
        RandomPrices = true,
        StoreOpen = 7,
        StoreClose = 21,
        DynamicStore = true,

    },
    Tumbleweed = {
        useRandomLocation = false, -- if true it will pick a random location from the list bellow, good thing for a store that can move and not always in the same place and npc
        possibleLocations = {
            OpenMenu = {
                -- vector3(-324.628, 803.9818, 116.88), -- valentine
                -- add more it will pick a random location from the list
            },
            Npcs = {
                -- vector4(-324.628, 803.9818, 116.88, -81.17), --valentine
                -- add more it will pick a random location from the list
            }

        },
        Blip = {
            Allowed = true,
            Name = "Tumbleweed Store",
            sprite = 1475879922,
            Pos = vector3(-5485.70, -2938.08, -0.299),
        },
        Npc = {
            Pos = vector4(-5485.70, -2938.08, -0.299, 127.72),
            distanceRemoveNpc = 20.0,
            Allowed = true,
            Model = "S_M_M_UNIBUTCHERS_01",
        },
        storeName = "Tumbleweed",
        PromptName = "general store",
        distanceOpenStore = 3.0,
        AllowedJobs = {},
        JobGrade = 0,
        -- * store categories allow which category to show in the store
        category = {
            { label = "food",  Type = "food",  desc = "delicious food", img = "consumable_bread_roll" },
            { label = "tools", Type = "tools", desc = "useful tools",   img = "butcher_table_production" },
        },
        -- * store type allow which type of store to show in the store
        storeType = {
            { label = "Buy ",  Type = "buy",  desc = "Buy from store", img = "consumable_bread_roll" },
            { label = "Sell ", Type = "sell", desc = "Sell to store",  img = "butcher_table_production" }

        },
        StoreHoursAllowed = true,
        RandomPrices = true,
        StoreOpen = 7,
        StoreClose = 21,
        DynamicStore = true,
    },
    StDenis = {
        useRandomLocation = false, -- if true it will pick a random location from the list bellow, good thing for a store that can move and not always in the same place and npc
        possibleLocations = {
            OpenMenu = {
                -- vector3(-324.628, 803.9818, 116.88), -- valentine
                -- add more it will pick a random location from the list
            },
            Npcs = {
                -- vector4(-324.628, 803.9818, 116.88, -81.17), --valentine
                -- add more it will pick a random location from the list
            }

        },
        Blip = {
            Allowed = true,
            Name = "St Denis Store",
            sprite = 1475879922,
            Pos = vector3(2824.863, -1319.74, 45.755),
        },
        Npc = {
            Pos = vector4(2824.863, -1319.74, 45.755, -39.61),
            distanceRemoveNpc = 20.0,
            Allowed = true,
            Model = "U_M_M_NbxGeneralStoreOwner_01",
        },

        storeName = "ST Denis",
        PromptName = "general store",
        distanceOpenStore = 2.0,
        AllowedJobs = {},
        JobGrade = 0,
        -- * store categories allow which category to show in the store
        category = {
            { label = "food",  Type = "food",  desc = "delicious food", img = "consumable_bread_roll" },
            { label = "tools", Type = "tools", desc = "useful tools",   img = "butcher_table_production" },
        },
        -- * store type allow which type of store to show in the store
        storeType = {
            { label = "Buy ",  Type = "buy",  desc = "Buy from store", img = "consumable_bread_roll" },
            { label = "Sell ", Type = "sell", desc = "Sell to store",  img = "butcher_table_production" }

        },
        StoreHoursAllowed = true,
        RandomPrices = true,
        StoreOpen = 7,
        StoreClose = 21,
        DynamicStore = true,

    },
    Vanhorn = {
        useRandomLocation = false, -- if true it will pick a random location from the list bellow, good thing for a store that can move and not always in the same place and npc
        possibleLocations = {
            OpenMenu = {
                -- vector3(-324.628, 803.9818, 116.88), -- valentine
                -- add more it will pick a random location from the list
            },
            Npcs = {
                -- vector4(-324.628, 803.9818, 116.88, -81.17), --valentine
                -- add more it will pick a random location from the list
            }

        },
        Blip = {
            Allowed = true,
            Name = "Vanhorn Store",
            sprite = 1475879922,
            Pos = vector3(3025.420, 561.7910, 43.722),
        },
        Npc = {
            Pos = vector4(3025.420, 561.7910, 43.722, -99.20),
            distanceRemoveNpc = 20.0,
            Allowed = true,
            Model = "U_M_M_NbxGeneralStoreOwner_01",
        },
        storeName = "Vanhorn",
        PromptName = "general store",
        distanceOpenStore = 2.5,
        AllowedJobs = {},
        JobGrade = 0,
        -- * store categories allow which category to show in the store
        category = {
            { label = "food",  Type = "food",  desc = "delicious food", img = "consumable_bread_roll" },
            { label = "tools", Type = "tools", desc = "useful tools",   img = "butcher_table_production" },
        },
        -- * store type allow which type of store to show in the store
        storeType = {
            { label = "Buy ",  Type = "buy",  desc = "Buy from store", img = "consumable_bread_roll" },
            { label = "Sell ", Type = "sell", desc = "Sell to store",  img = "butcher_table_production" }

        },
        StoreHoursAllowed = true,
        RandomPrices = true,
        StoreOpen = 7,
        StoreClose = 21,
        DynamicStore = true,

    },
    BlackwaterFishing = {
        useRandomLocation = false, -- if true it will pick a random location from the list bellow, good thing for a store that can move and not always in the same place and npc
        possibleLocations = {
            OpenMenu = {
                -- vector3(-324.628, 803.9818, 116.88), -- valentine
                -- add more it will pick a random location from the list
            },
            Npcs = {
                -- vector4(-324.628, 803.9818, 116.88, -81.17), --valentine
                -- add more it will pick a random location from the list
            }

        },
        Blip = {
            Allowed = true,
            Name = "Blackwater Fishing Store",
            sprite = 3442726182,
            Pos = vector3(-756.069, -1360.76, 43.724),
        },
        Npc = {
            Pos = vector4(-756.069, -1360.76, 43.724, -90.80),
            distanceRemoveNpc = 20.0,
            Allowed = true,
            Model = "U_M_M_NbxGeneralStoreOwner_01",
        },

        blipAllowed = true,
        BlipName = "Fishing store",
        storeName = "Bait Shop",
        PromptName = "fishing store",
        distanceOpenStore = 2.5,
        AllowedJobs = {}, -- jobs allowed
        JobGrade = 0,
        -- * store categories allow which category to show in the store
        category = {
            { label = "food",  Type = "food",  desc = "delicious food", img = "consumable_bread_roll" },
            { label = "tools", Type = "tools", desc = "useful tools",   img = "butcher_table_production" },
        },
        -- * store type allow which type of store to show in the store
        storeType = {
            { label = "Buy ",  Type = "buy",  desc = "Buy from store", img = "consumable_bread_roll" },
            { label = "Sell ", Type = "sell", desc = "Sell to store",  img = "butcher_table_production" }

        },
        StoreHoursAllowed = true,
        RandomPrices = true,
        StoreOpen = 7,
        StoreClose = 21,
        DynamicStore = true,
    },
    Wapiti = {
        useRandomLocation = false, -- if true it will pick a random location from the list bellow, good thing for a store that can move and not always in the same place and npc
        possibleLocations = {
            OpenMenu = {
                -- vector3(-324.628, 803.9818, 116.88), -- valentine
                -- add more it will pick a random location from the list
            },
            Npcs = {
                -- vector4(-324.628, 803.9818, 116.88, -81.17), --valentine
                -- add more it will pick a random location from the list
            }
        },
        Blip = {
            Allowed = true,
            Name = "Wapiti Store",
            sprite = 3442726182,
            Pos = vector3(449.7435, 2216.437, 245.30),
        },
        Npc = {
            Pos = vector4(449.7435, 2216.437, 245.30, -73.78),
            distanceRemoveNpc = 20.0,
            Allowed = true,
            Model = "U_M_M_NbxGeneralStoreOwner_01",
        },
        storeName = "Wapiti Shop",
        PromptName = "Native store",
        distanceOpenStore = 2.5,
        AllowedJobs = {}, -- jobs allowed
        JobGrade = 0,
        -- * store categories allow which category to show in the store
        category = {
            { label = "food",  Type = "food",  desc = "delicious food", img = "consumable_bread_roll" },
            { label = "tools", Type = "tools", desc = "useful tools",   img = "butcher_table_production" },
        },
        -- * store type allow which type of store to show in the store
        storeType = {
            { label = "Buy ",  Type = "buy",  desc = "Buy from store", img = "consumable_bread_roll" },
            { label = "Sell ", Type = "sell", desc = "Sell to store",  img = "butcher_table_production" }

        },
        StoreHoursAllowed = true,
        RandomPrices = true,
        StoreOpen = 7,
        StoreClose = 21,
        DynamicStore = true,
    }
}
