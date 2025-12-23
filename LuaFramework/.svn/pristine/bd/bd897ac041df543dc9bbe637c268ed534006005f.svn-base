--auto generate by unity editor
local new_game_pool_effect = {
[1] = {1,{{"BingoEffect","BingoEffect","5","8"},{"ClickGet","NormalClickGet","8","16"}}},
[2] = {2,{{"PiggyBankJackpot","PiggyBankJackpot","4","4"},{"PiggyBankbingo","PiggyBankbingo","4","8"},{"ClickGet","PiggyBankClickGet","8","16"},{"PiggyBankEmpty","PiggyBankEmpty","4"," 8"},{"PiggyBankskill2feiji","PiggyBankskill2feiji","4","4"},{"PiggyBankskillyanjing","PiggyBankskillyanjing","4","4"}}},
[3] = {3,{{"DrinkingFrenzyJackpot","DrinkingFrenzyJackpot","4","4"},{"DrinkingFrenzybingo","DrinkingFrenzybingo","4","8"},{"ClickGet","DrinkingFrenzyClickGet","8","16"},{"treasure01","DrinkingFrenzy_Item1Show","4","8"},{"treasure02","DrinkingFrenzy_Item2Show","4","8"},{"treasureFlyItem01","DrinkingFrenzy_FlyItem1","4","8"},{"treasureFlyItem02","DrinkingFrenzy_FlyItem2","4","8"},{"DrinkingFrenzyskill2feiji","DrinkingFrenzyskill2feiji","4","4"}}},
[4] = {4,{{"PirateShipJackpot","PirateShipJackpot","4","4"},{"PirateShipbingo","PirateShipbingo","4","8"},{"ClickGet","PirateShipClickGet","8","16"},{"showitem","PirateShipItemShow","4"," 8"},{"flyItem","PirateShipFlyItem","4"," 8"},{"PirateShipPuSkill","PirateShipPuSkill","4","4"}}}
}

local keys = {id = 1,effect_config = 2}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_game_pool_effect) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_game_pool_effect
