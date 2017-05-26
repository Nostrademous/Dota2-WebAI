local VectorHelper = require(GetScriptDirectory().."/helper/vector_helper")

local RotateAway = {}

RotateAway.name = "Rotate Away"

-------------------------------------------------
function RotateAway:Call(point)
    local bot = GetBot()
    local away_vector = VectorHelper:Normalize(bot:GetLocation() - point)
    bot:Action_MoveToLocation(bot:GetLocation() + away_vector)
end
-------------------------------------------------

return RotateAway