fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'VORP refactored by @blackpegasus' -- original author FRP framework
description 'A fishing script for vorp core framework'
repository 'https://github.com/VORPCORE/vorp_fishing-lua'


shared_scripts {
	"config/config.lua",
	"config/baits.lua",
	"config/baitsPerFish.lua",
	"config/fishData.lua",
	"translation/translation.lua"
}

client_scripts {
	'client/client_js.js',
	'client/client.lua'
}

server_script {
	'server/server.lua'
}

dependencies {
	'vorp_core',
	'vorp_inventory'
}

exports {
	'GET_TASK_FISHING_DATA',
	'SET_TASK_FISHING_DATA',
	'VERTICAL_PROBE'
}

--dont touch
version '1.1'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_fishing-lua'
