fx_version "adamant"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game "rdr3"
author 'Rexshack, Outsider VORP '
description 'Railroad Job'
lua54 'yes'

client_scripts {
	'client/client.lua',
	'client/npc.lua',

}
shared_script 'config.lua'

server_script 'server.lua'

dependency 'menuapi'
