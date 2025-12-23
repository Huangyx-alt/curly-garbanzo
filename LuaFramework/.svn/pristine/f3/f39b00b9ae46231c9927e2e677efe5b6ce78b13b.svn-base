require "View/CommonView/WatchADUtility"
require "View/CommonView/RemainTimeCountDown"

local BottomRegularlyAwardBaseState = require "State/BottomRegularlyAwardView/BottomRegularlyAwardBaseState"
local BottomRegularlyAwardOriginalState = require "State/BottomRegularlyAwardView/BottomRegularlyAwardOriginalState"
local BottomRegularlyAwardRawState = require "State/BottomRegularlyAwardView/BottomRegularlyAwardRawState"
local BottomRegularlyAwardMatureState = require "State/BottomRegularlyAwardView/BottomRegularlyAwardMatureState"
local BottomRegularlyAwardDisableState = require "State/BottomRegularlyAwardView/BottomRegularlyAwardDisableState"
local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"

local FunctionIconRegularlyAwardView = FunctionIconBaseView:New()
local this = FunctionIconRegularlyAwardView
this.viewType = CanvasSortingOrderManager.LayerType.None

local _watchADUtility = WatchADUtility:New(AD_EVENTS.AD_EVENTS_ACTIVITY_CD)

local remainTimeCountDown = RemainTimeCountDown:New()

this.auto_bind_ui_items = {
    "btn_RegularlyAward",
    "text_countdown",
    "btn_watch_video",
    "img_claim",
    "anima",
    "lock",
    "img_reddot",
    "text_timer",
}

local instance = nil

function FunctionIconRegularlyAwardView:New()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    instance = o
    return o
end

function FunctionIconRegularlyAwardView:Awake()
    self:on_init()
end

function FunctionIconRegularlyAwardView:OnEnable()
    this = self
    Facade.RegisterView(self)
    self:BuildFsm()
    self:CheckRemainTime()
end

function FunctionIconRegularlyAwardView:IsFunctionOpen()
    return ModelList.RouletteModel:IsRouletteUnlock()
end

function FunctionIconRegularlyAwardView:OnApplicationFocus(focus)
    if focus and self then
        self:CheckRemainTime()
    end
end

function FunctionIconRegularlyAwardView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("FunctionIconRegularlyAwardView", self, {
        BottomRegularlyAwardOriginalState:New(),
        BottomRegularlyAwardRawState:New(),
        BottomRegularlyAwardMatureState:New(),
        BottomRegularlyAwardDisableState:New()
    })
    self._fsm:StartFsm("BottomRegularlyAwardOriginalState")
end

function FunctionIconRegularlyAwardView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function FunctionIconRegularlyAwardView:IsAbleWatchAd()
    return _watchADUtility:IsAbleWatchAd()
end

function FunctionIconRegularlyAwardView.OnRefreshRoulette()
    this:CheckRemainTime()
end

function FunctionIconRegularlyAwardView:CheckRemainTime()
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

function FunctionIconRegularlyAwardView:CheckAd()

end

function FunctionIconRegularlyAwardView:SetUnLock()
    self.anima.enabled = true
    fun.set_active(self.lock, false)
    Util.SetImageColorGray(self.btn_RegularlyAward, false)
    Util.SetImageColorGray(self.img_claim, false)
end

function FunctionIconRegularlyAwardView:SetRaw()
    fun.set_active(self.btn_RegularlyAward.transform, false)
    fun.set_active(self.btn_watch_video.transform, true)
    fun.set_active(self.img_claim.transform, false)
    self:StartTimer()
end

function FunctionIconRegularlyAwardView:SetMature()
    remainTimeCountDown:StopCountDown()
    self.anima:Play("win")
    fun.set_active(self.btn_RegularlyAward.transform, true)
    fun.set_active(self.btn_watch_video.transform, false)
    fun.set_active(self.img_claim.transform, true)
    fun.set_active(self.text_timer, false)
    Util.SetUIImageGray(self.btn_RegularlyAward, false)
    --self.text_timer.text = ""
end

function FunctionIconRegularlyAwardView:SetDisable()
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

function FunctionIconRegularlyAwardView:CheckAdvert()
    if _watchADUtility:IsAbleWatchAd() then
        _watchADUtility:WatchVideo(self, self.WatchVideoCallback, "main_skiptime", "cd")
    else
        --self:ShowAwardView()
    end
end

function FunctionIconRegularlyAwardView:WatchVideoCallback(isBreak)
    if isBreak then
        self._fsm:GetCurState():AdBreakOut(self._fsm)
    else
        ModelList.RouletteModel:ResetRouletteInfo()
    end
end

function FunctionIconRegularlyAwardView:ShowAwardView()
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

function FunctionIconRegularlyAwardView:StartTimer()
    fun.set_active(self.text_timer, true)
    remainTimeCountDown:StartCountDown(CountDownType.cdt4, self._remainTime, self.text_countdown, function()
        self._fsm:GetCurState():Change2Mature(self._fsm)
    end, function()
        self._fsm:GetCurState():CheckAd(self._fsm)
    end)
end

function FunctionIconRegularlyAwardView:StartTimer_bigR()
    fun.set_active(self.text_timer, true)
    remainTimeCountDown:StartCountDown(CountDownType.cdt4, self._remainTime, self.text_countdown, function()
        self._fsm:GetCurState():Change2Mature(self._fsm)
    end, nil)
end

function FunctionIconRegularlyAwardView:OnDisable()
    Facade.RemoveView(self)
    remainTimeCountDown:StopCountDown()
end

function FunctionIconRegularlyAwardView:on_close()
end

function FunctionIconRegularlyAwardView:OnDestroy()
    self:Close()
end

function FunctionIconRegularlyAwardView:on_btn_RegularlyAward_click()
    if ModelList.RouletteModel:IsRouletteUnlock() then
        if CmdCommonList.CmdEnterCityPopupOrder.IsFinish() then
            self._fsm:GetCurState():ClickRegularlyAward(self._fsm)
        end
    else
        UISound.play("button_invalid")
        UIUtil.show_common_popup(8017, true)
    end
end

function FunctionIconRegularlyAwardView:on_btn_watch_video_click()
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

function FunctionIconRegularlyAwardView.OnWatchVideoCallback()
    instance._fsm:GetCurState():CliamRewardRespone(instance._fsm)
end

this.NotifyList =
{
    { notifyName = NotifyName.Roulette.RefreshRoulette,    func = this.OnRefreshRoulette },
    { notifyName = NotifyName.Roulette.WatchVideoCallback, func = this.OnWatchVideoCallback }
}

return this
