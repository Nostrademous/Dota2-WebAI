local next = next  -- https://stackoverflow.com/a/1252776
local VectorHelper = require(GetScriptDirectory().."/helper/vector_helper")

local StackCamp = {}

StackCamp.Name = "Stack Camp"

-------------------------------------------------

function StackCamp:Call(camp_location, camp_timing, camp_wait_at, camp_pull_to)
    -- Returns 0 if it still has future stacking actions to accomplish
    -- Returns 1 if it has not finished stacking, but will do so if action queue left alone


    -- Making assumption that clear action-queue before tell it to stack
    -- otherwise its hard to not keep giving it a moveLocation command every frame

    --TODO check if need to update timings based on range/projectile speed/animation speed?
    local bot = GetBot()
    local current_action = bot:GetCurrentActionType()

    if current_action == nil and GetSeconds() < camp_timing then  -- It's not time to pull/stack yet
        -- If we're already at the waiting spot, nothing to do
        if VectorHelper:GetDistance(bot:GetLocation(), camp_wait_at) > 1 then
            -- I could use MoveToLocation:Call. but then its doing GetBot() twice. doesnt feel necessary.
            -- these functions can actually be attached to the bot 'table'
            -- i.e. function CDOTA_Bot_Script:pull_camp(camp, timing, should_chain, pull_num)
            -- they are then simply called with bot:pull_camp(blah...)
            bot:Action_MoveToLocation(camp_wait_at)
        end
    else
        local attack_range = bot:GetAttackRange()
        if current_action == nil and not isRanged(bot) then  -- again could attach isRanged to the bot table?
            bot:Action_MoveToLocation(camp_location)
            bot:ActionQueue_MoveToLocation(camp_pull_to)
            return 1
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
                    bot:ActionAttackUnit(first_neutral, true)
                    bot:ActionQueue_MoveToLocation(camp_pull_to)
                    return 1
                end
            end
        end
    end
    return 0
end


-------------------------------------------------