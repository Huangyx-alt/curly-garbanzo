--auto generate by unity editor
local powerup_joker_item = {
[1] = {1,{7001,7001},10},
[2] = {2,{7001,7002},10},
[3] = {3,{7001,7003},10},
[4] = {4,{7002,7002},10},
[5] = {5,{7002,7003},10},
[6] = {6,{7003,7003},10}
}

local keys = {id = 1,item = 2,probability = 3}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(powerup_joker_item) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return powerup_joker_item
