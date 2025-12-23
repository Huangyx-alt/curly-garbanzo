local CarQuestHelpView = BaseDialogView:New('CarQuestHelperView', "CarQuestHelpAtlas")
local this = CarQuestHelpView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "btn_play",
    "anima",
    "Text1",
    "Text2",
    "Text3",
    "btn_close",
}

local descriptionIds = {
    30110, 30111, 30112,
}

function CarQuestHelpView:Awake()
end

function CarQuestHelpView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
end

function CarQuestHelpView:on_after_bind_ref()    
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"enter", "CarQuestHelperViewenter"}, false, function() 
            self:MutualTaskFinish()
        end)
    end

    self:DoMutualTask(task)
    self:InitView()
end

function CarQuestHelpView:InitView()
    for i = 1, 3 do
        if descriptionIds[i] > 0 then
            local contentStr = Csv.GetData("description", descriptionIds[i], "description")
            self["Text" .. i].text = contentStr
        end
    end
end

function CarQuestHelpView:OnDisable()
    Facade.RemoveViewEnhance(self)
end

function CarQuestHelpView:CloseSelf()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"end", "CarQuestHelperViewend"}, false, function()
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.HideDialog, self)
        end)
    end

    self:DoMutualTask(task)
end

function CarQuestHelpView:on_btn_play_click()
    self:CloseSelf()
end

function CarQuestHelpView:on_btn_close_click()
    self:CloseSelf()
end



--设置消息通知
this.NotifyEnhanceList =
{
}

return this