--auto generate by unity editor
local admission_pay = {
[1] = {1,2,2,},
[2] = {2,2,2,},
[3] = {3,7,2,}
}

local keys = {id = 1,resources_id = 2,reward_id = 3,}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(admission_pay) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return admission_pay
