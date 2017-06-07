local MoveToUnit = {}

MoveToUnit.Name = "Move to Unit"

-------------------------------------------------
function MoveToUnit:Call( hUnit, hUnit2, iType )
    if hUnit2 and not hUnit2:IsNull() and hUnit2:IsAlive() then
        if hUnit:IsHero() then
            hUnit.mybot.moving_location = hUnit2:GetLocation()
        end
        
        DebugDrawCircle(hUnit2:GetLocation(), 25, 255, 255 ,255)
        DebugDrawLine(hUnit:GetLocation(), hUnit2:GetLocation(), 255, 255, 255)
        
        if iType == nil or iType == ABILITY_STANDARD then
            hUnit:Action_MoveToUnit( hUnit2 )
        elseif iType == ABILITY_PUSH then
            hUnit:ActionPush_MoveToUnit( hUnit2 )
        elseif iType == ABILITY_QUEUE then
            hUnit:ActionQueue_MoveToUnit( hUnit2 )
        end
    end
end
-------------------------------------------------

return MoveToUnit