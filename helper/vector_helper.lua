-------------------------------------------------------------------------------
--- AUTHORS: iSarCasm, Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

local VectorHelper = {}

---------------------------------------
function VectorHelper:Normalize(vec)
    local x = vec[1]
    local y = vec[2]
    local vec_length = math.pow(x*x+y*y, 0.5)
    return Vector(x/vec_length, y/vec_length)
end

function VectorHelper:Length(vec)
  return (math.sqrt(math.pow(vec.x, 2) + math.pow(vec.y, 2)))
end

function VectorHelper:GetDistance(s, t)
    return math.sqrt(math.pow(s[1]-t[1], 2) + math.pow(s[2]-t[2], 2))
end

function VectorHelper:VectorTowards(start, towards, distance)
    local facing = towards - start
    local direction = facing / self:GetDistance(facing, Vector(0,0)) --normalized
    return start + (direction * distance)
end

function VectorHelper:VectorAway(start, towards, distance)
    local facing = start - towards
    local direction = facing / self:GetDistance(facing, Vector(0,0)) --normalized
    return start + (direction * distance)
end

---------------------------------------
return VectorHelper
