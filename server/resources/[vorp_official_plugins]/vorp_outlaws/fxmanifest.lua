fx_version "adamant"
games { "rdr3" }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'VORP @outsider'
lua54 'yes'
description 'Outlaw ambush npcs'

client_scripts {
	'client/*.lua',
}

shared_scripts {
	'config.lua',
	'locale.lua',
	'languages/*.lua'
}

server_scripts {
	'server/*.lua'
}


--dont touch
version '1.0'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_outlaws'
