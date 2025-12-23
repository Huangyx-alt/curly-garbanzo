--auto generate by unity editor
local new_city_play_feature = {
[1] = {1,2,{1,10},2,0,30,0,2,1,"piggybankpopinmain","PiggyBankIcon","PiggyBankPop","PiggyBankposter","PiggyBankFeatureAtlas","PiggyBank",},
[2] = {2,3,{2,30},2,0,0,0,3,1,"drinkingpopinmain","DrinkingFrenzyIcon","DrinkingFrenzyPop","DrinkingFrenzyposter","DrinkingFrenzyFeatureAtlas","DrinkingFrenzy",},
[3] = {3,4,{3,40},2,0,0,0,4,1,"piratepopinmain","PirateShipIcon","PirateShipPop","PirateShipposter","0","PirateShip",}
}

local keys = {id = 1,city_play = 2,featured_group = 3,featured_type = 4,featured_entrance = 5,featured_banner = 6,featured_pop = 7,modular_id = 8,modular_type = 9,pop_sound = 10,modular_icon = 11,modular_pop = 12,modular_poster = 13,modular_atlas = 14,modular_name = 15,}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_city_play_feature) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_city_play_feature
