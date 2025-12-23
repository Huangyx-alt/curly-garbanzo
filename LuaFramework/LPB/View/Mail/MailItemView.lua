require "State/MailItemView/MailItemBaseState"  --基础
require "State/MailItemView/MailItemAReadAGetState"  --已读已领
require "State/MailItemView/MailItemAReadCGetState"  --已读不用领
require "State/MailItemView/MailItemEnterState"      --进入
require "State/MailItemView/MailItemExitState"       --退出
require "State/MailItemView/MailItemNReadAGetState"  -- 未读已领
require "State/MailItemView/MailItemNReadCGetState"  -- 未读已领
require "State/MailItemView/MailItemNReadNGetState"  -- ---未读未领

local MailItemView = BaseView:New("MailItemView")
local _watchADUtility = WatchADUtility:New(AD_EVENTS.AD_EVENTS_MAIL_INBOX)
local this = MailItemView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "img_Type",         --物品icon 图片
    "text_Ttile",       --邮件标题
    "redDot",           --红点
    "text_dec",         --邮件简缩内容
    "expiresTimeTxt",   --是否有时间
    "text_Time",        --时间文本
    "btn_claim",        -- 收集，或者阅读更多
    "text_btn_claim"     -- 收集，或者阅读更多
}   

this.ItemText = {
    ["readmore"] = "MORE",
    ["collect"] = "COLLECT",
    ["update"]  = "UPDATE"
}

--与 email_Type 对应
this.Image_Type_s ={
    [0] = {m="normal",a="MailAtlas",w=132,h=107} , --普通邮件
    [1] = {m="GiftBox",a="MailAtlas",w=146,h=107},--弹窗邮件
    [2] = {m="GiftBox",a="MailAtlas",w=146,h=107},--奖励邮件
    [3] = {m="c_biao4",a="MailAtlas",w=141,h=103},--广告邮件
    [4] = {m="InBoxIconFB",a="MailAtlas",w=209,h=152},--Facebook绑定邮件
    [5] = {m="GiftBox",a="MailAtlas",w=146,h=107},--奖励邮件
    [6] = {m="GiftBox",a="MailAtlas",w=146,h=107},--奖励邮件
    [7] = {m="GiftBox",a="MailAtlas",w=146,h=107},--奖励邮件
    [8] = {m="ZBzhenjinjiangli4",a="MailAtlas",w=146,h=107},--真金周榜
    [9] = {m="InBoxIconKb",a="MailAtlas",w=146,h=107},--卡牌奖励邮件
    [10] = {m="InBoxIconKb",a="MailAtlas",w=146,h=107},--卡牌回赠奖励邮件
}

function MailItemView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function MailItemView:Awake()
    self:on_init()
end


function MailItemView:OnEnable(data)
    self:BuildFsm()
    _watchADUtility:ChangeAdEvent(AD_EVENTS.AD_EVENTS_MAIL)
end

function MailItemView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("MailItemView",self,{
        MailItemEnterState:New(),
        MailItemExitState:New(),
        MailItemNReadAGetState:New(),
        MailItemNReadCGetState:New(),
        MailItemNReadNGetState:New(),
        MailItemAReadAGetState:New(),
        MailItemAReadCGetState:New(),
    })
    self._fsm:StartFsm("MailItemEnterState")
end


function MailItemView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function MailItemView:GetTransform()
    if self.go then
        return self.go.transform
    end
    return nil
end

function MailItemView:UpdateData(data)
    
    
    self.data = deep_copy(data)
    if self.data ~= nil then
        
        if self.data.type == EMAIL_TYPE.UPDATE_EMAIL then 
            --需要区分升级还是没有升级
            local UpdateMailInfo = ModelList.MailModel.GetUpdateMailCont(self.data.recordId)
            
            if UpdateMailInfo ~= nil then 
                self.text_Ttile.text = string.len(UpdateMailInfo.title )> 15 and  string.sub(UpdateMailInfo.title,1,16) .. "..." or UpdateMailInfo.title
                --self.text_dec.text =  string.len(UpdateMailInfo.title ) >30 and  string.sub(UpdateMailInfo.content,1,30) .. "..."  or UpdateMailInfo.content
            end 
        elseif self.data.type == EMAIL_TYPE.QUESTION_EMAIL then 
            local LinkMaildata =  ModelList.MailModel.GetInterlinkMailCont(self.data.recordId)
            if LinkMaildata ~= nil then 
                self.text_Ttile.text =  string.len( LinkMaildata.title )> 15 and  string.sub( LinkMaildata.title,1,16) .. "..." or  LinkMaildata.title
                --self.text_dec.text = string.len(LinkMaildata.content ) >30 and  string.sub(LinkMaildata.content,1,30) .. "..."  or LinkMaildata.content
            end 
        elseif self.data.type == EMAIL_TYPE.AMAZON_GIFT_CARD_EMAIL then 
            self.text_Ttile.text ="AMAZON GIFT CARD GET"
            --self.text_dec.text ="Hello here have you ..."
        else 
            self.text_Ttile.text = string.len(self.data.title )> 15 and string.sub(self.data.title,1,16) .. "..." or self.data.title --邮件题目
            --self.text_dec.text =string.len(self.data.content ) >30 and  string.sub(self.data.content,1,30) .. "..." or  self.data.content    --缩减内容，
        end 

        if this.Image_Type_s[self.data.type] then 
            --self.img_Type.sprite =  AtlasManager:GetSpriteByName(this.Image_Type_s[data.type].a, this.Image_Type_s[data.type].m)
            --fun.set_recttransform_native_size(self.img_Type,this.Image_Type_s[data.type].w,this.Image_Type_s[data.type].h)
        end 
        
        if self.data.expireTime ~= nil and self.data.expireTime ~= 0 then 
            fun.set_active(self.expiresTimeTxt,true)
            fun.set_active(self.text_Time,true)
            self:SetLeftTime(self.data.expireTime)
        else 
            fun.set_active(self.expiresTimeTxt,false)
            fun.set_active(self.text_Time,false)
        end

        if self.data.type == EMAIL_TYPE.ADVERTISE_EMAIL then   --广告类型的需要显示按钮上的
            local mIcon = fun.find_child(self.btn_claim, "TvIcon")
            fun.set_active(mIcon,true)
        end 

        self:Change2FitState()
    end
end

function MailItemView:SetLeftTime(endTimeStamp)
     local start_time = ModelList.PlayerInfoModel.get_cur_server_time()
     self.endTime = endTimeStamp - start_time

    if self.loopTime  then
        LuaTimer:Remove(self.loopTime)
        self.loopTime = nil
    end

    self.loopTime = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
        if self.text_Time then
            self.text_Time.text = fun.SecondToStrFormat(self.endTime)
            self.endTime = self.endTime - 1
            if self.endTime  <= 0 then
                self:closeTimer()
            end
        end
    end,nil,nil,LuaTimer.TimerType.UI)
end

function MailItemView:closeTimer()
    if self.loopTime  then
        LuaTimer:Remove(self.loopTime)
        self.loopTime = nil
    end

    if self.expiresTimeTxt ~= nil then 
        fun.set_active(self.expiresTimeTxt,false)
        fun.set_active(self.text_Time,false)
    end 

    -- --请求邮件协议
    -- ModelList.MailModel.C2S_RequestMailList()
end

function MailItemView:OnDisable()
    if self.loopTime  then
        LuaTimer:Remove(self.loopTime)
        self.loopTime = nil
    end
end


--转到对应状态
function MailItemView:Change2FitState()
    if not self.data then
        return
    end 

    if self.data.isReceive == false and self.data.isRead == false then -- 未读未领
        self._fsm:ChangeState("MailItemNReadNGetState")
        return;
    end 

    if self.data.isReceive == true  and self.data.isRead == false then -- 未读已领
        self._fsm:ChangeState("MailItemNReadAGetState")
        return;
    end 

    if self.data.isReceive == true and self.data.isRead == true then  --已读已领
        self._fsm:ChangeState("MailItemAReadAGetState")
        return;
    end 

    if self.data.isReceive == false and self.data.isRead == true then  --已读不用领
        self._fsm:ChangeState("MailItemAReadCGetState")
        return;
    end 

end 

--未读未领状态 
function MailItemView:NotReadNotGet()
    fun.set_active(self.redDot,true)
    fun.set_active(self.btn_claim,true)

    if self.data.type == EMAIL_TYPE.UPDATE_EMAIL then 
        local mailInfo = ModelList.MailModel.GetUpdateMailCont(self.data.recordId)

        if not mailInfo then 
            return
        end 

        if mailInfo.isUpdate == true then 
            self.text_btn_claim.text = this.ItemText["collect"]
        else
            self.text_btn_claim.text = this.ItemText["update"]
        end 
      
        return 
    end 

    if self.data ~= nil and #self.data.reward > 0 and  self.data.type ~= EMAIL_TYPE.NORMAL_EMAIL then 
        self.text_btn_claim.text = this.ItemText["collect"]
    else 
        self.text_btn_claim.text = this.ItemText["readmore"]
    end 

end 


--未读已领
function MailItemView:NotReadAlrGet()
    fun.set_active(self.redDot,true)
    fun.set_active(self.btn_claim,true)

    if self.data.type == EMAIL_TYPE.UPDATE_EMAIL then 
        local mailInfo = ModelList.MailModel.GetUpdateMailCont(self.data.recordId)
        if mailInfo.isUpdate == true then 
            self.text_btn_claim.text = this.ItemText["collect"]
        else
            self.text_btn_claim.text = this.ItemText["update"]
        end 
      
        return 
    end 

    if self.data ~= nil and #self.data.reward > 0 then 
        self.text_btn_claim.text = this.ItemText["collect"]
    else 
        self.text_btn_claim.text = this.ItemText["readmore"]
    end 
end 

--已读不用领
function MailItemView:AlrReadCGet()
    fun.set_active(self.redDot,false)
    fun.set_active(self.btn_claim,true)
    
    self.text_btn_claim.text = this.ItemText["collect"]
end 

--已读已领
function MailItemView:AlrReadAlrGet()
    -- fun.set_active(self.redDot,false)
    -- fun.set_active(self.btn_claim,false)
    -- fun.set_active(self.expiresTimeTxt,false)
    -- fun.set_active(self.text_Time,false)
    this:closeTimer()
    fun.set_active(self.go,false)
end 

--未读不用领
function MailItemView:NotReadCGet()
    fun.set_active(self.redDot,true)
    fun.set_active(self.btn_claim,false)
end

--阅读事件
function MailItemView:OnReadClick()
    --并发送已读消息
    ModelList.MailModel.C2S_RequestMailRead(self.data.recordId)

    if self.data.type == EMAIL_TYPE.NORMAL_EMAIL and #self.data.reward <= 0 then 
        ModelList.MailModel.C2S_RequestMailGetReward(self.data.recordId)
    end 
end

--领取事件
function MailItemView:OnGetClick()
    if self.data.type == EMAIL_TYPE.NORMAL_EMAIL then 
        ModelList.MailModel.C2S_RequestMailRead(self.data.recordId)
        return 
    end 

    --问卷调查类型
    if self.data.type == EMAIL_TYPE.QUESTION_EMAIL then 
        ModelList.MailModel.C2S_RequestMailRead(self.data.recordId)
        return 
    end 

    --亚马逊类型
    if self.data.type == EMAIL_TYPE.AMAZON_GIFT_CARD_EMAIL then 
        ModelList.MailModel.C2S_RequestMailRead(self.data.recordId)
        return 
    end 

    local cardShowRewardList = {}

    for _,v in pairs(self.data.reward) do
        if  ModelList.SeasonCardModel:IsCardPackage(v.id) then 
            table.insert(cardShowRewardList,v.id)
        end
    end

    if #self.data.reward == #cardShowRewardList then 
        ModelList.MailModel.C2S_RequestMailGetReward(self.data.recordId)
        local params = {}
        params.bagIds = cardShowRewardList
        params.finishCallback = function() 
           
        end 
        ModelList.SeasonCardModel:OpenCardPackage(params)
    else 
        --发送领取事件
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,self.data.reward,function()
            ModelList.MailModel.C2S_RequestMailGetReward(self.data.recordId)
        end)
    end
  
end

--观看广告事件
function MailItemView:OnWatchAdClick()
  
    if _watchADUtility:IsAbleWatchAd(AD_EVENTS.AD_EVENTS_MAIL) then
        _watchADUtility:WatchVideo(self,self.WatchAdCallback,"MAIL_iNBOX")
    end 
end

--facebook登录事件
function MailItemView:OnFacebookClick()
    ModelList.loginModel.FbLogin(function(code)
        if code and code == RET.RET_ACCOUNT_BIND_NOT_CURRENT then
            UIUtil.show_common_error_popup(9037,true,function()
                ModelList.loginModel.user_logout()
            end)
        else
            UIUtil.show_common_error_popup(8010,true,nil)
        end
    end,function()
        ModelList.MailModel.C2S_RequestMailRead(self.data.recordId)
    end)
end

--更新事件
function MailItemView:OnUpdateClick()
    if not self.data then 
        return nil 
    end 

    if not self.data.recordId then 
        return nil 
    end 

    local mailInfo = ModelList.MailModel.GetUpdateMailCont(self.data.recordId)

    if not mailInfo then 
        return 
    end 

    if mailInfo.isUpdate == true then 
        if #self.data.reward <= 0 then 
            self:OnReadClick()
        else
            self:OnGetClick()
        end 
    else    
         --弹出去更新
        fun.OpenURL(mailInfo.URL)
    end 

end

function MailItemView:WatchAdCallback(isBreak)
    if isBreak then

    else
        if #self.data.reward <= 0 then 
            return 
        end 

        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,self.data.reward,function()
            ModelList.MailModel.C2S_RequestMailGetReward(self.data.recordId)
        end)
    end
end


--收集按钮响应
function MailItemView:on_btn_claim_click()
    if self.data ~= nil and self.data.type == EMAIL_TYPE.ADVERTISE_EMAIL then
        self._fsm:GetCurState():OnWatchAd(self._fsm)
    elseif self.data ~= nil and self.data.type == EMAIL_TYPE.REWARD_EMAIL then
        self._fsm:GetCurState():OnGetReward(self._fsm)
    elseif self.data ~= nil and self.data.type == EMAIL_TYPE.FACEBOOK_EMAIL then
        self._fsm:GetCurState():OnFaceBookGet(self._fsm)
    elseif self.data ~= nil and self.data.type == EMAIL_TYPE.UPDATE_EMAIL then
        self._fsm:GetCurState():OnUpdateGet(self._fsm)
    elseif self.data ~= nil and self.data.type == EMAIL_TYPE.POP_EMAIL then
        self._fsm:GetCurState():OnGetReward(self._fsm)
    elseif self.data ~= nil and self.data.type == EMAIL_TYPE.QUESTION_EMAIL then -- 问卷调查类型
        self._fsm:GetCurState():OnReadOrGet(self._fsm)
    else
        self._fsm:GetCurState():OnReadOrGet(self._fsm)
    end
end

return this