local BaseRedDot = require("RedDot/BaseRedDot")
local ShopCoinFreeRedDot = Clazz(BaseRedDot,"ShopCoinFreeRedDot")

function ShopCoinFreeRedDot:Check(node,param)
    local isBigR = ModelList.PlayerInfoModel:GetUserType()  --判断是否是大R用户
 --   log.r("isBigR usetype"..isBigR)
    if node.param == RedDotParam.shop_gem or 
        node.param == RedDotParam.shop_offers or 
        node.param == RedDotParam.shop_coin or 
        node.param == RedDotParam.shop_cherry or isBigR == UserTypeBigR then
            
        ShopCoinFreeRedDot:SetSingleNodeActive(node,false)
    else

        ShopCoinFreeRedDot:SetSingleNodeActive(node,ModelList.MainShopModel:CheckFreeRewardAvailable())
    end
end

function ShopCoinFreeRedDot:Refresh(nodeList,param)
    assert(nodeList ~= nil,"nodeList异常")
    for key, value in pairs(nodeList) do
        ShopCoinFreeRedDot:Check(value,param)
        -- log.r("ShopCoinFreeRedDot Node "..key)
    end
end

return ShopCoinFreeRedDot