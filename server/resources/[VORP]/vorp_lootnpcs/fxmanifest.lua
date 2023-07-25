fx_version "cerulean"
game "rdr3"

author 'refactor by @outsider31000'
lua54 'yes'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

exports {
    'DataViewNativeGetEventData2'
}

client_scripts { 'client.lua', 'client.js' }
shared_script 'config.lua'
server_script 'server.lua'
