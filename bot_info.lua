-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous, iSarCasm
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

local MapHelper   = require(GetScriptDirectory().."/helper/map_helper")
local UnitHelper  = require(GetScriptDirectory().."/helper/unit_helper")

--------------------------------------------------------

local BotInfo = {}

--------------------------------------------------------

function BotInfo:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function BotInfo:Init(lane, role)
    self.LANE = lane
    self.ROLE = role

    self.lastHealth = 0
    self.health = 0
    self.lastHealthCapture = DotaTime()
    self.healthDelta = 0
end

--------------------------------------------------------

return BotInfo