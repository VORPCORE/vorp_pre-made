ConfigShops                      = {}

ConfigShops.UseShops             = true  -- if you want to use the shops set to true if not set to false

ConfigShops.SecondChancePrice    = 15000 -- if store is second chance then this is the price they need to pay to use it

ConfigShops.SecondChanceCurrency = 0     -- 0 is cash 1 is gold 2 is tokens currency
--[[ types of stores]]
--
-- clothing
-- hair
-- makeup
-- face
-- secondchance -- this enables all
-- lifestyle --scars acne complex
-- Blip Colors: https://github.com/femga/rdr3_discoveries/tree/master/useful_info_from_rpfs/blip_modifiers

ConfigShops.Locations = {
    {                                                   -- valentine
        Prompt = {
            Position = vector3(-326.1, 774.48, 117.46), -- prompt location
            Label = "Clothing Store",                   -- prompt label
        },
        Npc = {
            Enable = true,
            Model = "CS_FRANCIS_SINCLAIR",
            Position = vector4(-325.55, 773.02, 116.44, 15.63),
        },
        Blip = {
            Enable = true,
            Sprite = 1195729388,
            Name = "Clothing Store",
            -- Color = 'BLIP_MODIFIER_MP_COLOR_23',
        },
        EditCharacter = { -- where the player will be teleported to edit character
            Position = vector4(-329.43, 775.29, 121.63, 278.17),
        },
        SpawnBack = { -- where the player will be teleported to after editing character
            Position = vector4(-323.12, 774.47, 121.63, 186.42),
        },
        CameraPosition = { -- camera position for the character editor
            Position = vector3(-327.38, 775.48, 122.00),
            Heading = 97.6,
            MaxUp = 122.75,
            MaxDown = 120.91,
        },
        TypeOfShop = "clothing",                          -- means all will be avaialble with a price to be paid to enter
        DrawLight = false,                                -- if you need a light in the store put true
    },
    {                                                     -- blackwater
        Prompt = {
            Position = vector3(-761.61, -1291.98, 43.85), -- prompt location
            Label = "Clothing Store",                     -- prompt label
        },
        Npc = {
            Enable = true,
            Model = "CS_FRANCIS_SINCLAIR",
            Position = vector4(-761.31, -1293.64, 43.84, 6.33),
            Scenario = 'WORLD_HUMAN_STAND_WAITING',
        },
        Blip = {
            Enable = true,
            Sprite = 1195729388,
            Name = "Clothing Store",
            -- Color = 'BLIP_MODIFIER_MP_COLOR_23',
        },
        EditCharacter = { -- where the player will be teleported to edit character
            Position = vector4(-767.98, -1294.88, 43.83, 263.09),
        },
        SpawnBack = { -- where the player will be teleported to after editing character
            Position = vector4(-766.53, -1293.13, 43.84, 357.64),
        },
        CameraPosition = { -- camera position for the character editor
            Position = vector3(-765.86, -1295.02, 44.14),
            Heading = 92.42,
            MaxUp = 44.85,
            MaxDown = 42.95,
        },
        TypeOfShop = "clothing",                          -- means all will be avaialble with a price to be paid to enter
        DrawLight = false,                                -- if you need a light in the store put true
    },
        {                                                     -- blackwater Makeup
        Prompt = {
            Position = vector3(-810.25, -1372.55, 44.02), -- prompt location
            Label = "Lifesyle Store",                     -- prompt label
        },
        Npc = {
            Enable = true,
            Model = "CS_FRANCIS_SINCLAIR",
            Position = vector4(-810.44, -1372.31, 44.02, 180.34),
            Scenario = 'WORLD_HUMAN_STAND_WAITING',
        },
        Blip = {
            Enable = true,
            Sprite = 1195729388,
            Name = "Lifesyle Store",
            -- Color = 'BLIP_MODIFIER_MP_COLOR_23',
        },
        EditCharacter = { -- where the player will be teleported to edit character
            Position = vector4(-815.03, -1374.82, 44.23, 264.34),
        },
        SpawnBack = { -- where the player will be teleported to after editing character
            Position = vector4(-810.69, -1375.92, 44.02, 323.48),
        },
        CameraPosition = { -- camera position for the character editor
         
            Position = vector3(-813.40, -1374.79, 44.86),
            Heading = 91.22,
            MaxUp = 45.86,
            MaxDown = 43.22,
        },
        TypeOfShop = "lifestyle",                          -- means all will be avaialble with a price to be paid to enter
        DrawLight = false,                                -- if you need a light in the store put true
    },
    
    {                                                     -- Rhodes
        Prompt = {
            Position = vector3(1324.66, -1291.59, 77.08), -- prompt location
            Label = "Enter Clothing Store",               -- prompt label
        },
        Npc = {
            Enable = true,
            Model = "CS_FRANCIS_SINCLAIR",
            Position = vector4(1323.02, -1292.14, 77.08, 239.01),
            Scenario = 'WORLD_HUMAN_STAND_WAITING',
        },
        Blip = {
            Enable = true,
            Sprite = 1195729388,
            Name = "Rhodes Clothing Store",
            -- Color = 'BLIP_MODIFIER_MP_COLOR_23',
        },
        EditCharacter = { -- where the player will be teleported to edit character
            Position = vector4(1324.24, -1287.88, 77.07, 164.22),
        },
        SpawnBack = { -- where the player will be teleported to after editing character
            Position = vector4(1324.78, -1292.34, 77.08, 250.13),
        },
        CameraPosition = { -- camera position for the character editor
            Position = vector3(1323.14, -1290.03, 77.72),
            Heading = -26.27,
            MaxUp = 78.13,
            MaxDown = 76.95,
        },
        TypeOfShop = "clothing",                         -- means all will be avaialble with a price to be paid to enter
        DrawLight = false,                               -- if you need a light in the store put true
    },
    {                                                    -- Saint Denis
        Prompt = {
            Position = vector3(2552.4, -1165.22, 53.73), -- prompt location
            Label = "Enter Clothing Store",              -- prompt label
        },
        Npc = {
            Enable = true,
            Model = "CS_FRANCIS_SINCLAIR",
            Position = vector4(2552.89, -1163.73, 53.73, 144.93),
            Scenario = 'WORLD_HUMAN_STAND_WAITING',
        },
        Blip = {
            Enable = true,
            Sprite = 1195729388,
            Name = "Saint Denis Clothing Store",
            -- Color = 'BLIP_MODIFIER_MP_COLOR_23',
        },
        EditCharacter = { -- where the player will be teleported to edit character
            Position = vector4(2556.66, -1159.76, 53.75, 191.14),
        },
        SpawnBack = { -- where the player will be teleported to after editing character
            Position = vector4(2553.0, -1161.22, 53.73, 85.61),
        },
        CameraPosition = { -- camera position for the character editor
            Position = vector3(2556.56, -1161.72, 54.10),
            Heading = 0.32,
            MaxUp = 54.82,
            MaxDown = 53.00,
        },
        TypeOfShop = "clothing",                           -- means all will be avaialble with a price to be paid to enter
        DrawLight = false,                                 -- if you need a light in the store put true
    },
    {                                                      -- Strawberry
        Prompt = {
            Position = vector3(-1791.07, -392.71, 160.29), -- prompt location
            Label = "Enter Clothing Store",                -- prompt label
        },
        Npc = {
            Enable = true,
            Model = "CS_FRANCIS_SINCLAIR",
            Position = vector4(-1791.07, -392.71, 160.29, 326.21),
            Scenario = 'WORLD_HUMAN_STAND_WAITING',
        },
        Blip = {
            Enable = true,
            Sprite = 1195729388,
            Name = "Strawberry Clothing Store",
            -- Color = 'BLIP_MODIFIER_MP_COLOR_23',
        },
        EditCharacter = { -- where the player will be teleported to edit character
            Position = vector4(-1794.4, -395.25, 160.34, 326.06),
        },
        SpawnBack = { -- where the player will be teleported to after editing character
            Position = vector4(-1793.69, -390.33, 160.26, 61.55),
        },
        CameraPosition = { -- camera position for the character editor
            Position = vector3(-1792.93, -393.17, 160.67),
            Heading = 145.25,
            MaxUp = 161.45,
            MaxDown = 145.31,
        },
        TypeOfShop = "clothing",                           -- means all will be avaialble with a price to be paid to enter
        DrawLight = false,                                 -- if you need a light in the store put true
    },
    {                                                      -- Tumblweed
        Prompt = {
            Position = vector3(-5483.24, -2933.42, -0.35), -- prompt location
            Label = "Enter Clothing Store",                -- prompt label
        },
        Npc = {
            Enable = true,
            Model = "CS_FRANCIS_SINCLAIR",
            Position = vector4(-5484.07, -2932.47, -0.35, 188.13),
            Scenario = 'WORLD_HUMAN_STAND_WAITING',
        },
        Blip = {
            Enable = true,
            Sprite = 1195729388,
            Name = "Tumbleweed Clothing Store",
            -- Color = 'BLIP_MODIFIER_MP_COLOR_23',
        },
        EditCharacter = { -- where the player will be teleported to edit character
            Position = vector4(-5480.05, -2932.88, -0.32, 229.49),
        },
        SpawnBack = { -- where the player will be teleported to after editing character
            Position = vector4(-5483.36, -2934.59, -0.35, 89.65),
        },
        CameraPosition = { -- camera position for the character editor
            Position = vector3(-5479.10, -2934.15, 0.17),
            Heading = 40.58,
            MaxUp = 0.78,
            MaxDown = -1.20,
        },
        TypeOfShop = "clothing",                           -- means all will be avaialble with a price to be paid to enter
        DrawLight = false,                                 -- if you need a light in the store put true
    },
    {                                                      -- Armadillo
        Prompt = {
            Position = vector3(-3686.21, -2626.6, -13.38), -- prompt location
            Label = "Enter Clothing Store",                -- prompt label
        },
        Npc = {
            Enable = true,
            Model = "CS_FRANCIS_SINCLAIR",
            Position = vector4(-3686.39, -2628.62, -13.38, 319.32),
            Scenario = 'WORLD_HUMAN_STAND_WAITING',
        },
        Blip = {
            Enable = true,
            Sprite = 1195729388,
            Name = "Armadillo Clothing Store",
            -- Color = 'BLIP_MODIFIER_MP_COLOR_23',
        },
        EditCharacter = { -- where the player will be teleported to edit character
            Position = vector4(-3688.98, -2630.14, -13.35, 6.45),
        },
        SpawnBack = { -- where the player will be teleported to after editing character
            Position = vector4(-3685.82, -2627.58, -13.38, 316.62),
        },
        CameraPosition = { -- camera position for the character editor
            Position = vector3(-3689.07, -2627.43, -12.97),
            Heading = 179.85,
            MaxUp = -12.48,
            MaxDown = -13.89,
        },
        TypeOfShop = "clothing", -- means all will be avaialble with a price to be paid to enter
        DrawLight = false,       -- if you need a light in the store put true
    },
    -- add more here
}


ConfigShops.Prices = {
    clothing = {
        CoatClosed = {
            price = 10,                                       -- if extra is enabled it will look for that and assignt hat price  instead
            extra = {
                { comp = 33333333, price = 20, currency = 0 } -- example of making some clothing to have a different prices
                --add more  if you want
            }
        },
        Hat = { price = 10 },
        EyeWear = { price = 10 },
        Mask = { price = 10 },
        NeckWear = { price = 10 },
        NeckTies = { price = 10 },
        Shirt = { price = 10 },
        Vest = { price = 10 },
        Coat = { price = 10 },
        Poncho = { price = 10 },
        Cloak = { price = 10 },
        Glove = { price = 10 },
        Bracelet = { price = 10 },
        Buckle = { price = 10 },
        Pant = { price = 10 },
        Skirt = { price = 10 },
        Chap = { price = 10 },
        Boots = { price = 10 },
        Spurs = { price = 10 },
        Spats = { price = 10 },
        GunbeltAccs = { price = 10 },
        Gauntlets = { price = 10 },
        Loadouts = { price = 10 },
        Accessories = { price = 10 },
        Satchels = { price = 10 },
        Dress = { price = 10 },
        Belt = { price = 10 },
        Holster = { price = 10 },
        Suspender = { price = 10 },
        armor = { price = 10 },
        Gunbelt = { price = 10 },
        RingLh = { price = 10 },
        RingRh = { price = 10 },
    },
    hair = {
        eyebrows = {
            price = 10,
        },
        Hair = {
            price = 10,
        },
        Beard = {
            price = 10,
        },
        bow = { -- females only
            price = 10,
        },
        beardstabble = { -- shaved beard
            price = 10,
        },
        hair = { -- shaved head
            price = 10,
        },
    },
    makeup = {
        lipsticks = {
            price = 10,
        },
        blush = {
            price = 10,
        },
        shadows = {
            price = 10,
        },
        eyeliners = {
            price = 10,
        },
        grime = {
            price = 10,
        },
        foundation = {
            price = 10,
        },
        paintedmasks = {
            price = 10,
        },
    },
    face = {
        Teeth = {
            price = 10,
        },
        head = {
            price = 10,
        },
        eyesandbrows = {
            price = 10,
        },
        ears = {
            price = 10,
        },
        cheek = {
            price = 10,
        },
        jaw = {
            price = 10,
        },
        chin = {
            price = 10,
        },
        nose = {
            price = 10,
        },
        mouthandlips = {
            price = 10,
        },
        upperbody = {
            price = 10,
        },
        lowerbody = {
            price = 10,
        },
    },
    lifestyle ={
        spots ={
            price = 10,
        },
        moles ={
            price = 10,
        },
        grime ={
            price = 10,
        },
        freckles ={
            price = 10,
        },
        disc ={
            price = 10,
        },
        complex ={
            price = 10,
        },
        acne ={
            price = 10,
        },
        scars ={
            price = 10,
        },
    }
  
}
