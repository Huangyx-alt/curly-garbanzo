local Const = require "View/WinZone/WinZoneConst"
local DownloadUtility =  require "View/CommonView/DownloadUtility"

local WinZonePosterView = BaseDialogView:New('WinZonePosterView', "WinZonePosterAtlasInMain")
local this = WinZonePosterView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
this._cleanImmediately = true
fun.ExtendClass(this, fun.ExtendFunction.mutual)

local downloadUtilityInstance = DownloadUtility:New()

this.auto_bind_ui_items = {
    "btn_play",
    "btn_close",
    "toggle",
    "anima",
}

function WinZonePosterView:Awake()
end

function WinZonePosterView:OnEnable()
    self:ClearMutualTask()
    UISound.play("winzonePosterinmain")
end

function WinZonePosterView:on_after_bind_ref()
    self.luabehaviour:AddToggleChange(self.toggle.gameObject, function(target, check)
        self:OnToggleChange(target, check)
    end)

    local playerInfo = ModelList.PlayerInfoModel:GetUserInfo()
    local value = fun.read_value(Const.TODAY_NO_LONGER_POPUP .. playerInfo.uid, Const.PosterToggleDefault)
    self.toggle.isOn = value == 1
    if fun.is_not_null(self.anima) then
        local task = function()
            AnimatorPlayHelper.Play(self.anima, {"start", "WinZonePosterView_start"}, false, function() 
                self:MutualTaskFinish()
            end)
        end
        self:DoMutualTask(task)
    end
end

function WinZonePosterView:OnToggleChange(target, check)
    log.log("WinZonePosterView:OnToggleChange ", check)
    local playerInfo = ModelList.PlayerInfoModel:GetUserInfo()
    if check then
        fun.save_value(Const.TODAY_NO_LONGER_POPUP .. playerInfo.uid, 1)
    else
        fun.save_value(Const.TODAY_NO_LONGER_POPUP .. playerInfo.uid, 0)
    end
end

function WinZonePosterView:OnDisable()
    self.luabehaviour:RemoveClick(self.toggle.gameObject)
end

function WinZonePosterView:CloseSelf()
    if fun.is_not_null(self.anima) then
        local task = function()
            AnimatorPlayHelper.Play(self.anima, {"end", "WinZonePosterView_end"}, false, function()
                self:MutualTaskFinish()
                Facade.SendNotification(NotifyName.HideDialog, self)
                Event.Brocast(NotifyName.WinZone.PopupActivityPosterFinish)
            end)
        end

        self:DoMutualTask(task)
    else
        Facade.SendNotification(NotifyName.HideDialog, self)
        Event.Brocast(NotifyName.WinZone.PopupActivityPosterFinish)
    end
end

function WinZonePosterView:on_btn_close_click()
    if not ModelList.GuideModel:IsGuideComplete(65) then
        ModelList.GuideModel:OpenUI("WinZonePosterView")
    end
    self:CloseSelf()
end

-- function WinZonePosterView:on_btn_play_click()
--     self:CloseSelf()
-- end

---打开WinZone界面
function WinZonePosterView:on_btn_play_click()
    if not ModelList.GuideModel:IsGuideComplete(65) then
        ModelList.GuideModel:OpenUI("WinZonePosterView")
        self:CloseSelf()
        log.log("WinZonePosterView:on_btn_play_click() 有引导未完成")
        return
    end

    local modularId = 14
    local loadDefault, data = downloadUtilityInstance:CheckDownload(modularId)
    if loadDefault == 0 then    --要下载
        UIUtil.show_common_popup(8050, true, function()
            downloadUtilityInstance:NewNode(14, self.btn_play)
            self:CloseSelf()
        end)
        log.log("WinZonePosterView:on_btn_play_click() 未下载")
        return
    elseif loadDefault == 1 then --下载中
        self:CloseSelf()
        log.log("WinZonePosterView:on_btn_play_click() 下载中")
        return
    else

    end

    if not ModelList.WinZoneModel:IsVipLevelEnough() then
        UIUtil.show_common_popup(8039, true, function()
            self:CloseSelf()
        end)
        log.log("WinZonePosterView:on_btn_play_click() VIP不足")
    elseif not ModelList.WinZoneModel:IsPlayerLevelEnough() then
        UIUtil.show_common_popup(8038, true, function()
            self:CloseSelf()
        end)
        log.log("WinZonePosterView:on_btn_play_click() 等级不足")
    else
        if ModelList.WinZoneModel:HasRewardAndCannotRelive() then
            log.log("WinZonePosterView:on_btn_play_click() 有奖励待领取")--这里不做领取，大厅已经有对这种情况做了处理
            self:CloseSelf()
            return
        end
        ModelList.BattleModel.RequireModuleLua("WinZone")
        ---检查winzone是否正在进行中
        if self:CheckWinZoneNeedOpen() then
            local winzoneView = require("View/WinZone/WinZoneInPropgressView")
            Facade.SendNotification(NotifyName.ShowUI, winzoneView:New())
            Event.Brocast(NotifyName.WinZone.BreakPopupOrder)
            self:CloseSelf()
            log.log("WinZonePosterView:on_btn_play_click() 游戏进行中")
            return
        end
        local winzoneView = require("View/WinZone/WinZoneHelperView")
        Facade.SendNotification(NotifyName.ShowUI, winzoneView:New())
        Event.Brocast(NotifyName.WinZone.BreakPopupOrder)
        self:CloseSelf()
        log.log("WinZonePosterView:on_btn_play_click() 正常接拉起游戏")
    end
    SDK.BI_Event_Tracker("click_victorybeats", {vip_level = ModelList.PlayerInfoModel:GetVIP()})
end

function WinZonePosterView:CheckWinZoneNeedOpen()
    if ModelList.WinZoneModel:IsActivityValid() and ModelList.WinZoneModel:ShouldGotoGameHall() then
        return true
    end
    return false
end

return this