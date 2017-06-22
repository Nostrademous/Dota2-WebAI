-------------------------------------------------------------------------------
--- AUTHORS: iSarCasm, Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--- CODE SPECIFIC
-------------------------------------------------------------------------------

globalInit = false

function InitializeGlobalVars()
    heroData = require( GetScriptDirectory().."/hero_data" )
    globalInit = true
end

--- TABLE RELATED
function InTable(tab, val)
    if not tab then return false end
    for index, value in ipairs (tab) do
        if value == val then
            return true
        end
    end

    return false
end

function PosInTable(tab, val)
    for index,value in ipairs(tab) do
        if value == val then
            return index
        end
    end

    return -1
end

function GetTableKeyNameFromID( hTable, iIndex )
	if hTable == nil or iIndex == nil then
		return "nil"
	end

	for key, value in pairs(hTable) do
		if value == iIndex then
			return tostring(key)
		end
	end
	
	return nil
end

function TableConcat(t1, t2)
    for i = 1, #t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

-------------------------------------------------------------------------------

--- MATH & TIME RELATED
-- checks if a specific bit is set in a bitmask
function CheckBitmask(bitmask, bit)
    return ((bitmask/bit) % 2) >= 1
end

function GetSeconds()
    return math.floor(DotaTime()) % 60
end

function Round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-------------------------------------------------------------------------------
--- DOTA2 SPECIFIC
-------------------------------------------------------------------------------

--- TARGET RELATED
function ValidTarget( hUnit )
    -- handle to the unit cannot be nil and null, and unit has to be alive
    return hUnit ~= nil and not hUnit:IsNull() and hUnit:IsAlive()
end

function GetUnitName( hUnit )
    local sName = hUnit:GetUnitName()
    return string.sub(sName, 15, string.len(sName))
end

--- SHOP RELATED
function GetShop()
    if (GetTeam() == TEAM_RADIANT) then
        return SHOP_RADIANT
    elseif (GetTeam() == TEAM_DIRE) then
        return SHOP_DIRE
    end
end

function ShopDistance( hUnit, iShop )
  if (iShop == SHOP_DIRE or iShop == SHOP_RADIANT) then
    return hUnit:DistanceFromFountain()
  elseif (iShop == SHOP_SIDE_BOT or iShop == SHOP_SIDE_TOP) then
    return hUnit:DistanceFromSideShop()
  else
    return hUnit:DistanceFromSecretShop()
  end
end

--- MAP & GAME ORIENTATION RELATED
function GetEnemyTeam()
    if (GetTeam() == TEAM_RADIANT) then
        return TEAM_DIRE
    elseif (GetTeam() == TEAM_DIRE) then
        return TEAM_RADIANT
    end
end

function GetFront(Team, Lane)
    return GetLaneFrontLocation(Team, Lane, GetLaneFrontAmount(Team, Lane, true))
end

function Safelane()
    return ((GetTeam() == TEAM_RADIANT) and LANE_BOT or LANE_TOP)
end

function Hardlane()
    return ((GetTeam() == TEAM_RADIANT) and LANE_TOP or LANE_BOT)
end


