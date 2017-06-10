local next = next  -- https://stackoverflow.com/a/1252776
local VectorHelper = require(GetScriptDirectory().."/helper/vector_helper")
local UnitHelper = require(GetScriptDirectory().."/helper/unit_helper")
local Stacking = {}

Stacking.Name = "Stacking"

-------------------------------------------------

function Stacking:Call(bot, camp_location, camp_timing, camp_wait_at, camp_pull_to)
    -- Returns false if it still has future stacking actions to accomplish
    -- Returns true if it has finished the stack

    --TODO check if need to update timings based on range/projectile speed/animation speed?
    local current_action = bot:GetCurrentActionType()
    dbg.myPrint("In Stacking. Current action: ", current_action)

    -- treat both these options same as nil option from initial call of stack
    if current_action == BOT_ACTION_TYPE_NONE or current_action == BOT_ACTION_TYPE_IDLE then
        current_action = nil
    end

    -- action nil check necessary
    -- as otherwise passing over the pull_to spot whilst moving to stack will inadvertently cancel it
    if current_action == nil and VectorHelper:GetDistance(bot:GetLocation(), camp_pull_to) < 200 then
        return true
    end


    if GetSeconds() < camp_timing then  -- It's not time to pull/stack yet
        -- If we're already at the waiting spot, nothing to do
        if VectorHelper:GetDistance(bot:GetLocation(), camp_wait_at) > 1 then
            bot:Action_MoveToLocation(camp_wait_at)
        end
    else
        -- take minimum distance between Attack Range and Vision Range (at night we can attack farther than we can see)
        local attack_range = math.min(bot:GetAttackRange(), bot:GetCurrentVisionRange())
        if current_action == nil and not UnitHelper:isRanged(bot) then  -- again could attach isRanged to the bot table?
            bot:Action_MoveToLocation(camp_location)
            bot:ActionQueue_MoveToLocation(camp_pull_to)
        else
            -- two options here
            -- 1) attack move. we track when projectile in air then move back
            -- 2) we check until the camp is visible whilst moving towards it (trees can obscure, especially at night)
            --    once neutral visible we do AttackUnit(bOnce=true), then queue a move back
            if current_action == nil then
                bot:Action_MoveLocation(camp_location)
            elseif current_action == BOT_ACTION_TYPE_MOVE then
                local first_neutral = next(bot:GetNearbyNeutralCreeps(attack_range))
                if first_neutral ~= nil then
                    bot:Action_AttackUnit(first_neutral, true)
                    bot:ActionQueue_MoveToLocation(camp_pull_to)
                end
            end
        end
    end
    return false
end

return Stacking
-------------------------------------------------