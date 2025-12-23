require "View/CommonView/RemainTimeCountDown"

local WinZoneConsoleView = BaseView:New("WinZoneConsoleView")
local this = WinZoneConsoleView

this.auto_bind_ui_items = {
    "anima",
    "dish",
    "text_reward",
    "jGeZi",
    "jGeZi2",
    "buff_time",
}

function WinZoneConsoleView:ResetInitState()
    self.isInit = false
end

function WinZoneConsoleView:Awake(obj)
    self:on_init()
end

function WinZoneConsoleView:OnEnable()
    Event.AddListener(EventName.Event_MaxBetrateEnableJackpot, self.OnMaxBetRateEnableJackpot, self)
    Event.AddListener(EventName.Event_WinZone_Item_Buff, self.OnWinZoneBuffChange, self)
    self:SetJackpotInfo()
    self:StartRemainTime()
end

function WinZoneConsoleView:OnDisable()
    Event.RemoveListener(EventName.Event_MaxBetrateEnableJackpot, self.OnMaxBetRateEnableJackpot, self)
    Event.RemoveListener(EventName.Event_WinZone_Item_Buff, self.OnWinZoneBuffChange, self)
end

function WinZoneConsoleView:OnDestroy()
    if self.remainTimeCountDown then
        self.remainTimeCountDown:StopCountDown()
        self.remainTimeCountDown = nil
    end
end

function WinZoneConsoleView:OnMaxBetRateEnableJackpot(betRate)
    AnimatorPlayHelper.Play(self.anima, { "jackpot_consolein", "WinZone_jackpot_consolein" }, false, nil)
    self:SetJackpotInfo()
end

function WinZoneConsoleView:OnWinZoneBuffChange()
    self:StartRemainTime()
end

function WinZoneConsoleView:SetJackpotInfo()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    local reward = Csv.GetData("city_play", playId, "jackpot_reward_new")
    if reward then
        --单卡价格
        local playCardCost = ModelList.CityModel:GetCostCoin(1)
        local BingoReward = Csv.GetBingoRewardOfPlayid(playId, 1) -- 只取单bingo
        BingoReward = BingoReward / 100 or 0
        local rewardValue = BingoReward * reward * playCardCost / 100  --做分层
        self.text_reward:SetValue(rewardValue)
    end

    local data, jackpotRuleId = ModelList.WinZoneModel:GetPlayReadyData()
    jackpotRuleId = data and data.jackpotRuleId or Csv.GetData("city_play", playId, "jackpot_rule_id")
    local jackpotData = Csv.GetData("jackpot", jackpotRuleId, "coordinate")
    if jackpotData and fun.is_not_null(self.jGeZi) then
        local img1 = self.jGeZi.sprite
        local img2 = self.jGeZi2.sprite
        local img_list = {}
        for i = 1, 25 do
            local tran = fun.get_child(self.dish, i - 1)
            local img = nil
            if tran then
                img = fun.get_component(tran, fun.IMAGE)
                img_list[i - 1] = img
            end
            if img then
                self:SetSprite(img, img2)
            end
        end
        for key, value in pairs(jackpotData) do
            if img_list[value - 1] then
                self:SetSprite(img_list[value - 1], img1)
            end
        end
    end
end

function WinZoneConsoleView:SetSprite(sprite, sprite2)
    if sprite.sprite.name ~= sprite2.name then
        sprite.sprite = sprite2
    end
end

function WinZoneConsoleView:StartRemainTime()
    if not self.buff_time then
        return
    end
    
    if self.remainTimeCountDown then
        self.remainTimeCountDown:StopCountDown()
    else
        self.remainTimeCountDown = RemainTimeCountDown:New()
    end
    
    local remainTime = ModelList.WinZoneModel:GetDoubleBuffRemainTime()
    if remainTime <= 0 then
        fun.set_active(self.buff_time.transform.parent, false)
    else
        fun.set_active(self.buff_time.transform.parent, true)
        remainTime = remainTime + 2
        self.remainTimeCountDown:StartCountDown(CountDownType.cdt3, remainTime, self.buff_time, function()
            if self then
                self:StartRemainTime()
            end
        end)
    end
end

return this
