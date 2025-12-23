--auto generate by unity editor
local victorybeats_putin = {
[1] = {1,{5000,9999},2010,1},
[2] = {2,{10000,14999},2010,2},
[3] = {3,{15000,19999},2010,3},
[4] = {4,{20000,24999},2010,4},
[5] = {5,{25000,49999},2010,5},
[6] = {6,{50000,99999},2010,10},
[7] = {7,{100000,149999},2011,10},
[8] = {8,{150000,199999},2011,15},
[9] = {9,{200000,249999},2012,13},
[10] = {10,{250000,374999},2012,16},
[11] = {11,{375000,499999},2014,15},
[12] = {12,{500000,749999},2014,20},
[13] = {13,{750000,999999},2015,15},
[14] = {14,{1000000,999999999},2015,20}
}

local keys = {id = 1,coin_range = 2,prop_type = 3,number = 4}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(victorybeats_putin) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return victorybeats_putin
