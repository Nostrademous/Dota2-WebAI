local UnitHelper = {}

-- this can be used for unit reaching another unit or projectile reaching a unit
function UnitHelper:TimeToReachTarget( hUnit, hTarget, fSpeed )
    local speed = fSpeed
    if not speed then
        if not hUnit:IsNull() then
            speed = hUnit:GetCurrentMovementSpeed()
        else
            return VERY_HIGH_INT
        end
    end
    
    if not hUnit:IsNull() and not hTarget:IsNull() then
        return GetUnitToUnitDistance( hUnit, hTarget ) / speed
    end
    
    return VERY_HIGH_INT
end

function UnitHelper:isRanged( hUnit )
    return ( hUnit:GetAttackRange() == 300 )
end

return UnitHelper
