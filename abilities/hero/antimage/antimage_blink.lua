local VectorHelper = require(GetScriptDirectory().."/dev/helper/vector_helper")
local Action = require(GetScriptDirectory().."/actions/basic_actions/action_use_ability_on_location")

local AntimageBlink = {}
AntimageBlink.Name = heroData.antimage.SKILL_1

function AntimageBlink:Ability()
    return GetBot():GetAbilityByName(self.Name)
end

function AntimageBlink:Desire()
    local bot = GetBot()
    
    local ability = self:Ability()
    
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE
    end

    local move_loc = bot.mybot.moving_location
    if not move_loc then
        return BOT_ACTION_DESIRE_NONE
    end
    
    local distance = GetUnitToLocationDistance(bot, move_loc)
    
    -- minimum blink distance is 200
    if distance < 200 then
        return BOT_ACTION_DESIRE_NONE
    end
    
    if bot:GetMana() > 120 and (distance > 900) then
        return BOT_ACTION_DESIRE_MEDIUM 
    end
    
    return BOT_ACTION_DESIRE_NONE
end

function AntimageBlink:Call()
    local bot = GetBot()
    
    local ability = self:Ability()
    local max_blink_range = ability:GetSpecialValueInt("blink_range")
    local move_loc = bot.mybot.moving_location
    
    local distance = GetUnitToLocationDistance(bot, move_loc)
    
    if distance > max_blink_range then
        move_loc = VectorHelper:VectorTowards(bot:GetLocation(), move_loc, max_blink_range)
    end
    
    Action:Call(ability, move_loc, ability:GetCastPoint())
end

return AntimageBlink