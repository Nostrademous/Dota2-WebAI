-------------------------------------------------------------------------------
--- AUTHORS: iSarCasm, Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

local UnitHelper = {}

-- this can be used for unit reaching another unit or projectile reaching a unit
function UnitHelper:TimeToReachTarget( hUnit, hTarget, fSpeed )
    if not hUnit:IsNull() then
        local speed = fSpeed
        if not speed then
            speed = hUnit:GetCurrentMovementSpeed()
        else
            return VERY_HIGH_INT
        end

        if not hTarget:IsNull() then
            return GetUnitToUnitDistance( hUnit, hTarget ) / speed
        end
    end
    
    return VERY_HIGH_INT
end

return UnitHelper