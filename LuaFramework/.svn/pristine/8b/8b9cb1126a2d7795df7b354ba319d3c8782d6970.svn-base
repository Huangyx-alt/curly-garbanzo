--auto generate by unity editor
local beginner_card = {
[1] = {1,{{5,8,3,15,7},{25,27,24,20,19},{31,36,99,40,33},{57,47,53,54,58},{63,66,64,70,71}},{0},{{7,1,15,9,6},{24,23,28,26,18},{32,36,99,40,38},{55,56,52,58,53},{65,72,63,68,66}},{11,12,13,21,22,23,24,31,33,35,44,45,51,53,54,55},{{0}},{0},{{0}},{0},{{51,815}},{{24,815}},{{0}},{{0}},0}
}

local keys = {id = 1,card1 = 2,card1_daub = 3,card2 = 4,card2_daub = 5,card3 = 6,card3_daub = 7,card4 = 8,card4_daub = 9,item1 = 10,item2 = 11,item3 = 12,item4 = 13,jackpot_card = 14}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(beginner_card) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return beginner_card
