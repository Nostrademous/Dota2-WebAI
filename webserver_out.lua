-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

dkjson = require( "game/dkjson" )

local dbg = require( GetScriptDirectory().."/debug" )
local packet = require( GetScriptDirectory().."/data_packet" )
local web_config = require( GetScriptDirectory().."/web_config" )

local webserver = {}

local webserverFound = false
local webserverAuthTried = false

webserver.startTime         = -1000.0
webserver.lastWorldUpdate   = -1000.0
webserver.lastEnemiesUpdate = -1000.0
webserver.lastAlliesUpdate  = -1000.0
webserver.lastReply         = nil

local function dumpHeroInfo( hHero )
    if not ValidTarget(hHero) then return "{}" end
    local data = {}
    
    if hHero.mybot then
        data.Name   = heroData[hHero.mybot.Name].Name:lower()
        data.NextItems  = hHero.mybot.sNextItem
        data.NextAbs    = hHero.mybot.sNextAbility
    else
        data.Name   = heroData[GetUnitName(hHero)].Name:lower()
    end
    data.Team       = hHero:GetTeam()
    data.Level      = hHero:GetLevel()
    data.Health     = hHero:GetHealth()
    data.MaxHealth  = hHero:GetMaxHealth()
    data.HealthReg  = hHero:GetHealthRegen()
    data.Mana       = hHero:GetMana()
    data.MaxMana    = hHero:GetMaxMana()
    data.ManaReg    = hHero:GetManaRegen()
    data.MS         = hHero:GetCurrentMovementSpeed()
    
    local loc = hHero:GetLocation()
    data.X          = loc.x
    data.Y          = loc.y
    data.Z          = loc.z
    
    local items = {}
    for iInvIndex = 0, 15, 1 do
        local hItem = hHero:GetItemInSlot(iInvIndex)
        if hItem ~= nil then
            local str = hItem:GetName()
            local numCharges = hItem:GetCurrentCharges()
            if numCharges > 1 then
                str = str .. '_' .. numCharges
            end
            table.insert(items, str)
        end
    end
    data.Items      = items
    
    -- this is data only available to heroes on my team
    if hHero:GetTeam() == GetTeam() then
        data.Gold       = hHero:GetGold()
        data.AP         = hHero:GetAbilityPoints()
    end

    return data
end

local function dumpUnitInfo( hUnit )
    if not ValidTarget(hUnit) then return "{}" end
    
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
        
        str = str .. ', "Items": ['
        
        local count = 1
        for iInvIndex = 0, 15, 1 do
            local hItem = hUnit:GetItemInSlot(iInvIndex)
            if hItem ~= nil then
                if count > 1 then str = str .. ', ' end
                str = str .. '"' .. hItem:GetName()
                local numCharges = hItem:GetCurrentCharges()
                if numCharges > 1 then
                    str = str .. '_' .. numCharges
                end
                str = str .. '"'
                count = count + 1
            end
        end
        str = str .. ']'
    end
    
    str = str .. '}'
    return str
end

local function dumpCourierInfo()
    local data = {}
    
    local numCouriers = GetNumCouriers()
    data.Num = GetNumCouriers()

    if numCouriers > 0 then
        -- NOTE: GetCourier( iCourier ) is 0-indexed
        for i = 0, numCouriers-1, 1 do
            local hCourier = GetCourier(i)
            local cdata = {}

            cdata.Health    = hCourier:GetHealth()
            cdata.Fly       = IsFlyingCourier(hCourier)
            cdata.State     = GetCourierState(hCourier)
            
            local loc = hCourier:GetLocation()
            cdata.X = loc.x
            cdata.Y = loc.y
            cdata.Z = loc.z
            
            data["C_"..tostring(i+1)] = cdata
        end
    end
    
    return data
end

local function dumpAlliedHeroes()
    local data = {}
    
    local alliedHeroes = GetUnitList(UNIT_LIST_ALLIED_HEROES)
    for _, ally in pairs(alliedHeroes) do
        if not ally:IsBot() or ally.mybot == nil then
            if not ally:IsIllusion() then
                data["Ally_"..tostring(ally:GetPlayerID())] = dumpHeroInfo(ally)
            end
        end
    end
    
    return data
end

local function dumpAlliedHeroesOther()
    local str = ''
    local count = 1
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
    local count = 1
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
    local count = 1
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
    local count = 1
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
    local data = {}
    
    local enemyHeroes = GetUnitList(UNIT_LIST_ENEMY_HEROES)
    for _, enemy in pairs(enemyHeroes) do
        if ValidTarget(enemy) then
            -- we add a _# to handle illusions for enemies
            local count = 1
            local key = "E_"..tostring(enemy:GetPlayerID()).."_"..tostring(count)
            while InTable(data, key) do
                count = count + 1
                key = "E_"..tostring(enemy:GetPlayerID()).."_"..tostring(count)
            end
            data[key] = dumpHeroInfo(enemy)
        end
    end
    
    return data
end

local function dumpEnemyHeroesOther()
    local str = ''
    local count = 1
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
    local count = 1
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
    local count = 1
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
    local count = 1
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

    str = str .. '"Ability": ' .. dkjson.encode(hTable.ability)
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
    local count = 1
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
    local count = 1
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
    local count = 1
    str = str..'"castCallback":{'
    str = str..callbackStr
    str = str..'}'
    
    callbackStr = ""
    return str
end

function webserver.SendPacket( json )    
    local req = CreateHTTPRequest( web_config.IP_ADDR .. ":" .. web_config.IP_PORT )
    req:SetHTTPRequestRawPostBody("application/json", json)
    req:Send( function( result )
        for k,v in pairs( result ) do
            if k == "Body" then
                local jsonReply, pos, err = dkjson.decode(v, 1, nil)
                if err then
                    print("JSON Decode Error: ", err)
                    print("Sent Message: ", json)
                    print("Msg Body: ", v)
                else
                    --print( tostring(jsonReply) )
                    packet:ProcessPacket(jsonReply.Type, jsonReply)
                    
                    if jsonReply.Type == packet.TYPE_AUTH then
                        webserverFound = true
                        print("Connected Successfully to Backend Server")
                    end
                end
                --break
            end
        end
    end )
end

function webserver.SendData(hBot)
    -- if we have not verified the presence of a webserver yet, send authentication packet
    if not webserverFound and not webserverAuthTried then
        webserverAuthTried = true
        local jsonData = webserver.CreateAuthPacket()
        packet:CreatePacket(packet.TYPE_AUTH, jsonData)
        webserver.SendPacket(jsonData)
    end
    
    -- if we have a webserver
    if webserverFound then
        -- initialize our cast callback if we have not done so yet
        if not callbackInit then
            InstallCastCallback(-1, callbackFunc)
            callbackInit = true
        end
    
        -- check if we need to send a World Update Packet
        if packet.LastPacket[packet.TYPE_WORLD] == nil or packet.LastPacket[packet.TYPE_WORLD].processed
            or (GameTime() - webserver.lastWorldUpdate) > 0.5 then
            local jsonData = webserver.CreateWorldUpdate()
            packet:CreatePacket(packet.TYPE_WORLD, jsonData)
            webserver.lastWorldUpdate = GameTime()
            dbg.myPrint("Sending World Update: ", tostring(jsonData))
            webserver.SendPacket(jsonData)
        end
        
        -- check if we need to send an Enemies Update Packet
        if packet.LastPacket[packet.TYPE_ENEMIES] == nil or packet.LastPacket[packet.TYPE_ENEMIES].processed
            or (GameTime() - webserver.lastEnemiesUpdate) > 0.25 then
            local jsonData = webserver.CreateEnemiesUpdate()
            packet:CreatePacket(packet.TYPE_ENEMIES, jsonData)
            webserver.lastEnemiesUpdate = GameTime()
            dbg.myPrint("Sending Enemies Update: ", tostring(jsonData))
            webserver.SendPacket(jsonData)
        end
        
        -- check if we need to send a Player Update Packet
        local sPID = tostring(hBot:GetPlayerID())
        local id = packet.TYPE_PLAYER .. sPID
        if packet.LastPacket[id] == nil or packet.LastPacket[id].processed 
            or (webserver["lastPlayerUpdate"..sPID] and (GameTime() - webserver["lastPlayerUpdate"..sPID]) > 0.25) then
            local jsonData = webserver.CreatePlayerUpdate(hBot)
            packet:CreatePacket(id, jsonData)
            webserver["lastPlayerUpdate"..sPID] = GameTime()
            dbg.myPrint("Sending Player Update: ", tostring(jsonData))
            webserver.SendPacket(jsonData)
        end

        -- check if we need to send an Enemies Update Packet
        if packet.LastPacket[packet.TYPE_ALLIES] == nil or (packet.LastPacket[packet.TYPE_ALLIES].processed
            and (GameTime() - webserver.lastAlliesUpdate) > 0.5) then
            local jsonData = webserver.CreateAlliesUpdate()
            packet:CreatePacket(packet.TYPE_ALLIES, jsonData)
            webserver.lastAlliesUpdate = GameTime()
            dbg.myPrint("Sending Allies Update: ", tostring(jsonData))
            webserver.SendPacket(jsonData)
        end
    end
end

function webserver.CreateAuthPacket()
    local json = {}
    
    json.Type = packet.TYPE_AUTH
    json.Time = RealTime()
    
    return dkjson.encode(json)
end

function webserver.CreateWorldUpdate()
    local json = {}
    
    json.Type = packet.TYPE_WORLD
    json.Time = RealTime()
    json.DotaTime = DotaTime()

    -- report Lane Front info for both teams (does not ignore towers)
    json.RTopFront = GetLaneFrontAmount(TEAM_RADIANT, LANE_TOP, false)
    json.RMidFront = GetLaneFrontAmount(TEAM_RADIANT, LANE_MID, false)
    json.RBotFront = GetLaneFrontAmount(TEAM_RADIANT, LANE_BOT, false)
    json.DTopFront = GetLaneFrontAmount(TEAM_DIRE, LANE_TOP, false)
    json.DMidFront = GetLaneFrontAmount(TEAM_DIRE, LANE_MID, false)
    json.DBotFront = GetLaneFrontAmount(TEAM_DIRE, LANE_BOT, false)
    
    json.CourierData    = dumpCourierInfo()
    
    --[[
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
    --]]
    
    return dkjson.encode(json)
end

function webserver.CreatePlayerUpdate(hBot)
    local json = {}
    
    json.Type = packet.TYPE_PLAYER .. tostring(hBot:GetPlayerID())
    json.Time = RealTime()
    
    json.Data = dumpHeroInfo(hBot)
    
    return dkjson.encode(json)
end

function webserver.CreateEnemiesUpdate()
    local json = {}
    
    json.Type = packet.TYPE_ENEMIES
    json.Time = RealTime()
    
    json.Data = dumpEnemyHeroes()
    
    return dkjson.encode(json)
end

function webserver.CreateAlliesUpdate()
    local json = {}

    json.Type = packet.TYPE_ALLIES
    json.Time = RealTime()
    json.DotaTime = DotaTime()

    json.AlliedHeroes   = dumpAlliedHeroes()

    return dkjson.encode(json)
end

function webserver.GetLastReply(sType)
    return packet:GetLastReply(sType)
end

return webserver
