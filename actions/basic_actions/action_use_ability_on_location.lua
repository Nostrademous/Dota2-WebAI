local UseAbilityOnLocation = {}

UseAbilityOnLocation.Name = "Use Ability On Location"

-------------------------------------------------
function UseAbilityOnLocation:Call( hUnit, hAbility, vLoc, fCastPoint, iType )
    if hUnit:IsHero() then
        hUnit.mybot.ability_location = vLoc
        hUnit.mybot.ability_completed = GameTime() + fCastPoint
    end

    if iType == nil or iType == ABILITY_STANDARD then
        hUnit:Action_UseAbilityOnLocation(hAbility, vLoc)
    elseif iType == ABILITY_PUSH then
        hUnit:ActionPush_UseAbilityOnLocation(hAbility, vLoc)
    elseif iType == ABILITY_QUEUE then
        hUnit:ActionQueue_UseAbilityOnLocation(hAbility, vLoc)
    end
end
-------------------------------------------------

return UseAbilityOnLocation