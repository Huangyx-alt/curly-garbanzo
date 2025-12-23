local SGMoneyBuildingInnerHelperView = BaseView:New("SGMoneyBuildingInnerHelperView", "SGMoneyBuildingInnerHelperAtlas")

local this = SGMoneyBuildingInnerHelperView
this.isCleanRes = true
this._cleanImmediately = true
this.viewType = CanvasSortingOrderManager.LayerType.PackageDialog
--this.viewType = CanvasSortingOrderManager.LayerType.None
this.auto_bind_ui_items = {
    "title1",
    "title2",
    "title3",
    "title4",
    "title5",
    "title6",
    "title7",
    "title8",
    "title9",
    "btn_play",
    "btn_close",
    "Toggle",
}

function SGMoneyBuildingInnerHelperView:New()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

function SGMoneyBuildingInnerHelperView:Awake()
    self:on_init()
    self.title1.text = Csv.GetDescription(191056)
    self.title2.text = Csv.GetDescription(191057)
    self.title3.text = Csv.GetDescription(191058)
    self.title4.text = Csv.GetDescription(191059)
    self.title5.text = Csv.GetDescription(191060)
    self.title6.text = Csv.GetDescription(191061)
    self.title7.text = Csv.GetDescription(191062)
    self.title8.text = Csv.GetDescription(191063)
    self.title9.text = Csv.GetDescription(191064)
end

function SGMoneyBuildingInnerHelperView:OnEnable()
    self.luabehaviour:AddToggleChange(self.Toggle.gameObject, function(target, check)
        self:OnToggleChange(target, check)
    end)
    self.Toggle.isOn = true
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    fun.save_value("SGMoneyBuildingInnerHelperView" .. playerInfo.uid, 1)
end

function SGMoneyBuildingInnerHelperView:OnDisable()
    self.luabehaviour:RemoveClick(self.Toggle.gameObject)
end

function SGMoneyBuildingInnerHelperView:OnToggleChange(target, check)
    log.log("SGMoneyBuildingInnerHelperView:OnToggleChange ", check)
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    if check then
        fun.save_value("SGMoneyBuildingInnerHelperView" .. playerInfo.uid, 1)
    else
        fun.save_value("SGMoneyBuildingInnerHelperView" .. playerInfo.uid, 0)
    end
end

function SGMoneyBuildingInnerHelperView:on_btn_play_click()
    Facade.SendNotification(NotifyName.CloseUI, self)
    --ViewList.SGMoneyBuildingInnerHelperView = nil
end

function SGMoneyBuildingInnerHelperView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI, self)
    --ViewList.SGMoneyBuildingInnerHelperView = nil
end

return this