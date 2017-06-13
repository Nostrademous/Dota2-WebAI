-------------------------------------------------------------------------------
--- AUTHORS: iSarCasm, Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

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

function UnitHelper:IsRanged( hUnit )
    return ( hUnit:GetAttackRange() == 300 )
end

function UnitHelper:IsTargetMagicImmune( hUnit )
    return hUnit:IsInvulnerable() or hUnit:IsMagicImmune()
end

function UnitHelper:IsCrowdControlled( hUnit )
    return hUnit:IsRooted() or hUnit:IsHexed() or hUnit:IsStunned()
end

function UnitHelper:IsUnableToCast( hUnit )
    return UnitHelper:IsCrowdControlled(hUnit) or hUnit:IsNightmared() or hUnit:IsSilenced()
end

function UnitHelper:IsUnitCrowdControlled( hUnit )
    return UnitHelper:IsCrowdControlled(hUnit) or hUnit:IsNightmared() or 
    hUnit:IsDisarmed() or hUnit:IsBlind() or hUnit:IsSilenced() or hUnit:IsMuted()
end

function UnitHelper:UnitHasBreakableBuff( hUnit )
    if not ValidTarget(hUnit) then return false end

    if hUnit:HasModifier("modifier_clarity_potion") or
        hUnit:HasModifier("modifier_flask_healing") or
        hUnit:HasModifier("modifier_bottle_regeneration") then
        return true
    end
    return false
end

return UnitHelper
