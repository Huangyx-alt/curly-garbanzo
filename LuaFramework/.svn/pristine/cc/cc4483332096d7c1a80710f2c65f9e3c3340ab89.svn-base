local CarQuestRoadUnit = BaseView:New("CarQuestRoadUnit")
local this = CarQuestRoadUnit
this.viewType = CanvasSortingOrderManager.LayerType.none

this.auto_bind_ui_items = {
    "startPoint",
    "numRoot",
    "imgStartLine",
    "imgNum1",
    "imgNum2",
    "imgNum3",
    "imgNum4",
    "imgNum5",
    "imgSpecial"
}

function CarQuestRoadUnit:New()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function CarQuestRoadUnit:Awake()
end

function CarQuestRoadUnit:OnEnable()
    Facade.RegisterViewEnhance(self)
    self.isSelected = false
end

function CarQuestRoadUnit:on_after_bind_ref()
    fun.set_active(self.startPoint, false)
    self:InitItem()
end

function CarQuestRoadUnit:OnDisable()
    Facade.RemoveViewEnhance(self)
end

function CarQuestRoadUnit:SetData(data)
    self.data = data
    self.view = data.view
    self.index = data.index or 0
end

function CarQuestRoadUnit:UpdateData(data)
    self.data = data
    self.index = data.index or 0
    self:InitItem()
end

function CarQuestRoadUnit:InitItem()
    fun.set_active(self.startPoint, false)
end

function CarQuestRoadUnit:ShowStartLine()
    if self.index == 1 then
        fun.set_active(self.startPoint, true)
    else
        fun.set_active(self.startPoint, false)
    end
end

function CarQuestRoadUnit:ShowUpgradeFlag()
    fun.set_active(self.imgSpecial, true)
end

function CarQuestRoadUnit:HideUpgradeFlag()
    fun.set_active(self.imgSpecial, false)
end

--设置消息通知
this.NotifyEnhanceList =
{
    --{notifyName = NotifyName.ZipResDownload.StartDownload, func = this.OnStartDownload},
}

return this