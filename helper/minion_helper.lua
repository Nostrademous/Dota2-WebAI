-------------------------------------------------------------------------------
--- AUTHORS: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

--- IMPORTS
-------------------------------------------------

-------------------------------------------------

local MinionHelper = {}

-------------------------------------------------
--- NOTE: List of API functions useful for minions
--- float GetRemainingLifespan()
--- { handles } GetModifierAuxiliaryUnits( nModifier )
-------------------------------------------------

function MinionHelper:MinionAboutToDie( hMinion )
    local percHealth = hMinion:GetHealth() / hMinion:GetMaxHealth()
    local fTimeRemaining = hMinion:GetRemainingLifespan()
    
    if percHealth > 50.0 then return false end
    
    if fTimeRemaining < 1.0 then return false end
    
    if percHealth < fTimeRemaining*5.0 then return true end
    
    return false
end

return MinionHelper