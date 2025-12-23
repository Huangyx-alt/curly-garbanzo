--auto generate by unity editor
local new_pigbank_start = {
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
[16] = {},
[17] = {},
[18] = {},
[19] = {},
[20] = {},
[21] = {},
[22] = {},
[23] = {},
[24] = {},
[25] = {},
[26] = {},
[27] = {},
[28] = {},
[29] = {},
[30] = {},
[31] = {},
[32] = {}
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
        for _, t in pairs(new_pigbank_start) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_pigbank_start
