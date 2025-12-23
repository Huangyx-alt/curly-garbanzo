
local BaseRedDot = require("RedDot/BaseRedDot")
local ShopGemsFreeRedDot = Clazz(BaseRedDot,"ShopGemsFreeRedDot")

function ShopGemsFreeRedDot:Check(node,param)
    ShopGemsFreeRedDot:SetSingleNodeActive(node,false)
end

function ShopGemsFreeRedDot:Refresh(nodeList,param)

end

return ShopGemsFreeRedDot