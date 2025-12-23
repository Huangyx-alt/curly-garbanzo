--auto generate by unity editor
local new_city_play_putin = {
[1] = {1,"Puzzle",601,1,1},
[2] = {2,"SeasonPass",603,2,5},
[3] = {3,"SeasonCard",604,2,4},
[4] = {4,"PowerUpChest",806,2,1},
[5] = {5,"WeeklyList",602,2,3},
[6] = {6,"Cookie",606,2,2}
}

local keys = {id = 1,putin_type = 2,putin_id = 3,display = 4,priority = 5}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_city_play_putin) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_city_play_putin
