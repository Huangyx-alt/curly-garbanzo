--auto generate by unity editor
local reward_sky = {
[1] = {1,1,0,{0,1,2,3},{9,999},{{1,200},{2,8000},{6007,2}},{"cGems02","cIconCoins02","tTJQY2and4Cards5off"},{6007,2},90,1,2,3},
[2] = {2,1,0,{0,1,2,3},{2},{{1,200},{2,8000},{6006,3}},{"cGems02","cIconCoins02","tTJQYPowerupCards5off2"},{6006,3},94,0,3,3},
[3] = {3,1,0,{0,1,2,3},{3,2},{{1,200},{2,8000},{6005,3}},{"cGems02","cIconCoins02","tTJQYPowerupCardsFree2"},{6005,3},95,0,3,3},
[6] = {6,1,0,{1,2,3},{6,2},{{1,200},{2,8000},{6006,3}},{"cGems02","cIconCoins02","tTJQYPowerupCards5off2"},{6006,3},92,0,3,3},
[7] = {7,2,1,{0,1,2,3},{0},{{1,200},{2,8000},{6005,6}},{"cGems02","cIconCoins02","tTJQYPowerupCardsFree2"},{6005,6},100,0,3,1},
[8] = {8,2,2,{0,1,2,3},{0},{{1,200},{6005,5},{2,8000}},{"cGems02","tTJQYPowerupCardsFree2","cIconCoins02"},{6005,5},99,1,5,1},
[9] = {9,2,3,{0,1,2,3},{0},{{6005,4},{1,200},{2,8000}},{"tTJQYPowerupCardsFree2","cGems02","cIconCoins02"},{6005,4},98,1,4,1},
[10] = {10,2,4,{0,1,2,3},{0},{{1,200},{2,8000},{6005,3}},{"cGems02","cIconCoins02","tTJQYPowerupCardsFree2"},{6005,3},97,0,3,1},
[11] = {11,2,5,{0,1,2,3},{0},{{6005,3},{1,200},{2,8000}},{"tTJQYPowerupCardsFree2","cGems02","cIconCoins02"},{6005,3},96,0,3,1},
[12] = {12,1,0,{0,1,2,3},{9,999},{{1,200},{2,8000},{6009,3}},{"cGems02","cIconCoins02","tTJQYAutoCards5off"},{6009,3},93,2,3,3},
[13] = {13,1,0,{0,1,2,3},{9,999},{{1,200},{2,8000},{6011,3}},{"cGems02","cIconCoins02","tTJQYjackpotUp"},{6011,3},50,0,10,3}
}

local keys = {id = 1,type = 2,total = 3,user_type = 4,trigger = 5,reward_exhibit = 6,reward_icon = 7,reward = 8,power = 9,application = 10,quantity = 11,daily_max_times = 12}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(reward_sky) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return reward_sky
