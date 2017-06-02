local VectorHelper = require(GetScriptDirectory().."/helper/vector_helper")

local MoveToLocation = {}

MoveToLocation.Name = "Move to Location"

-------------------------------------------------
function MoveToLocation:Call(point)
    local bot = GetBot()
    bot.mybot.moving_location = point
    DebugDrawCircle(point, 25, 255, 255 ,255)
    DebugDrawLine(bot:GetLocation(), point, 255, 255, 255)
    bot:Action_MoveToLocation(point)
end
-------------------------------------------------

return MoveToLocation