fx_version 'cerulean'

shared_script "@SecureServe/src/module/module.lua"
shared_script "@SecureServe/src/module/module.js"
file "@SecureServe/secureserve.key"
game 'gta5'

author 'GC Dev'
description 'Server Info Display (ps-hud compatible transparent version)'
version '1.2.0'

ui_page 'html/index.html'
ui_page_preload "no"   -- ✅ disable black preload layer

client_script 'client.lua'
server_script 'server.lua'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/myLogo.png'
}

lua54 'yes'
