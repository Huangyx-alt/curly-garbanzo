local PlayerInfoUpdateAvatarAndFrame = BaseView:New()
local this = PlayerInfoUpdateAvatarAndFrame
this.viewType = CanvasSortingOrderManager.LayerType.None
this.auto_bind_ui_items ={
    "imgHead",
    "imageFrame",
}

function PlayerInfoUpdateAvatarAndFrame:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function PlayerInfoUpdateAvatarAndFrame:OnEnable()
    self.init = true
end

function PlayerInfoUpdateAvatarAndFrame:SetIsOneSelf(isOneSelf)
    self.isOneSelf = isOneSelf or false
    if isOneSelf then
        self:AddChangeaAvatarorFrameEvent()
        self:SetPlayerSelf()
    end
end

function PlayerInfoUpdateAvatarAndFrame:ChangeAvatarEvent()
    local useingHeadIconId = ModelList.PlayerInfoSysModel.GetUsingHeadIconID()
    self:SetAvatarId(useingHeadIconId)
end

function PlayerInfoUpdateAvatarAndFrame:ChangeFrameEvent()
    local useingFrameIconId = ModelList.PlayerInfoSysModel.GetUsingFrameIconID()
    self:SetFrameId(useingFrameIconId)
end

function PlayerInfoUpdateAvatarAndFrame:AddChangeaAvatarorFrameEvent()
    Event.AddListener(NotifyName.PlayerInfo.ChangeAvatarEvent,self.ChangeAvatarEvent,self)
    Event.AddListener(NotifyName.PlayerInfo.ChangeFrameEvent,self.ChangeFrameEvent,self)
end

function PlayerInfoUpdateAvatarAndFrame:RemoveChangeFrameEvent()
    Event.RemoveListener(NotifyName.PlayerInfo.ChangeAvatarEvent,self.ChangeAvatarEvent,self)
    Event.RemoveListener(NotifyName.PlayerInfo.ChangeFrameEvent,self.ChangeFrameEvent,self)
end


function PlayerInfoUpdateAvatarAndFrame:SetPlayerSelf()
    local useingHeadIconId = ModelList.PlayerInfoSysModel.GetUsingHeadIconID()
    self:SetAvatarId(useingHeadIconId)

    local useingFrameIconId = ModelList.PlayerInfoSysModel.GetUsingFrameIconID()
    self:SetFrameId(useingFrameIconId)
end

function PlayerInfoUpdateAvatarAndFrame:SetAvatarId(headIconId)
    if not self.imgHead or fun.is_null(self.imgHead) or not headIconId then
        log.log("错误缺少引用UI图片")
        return  --需要这个
    end
    ModelList.PlayerInfoSysModel:LoadTargetHeadSprite(headIconId, self.imgHead)
end

function PlayerInfoUpdateAvatarAndFrame:SetFrameId(frameIconId)
    if not self.imageFrame or fun.is_null(self.imageFrame) or not frameIconId then
        log.log("错误缺少引用UI图片")
        return  --需要这个
    end
    ModelList.PlayerInfoSysModel:LoadTargetFrameSprite(frameIconId, self.imageFrame)
end

function PlayerInfoUpdateAvatarAndFrame:SetAvatarIdByName(headName)
    if not self.imgHead or fun.is_null(self.imgHead) or not headName then
        log.log("错误缺少引用UI图片")
        return  --需要这个
    end
    ModelList.PlayerInfoSysModel:LoadTargetHeadSpriteByName(headName, self.imgHead)
end

function PlayerInfoUpdateAvatarAndFrame:SetFrameIdByName(frameName)
    if not self.imageFrame or fun.is_null(self.imageFrame) or not frameName then
        log.log("错误缺少引用UI图片")
        return  --需要这个
    end
    ModelList.PlayerInfoSysModel:LoadTargetFrameSpriteByName(frameName, self.imageFrame)
end

function PlayerInfoUpdateAvatarAndFrame:OnDestroy()
    if self.isOneSelf then
        self:RemoveChangeFrameEvent()
    end
    self.init = false
    self.isOneSelf = false
    self.imgHead = nil
    self.imageFrame = nil
end

return PlayerInfoUpdateAvatarAndFrame