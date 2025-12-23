--auto generate by unity editor
local pigbank_group = {
[1] = {1,},
[2] = {2,},
[3] = {3,},
[4] = {4,},
[5] = {5,},
[6] = {6,},
[7] = {7,},
[8] = {8,},
[9] = {9,},
[10] = {10,},
[11] = {11,},
[12] = {12,},
[13] = {13,},
[14] = {14,},
[15] = {15,},
[16] = {16,}
}

local keys = {id = 1,}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(pigbank_group) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return pigbank_group
