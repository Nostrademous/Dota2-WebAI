-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous, iSarCasm
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

local FountainDanger = {}
FountainDanger.name = "fountain"

------------------------------------------

VectorHelper = require(GetScriptDirectory().."/helper/vector_helper")

------------------------------------------

local DANGER_FOUNTAIN       = 500
local DANGER_FOUNTAIN_FAR   = 5000
local DANGER_FOUNTAIN_BASE  = 500

------------------------------------------

function FountainDanger:Power(distance)
    if (distance < 1000) then
        return DANGER_FOUNTAIN
    elseif (distance < 3000) then
        return DANGER_FOUNTAIN_FAR / (distance*distance)
    else
        return DANGER_FOUNTAIN_BASE / (distance*distance) -- fountain is basic safety
    end
end

function FountainDanger:OfLocation( vLocation, team )
    local length = VectorHelper:Length(vLocation - FOUNTAIN[team])
    -- print("input vector")
    -- print(vLocation)
    -- print("team "..team)
    -- print(FOUNTAIN[team])
    -- print("l "..length)
    return self:Power(length)
end

function FountainDanger:ResultVector(team, unit, distance)
    return self:PowerDelta(team, unit, distance) * self:Location(team)
end

function FountainDanger:PowerDelta(team, unit, distance)
    local current_distance = GetUnitToLocationDistance(unit, self:Location(team))
    local delta = ((team == GetTeam()) and -distance or distance)
    return math.abs(self:Power(Max(1, current_distance + delta)) - self:Power(current_distance))
end

function FountainDanger:Location(team)
    return FOUNTAIN[team]
end

------------------------------------------

return FountainDanger