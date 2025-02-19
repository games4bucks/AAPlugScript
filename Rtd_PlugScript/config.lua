Config = {}
Config.Cooldown = 120 -- Cooldown in minutes
Config.Notification = "qb" -- Change to "qb", "ox", "okok", "mNotify", "ps-ui" if needed
Config.Inventory = "qb-inventory" -- Change to "qb-inventory", "ox-inventory", "codem-inventory", "ps-inventory", "ak47_qb_inventory" if needed
Config.Plugs = {
    CokePlug = {
        TextNotification = "Press ~INPUT_CONTEXT~ to gather Coke for $1200000 per 2000 pounds",
        Account = {
            type = "item",
            payment = "cash" -- Set the Account payment type ("cash", "bank", or "black_money") 
        },
        Items = {
            { label = "Coke", item = "cokebaggy", amount = 2000, price = 1200000 }
        },
        ped = {
            coords = vector4(-98.6536, -2232.4239, 7.8117, 319.3485),
            ped = 'cs_lestercrest'
        },
        Authorized = {
            License = "license:example_license_2" -- Set a specific license ID or leave nil to disable license restriction
        }
    },
    MethPlug = {
        TextNotification = "Press ~INPUT_CONTEXT~ to gather Coke for $1000000 per 2000 pounds",
        Account = {
            type = "item",
            payment = "cash" -- Set the Account payment type ("cash", "bank", or "black_money") 
        },
        Items = {
            { label = "Coke", item = "cokebaggy", amount = 2000, price = 1000000 }
        },
        ped = {
            coords = vector4(473.99, -538.53, 28.5, 129.79),
            ped = 'cs_lestercrest'
        },
        Authorized = {
            License = "license:example_license_2" -- Set a specific license ID or leave nil to disable license restriction
        }
    },
    FentanylPlug = {
        TextNotification = "Press ~INPUT_CONTEXT~ to gather Fentanyl for $5000000 per 20000 pounds",
        Account = {
            type = "item",
            payment = "cash" -- Set the Account payment type ("cash", "bank", or "black_money") 
        },
        Items = {
            { label = "Fentanyl", item = "fentanyl_pure", amount = 20000, price = 5000000 }
        },
        ped = {
            coords = vector4(-102.6536, -2240.4239, 7.8117, 319.3485),
            ped = 's_m_y_dealer_02'
        },
        Authorized = {
            License = "license:example_license_3" -- Set a specific license ID or leave nil to disable license restriction
        }
    }
}

-- Guide for adding more plugs:
-- 1. Copy the structure of one of the existing plug entries (e.g., CokePlug).
-- 2. Change the name of the plug (e.g., MethPlug, HeroinPlug).
-- 3. Update the TextNotification to match the drug being gathered.
-- 4. Set the Account payment type ("cash", "bank", or "black_money").
-- 5. Define the Items (item name, amount, and price).
-- 6. Update the ped information (coordinates and model).
-- 7. Set the Authorized License (leave nil to disable license restriction).
-- 8. Save and restart your server to apply changes.
