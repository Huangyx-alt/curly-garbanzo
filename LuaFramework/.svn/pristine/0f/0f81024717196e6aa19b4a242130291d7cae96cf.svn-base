local PlayerInfoSysChangeGroupView = require "View/PlayerInfoSysView/PlayerInfoSysChangeGroupView"
local PlayerInfoSysChangeFrameGroupView = PlayerInfoSysChangeGroupView:New()
local this = PlayerInfoSysChangeFrameGroupView
this.viewType = CanvasSortingOrderManager.LayerType.None

function PlayerInfoSysChangeFrameGroupView:SendChooseEvent(index)
    Event.Brocast(NotifyName.PlayerInfo.SysClickChooseFrame, index)
end

function PlayerInfoSysChangeFrameGroupView:GetItemViewCode()
    local itemView = require "View/PlayerInfoSysView/PlayerInfoFrameItem"
    return itemView
end

function PlayerInfoSysChangeFrameGroupView:GetItemPosFirst()
    return {x = 123 , y = -141}
end

function PlayerInfoSysChangeFrameGroupView:GetItemOffset()
    return {x = 213 , y = -235}
end

function PlayerInfoSysChangeFrameGroupView:GetItemPosHorizonalNum()
    return 4
end

function PlayerInfoSysChangeFrameGroupView:GetItemHeight()
    return 260
end

return PlayerInfoSysChangeFrameGroupView