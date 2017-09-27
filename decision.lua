-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

--- LOAD OUR GLOBAL CONSTANTS
require( GetScriptDirectory().."/constants/tables" )
require( GetScriptDirectory().."/constants/generic" )
require( GetScriptDirectory().."/constants/roles" )
require( GetScriptDirectory().."/constants/runes" )
require( GetScriptDirectory().."/constants/shops" )
require( GetScriptDirectory().."/constants/fountains" )
require( GetScriptDirectory().."/constants/jungle" )

local item_map = require( GetScriptDirectory().."/constants/item_mappings" )

--- LOAD OUR HELPERS
require( GetScriptDirectory().."/helper/global_helper" )

local dp = require( GetScriptDirectory().."/data_packet" )
local InvHelp = require( GetScriptDirectory().."/helper/inventory_helper" )

--- LOAD OUR DEBUG SYSTEM
dbg = require( GetScriptDirectory().."/debug" )

local think = require( GetScriptDirectory().."/think" )

local server = require( GetScriptDirectory().."/webserver_out" )

noneMode = dofile( GetScriptDirectory().."/modes/none" )

-------------------------------------------------------------------------------
-- BASE CLASS - DO NOT MODIFY THIS SECTION
-------------------------------------------------------------------------------

local X = { init = false, currentMode = noneMode, currentModeValue = BOT_MODE_DESIRE_NONE, prevMode = noneMode  }

function X:new(myBotInfo)
    local mybot = {}
    setmetatable(mybot, self)
    self.__index = self
    mybot.botInfo = myBotInfo
    
    -- TODO - other stats we want to track?
    
    GetBot().mybot = mybot              -- make mybot accessible anywhere after calling GetBot()
    GetBot().botInfo = mybot.botInfo    -- make botInfo accessible
    
    return mybot
end

function X:getCurrentMode()
    return self.currentMode
end

function X:getCurrentModeValue()
    return self.currentModeValue
end

function X:getPrevMode()
    return self.prevMode
end

function X:ExecuteMode()
    if self.currentMode ~= self.prevMode then
        if self.currentMode:GetName() == nil then
            dbg.pause("Unimplemented Mode: ", self.currentMode)
        end
        dbg.myPrint("Mode Transition: "..self.prevMode:GetName():upper().." --> "..self.currentMode:GetName():upper())

        -- call OnEnd() of previous mode
        self.prevMode:OnEnd()

        -- call OnStart() of new mode
        self.currentMode:OnStart()

        self.prevMode = self.currentMode
    end

    -- do Mode
    self.currentMode:Think()
end

function X:BeginMode(mode, value)
    if mode == nil then
        self.currentMode = noneMode
        self.currentModeValue = BOT_MODE_DESIRE_NONE
        return
    end
    
    if mode == self.currentMode then return end
    self.currentMode = mode
    self.currentModeValue = value
end

function X:ClearMode()
    self.currentMode = noneMode
    self.currentModeValue = BOT_MODE_DESIRE_NONE
    self:ExecuteMode()
end

-------------------------------------------------------------------------------
-- BASE INITIALIZATION & RESET FUNCTIONS - DO NOT OVER-LOAD
-------------------------------------------------------------------------------

function X:DoInit(hBot)
    if not globalInit then
        InitializeGlobalVars()
    end

    self.Init = true
    hBot.mybot = self
    
    self.sNextAbility       = {}
    self.sNextItem          = {}
    self.lastModeThink      = -1000.0
    
    self.moving_location    = nil
    self.ability_location   = nil
    self.ability_completed  = -1000.0
    self.attack_target      = nil
    self.attack_target_id   = -1
    self.attack_completed   = -1000.0
    
    local fullName = hBot:GetUnitName()
    self.Name = string.sub(fullName, 15, string.len(fullName))
end

function X:ResetTempVars()
    self.moving_location    = nil
    
    if self.ability_location ~= nil then
        if GameTime() >= self.ability_completed then
            self.ability_location = nil
            self.ability_completed = -1000.0
        end
    end

    if self.attack_target ~= nil then
        if GameTime() >= self.attack_completed then
            self.attack_completed = -1000.0
        end
    end
end

-------------------------------------------------------------------------------
-- BASE THINK - DO NOT OVER-LOAD
-------------------------------------------------------------------------------

local lastReply = nil
local function ServerUpdate()
    local hBot = GetBot()
    
    server.SendData(hBot)

    local worldReply = server.GetLastReply(dp.TYPE_WORLD)
    if worldReply ~= nil then
        dbg.myPrint("Need to Process new World Reply")
        dbg.myPrint("Packet RTT: ", RealTime() - worldReply.Time)
    end
    
    local enemiesReply = server.GetLastReply(dp.TYPE_ENEMIES)
    if enemiesReply ~= nil then
        dbg.myPrint("Need to Process new Enemies Reply")
        dbg.myPrint("Packet RTT: ", RealTime() - enemiesReply.Time)
    end
    
    local botReply = server.GetLastReply(dp.TYPE_PLAYER..tostring(hBot:GetPlayerID()))
    
    if botReply == nil then
        return nil, BOT_MODE_DESIRE_NONE
    else
        dbg.myPrint("Need to Process new Player Reply")
        dbg.myPrint("Packet RTT: ", RealTime() - botReply.Time)
        if botReply.Data then
            if botReply.Data.StartItems then
                if #hBot.mybot.sNextItem == 0 then
                    hBot.mybot.sNextItem = botReply.Data.StartItems
                end
            end
            
            if botReply.Data.LevelAbs then
                if #hBot.mybot.sNextAbility == 0 then
                    hBot.mybot.sNextAbility = botReply.Data.LevelAbs
                end
            end
        end
    end

    return nil, BOT_MODE_DESIRE_NONE
end

function X:Think(hBot)
    -- if we are a human player, don't bother
    if not hBot:IsBot() then return end

    if not self.Init then
        self:DoInit(hBot)
        return
    end

    if GetGameState() ~= GAME_STATE_GAME_IN_PROGRESS and GetGameState() ~= GAME_STATE_PRE_GAME then return end

    -- draw debug info to Game UI
    dbg.draw()
    
    -- do out Thinking and set our Mode
    if GameTime() - self.lastModeThink >= 0.1 then
        -- reset any frame-temporary variables
        self:ResetTempVars()
        
        -- try to get directives from the web-server
        local highestDesiredMode, highestDesiredValue = ServerUpdate()
        
        -- if we got "nil" then do local thinking
        if highestDesiredMode == nil then
            highestDesiredMode, highestDesiredValue = think.MainThink()
        end
        
        -- execute any atomic operations
        self:ExecuteAtomicOperations(hBot)
        
        -- execute our current directives
        self:BeginMode(highestDesiredMode, highestDesiredValue)
        self:ExecuteMode()
        
        self.lastModeThink = GameTime()
    end
end

-------------------------------------------------------------------------------
-- ATOMIC OPERATIONS
-------------------------------------------------------------------------------

function X:ExecuteAtomicOperations(hBot)
    self:Atomic_LearnAbilities(hBot)
    self:Atomic_BuyItems(hBot)
    self:Atomic_SwapItems(hBot)
end

function X:Atomic_LearnAbilities(hBot)
    if #hBot.mybot.sNextAbility == 0 then return end
    
    local nAbilityPoints = hBot:GetAbilityPoints()
    if nAbilityPoints > 0 then
        for i = 1, #hBot.mybot.sNextAbility do
            local sNextAb = hBot.mybot.sNextAbility[1]
            local hAbility = hBot:GetAbilityByName(sNextAb)
            if hAbility and hAbility:CanAbilityBeUpgraded() then
                hBot:ActionImmediate_LevelAbility(sNextAb)
                table.remove(hBot.mybot.sNextAbility, 1)
                break
            else
                dbg.pause("Trying to level an ability I cannot", hBot.mybot.sNextAbility)
            end
        end
    end
end

function X:Atomic_BuyItems(hBot)
    if #hBot.mybot.sNextItem == 0 then return end
    
    local sComps = {}
    
    for i = 1, #hBot.mybot.sNextItem do
        TableConcat(sComps, InvHelp:GetComponents(item_map[hBot.mybot.sNextItem[i]]))
    end
    
    hBot.mybot.sNextItem = sComps
    for k,v in pairs(sComps) do
        print(k,v)
    end
    
    while #hBot.mybot.sNextItem > 0 do
        local sNextItem = hBot.mybot.sNextItem[1]
    
        if hBot:GetGold() >= GetItemCost(sNextItem) then
            local secret = IsItemPurchasedFromSecretShop(sNextItem)
            local side = IsItemPurchasedFromSideShop(sNextItem)
            local fountain = (not secret)

            local shops = {}
            -- Determine valid shops that sell the item
            if (secret and side) then
                shops = {SHOP_SECRET_RADIANT, SHOP_SECRET_DIRE, SHOP_SIDE_BOT, SHOP_SIDE_TOP}
            elseif (secret) then
                shops = {SHOP_SECRET_RADIANT, SHOP_SECRET_DIRE}
            elseif (side and fountain) then
                shops = {SHOP_SIDE_BOT, SHOP_SIDE_TOP, SHOP_RADIANT, SHOP_DIRE}
            elseif (fountain) then
                shops = {SHOP_RADIANT, SHOP_DIRE}
            end
            
            for i = 1, #shops do
                local shop = shops[i]
                if ShopDistance(hBot, shop) <= SHOP_USE_DISTANCE then
                    local buyRet = InvHelp:BuyItem(hBot, sNextItem)
                    if buyRet == 0 then
                        table.remove(hBot.mybot.sNextItem, 1)
                    end
                    break
                end
            end
        else
            break
        end
    end
end

function X:Atomic_SwapItems(hBot)
    local index1 = nil
    local index2 = nil
    if not InvHelp:IsBackpackEmpty(hBot) then
        local i1 = InvHelp:MostValuableItemSlot(hBot, 6, 8)
        local i2 = InvHelp:LeastValuableItemSlot(hBot, 0, 5)

        if i1.value > i2.value then
            index1 = i1.slot
            index2 = i2.slot
        end
    end

    if index1 and index2 then
        hBot:ActionImmediate_SwapItems(index1, index2)
    end
end

return X