local MailMessagePopView = BaseView:New("MailMessagePopView","MailAtlas")
local this = MailMessagePopView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
local RewardItemEntityCache = {}
local showRewardList = {}
this.recordId = nil 
this.auto_bind_ui_items = {
    "btn_close",    --关闭按钮
    "btn_claim",    --确认收集按钮
    "btn_Retrun",   --回赠按钮
    "titleText",    --标题文字
    --"signText",     --落款
    "contentText",  --内容文字
    "rewardContent", --奖励内容  --里面是奖励内容的Item
    "rewardItem",
    "txt_btn_claim",  --确认收集按钮
    "rewardT", --奖励得条幅
    "rewardTContent",--奖励具体内容
    "rewardScroll",
    "readLine",      --阅读线
}

this.BtnText = {
    ["update"] = "UPDATE",
    ["collect"] = "COLLECT",
    ["continue"] = "CONTINUE",
    ["go"] = "GO",
    ["thank"] = "THANKS"
}

function MailMessagePopView:Awake()
    self:on_init()
end


function MailMessagePopView:OnEnable(params)
    this:UpdataUiData(params.RecordId)
    Facade.RegisterView(this)
    self:SetBg()
end 

function MailMessagePopView:OnDisable()
    for i, v in pairs(RewardItemEntityCache) do
	    v:Close()
	end
    RewardItemEntityCache = {}
    showRewardList = {}
    Facade.RemoveView(this)  
end

function MailMessagePopView:UpdataUiData(RecordId)
    local recordID = RecordId
 
    if recordID ~= nil then 
        local mailInfo = ModelList.MailModel.GetMailInfo(recordID)
        this.recordId = recordID
       
        local count = 0
        if mailInfo ~= nil then 
            this.MailType = mailInfo.type
            --fun.set_active(self.btn_Retrun,false)
            if mailInfo.type == EMAIL_TYPE.UPDATE_EMAIL then 
                --需要区分升级还是没有升级
                local UpdateMailInfo = ModelList.MailModel.GetUpdateMailCont(recordID)
                
                if UpdateMailInfo ~= nil then 
                    self.titleText.text = UpdateMailInfo.title
                    self.contentText.text = UpdateMailInfo.content

                    if UpdateMailInfo.isUpdate == true then 
                        self.txt_btn_claim.text = this.BtnText["collect"]
                    else 
                        self.txt_btn_claim.text =  this.BtnText["update"]
                    end 
                end 

            elseif mailInfo.type == EMAIL_TYPE.QUESTION_EMAIL then -- 问卷调查类型
                local LinkMaildata =  ModelList.MailModel.GetInterlinkMailCont(recordID)

                if LinkMaildata ~= nil then 
                    self.titleText.text = LinkMaildata.title
                    self.contentText.text = LinkMaildata.content
                end 
                self.txt_btn_claim.text =  this.BtnText["go"]

            elseif mailInfo.type ==  EMAIL_TYPE.CLUB_SEASON_CARD_EMAIL then -- 赛季卡包邮件

                --fun.set_active(self.btn_Retrun,true)
                self.txt_btn_claim.text =  this.BtnText["thank"]
                self.titleText.text = mailInfo.title
                self.contentText.text = mailInfo.content
            elseif mailInfo.type ==  EMAIL_TYPE.SEASON_CARD_FEEDBACK then -- 赛季卡片回赠
                  --fun.set_active(self.btn_Retrun,false)
                  self.txt_btn_claim.text =  this.BtnText["thank"]
                  self.titleText.text = mailInfo.title
                  self.contentText.text = mailInfo.content
            else 
                if #mailInfo.reward <= 0 then 
                    fun.set_active(self.btn_claim,true)
                    fun.set_active(self.rewardT,false)
                    fun.set_active(self.rewardTContent,false)
                    fun.set_active(self.rewardScroll,false)
                    fun.set_active(self.readLine,true)
                    self.txt_btn_claim.text = this.BtnText["continue"]
                else
                    self.txt_btn_claim.text = this.BtnText["collect"]
                end 

                self.titleText.text = mailInfo.title
                self.contentText.text = mailInfo.content
             
            end 


            local contlen = string.len(self.contentText.text)
            if  contlen< 200 then 
                local tStr = ""
                local count = math.ceil(contlen /37) 
                for i=1,8-count,1 do 
                    tStr = tStr.."\n"
                end 
                self.contentText.text =self.contentText.text ..tStr
            end 
         
            showRewardList = mailInfo.reward
            for _,v in pairs(mailInfo.reward) do
                count = count +1 
                local view =  this:GetItemViewInstance(count)
                if view then 
                    view:UpdateData(v)
                end 
            end 

        else 
            this:errorClose()
        end 

    else 
        this:errorClose()
    end 
end

function MailMessagePopView:errorClose()
    Facade.SendNotification(NotifyName.CloseUI,this)
    Event.Brocast(EventName.Event_popup_MailPop_finish)
end

function MailMessagePopView:GetItemViewInstance(index)
    local view = require "View/Mail/RewardItemView"
    local view_instance = nil
    
    if RewardItemEntityCache[index] == nil then
        local item = fun.get_instance(self.rewardItem,self.rewardContent)
        view_instance = view:New()
        view_instance:SkipLoadShow(item)
        RewardItemEntityCache[index] = view_instance
    else
        view_instance = RewardItemEntityCache[index]
    end 
    
    fun.set_active(view_instance:GetTransform(),true,false)
    return view_instance
end 

function MailMessagePopView:on_btn_close_click()
    local callbackPop = function()
        ModelList.MailModel.C2S_RequestMailGetReward(this.recordId)
        Facade.SendNotification(NotifyName.CloseUI,this)
        LuaTimer:SetDelayFunction(2, function()
            Event.Brocast(EventName.Event_popup_MailPop_finish)
        end,nil,LuaTimer.TimerType.UI)
    end
    
    if this.MailType ~= nil and this.MailType == EMAIL_TYPE.UPDATE_EMAIL then 
        --判断版本显示是需要升级还是领取奖励 
        local mailInfo = ModelList.MailModel.GetUpdateMailCont(this.recordId)
        if mailInfo ~= nil then 
            if mailInfo.isUpdate == true then  -- 已更新的情况的下
                Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,showRewardList,function()
                        if callbackPop then 
                            callbackPop()
                        end 
                end)
            else 
                --区分强制更新和非强制更新情况
                if mailInfo ~= nil and tonumber( mailInfo.isForce) == 0 then 
                    Facade.SendNotification(NotifyName.CloseUI,this)
                    Event.Brocast(EventName.Event_popup_MailPop_finish)
                end 
            
            end 
        end
        return 
    end 

    if this.MailType ~= nil and this.MailType == EMAIL_TYPE.QUESTION_EMAIL then --问卷调查
        Facade.SendNotification(NotifyName.CloseUI,this)
        Event.Brocast(EventName.Event_popup_MailPop_finish)
        return 
    end 

    if this.MailType ~= nil and #showRewardList >0 then 
        --筛出奖励为卡牌得

        local cardShowRewardList = {}

        for _,v in pairs(showRewardList) do
            if  ModelList.SeasonCardModel:IsCardPackage(v.id) then 
                table.insert(cardShowRewardList,v.id)
            end
        end

        if #showRewardList == #cardShowRewardList then 
            ModelList.MailModel.C2S_RequestMailGetReward(this.recordId)
            local params = {}
            params.bagIds = cardShowRewardList
            params.finishCallback = function() 
                if callbackPop then 
                    callbackPop()
                end 
            end 
            ModelList.SeasonCardModel:OpenCardPackage(params)
        else 
            --做领取处理    
            Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,showRewardList,function()
                if callbackPop then 
                    callbackPop()
                end 
            end)
        end 
    else
        ModelList.MailModel.C2S_RequestMailGetReward(this.recordId)
        Facade.SendNotification(NotifyName.CloseUI,this)
        Event.Brocast(EventName.Event_popup_MailPop_finish)
    end 

end

function MailMessagePopView:on_btn_claim_click()
    local callbackPop = function()
        ModelList.MailModel.C2S_RequestMailGetReward(this.recordId)
        Facade.SendNotification(NotifyName.CloseUI,this)
        LuaTimer:SetDelayFunction(2, function()
            Event.Brocast(EventName.Event_popup_MailPop_finish)
        end,nil,LuaTimer.TimerType.UI)
    end

    ---如果是更新提示，做特殊处理
    if this.MailType ~= nil and this.MailType == EMAIL_TYPE.UPDATE_EMAIL then 
        --判断版本显示是需要升级还是领取奖励
        local mailInfo = ModelList.MailModel.GetUpdateMailCont(this.recordId)
        
        if mailInfo ~= nil then 
            if mailInfo.isUpdate == true then  -- 已更新的情况的下
                Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,showRewardList,function()
                    if callbackPop then 
                        callbackPop()
                    end 
                end)
            else 
                --变更为update
                
                --弹出去更新
                fun.OpenURL(mailInfo.URL)
            end 
        end 

        return 
    end 

    --问卷调查
    if this.MailType ~= nil and this.MailType == EMAIL_TYPE.QUESTION_EMAIL then 
        local mailInfo = ModelList.MailModel.GetInterlinkMailCont(this.recordId) 
        fun.OpenURL(mailInfo.url)
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.claimReward,showRewardList,function()
            if callbackPop then 
                callbackPop()
            end 
        end)
       
        return
    end 
    
    if not showRewardList or #showRewardList ==0 then 
        ModelList.MailModel.C2S_RequestMailGetReward(this.recordId)
        Facade.SendNotification(NotifyName.CloseUI,this)
        return 
    end 

    local cardShowRewardList = {}

    for _,v in pairs(showRewardList) do
        if  ModelList.SeasonCardModel:IsCardPackage(v.id) then 
            table.insert(cardShowRewardList,v.id)
        end
    end

    if #showRewardList == #cardShowRewardList then 
        ModelList.MailModel.C2S_RequestMailGetReward(this.recordId)
        local params = {}
        params.bagIds = cardShowRewardList
        params.finishCallback = function() 
            if callbackPop then 
                callbackPop()
            end 
        end 
        ModelList.SeasonCardModel:OpenCardPackage(params)
    else 
    --做领取处理    
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,showRewardList,function()
            
            if callbackPop then 
                callbackPop()
            end 
        end)
    end 
  
end
--
--function MailMessagePopView:on_btn_Retrun_click()
--    ModelList.MailModel.C2S_FetchFeedbackSeasonCards(this.recordId)
--end

function MailMessagePopView.OnReturnClubCard(data)
    --Facade.SendNotification(NotifyName.Common.CommonTip, "copy uid success") 弱提示
    -- 判断次数够不够不够次数弹提示
    if data.feedbackTimes > 0 and #data.groups > 0 then 
        local tmpdata = {}
        tmpdata.recordId = this.recordId
        tmpdata.groups = deep_copy(data.groups) 
        Facade.SendNotification(NotifyName.ShowUI, ViewList.MailGiveCardView,nil,nil,tmpdata)
    end 

    if data.feedbackTimes <= 0 then 
        UIUtil.show_common_popup(30096,true,function()
            --fun.set_active(this.btn_Retrun ,false)
        end)
    end

    if #data.groups == 0 then
        UIUtil.show_common_popup(30099 ,true,function()
            --fun.set_active(this.btn_Retrun ,false)
        end)
    end 

end

function MailMessagePopView.OnHideMailGiveCard()
    --fun.set_active(this.btn_Retrun ,false)
end

function MailMessagePopView:SetBg()
    --if self.go then
    --    local bg = fun.find_child(self.go,"SafeArea/MessageBg")
    --    if bg and not fun.is_null(bg) then
    --        local bgImg = fun.get_component(bg,fun.IMAGE)
    --        if bgImg and not fun.is_null(bgImg) then
    --            bgImg.sprite = AtlasManager:GetSpriteByName("MailAtlas","InBoxXQDi")
    --        end
    --    end
    --end
end


this.NotifyList = {
    {notifyName = NotifyName.Mail.ShowMailGiveCard, func = this.OnReturnClubCard},
    {notifyName = NotifyName.Mail.HideMailGiveCard, func = this.OnHideMailGiveCard},
}

return this