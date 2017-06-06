local MoveToLocation = {}

MoveToLocation.Name = "Move to Location"

-------------------------------------------------

function MoveToLocation:Call( hUnit, fPoint, iType )
    if hUnit:IsHero() then
        hUnit.mybot.moving_location = fPoint
    end
    
    DebugDrawCircle(fPoint, 25, 255, 255 ,255)
    DebugDrawLine(hUnit:GetLocation(), fPoint, 255, 255, 255)
    
    if iType == nil or iType == ABILITY_STANDARD then
        hUnit:Action_MoveToLocation(fPoint)
    elseif iType == ABILITY_PUSH then
        hUnit:ActionPush_MoveToLocation(fPoint)
    elseif iType == ABILITY_QUEUE then
        hUnit:ActionQueue_MoveToLocation(fPoint)
    end
end

-------------------------------------------------

return MoveToLocation