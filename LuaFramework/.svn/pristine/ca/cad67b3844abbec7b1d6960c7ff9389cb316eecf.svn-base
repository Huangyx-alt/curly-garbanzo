--auto generate by unity editor
local shop_repay = {
[1] = {1,0,10,{{2,30000}}},
[2] = {2,10,20,{{2,60000}}},
[3] = {3,20,50,{{2,90000}}},
[4] = {4,50,100,{{2,120000}}},
[5] = {5,100,200,{{2,150000}}},
[6] = {6,200,500,{{2,200000}}}
}

local keys = {id = 1,price_range = 2,reward = 3}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(shop_repay) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return shop_repay
