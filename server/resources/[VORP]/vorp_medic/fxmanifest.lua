fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'VORP @outsider'
description 'A medical scrpt for vorp core framework'
repository 'https://github.com/VORPCORE/vorp_medic'
lua54 'yes'

shared_scripts {
    'configs/config.lua',
    'languages/translation.lua'
}
client_script 'client/main.lua'
server_scripts {
    'server/main.lua',
    'configs/logs.lua',

}
version '0.2'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_medic'
