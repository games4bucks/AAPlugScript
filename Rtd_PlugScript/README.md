🚀 Standalone Drug Plug - FiveM Script

📌 Description

This Standalone Drug Plug script allows players to own a plug and manage drug transactions in FiveM. This means only authorized players can sell drugs, unless configured to allow anyone to buy. The script supports QB-Core, ESX, OX Inventory, Codem Inventory, PS Inventory, and AK47 QB Inventory while including animations, notifications, and a cooldown system.

🌟 Features

🏬 Own a Drug Plug: Only authorized players can buy unless set for public.

🎭 Persistent Drug Dealers: Peds spawn at set locations and play animations.

⏳ Cooldown System: Players must wait before purchasing again.

💰 Payment System: Supports cash, bank, or custom inventory payments.

🎞️ Transaction Animations: Realistic money exchange with props.

🔒 Authorized Buyers: Restrict purchases to licensed players or allow public transactions.

🛠 Framework Compatibility: Works with QB-Core, ESX, and OX Inventory.

🏦 Inventory Compatibility: Supports qb-inventory, ox_inventory, codem-inventory, ps-inventory, ak47_qb_inventory.

🔔 Notification System Compatibility: Works with qb-notify, ox_lib, okokNotify, mNotification, ps-ui.

📂 Installation

Download & Extract

Move the folder to resources/ in your FiveM server.

Add to Server.cfg

Open your server.cfg and add:

ensure Rtd_Plugscript

Configure Settings

Open config.lua and update the inventory system:

Config.Inventory = "codem-inventory" -- Options: "qb-inventory", "ox-inventory", "ps-inventory", "ak47_qb_inventory", "esx"

Open config.lua and update the notification system:

Config.Notification = "ox" -- Options: "qb", "okok", "mNotify", "ps-ui"

Setting Player License for Ownership:

To require a license for purchases:

Config.RequireLicense = true -- Set to false to allow anyone to buy

Each plug in config.lua has an authorization section:

Authorized = {
    License = "license:699e9d59160e73f7fb8e775e76f4e75554f1d44d" -- Set a specific license ID or leave nil to disable restriction
}

Customizing Items & Prices:

Each plug can be edited in config.lua. Example:

CokePlug = {
    TextNotification = "Press ~INPUT_CONTEXT~ to gather Cocaine for $1200000 per 2000 pounds",
    Items = {
        { label = "Coke", item = "coke_pure", amount = 2000, price = 1200000 }
    },
    ped = {
        coords = vector4(-98.6536, -2232.4239, 7.8117, 319.3485),
        ped = 'cs_lestercrest'
    },
    Authorized = {
        License = "license:your-license-id"
    }
}

To add more plugs, duplicate this format and modify item names, prices, and locations.

🛠 Dependencies

QB-Core (optional)

ESX (optional)

OX Inventory (optional)

Codem Inventory (optional)

PS Inventory (optional)

AK47 QB Inventory (optional)

🖥️ Commands

Press E near a drug plug to make a purchase (default keybinding).

The cooldown system prevents spamming purchases.
