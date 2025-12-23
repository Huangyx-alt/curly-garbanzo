--auto generate by unity editor
local user_label = {
[0] = {0,0,{0},{1,2},0},
[1] = {1,0,{0,0.5},{1,2},1},
[2] = {2,0,{0.5,4.98},{2},2},
[3] = {3,0,{4.98},{0},3}
}

local keys = {id = 1,days = 2,pay = 3,advertise = 4,pay_label = 5}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(user_label) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return user_label
