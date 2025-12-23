--auto generate by unity editor
local new_game_card = {
[1] = {1,1,{"CardInput","CardItem","NormalCardMagnifier","CardPower","CardGuide","CardFlyItemContainer","CardFoodBasket"},"CardAutoSignTipView",1,{0.5,0.5},},
[2] = {2,1,{"CardInput","CardItem","NormalCardMagnifier","CardPower","CardFlyItemContainer","CardFoodBasket"},"CardAutoSignTipView",1,{0.5,0.5},},
[3] = {3,1,{"CardInput","CardItem","NormalCardMagnifier","CardPower","CardFlyItemContainer","CardFoodBasket"},"CardAutoSignTipView",1,{0.5,0.5},},
[4] = {4,1,{"CardInput","CardItem","NormalCardMagnifier","CardPower","CardFlyItemContainer","CardFoodBasket"},"CardAutoSignTipView",0,{0.5,0.5},}
}

local keys = {id = 1,card_load_type = 2,card_open_module = 3,card_sign_tip = 4,need_wish = 5,letter_pivot_offset = 6,}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_game_card) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_game_card
