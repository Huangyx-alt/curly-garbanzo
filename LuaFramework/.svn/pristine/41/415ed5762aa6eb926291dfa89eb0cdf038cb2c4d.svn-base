--auto generate by unity editor
local weeklist_bi_level = {
[1] = {1,1,{"0"},1,1},
[2] = {2,1,{"LPB99903845"},1,1},
[3] = {3,1,{"LPB99903847"},2,1},
[4] = {4,1,{"LPB99903848"},3,2},
[5] = {5,1,{"LPB99903849"},4,3},
[6] = {6,2,{"0"},1,1},
[7] = {7,2,{"LPB99903845"},1,1},
[8] = {8,2,{"LPB99903847"},2,1},
[9] = {9,2,{"LPB99903848"},3,2},
[10] = {10,2,{"LPB99903849"},4,3}
}

local keys = {id = 1,game_type = 2,bi_id = 3,start_level = 4,end_level = 5}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(weeklist_bi_level) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return weeklist_bi_level
