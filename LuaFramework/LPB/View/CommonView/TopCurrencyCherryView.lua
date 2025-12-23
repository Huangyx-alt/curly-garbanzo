
TopCurrencyCherryView = TopCurrencyView:New("TopCurrencyCherryView")
local this = TopCurrencyCherryView
this.viewType = CanvasSortingOrderManager.LayerType.None

function TopCurrencyCherryView:New(viewName,reddot)
    local o = {}
    self.__index = self
    setmetatable(o, self)
    o.viewName = viewName or "TopCurrencyCherryView"
    o._reddot = reddot or RedDotParam.city_top_shop
    return o
end

function TopCurrencyCherryView:ChangeCurrencyShowType()
    self.left_icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas","icon_cherry")
    self:SetDefaultRightResource()
end

function TopCurrencyCherryView:RegisterEvent()
    Event.AddListener(EventName.Event_cherry_change,self.OnCherryChange,self)
    Event.AddListener(EventName.Event_diamond_change,self.OnDiamondChange,self)
end

function TopCurrencyCherryView:RemoveEvent()
    Event.RemoveListener(EventName.Event_cherry_change,self.OnCherryChange,self)
    Event.RemoveListener(EventName.Event_diamond_change,self.OnDiamondChange,self)
end

function TopCurrencyCherryView:OnCherryChange()
    self:RefreshCurrency()
end

function TopCurrencyCherryView:RefreshCurrency()
    local cherry = ModelList.ItemModel.get_cherry()
    local diamond = ModelList.ItemModel.get_diamond()
    if cherry > 10 then
        self.text_coin_value:RollByTime(cherry,1,nil)
    else
        self.text_coin_value.text = tostring(cherry)
    end
    if diamond > 10 then
        self.text_dimond_value:RollByTime(diamond,1,nil)
    else
        self.text_dimond_value.text = tostring(diamond)
    end
end