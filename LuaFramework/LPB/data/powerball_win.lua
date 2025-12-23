--auto generate by unity editor
local powerball_win = {
[1] = {1,1,10,6},
[2] = {2,1,3,8},
[3] = {3,1,1,9}
}

local keys = {id = 1,bet = 2,win = 3}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(powerball_win) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return powerball_win
