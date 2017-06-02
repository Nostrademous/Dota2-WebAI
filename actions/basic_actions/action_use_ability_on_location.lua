local UseAbilityOnLocation = {}

UseAbilityOnLocation.Name = "Use Ability On Location"

-------------------------------------------------
function UseAbilityOnLocation:Call(ability, vLoc, fCastPoint)
    local bot = GetBot()
    bot.mybot.ability_location = vLoc
    bot.mybot.ability_completed = GameTime() + fCastPoint
    bot:Action_UseAbilityOnLocation(ability, vLoc)
end
-------------------------------------------------

return UseAbilityOnLocation