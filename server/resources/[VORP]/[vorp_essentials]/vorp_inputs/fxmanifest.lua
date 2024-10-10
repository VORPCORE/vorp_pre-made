fx_version 'adamant'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'VORP converted by @Emollit' -- conversion from C# VORP INPUTS
description 'An Input tool to use in your scripts for vorp core framework'
repository 'https://github.com/VORPCORE/vorp_inputs-lua'

client_scripts {
  'client/models/*.lua',
  'client/services/*.lua',
  'client/controllers/*.lua'
}

ui_page 'html/index.html'
files {
  'html/**/*'
}

version '1.2'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_inputs-lua'
