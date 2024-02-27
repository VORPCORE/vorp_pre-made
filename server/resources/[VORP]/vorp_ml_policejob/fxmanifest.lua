fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'VORP'
description 'A police job for vorp core framework'
repository 'https://github.com/VORPCORE/vorp_ml_policejob'

shared_scripts {
	'locale.lua',
	'locales/es.lua',
	'locales/en.lua',
}
client_scripts {
	'config.lua',
	'client/main.lua',
	'client/warmenu.lua',
	'functions.lua'
}
server_scripts {
	'config.lua',
	'server/main.lua'
}
