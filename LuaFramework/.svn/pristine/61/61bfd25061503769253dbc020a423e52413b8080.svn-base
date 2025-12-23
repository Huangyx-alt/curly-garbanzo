--auto generate by unity editor
local card_expect = {
[1] = {1,1,1,{{0,0},{1,100}},},
[2] = {2,1,2,{{0,20},{1,50},{2},{30}},},
[3] = {3,1,4,{{0,0},{1,50},{2},{30},{3,20},{4,10}},},
[4] = {4,2,1,{{0,0},{1,100}},},
[5] = {5,2,2,{{0,20},{1,50},{2},{30}},},
[6] = {6,2,4,{{0,0},{1,50},{2},{30},{3,20},{4,10}},},
[7] = {7,3,1,{{0,0},{1,100}},},
[8] = {8,3,2,{{0,20},{1,50},{2},{30}},},
[9] = {9,3,4,{{0,0},{1,50},{2},{30},{3,20},{4,10}},}
}

local keys = {id = 1,city_id = 2,card_num = 3,expect_num = 4,}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(card_expect) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return card_expect
