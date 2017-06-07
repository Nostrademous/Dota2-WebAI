local PickUpItem = {}

PickUpItem.Name = "Pick Up Item"

-------------------------------------------------
function PickUpItem:Call( hUnit, hItem, iType )    
    if iType == nil or iType == ABILITY_STANDARD then
        hUnit:Action_PickUpItem(hItem)
    elseif iType == ABILITY_PUSH then
        hUnit:ActionPush_PickUpItem(hItem)
    elseif iType == ABILITY_QUEUE then
        hUnit:ActionQueue_PickUpItem(hItem)
    end
end
-------------------------------------------------

return PickUpItem