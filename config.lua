Config = {}

-- Define knockout chances for each melee weapon
Config.WeaponChances = {
    [GetHashKey("WEAPON_GOLFCLUB")] = 50, -- Example chance for WEAPON_GOLFCLUB
    [GetHashKey("WEAPON_HAMMER")] = 70, -- Example chance for WEAPON_HAMMER
    [GetHashKey("WEAPON_HATCHET")] = 80, -- Example chance for WEAPON_HATCHET
    [GetHashKey("WEAPON_WRENCH")] = 100, -- Example chance for WEAPON_WRENCH
    [GetHashKey("WEAPON_POOLCUE")] = 40, -- Example chance for WEAPON_POOLCUE
    [GetHashKey("WEAPON_STONE_HATCHET")] = 90 -- Example chance for WEAPON_STONE_HATCHET
}

-- General knockout chance if no specific weapon. (HANDS)
Config.BaseChance = 10

-- Knockout duration in milliseconds
Config.KnockOutTime = 10000 -- 10 seconds

-- Enable or disable sound effect
Config.TurnOnSound = true
