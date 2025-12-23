
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupUltraBetRewardOrder = Clazz(BaseOrder, "")
local this = PopupUltraBetRewardOrder

function PopupUltraBetRewardOrder.Execute(args)
    AddLockCountOneStep(true)
    local isNeedPopup = ModelList.UltraBetModel:HasEncouragement()
    --isNeedPopup = true --for test wait delete
    if isNeedPopup then
        Event.AddListener(EventName.Event_registerReward, this.ClaimEncouragementReward, this)
        ModelList.UltraBetModel:ClaimEncouragementReward()
    else
        this.Finish()
    end
end

function PopupUltraBetRewardOrder.Finish()
    log.g("brocast  EventName.Event_popup_order_finish  RegisterReward")
    AddLockCountOneStep(false)
    Facade.SendNotification(NotifyName.CloseUI, ViewList.RegisterRewardView, nil, nil, nil)
    this.NotifyCurrentOrderFinish()
end

function PopupUltraBetRewardOrder:ClaimEncouragementReward(reward)
    log.g("ClaimEncouragementReward poupOrder" .. tostring(reward))
    if reward then
        Facade.SendNotification(NotifyName.ShowUI, ViewList.RegisterRewardView, nil, nil, reward)
    else
        Event.RemoveListener(EventName.Event_registerReward, this.ClaimEncouragementReward, this)
        Facade.SendNotification(NotifyName.UltraBet.RewardReceiveFinish)
        this.Finish()
    end
end

return this