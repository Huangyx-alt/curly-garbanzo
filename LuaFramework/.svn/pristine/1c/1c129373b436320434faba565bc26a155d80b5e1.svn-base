local SeasonCardGalleryItem = require "View/SeasonCard/SeasonCardGalleryItem"
local SeasonCardClownCard = require "View/SeasonCard/SeasonCardClownCard"
local SeasonCardFeatureView = BaseDialogView:New('SeasonCardFeatureView')
local this = SeasonCardFeatureView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "btn_close",
    "txtDescription1",
    "btn_collect",
    "displayRoot",
    "exchangeRoot",
    "CardItem",
    "scaleRoot1",
    "scaleRoot2",
    "CardItem1",
    "CardItem2",
    "txtDescription2",
    "anima",
    "btn_mask",
    "left_time",
    "left_time_txt",
}

this.PurposeType = {
    display = 1,
    playAnimation = 2,
}

local animParamList = {
    {"startdisplay", "SeasonCardFeatureViewstartdisplay"},
    {"startexchange", "SeasonCardFeatureViewstartexchange"},
    {"change", "SeasonCardFeatureViewchange"},
    {"enddisplay", "SeasonCardFeatureViewenddisplay"},
    {"endexchange", "SeasonCardFeatureViewendexchange"},
    {"changeend", "SeasonCardFeatureViewchangeend"},
}

function SeasonCardFeatureView:Awake()
end

function SeasonCardFeatureView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
end

function SeasonCardFeatureView:on_after_bind_ref()
    self:PlayEnterAnima()
    self:InitView()
end

function SeasonCardFeatureView:OnDisable()
    Facade.RemoveViewEnhance(self)
    self:RemoveClownCardTimer()
    self.waitExchangeCard = nil
end

function SeasonCardFeatureView:PlayEnterAnima()
    local animParams = self:GetStartAnimaParams()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, animParams, false, function()
            self:MutualTaskFinish()
        end)
    end

    self:DoMutualTask(task)

    if self.purpose == self.PurposeType.playAnimation then
        UISound.play("card_joker")
    end
end

function SeasonCardFeatureView:IsShowing()
    return self.isShow
end

function SeasonCardFeatureView:SetData(data)
    self.cardInfo = data.cardInfo
    self.purpose = data.purpose
    self.seasonId = data.seasonId
end

function SeasonCardFeatureView:GetStartAnimaParams()
    if self.purpose == self.PurposeType.playAnimation then
        return animParamList[3]
    else
        if self:CanExchange() then
            return animParamList[2]
        else
            return animParamList[1]
        end
    end
end

function SeasonCardFeatureView:GetEndAnimaParams()
    if self.purpose == self.PurposeType.playAnimation then
        return animParamList[6]
    else
        if self:CanExchange() then
            return animParamList[5]
        else
            return animParamList[4]
        end
    end
end

function SeasonCardFeatureView:CanExchange()
    if ModelList.SeasonCardModel:GetShowingSeasonId() == ModelList.SeasonCardModel:GetCurSeasonId() then
        return self.cardInfo.flexibleData.collectNum < 1 and ModelList.SeasonCardModel:IsHasClownCard()
    end
end

function SeasonCardFeatureView:InitView()
    fun.set_active(self.btn_close, false)
    fun.set_active(self.displayRoot, false)
    fun.set_active(self.exchangeRoot, false)
    fun.set_active(self.CardItem, true)
    fun.set_active(self.CardItem1, true)
    fun.set_active(self.CardItem2, true)

    if self:CanExchange() or self.purpose == self.PurposeType.playAnimation then
        self:InitExchange()
    else
        self:InitDisplay()
    end
end

function SeasonCardFeatureView:InitDisplay()
    fun.set_active(self.displayRoot, true)
    self:CreateCardItem(self.CardItem)
    local descId = 30089
    if self.cardInfo.flexibleData.collectNum < 1 then
        descId = 30090
    end
    self.txtDescription1.text = Csv.GetDescription(descId)
end

function SeasonCardFeatureView:InitExchange()
    local descId = 30093
    self.txtDescription2.text = Csv.GetDescription(descId)
    fun.set_active(self.exchangeRoot, true)
    self:CreateClownCardItem(self.CardItem1)
    self.waitExchangeCard = self:CreateCardItem(self.CardItem2)
    self:SetClownCardLeftTime()
    fun.set_active(self.left_time, self.purpose ~= self.PurposeType.playAnimation)
end

function SeasonCardFeatureView:CreateCardItem(itemGo)
    local item = SeasonCardGalleryItem:New()
    local data = {parent = self, cardId = self.cardInfo.cardId, seasonId = self.seasonId}
    item:SetData(data)
    item:SetOnlyShowBasicInfo()
    item:SkipLoadShow(itemGo)
    item:SetClickEnable(false)
    item:UpdateGrayState()
    item:UpdateRewardState()
    return item
end

function SeasonCardFeatureView:CreateClownCardItem(itemGo)
    local item = SeasonCardClownCard:New()
    local data = {parent = self, cardId = ModelList.SeasonCardModel:GetClownCardId()}
    item:SetData(data)
    item:SetOnlyShowBasicInfo()
    item:SkipLoadShow(itemGo)
    item:SetClickEnable(false)
    return item
end

function SeasonCardFeatureView:SetClownCardLeftTime()
    local expireTime = ModelList.SeasonCardModel:GetSoonestClownCardExpire()
    local currentTime = ModelList.SeasonCardModel:GetCurrentTime()
    self.clownCardEndTime = expireTime - currentTime
    self:RemoveClownCardTimer()
    if self.clownCardEndTime > 0 then
        self.clownCardLoopTime = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
            if self.clownCardEndTime >= 0 and self.left_time_txt then
                self.left_time_txt.text = fun.SecondToStrFormat(self.clownCardEndTime)
                self.clownCardEndTime = self.clownCardEndTime - 1
                if self.clownCardEndTime <= 0 then
                    --self:on_btn_close_click()
                end
            end
        end,nil,nil,LuaTimer.TimerType.UI)
    end
end

function SeasonCardFeatureView:RemoveClownCardTimer()
    if self.clownCardLoopTime then
        LuaTimer:Remove(self.clownCardLoopTime)
        self.clownCardLoopTime = nil
    end
end

function SeasonCardFeatureView:CloseSelf()
    local task = function()
        local animParams = self:GetEndAnimaParams()
        AnimatorPlayHelper.Play(self.anima, animParams, false, function()
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.HideDialog, self)
        end)
    end

    self:DoMutualTask(task)
end

function SeasonCardFeatureView:on_btn_close_click()
    self:CloseSelf()
end

function SeasonCardFeatureView:on_btn_collect_click()
    if self:CanExchange() and self.purpose == self.PurposeType.display then
        ModelList.SeasonCardModel:C2S_ClownCardExchange(self.cardInfo.cardId)
    else
        self:CloseSelf()
    end
end

function SeasonCardFeatureView:on_btn_mask_click()
    if self.purpose == self.PurposeType.display and self:CanExchange() then
        return
    end
    self:CloseSelf()
end

function SeasonCardFeatureView:OnReceiveClownCardExchangeResult(params)
    self.cardInfo = params.cardInfo
    self.purpose = self.PurposeType.playAnimation
    fun.set_active(self.left_time, false)
    if self.waitExchangeCard then
        self.waitExchangeCard:UpdateGrayState()
    end
    self:PlayEnterAnima()
end


function SeasonCardFeatureView:OnForceExit(params)
    self:CloseSelf()
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.SeasonCard.ReceiveClownCardExchangeResult, func = this.OnReceiveClownCardExchangeResult},
    {notifyName = NotifyName.SeasonCard.ForceExit, func = this.OnForceExit},
}

return this