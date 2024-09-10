RegisterServerEvent('knockout:checkDamage')
AddEventHandler('knockout:checkDamage', function(targetPlayer, damage, weaponHash)
    if damage > 0 then
        local knockoutChance = Config.BaseChance
        if Config.WeaponChances[weaponHash] then
            knockoutChance = Config.WeaponChances[weaponHash]
        end

        knockoutChance = math.max(0, math.min(100, knockoutChance))

        local chance = math.random(1, 100)

        if chance <= knockoutChance then
            TriggerClientEvent('knockout:start', targetPlayer)
        end
    end
end)

-- Synchronize player standing up across all clients
RegisterServerEvent('knockout:syncStandUp')
AddEventHandler('knockout:syncStandUp', function(playerId)
-- Broadcast to all players so that everyone sees the player getting up normally
    TriggerClientEvent('knockout:doStandUp', -1, playerId)
end)
