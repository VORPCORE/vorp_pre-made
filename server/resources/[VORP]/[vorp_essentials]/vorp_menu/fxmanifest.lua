fx_version 'adamant'
game 'rdr3'
author 'vorp @outsider' --  SLIZZARN original author
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

client_scripts {
	'client/main.lua'
}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/css/app.css',
	'html/css/*.png',
	'html/js/mustache.min.js',
	'html/js/app.js',
	'html/fonts/*ttf',
}

version '1.0'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_menu'
