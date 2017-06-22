
local actionMove = require( GetScriptDirectory().."/actions/basic_actions/action_move_to_location" )

-------------------------------------------------

local ActionBlockUnit = {}
ActionBlockUnit.Name = "Action Block Unit"
ActionBlockUnit.Sensitivity = 0.25

-------------------------------------------------

function ActionBlockUnit:Call( hUnit, hBlockUnit, iType )
    if not ValidTarget(hBlockUnit) then return end

    local futureLoc = hBlockUnit:GetExtrapolateLocation(self.Sensitivity)
    if GetUnitToLocationDistance( hUnit, futureLoc ) < 15.0 then
        hUnit:Action_ClearActions(true)
        return
    else
        actionMove:Call(hUnit, futureLoc, iType)
        return
    end
end

-------------------------------------------------

return ActionBlockUnit