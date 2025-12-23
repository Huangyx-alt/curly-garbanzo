--auto generate by unity editor
local new_game_settle = {
[1] = {1,0,{1,1},{1,1},{0,0},{0.6,0.6},0.3,1,{0,0},{1,1}},
[2] = {2,1,{0.92,0.92},{0.21,0.21},{0,0},{0.6,0.6},0.3,2,{-2.25,-3.5},{1,1}},
[3] = {3,1,{0.92,0.92},{0.21,0.21},{0,0},{0.6,0.6},0.3,2,{-2.25,-3.5},{1,1}},
[4] = {4,1,{1.03,0.92},{0.21,0.21},{0,0},{0.6,0.6},0.3,2,{-7.25,-8.5},{1,1}}
}

local keys = {id = 1,settle_card_summary = 2,climb_rank_card_size = 3,detail_card_jackpot_scale = 4,detail_card_jackpot_offset = 5,rocket_card_size = 6,rocket_card_fly_time = 7,transition_check_effect = 8,climb_card_bg_offset = 9,detail_summary_card_size = 10}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_game_settle) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_game_settle
