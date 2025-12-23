--auto generate by unity editor
local piggy_bank_user = {
[1] = {1,0,1},
[2] = {2,1,2},
[3] = {3,2,3},
[4] = {4,3,4}
}

local keys = {id = 1,user_type = 2,level = 3}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(piggy_bank_user) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return piggy_bank_user
