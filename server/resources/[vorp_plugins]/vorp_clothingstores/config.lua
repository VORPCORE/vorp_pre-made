Config = {
  defaultlang = "En", -- Set your language, verify that it exists in vorp_clothingstore/languages/
  debugMode = false,   -- LEAVE SET TO FALSE

  Cost = {	-- Category Prices (Each item equiped adds to the total cost)
	  Hats = 4.0,
	  Glasses = 0.5,
	  Neckwear = 1.5,
	  Masks = 5.0,
	  Ties = 1.5,
	  Shirts = 0.1,
	  Suspenders = 1.5,
	  Vests = 2.5,
	  Coats = 4.5,
	  CoatsClosed = 4.5,
	  Ponchos = 3.5,
	  Cloaks = 3.5,
	  Gloves = 1.5,
	  RightRings = 0.3,
	  LeftRings = 0.3,
	  Bracelets = 0.3,
	  PrimaryHolsters = 2.0, -- "Gunbelts"
	  Belts = 1.0,
	  Buckles = 3.0,
	  SecondaryHolsters = 3.0,
	  Pants = 4.0,
	  Skirts = 3.5,
	  Chaps = 3.5,
	  Boots = 3.0,
	  Spurs = 3.0,
	  Spats = 3.0,
	  Gauntlets = 3.0,
	  Loadouts = 3.0,
	  Accessories = 3.0,
	  Satchels = 3.0,
	  GunbeltAccs = 3.0,
	  Badges = 0.5,
  },

  -- Store locations
  Stores = {
    {
      name = "Clothing Store", -- Saint Denis
      BlipIcon = 1195729388,
      EnterStore = { 2554.63, -1169.08, 53.68, 2.0 },
      ExitWardrobe =  { 2552.91, -1161.32, 52.68, 89.54 },
      Cameras = {
         { 2554.943, -1158.621, 53.58861, -2.330096, 0.0, -156.1156 }, -- Principal Camera
         { 2555.981, -1160.313, 54.39523, -11.70692, 0.0, -179.1418 }, -- Head
         { 2555.859, -1160.348, 53.56942, -1.271006, 0.0, -177.3267 }, -- Torso and Belt
         { 2555.885, -1160.515, 53.57616, -42.50001, 0.0, -175.8598 } -- Boots and Pants
      },
      StoreRoom =  { 2555.89, -1161.23, 52.6, 12.85 },
      DoorRoom =  { 2553.27, -1161.21, 53.60 },
      NPCStore =  { 2554.6, -1166.83, 52.7, 180.95 }
    },
    {
      name = "Clothing Store", -- Blackwater
      BlipIcon = 1195729388,
      EnterStore =  { -761.67, -1291.53, 43.86, 2.0 },
      ExitWardrobe =  { -764.82, -1291.39, 42.83, 271.27 },
      Cameras = {
         { -766.0403, -1294.163, 44.43269, -17.62717, 0.0, 129.3011 }, -- Principal Camera
         { -767.3044, -1295.018, 44.70681, -14.76083, 0.0, 110.0223 }, -- Head
         { -767.0049, -1294.8, 44.34212, -11.34102, 0.0, 119.205 }, -- Torso and Belt
         { -766.877, -1294.616, 43.69395, -9.997398, 0.0, 119.4959 } -- Boots and Pants
      },
      StoreRoom =  { -767.74, -1295.17, 42.84, 304.87 },
      DoorRoom =  { -766.47, -1293.27, 43.84 },
      NPCStore =  { -761.75, -1293.92, 42.84, 357.16 }
    },
    {
      name = "Clothing Store", -- Valentine
      BlipIcon = 1195729388,
      EnterStore =  { -325.99, 774.77, 117.46, 2.0 },
      ExitWardrobe =  { -322.57, 771.95, 116.44, 23.65 },
      Cameras = {
         { -326.5601, 776.4949, 122.2295, -15.07608, 0.0, 124.8089 }, -- Principal Camera
         { -328.5588, 775.3238, 122.8339, -27.55054, 0.0, 113.3157 }, -- Head
         { -328.5489, 775.331, 122.0722, -11.07298, 0.0, 111.5303 }, -- Torso and Belt
         { -328.5584, 775.3353, 121.3246, -19.40872, 0.0, 109.0525 } -- Boots and Pants
      },
      StoreRoom =  { -329.31, 775.11, 120.63, 294.79 },
      DoorRoom =  { -321.92, 764.86, 117.44 },
      NPCStore =  { -325.67, 772.63, 116.44, 11.3 }
    },
    {
      name = "Clothing Store", -- Rhodes
      BlipIcon = 1195729388,
      EnterStore =  { 1326.11, -1288.78, 77.02, 2.0 },
      ExitWardrobe =  { 1323.88, -1292.37, 76.03, 267.47 },
      Cameras = {
         { 2554.943, -1158.621, 53.58861, -2.330096, 0.0, -156.1156 }, -- Principal Camera
         { 2555.981, -1160.313, 54.39523, -11.70692, 0.0, -179.1418 }, -- Head
         { 2555.859, -1160.348, 53.56942, -1.271006, 0.0, -177.3267 }, -- Torso and Belt
         { 2555.885, -1160.515, 53.57616, -42.50001, 0.0, -175.8598 } -- Boots and Pants
      },
      StoreRoom =  { 2555.89, -1161.23, 52.6, 12.85 },
      DoorRoom =  { 1323.14, -1291.8, 77.03 },
      NPCStore =  { 1326.11, -1288.78, 76.02, 194.36 }
    },
    {
      name = "Clothing Store", -- Tumbleweed
      BlipIcon = 1195729388,
      EnterStore =  { -5483.86, -2932.48, -0.4, 2.0 },
      ExitWardrobe =  { -5482.74, -2935.01, -1.4, 80.17 },
      Cameras = {
         { 2554.943, -1158.621, 53.58861, -2.330096, 0.0, -156.1156 }, -- Principal Camera
         { 2555.981, -1160.313, 54.39523, -11.70692, 0.0, -179.1418 }, -- Head
         { 2555.859, -1160.348, 53.56942, -1.271006, 0.0, -177.3267 }, -- Torso and Belt
         { 2555.885, -1160.515, 53.57616, -42.50001, 0.0, -175.8598 } -- Boots and Pants
      },
      StoreRoom =  { 2555.89, -1161.23, 52.6, 12.85 },
      DoorRoom =  { -5481.28, -2935.14, -0.4 },
      NPCStore =  { -5483.86, -2932.48, -1.4, 137.06 }
    },
    {
      name = "Clothing Store", -- Armadillo
      BlipIcon = 1195729388,
      EnterStore =  { -3681.88, -2627.49, -13.43, 2.0 },
      ExitWardrobe =  { -3686.44, -2627.48, -14.43, 302.64 },
      Cameras = {
         { 2554.943, -1158.621, 53.58861, -2.330096, 0.0, -156.1156 }, -- Principal Camera
         { 2555.981, -1160.313, 54.39523, -11.70692, 0.0, -179.1418 }, -- Head
         { 2555.859, -1160.348, 53.56942, -1.271006, 0.0, -177.3267 }, -- Torso and Belt
         { 2555.885, -1160.515, 53.57616, -42.50001, 0.0, -175.8598 } -- Boots and Pants
      },
      StoreRoom =  { 2555.89, -1161.23, 52.6, 12.85 },
      DoorRoom =  { -3686.44, -2627.48, -13.43 },
      NPCStore =  { -3681.88, -2627.49, -14.43, 5.85 }
    }
  }

}