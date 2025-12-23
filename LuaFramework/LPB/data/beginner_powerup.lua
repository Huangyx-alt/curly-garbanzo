--auto generate by unity editor
local beginner_powerup = {
[1] = {1,{101,107,104,101},46,1,0,{0},{{12},{44},{32,44},{11}},{{0}},{{24},{15},{13,55},{44}},{{0}},{{0}},{{0}},{{0}},{{0}}}
}

local keys = {id = 1,cardid = 2,power = 3,level = 4,pay = 5,joker_cardid = 6,card1 = 7,joker_card1 = 8,card2 = 9,joker_card2 = 10,card3 = 11,joker_card3 = 12,card4 = 13,joker_card4 = 14}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(beginner_powerup) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return beginner_powerup
