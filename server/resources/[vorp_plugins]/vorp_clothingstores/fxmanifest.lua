fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'


author 'VORP / UnderworldServers'
description 'vorp_clothingstore lua'

client_scripts {
    'client/*.lua',

}

server_scripts {
    'server/*.lua',
}

shared_scripts {
    'config.lua',
    'shared/*.lua',
    'languages/*.lua',
}

files {
    'images/*'
}

dependencies {
    'vorp_core',
    'vorp_character',
    'menuapi'
}

version '1.1'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_clothingstores-lua'


--------------- Thanks to Artzalez, the original creator.
--------------- Refactored from C# to Lua by Bobert
--------------- https://github.com/UnderworldServers
