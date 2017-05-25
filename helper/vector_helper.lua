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
---------------------------------------
return VectorHelper
