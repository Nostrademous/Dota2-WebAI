
local actionMove = require( GetScriptDirectory().."/actions/basic_actions/action_move_to_location" )
local actionUseAbility = require( GetScriptDirectory().."/actions/basic_actions/action_use_ability_on_location" )

local ApproachAndExecuteActionOnLocation = {}
ApproachAndExecuteActionOnLocation.Name = "Approach And Execute Action On Location"

-------------------------------------------------

function ApproachAndExecuteActionOnLocation:Call( hUnit, vLoc, fPrecision, iType, hAbility, execLoc, fCastPoint )
    local unitsToLocation = fPrecision
    if unitsToLocation == nil then
        unitsToLocation = 16.0
    end
    
    local distToLoc = GetUnitToLocationDistance(hUnit, vLoc)
    if distToLoc > unitsToLocation then
        actionMove:Call(hUnit, vLoc, iType)
        return
    else
        actionUseAbility(hUnit, hAbility, execLoc, fCastPoint, iType)
        return
    end
end

-------------------------------------------------

return ApproachAndExecuteActionOnLocation