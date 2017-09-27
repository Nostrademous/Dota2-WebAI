-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous, iSarCasm
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

local TowerDanger = {}
TowerDanger.name = "tower"
------------------------------------------

local VectorHelper = require(GetScriptDirectory().."/helper/vector_helper")
local Game         = require(GetScriptDirectory().."/game")

-----------------------------------------

local DANGER_TOWER      = 15
local DANGER_TOWER_FAR  = 100

------------------------------------------

function TowerDanger:OfLocation( vLocation, team )
    local all_towers = Game:GetTowersForTeam(team)
    if (#all_towers == 0) then
        return 0
    end
    local total_danger = 0
    for i = 1, #all_towers do
        local tower = all_towers[i]
        total_danger = total_danger + self:Power(GetUnitToLocationDistance(tower, vLocation))
    end
    return total_danger
end 

function TowerDanger:Power(distance)
    if (distance < 800) then -- below attack range (actual tower range is 700 + ~100 for bounding radius)
        return DANGER_TOWER
    elseif (distance < 5000) then -- 14000 is random range from the tower which is `kinda safe`
        return DANGER_TOWER_FAR / (distance*distance)
    else
        return 0
    end
end

function TowerDanger:PowerDelta(team, unit, distance)
    self.TowerVector = Vector(0, 0)

    local total_delta = 0
    local all_towers = Game:GetTowersForTeam(team)

    if (#all_towers == 0) then
        return 0
    end

    for i = 1, #all_towers do
        local tower = all_towers[i]
        local current_distance = GetUnitToLocationDistance(unit, tower:GetLocation())
        local delta_distance = ((team == GetTeam()) and -distance or distance)
        local delta = math.abs(self:Power(Max(1, current_distance + delta_distance)) - self:Power(current_distance))
        total_delta = total_delta + delta
        self.TowerVector = self.TowerVector + tower:GetLocation() * delta
    end
    self.TowerVector = self.TowerVector / total_delta
    return total_delta
end

function TowerDanger:Location(team)
    return self.TowerVector
end

------------------------------------------

return TowerDanger