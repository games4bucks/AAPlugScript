fx_version 'cerulean'
game 'gta5'

name 'Standalone Drug Plug'
description 'A standalone ESX/QB-Core/OX Inventory script for drug plugs with animations and notifications.'
author 'RichPorter'
version '1.1.0'

-- Shared Config
shared_script 'config.lua'

-- Server Scripts
server_script 'server/server.lua' -- Updated path to server.lua

-- Client Scripts
client_script 'client/client.lua' -- Updated path to client.lua

dependencies {
    'qb-core', -- Optional, remove if not using QB-Core
    --'es_extended', -- Optional, remove if not using ESX
    'ox_inventory' -- Optional, remove if not using OX Inventory
}
