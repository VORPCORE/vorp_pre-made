fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

lua54 'yes'
author 'VORP @Bytesizd'
description 'A tool to use within your scripts for vorp core framework'
repository 'https://github.com/VORPCORE/vorp_progressbar'

shared_script 'config.lua'
client_script 'client/client.lua'

files {
    'ui/*',
    'ui/assets/*',
    'ui/assets/fonts/*'
}

ui_page 'ui/index.html'

export "initiate"

--dont touch
version '1.2.0'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_progressbar'
