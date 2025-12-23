
TopCurrencyTicketsView = TopCurrencyView:New()
local this = TopCurrencyTicketsView
this.viewType = CanvasSortingOrderManager.LayerType.None

function TopCurrencyTicketsView:New(viewName,change,parentView,reddot)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o.viewName = viewName or "TopCurrencyTicketsView"
    o.changeRes = change
    o._parentView = parentView
    o._reddot = reddot or RedDotParam.city_top_shop
    return o
end

function TopCurrencyTicketsView:ChangeCurrencyShowType()
    if self.changeRes == 1 then --1表示根据玩法类型来显示消耗资源
        local res_id = nil
        local icon = nil
        local playType = ModelList.CityModel:GetEnterGameMode()
        res_id = Csv.GetData("admission_pay",playType,"resources_id")
        if res_id then
            icon = Csv.GetData("resources",res_id,"icon")
        end
        if icon then
            self.left_icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas",icon)
        end
        self.res_id = res_id
    else
        self.left_icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas","autoTickets")
    end
    self:SetDefaultRightResource()
end

function TopCurrencyTicketsView:RegisterEvent_Override()
    Event.AddListener(EventName.Event_autoTickets_change,self.OnAutoTicketsChange,self)
end

function TopCurrencyTicketsView:RemoveEvent_Override()
    Event.RemoveListener(EventName.Event_autoTickets_change,self.OnAutoTicketsChange,self)
end

function TopCurrencyTicketsView:OnAutoTicketsChange()
    self:RefreshCurrency()
end

function TopCurrencyTicketsView:RefreshCurrency()
    local tickets = nil
    local diamond = ModelList.ItemModel.get_diamond()
    if self.res_id == nil then
        tickets = ModelList.ItemModel.get_autoTickets()
    else
        tickets = ModelList.ItemModel.getResourceNumByType(self.res_id)
    end

    if tickets > 10 then
        self.text_coin_value:RollByTime(tickets,1,nil)
    else
        self.text_coin_value.text = tostring(tickets)
    end
    if diamond > 10 then
        self.text_dimond_value:RollByTime(diamond,1,nil)
    else
        self.text_dimond_value.text = tostring(diamond)
    end
end