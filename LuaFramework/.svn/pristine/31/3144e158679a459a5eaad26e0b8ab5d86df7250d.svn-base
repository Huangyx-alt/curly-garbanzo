local HallofFameHelpView = BaseDialogView:New('HallofFameHelpView', "VolcanoMissionHelpAtlas")
local this = HallofFameHelpView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "anima",
    "btn_PlayNow",
    "btn_Close",
    "text1",
    "text2",
    "text3",
    "text4"
}

function HallofFameHelpView:Awake() end

function HallofFameHelpView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
end

function HallofFameHelpView:on_after_bind_ref()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"start", "TournamentExplainView_start"}, false, function()
            self:MutualTaskFinish()
        end)
    end

    self:DoMutualTask(task)
    self:InitView()
end

local DesIDs = {1925, 1926, 1927, 1928}
function HallofFameHelpView:InitView()
    table.each(DesIDs, function(desID, k)
        local contentStr = Csv.GetData("description", desID, "description")
        self["text" .. k].text = contentStr
    end)
end

function HallofFameHelpView:OnDisable()
    Facade.RemoveViewEnhance(self)
end

function HallofFameHelpView:CloseSelf()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"end", "TournamentExplainView_end"}, false, function()
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.HideDialog, self)
        end)
    end

    self:DoMutualTask(task)
end

function HallofFameHelpView:on_btn_Close_click()
    self:CloseSelf()
end

function HallofFameHelpView:on_btn_PlayNow_click()
    self:CloseSelf()
end

return this



