BOUNTY_RUNES = {
    RUNE_BOUNTY_1,
    RUNE_BOUNTY_2,
    RUNE_BOUNTY_3,
    RUNE_BOUNTY_4
}

-- Better Bounty Naming
RUNE_RADIANT_SAFE   = RUNE_BOUNTY_1
RUNE_RADIANT_OFF    = RUNE_BOUNTY_2
RUNE_DIRE_SAFE      = RUNE_BOUNTY_3
RUNE_DIRE_OFF       = RUNE_BOUNTY_4

POWER_RUNES = {
    RUNE_POWERUP_1,
    RUNE_POWERUP_2
}

function GetRuneLocation( nRuneLoc )
    return GetRuneSpawnLocation(nRuneLoc)
end
