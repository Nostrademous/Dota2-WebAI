local MoveToUnit = {}

MoveToUnit.Name = "Move to Unit"

-------------------------------------------------
function MoveToUnit:Call( hUnit )
    if hUnit and not hUnit:IsNull() and hUnit:IsAlive() then
        local bot = GetBot()
        bot.mybot.moving_location = hUnit:GetLocation()
        DebugDrawCircle(bot.mybot.moving_location, 25, 255, 255 ,255)
        DebugDrawLine(bot:GetLocation(), bot.mybot.moving_location, 255, 255, 255)
        bot:Action_MoveToUnit( hUnit )
    end
end
-------------------------------------------------

return MoveToUnit