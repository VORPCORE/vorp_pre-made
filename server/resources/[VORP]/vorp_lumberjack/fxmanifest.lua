fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'VORP @blue'
description 'A lumberjack script for vorp core framework'
repository 'https://github.com/VORPCORE/vorp_lumberjack'

shared_scripts {
    'config.lua',
    'shared/*.lua'
}
client_script 'client/client.lua'
server_script 'server/server.lua'

dependencies {
      'syn_minigame'
}

version '1.0'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_lumberjack'
