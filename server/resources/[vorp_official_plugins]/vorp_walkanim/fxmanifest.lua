fx_version "adamant"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'blue edit by @outsider'
game "rdr3"
lua54 'yes'

client_script 'client/client.lua'
shared_script {
    'config.lua',
    'locale.lua',
    'languages/*.lua'
}
server_script 'server/server.lua'

--dont touch
version '1.2'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/Vorp_walkanim'
