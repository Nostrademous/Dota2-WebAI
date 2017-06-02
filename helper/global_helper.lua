-------------------------------------------------------------------------------
--- AUTHORS: iSarCasm, Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

globalInit = false

function InitializeGlobalVars()
    heroData = require( GetScriptDirectory().."/hero_data" )
    globalInit = true
end

function GetShop()
    if (GetTeam() == TEAM_RADIANT) then
        return SHOP_RADIANT
    elseif (GetTeam() == TEAM_DIRE) then
        return SHOP_DIRE
    end
end

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