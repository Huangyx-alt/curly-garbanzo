local TopMenuView = BaseView:New("TopMenuView")
local this = TopMenuView
this.viewType = CanvasSortingOrderManager.LayerType.None
this.auto_bind_ui_items ={
    "btn_click_gamerule",
    "btn_click_inbox",
    "btn_click_setting",
    "btn_click_home",
    "btn_mask",
    "btn_back",

    "GameRule",
    "Inbox",
    "Setting",
    "Home",
    "bg",
    "inboxRed",
}

local click_interval = 0
local topDistance = 55
local itemGridHeight = 120
local itemGridOffsetDistance = 10

function TopMenuView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function TopMenuView:Awake()
    self:on_init()
    click_interval = 0
end

function TopMenuView:OnEnable(showType)
    if showType == BingoBangEntry.topMenuShowType.Home then
        self:ShowHome()
    elseif showType == BingoBangEntry.topMenuShowType.MachineLobby then
        self:ShowMachineLobby()
    else
        log.r("未知的打开状态 ", showType)
    end
    fun.play_animator(self.go, "enter", true)

    self:InitRed()
end

function TopMenuView:InitRed()
    local tb =ModelList.MailModel.getMailItemListbyTime()
    local mailExist = false
    for k ,v in pairs(tb) do
        if v then
            if not v.isRead or not v.isReceive then
                mailExist = true
                break
            end
        end
    end
    fun.set_active(self.inboxRed , mailExist)
end

function TopMenuView:ShowHome()
    fun.set_active(self.GameRule, false)
    fun.set_active(self.Inbox, true)
    fun.set_active(self.Setting, true)
    fun.set_active(self.Home, false)
    local itemList = {self.Inbox , self.Setting}
    self:ResetItemView(itemList)
end

function TopMenuView:ShowMachineLobby()
    fun.set_active(self.GameRule, true)
    fun.set_active(self.Inbox, true)
    fun.set_active(self.Setting, true)
    fun.set_active(self.Home, true)
    local itemList = {self.GameRule,self.Inbox , self.Setting , self.Home}
    self:ResetItemView(itemList)
end

function TopMenuView:ResetItemView(itemList)
    local num = GetTableLength(itemList)
    --bg.
    local bgSizeDelta = fun.get_rect_delta_size(self.bg)
    local bgHeight = topDistance + itemGridHeight * num + itemGridOffsetDistance * (num - 1)
    fun.set_recttransform_native_size(self.bg, bgSizeDelta.x, bgHeight)

    for i =1 , num do
        local item = itemList[i]
        local ref = fun.get_component(item, fun.REFER)
        local line = ref:Get("line")
        if i == num then
            fun.set_active(line, false)
        else
            fun.set_active(line, true)
        end
        local pos = - (topDistance + itemGridHeight * (i-1) + itemGridOffsetDistance * (i-1))
        item.transform.localPosition =  Vector2.New(3.6 , pos)
        fun.SetAsLastSibling(item)
    end
end

function TopMenuView:on_btn_click_gamerule_click()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    local helpSetting = Csv.GetData("new_game_help_setting", playId)
    local assetviewName = helpSetting.asset_viewname
    if assetviewName == "0" then
        return
    end
    
    local HallExplainHelpView = require "View/CommonView/HallExplainHelpView"
    Cache.load_prefabs(AssetList[assetviewName], assetviewName, function(obj)
        local root = HallExplainHelpView:GetRootView()
        local gameObject = fun.get_instance(obj, root)
        HallExplainHelpView:SkipLoadShow(gameObject)
    end)
    
    self:HideGameObject()
end

function TopMenuView:on_btn_click_inbox_click()
    self:HideGameObject()
    Facade.SendNotification(NotifyName.ShowUI,ViewList.MailView)
end

function TopMenuView:on_btn_mask_click()
    self:HideGameObject()
end

function TopMenuView:on_btn_back_click()
    self:HideGameObject()
end

function TopMenuView:on_btn_click_setting_click()
    Facade.SendNotification(NotifyName.ShowUI,ViewList.SettingView)
    self:HideGameObject()
end

function TopMenuView:on_btn_click_home_click()
    if os.time() - click_interval > 0.5 then
        click_interval = os.time()
        local topbar_view = GetCurrentTopBarView()
        if topbar_view then
            topbar_view:CloseTopBarParent(BingoBangEntry.exitMachineLobbyType.ClickBackHome)
        else
            Facade.SendNotification(NotifyName.Common.GoBackClick)
        end
    end
    self:HideGameObject()
end

function TopMenuView:HideGameObject()
    Facade.SendNotification(NotifyName.CloseUI, self)
end

function TopMenuView:OnDisable()
    click_interval = 0
end

function TopMenuView:OnDestroy()
    
end

return TopMenuView