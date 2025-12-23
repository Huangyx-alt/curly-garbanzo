
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

function PopupOrder.Execute(args,orderData)
    --如果有公会俱乐部

    --local nextCanShowTaskUnix = fun.read_value("PopupClubCheckOrder",0);
    --local selftime = os.time()
    --local MailInterTime =Csv.GetControlByName("club_cd")[1][1] or 432000  --默认5天

    if not this.IsAllowPop("PopupClubCheckOrder",orderData) then
        this.Finish()
        return
    end
    local isJoinClub = ModelList.ClubModel.CheckPlayerHasJoinClub()
    local isClubOpen = ModelList.ClubModel.IsClubOpen()
    if not isJoinClub and  isClubOpen  then
        this.RefreshPopTime("PopupClubCheckOrder",orderData,2)
        --fun.save_value("PopupClubCheckOrder",selftime+MailInterTime );
        Event.AddListener(EventName.Event_popup_PopupClubCheck_finish,this.Finish)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.ClubHelpViewInMain,nil,nil,nil)
    else
        this.Finish()
    end 
  
  
end

function PopupOrder.Finish()
    log.g("brocast  EventName.Event_popup_order_finish ")
    Event.RemoveListener(EventName.Event_popup_PopupClubCheck_finish,this.Finish)
    this.NotifyCurrentOrderFinish()
end

return this