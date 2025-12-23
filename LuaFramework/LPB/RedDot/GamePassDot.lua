
local BaseRedDot = require("RedDot/BaseRedDot")
local GamePassDot = Clazz(BaseRedDot,"GamePassDot")

function GamePassDot:Check(node, param)
    local hasReward = ModelList.GameActivityPassModel.CurrentPlayIdHasReward()
    self:SetSingleNodeActive(node, hasReward) 
end

function GamePassDot:Refresh(nodeList, param)
    for key, value in pairs(nodeList) do
        self:Check(value,param)
    end
end

---------------------------------------------------------------


return GamePassDot