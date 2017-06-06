local VectorHelper = require(GetScriptDirectory().."/helper/vector_helper")

local RotateAway = {}

RotateAway.name = "Rotate Away"

-------------------------------------------------
function RotateAway:Call( hUnit, fPoint, iType )
    local away_vector = VectorHelper:Normalize(hUnit:GetLocation() - fPoint)
    
    if iType == nil or iType == ABILITY_STANDARD then
        hUnit:Action_MoveToLocation(hUnit:GetLocation() + away_vector)
    elseif iType == ABILITY_PUSH then
        hUnit:ActionPush_MoveToLocation(hUnit:GetLocation() + away_vector)
    elseif iType == ABILITY_QUEUE then
        hUnit:ActionQueue_MoveToLocation(hUnit:GetLocation() + away_vector)
    end
end
-------------------------------------------------

return RotateAway