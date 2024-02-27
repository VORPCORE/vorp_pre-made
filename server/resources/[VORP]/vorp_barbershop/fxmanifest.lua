fx_version "adamant"
game 'rdr3' 
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'VORP @blue'
description 'A barber shop for vorp core framework'
repository 'https://github.com/VORPCORE/vorp_barbershop_lua'

shared_scripts {
	'config.lua',
	'shared/*.lua'
}
client_scripts {
	'client/dataview.lua',
	'client/client.lua',
	'config.lua',
	'client/cloth_hash_names.lua'
}
server_script 'server/server.lua'

version '1.0'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_barbershop_lua'
