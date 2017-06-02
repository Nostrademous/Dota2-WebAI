-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

require( GetScriptDirectory().."/helper/global_helper" )

dbg = require( GetScriptDirectory().."/debug" )

local think = require( GetScriptDirectory().."/think" )

local server = require( GetScriptDirectory().."/webserver_out" )

noneMode = dofile( GetScriptDirectory().."/modes/none" )

-------------------------------------------------------------------------------
-- BASE CLASS - DO NOT MODIFY THIS SECTION
-------------------------------------------------------------------------------

local X = { init = false, currentMode = noneMode, currentModeValue = BOT_MODE_DESIRE_NONE, prevMode = noneMode  }

function X:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function X:getCurrentMode()
    return self.currentMode
end

function X:getCurrentModeValue()
    return self.currentModeValue
end

function X:getPrevMode()
    return self.prevMode
end

function X:ExecuteMode()
    if self.currentMode ~= self.prevMode then
        if self.currentMode:GetName() == nil then
            dbg.pause("Unimplemented Mode: ", self.currentMode)
        end
        dbg.myPrint("Mode Transition: "..self.prevMode:GetName():upper().." --> "..self.currentMode:GetName():upper())

        -- call OnEnd() of previous mode
        self.prevMode:OnEnd()

        -- call OnStart() of new mode
        self.currentMode:OnStart()

        self.prevMode = self.currentMode
    end

    -- do Mode
    self.currentMode:Think()
end

function X:BeginMode(mode, value)
    if mode == nil then
        self.currentMode = noneMode
        self.currentModeValue = BOT_MODE_DESIRE_NONE
        return
    end
    
    if mode == self.currentMode then return end
    self.currentMode = mode
    self.currentModeValue = value
end

function X:ClearMode()
    self.currentMode = noneMode
    self.currentModeValue = BOT_MODE_DESIRE_NONE
    self:ExecuteMode()
end

-------------------------------------------------------------------------------
-- BASE INITIALIZATION & RESET FUNCTIONS - DO NOT OVER-LOAD
-------------------------------------------------------------------------------

function X:DoInit(bot)
    if not globalInit then
        InitializeGlobalVars()
    end

    self.Init = true
    bot.mybot = self
    
    self.lastModeThink = -1000.0
    
    self.moving_location = nil
    self.ability_location = nil
    self.ability_completed = -1000.0
    
    local fullName = bot:GetUnitName()
    self.Name = string.sub(fullName, 15, string.len(fullName))
end

function X:ResetTempVars()
    self.moving_location = nil
    
    if self.ability_location ~= nil then
        if GameTime() >= self.ability_completed then
            self.ability_location = nil
            self.ability_completed = -1000.0
        end
    end
end

-------------------------------------------------------------------------------
-- BASE THINK - DO NOT OVER-LOAD
-------------------------------------------------------------------------------

local lastReply = nil
local function ServerUpdate()
    server.SendData()

    local reply = server.GetLastReply(GetBot():GetUnitName())
    
    if reply == nil then
        return nil, BOT_MODE_DESIRE_NONE
    else
        if lastReply ~= reply then
            lastReply = reply
        end
    end

    return lastReply.Mode, lastReply.ModeValue
end

function X:Think(bot)
    -- if we are a human player, don't bother
    if not bot:IsBot() then return end

    if GetGameState() == GAME_STATE_PRE_GAME and not self.Init then
        self:DoInit(bot)
        return
    end

    if GetGameState() ~= GAME_STATE_GAME_IN_PROGRESS and GetGameState() ~= GAME_STATE_PRE_GAME then return end

    -- draw debug info to Game UI
    dbg.draw()
    
    -- do out Thinking and set our Mode
    if GameTime() - self.lastModeThink >= 0.1 then
        -- reset any frame-temporary variables
        self:ResetTempVars()
        
        -- try to get directives from the web-server
        local highestDesiredMode, highestDesiredValue = ServerUpdate()
        
        -- if we got "nil" then do local thinking
        if highestDesiredMode == nil then
            highestDesiredMode, highestDesiredValue = think.MainThink()
        end
        
        -- execute our current directives
        self:BeginMode(highestDesiredMode, highestDesiredValue)
        self:ExecuteMode()
        
        self.lastModeThink = GameTime()
    end
end

return X