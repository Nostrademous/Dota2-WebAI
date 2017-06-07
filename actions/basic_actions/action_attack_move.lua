local AttackMove = {}

AttackMove.Name = "Attack Move"

-------------------------------------------------

function AttackMove:Call( hUnit, fPoint, iType )
    if hUnit:IsHero() then
        hUnit.mybot.moving_location = fPoint
    end
    
    DebugDrawCircle(fPoint, 25, 255, 255 ,255)
    DebugDrawLine(hUnit:GetLocation(), fPoint, 255, 255, 255)
    
    if iType == nil or iType == ABILITY_STANDARD then
        hUnit:Action_AttackMove(fPoint)
    elseif iType == ABILITY_PUSH then
        hUnit:ActionPush_AttackMove(fPoint)
    elseif iType == ABILITY_QUEUE then
        hUnit:ActionQueue_AttackMove(fPoint)
    end
end

-------------------------------------------------

return AttackMove