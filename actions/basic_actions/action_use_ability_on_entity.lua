local UseAbilityOnEntity = {}

UseAbilityOnEntity.Name = "Use Ability On Entity"

-------------------------------------------------
function UseAbilityOnEntity:Call( hUnit, hAbility, hTarget, fCastPoint, iType )    
    if hUnit:IsHero() and not hTarget:IsNull() then
        hUnit.mybot.ability_location = hTarget:GetLocation()
        hUnit.mybot.ability_completed = GameTime() + fCastPoint
    end
    
    if not hTarget:IsNull() then
        if iType == nil or iType == ABILITY_STANDARD then
            hUnit:Action_UseAbilityOnEntity(hAbility, hTarget)
        elseif iType == ABILITY_PUSH then
            hUnit:ActionPush_UseAbilityOnEntity(hAbility, hTarget)
        elseif iType == ABILITY_QUEUE then
            hUnit:ActionQueue_UseAbilityOnEntity(hAbility, hTarget)
        end
    end
end
-------------------------------------------------

return UseAbilityOnEntity