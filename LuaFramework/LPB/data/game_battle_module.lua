--auto generate by unity editor
local game_battle_module = {
[1] = {1,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"b_tips_yellow",{{"switch_logic","BaseLogicSwitchCard"}}},
[2] = {2,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"b_tips_yellow",{{"switch_logic","BaseLogicSwitchCard"}}},
[3] = {3,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"b_tips_yellow",{{"switch_logic","BaseLogicSwitchCard"}}},
[4] = {4,{"CardPower","CardItem","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"b_tips_yellow",{{"switch_logic","BaseLogicSwitchCard"}}},
[5] = {5,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","HawaiiLogicSwitchCard"},{"card_logic","HawaiiLogicCard"}}},
[6] = {6,{"CardPower","CardItem","CardInput","CardMagnifier","CardFlyItemContainer","CardFoodBasket"},"b_tips_yellow",{{"switch_logic","ChristmasLogicSwitchCard"},{"card_logic","ChristmasLogicCard"}}},
[7] = {7,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","LeetoleManLogicSwitchCard"},{"card_logic","LeetoleManLogicCard"}}},
[8] = {8,{"CardPower","CardItem","CardInput","CardMagnifier","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","SingleWolfLogicSwitchCard"},{"card_logic","SingleWolfLogicCard"}}},
[10] = {10,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"b_tips_yellow",{{"switch_logic","BaseLogicSwitchCard"}}},
[11] = {11,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"b_tips_yellow",{{"switch_logic","BaseLogicSwitchCard"}}},
[14] = {14,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"b_tips_yellow",{{"switch_logic","BaseLogicSwitchCard"}}},
[15] = {15,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"b_tips_yellow",{{"switch_logic","BaseLogicSwitchCard"}}},
[12] = {12,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","GemQueenLogicSwitchCard"},{"card_logic","GemQueenLogicCard"}}},
[13] = {13,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","CandyLogicSwitchCard"},{"card_logic","CandyLogicCard"}}},
[16] = {16,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","NewChristmasLogicSwitchCard"},{"card_logic","NewChristmasLogicCard"}}},
[17] = {17,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"b_tips_yellow",{{"switch_logic","BaseLogicSwitchCard"}}},
[18] = {18,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","GoldenPigLogicSwitchCard"},{"card_logic","GoldenPigLogicCard"}}},
[19] = {19,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","DragonFortuneLogicSwitchCard"},{"card_logic","DragonFortuneLogicCard"}}},
[20] = {20,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","NewLeetoleManLogicSwitchCard"},{"card_logic","NewLeetoleManLogicCard"}}},
[21] = {21,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","EasterLogicSwitchCard"},{"card_logic","EasterLogicCard"}}},
[22] = {22,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","VolcanoLogicSwitchCard"},{"card_logic","VolcanoLogicCard"}}},
[23] = {23,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","PirateShipLogicSwitchCard"},{"card_logic","PirateShipLogicCard"}}},
[24] = {24,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","ThievesLogicSwitchCard"},{"card_logic","ThievesLogicCard"}}},
[25] = {25,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"b_tips_yellow",{{"switch_logic","BaseLogicSwitchCard"}}},
[26] = {26,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","MoleMinerLogicSwitchCard"},{"card_logic","MoleMinerLogicCard"}}},
[27] = {27,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","BisonLogicSwitchCard"},{"card_logic","BisonLogicCard"}}},
[28] = {28,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","HorseRacingLogicSwitchCard"},{"card_logic","HorseRacingLogicCard"}}},
[29] = {29,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","ScratchWinnerLogicSwitchCard"},{"card_logic","ScratchWinnerLogicCard"}}},
[30] = {30,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","GoldenTrainLogicSwitchCard"},{"card_logic","GoldenTrainLogicCard"}}},
[31] = {31,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer"},"s_tips_yellow",{{"switch_logic","ChristmasSynthesisLogicSwitchCard"},{"card_logic","ChristmasSynthesisLogicCard"}}},
[32] = {32,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","GotYouLogicSwitchCard"},{"card_logic","GotYouLogicCard"}}},
[33] = {33,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","LetemRollLogicSwitchCard"},{"card_logic","LetemRollLogicCard"}}},
[34] = {34,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","PiggyBankLogicSwitchCard"},{"card_logic","PiggyBankLogicCard"}}},
[35] = {35,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","SolitaireLogicSwitchCard"},{"card_logic","SolitaireLogicCard"}}},
[36] = {36,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","MonopolyLogicSwitchCard"},{"card_logic","MonopolyLogicCard"}}},
[37] = {37,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","DrinkingFrenzyLogicSwitchCard"},{"card_logic","DrinkingFrenzyLogicCard"}}}
}

local keys = {id = 1,card_modules = 2,powerup_modules = 3,logic_module = 4}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(game_battle_module) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return game_battle_module
