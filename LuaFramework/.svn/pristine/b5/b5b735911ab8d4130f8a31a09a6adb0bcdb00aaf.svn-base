--auto generate by unity editor
local new_jackpot = {
[1] = {1,3,{5},{0}},
[2] = {2,3,{3},{0}},
[3] = {3,3,{4},{0}},
[4] = {4,3,{5},{0}}
}

local keys = {id = 1,type = 2,coordinate = 3,pos = 4}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_jackpot) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_jackpot
