
local goAndDo = require( GetScriptDirectory().."/actions/complex_actions/approach_and_execute_action_on_location" )
local useAbilityOnLoc = require( GetScriptDirectory().."/actions/basic_actions/action_use_ability_on_location" )
local invHelper = require( GetScriptDirectory().."/helper/inventory_helper" )

local PlaceWard = {}
PlaceWard.Name = "Place Ward"

-------------------------------------------------

function PlaceWard:Call( hUnit, vWardLoc, wardType, iType )
    local wardCastRange = 500.0
    self.Name = self.Name .. " " .. wardType
    
    local hWardAbility = invHelper:GetItemByName( hUnit, wardType, true )
    if hWardAbility then
        print("Ward Cast Point: " .. hWardAbility:GetCastPoint())
        print("Ward Cast Range: " .. hWardAbility:GetCastRange())
        local fCastPoint = hWardAbility:GetCastPoint()
        goAndDo:Call( hUnit, vWardLoc, wardCastRange, iType, hWardAbility, vWardLoc, fCastPoint )
    else
        dbg.pause(self.Name, "Not Found")
    end
end

-------------------------------------------------

return PlaceWard