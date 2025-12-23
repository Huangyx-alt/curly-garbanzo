local Command = {}

function Command.Execute(notifyName, ...)
    local cardId,pos = select(1,...)
    if cardId == nil or pos == nil then
        Facade.SendNotification(NotifyName.CloseUI,ViewList.PowerupCardShowTipView)
        return
    end
    if ViewList.PowerupCardShowTipView.isShow then
        ViewList.PowerupCardShowTipView:SetPowerupCardInfo(cardId,pos)
    else
        Facade.SendNotification(NotifyName.ShowUI,ViewList.PowerupCardShowTipView,function()
            ViewList.PowerupCardShowTipView:SetPowerupCardInfo(cardId,pos)
        end)
    end
end

return Command