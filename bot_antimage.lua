-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

local dt = require( GetScriptDirectory().."/decision" )
local inv = require( GetScriptDirectory().."/helper/inventory_helper" )
local heroes = require(GetScriptDirectory().."/heroes/_heroes")

local botAM = dt:new(heroes:GetHero())

function botAM:new(o)
    o = o or dt:new(o)
    setmetatable(o, self)
    self.__index = self
    return o
end

local amBot = botAM:new{}

function Think()
    local hBot = GetBot()
    
    amBot:Think( hBot )
end
