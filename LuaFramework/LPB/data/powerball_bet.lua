--auto generate by unity editor
local powerball_bet = {
[1] = {1,{1,50},{1,2,3,5,6,8,10,15}},
[2] = {2,{51,100},{1,2,3,5,6,10,15,20}},
[3] = {3,{101,200},{2,3,5,8,10,20,40,50}},
[4] = {4,{201,500},{2,5,8,10,20,40,60,80}},
[5] = {5,{501,9999999999999},{3,5,8,10,30,60,80,100}}
}

local keys = {id = 1,powerball = 2,bet = 3}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(powerball_bet) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return powerball_bet
