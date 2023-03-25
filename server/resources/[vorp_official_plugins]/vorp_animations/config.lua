Config = {}
Config.DevTools = false


-- If you add new animations here, please consider raising a PR and sharing it with the community! :) 
-- Read through the README to see how to add new animations.
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
            subprops = {
                {
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
            subprops = {
                {
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
        }
    },
    ["campfire"] = {
        dict = "script_campfire@lighting_fire@male_male",
        name = "light_fire_b_p2_male_b", 
        flag = 17,
        type = 'standard'
	},
    ["riverwash"] = {
        dict = "amb_misc@world_human_wash_kneel_river@female_a@idle_a",
        name = "idle_c", 
        flag = 17,
        type = 'standard'
    },
    ["hoeing"] = {
        dict = "amb_work@world_human_farmer_hoe@male_a@base",
        name = "base", 
        flag = 17,
        type = 'standard',
        prop = {
            model = 'p_rake01x',
            coords = {
                x = 0.2, 
                y = 0.3,
                z = 0.1,
                xr = 210.0,
                yr = -90.0,
                zr = -186.0
            },
            bone = 'SKEL_L_Hand'
        }
    }
}