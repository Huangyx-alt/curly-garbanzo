local SeasonCardExchangeItem = BaseView:New("SeasonCardExchangeItem")
local this = SeasonCardExchangeItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "imgBox",
    "btn_exchange",
    "btn_info",
    "lbl_cost",
    "imgbg",
    "btn_box",
    "btn_clear_cd",
    "imgLock",
    "efglow1",
    "lbl_skip",
    "lbl_cost_diamond",
    "left_time",
    "left_time_txt",
}

function SeasonCardExchangeItem:New()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function SeasonCardExchangeItem:Awake()
end

function SeasonCardExchangeItem:OnEnable()
    Facade.RegisterViewEnhance(self)
end

function SeasonCardExchangeItem:on_after_bind_ref()
    self:InitItem()
    --Util.SetUIImageGray(self.go, true)
end

function SeasonCardExchangeItem:OnDisable()
    Facade.RemoveViewEnhance(self)
    self:RemoveTimer()
end

function SeasonCardExchangeItem:SetData(data)
    self.data = data
    self.index = data.index
    self.boxId = data.boxId
    self.boxInfo = ModelList.SeasonCardModel:GetBoxInfo(self.boxId)
    log.log("SeasonCardExchangeItem:SetData", data)
end

function SeasonCardExchangeItem:InitItem()
    if not self.data then
        return
    end

    self.lbl_cost.text = self.boxInfo.flexibleData.starNum
    --self.lbl_cost.text = boxInfo.fixedData.price

    self:UpdateCdState()
end

function SeasonCardExchangeItem:on_btn_exchange_click()
    log.log("SeasonCardExchangeItem:on_btn_exchange_click")
    local count = ModelList.SeasonCardModel:GetStarCount() or 0
    local cost = self.boxInfo.flexibleData.starNum
    if count >= cost then
        ModelList.SeasonCardModel:C2S_ReceiveTreasureBoxAward(self.boxId)
    else
        log.log("SeasonCardExchangeItem:on_btn_exchange_click - 星星不足")
        UIUtil.show_common_popup(
            30072, 
            true,
            function()

            end
        )
    end
end

function SeasonCardExchangeItem:on_btn_info_click()
    log.log("SeasonCardExchangeItem:on_btn_info_click")
    self:ShowBubble()
end

function SeasonCardExchangeItem:on_btn_box_click()
    log.log("SeasonCardExchangeItem:on_btn_box_click")
    self:ShowBubble()
end

function SeasonCardExchangeItem:on_btn_clear_cd_click()
    log.log("SeasonCardExchangeItem:btn_clear_cd")
    local diamondCount = ModelList.ItemModel.get_diamond()
    local diamondConsume = self:Time2Diamond(self.endTime)
    if diamondCount >= diamondConsume then
        UIUtil.show_common_popup(
            30044, 
            false,
            function()
                ModelList.SeasonCardModel:C2S_ResetBoxCD(self.boxId)
            end,
            function()
                log.log("SeasonCardExchangeItem:btn_clear_cd - cancel opt")
            end
        )
    else
        log.log("SeasonCardExchangeItem:btn_clear_cd - 钻石不足")
        UIUtil.show_common_popup(
            30045, 
            true,
            function()
                
            end
        )
    end
end

function SeasonCardExchangeItem:ShowBubble()
    local pos = fun.get_gameobject_pos(self.go, false)
    local rect = fun.get_component(self.go, fun.RECT)
    --pos.y = pos.y + rect.sizeDelta.y / 2 + 20
    local rewards = self.boxInfo.fixedData.item_description
    local params = {}
    params.pos = pos
    params.rewards = rewards
    params.packageIcon = self.boxInfo.fixedData.card_box_icon
    params.hasClownCard = self.index == 3 --当前条件如此
    Facade.SendNotification(NotifyName.SeasonCard.ShowExchangeBoxBubble, params)
end

function SeasonCardExchangeItem:OnReceiveTreasureBoxReward(params) 
    if params.boxId == self.boxId then
        --Facade.SendNotification(NotifyName.SeasonCard.ShowExchangeBoxBubble, params)
        self:UpdateCdState()
        params.index = self.index
        ViewList.SeasonCardOpenTreasureBoxView:SetData(params)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardOpenTreasureBoxView)
    else
        local expireTime = self.boxInfo.flexibleData.cd
        local currentTime = ModelList.SeasonCardModel:GetCurrentTime()
        local leftTime = expireTime - currentTime
        if leftTime > 0 then
            fun.set_active(self.efglow1, false)
        else
            self:GetStarCount()
        end
    end
    
end

function SeasonCardExchangeItem:UpdateCdState(params)
    local expireTime = self.boxInfo.flexibleData.cd
    local currentTime = ModelList.SeasonCardModel:GetCurrentTime()
    local leftTime = expireTime - currentTime
    if leftTime > 0 then
        fun.set_active(self.btn_exchange, false)
        fun.set_active(self.efglow1, false)
        fun.set_active(self.imgLock, true)
        fun.set_active(self.btn_clear_cd, true)

        Util.SetUIImageGray(self.imgBox.gameObject, true)
        self:UpdateDiamondCost(leftTime)
        self:StartCounting(leftTime)
    else
        fun.set_active(self.btn_exchange, true)
        fun.set_active(self.efglow1, true)
        fun.set_active(self.imgLock, false)
        fun.set_active(self.btn_clear_cd, false)

        self:GetStarCount()

        Util.SetUIImageGray(self.imgBox.gameObject, false)
        self:RemoveTimer()
    end

    Facade.SendNotification(NotifyName.SeasonCard.ExchangeCdChange)
end

function SeasonCardExchangeItem:GetStarCount()
    local count = ModelList.SeasonCardModel:GetStarCount() or 0
    local cost = self.boxInfo.flexibleData.starNum
    if count >= cost then
        fun.set_active(self.efglow1,true)
        local imgExchange=fun.get_component(self.btn_exchange,fun.IMAGE)
        imgExchange.sprite = AtlasManager:GetSpriteByName("CommonAtlas","tButton")
    else
        fun.set_active(self.efglow1,false)
        local imgExchange=fun.get_component(self.btn_exchange,fun.IMAGE)
        imgExchange.sprite = AtlasManager:GetSpriteByName("CommonAtlas","p_btn03an")
    end
end

function SeasonCardExchangeItem:StartCounting(leftTime)
    self.endTime = leftTime
    if self.endTime > 0 then
        self:RemoveTimer()
        self.loopTime = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
            if self.left_time_txt then
                self.left_time_txt.text = fun.SecondToStrFormat(self.endTime)
                self.endTime = self.endTime - 1
                self:UpdateDiamondCost(self.endTime)
                if self.endTime <= 0 then
                    self:UpdateCdState()
                end
            end
        end,nil,nil,LuaTimer.TimerType.UI)
    end
end

function SeasonCardExchangeItem:UpdateDiamondCost(leftTime)
    self.lbl_cost_diamond.text = self:Time2Diamond(leftTime)
end

function SeasonCardExchangeItem:Time2Diamond(leftTime)
    if not leftTime or leftTime <= 0 then
        return 0
    end

    local costParams = self.boxInfo.fixedData.remove_cd
    local price = math.ceil(leftTime / (costParams[1] / costParams[2]))

    --当前配置数据有问题，暂时先这么处理
    --[[
    local costParams = self.boxInfo.fixedData.remove_cd
    local price = math.ceil(leftTime / (costParams / 1))
    --]]
    return price
end

function SeasonCardExchangeItem:RemoveTimer()
    if self.loopTime then
        LuaTimer:Remove(self.loopTime)
        self.loopTime = nil
    end
end

function SeasonCardExchangeItem:OnReceiveClearBoxCdResult(params)
    if params.succ then
        if params.boxId == self.boxId then
            self:UpdateCdState()
        end
    else

    end
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.SeasonCard.ReceiveTreasureBoxReward, func = this.OnReceiveTreasureBoxReward},
    {notifyName = NotifyName.SeasonCard.ReceiveClearBoxCdResult, func = this.OnReceiveClearBoxCdResult},
}

return this