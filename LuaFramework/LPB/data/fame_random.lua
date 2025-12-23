--auto generate by unity editor
local fame_random = {
[1] = {},
[2] = {},
[3] = {},
[4] = {},
[5] = {},
[6] = {},
[7] = {},
[8] = {},
[9] = {},
[10] = {},
[11] = {},
[12] = {},
}

local keys = {}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(fame_random) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return fame_random
