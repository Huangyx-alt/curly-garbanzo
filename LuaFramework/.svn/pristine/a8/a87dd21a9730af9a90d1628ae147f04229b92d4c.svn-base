local PlayerInfoAvatarItemBase = require "View/PlayerInfoSysView/PlayerInfoAvatarItemBase"
local PlayerInfoAvatarItem = PlayerInfoAvatarItemBase:New("PlayerInfoAvatarItem")
local this = PlayerInfoAvatarItem
this.viewType = CanvasSortingOrderManager.LayerType.None

function PlayerInfoAvatarItem:GetUsingAtlasName()
    return "HeadAtlas"
end

function PlayerInfoAvatarItem:SetUsingSprite()
    if self.data and self.data.icon  then
        --用的本地图标
        ModelList.PlayerInfoSysModel:LoadTargetHeadSprite(self.data.icon, self:GetIconUI())
    else
        log.log("缺少图片配置" , self.data)
    end
end

function PlayerInfoAvatarItem:GetDesId()
    local desId = ModelList.PlayerInfoSysModel:GetConfigAvatarDesId(self.data.icon)
    return desId
end


return this