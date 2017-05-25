local MapHelper = {}
----------------------
function MapHelper:LaneFrontLocation(team, lane, ignoreTowers)
    return GetLaneFrontLocation(team, lane, GetLaneFrontAmount(team, lane, ignoreTowers))
end

function MapHelper:GetFrontTowerAt(LANE)
    local T1 = -1
    local T2 = -1
    local T3 = -1

    if(LANE == LANE_TOP) then
        T1 = TOWER_TOP_1
        T2 = TOWER_TOP_2
        T3 = TOWER_TOP_3
    elseif(LANE == LANE_MID) then
        T1 = TOWER_MID_1
        T2 = TOWER_MID_2
        T3 = TOWER_MID_3
    elseif(LANE == LANE_BOT) then
        T1 = TOWER_BOT_1
        T2 = TOWER_BOT_2
        T3 = TOWER_BOT_3
    end

    local tower = GetTower(GetTeam(),T1)
    if(tower ~= nil and tower:IsAlive())then
        return tower
    end

    tower = GetTower(GetTeam(),T2)
    if(tower ~= nil and tower:IsAlive())then
        return tower
    end

    tower = GetTower(GetTeam(),T3)
    if(tower ~= nil and tower:IsAlive())then
        return tower
    end
    return nil
end

function MapHelper:GetEnemyFrontTowerAt(LANE)
    local T1 = -1
    local T2 = -1
    local T3 = -1

    if(LANE == LANE_TOP) then
        T1 = TOWER_TOP_1
        T2 = TOWER_TOP_2
        T3 = TOWER_TOP_3
    elseif(LANE == LANE_MID) then
        T1 = TOWER_MID_1
        T2 = TOWER_MID_2
        T3 = TOWER_MID_3
    elseif(LANE == LANE_BOT) then
        T1 = TOWER_BOT_1
        T2 = TOWER_BOT_2
        T3 = TOWER_BOT_3
    end
    local team = (GetTeam() == 2) and 3 or 2
    local tower = GetTower(team,T1)
    if(tower ~= nil and tower:IsAlive())then
        return tower
    end

    tower = GetTower(team,T2)
    if(tower ~= nil and tower:IsAlive())then
        return tower
    end

    tower = GetTower(team,T3)
    if(tower ~= nil and tower:IsAlive())then
        return tower
    end
    return nil
end
----------------------
return MapHelper