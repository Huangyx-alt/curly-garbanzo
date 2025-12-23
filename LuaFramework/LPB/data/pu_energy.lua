--auto generate by unity editor
local pu_energy = {
[1] = {{1},{110},{120},{150},{0},{0}},
[2] = {{2},{110},{120},{150},{0},{0}},
[3] = {{3},{110},{120},{150},{0},{0}},
[4] = {{4},{0},{0},{120},{130},{140}},
[5] = {{5},{110},{130},{150},{0},{0}},
[6] = {{6},{110},{130},{150},{0},{0}},
[7] = {{7},{110},{130},{150},{0},{0}},
[8] = {{8},{110},{130},{150},{0},{0}},
[9] = {{9},{110},{130},{150},{0},{0}}
}

local keys = {play_id = 1,card1 = 2,card2 = 3,card4 = 4,card6 = 5,card8 = 6}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(pu_energy) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return pu_energy
