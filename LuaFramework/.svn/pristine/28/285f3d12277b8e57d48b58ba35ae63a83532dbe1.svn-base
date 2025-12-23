--auto generate by unity editor
local new_vip = {
[0] = {0,160,159,0,0,1000,0,0,"VIP0"},
[1] = {1,400,560,100,2,1001,1,1,"VIP1"},
[2] = {2,1840,2400,200,5,1002,2,2,"VIP2"},
[3] = {3,5600,8000,400,10,1003,3,3,"VIP3"},
[4] = {4,32000,40000,600,15,1004,4,4,"VIP4"},
[5] = {5,120000,160000,800,20,1005,5,5,"VIP5"},
[6] = {6,1040000,1200000,1000,25,1006,6,6,"VIP6"},
[7] = {7,6800000,8000000,1200,30,1007,7,7,"VIP7"},
[8] = {8,40000000,48000000,1500,35,1008,8,8,"VIP8"},
[9] = {9,100000000,148000000,1800,40,1009,9,9,"VIP9"},
[10] = {10,9999999999,10147999999,2400,50,1010,10,10,"VIP10"}
}

local keys = {level = 1,exp = 2,sum_exp = 3,shop_added = 4,roulette = 5,daily_gift = 6,weekly_bonus = 7,seasonpass_bonus = 8,icon = 9}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_vip) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_vip
