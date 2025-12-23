--auto generate by unity editor
local new_game_effect_cache = {
[1] = {1,1000,1000,2,0,2,},
[2] = {2,1000,2500,2,0,2,},
[3] = {3,1000,2500,2,0,2,},
[4] = {4,1000,2500,2,0,2,}
}

local keys = {id = 1,bingo_effect_min_alive_time = 2,jackpot_effect_min_alive_time = 3,settle_ignore_effect_type = 4,bingo_sibling = 5,bingo_coin_sibling = 6,}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_game_effect_cache) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_game_effect_cache
