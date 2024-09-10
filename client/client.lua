local isKnockedOut = false
local scaleformMovie = nil

local function displayKnockoutMessage()
    if Config.TurnMovieText then
        if scaleformMovie == nil then
            scaleformMovie = RequestScaleformMovie("mp_big_message_freemode")
            while not HasScaleformMovieLoaded(scaleformMovie) do
                Citizen.Wait(0)
            end
        end

        BeginScaleformMovieMethod(scaleformMovie, "SHOW_SHARD_WASTED_MP_MESSAGE")
        ScaleformMovieMethodAddParamPlayerNameString(Config.KnockedText)
        EndScaleformMovieMethod()
    end
end

local function cleanupScaleformMovie()
    if scaleformMovie then
        SetScaleformMovieAsNoLongerNeeded(scaleformMovie)
        scaleformMovie = nil
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsPedInMeleeCombat(PlayerPedId()) then
            local target = GetMeleeTargetForPed(PlayerPedId())
            if DoesEntityExist(target) and IsEntityAPed(target) and IsPedAPlayer(target) then
                local targetHealthBeforeHit = GetEntityHealth(target)

                Citizen.Wait(100)
                
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
    
    displayKnockoutMessage()

    local knockoutTime = Config.KnockOutTime
    
    Citizen.CreateThread(function()
        local endTime = GetGameTimer() + knockoutTime
        
        while GetGameTimer() < endTime do
            ShakeGameplayCam(Config.ShakeEffect, Config.ShakeEffectShake)
            Citizen.Wait(500)
        end

        cleanupScaleformMovie()
        
        TriggerServerEvent('knockout:syncStandUp', GetPlayerServerId(PlayerId()))
        
        ClearPedTasks(playerPed)
        isKnockedOut = false
    end)
end)

RegisterNetEvent('knockout:doStandUp')
AddEventHandler('knockout:doStandUp', function(playerId)
    local playerPed = PlayerPedId()
    local playerServerId = GetPlayerServerId(PlayerId())
    
    if playerId == playerServerId then
        ClearPedTasks(playerPed)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if scaleformMovie and Config.TurnMovieText then
            DrawScaleformMovieFullscreen(scaleformMovie, 255, 255, 255, 255)
        end
    end
end)
