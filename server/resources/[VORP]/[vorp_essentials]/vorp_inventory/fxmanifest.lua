fx_version 'cerulean'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
author 'VORP'
repository 'https://github.com/VORPCORE/vorp_inventory-lua'
description 'Inventory System for RedM VORPCore framework'

lua54 'yes'

ui_page 'html/ui.html'

shared_scripts {
  "config/config.lua",
  "config/weapons.lua",
  "config/ammo.lua",
  "languages/*.lua",
  "shared/models/*.lua",
  'shared/handler/*.lua',
  "shared/services/*.lua",
  "shared/services/Regex.js",
}

client_scripts {
  'client/models/*.lua',
  'client/services/*.lua',
  'client/controllers/*.lua',
  'client/*.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/models/*.lua',
  'server/services/*.lua',
  'server/controllers/*.lua',
  'vorpInventoryApi.lua',
  'server/*.lua',
}


files { 'html/**/*' }

server_exports { 'vorp_inventoryApi' }

-- version
version '3.0'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_inventory-lua'
