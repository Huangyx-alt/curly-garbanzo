--auto generate by unity editor
local user_hierarchy = {
[1] = {1,1,"9.99",{50,100000},{0},1,10,100,"pay_1_low",1,100},
[2] = {2,1,"24.99",{101,200000},{0},1,20,100,"pay_2_middle",2,200},
[3] = {3,1,"49.99",{201,300000},{0},1,40,100,"pay_3_high",3,300},
[4] = {4,1,"79.99",{301,400000},{0},1,60,100,"pay_4_max",4,400},
[5] = {5,1,"99.99",{401,9999999},{0},1,80,100,"pay_5_super",5,500},
[6] = {6,1,"199.99",{1000,9999999},{0},1,100,100,"pay_6_ultra",6,600}
}

local keys = {id = 1,user_type = 2,pay = 3,total_pay = 4,user_level = 5,history_bet = 6,folder = 7,power = 8,play_frequency = 9}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(user_hierarchy) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return user_hierarchy
