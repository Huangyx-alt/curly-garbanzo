local Const = require "View/WinZone/WinZoneConst"
local WinZonePromoteTipView = BaseDialogView:New('WinZonePromoteTipView', "WinZonePromoteAtlas")
local this = WinZonePromoteTipView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
--this._cleanImmediately = true
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "btn_confirm",
    "panel1",
    "panel2",
    "desc1",
    "desc2",
    "anima",
}

local descriptionIds = {
    8041, 8040,
}

local startAnimParams = nil
local endAnimParams = nil

function WinZonePromoteTipView:Awake()
end

function WinZonePromoteTipView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
end

function WinZonePromoteTipView:on_after_bind_ref()
    self:InitView()
end

function WinZonePromoteTipView:InitView()
    ---[[
    for i = 1, #descriptionIds do
        if descriptionIds[i] > 0 then
            local contentStr = Csv.GetData("description", descriptionIds[i], "description")
            self["desc" .. i].text = contentStr
        end
    end
    --]]

    startAnimParams = {}
    endAnimParams = {}
    if self.showType == Const.ShowPromoteTipTypes.fail then
        fun.set_active(self.panel1, true)
        fun.set_active(self.panel2, false)
        startAnimParams[1] = "start1"
        startAnimParams[2] = "WinZonePromoteTipView_start1"
        endAnimParams[1] = "end1"
        endAnimParams[2] = "WinZonePromoteTipView_end1"
    else
        fun.set_active(self.panel1, false)
        fun.set_active(self.panel2, true)
        startAnimParams[1] = "start2"
        startAnimParams[2] = "WinZonePromoteTipView_start2"
        endAnimParams[1] = "end2"
        endAnimParams[2] = "WinZonePromoteTipView_end2"
        UISound.play("winzonePpromotion")
        UISound.play("winzoneNextround")
    end

    if fun.is_not_null(self.anima) then
        local task = function()
            AnimatorPlayHelper.Play(self.anima, {startAnimParams[1], startAnimParams[2]}, false, function()
                self:MutualTaskFinish()
            end)
        end

        self:DoMutualTask(task)
    end
end

function WinZonePromoteTipView:OnDisable()
    Facade.RemoveViewEnhance(self)
    Facade.SendNotification(NotifyName.WinZone.ClosePromoteTip, self.showType)
    self.showType = nil
    startAnimParams = nil
    endAnimParams = nil
end

function WinZonePromoteTipView:SetShowType(showType)
    self.showType = showType
end

function WinZonePromoteTipView:CloseSelf()
    if fun.is_not_null(self.anima) and endAnimParams then
        local task = function()
            AnimatorPlayHelper.Play(self.anima, {endAnimParams[1], endAnimParams[2]}, false, function()
                self:MutualTaskFinish()
                Facade.SendNotification(NotifyName.HideDialog, self)
            end)
        end

        self:DoMutualTask(task)
    else
        Facade.SendNotification(NotifyName.HideDialog, self)
    end
end

function WinZonePromoteTipView:on_btn_confirm_click()
    self:CloseSelf()
end

--设置消息通知
this.NotifyEnhanceList =
{
}

return this