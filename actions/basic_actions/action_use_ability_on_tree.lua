local UseAbilityOnTree = {}

UseAbilityOnTree.Name = "Use Ability On Tree"

-------------------------------------------------
function UseAbilityOnTree:Call( hUnit, hAbility, iTree, fCastPoint, iType )    
    if hUnit:IsHero() then
        hUnit.mybot.ability_location = GetTreeLocation(iTree)
        hUnit.mybot.ability_completed = GameTime() + fCastPoint
    end

    if iType == nil or iType == ABILITY_STANDARD then
        hUnit:Action_UseAbilityOnTree(hAbility, iTree)
    elseif iType == ABILITY_PUSH then
        hUnit:ActionPush_UseAbilityOnTree(hAbility, iTree)
    elseif iType == ABILITY_QUEUE then
        hUnit:ActionQueue_UseAbilityOnTree(hAbility, iTree)
    end
end
-------------------------------------------------

return UseAbilityOnTree