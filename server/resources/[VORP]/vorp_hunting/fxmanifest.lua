fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'VORP | rubi216 | Artzalez'
description 'A Hunting script for vorp core framework'
repository 'https://github.com/VORPCORE/VORP-Hunting'
lua54 'yes'


client_script {
    'config.lua',
    'client/main.lua',
    'client/main.js'
}
server_script {
    'config.lua',
    'server/main.lua'
}

exports {
    'DataViewNativeGetEventData'
}


--dont touch
version '1.0.4'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/VORP-Hunting'
