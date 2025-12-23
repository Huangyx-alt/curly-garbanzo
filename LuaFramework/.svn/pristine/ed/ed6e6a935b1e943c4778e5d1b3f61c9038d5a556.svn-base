--auto generate by unity editor
local new_powerup_replace = {
[1] = {1,2,106,110,},
[2] = {2,2,108,104,},
[3] = {3,3,106,112,},
[4] = {4,3,108,104,},
[5] = {5,4,106,114,},
[6] = {6,4,108,104,}
}

local keys = {id = 1,play_id = 2,powerup_id = 3,powerup_replace_id = 4,}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_powerup_replace) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_powerup_replace
