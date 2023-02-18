fx_version "adamant"
games { "rdr3" }
description 'loot npcs'
author 'edit by @outsider'
lua54 'yes'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

exports {
    'DataViewNativeGetEventData2'
}

server_script { 'server.lua', 'config.lua' }

client_scripts { 'client.lua', 'client.js' }
