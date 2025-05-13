fx_version 'cerulean'
game 'gta5'
lua54 'yes'
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
    'qb-inventory', -- Optional, remove if not using Qb Inventory
    --'es_extended', -- Optional, remove if not using ESX
    --'ox_inventory', -- Optional, remove if not using OX Inventory
    --'codem-inventory', -- Optional, remove if not using Codem inventory
    --'ps-inventory', -- Optional, remove if not using ps inventory
    --'Ak47_qb_inventory', -- Optional, remove if not using ak47 qb inventory
}
escrow_ignore {
  'script/config.lua',  -- Only ignore one file
}
