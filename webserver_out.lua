-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

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

function webserver.SendData()
    if GameTime() - webserver.lastUpdate > 0.1 then
            
        webserver.lastUpdate = GameTime()
        
        local json = '{'
                
        json = json..dumpAlliedHeroes()
        json = json..", "..dumpEnemyHeroes()
        json = json..", "..dumpAlliedHeroesOther()
        json = json..", "..dumpEnemyHeroesOther()
        
        json = json..', "updateTime": ' .. webserver.lastUpdate
        json = json..'}'
        
        --print(tostring(json))
        
        local req = CreateHTTPRequest( ":2222" )
        req:SetHTTPRequestRawPostBody("application/json", json)
        req:Send( function( result )
            --print( "\nPOST response:" )
            for k,v in pairs( result ) do
                if k == "Body" then
                    webserver.lastReply = v
                end
                --print( webserver.lastReply )
            end
            --print( "Done\n" )
        end )
    end
end

function webserver.GetLastReply()
    return webserver.lastReply
end

return webserver
