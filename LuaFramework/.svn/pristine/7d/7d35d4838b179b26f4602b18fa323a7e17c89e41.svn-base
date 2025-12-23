
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

function PopupOrder.Execute(args,orderData)
    --暂时先屏蔽 mail AdressSubmit view
    if ModelList.PlayerInfoModel:GetEmail() == "" 
            and ModelList.PlayerInfoModel:GetIsTrueGoldUser() then 
        --判断是否满足条件  -- 真金傍，一天只能弹一次  大于某个等级才会提示
        if not this.IsAllowPop("PoupMailAdrressOrder",orderData) then
            this.Finish()
            return
        end
        local selfLevel = ModelList.PlayerInfoModel:GetLv()
        local openLevel = Csv.GetControlByName("request_email")[1][1]
        if selfLevel > openLevel   then
            this.RefreshPopTime("PoupMailAdrressOrder",orderData,2)
            Event.AddListener(EventName.Event_popup_MailPopAddress_finish,this.Finish)
            Facade.SendNotification(NotifyName.ShowUI, ViewList.MailAdressSubmitView,nil,nil,nil)
        else
            this.Finish()
        end 

    else 
        this.Finish()
    end 

  
end

function PopupOrder.Finish()
    log.g("brocast  EventName.Event_popup_order_finish ")
    Event.RemoveListener(EventName.Event_popup_MailPopAddress_finish,this.Finish)
    this.NotifyCurrentOrderFinish()
end

return this