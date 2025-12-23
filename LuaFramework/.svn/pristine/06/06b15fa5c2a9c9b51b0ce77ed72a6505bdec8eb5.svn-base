local SeasonCardHelpView = BaseDialogView:New('SeasonCardHelpView', "SeasonCardHelper")
local this = SeasonCardHelpView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "btn_close",
    "Text1",
    "Text2",
    "Text3",
    "Text4",
    "Text5",
    "anima",
}

local descriptionIds = {
    30040, 30041, 0, 30042, 30043,
}

function SeasonCardHelpView:Awake()
end

function SeasonCardHelpView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
end

function SeasonCardHelpView:on_after_bind_ref()    
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"start", "SeasonCardHelpViewstart"}, false, function() 
            self:MutualTaskFinish()
        end)
    end

    self:DoMutualTask(task)
    self:InitView()
end

function SeasonCardHelpView:InitView()
    for i = 1, 5 do
        if descriptionIds[i] > 0 then
            local contentStr = Csv.GetData("description", descriptionIds[i], "description")
            self["Text" .. i].text = contentStr
        end
    end
    self.Text3.text = "=1xp"
end

function SeasonCardHelpView:OnDisable()
    Facade.RemoveViewEnhance(self)
end

function SeasonCardHelpView:CloseSelf()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"end", "SeasonCardHelpViewend"}, false, function()
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.HideDialog, self)
        end)
    end

    self:DoMutualTask(task)
end

function SeasonCardHelpView:on_btn_close_click()
    self:CloseSelf()
end

function SeasonCardHelpView:OnForceExit(params)
    self:CloseSelf()
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.SeasonCard.ForceExit, func = this.OnForceExit},
}

return this