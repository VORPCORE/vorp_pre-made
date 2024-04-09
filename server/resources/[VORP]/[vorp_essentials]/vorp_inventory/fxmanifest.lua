fx_version 'cerulean'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
author 'VORP'
repository 'https://github.com/VORPCORE/vorp_inventory-lua'
description 'Inventory System for RedM VORPCore framework'

lua54 'yes'

shared_scripts {
  "config/config.lua",
  "config/weapons.lua",
  "config/ammo.lua",
  "config/logs.lua",
  "languages/*.lua",
  "shared/models/*.lua",
  'shared/handler/*.lua',
  "shared/services/*.lua",
  "shared/services/Regex.js",
}

client_scripts {
  'client/client.lua',
  'client/models/*.lua',
  'client/services/*.lua',
  'client/controllers/*.lua',
  '@vorp_core/client/dataview.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/server.lua',
  'server/models/*.lua',
  'server/services/*.lua',
  'server/controllers/*.lua',
  'vorpInventoryApi.lua',
  'server/respawn.lua',

}

files { 'html/**/*' }
ui_page 'html/ui.html'

server_exports { 'vorp_inventoryApi' }

-- version
version '3.5'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_inventory-lua'
