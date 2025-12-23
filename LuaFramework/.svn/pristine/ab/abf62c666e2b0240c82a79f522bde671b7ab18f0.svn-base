--auto generate by unity editor
local competition_start = {
[1] = {1,"BsCookieTtb",0,"CompetitionCookieAtlas"},
[2] = {2,"BsCookieTtb",0,"CompetitionCookieAtlas"},
[3] = {3,"BsCookieTtb",0,"CompetitionCookieAtlas"}
}

local keys = {id = 1,icon = 2,cd = 3,atlas = 4}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(competition_start) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return competition_start
