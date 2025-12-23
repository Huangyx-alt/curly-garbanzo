local PlayerInfoAvatarItemBase = require "View/PlayerInfoSysView/PlayerInfoAvatarItemBase"
local PlayerInfoFrameItem = PlayerInfoAvatarItemBase:New("PlayerInfoFrameItem")
local this = PlayerInfoFrameItem
this.viewType = CanvasSortingOrderManager.LayerType.None

function PlayerInfoFrameItem:GetUsingAtlasName()
    return "HeadIconFrameAtlas"
end

function PlayerInfoFrameItem:SetUsingSprite()
    --log.log("替换修改图标" , self.data)
    ModelList.PlayerInfoSysModel:LoadTargetFrameSprite(self.data.icon , self:GetIconUI(), true)
end

function PlayerInfoFrameItem:GetDesId()
    local desId = ModelList.PlayerInfoSysModel:GetConfigFrameDesId(self.data.icon)
    return desId
end

return this