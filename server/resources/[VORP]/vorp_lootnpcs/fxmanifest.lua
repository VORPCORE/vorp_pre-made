fx_version "cerulean"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game "rdr3"

author 'refactor by @outsider31000'
lua54 'yes'
description 'A npc looting script for vorp core framework'
repository 'https://github.com/VORPCORE/vorp_lootnpcs'

exports {
    'DataViewNativeGetEventData2'
}

client_scripts {
    'client/client.lua',
    'client/client.js'
}

shared_script {
    'shared/translation.lua',
    'config.lua'
}

server_script {
    'server/server.lua'
}

dependencies {
    'vorp_core',
    'vorp_inventory'
}

version '1.3'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_lootnpcs'
