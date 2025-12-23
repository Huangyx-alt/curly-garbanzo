
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

function PopupOrder.Execute(args)
    AddLockCountOneStep(true)
    if ModelList.PlayerInfoModel.IsHasRegisterReward() then
        Event.AddListener(EventName.Event_registerReward,this.OnClaimRegisterReward,this)
        ModelList.PlayerInfoModel.ClaimRegisterReward()
    else
        this.Finish()    
    end
end

function PopupOrder.Finish()
    log.g("brocast  EventName.Event_popup_order_finish  RegisterReward")
    AddLockCountOneStep(false)
    Facade.SendNotification(NotifyName.CloseUI,ViewList.RegisterRewardView,nil,nil,nil)
    this.NotifyCurrentOrderFinish()
    
end

function PopupOrder:OnClaimRegisterReward(reward)
    log.g("OnClaimRegisterReward poupOrder"..tostring(reward))
    if reward then

        Facade.SendNotification(NotifyName.ShowUI,ViewList.RegisterRewardView,nil,nil,reward)
    else
        Event.RemoveListener(EventName.Event_registerReward,this.OnClaimRegisterReward,this)
        this.Finish()    
    end
end

this.NotifyList = {
    {notifyName = NotifyName.Login.RegisterReward,func = this.OnClaimRegisterReward}
}

return this