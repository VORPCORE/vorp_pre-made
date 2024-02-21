Config = {}

Config.MinimumDistance = 2.0 -- Minimum distance required to enable prompts for digging and picking up reward item

Config.Timeout = 2           -- Timeout (in minutes)

Config.ShowUsedNodePrompt = true    -- Show greyed out prompt on used nodes

-- Pre-spawned plants to check for. Leave blank to not have any prompts spawn on world objects.
Config.Plants = {
    {                                               -- Follow this format exactly when adding in new world plants
        hash = joaat("s_inv_blackberry01x"),        -- Plant name as a hash value
        name = "Blackberry",                        -- Plant name to be displayed in prompt
        reward = "blackberry",                      -- Plant db reward item
        minReward = 1,                              -- Minimum reward per plant (optional, defaults to 1!)
        maxReward = 5                               -- Maximum reward per plant (optional, defaults to 1!)
    },
    {                                              
        hash = joaat("s_indiantobacco01x"),       
        name = "Indian Tobbaco",                       
        reward = "Indian_Tobbaco",                      
        minReward = 1,                              
        maxReward = 5                               
    },
	    {                                             
        hash = joaat("crp_cotton_bd_sim"),      
        name = "Cotton",                      
        reward = "cotton",                      
        minReward = 1,                             
        maxReward = 5                           
    },
		{                                               
        hash = joaat("rdr_bush_dry_thin_ba_sim"),        
        name = "blueberry",                        
        reward = "blueberry",                    
        minReward = 1,                            
        maxReward = 5                              
    },
		{                                             
        hash = joaat("rdr_bush_ficus_aa_sim"),      
        name = "Oregano",                       
        reward = "Oregano",                      
        minReward = 1,                           
        maxReward = 5                           
    },
		{                                             
        hash = joaat("rdr_bush_bram_aa_sim"),      
        name = "Basil",                       
        reward = "Basil",                      
        minReward = 1,                           
        maxReward = 5                           
    },
		{                                             
        hash = joaat("rdr_bush_thick_aa_sim"),      
        name = "Agarita",                       
        reward = "Agarita",                      
        minReward = 1,                           
        maxReward = 5                           
    },
		{                                             
        hash = joaat("rdr_bush_lrg_aa_sim"),      
        name = "Creeking Thyme",                       
        reward = "Creeking_Thyme",                      
        minReward = 1,                           
        maxReward = 5                           
    },
		{                                             
        hash = joaat("rdr_bush_bram_dead_aa_sim"),      
        name = "Milk Weed",                       
        reward = "Milk_Weed",                      
        minReward = 1,                           
        maxReward = 5                           
    },
		{                                             
        hash = joaat("rdr_bush_brush_grn_aa_sim"),      
        name = "Crows Garlic",                       
        reward = "Crows_Garlic",                      
        minReward = 1,                           
        maxReward = 5                           
    },
		{                                             
        hash = joaat("p_sap_poplar_ab_sim"),      
        name = "English Mace",                       
        reward = "English_Mace",                      
        minReward = 1,                           
        maxReward = 5                           
    },
		{                                             
        hash = joaat("rdr_bush_thorn_aa_sim"),      
        name = "Hummingbird Sage",                       
        reward = "Hummingbird_Sage",                      
        minReward = 1,                           
        maxReward = 5                           
    }, 
			{                                             
        hash = joaat("rdr_bush_creosotebush"),      
        name = "Oleander Sage",                       
        reward = "Oleander_Sage",                      
        minReward = 1,                           
        maxReward = 5                           
    },
		{                                             
        hash = joaat("rdr2_bush_desertbroom"),      
        name = "Desert Sage",      	
        reward = "Desert_Sage",                      
        minReward = 1,                           
        maxReward = 5                           
    },
		{                                             
        hash = joaat("rdr_bush_sumac_aa_sim"),      
        name = "American Ginseng",                       
        reward = "American_Ginseng",                      
        minReward = 1,                           
        maxReward = 5                           
    },
		{                                             
        hash = joaat("rdr_bush_mang_aa_sim"),      
        name = "Alaskan Ginseng",                       
        reward = "Alaskan_Ginseng",                      
        minReward = 1,                           
        maxReward = 5                           
    },
		{                                             
        hash = joaat("rdr_bush_leafy_aa_sim"),      
        name = "Red Raspberry",                       
        reward = "Red_Raspberry",                      
        minReward = 1,                           
        maxReward = 5                           
    },	
    {                                   
        hash = joaat("p_tree_apple_01"),       
        name = "Apple",                     
        reward = "apple",                   
        minReward = 1,                          
        maxReward = 5                              
    },
    {
        hash = joaat("crp_wheat_dry_aa_sim"),
        name = "Grain",
        reward = "Grain",
        minReward = 1,
        maxReward = 5  
    },
    {                                             
        hash = joaat("rdr_bush_agave_aa_sim"),       
        name = "Agave",                        
        reward = "Agave",                     
        minReward = 1,                              
        maxReward = 5                             
    },
	    {                                             
        hash = joaat("rdr_bush_scrub_aa_sim"),       
        name = "Red Sage",                        
        reward = "Red_Sage",                     
        minReward = 1,                              
        maxReward = 5                             
    },
    {                                             
        hash = joaat("blackcurrant_p"),       
        name = "Black Currant",                        
        reward = "Black_Currant",                     
        minReward = 1,                              
        maxReward = 5                             
    },
    {                                             
        hash = joaat("rdr_bush_aloe_aa_sim"),       
        name = "Bitter Weed",                        
        reward = "Bitter_Weed",                     
        minReward = 1,                              
        maxReward = 5                             
    },
    {                                             
        hash = joaat("rdr2_bush_desertironwood"),       
        name = "Evergreen Huckleberry",                        
        reward = "Evergreen_Huckleberry",                     
        minReward = 1,                              
        maxReward = 5                             
    },
    {                                             
        hash = joaat("rdr_bush_cat_tail_aa_sim"),       
        name = "Bulrush",                        
        reward = "Bulrush",                     
        minReward = 1,                              
        maxReward = 5                             
    },
    {                                             
        hash = joaat("p_sap_poplar_aa_sim"),       
        name = "Wisteria",                        
        reward = "Wisteria",                     
        minReward = 1,                              
        maxReward = 5                             
    },
    {                                             
        hash = joaat("rdr2_bush_scruboak"),       
        name = "Wild Rhubarb",                        
        reward = "Wild_Rhubarb",                     
        minReward = 1,                              
        maxReward = 5                             
    },
    {                                             
        hash = joaat("rdr2_bush_scruboak"),       
        name = "Wintergreen Berry",                        
        reward = "Wintergreen_Berry",                     
        minReward = 1,                              
        maxReward = 5                             
    },
    {                                             
        hash = joaat("crp_sugarcane_ac_sim"),       
        name = "Sugarcane",                        
        reward = "sugar",                     
        minReward = 1,                              
        maxReward = 5                             
    }
}

-- Default locations. Feel free to add more, just follow the existing template. Leave blank to not have any plants or prompts spawn.
Config.Locations = {
    -- Fully customized node (spawns in custom objects via coords)
    {
        name = "Tobacco Plant",                     -- Area name
        reward = "Indian_Tobbaco",                  -- Reward item database name
        plantModel = "s_indiantobacco01x",          -- Plant model to spawn (optional!)
        coords = vector3(2018.05, -880.44, 42.54),  -- Coordinates for plant model object
        timeout = 1,                                -- Custom timeout per node (optional, in minutes!)
        minReward = 1,                              -- Minimum reward per plant (optional, defaults to 1!)
        maxReward = 5                               -- Maximum reward per plant (optional, defaults to 1!)
    },
    -- Partially customized node (uses coords to create prompt, preferrably near existing world objects)
    -- Orchard Near Saint Denis --
    {
        name = "Orange Tree",                        -- Area name
        reward = "orange",                           -- Reward item database name
        coords = vector3(2009.33, -882.96, 42.96)    -- Coordinates for dirt mounds/reward item objects
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1999.68, -883.71, 42.91)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1989.15, -882.77, 42.36)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1981.92, -882.38, 42.4)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1971.59, -876.93, 42.03)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1981.15, -875.14, 42.45)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1987.82, -873.35, 42.68)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1999.6, -873.65, 42.42)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(2009.29, -872.42, 42.34)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(2018.73, -873.18, 42.77)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(2036.01, -864.92, 42.6)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(2027.38, -865.86, 42.56)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(2018.2, -865.97, 42.6)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1960.38, -856.78, 42.12)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(2008.23, -865.35, 42.86)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1999.31, -865.48, 42.89)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1989.77, -864.45, 42.47)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1979.89, -866.82, 41.85)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1970.7, -866.3, 41.55)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1962.55, -866.43, 41.71)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1970.33, -858.09, 41.96)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(1979.69, -856.79, 41.93)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(1987.9, -855.47, 42.38)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(1997.71, -855.62, 42.69)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(2007.12, -854.76, 42.8)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(2017.02, -853.6, 42.81)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(2026.87, -855.13, 42.57)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(2036.59, -854.72, 42.4)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(2036.57, -845.5, 42.8)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(2027.04, -845.69, 43.03)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(2017.53, -844.59, 43.14)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(2007.35, -845.59, 42.92)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(1998.93, -845.95, 42.65)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1988.51, -846.2, 42.32)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1979.88, -847.81, 42.1)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1970.52, -849.38, 41.86)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1961.45, -848.45, 41.9)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1987.28, -837.99, 42.13)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1996.8, -837.54, 42.28)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(2006.63, -836.59, 42.44)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(2016.89, -836.21, 42.86)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(2026.19, -835.05, 42.73)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(2035.89, -835.05, 42.55)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(2027.24, -826.91, 42.32)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(2007.3, -826.9, 42.26)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(2017.68, -827.99, 42.33)
    },
    -- Braithwaite Orchard --
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(1051.53, -1731.91, 46.81)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(1050.98, -1741.04, 46.73)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(1052.01, -1749.82, 46.81)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(1051.53, -1758.96, 46.85)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(1050.71, -1768.72, 46.87)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(1051.72, -1778.53, 47.1)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(1059.81, -1797.46, 48.32)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(1059.52, -1788.41, 47.96)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(1060.63, -1779.88, 47.77)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(1059.94, -1769.92, 47.47)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(1061.08, -1759.55, 47.42)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(1060.7, -1750.92, 47.33)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(1059.99, -1741.61, 47.22)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(1059.63, -1733.98, 47.18)
    },
    {
        name = "Apple Tree",                       
        reward = "apple",                         
        coords = vector3(1057.89, -1723.74, 47.22)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1069.0, -1713.32, 48.32)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1068.46, -1721.85, 48.2)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1069.36, -1731.84, 48.18)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1070.92, -1740.19, 48.28)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1069.19, -1748.79, 48.08)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1070.34, -1759.5, 48.21)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1068.87, -1767.7, 48.13)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1068.94, -1777.57, 48.32)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1068.3, -1786.75, 48.56)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1068.7, -1796.17, 48.91)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1069.08, -1806.43, 49.04)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1078.13, -1807.23, 48.87)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1077.29, -1797.22, 49.11)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1079.04, -1788.33, 49.21)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1078.82, -1778.4, 49.26)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1078.22, -1769.87, 49.06)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1078.52, -1759.52, 49.0)
    },
    {
        name = "Orange Tree",                        
        reward = "orange",                           
        coords = vector3(1079.14, -1816.25, 48.57)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1088.54, -1816.66, 47.6)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1088.29, -1806.62, 48.18)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1088.46, -1797.53, 48.54)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1088.21, -1787.97, 48.92)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1087.5, -1778.22, 49.15)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1087.88, -1768.41, 49.37)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1087.74, -1759.34, 49.45)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1087.48, -1749.55, 49.61)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1086.87, -1740.6, 49.84)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1086.41, -1732.88, 49.92)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1078.05, -1749.62, 48.98)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1078.71, -1742.08, 49.0)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1079.07, -1732.6, 49.27)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1077.9, -1723.14, 49.25)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1078.42, -1712.51, 49.35)
    },
    {
        name = "Lemon Tree",                        
        reward = "lemon",                           
        coords = vector3(1087.0, -1722.88, 50.05)
    },
-------- Caliga Trees ------
    {
    name = "Apple Tree",                       
    reward = "apple",                         
    coords = vector3(1768.56, -1322.75, 43.82)
    },
    {
    name = "Apple Tree",                       
    reward = "apple",                         
    coords = vector3(1765.59, -1314.21, 44.08)
    },
    {
    name = "Apple Tree",                       
    reward = "apple",                         
    coords = vector3(1758.56, -1318.52, 44.23)
    },
    {
    name = "Apple Tree",                       
    reward = "apple",                         
    coords = vector3(1761.63, -1325.03, 44.35)
    }
}

-- Language text for prompts
Config.Language = {
    PromptText = "Pick",
    PromptGroupName = "Plants"
}

-- Control actions for prompts
Config.ControlAction = 0x6D1319BE -- R key
