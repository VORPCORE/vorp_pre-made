fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'
author 'VORP @Bytesizd'

client_scripts {
    'client/client.lua'
}

shared_scripts {
    'config.lua'
}
files {
    'ui/*',
    'ui/assets/*',
    'ui/assets/fonts/*'
}

ui_page 'ui/index.html' -----------------------------------------------------------------------------

dependencies {
    'vorp_core'
}

export "initiate"

--dont touch
version '1.1'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_progressbar'
