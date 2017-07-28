-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous, iSarCasm
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

local Danger = {}

local VectorHelper  = require(GetScriptDirectory().."/helper/vector_helper")

-----------------------------------------

local FountainDanger  = require(GetScriptDirectory().."/danger/fountain_danger")
local TowerDanger     = require(GetScriptDirectory().."/danger/tower_danger")
local HeroDanger      = require(GetScriptDirectory().."/danger/hero_danger")

-----------------------------------------

Danger.danger_sources = {
    FountainDanger,
    TowerDanger,
    HeroDanger
}

-----------------------------------------
local DANGER_TRAVEL_DISTANCE = 1000
-----------------------------------------

return Danger