--auto generate by unity editor
local victorybeats_revival = {
[1] = {1,1,5,4.99,54,60,"fuhuo1",},
[2] = {2,2,10,9.99,56,60,"fuhuo2",},
[3] = {3,3,15,14.99,58,60,"fuhuo3",}
}

local keys = {id = 1,revival_times = 2,revivalcoin_num = 3,price = 4,product_difference = 5,revival_time = 6,cehuakan = 7,}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(victorybeats_revival) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return victorybeats_revival
