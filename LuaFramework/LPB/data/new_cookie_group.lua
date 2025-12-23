--auto generate by unity editor
local new_cookie_group = {
[1] = {1,{0,1000},1,0},
[2] = {2,{1001,2000},1,0},
[3] = {3,{2001,4000},1,2},
[4] = {4,{4001,8000},1,2},
[5] = {5,{8001,10000},1,2},
[6] = {6,{10001,15000},1,2},
[7] = {7,{15001,20000},1,2},
[8] = {8,{20001,30000},1,3},
[9] = {9,{30001,40000},1,3},
[10] = {10,{40001,50000},1,3},
[11] = {11,{50001,100000},1,3},
[12] = {12,{100001,200000},1,3},
[13] = {13,{200001,1000000},1,3},
[14] = {14,{1000001,99999999999},0,3},
}

local keys = {id = 1,coins_range = 2,level_up = 3,level_down = 4}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_cookie_group) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_cookie_group
