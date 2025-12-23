local CurrentVipAttributeView = BaseView:New("CurrentVipAttributeView","")

local this = CurrentVipAttributeView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
this.auto_bind_ui_items = {
    "btn_close",
    "btn_vip",
    "currentVipLevel",
    "nextVipLevel",
    "currentLevel",
    "nextLevel",
}

local CmdVipAttribute = require("Logic/PeripheralSystem/CmdVipAttribute")
local CmdLevelAttribute = require("Logic/PeripheralSystem/CmdLevelAttribute")

function CurrentVipAttributeView:Awake()
    self:on_init()
end

function CurrentVipAttributeView:OnEnable()
    Facade.RegisterView(self)
    self:InitVipView()
    self:InitLevelView()
end

function CurrentVipAttributeView:InitLevelView()
    self.cmdCurrentLevelAttrivute = CmdLevelAttribute:New()
    self.cmdNextLevelAttrivute = CmdLevelAttribute:New()
    local level = ModelList.PlayerInfoModel:GetLevel()
    self.cmdCurrentLevelAttrivute:OnCmdExecute(self.currentLevel , level)

    local nextLevel = ModelList.PlayerInfoModel.GetNextLevelAddLevel()
    self.cmdNextLevelAttrivute:OnCmdExecute(self.nextLevel , nextLevel)
end

function CurrentVipAttributeView:InitVipView()
    local currVipLv = ModelList.PlayerInfoModel:GetVIP()
    self.cmdCurrentVipAttribute = CmdVipAttribute.New()
    self.cmdNextVipAttribute = CmdVipAttribute.New()
    self.cmdCurrentVipAttribute :OnCmdExecute(self.currentVipLevel , currVipLv)
    
    local nextVipLevel = ModelList.PlayerInfoModel.GetNextVipAddLevel()
    self.cmdNextVipAttribute:OnCmdExecute(self.nextVipLevel , nextVipLevel)
end

function CurrentVipAttributeView:GetNextLevelAttr(level)
    local config = Csv.new_level
end

function CurrentVipAttributeView:OnDisable()
    Facade.RemoveView(self)

end

function CurrentVipAttributeView:OnDestroy()
    if self.cmdCurrentVipAttribute then
        self.cmdCurrentVipAttribute:CloseCmd()
        self.cmdCurrentVipAttribute = nil
    end
    if self.cmdNextVipAttribute then
        self.cmdNextVipAttribute:CloseCmd()
        self.cmdNextVipAttribute = nil
    end
    if self.cmdCurrentLevelAttrivute then
        self.cmdCurrentLevelAttrivute:CloseCmd()
        self.cmdCurrentLevelAttrivute = nil
    end
    if self.cmdNextLevelAttrivute then
        self.cmdNextLevelAttrivute:CloseCmd()
        self.cmdNextLevelAttrivute = nil
    end
end

function CurrentVipAttributeView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end

function CurrentVipAttributeView:on_btn_vip_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
    Facade.SendNotification(NotifyName.ShowUI,ViewList.ShopVipAttributeView)
end



this.NotifyList = {
}

return this

