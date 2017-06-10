
local Stacking = require( GetScriptDirectory().."/actions/complex_actions/action_stacking" )
local VectorHelper = require(GetScriptDirectory().."/helper/vector_helper")
local Pulling = {}

Pulling.Name = "Pulling"
Pulling.state = {} -- doesnt require init, because same behaviour for state[bot_name] being `nil` or `false`

-------------------------------------------------

function Pulling:Call(lane, camp_type, camp_location, camp_wait_at)
    local bot = GetBot()
    local bot_name = bot:GetUnitName()

    if Pulling.state[bot_name] then
        print("Add the last-hitting/farming func!")
        -- Need to reset/clear Pulling.state for this hero after finished farming
    else
        local amount_along_lane = GetAmountAlongLane(lane, camp_location)
        local camp_pull_to = GetLocationAlongLane(lane, amount_along_lane.amount)
        -- move a bit further so we de-aggro creeps
        camp_pull_to = camp_pull_to + VectorHelper:Normalize(camp_pull_to - camp_location) * 200
        local camp_timing = (camp_type == "large") and 23 or 13
        if GetSeconds() > 30 then
            camp_timing = camp_timing + 30
        end
        Pulling.state[bot_name] = Stacking:Call(bot, camp_location, camp_timing, camp_wait_at, camp_pull_to)
    end

end

return Pulling