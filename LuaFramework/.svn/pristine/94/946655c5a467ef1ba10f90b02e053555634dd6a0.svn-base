--auto generate by unity editor
local reward_signin_progress = {
[1] = {1,7,{{2,50},{1,20},{910804,5}},{"cIconCoins04","cIconGems03","powerupCards03"},{{"180","110"},{"100","90"},{"100","90"}}},
[2] = {2,14,{{2,100},{1,40},{910804,10}},{"cIconCoins04","cIconGems03","powerupCards03"},{{"180","110"},{"100","90"},{"100","90"}}},
[3] = {3,28,{{2,200},{1,80},{910804,20}},{"cIconCoins04","cIconGems03","powerupCards03"},{{"180","110"},{"100","90"},{"100","90"}}}
}

local keys = {id = 1,progress_times = 2,progress_reward = 3,icon = 4,size = 5}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(reward_signin_progress) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return reward_signin_progress
