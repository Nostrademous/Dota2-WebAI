local DropItem = {}

DropItem.Name = "Drop Item"

-------------------------------------------------
function DropItem:Call( hUnit, hItem, vLoc, iType )    
    if iType == nil or iType == ABILITY_STANDARD then
        hUnit:Action_DropItem(hItem, vLoc)
    elseif iType == ABILITY_PUSH then
        hUnit:ActionPush_DropItem(hItem, vLoc)
    elseif iType == ABILITY_QUEUE then
        hUnit:ActionQueue_DropItem(hItem, vLoc)
    end
end
-------------------------------------------------

return DropItem