local UseAbility = {}

UseAbility.Name = "Use Ability"

-------------------------------------------------
function UseAbility:Call( hUnit, hAbility, fCastPoint, iType )    
    if hUnit:IsHero() then
        hUnit.mybot.ability_completed = GameTime() + fCastPoint
    end
    
    if iType == nil or iType == ABILITY_STANDARD then
        hUnit:Action_UseAbility(hAbility)
    elseif iType == ABILITY_PUSH then
        hUnit:ActionPush_UseAbility(hAbility)
    elseif iType == ABILITY_QUEUE then
        hUnit:ActionQueue_UseAbility(hAbility)
    end
end
-------------------------------------------------

return UseAbility