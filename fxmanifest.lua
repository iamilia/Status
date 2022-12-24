--[[ FX Information ]] --
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'
--[[ Resource Information ]] --
name 'Ai_ClothingMenu'
author "Ilia & Wiliam"
version '1.0.0'
url 'https://github.com/iamilia'
description "New Status From Fivem Config Enbale And Can Change Image"

--[[ Manifest ]] --
dependencies {
    '/server:5104',
    '/onesync',
}
ui_page "index.html"

files {
    "html/icons/*.png",
    "html/*.js",
    "html/*.css",
    "index.html",
}

shared_script "config.lua"

client_scripts "framework/client/*.lua"
server_scripts "framework/server/*.lua"