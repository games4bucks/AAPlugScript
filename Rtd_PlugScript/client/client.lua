-- client.lua
local isNearPlug = false
local currentPlug = nil
local pedEntities = {}
local textDisplayed = {}
local isOnCooldown = false

CreateThread(function()
    for plugName, plugData in pairs(Config.Plugs) do
        local model = GetHashKey(plugData.ped.ped)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(100)
        end

        -- Spawn the ped
        local ped = CreatePed(4, model, plugData.ped.coords.x, plugData.ped.coords.y, plugData.ped.coords.z - 1.0, plugData.ped.coords.w, true, true)
        
        -- Make the ped persistent
        SetEntityAsMissionEntity(ped, true, false)
        SetPedKeepTask(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(ped), false)

        -- Assign animations
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_DRUG_DEALER_HARD", 0, true)

        -- Store the ped reference
        pedEntities[plugName] = ped
        textDisplayed[plugName] = false
    end
end)


CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        isNearPlug = false

        for plugName, plugData in pairs(Config.Plugs) do
            local pedCoords = plugData.ped.coords
            local distance = #(playerCoords - vector3(pedCoords.x, pedCoords.y, pedCoords.z))

            if distance < 3.0 then
                if not textDisplayed[plugName] then
                    BeginTextCommandDisplayHelp("STRING")
                    AddTextComponentSubstringPlayerName(plugData.TextNotification)
                    EndTextCommandDisplayHelp(0, false, true, -1)
                    textDisplayed[plugName] = true
                end

                isNearPlug = true
                currentPlug = plugName

                if IsControlJustPressed(0, 38) and not isOnCooldown then -- Default key: E
                    TriggerServerEvent('drug_plug:checkCooldown') -- Ask server for cooldown status
                end
                break
            end
        end

        if not isNearPlug then
            if currentPlug ~= nil then
                ClearAllHelpMessages()
                textDisplayed[currentPlug] = false
                currentPlug = nil
            end
        end

        Wait(0) -- Continuous loop for immediate key detection
    end
end)

RegisterNetEvent('drug_plug:cooldownResponse', function(remainingTime)
    if remainingTime > 0 then
        isOnCooldown = true
        BeginTextCommandDisplayHelp("STRING")
        AddTextComponentSubstringPlayerName("You must wait " .. math.ceil(remainingTime / 60) .. " minutes before buying again.")
        EndTextCommandDisplayHelp(0, false, true, -1)
    else
        isOnCooldown = false
        TriggerServerEvent('drug_plug:buyItem', currentPlug)
    end
end)

RegisterNetEvent('drug_plug:doTransactionAnimation', function()
    if not isOnCooldown then
        local playerPed = PlayerPedId()
        local ped = pedEntities[currentPlug]
        local animDict = "mp_common"
        local animNamePlayer = "givetake1_a"
        local animNamePed = "givetake1_b"
        local moneyProp = "prop_cash_pile_01" -- Money prop for player
        local drugProp = "hei_prop_hei_drug_pack_01a" -- Drug pack prop for ped

        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(10)
        end

        RequestModel(moneyProp)
        while not HasModelLoaded(moneyProp) do
            Wait(10)
        end

        RequestModel(drugProp)
        while not HasModelLoaded(drugProp) do
            Wait(10)
        end

        -- Create and attach the money prop to the player
        local money = CreateObject(GetHashKey(moneyProp), GetEntityCoords(playerPed), true, true, false)
        AttachEntityToEntity(money, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        
        -- Create and attach the drug pack prop to the ped
        local drugs = CreateObject(GetHashKey(drugProp), GetEntityCoords(ped), true, true, false)
        AttachEntityToEntity(drugs, ped, GetPedBoneIndex(ped, 57005), 0.15, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        
        TaskPlayAnim(playerPed, animDict, animNamePlayer, 8.0, -8.0, 2000, 49, 0, false, false, false)
        TaskPlayAnim(ped, animDict, animNamePed, 8.0, -8.0, 2000, 49, 0, false, false, false)
        Wait(2000) -- Animation duration

        -- Swap props (simulate handover)
        DetachEntity(money, true, true)
        DeleteObject(money)
        Wait(500)
        DetachEntity(drugs, true, true)
        AttachEntityToEntity(drugs, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        Wait(1500)
        DeleteObject(drugs)
        
        ClearPedTasks(playerPed)
        ClearPedTasks(ped)
    end
end)
