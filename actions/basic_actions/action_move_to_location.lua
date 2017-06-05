local MoveToLocation = {}

MoveToLocation.Name = "Move to Location"

-------------------------------------------------

function MoveToLocation:Call( hUnit, point )
    if hUnit:IsHero() then
        hUnit.mybot.moving_location = point
    end
    
    DebugDrawCircle(point, 25, 255, 255 ,255)
    DebugDrawLine(hUnit:GetLocation(), point, 255, 255, 255)
    hUnit:Action_MoveToLocation(point)
end

-------------------------------------------------

return MoveToLocation