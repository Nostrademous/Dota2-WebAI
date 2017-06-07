local PickUpRune = {}

PickUpRune.Name = "Pick Up Rune"

-------------------------------------------------
function PickUpRune:Call( hUnit, iRune, iType )    
    if iType == nil or iType == ABILITY_STANDARD then
        hUnit:Action_PickUpRune(iRune)
    elseif iType == ABILITY_PUSH then
        hUnit:ActionPush_PickUpRune(iRune)
    elseif iType == ABILITY_QUEUE then
        hUnit:ActionQueue_PickUpRune(iRune)
    end
end
-------------------------------------------------

return PickUpRune