
local actionMove = require( GetScriptDirectory().."/actions/basic_actions/action_move_to_location" )

local ApproachAndExecuteActionOnLocation = {}
ApproachAndExecuteActionOnLocation.Name = "Approach And Execute Action On Location"

-------------------------------------------------

function ApproachAndExecuteActionOnLocation:Call( hUnit, vLoc, fPrecision, iType, execAction, execLoc )
    local unitsToLocation = fPrecision
    if unitsToLocation == nil then
        unitsToLocation = 16.0
    end
    
    local distToLoc = GetUnitToLocationDistance(hUnit, vLoc)
    if distToLoc > unitsToLocation then
        actionMove:Call(hUnit, vLoc, iType)
        return
    else
        execAction(hUnit, execLoc, iType)
        return
    end
end

-------------------------------------------------

return ApproachAndExecuteActionOnLocation