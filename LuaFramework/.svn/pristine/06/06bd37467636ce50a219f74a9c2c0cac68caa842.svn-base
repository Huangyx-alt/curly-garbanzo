require "View/CommonView/WatchADUtility"
require "View/CommonView/RemainTimeCountDown"

local BottomRegularlyAwardBaseState = require "State/BottomRegularlyAwardView/BottomRegularlyAwardBaseState"
local BottomRegularlyAwardOriginalState = require "State/BottomRegularlyAwardView/BottomRegularlyAwardOriginalState"
local BottomRegularlyAwardRawState = require "State/BottomRegularlyAwardView/BottomRegularlyAwardRawState"
local BottomRegularlyAwardMatureState = require "State/BottomRegularlyAwardView/BottomRegularlyAwardMatureState"
local BottomRegularlyAwardDisableState = require "State/BottomRegularlyAwardView/BottomRegularlyAwardDisableState"

local BottomRegularlyAwardView = BaseView:New("BottomRegularlyAwardView")
local this = BottomRegularlyAwardView
this.viewType = CanvasSortingOrderManager.LayerType.None

local _watchADUtility = WatchADUtility:New(AD_EVENTS.AD_EVENTS_ACTIVITY_CD)

local remainTimeCountDown = RemainTimeCountDown:New()

this.auto_bind_ui_items = {
    "btn_RegularlyAward",
    "text_timer",
    "btn_watch_video",
    "img_claim",
    "lock",
    "anima"
}

local instance = nil

function BottomRegularlyAwardView:New()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    instance = o
    return o
end

function BottomRegularlyAwardView:Awake()
    self:on_init()
end

function BottomRegularlyAwardView:OnEnable()
    this = self
    Facade.RegisterView(self)
    self:BuildFsm()
    self:CheckRemainTime()
end

function BottomRegularlyAwardView:OnApplicationFocus(focus)
    if focus and self then
        self:CheckRemainTime()
    end
end

function BottomRegularlyAwardView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("BottomRegularlyAwardView", self, {
        BottomRegularlyAwardOriginalState:New(),
        BottomRegularlyAwardRawState:New(),
        BottomRegularlyAwardMatureState:New(),
        BottomRegularlyAwardDisableState:New()
    })
    self._fsm:StartFsm("BottomRegularlyAwardOriginalState")
end

function BottomRegularlyAwardView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function BottomRegularlyAwardView:IsAbleWatchAd()
    return _watchADUtility:IsAbleWatchAd()
end

function BottomRegularlyAwardView.OnRefreshRoulette()
    this:CheckRemainTime()
end

function BottomRegularlyAwardView:CheckRemainTime()
    if ModelList.RouletteModel:IsRouletteUnlock() then
        self._remainTime = ModelList.RouletteModel:GetRemainTime()
        if self._remainTime <= 0 then
            self._fsm:GetCurState():Change2Mature(self._fsm)
        else
            local isBigR = ModelList.regularlyAwardModel:CheckUserTypes()
            if isBigR then
                self._fsm:GetCurState():ChangeDisable(self._fsm)
            else
                local abActive = _watchADUtility:IsAbleWatchAd()
                if abActive then
                    self._fsm:GetCurState():Change2Raw(self._fsm)
                else
                    self._fsm:GetCurState():ChangeDisable(self._fsm)
                end
            end
        end
    end
end

function BottomRegularlyAwardView:CheckAd()

end

function BottomRegularlyAwardView:SetUnLock()
    self.anima.enabled = true
    fun.set_active(self.lock, false)
    Util.SetImageColorGray(self.btn_RegularlyAward, false)
    Util.SetImageColorGray(self.img_claim, false)
end

function BottomRegularlyAwardView:SetRaw()
    fun.set_active(self.btn_RegularlyAward.transform, false)
    fun.set_active(self.btn_watch_video.transform, true)
    fun.set_active(self.img_claim.transform, false)
    self:StartTimer()
end

function BottomRegularlyAwardView:SetMature()
    remainTimeCountDown:StopCountDown()
    self.anima:Play("win")
    fun.set_active(self.btn_RegularlyAward.transform, true)
    fun.set_active(self.btn_watch_video.transform, false)
    fun.set_active(self.img_claim.transform, true)
    fun.set_active(self.text_timer, false)
    Util.SetUIImageGray(self.btn_RegularlyAward, false)
    --self.text_timer.text = ""
end

function BottomRegularlyAwardView:SetDisable()
    self.anima:Play("idle")
    fun.set_active(self.btn_RegularlyAward.transform, true)
    fun.set_active(self.btn_watch_video.transform, false)
    fun.set_active(self.img_claim.transform, false)
    Util.SetUIImageGray(self.btn_RegularlyAward, true)
    if ModelList.regularlyAwardModel:CheckUserTypes() then
        self:StartTimer_bigR()
    else
        self:StartTimer()
    end
end

function BottomRegularlyAwardView:CheckAdvert()
    if _watchADUtility:IsAbleWatchAd() then
        _watchADUtility:WatchVideo(self, self.WatchVideoCallback, "main_skiptime", "cd")
    else
        --self:ShowAwardView()
    end
end

function BottomRegularlyAwardView:WatchVideoCallback(isBreak)
    if isBreak then
        self._fsm:GetCurState():AdBreakOut(self._fsm)
    else
        ModelList.RouletteModel:ResetRouletteInfo()
    end
end

function BottomRegularlyAwardView:ShowAwardView()
    --Facade.SendNotification(NotifyName.HallCity.Function_icon_click,"RegularlyAwardInfoView",true)
    if ModelList.RouletteModel:GetRouletteInfo() ~= nil then
        Facade.SendNotification(NotifyName.ShowUI, ViewList.RouletteView)
    else
        ModelList.RouletteModel.C2S_RequestRouletteInfo(function()
            if ModelList.RouletteModel:GetRouletteInfo() ~= nil then
                Facade.SendNotification(NotifyName.ShowUI, ViewList.RouletteView)
            end
        end)
    end
end

function BottomRegularlyAwardView:StartTimer()
    fun.set_active(self.text_timer, true)
    remainTimeCountDown:StartCountDown(CountDownType.cdt4, self._remainTime, self.text_timer, function()
        self._fsm:GetCurState():Change2Mature(self._fsm)
    end, function()
        self._fsm:GetCurState():CheckAd(self._fsm)
    end)
end

function BottomRegularlyAwardView:StartTimer_bigR()
    fun.set_active(self.text_timer, true)
    remainTimeCountDown:StartCountDown(CountDownType.cdt4, self._remainTime, self.text_timer, function()
        self._fsm:GetCurState():Change2Mature(self._fsm)
    end, nil)
end

function BottomRegularlyAwardView:OnDisable()
    Facade.RemoveView(self)
    remainTimeCountDown:StopCountDown()
end

function BottomRegularlyAwardView:on_close()
end

function BottomRegularlyAwardView:OnDestroy()
    self:Close()
end

function BottomRegularlyAwardView:on_btn_RegularlyAward_click()
    if ModelList.RouletteModel:IsRouletteUnlock() then
        if CmdCommonList.CmdEnterCityPopupOrder.IsFinish() then
            self._fsm:GetCurState():ClickRegularlyAward(self._fsm)
        end
    else
        UISound.play("button_invalid")
        UIUtil.show_common_popup(8017, true)
    end
end

function BottomRegularlyAwardView:on_btn_watch_video_click()
    --by LwangZg SDK相关 TODO
    -- local abActive = _watchADUtility:IsAbleWatchAd()
    -- if abActive then
    --     self._fsm:GetCurState():ClickRegularlyAward(self._fsm)
    -- else
    --     --Ad has not prepared yet
    --     UIUtil.show_common_popup(9024, true)
    -- end
    UIUtil.show_common_popup(9024, true)
end

function BottomRegularlyAwardView.OnWatchVideoCallback()
    instance._fsm:GetCurState():CliamRewardRespone(instance._fsm)
end

this.NotifyList =
{
    { notifyName = NotifyName.Roulette.RefreshRoulette,    func = this.OnRefreshRoulette },
    { notifyName = NotifyName.Roulette.WatchVideoCallback, func = this.OnWatchVideoCallback }
}

return this
