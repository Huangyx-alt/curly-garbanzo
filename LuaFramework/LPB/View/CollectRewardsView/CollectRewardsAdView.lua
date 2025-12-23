local CollectRewardsView =  require "View/CollectRewardsView/CollectRewardsView"

local CollectRewardsAdView = CollectRewardsView:New("CollectRewardsAdView")
local this = CollectRewardsAdView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local _watchADUtility = nil
local _callback = nil
local _cacheBtnPos = nil

this.auto_bind_ui_items = {
    "content",
    "reward_item",
    "btn_collect1",
    "btn_collect2",
    "btn_collect3",
    "anima"
}

function CollectRewardsAdView:SetAdData(adData)
    _watchADUtility = adData
end

function CollectRewardsAdView:OnEnable(prams)
    getmetatable(self).OnEnable(self,prams)
    local isBigR = ModelList.regularlyAwardModel:CheckUserTypes()
    if isBigR or not _watchADUtility then
        self:OnAdForbiden()
    elseif not _watchADUtility:IsAbleWatchAd() then
        self:OnAdForbiden()
        self._timer = Timer.New(function()
            if not self:IsLifeStateDisable()
                and _watchADUtility
                and _watchADUtility:IsAbleWatchAd() then
                self:OnAdAvailable()
                self:StopTimer()
            end
        end,1,-1)
        self._timer:Start()
    end
end

function CollectRewardsAdView:StopTimer()
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end

function CollectRewardsAdView:OnDisable()
    getmetatable(self).OnDisable(self)
    self:StopTimer()
    _watchADUtility = nil
    _callback = nil
    _cacheBtnPos = nil
end

function CollectRewardsAdView:OnAdForbiden()
    _cacheBtnPos = fun.get_rect_anchored_position(self.btn_collect1)
    fun.set_active(self.btn_collect2,false)
    fun.set_active(self.btn_collect3,false)
    fun.set_active(self.btn_collect1,true)
    fun.set_rect_anchored_position_x(self.btn_collect1,0)
end

function CollectRewardsAdView:OnAdAvailable()
    if _cacheBtnPos then
        fun.set_active(self.btn_collect2,true)
        fun.set_active(self.btn_collect3,true)
        fun.set_active(self.btn_collect1,false)
        fun.set_rect_anchored_position_x(self.btn_collect1,_cacheBtnPos.x)
    end
end

function CollectRewardsAdView:on_btn_collect1_click()
    getmetatable(self).on_btn_collect_click(self)
    --Util.SetImageColorGray(self.btn_collect1,true)
end

function CollectRewardsAdView:on_btn_collect3_click()
    getmetatable(self).on_btn_collect_click(self)
    --Util.SetImageColorGray(self.btn_collect1,true)
end

function CollectRewardsAdView:on_btn_collect2_click()
    self._fsm:GetCurState():ExtraSpin(self._fsm)
end

function CollectRewardsAdView:OnExtraSpin()
    getmetatable(self).OnCollectReward(self)
    --Util.SetImageColorGray(self.btn_collect2,true)
end

function CollectRewardsAdView:CloseView(callback)
    _callback = callback
    self._fsm:GetCurState():Complete(self._fsm)
end

function CollectRewardsAdView:Finish()
    getmetatable(self).CloseView(self,function()
        if _callback then
            _callback(false)
        end
    end)
end

function CollectRewardsAdView:FinishNeedExtraSpin()
    getmetatable(self).CloseView(self,function()
        local isBigR = ModelList.regularlyAwardModel:CheckUserTypes()
        if not isBigR and _watchADUtility and _watchADUtility:IsAbleWatchAd() then
            if _callback then
                _callback(true)
             end
        else
            if _callback then
                _callback(false)
            end
        end
    end)
end

return this
