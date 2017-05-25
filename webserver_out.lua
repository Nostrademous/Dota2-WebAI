-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

dkjson = require( "game/dkjson" )

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

local function dumpAOEInfo ( hTable )
    -- NOTE: an aoe will be table with { "location", "ability", "caster", "radius", "playerid" }.
    local str = '"' .. hTable.playerid .. '":{'

    str = str .. '"Ability": ' .. hTable.ability
    str = str .. ', "Radius": ' .. hTable.radius
    str = str .. ', "Caster": ' .. hTable.caster
    
    local loc = hTable.location
    str = str .. ', "Loc_X": ' .. loc.x
    str = str .. ', "Loc_Y": ' .. loc.y
    str = str .. ', "Loc_Z": ' .. loc.z
    
    str = str .. '}'
    return str
end

local function dumpDangerousAOEs()
    local str = ''
    count = 1
    str = str..'"dangerousAOEs":{'
    local badAOEs = GetAvoidanceZones()
    for _, aoe in pairs(badAOEs) do
        if aoe.caster:GetTeam() ~= GetTeam() or aoe.ability == "faceless_void_chronosphere" then
            if count > 1 then str = str..', ' end

            str = str .. dumpAOEInfo( aoe )

            count = count + 1
        end
    end
    str = str..'}'
    return str
end

local function dumpProjectileInfo( hTable )
    -- NOTE: a projectile will be a table with { "location", "ability", "velocity", "radius", "playerid" }
    local str = '"' .. hTable.playerid .. '":{'

    str = str .. '"Ability": ' .. hTable.ability
    str = str .. ', "Radius": ' .. hTable.radius
    str = str .. ', "Velocity": ' .. hTable.velocity
    
    local loc = hTable.location
    str = str .. ', "Loc_X": ' .. loc.x
    str = str .. ', "Loc_Y": ' .. loc.y
    str = str .. ', "Loc_Z": ' .. loc.z
    
    str = str .. '}'
    return str
end

local function dumpDangerousProjectiles()
    local str = ''
    count = 1
    str = str..'"dangerousProjectiles":{'
    local badProjectiles = GetLinearProjectiles()
    for _, projectile in pairs(badProjectiles) do
        if projectile.playerid == nil or GetTeamForPlayer(projectile.playerid) ~= GetTeam() then
            if count > 1 then str = str..', ' end

            str = str .. dumpProjectileInfo( projectile )

            count = count + 1
        end
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

local function dumpCastCallbackInfo( hTable )
    local str = '"' .. hTable.playerid .. '":{'

    str = str .. '"TimeRemaining": ' .. hTable.time_remaining
    
    local loc = hTable.location
    str = str .. ', "Loc_X": ' .. loc.x
    str = str .. ', "Loc_Y": ' .. loc.y
    str = str .. ', "Loc_Z": ' .. loc.z
    
    str = str .. '}'
    return str
end

local callbackInit = false
local callbackStr = ""

function callbackFunc( hTable )
    local str = '"'
    if callbackStr ~= "" then str = ', "' end

    str = str .. hTable.player_id .. '":{'
    if hTable.unit == nil then
        str = str .. '"CastingUnit": UNKNOWN'
    else
        str = str .. '"CastingUnit": ' .. dumpUnitInfo( hTable.unit )
    end
    
    if hTable.ability == nil then
        str = str .. ', "Ability": UNKNOWN'
    else
        str = str .. ', "Ability": ' .. hTable.ability:GetName()
    end
    
    local loc = hTable.location
    str = str .. ', "Loc_X": ' .. loc.x
    str = str .. ', "Loc_Y": ' .. loc.y
    str = str .. ', "Loc_Z": ' .. loc.z
    str = str .. '}'
    
    callbackStr = callbackStr .. str
end

local function dumpCastCallback()
    local str = ''
    count = 1
    str = str..'"castCallback":{'
    str = str..callbackStr
    str = str..'}'
    
    callbackStr = ""
    return str
end

function webserver.SendData()
    if (GameTime() - webserver.lastUpdate) > 0.5 then
    
        if not callbackInit then
            InstallCastCallback(-1, callbackFunc)
            callbackInit = true
        end
    
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
        json = json..", "..dumpDangerousAOEs()
        json = json..", "..dumpDangerousProjectiles()
        json = json..", "..dumpGetIncomingTeleports()
        json = json..", "..dumpCastCallback()
        
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
                    local obj, pos, err = dkjson.decode(v, 1, nil)
                    if err then
                        print("JSON Decode Error: ", err)
                        webserver.lastReply = nil
                    else
                        webserver.lastReply = obj
                        --print( webserver.lastReply )
                    end
                    break
                end
            end
        end )
    end
end

function webserver.GetLastReply( sHeroName )
    if webserver.lastReply == nil then
        dbg.myPrint( "No Server Reply - Is it Running???" )
        return nil
    end
    
    dbg.myPrint( webserver.lastReply.Timestamp )
    
    -- if we are not provided a hero name, return full last reply
    if sHeroName == nil and webserver.lastReply then
        return webserver.lastReply
    end
    
    -- if we are provided a hero name, return reply for that hero
    if webserver.lastReply[sHeroName] ~= nil then
        return webserver.lastReply[sHeroName]
    end
    
    return nil
end

return webserver
