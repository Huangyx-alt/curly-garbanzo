--auto generate by unity editor
local bingo_pay_up = {
[1] = {1,1,0;2,0;4,0;8,0;12,0,1,0;2,0;4,0;8,0;12,0,1,0;2,0;4,0;8,0;12,0}
}

local keys = {id = 1,power1 = 2,power2 = 3,power3 = 4}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(bingo_pay_up) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return bingo_pay_up
