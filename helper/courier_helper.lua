-------------------------------------------------------------------------------
--- AUTHORS: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

--- IMPORTS
-------------------------------------------------

local actionMoveLoc = require( GetScriptDirectory().."/actions/basic_actions/action_move_to_location" )
local actionMoveUnit = require( GetScriptDirectory().."/actions/basic_actions/action_move_to_unit" )

-------------------------------------------------

local CourierHelper = {}

--- NOTE: This function is probably not necessary as the web-server will make 
--- all the decisions about courier availability and usage
function CourierHelper:GetAvailableCourier()
    local num = GetNumCouriers()
    
    if num < 1 then return nil end
    
    --- NOTE: Couriers are 0-indexed
    for i = 0, num do
        local hCourier = GetCourier(i)
        local courierState = GetCourierState(hCourier)
        
        if courierState == COURIER_STATE_DEAD then
            return nil
        elseif courierState == COURIER_STATE_AT_BASE then
            return hCourier
        end
    end
    
    return nil
end

function CourierHelper:CourierAction( hHero, nCourierIndex, nAction )
    local hCourier = GetCourier(nCourierIndex)
    if hCourier and not GetCourierState(hCourier) == COURIER_STATE_DEAD then
        hHero:ActionImmediate_Courier(hCourier, nAction)
    end
end

function CourierHelper:NumEmpyInventorySlots( nCourierIndex )
    local hCourier = GetCourier(nCourierIndex)
    local nEmptySlots = 0
    for i = 0, 8 do -- 6 inv slots, 3 backpack slots
        local hItem = hCourier:GetItemInSlot(i)
        if hItem == nil then
            nEmptySlots = nEmptySlots + 1
        end
    end
    return nEmptySlots
end

--- THESE LEVERAGE THE ActionImmediate_Courier() API
function CourierHelper:UseSpeedBurst( hHero, nCourierIndex )
    local hCourier = GetCourier(nCourierIndex)
    
    if hCourier.lastBurstTime == nil then hCourier.lastBurstTime = -1000.0 end
    
    if hCourier and IsFlyingCourier(hCourier) and GameTime() > (hCourier.lastBurstTime + 90.0) then
        self:CourierAction(hHero, nCourierIndex, COURIER_ACTION_BURST)
        hCourier.lastBurstTime = GameTime()
    end
end

function CourierHelper:ReturnToBase( hHero, nCourierIndex )
    self:CourierAction(hHero, nCourierIndex, COURIER_ACTION_RETURN)
end

function CourierHelper:TransferItems( hHero, nCourierIndex )
    self:CourierAction(hHero, nCourierIndex, COURIER_ACTION_TRANSFER_ITEMS)
end

function CourierHelper:TakeStashItems( hHero, nCourierIndex )
    self:CourierAction(hHero, nCourierIndex, COURIER_ACTION_TAKE_STASH_ITEMS)
end

function CourierHelper:TakeAndTransferItems( hHero, nCourierIndex )
    self:CourierAction(hHero, nCourierIndex, COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS)
end 

--- NOTE: TODO - test that doing a unit-scoped:Action*_Move*() works on courier units
function CourierHelper:MoveCourierToLoc( nCourierIndex, vLoc, iType )
    local hCourier = GetCourier(nCourierIndex)
    if hCourier and not GetCourierState(hCourier) == COURIER_STATE_DEAD then
        actionMoveLoc:Call(hCourier, vLoc, iType)
    end
end

function CourierHelper:MoveCourierToUnit( nCourierIndex, hUnit, iType )
    local hCourier = GetCourier(nCourierIndex)
    if hCourier and not GetCourierState(hCourier) == COURIER_STATE_DEAD then
        actionMoveUnit:Call(hCourier, hUnit, iType)
    end
end

function CourierHelper:MoveToTopSecretShop( nCourierIndex, iType )
    self:MoveCourierToLoc(nCourierIndex, GetShopLocation(TEAM_NONE, SHOP_SECRET), iType)
end

function CourierHelper:MoveToTopSideShop( nCourierIndex, iType )
    self:MoveCourierToLoc(nCourierIndex, GetShopLocation(TEAM_NONE, SHOP_SIDE), iType)
end

function CourierHelper:MoveToBotSecretShop( nCourierIndex, iType )
    self:MoveCourierToLoc(nCourierIndex, GetShopLocation(TEAM_NONE, SHOP_SECRET_2), iType)
end

function CourierHelper:MoveToBotSideShop( nCourierIndex, iType )
    self:MoveCourierToLoc(nCourierIndex, GetShopLocation(TEAM_NONE, SHOP_SIDE_2), iType)
end

function CourierHelper:DeathCallback( hTable )
    dbg.myPrint("Courier killed: ", hTable.unit, ", Team: ", hTable.team)
    dbg.pause("Courier DeathCallback Called")
end

InstallCourierDeathCallback( CourierHelper:DeathCallback )

return CourierHelper