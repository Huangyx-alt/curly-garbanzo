--auto generate by unity editor
local new_city_play = {
[1] = {1,1001,"Maingame",1,1,0,"MiniGamePuzzleView",{2,0.002},{{1,2}},{{0,2},{15,5}},0,{100400},1,{{1,815,1}},{33},5000,{28,32},{{18,10},{19,10},{20,12},{21,12},{22,14},{23,15},{24,14},{25,12},{26,12},{27,10},{28,10}},{{0}},12,{6,2,1},"lasvegas","SceneGame","0",{"Play1Package","Play1Package","bcard01","bcard01s"},4000},
[2] = {2,6002,"PiggyBank",2,2,0,"MiniGamePiggySlotsView",{1,0.002},{{3}},{{0}},0,{100400},2,{{1,815,1},{2,821,1}},{0},5000,{28,32},{{18,13},{19,14},{20,15},{21,16},{22,15},{23,14},{24,13}},{{0}},12,{2,1,1},"piggybank","ScenePiggyBank","0",{"0"},4000},
[3] = {3,6003,"DrinkingFrenzy",3,2,0,"MiniGamePiggySlotsView",{1,0.002},{{4}},{{0}},0,{100400},3,{{1,815,1}},{0},5000,{28,32},{{18,13},{19,14},{20,15},{21,16},{22,15},{23,14},{24,13}},{{0}},12,{2,1,1},"drinkingfrenzy","SceneDringkingFrenzy","0",{"0"},4000},
[4] = {4,6004,"PirateShip",4,2,0,"MiniGamePiggySlotsView",{1,0.002},{{5,6}},{{0}},0,{100400},4,{{1,815,1}},{33},5000,{28,32},{{18,13},{19,14},{20,15},{21,16},{22,15},{23,14},{24,13}},{{0}},12,{2,1,1},"pirate","ScenePirateShip","0",{"0"},4000}
}

local keys = {id = 1,modular_id = 2,name = 3,play_type = 4,bet_group = 5,operate = 6,function_btn = 7,callreward = 8,bingo_rule_id = 9,bingo_unlock = 10,jackpot_reward_new = 11,jackpot = 12,jackpot_rule_id = 13,bet_bonus = 14,begin_marked_pos = 15,callcd = 16,bingosleft = 17,callnumber = 18,powerup_cd = 19,countdown = 20,bingo_beginner = 21,music = 22,scenes_name = 23,scene_resources = 24,card_resources = 25,hint_delay = 26}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_city_play) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_city_play
