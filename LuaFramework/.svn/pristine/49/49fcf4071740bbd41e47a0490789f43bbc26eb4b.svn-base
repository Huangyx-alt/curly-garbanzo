local Const = require "View/WinZone/WinZoneConst"
local WinZoneRestartDialog = BaseDialogView:New('WinZoneRestartDialog', "WinZoneRestartAtlas")
local this = WinZoneRestartDialog
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
--this._cleanImmediately = true
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "btn_confirm",
    "panel1",
    "desc1",
    "anima",
    "btnText",
    "btn_close",
}

local descriptionIds = {
    8052,
    8053,
    8054,
}

function WinZoneRestartDialog:Awake()
end

function WinZoneRestartDialog:OnEnable()
    Facade.RegisterViewEnhance(self)
    Event.AddListener("MSG_NOT_RETURN", self.OnMsgNotReturn, self)
    self:ClearMutualTask()
    --self.lastSelectRoundType = ModelList.WinZoneModel:GetSelectRoundRecord() or 1
    UISound.play("winzoneTips")
end

function WinZoneRestartDialog:on_after_bind_ref()
    self:InitView()
end

function WinZoneRestartDialog:InitView()
    --[[
    for i = 1, #descriptionIds do
        if descriptionIds[i] > 0 then
            local contentStr = Csv.GetData("description", descriptionIds[i], "description")
            self["desc" .. i].text = contentStr
        end
    end
    --]]
    self.desc1.text = Csv.GetData("description", descriptionIds[self.showType] or descriptionIds[1] , "description")
    if self.showType == Const.ShowRestartDialogMode.upgrade then
        self.btnText.text = "JOIN NOW"
    elseif self.showType == Const.ShowRestartDialogMode.win then
        self.btnText.text = "TRY AGAIN!"
    elseif self.showType == Const.ShowRestartDialogMode.lose then
        self.btnText.text = "TRY AGAIN!"
    end

    if fun.is_not_null(self.anima) then
        local task = function()
            AnimatorPlayHelper.Play(self.anima, {"enter", "WinZoneRestartDialogstart"}, false, function()
                self:MutualTaskFinish()
            end)
        end

        self:DoMutualTask(task)
    end
end

function WinZoneRestartDialog:OnDisable()
    Facade.RemoveViewEnhance(self)
    Event.RemoveListener("MSG_NOT_RETURN", self.OnMsgNotReturn, self)
    Facade.SendNotification(NotifyName.WinZone.RestartDialogClose)
    self.showType = nil
    self.lastSelectRoundType = nil
end

function WinZoneRestartDialog:SetShowType(showType)
    self.showType = showType
end

function WinZoneRestartDialog:SetLastRoundType(roundType)
    self.lastSelectRoundType = roundType or ModelList.WinZoneModel:GetSelectRoundRecord() or 1
end

function WinZoneRestartDialog:CloseSelf(callback1)
    if fun.is_not_null(self.anima) then
        local task = function()
            if callback1 then
                callback1()
            end
            AnimatorPlayHelper.Play(self.anima, {"end", "WinZoneRestartDialogend"}, false, function()
                self:MutualTaskFinish()
                Facade.SendNotification(NotifyName.HideDialog, self)
            end)
        end

        self:DoMutualTask(task)
    else
        if callback1 then
            callback1()
        end
        Facade.SendNotification(NotifyName.HideDialog, self)
    end
end

function WinZoneRestartDialog:on_btn_confirm_click()
    log.log("WinZoneRestartDialog:on_btn_confirm_click 1", self.lastSelectRoundType)
    local task = function()
        log.log("WinZoneRestartDialog:on_btn_confirm_click 2", self.lastSelectRoundType)
        ModelList.WinZoneModel:C2S_VictoryBeatsJoin(self.lastSelectRoundType)
    end
    self:DoMutualTask(task)
end

function WinZoneRestartDialog:on_btn_close_click()
    self:CloseSelf(function()
        ModelList.BattleModel.RequireModuleLua("WinZone")
        Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneChooseRoundView)
    end)
end

function WinZoneRestartDialog:OnSelectRoundSucc(params)
    log.log("WinZoneRestartDialog:OnSelectRoundSucc", params)
    Event.Brocast(NotifyName.WinZone.BreakPopupChooseRoundOrder)
    Event.Brocast(NotifyName.WinZone.PopupChooseRoundFinish)
    self:MutualTaskFinish()
    self:CloseSelf()
    ViewList.WinZoneLobbyView:SetGameState(params.nextState)
    Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneLobbyView)
end

function WinZoneRestartDialog:OnSelectRoundFail(params)
    log.log("WinZoneRestartDialog:OnSelectRoundFail some thing error ", params)
    self:MutualTaskFinish()
    if params.errorCode == 16 then --参数错误，没有达到用户等级、vip等级、加入没有解锁的轮制
        self:CloseSelf()
    elseif params.errorCode == RET.RET_ACTIVITY_NOT_ALLOWED then --7001 未完成上一次游戏，不能重复游戏 (有奖励未领取，上一次游戏还在进行中)
        self:CloseSelf()
    end
end

function WinZoneRestartDialog:OnMsgNotReturn(code)
    log.log("WinZoneRestartDialog:OnMsgNotReturn(code)", code)
    if code == MSG_ID.MSG_VICTORY_BEATS_JOIN then
        self:MutualTaskFinish()
    end
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.WinZone.SelectRoundSucc, func = this.OnSelectRoundSucc},
    {notifyName = NotifyName.WinZone.SelectRoundFail, func = this.OnSelectRoundFail},
}

return this