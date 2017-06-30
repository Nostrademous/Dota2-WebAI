-------------------------------------------------------------------------------
--- AUTHORS: iSarCasm, Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

--- IMPORTS
-------------------------------------------------

-------------------------------------------------

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

function UnitHelper:DistanceFromNearestShop( hUnit )
    local vecShops = {
        GetShopLocation(TEAM_RADIANT, SHOP_HOME),
        GetShopLocation(TEAM_DIRE, SHOP_HOME),
        GetShopLocation(TEAM_NONE, SHOP_SECRET),
        GetShopLocation(TEAM_NONE, SHOP_SECRET_2),
        GetShopLocation(TEAM_NONE, SHOP_SIDE),
        GetShopLocation(TEAM_NONE, SHOP_SIDE_2)
    }

    local dist = VERY_HIGH_INT
    for _, vecShop in pairs(vecShops) do
        local thisDist = GetUnitToLocationDistance(hUnit, vecShop)
        if thisDist < SHOP_USE_DISTANCE then
            return thisDist
        end

        if thisDist < dist then
            dist = thisDist
        end
    end

    return dist
end

return UnitHelper
