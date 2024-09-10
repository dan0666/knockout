local weaponChances = Config.WeaponChances or {}
local baseChance = Config.BaseChance or 100

RegisterServerEvent('knockout:checkDamage')
AddEventHandler('knockout:checkDamage', function(targetPlayer, damage, weaponHash)
    if damage > 0 then
        local weaponChance = weaponChances[weaponHash] or baseChance
        
        local chance = math.random(1, 100)
        
        if chance <= weaponChance then
            TriggerClientEvent('knockout:start', targetPlayer)
        end
    end
end)

RegisterServerEvent('knockout:syncStandUp')
AddEventHandler('knockout:syncStandUp', function(playerId)
    TriggerClientEvent('knockout:doStandUp', -1, playerId)
end)
