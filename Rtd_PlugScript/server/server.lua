-- server.lua

local QBCore = nil
local ESX = nil
local playerCooldowns = {} -- Initialize the player cooldowns table

if GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif GetResourceState('es_extended') == 'started' then
    ESX = exports['es_extended']:getSharedObject()
end

-- Ensure playerCooldowns entry is created for each player if not present
AddEventHandler('playerDropped', function()
    local src = source
    if playerCooldowns[src] then
        playerCooldowns[src] = nil
    end
end)

AddEventHandler('playerJoining', function()
    local src = source
    if not playerCooldowns[src] then
        playerCooldowns[src] = os.time() - (3 * 3600) -- Ensure no cooldown when first joining
    end
end)

local function Notify(src, message, type)
    if Config.Notification == "qb" then
        TriggerClientEvent('QBCore:Notify', src, message, type)
    elseif Config.Notification == "ox" then
        TriggerClientEvent('ox_lib:notify', src, {description = message, type = type})
    elseif Config.Notification == "okok" then
        TriggerClientEvent('okokNotify:Alert', src, "Drug Plug", message, 5000, type)
    elseif Config.Notification == "mNotify" then
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = type, text = message, length = 5000 })
    elseif Config.Notification == "ps-ui" then
        TriggerClientEvent('ps-ui:notify', src, message, type)
    else
        print("[Drug Plug] ERROR: No valid notification system set! Check Config.Notification.")
    end
end

local function AddItemToInventory(xPlayer, item, amount, src)
    if Config.Inventory == "qb-inventory" then
        xPlayer.Functions.AddItem(item, amount)
    elseif Config.Inventory == "ox_inventory" then
        xPlayer.addInventoryItem(item, amount)
    elseif Config.Inventory == "ox_inventory" then
        exports.ox_inventory:AddItem(src, item, amount)
    elseif Config.Inventory == "codem-inventory" then
        exports['codem-inventory']:AddItem(src, item, amount)
    elseif Config.Inventory == "ps-inventory" then
        exports['ps-inventory']:AddItem(src, item, amount)
    elseif Config.Inventory == "ak47_qb_inventory" then
        exports['ak47_qb_inventory']:AddItem(src, item, amount)
    else
        print("[Drug Plug] ERROR: Unsupported inventory type! Check Config.Inventory.")
    end
end

RegisterNetEvent('drug_plug:buyItem', function(plug)
    local src = source
    local xPlayer = nil

    if QBCore then
        xPlayer = QBCore.Functions.GetPlayer(src)
    elseif ESX then
        xPlayer = ESX.GetPlayerFromId(src)
    end

    if not xPlayer then
        return
    end

    local plugData = Config.Plugs[plug]
    if not plugData then return end

    if plugData.Authorized and plugData.Authorized.License then
        local hasLicense = false

        -- Fetching the FiveM license
        local identifiers = GetPlayerIdentifiers(src)
        for _, identifier in pairs(identifiers) do
            if identifier:sub(1, 8) == "license:" and identifier == plugData.Authorized.License then
                hasLicense = true
                break
            end
        end

        if not hasLicense then
            Notify(src, 'You are not authorized to buy from this plug!', 'error')
            return
        end
    end

    for _, item in ipairs(plugData.Items) do
        local price = item.price
        local paymentType = plugData.Account.payment
        
        if QBCore and xPlayer.Functions.RemoveMoney(paymentType, price) then
            AddItemToInventory(xPlayer, item.item, item.amount, src)
            playerCooldowns[src] = os.time() + (3 * 3600) -- Set 3-hour cooldown
            TriggerClientEvent('drug_plug:doTransactionAnimation', src)
            Notify(src, 'You successfully purchased from the plug!', 'success')
        elseif ESX and xPlayer.getAccount(paymentType).money >= price then
            xPlayer.removeAccountMoney(paymentType, price)
            AddItemToInventory(xPlayer, item.item, item.amount, src)
            playerCooldowns[src] = os.time() + (3 * 3600) -- Set 3-hour cooldown
            TriggerClientEvent('drug_plug:doTransactionAnimation', src)
            Notify(src, 'You successfully purchased from the plug!', 'success')
        else
            Notify(src, 'You do not have enough money!', 'error')
            return
        end
    end
end)

RegisterNetEvent('drug_plug:checkCooldown', function()
    local src = source
    local currentTime = os.time()
    if not playerCooldowns[src] then
        playerCooldowns[src] = currentTime
    end
    local remainingTime = math.max(0, playerCooldowns[src] - currentTime)
    TriggerClientEvent('drug_plug:cooldownResponse', src, remainingTime)
end)
