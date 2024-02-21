# VORP Animations

## What is this script?
An animation tool for other scripts to utilize. The goal of this script is to make interacting with animations much easier for other developers. This Script allows other script creators to leverage pre-made animations and animation combos with ease of use in mind.

## How to install
* Download this repo
* Copy and paste `vorp_animations` folder to `resources/vorp_animations`
* Add `ensure vorp_animations` to your `server.cfg` file
* Now you are ready to get coding!

## Screen Shot
![image](https://user-images.githubusercontent.com/10902965/184693638-fb6aab24-721b-4c29-a69b-57daf62b0bda.png)

## Documentation

### How to initialize the animation API

```lua
local Animations = exports.vorp_animations.initiate()
```

### How to play an animation
`Animations.playAnimation(animationname, length)`

Example:
```lua
Animations.playAnimation('campfire', 2000)
```

### How to add a custom prop to an animation
`setCustomProp(propobject)`
__This must be used before playing an animation to take effect__

Example:
```lua
Animations.setCustomProp({
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
})
```

### How to start an animation with no end
`Animations.startAnimation(animationname)`

Example:
```lua
Animations.startAnimation('campfire')
```

### How to end an animation
`Animations.playAnimation(animationname)`

Example:
```lua
Animations.endAnimation('campfire')
```

### Animation DevTool

_To Activate set `Config.DevTools` to true and then in-game use the `/startanimation animationname` command_
![image](https://user-images.githubusercontent.com/10902965/184692733-c450aff6-e793-43b3-880b-ba1563199cc1.png)

#### View Current animation
- Displays the current animation playing

#### Prop Live endAnimation
- Lets you manipulate the main props location easily and lets you copy the coords to the config easily

#### Command List
- A DevTool Command list

### How to add an animation
New animations should be added and PR'd to this repo to ensure the best animation for all!

Animations can be added via the config.lua of this scripts

_Where to find animation dict and name:_ https://raw.githubusercontent.com/femga/rdr3_discoveries/master/animations/ingameanims/ingameanims_list.lua

```lua
-- ["nameofyouranimation"] = {
--     dict = "amb_camp@world_camp_fire_cooking@male_d@wip_base",
--     name = "wip_base",
--     flag = 17, -- This is a flag that limits where the animation plays on the character
--     type = 'standard', -- standard or scenario, not super well supported yet
--     prop = { -- If you want a prop to be within the animation
--         model = 'p_stick04x', -- What model should be shown for th prop
--         coords = { -- Where should the prop be placed 
--             x = 0.2, 
--             y = 0.04,
--             z = 0.12,
--             xr = 170.0,
--             yr = 50.0,
--             zr = 0.0
--         },
--         bone = 'SKEL_R_Finger13', -- what bone should the prop be connected too
--         subprops = { -- Add more props and locations
--             {
--                 model = 's_meatbit_chunck_medium01x',
--                 coords = {
--                     x = -0.30, 
--                     y = -0.08,
--                     z = -0.30,
--                     xr = 0.0,
--                     yr = 0.0,
--                     zr = 70.0
--                 }
--             }
--         }
--     }
-- },
```

## Need More Support? 
- [Vorp Disord](https://discord.gg/DHGVAbCj7N)
