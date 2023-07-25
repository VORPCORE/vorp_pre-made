fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

-- Initial Convertion from C# to lua by grumpypoo
-- refactor by outsider
author 'VORP @outsider'
game 'rdr3'
lua54 'yes'

shared_scripts {
	'config.lua',
	'shared/*.lua'
}

client_scripts {
	'client/*.lua',
	'client/notify.js'
}

server_scripts {
	'server/*.lua',
}

files {
	--'ui/*',
	'images/*png',
	'clothingfemale/*png',
}

--========= VERSION =============--

version '1.4'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_character-lua'

-- this script is protected under its license.
