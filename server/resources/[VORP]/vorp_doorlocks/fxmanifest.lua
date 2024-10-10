fx_version "cerulean"
game "rdr3"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

name "vorp doorlocks"
description "Door System for RedM"
author "VORP @outsider"
lua54 'yes'

shared_script 'config.lua'
client_script 'client/main.lua'
server_script 'server/main.lua'


version '0.1'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_doorlocks'
