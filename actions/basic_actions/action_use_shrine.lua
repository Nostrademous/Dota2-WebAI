local UseShrine = {}

UseShrine.Name = "Use Shrine"

-------------------------------------------------
function UseShrine:Call( hUnit, hShrine, iType )    
    if iType == nil or iType == ABILITY_STANDARD then
        hUnit:Action_UseShrine(hShrine)
    elseif iType == ABILITY_PUSH then
        hUnit:ActionPush_UseShrine(hShrine)
    elseif iType == ABILITY_QUEUE then
        hUnit:ActionQueue_UseShrine(hShrine)
    end
end
-------------------------------------------------

return UseShrine