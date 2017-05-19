-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

local dbg = require( GetScriptDirectory().."/debug" )

local server = require( GetScriptDirectory().."/webserver_out" )

none = dofile( GetScriptDirectory().."/modes/none" )

-------------------------------------------------------------------------------
-- BASE CLASS - DO NOT MODIFY THIS SECTION
-------------------------------------------------------------------------------

local X = { init = false, currentMode = none, currentModeValue = BOT_MODE_DESIRE_NONE, prevMode = none  }

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
    if mode == self.currentMode then return end
    self.currentMode = mode
    self.currentModeValue = value
end

function X:ClearMode()
    self.currentMode = none
    self.currentModeValue = BOT_MODE_DESIRE_NONE
    self:ExecuteMode()
end

-------------------------------------------------------------------------------
-- BASE INITIALIZATION - DO NOT OVER-LOAD
-------------------------------------------------------------------------------

function X:DoInit(bot)

    self.Init = true
end

-------------------------------------------------------------------------------
-- BASE THINK - DO NOT OVER-LOAD
-------------------------------------------------------------------------------

function X:Think(bot)
    -- if we are a human player, don't bother
    if not bot:IsBot() then return end

    if GetGameState() == GAME_STATE_PRE_GAME and not self.Init then
        self:DoInit(bot)
        return
    end

    if GetGameState() ~= GAME_STATE_GAME_IN_PROGRESS and GetGameState() ~= GAME_STATE_PRE_GAME then return end

    server.SendData()

    local reply = server.GetLastReply()
    dbg.myPrint( reply )
end

return X