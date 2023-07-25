game 'rdr3'
fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
lua54 'yes'
author "VORP @Bytesizd"

client_scripts {
  'client/data/*.lua',
  'client/services/*.lua',
  'client/*.lua'
}

server_scripts {
  'server/main.lua',
  'server/helpers/*.lua',
  'server/services/*.lua'
}

shared_scripts {
  'shared/helpers/*.lua',
  'shared/services/*.lua'
}

version '1.1.1'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_utils'
