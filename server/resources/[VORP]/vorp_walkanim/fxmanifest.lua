fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'


author 'VORP @outsider'
description 'A Menu to set walkstyles for vorp core framework'
repository 'https://github.com/VORPCORE/Vorp_walkanim'
lua54 'yes'

shared_script {
    'config.lua',
    'locale.lua',
    'languages/*.lua'
}
client_script 'client/client.lua'
server_script 'server/server.lua'

--dont touch
version '1.3'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/Vorp_walkanim'
