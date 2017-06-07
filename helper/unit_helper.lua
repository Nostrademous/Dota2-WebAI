local UnitHelper = {}

-- this can be used for unit reaching another unit or projectile reaching a unit
function UnitHelper:TimeToReachTarget( hUnit, hTarget, fSpeed )
    if not hUnit:IsNull() then
        local speed = fSpeed or hUnit:GetCurrentMovementSpeed()
        if not hTarget:IsNull() then
            return GetUnitToUnitDistance( hUnit, hTarget ) / speed
        end
    end
    return VERY_HIGH_INT
end

function UnitHelper:isRanged( hUnit )
    return ( hUnit:GetAttackRange() == 300 )
end

return UnitHelper
