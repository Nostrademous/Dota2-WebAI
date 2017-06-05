local UseAbilityOnLocation = {}

UseAbilityOnLocation.Name = "Use Ability On Location"

-------------------------------------------------
function UseAbilityOnLocation:Call( hUnit, ability, vLoc, fCastPoint)
    if hUnit:IsHero() then
        hUnit.mybot.ability_location = vLoc
        hUnit.mybot.ability_completed = GameTime() + fCastPoint
    end
    
    hUnit:Action_UseAbilityOnLocation(ability, vLoc)
end
-------------------------------------------------

return UseAbilityOnLocation