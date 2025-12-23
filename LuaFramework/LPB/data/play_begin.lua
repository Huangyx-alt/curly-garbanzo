--auto generate by unity editor
local play_begin = {
[1] = {1,1,{33}},
[2] = {2,2,{33}},
[3] = {3,3,{33}},
[4] = {4,4,{33}},
[5] = {5,8,{22,24,42,44}},
[6] = {6,9,{11,15,51,55}},
[7] = {7,10,{33}},
[8] = {8,11,{33}},
[11] = {11,14,{33}},
[12] = {12,15,{33}},
[14] = {14,20,{33}},
[15] = {15,22,{33}},
[16] = {16,23,{33}},
[17] = {17,24,{22,24,42,44}},
[18] = {18,25,{33}},
[19] = {19,29,{33}},
[20] = {20,30,{33}}
}

local keys = {id = 1,city_play_id = 2,begin_marked_pos = 3}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(play_begin) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return play_begin
