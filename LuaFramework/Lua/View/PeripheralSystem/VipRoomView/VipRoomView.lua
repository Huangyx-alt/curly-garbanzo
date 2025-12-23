local VipRoomView = BaseView:New("VipRoomView")
local this = VipRoomView
this.viewType = CanvasSortingOrderManager.LayerType.None
this.auto_bind_ui_items ={
    --"btn_item_1",
    --"btn_item_2",
    --"btn_item_3",
    "item1",
    "item2", 
    "item3",
}


local VipRoomItem = require "View/PeripheralSystem/VipRoomView/VipRoomItem"

local click_interval = 0

function VipRoomView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function VipRoomView:Awake()
    self:on_init()
    click_interval = 0
end

function VipRoomView:OnEnable()
    if GetTableLength(self.itemList) > 0 then
        return
    end
    self:RegEvent()
    self.go.transform.localScale = Vector3.New(1,1,1)
    self.itemList = self.itemList or {}
    
    local config = Csv.new_city_play_feature
    for i  = 1 , 3 do
        local itemPrefab = self["item" .. i]
        local data = config[i]
        local view = VipRoomItem:New(data,self)
        view:SkipLoadShow(itemPrefab)
        self.itemList[i] = view
    end
end

function VipRoomView:RegEvent()
    Event.AddListener(EventName.Event_UpdateRoleInfo,self.OnUpdateRoleInfo,self)
end

function VipRoomView:UnRegEvent()
    Event.RemoveListener(EventName.Event_UpdateRoleInfo,self.OnUpdateRoleInfo)
end

function VipRoomView:OnUpdateRoleInfo()
    if GetTableLength(self.itemList) > 0 then
        for k, v in pairs(self.itemList) do
            v:RefreshItem()
        end
    end
end


function VipRoomView:HideVipRoom()
    fun.set_active(self.go , false)
end

function VipRoomView:ShowVipRoom()
    fun.set_active(self.go , true)
end

function VipRoomView:OnDisable()
end

function VipRoomView:OnDestroy()
    self:UnRegEvent()
end


function VipRoomView:OnBtnItemplayClick(data)
    log.log("进入机台数据 " ,data)

    if not self:CheckValidFeature(data) then
        local tip = Csv.GetDescription(85007) or "Activity is End !!"
        UIUtil.show_common_popup_with_options({
            isSingleBtn = true,
            contentText = tip,
        })
        return
    end

    if ModelList.WinZoneModel:Check_WinZone_Need_Open() then
        if ModelList.WinZoneModel:CheckVersion() then
            ModelList.BattleModel.RequireModuleLua("WinZone")
            local winzoneView = require("View/WinZone/WinZoneInPropgressView")
            Facade.SendNotification(NotifyName.ShowUI, winzoneView:New())
            return
        end
    end
    ModelList.BattleModel.RequireModuleLua(data.modular_name)

    Event.Brocast(EventName.Event_popup_FullGameplay_finish, true)
    Facade.SendNotification(NotifyName.SpecialGameplay.CloseSpecialGameplayView)

    --跳转到固定城市
    ModelList.CityModel.C2S_ChangeCity(0)
    Facade.SendNotification(NotifyName.SceneCity.Click_City_Enter, nil, data.city_play)
end


--检查全机台活动
function VipRoomView:CheckValidFeature(data)
    return true
    ----配置有问题 实际需要打开
    --local isFullGameOpen = ModelList.CityModel:GetFullGameplayRemainTime() > 0
    --if isFullGameOpen then
    --    return true
    --end
    --
    --local featureID   = data.id
    --local ServerData  = ModelList.CityModel:GetRecommendBanners()
    --local playerLevel = ModelList.PlayerInfoModel:GetLevel()
    --local limitLevel  = Csv.GetData("control", 157, "content")[1][1] or 2
    --if not ServerData or #ServerData <= 2 or playerLevel < limitLevel then
    --    --确保数据存在
    --    local featureData = Csv.GetData("feature_enter", featureID)
    --    if featureData ~= nil and featureData.featured_banner > 0 then
    --        return true
    --    end
    --else
    --    for k, v in ipairs(ServerData) do
    --        if featureID == v then
    --            return true
    --        end
    --    end
    --end
    ----配置有问题 实际需要打开

end

return VipRoomView