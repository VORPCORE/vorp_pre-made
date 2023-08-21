# Inventory  System for VORPCore framework in Lua

## Requirements
- [vorp_core](https://github.com/VORPCORE/vorp-core-lua) Lua

## How to install
* Download the lastest version of vorp_nventory
* Copy and paste ```vorp_inventory``` folder to ```resources/[VORP]essentials/vorp_inventory```
* Add ```ensure vorp_inventory``` to your ```resource.cfg``` file
* To change the language go to ```languages/language.lua``` and change the default language in config


## Extensive API
* using a single export on top of your server and client files as a function triggering events `that can also be used/listen` with callbacks using Lua promisses
* single exports for each API function * NEW

## Features
* Unique weapons equip unequip
* give ammo from your belt
* drop give pick up functions
* usable items double click or right click
* KLS.
* metadata for items
* storage/stashes API
* on respawn clear weapons items money ammo
* jobs can hold more weapons
* items and weapons with groups
* item give on first connection and weapons
and much more


![image](https://user-images.githubusercontent.com/87246847/156600012-3901dac7-73f8-4577-a8f5-9a60d7e3150b.png)
<img width="354" alt="image" src="https://user-images.githubusercontent.com/87246847/156600211-cc3fc70f-60bb-4884-971a-1d2ad4fdb8ad.png">
<img width="286" alt="image" src="https://user-images.githubusercontent.com/87246847/176539805-57997f6d-967d-4341-bdf6-cf88f2277a0f.png">

## Extra Features
* All features from vorp_inventory_lua 1.0.7
* Description of all items in DB
* Gold item like Dollars (You can give and drop item)
- You can choose if using Gold like Dollars in config.lua and config.js
- Added descriptions of each item in inventory, for items (desc is in DB), for weapons (desc is in shared/weapons.lua)


## DOCUMENTATION

[vorp_inventory](https://vorpcore.github.io/VORP_Documentation/api/inventory)


## Credits
- To [Val3ro](https://github.com/Val3ro) for the initial work.
- to [Emolitt](https://github.com/RomainJolidon) and [Outsider](https://github.com/outsider31000) for finishing/testing.   
- Credits to Vorp Team for creating the C# version and [Local9](https://github.com/Local9).
- to [blue](https://github.com/kamelzarandah) for making this possible
