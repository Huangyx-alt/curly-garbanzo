--auto generate by unity editor
local powerball_reward = {
[1] = {1,0,1,{{2,5000}}},
[2] = {2,1,1,{{2,10000}}},
[3] = {3,2,1,{{2,20000}}},
[4] = {4,3,0,{{2,20000}}},
[5] = {5,3,1,{{1,100},{2,20000}}},
[6] = {6,4,0,{{1,100},{2,20000}}},
[7] = {7,4,1,{{1,1000},{2,100000}}},
[8] = {8,5,0,{{1,1500},{2,200000},{9,20}}},
[9] = {9,5,1,{{1,5000},{2,1000000},{9,100}}}
}

local keys = {id = 1,white = 2,red = 3,reward = 4}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(powerball_reward) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return powerball_reward
