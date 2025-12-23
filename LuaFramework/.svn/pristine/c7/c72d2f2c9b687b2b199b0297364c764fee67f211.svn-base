--auto generate by unity editor
local user_return = {
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
[13] = {},
[14] = {},
[15] = {},
[16] = {}
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
        for _, t in pairs(user_return) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return user_return
