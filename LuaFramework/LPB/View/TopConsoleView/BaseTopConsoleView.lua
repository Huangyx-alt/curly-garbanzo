require "View/CommonView/TopCurrencyView"

BaseTopConsoleView = TopCurrencyView:New("BaseTopConsoleView",nil,nil,false,nil,RedDotParam.city_top_shop)
local this = BaseTopConsoleView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

function BaseTopConsoleView:New(viewName, atlasName, parentView,disable,owner,reddot)
    local o = {}
    self.__index = self
    setmetatable(o, self)
    o.viewName = viewName
    o.atlasName = atlasName
    o._parentView = parentView
    o._disable = disable
    o._owner = owner
    o._reddot = reddot or RedDotParam.city_top_shop
    return o
end

function BaseTopConsoleView:RegisterEvent_Override()
    Event.AddListener(EventName.Event_topbar_change,self.OnTopBarChange,self)
end

function BaseTopConsoleView:RemoveEvent_Override()
    Event.RemoveListener(EventName.Event_topbar_change,self.OnTopBarChange,self)
end

local preShowTop = nil
local curShowTop = nil
function BaseTopConsoleView:OnTopBarChange(...)
    local active,change,fallback = select(1,...)
    if fallback then
        if preShowTop then
            self:OnTopBarChange(preShowTop.active,preShowTop.change)
        else
            self:OnTopBarChange(true,true)
        end
    else
        if curShowTop then
            preShowTop = curShowTop
        end
        curShowTop = {active = active,change = change}
        if change == TopBarChange.buy then
            self:SetDisable(active)
            self:SetGoback(true)
            self:SetHeadDisable(active)
        elseif change == TopBarChange.goback then
            self:SetDisable(true)
            self:SetGoback(active)
        elseif change == TopBarChange.buyDgbA then
            self:SetDisable(false)
            self:SetGoback(true)
        elseif change == TopBarChange.buyAgbD then
            self:SetDisable(true)
            self:SetGoback(false)
        elseif change == TopBarChange.buyHeadDgbA then
            self:SetDisable(false)
            self:SetGoback(true)
            self:SetHeadDisable(false)    
        else
            self:SetDisable(active)
            self:SetGoback(active)
        end
    end

    --刷新下红点
    RedDotManager:Refresh(RedDotEvent.shop_coinfree_event)
end