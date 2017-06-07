local AttackUnit = {}

AttackUnit.Name = "Attack Unit"

-------------------------------------------------
function AttackUnit:Call( hUnit, hTarget, bOnce, fAttackPoint, iType )    
    if hUnit:IsHero() and not hTarget:IsNull() then
        hUnit.mybot.attack_target = hTarget
        if hTarget:IsHero() then
            hUnit.mybot.attack_target_id = hTarget:GetPlayerID()
        end
        hUnit.mybot.attack_completed = GameTime() + fAttackPoint
    end
    
    if not hTarget:IsNull() then
        if iType == nil or iType == ABILITY_STANDARD then
            hUnit:Action_AttackUnit(hTarget, bOnce)
        elseif iType == ABILITY_PUSH then
            hUnit:ActionPush_AttackUnit(hTarget, bOnce)
        elseif iType == ABILITY_QUEUE then
            hUnit:ActionQueue_AttackUnit(hTarget, bOnce)
        end
    end
end
-------------------------------------------------

return AttackUnit