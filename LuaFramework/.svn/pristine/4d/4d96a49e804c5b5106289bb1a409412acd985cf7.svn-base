
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"PopupDeepLinkRewardOrder")
local this = PopupOrder

function PopupOrder.Execute(occasion)
    -- deeplink 链接数据 看有没有数据
    -- 如果有就弹
    local data = ModelList.PlayerInfoModel.GetDeeplinkRewardInfo()
    if not data  then 
        PopupOrder.Finish()
    else 
        if data and data.isShow == true then  
            UIUtil.show_common_popup(30118,true,function()
                PopupOrder.Finish()
            end)
        else 
            if data.codeId ~= nil then 
                ModelList.PlayerInfoModel.SetDeeplinkRewardDisabled(data.codeId)
            end 
    
            SDK.thought_DeepLinkRewardPush(data.codeId)

            Event.AddListener(EventName.Event_Deep_Link_finish,PopupOrder.Finish)
            Facade.SendNotification(NotifyName.ShowUI,ViewList.CommonRewardNetView,nil,nil,data)
            ModelList.PlayerInfoModel.C2SDeepLinkCodeReward(data.codeId) --显示及领取
    
        end 
    
    end 
end

function PopupOrder.Finish()
    Event.RemoveListener(EventName.Event_Deep_Link_finish,PopupOrder.Finish)
    log.g("brocast  EventName.Event_popup_order_finish ")
    Event.Brocast(EventName.Event_popup_order_finish,true)
end


return this