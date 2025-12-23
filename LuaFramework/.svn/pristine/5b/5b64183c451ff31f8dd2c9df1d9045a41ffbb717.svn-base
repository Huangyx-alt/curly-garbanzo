--auto generate by unity editor
local piggy_bank_activity = {
[1] = {1,1,200,"0","0",604800},
[2] = {2,2,2,"2023/1/4 0:00:00","2023/2/4 0:00:00",0},
[3] = {3,2,3,"2023/2/6 0:00:00","2023/3/6 0:00:00",0}
}

local keys = {id = 1,type = 2,value = 3,open_date = 4,close_date = 5,continue = 6}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(piggy_bank_activity) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return piggy_bank_activity
