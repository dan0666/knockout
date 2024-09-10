local isKnockedOut = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsPedInMeleeCombat(PlayerPedId()) then
            local target = GetMeleeTargetForPed(PlayerPedId())
            if DoesEntityExist(target) and IsEntityAPed(target) and IsPedAPlayer(target) then
                local targetHealthBeforeHit = GetEntityHealth(target)

                Citizen.Wait(0)
                
                local targetHealthAfterHit = GetEntityHealth(target)
                local damageTaken = targetHealthBeforeHit - targetHealthAfterHit               
                local weaponHash = GetSelectedPedWeapon(PlayerPedId())

                if damageTaken > 0 and not isKnockedOut then
                    TriggerServerEvent('knockout:checkDamage', GetPlayerServerId(NetworkGetPlayerIndexFromPed(target)), damageTaken, weaponHash)
                end
            end
        end
    end
end)

RegisterNetEvent('knockout:start')
AddEventHandler('knockout:start', function()
    if isKnockedOut then return end
    isKnockedOut = true

    local playerPed = PlayerPedId()

    SetPedToRagdoll(playerPed, 10000, 10000, 0, false, false, false)
    
    if Config.TurnOnSound then
        PlaySoundFrontend(-1, "Bed", "WastedSounds", 0)
    end
    
    local knockoutTime = Config.KnockOutTime
    
    Citizen.CreateThread(function()
        local endTime = GetGameTimer() + knockoutTime       
        while GetGameTimer() < endTime do
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 1.0)
            Citizen.Wait(500)
        end
        TriggerServerEvent('knockout:syncStandUp', GetPlayerServerId(PlayerId()))
        ClearPedTasks(playerPed)
        isKnockedOut = false
    end)
end)
