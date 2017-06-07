local VectorHelper = require(GetScriptDirectory().."/helper/vector_helper")

local RotateTowards = {}

RotateTowards.name = "Rotate Towards"

-------------------------------------------------
function RotateTowards:Call( hUnit, fPoint, iType )
    local towards_vector = VectorHelper:Normalize(fPoint - hUnit:GetLocation())
    
    if iType == nil or iType == ABILITY_STANDARD then
        hUnit:Action_MoveToLocation(hUnit:GetLocation() + towards_vector)
    elseif iType == ABILITY_PUSH then
        hUnit:ActionPush_MoveToLocation(hUnit:GetLocation() + towards_vector)
    elseif iType == ABILITY_QUEUE then
        hUnit:ActionQueue_MoveToLocation(hUnit:GetLocation() + towards_vector)
    end
end
-------------------------------------------------

return RotateTowards