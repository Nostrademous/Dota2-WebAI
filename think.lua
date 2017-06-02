-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
-------------------------------------------------------------------------------

local freqTeamThink = 0.25
local lastTeamThink = -1000.0

local X = {}

function X.MainThink()
    
    -- Exercise TeamThink() at coded frequency
    if GameTime() > lastTeamThink then
        X.TeamThink()
        lastTeamThink = GameTime() + freqTeamThink
    end
    
    -- Exercise individual Hero think at every frame (if possible).
    -- HeroThink() will check assignments from TeamThink()
    -- for that individual Hero that it should perform, if any.
    return X.HeroThink()
end

function X.TeamThink()
    dbg.myPrint("TeamThink")
end

function X.HeroThink()
    dbg.myPrint("HeroThink")
    
    local bot = GetBot()

    local highestDesireValue = BOT_MODE_DESIRE_NONE
    local highestDesireMode = noneMode
    
    local evaluatedDesireValue = BOT_MODE_DESIRE_NONE 
    
    return highestDesireMode, highestDesireValue
end

return X
