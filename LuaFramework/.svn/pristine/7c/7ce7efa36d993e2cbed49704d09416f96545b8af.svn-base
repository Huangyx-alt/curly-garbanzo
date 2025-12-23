--auto generate by unity editor
local new_game_help_setting = {
[1] = {1,"HallMainHelpView","HallMainHelpView",{0,1154,1155},"CityTitle01","CityBingo01","CityJN01","CityJoker02","CityBG01",{235,236,255},{104,15,252}},
[2] = {2,"PiggyBankHelpView","PiggyBankHelpView",{191095,191096,191097,191098},"0","0","0","0","0",{0},{0}},
[3] = {3,"DrinkingFrenzyHelpView","DrinkingFrenzyHelpView",{191188,191189,191190,191191},"0","0","0","0","0",{0},{0}},
[4] = {4,"PirateShipHelpView","PirateShipHelpView",{1182,1183,1184,1185},"0","0","0","0","0",{0},{0}}
}

local keys = {id = 1,asset_viewname = 2,atlas_viewname = 3,help_text_id = 4,title = 5,img = 6,joke = 7,bingo = 8,guang = 9,tc = 10,oc = 11}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_game_help_setting) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_game_help_setting
