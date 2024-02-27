fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'
lua54 'yes'

-- Initial Convertion from C# to lua by grumpypoo
author 'VORP refactored by @outsider'
description 'A Character creator with also shops built in for vorpcore framework'
repository 'https://github.com/VORPCORE/vorp_character-lua'

shared_scripts {
	'config.lua',
	'config_shops.lua',
	'shared/utils.lua',
	'shared/translation.lua',
}

client_scripts {
	'@vorp_core/client/dataview.lua',
	'shared/clothing.lua',
	'shared/hairs.lua',
	'client/*.lua',
	'client/notify.js',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua',
}

files {
	--'ui/*',
	'images/*png',
	'images/CreatorImages/*png',
	'clothingfemale/*png',
}

--========= VERSION =============--

version '1.6'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_character-lua'

-- this script is protected under its license.
