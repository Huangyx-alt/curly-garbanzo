--auto generate by unity editor
local new_shop_gift = {
[1000] = {1000,{{1100}},1200},
[1001] = {1001,{{1100}},1200},
[1002] = {1002,{{1100}},1200},
[1003] = {1003,{{1100}},1200},
[1004] = {1004,{{1100}},1200},
[1005] = {1005,{{1100}},1200},
[1006] = {1006,{{1100}},1200},
[1007] = {1007,{{1100}},1200},
[1008] = {1008,{{1100}},1200},
[1009] = {1009,{{1100}},1200},
[1010] = {1010,{{1100}},1200}
}

local keys = {id = 1,reward = 2,gift_cd = 3}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_shop_gift) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_shop_gift
