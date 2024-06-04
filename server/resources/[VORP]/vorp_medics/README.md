# VORP-Medicine

VORP Medics and Herbalists script in Lua

## Dependency

* VORP-Core: version 1.4 or higher
* VORP-Inventory version 1.0.7 or higher

This script may **not** work properly with VORP-Metabolism!

## Installation

* Download and put into `server-data/resources/`
* `ensure vorp_medics` in server.cfg
* edit the config
* run database.sql

**ATTENTION** you need updated images in vorp_inventory

## Features

* Doctor's job with locations in Saint-Denis, Valentine, Strawberry with Blips (you can add extra locations in config.lua)
* A starting point to become herbalist in all five states without blips (you can add extra)
* Doctors can revive using `syringe`
* Doctors can treat patients with full recover using `consumable_medicine`
* Doctors can treat patients (adding up to 40% health) and sell `bandage`
* Doctors can treat patients at their locations using no items
* Herbalists can treat using `herbal_medicine` and `herbal_tonic` up to 75% and 50% and sell them
* All players can use bought items to regenerate health for a short time
* Anims for reviving and treating
* Health regeneration is **off**

## Extra

This is not just a script for a doctor's job. It expands the RP in the area of medicine. With traditional medicine comes popular those days alternative medicine.
All players can become herbalists. But they have to find a place, where they can study herbalism (five camps across the map, one camp in each state). Herbalists
cannot revive players but they can treat them and sell treatment.

Players can use bought items. It will affect inner core turning on health regeneration. After period of time inner core will be reset and health regeneration *fully* stops.
VORP-Core *must be* of version 1.4 or higher as health regeneration and inner core were reworked in version 1.4.

Do **not** try to use VORP-Medicine and VORP-Metabolism. VORP-Metabolism affects inner core values
