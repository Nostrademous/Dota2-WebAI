-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

local server = require( GetScriptDirectory().."/webserver_out" )

-------------------------------------------------------------------------------
-- BASE CLASS - DO NOT MODIFY THIS SECTION
-------------------------------------------------------------------------------

local X = { init = false }

function X:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
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
    print( reply )
end

return X