-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

local dbg = require( GetScriptDirectory().."/debug" )

local webserver = {}

webserver.lastUpdate  = -1000.0
webserver.lastReply   = nil

local function dumpUnitInfo( hUnit )
    local str = '"' .. hUnit:GetUnitName() .. '":{'
    
    str = str .. '"Health": ' .. hUnit:GetHealth()
    str = str .. ', "MaxHealth": ' .. hUnit:GetMaxHealth()
    
    str = str .. ', "Mana": ' .. hUnit:GetMana()
    str = str .. ', "MaxMana": ' .. hUnit:GetMaxMana()
    
    local loc = hUnit:GetLocation()
    str = str .. ', "Loc_X": ' .. loc.x
    str = str .. ', "Loc_Y": ' .. loc.y
    str = str .. ', "Loc_Z": ' .. loc.z
    
    str = str .. ', "Team": ' .. hUnit:GetTeam()
    
    if hUnit:IsHero() then
        str = str .. ', "ID": ' .. hUnit:GetPlayerID()
    end
    
    str = str .. '}'
    return str
end

local function dumpAlliedHeroes()
    local str = ''
    count = 1
    str = str..'"alliedHeroes":{'
    local alliedHeroes = GetUnitList(UNIT_LIST_ALLIED_HEROES)
    for _, value in pairs(alliedHeroes) do
        if count > 1 then str = str..', ' end

        str = str .. dumpUnitInfo( value )

        count = count + 1
    end
    str = str..'}'
    return str
end

local function dumpAlliedHeroesOther()
    local str = ''
    count = 1
    str = str..'"alliedHeroesOther":{'
    local alliedHeroesOther = GetUnitList(UNIT_LIST_ALLIED_OTHER)
    for _, value in pairs(alliedHeroesOther) do
        if count > 1 then str = str..', ' end
        str = str .. dumpUnitInfo( value )
        count = count + 1
    end
    str = str..'}'
    return str
end

local function dumpAlliedCreep()
    local str = ''
    count = 1
    str = str..'"alliedCreep":{'
    local alliedCreep = GetUnitList(UNIT_LIST_ALLIED_CREEPS)
    for _, value in pairs(alliedCreep) do
        if count > 1 then str = str..', ' end

        str = str .. dumpUnitInfo( value )

        count = count + 1
    end
    str = str..'}'
    return str
end

local function dumpAlliedWards()
    local str = ''
    count = 1
    str = str..'"alliedWards":{'
    local alliedWards = GetUnitList(UNIT_LIST_ALLIED_WARDS)
    for _, value in pairs(alliedWards) do
        if count > 1 then str = str..', ' end

        str = str .. dumpUnitInfo( value )

        count = count + 1
    end
    str = str..'}'
    return str
end

local function dumpNeutralCreep()
    local str = ''
    count = 1
    str = str..'"neutralCreep":{'
    local neutralCreep = GetUnitList(UNIT_LIST_NEUTRAL_CREEPS)
    for _, value in pairs(neutralCreep) do
        if count > 1 then str = str..', ' end

        str = str .. dumpUnitInfo( value )

        count = count + 1
    end
    str = str..'}'
    return str
end

local function dumpEnemyHeroes()
    local str = ''
    count = 1
    str = str..'"enemyHeroes":{'
    local enemyHeroes = GetUnitList(UNIT_LIST_ENEMY_HEROES)
    for _, value in pairs(enemyHeroes) do
        if count > 1 then str = str..', ' end
        str = str .. dumpUnitInfo( value )
        count = count + 1
    end
    str = str..'}'
    return str
end

local function dumpEnemyHeroesOther()
    local str = ''
    count = 1
    str = str..'"enemyHeroesOther":{'
    local enemyHeroesOther = GetUnitList(UNIT_LIST_ENEMY_OTHER)
    for _, value in pairs(enemyHeroesOther) do
        if count > 1 then str = str..', ' end

        str = str .. dumpUnitInfo( value )

        count = count + 1
    end
    str = str..'}'
    return str
end

local function dumpEnemyCreep()
    local str = ''
    count = 1
    str = str..'"enemyCreep":{'
    local enemyCreep = GetUnitList(UNIT_LIST_ENEMY_CREEPS)
    for _, value in pairs(enemyCreep) do
        if count > 1 then str = str..', ' end

        str = str .. dumpUnitInfo( value )

        count = count + 1
    end
    str = str..'}'
    return str
end

local function dumpEnemyWards()
    local str = ''
    count = 1
    str = str..'"enemyWards":{'
    local enemyWards = GetUnitList(UNIT_LIST_ENEMY_WARDS)
    for _, value in pairs(enemyWards) do
        if count > 1 then str = str..', ' end

        str = str .. dumpUnitInfo( value )

        count = count + 1
    end
    str = str..'}'
    return str
end

local function dumpTeleportInfo( hTable )
    local str = '"' .. hTable.playerid .. '":{'

    str = str .. '"TimeRemaining": ' .. hTable.time_remaining
    
    local loc = hTable.location
    str = str .. ', "Loc_X": ' .. loc.x
    str = str .. ', "Loc_Y": ' .. loc.y
    str = str .. ', "Loc_Z": ' .. loc.z
    
    str = str .. '}'
    return str
end

local function dumpGetIncomingTeleports()
    local str = ''
    count = 1
    str = str..'"incomingTeleports":{'
    local teleports = GetIncomingTeleports()
    for _, value in pairs(teleports) do
        if count > 1 then str = str..', ' end

        str = str .. dumpTeleportInfo( value )

        count = count + 1
    end
    str = str..'}'
    return str
end

local function reportEnemyCastInfo()
    --InstallCastCallback()
end

function webserver.SendData()
    if (GameTime() - webserver.lastUpdate) > 0.25 then
        local json = '{'
                
        json = json..dumpAlliedHeroes()
        json = json..", "..dumpEnemyHeroes()
        json = json..", "..dumpAlliedHeroesOther()
        json = json..", "..dumpEnemyHeroesOther()
        json = json..", "..dumpAlliedCreep()
        json = json..", "..dumpNeutralCreep()
        json = json..", "..dumpEnemyCreep()
        json = json..", "..dumpAlliedWards()
        json = json..", "..dumpEnemyWards()
        json = json..", "..dumpGetIncomingTeleports()
        
        webserver.lastUpdate = GameTime()
        --dbg.myPrint("LastUpdate - ", webserver.lastUpdate)
        
        json = json..', "updateTime": ' .. webserver.lastUpdate
        json = json..'}'
        
        --dbg.myPrint(tostring(json))
        
        local req = CreateHTTPRequest( ":2222" )
        req:SetHTTPRequestRawPostBody("application/json", json)
        req:Send( function( result )
            for k,v in pairs( result ) do
                if k == "Body" then
                    webserver.lastReply = v
                    --print( webserver.lastReply )
                    break
                end
            end
        end )
    end
end

function webserver.GetLastReply()
    return webserver.lastReply
end

return webserver
