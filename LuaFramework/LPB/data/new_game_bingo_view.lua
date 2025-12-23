--auto generate by unity editor
local new_game_bingo_view = {
[1] = {1,"NormalCardView","GamePowerUpView","GameJackpotView","GameBingoEffectView","GameCallNumberView","GameBoxView","GameBingosleftView","GameBingoSwitchView",{"0"}},
[2] = {2,"PiggyBankGameCardView","GamePowerUpView","PiggyBankJackpotView","GameBingoEffectView","GameCallNumberView","GameBoxView","GameBingosleftView","PiggyBankSwitchView",{"PiggyBankBingoAtlas","PiggyBankHallAtlas"}},
[3] = {3,"DrinkingFrenzyGameCardView","GamePowerUpView","DrinkingFrenzyJackpotView","GameBingoEffectView","GameCallNumberView","GameBoxView","GameBingosleftView","DrinkingFrenzySwitchView",{"DrinkingFrenzyBingoAtlas","DrinkingFrenzyHallAtlas"}},
[4] = {4,"PirateShipGameCardView","GamePowerUpView","GameJackpotView","GameBingoEffectView","GameCallNumberView","GameBoxView","GameBingosleftView","PirateShipSwitchView",{"PirateShipBingoAtlas","PirateShipHallAtlas"}}
}

local keys = {id = 1,card_view = 2,power_view = 3,jackpot_view = 4,jump_bingo_view = 5,call_number_view = 6,box_view = 7,bingosleft_view = 8,switch_view = 9,atlas = 10}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_game_bingo_view) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_game_bingo_view
