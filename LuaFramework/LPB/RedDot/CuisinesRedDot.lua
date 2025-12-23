
local BaseRedDot = require("RedDot/BaseRedDot")
local CuisinesRedDot = Clazz(BaseRedDot,"CuisinesRedDot")
local this = CuisinesRedDot

function CuisinesRedDot:Check(node,param)
    if node.param == nil then--node.param == nil表示是炒菜功能入口，value == node.param表示具体菜品id要对应上
        local gameMode = ModelList.CityModel:GetEnterGameMode()
        self:SetSingleNodeActive(node, ModelList.ItemModel:IsCuisinesAvailable(nil,nil,gameMode) or ModelList.CityModel:IsCuisineReward())
    elseif node.param == RedDotParam.auto_city_cuisines then
        local isActive = (ModelList.ItemModel:IsCuisinesAvailable(Csv.GetAutoCity(),nil) or
        ModelList.CityModel:IsCuisineReward(Csv.GetAutoCity(),nil) or
        self:GetInfoByReddotCount(node,"cuisines")) and ModelList.PlayerInfoModel:IsAutoLobbyOpen()

        self:SetSingleNodeActive(node,isActive)
        self:SetReddotCountInfo(node,"cuisines",isActive)
    elseif node.param then
        self:SetSingleNodeActive(node, ModelList.ItemModel:IsCuisinesAvailable(nil,node.param))
    end
end

function CuisinesRedDot:Refresh(nodeList,param)
    for key, value in pairs(nodeList) do
        self:Check(value,param)
    end
end

return this