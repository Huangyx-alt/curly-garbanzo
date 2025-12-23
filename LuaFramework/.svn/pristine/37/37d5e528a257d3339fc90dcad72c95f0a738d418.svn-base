--auto generate by unity editor
local pu_migrate = {
[1] = {1,{1,2}},
[2] = {2,{1}},
[3] = {3,{1}},
[4] = {4,{1}},
[5] = {5,{1}},
[6] = {6,{1}},
[7] = {7,{1}},
[8] = {8,{1}},
[9] = {9,{1}},
[10] = {10,{1}},
[11] = {11,{1}}
}

local keys = {id = 1,level = 2}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(pu_migrate) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return pu_migrate
