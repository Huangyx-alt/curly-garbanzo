local PlayerInfoSysChangeGroupView = require "View/PlayerInfoSysView/PlayerInfoSysChangeGroupView"
local PlayerInfoSysChangeAvatarGroupView = PlayerInfoSysChangeGroupView:New()
local this = PlayerInfoSysChangeAvatarGroupView
this.viewType = CanvasSortingOrderManager.LayerType.None

function PlayerInfoSysChangeAvatarGroupView:SendChooseEvent(index)
    Event.Brocast(NotifyName.PlayerInfo.SysClickChooseAvatar, index)
end

function PlayerInfoSysChangeAvatarGroupView:GetItemViewCode()
    local avatarItemView = require "View/PlayerInfoSysView/PlayerInfoAvatarItem"
    return avatarItemView
end

function PlayerInfoSysChangeAvatarGroupView:CheckItemVisiable(useIndex)
    local playerInfoSysModel = ModelList.PlayerInfoSysModel
    if not playerInfoSysModel:CheckIsFbHead(self.data[useIndex].icon) then
        return true
    else
        if ModelList.PlayerInfoModel:IsFaceBookLogin() and playerInfoSysModel:CheckFaceBookAvatarResourceExist() then
            return true
        else
            return false
        end
    end
end


function PlayerInfoSysChangeAvatarGroupView:GetItemPosFirst()
    return {x = 123 , y = -141}
end

function PlayerInfoSysChangeAvatarGroupView:GetItemOffset()
    return {x = 213 , y = -235}
end

function PlayerInfoSysChangeAvatarGroupView:GetItemPosHorizonalNum()
    return 4
end

function PlayerInfoSysChangeAvatarGroupView:GetItemHeight()
    return 230
end

return PlayerInfoSysChangeAvatarGroupView