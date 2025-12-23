--auto generate by unity editor
local new_game_cell = {
[1] = {1,0,"b_tips_red","b_tips_yellow","b_tips_green","b_tips_blue","b_tips_purple","BingoAtlas",{{-44,35},{-8.5,35},{5,-24},{40.5,-24}},{{0.9,0.9},{0.9,0.9},{0,0},{0,0}},0,"0","0",{0}},
[2] = {2,1,"candyipsRed","0","0","0","0","PiggyBankBingoAtlas",{{-39.6,26.1},{-4.8,26.1},{5,-27.5},{40.5,-27.5}},{{0.8,0.8},{0.8,0.8},{0.8,0.8},{0.8,0.8}},1,"PiggyBankbcardJoke","0",{0}},
[3] = {3,1,"BeerZdTips","0","0","0","0","DrinkingFrenzyBingoAtlas",{{-39.6,26.1},{-4.8,26.1},{5,-27.5},{40.5,-27.5}},{{0.8,0.8},{0.8,0.8},{0.8,0.8},{0.8,0.8}},1,"BeercardJoke","0",{0}},
[4] = {4,1,"PirateipsRed","0","0","0","0","PirateShipBingoAtlas",{{-39.6,26.1},{-4.8,26.1},{5,-27.5},{40.5,-27.5}},{{0.8,0.8},{0.8,0.8},{0.8,0.8},{0.8,0.8}},1,"PiratebcardJoke","0",{0}}
}

local keys = {id = 1,type = 2,b_tip = 3,i_tip = 4,n_tip = 5,g_tip = 6,o_tip = 7,atlas_name = 8,double_num_pos = 9,double_num_scale = 10,hide_bg = 11,joker_bg_un_signed = 12,joker_bg_signed = 13,joker_bg_offet_signed = 14}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_game_cell) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_game_cell
