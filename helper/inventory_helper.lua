-------------------------------------------------------------------------------
--- AUTHORS: iSarCasm, Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

--- IMPORTS
-------------------------------------------------

local UnitHelper = require( GetScriptDirectory().."/helper/unit_helper" )

-------------------------------------------------

local InventoryHelper = {}

function InventoryHelper:HasItem(hUnit, sItemName, hasToBeActiveSlot)
    local slots = (hasToBeActiveSlot and 5 or 8)
    for i = 0, slots do
        local slot = hUnit:GetItemInSlot(i)
        if (slot and slot:GetName() == sItemName) then
            return true
        end
    end
    return false
end

function InventoryHelper:GetItemByName(hUnit, sItemName, hasToBeActiveSlot)
    local slots = (hasToBeActiveSlot and 5 or 8)
    for i = 0, slots do
        local slot = hUnit:GetItemInSlot(i)
        if (slot and slot:GetName() == sItemName) then
            return slot
        end
    end
    return nil
end

function InventoryHelper:WorthOfItemsCanBeBought(build)
    local gold = GetBot():GetGold()
    local goldLeft = gold
    local worth = 0
    for i = 1, #build do
        local cost = GetItemCost(build[i])
        if (goldLeft >= cost) then
            goldLeft = goldLeft - cost
            worth = worth + cost
        else
            return worth
        end
    end
    return 0
end

function InventoryHelper:HasSpareSlot(hUnit, hasToBeActiveSlot)
    local slots = (hasToBeActiveSlot and 5 or 8)
    for i = 0, slots do
        local slot = hUnit:GetItemInSlot(i)
        if (not slot) then
            return true
        end
    end
    return false
end

function InventoryHelper:IsBackpackEmpty(hUnit)
    for i = 6, 8 do
        local slot = hUnit:GetItemInSlot(i)
        if (slot) then
            return false
        end
    end
    return true
end

function InventoryHelper:MostValuableItemSlot(hUnit, slot_from, slot_to)
    local most_value = VERY_LOW_INT
    local most = nil
    for i = slot_from, slot_to do
        local item = hUnit:GetItemInSlot(i)
        if (item and self:Value(item:GetName()) > most_value) then
            most_value = self:Value(item:GetName())
            most = i
        end
    end
    local hash = {}
    hash.slot = most
    hash.value = most_value
    return hash
end

function InventoryHelper:LeastValuableItemSlot(hUnit, slot_from, slot_to)
    local least_value = VERY_HIGH_INT
    local least = nil
    for i = slot_from, slot_to do
        local item = hUnit:GetItemInSlot(i)
        if (item) then
            if (self:Value(item:GetName()) < least_value) then
                least_value = self:Value(item:GetName())
                least = i
            end
        else
            least_value = 0
            least = i
            break
        end
    end
    local hash = {}
    hash.slot = least
    hash.value = least_value
    return hash
end

function InventoryHelper:Value(sItemName)
    --- NOTE: Blink Dagger - we "almost always" won't in main inventory
    if sItemName == "item_blink" then return 5000 end

    return GetItemCost(sItemName)
end

function InventoryHelper:BuyItem( hUnit, sItemName )
    local buyResult = hUnit:ActionImmediate_PurchaseItem(sItemName)
    if buyResult ~= PURCHASE_ITEM_SUCCESS then
        local sError = GetTableKeyNameFromID(tableItemPurchaseResults, buyResult)
        if sError == nil then sError = buyResult end
        
        dbg.pause("[ITEM PURCHASE ERROR] Hero: ", hUnit:GetUnitName(), ", Item: ", sItemName, ", Result: ", sError)
        return 1
    end
    return 0
end

--- NOTE: This will only sell items we have in main inventory or backpack
---       If we need ability to sell items in stash we will need to revise this function
function InventoryHelper:SellItem( hUnit, sItemName )
    if UnitHelper:DistanceFromNearestShop(hUnit) < SHOP_USE_DISTANCE then
        if self:HasItem(hUnit, sItemName, false) then
            hUnit:ActionImmediate_SellItem(sItemName)
        else
            dbg.pause("[ITEM SELL ERROR] Hero: ", hUnit:GetUnitName(), ", Item: ", sItemName)
        end
    end
end

function InventoryHelper:GetComponents( sItemName )
    local variants = GetItemComponents(sItemName)
    
    -- first container is number of ways to build the items (e.g., Power Treads has 3)
    local comps = {}
    if #variants == 0 then
        table.insert(comps, sItemName)
    elseif #variants == 1 then
        comps = variants[1]
    else
        dbg.pause("[ITEM BREAKDOWN INTO COMPONENTS ERROR]: WE DO NOT HANDLE VARIANT BUILDUPS YET. ", #variants)
        comps = variants[1]
    end
    
    local finalComps = {}
    self:FlattenComponents(finalComps, comps)    
    return finalComps
end

function InventoryHelper:FlattenComponents(output, input)
    local input_map  -- has the same structure as input, but stores the
                     -- indices to the corresponding output
  
    --print("Input Size: ", #input)
    for indx = 1, #input do
        --print("Input: ", input[indx])
        local components = GetItemComponents(input[indx])
        if #components > 0 then
            --print("Recursive...")
            for i = 1, #components do
                input_map = {}
                -- forward DFS order
                input_map[#input_map+1] = self:FlattenComponents(output, components[i])
            end
        else
            --print("Non-Recursive...")
            input_map = #output + 1
            output[input_map] = input[indx]
        end
    end
    return input_map
end

function InventoryHelper:HealthConsumables( hHero )
    local health = 0
    for i = 0, 5 do
        local item = hHero:GetItemInSlot(i)
        if (item) then
            if (item:GetName() == "item_tango") then
                health = health + 115 * item:GetCurrentCharges()
            elseif(item:GetName() == "item_flask") then
                health = health + 400 * item:GetCurrentCharges()
            elseif(item:GetName() == "item_faerie_fire") then
                health = health + 75
            elseif(item:GetName() == "item_bottle") then
                health = health + 90 * item:GetCurrentCharges()
            end
        end
    end
    return health
end

return InventoryHelper
