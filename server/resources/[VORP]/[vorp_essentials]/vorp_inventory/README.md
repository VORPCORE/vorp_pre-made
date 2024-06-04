# Inventory  System for VORPCore framework in Lua

## Requirements
- [vorp_core](https://github.com/VORPCORE/vorp-core-lua) Lua

## How to install
* Download the lastest version of vorp_nventory
* Copy and paste ```vorp_inventory``` folder to ```resources/[VORP]essentials/vorp_inventory```
* Add ```ensure vorp_inventory``` to your ```resource.cfg``` file
* To change the language go to ```languages/language.lua``` and change the default language in config


## Extensive API
* using a single export on top of your server and client files
* single exports for each API function * NEW

## Features
* wieght inventory based `(with limit for items)`
* Unique weapons equip unequip
* weapons with serial numbers
* weapons custom labels serial numbers and descriptions
* weight for weapons and items
* give ammo from your belt
* drop give pick up functions
* usable items double click or right click
* KLS.
* metadata for items
* storage/stashes API
* on respawn clear weapons items money ammo
* jobs can hold more weapons
* items and weapons with groups
* item give on first connection and weaponsand much more


![image](https://cdn.discordapp.com/attachments/835823498840375316/1229123830077718618/image.png?ex=662e89c5&is=661c14c5&hm=5fcda3b1b3a29632e2ee63c346c8077dc0e9e8dbdc96491e12b832dc762bfcd4&)

<img width="354" height="520"  alt="image" src="https://cdn.discordapp.com/attachments/844700329933013032/1229407443998609458/image.png?ex=662f91e7&is=661d1ce7&hm=a19316783828c4f2e51fe2b518180f9b58b1cea64b7225100fea16d36c53d478&">
<img width="354" height="520" alt="image" src="https://cdn.discordapp.com/attachments/844700329933013032/1229407600483897374/image.png?ex=662f920d&is=661d1d0d&hm=beaaea8da00a4c2e0ddac24fec6600cfcf5cf9bb4846d65ca6edca605c6d5e1f&">

## Extra Features
* Description of all items in DB
* Gold item like Dollars (You can give and drop item)
* You can choose if using Gold like Dollars in config.lua and config.js
* Added descriptions of each item in inventory, for items (desc is in DB), for weapons (desc is in shared/weapons.lua)


## DOCUMENTATION

[vorp_inventory](https://vorpcore.github.io/VORP_Documentation/api/inventory) 


## Credits
- To [Val3ro](https://github.com/Val3ro) for the initial work.
- to [Emolitt](https://github.com/RomainJolidon) and [Outsider](https://github.com/outsider31000) for finishing/testing.   
- Credits to Vorp Team for creating the C# version and [Local9](https://github.com/Local9).
- to [blue](https://github.com/kamelzarandah) for making this possible
