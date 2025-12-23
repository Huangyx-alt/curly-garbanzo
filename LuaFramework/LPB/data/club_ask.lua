--auto generate by unity editor
local club_ask = {
[1] = {1,1,{2,20000},86400,2,5,{{2,200}},{{4,30},{3,40},{2,20},{1,10}},{60,3600},{1,60;2,20;3,10;4,10},{3600,14400}},
[2] = {2,1,{1,50},86400,2,5,{{1,5}},{{4,30},{3,40},{2,20},{1,10}},{60,3600},{1,60;2,20;3,10;4,10},{3600,14400}},
[3] = {3,1,{9,3},86400,2,5,{{1,5}},{{4,30},{3,40},{2,20},{1,10}},{60,3600},{1,60;2,20;3,10;4,10},{3600,14400}},
[4] = {4,2,{0},86400,1,1,{{0}},{{1,10},{0,90}},{3600,72000},{0,60;1,40},{36000,43200}},
}

local keys = {id = 1,ask_reward_type = 2,ask_reward = 3,ask_cd = 4,help_use = 5,help_number = 6,help_reward = 7,robot_help = 8,robot_help_cd = 9,robot_ask = 10,robot_ask_cd = 11}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(club_ask) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return club_ask
