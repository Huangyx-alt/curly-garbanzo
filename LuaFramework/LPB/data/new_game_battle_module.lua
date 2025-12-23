--auto generate by unity editor
local new_game_battle_module = {
[1] = {1,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"b_tips_yellow",{{"switch_logic","BaseLogicSwitchCard"},{"card_logic","BaseLogicCard"}}},
[2] = {2,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","PiggyBankLogicSwitchCard"},{"card_logic","PiggyBankLogicCard"}}},
[3] = {3,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","DrinkingFrenzyLogicSwitchCard"},{"card_logic","DrinkingFrenzyLogicCard"}}},
[4] = {4,{"CardPower","CardItem","CardInput","CardMagnifier","CardGuide","CardFlyItemContainer","CardFoodBasket"},"s_tips_yellow",{{"switch_logic","PirateShipLogicSwitchCard"},{"card_logic","PirateShipLogicCard"}}},
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
        for _, t in pairs(new_game_battle_module) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_game_battle_module
