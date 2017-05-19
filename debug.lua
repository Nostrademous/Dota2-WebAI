-------------------------------------------------------------------------------
--- AUTHOR: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

local X = {}

local function Round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function GetUnitName( hUnit )
    local sName = hUnit:GetUnitName()
    return string.sub(sName, 15, string.len(sName));
end

function X.myPrint(...)
    local args = {...}
    
    if #args > 0 then
        local botname = GetUnitName( GetBot() )
        local msg = tostring(Round(GameTime(), 5)).." [" .. botname .. "]: "
        for i,v in ipairs(args) do
            msg = msg .. tostring(v)
        end
        
        --uncomment to only see messages by bots mentioned underneath
        --if botname == "invoker" then --or botname == "viper" then
            print(msg)
        --end
    end
end

function X.pause(...)
    X.myPrint(...)
    DebugPause()
end

return X