fx_version 'adamant'
games { 'rdr3' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'VORP @outsider'
description 'VORP admin menu'

ui_page 'html/index.html'

client_scripts {
    'client/*.lua',
}

shared_script {
    'config.lua',
    'locale.lua',
    'languages/*.lua',
}

server_scripts {
    'server/*.lua',
}

files { -- Credits to https://github.com/LVRP-BEN/bl_coords for clipboard copy method
    'html/index.html',
    'html/index.js'
}
--version check dont touch
version '1.0'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_admin'
