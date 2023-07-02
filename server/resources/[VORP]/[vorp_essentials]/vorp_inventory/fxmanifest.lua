game 'rdr3'
fx_version 'cerulean'
author 'VORP Core'
description 'VORP Inventory'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
ui_page 'html/ui.html'
lua54 'yes'

client_scripts {
  'client/models/*.lua',
  'client/handler/*.lua',
  'client/services/*.lua',
  'client/controllers/*.lua',
  'client/*.lua',
}

server_scripts {
  'server/models/*.lua',
  'server/handler/*.lua',
  'server/services/*.lua',
  'server/controllers/*.lua',
  'vorpInventoryApi.lua',
  'server/*.lua',
  '@oxmysql/lib/MySQL.lua'
}

shared_scripts {
  "config.lua",
  "languages/*.lua",
  "shared/models/*.lua",
  "shared/services/*.lua",
  "shared/services/Regex.js"
}

files { 'html/**/*' }

server_exports { 'vorp_inventoryApi' }


version '2.6'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_inventory-lua'
