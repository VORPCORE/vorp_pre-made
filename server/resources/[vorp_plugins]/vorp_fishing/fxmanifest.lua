fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

shared_scripts {
	"config.lua",
	"locale.lua",
	"languages/*.lua"
}

client_scripts {
	'client/client_js.js',
	'client/client.lua',
}

server_scripts {
	'server/server.lua',
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
