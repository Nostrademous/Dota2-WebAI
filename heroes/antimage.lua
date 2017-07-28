-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous, iSarCasm
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

local BotInfo = require(GetScriptDirectory().."/bot_info")

-------------------------------------------

local Hero = BotInfo:new()

-------------------------------------------

Hero = Hero:new()

Hero:Init(Safelane(), ROLE_CARRY)
Hero.projectileSpeed = 0

-------------------------------------------

return Hero