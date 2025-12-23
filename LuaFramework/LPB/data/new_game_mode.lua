--auto generate by unity editor
local new_game_mode = {
[1] = {1,1,"Normal","GameBingoView","GameModel","BingoSettleDetailView",{"cardinput","carditem","cardmagnifier","cardpower","effectentry","cardeffect","cardguide","cardflyitemcontainer","cardfoodbasket","singlecardview"},{"PowerUpEffect"},{"CellSignType"},1,1,1,1,1,1,1,1,"BaseFlyItemEffect","NormalBingoEffect","NormalSingleCardView",1,"NormalSignEffect","CardCoinEffect",{"0"},"0"},
[2] = {2,2,"PiggyBank","PiggyBankBingoView","PiggyBankModel","PiggyBankSettleDetailView",{"cardinput","carditem","cardmagnifier","cardpower","effectentry","cardeffect","cardguide","cardflyitemcontainer","cardfoodbasket"},{"PowerUpEffect"},{"CellSignType"},1,1,1,1,1,0,1,1,"PiggyBankFlyItemEffect","PiggyBankBingoEffect","PiggyBankSingleCardView",1,"PiggyBankSignEffect","CardCoinEffect",{"piggyBankPuSkill","PiggyBankPuSkill"},"0"},
[3] = {3,3,"DrinkingFrenzy","DrinkingFrenzyBingoView","DrinkingFrenzyModel","DrinkingSettleDetailView",{"cardinput","carditem","cardmagnifier","cardpower","effectentry","cardeffect","cardguide","cardflyitemcontainer","cardfoodbasket"},{"PowerUpEffect"},{"CellSignType"},0,1,1,1,1,0,1,1,"DrinkingFrenzyFlyItemEffect","DrinkingFrenzyBingoEffect","DrinkingFrenzySingleCardView",1,"DrinkingFrenzySignEffect","CardCoinEffect",{"DrinkingFrenzyPuSkill","DrinkingFrenzyPuSkill"},"0"},
[4] = {4,4,"PirateShip","PirateShipBingoView","PirateShipModel","PirateShipSettleDetailView",{"cardinput","carditem","cardmagnifier","cardpower","effectentry","cardeffect","cardguide","cardflyitemcontainer","cardfoodbasket"},{"PowerUpEffect"},{"CellSignType"},1,1,1,1,1,0,1,1,"PirateShipFlyItemEffect","PirateShipBingoEffect","PirateShipSingleCardView",1,"PirateShipSignEffect","CardCoinEffect",{"pirateShipPuSkill","PirateShipPuSkill"},"0"},
}

local keys = {id = 1,city_play = 2,type_name = 3,view = 4,model = 5,settledetailview = 6,card = 7,power = 8,effect = 9,cardinput = 10,carditem = 11,cardmagnifier = 12,cardpower = 13,cardeffect = 14,cardguide = 15,cardflyitemcontainer = 16,cardfoodbasket = 17,flyitemeffect = 18,cardbingoeffect = 19,singlecardview = 20,powerupeffect = 21,cellsigntype = 22,card_coin_effect = 23,skill_require = 24,card_effect_require = 25}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_game_mode) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_game_mode
