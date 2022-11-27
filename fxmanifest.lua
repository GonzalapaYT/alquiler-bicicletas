fx_version 'cerulean'
game 'gta5'

name 'Alquiler de bicicletas'
description 'Alquiler de bicicletas funcionando en la Legacy'
author 'Gonzalapa'
version '1.0'

shared_script '@es_extended/imports.lua'

server_scripts {
  'config.lua',
  'server/server.lua'
}

client_scripts {
  'config.lua',
  'client/client.lua'
}
