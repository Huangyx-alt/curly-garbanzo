--auto generate by unity editor
local level_coefficient = {
[1] = {1,{0,100},{1},0,{100,100,100,100,100,100,100,100,100,100}}
}

local keys = {id = 1,level = 2,cityplay_id = 3,ultrabet_valve = 4,coefficient = 5}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(level_coefficient) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return level_coefficient
