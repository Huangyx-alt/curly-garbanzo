
TopBarControllerView = BaseView:New("TopBarControllerView")
local this = TopBarControllerView

local Stack = require "Common/Stack" 
local order_stack = Stack:New()

function GetCurrentTopBarView()
    return order_stack:Current()
end

function TopBarControllerView:New(viewName,atlasName)
    local o = {viewName = viewName,atlasName = atlasName,isShow = false,isLoaded = false,changeSceneClear = true}
    self.__index = self
    setmetatable(o,self)
    return o
end

function TopBarControllerView:OnEnable_before()
    self:SetCurrentTopBar()
    local topBar = GetTopCurrencyInstance()
    if topBar == nil then
        self._closeTopBar = true
        Facade.SendNotification(NotifyName.ShowUI,ViewList.TopConsoleView)
    end
end

function TopBarControllerView:OnDestroy_late()
    if self._closeTopBar then
        self._closeTopBar = nil
        local isClose = true
        local view_list = GetActivatedViewList()
        for key, value in pairs(view_list) do
            if value:IsTopBarView() then
                isClose = false
                break
            end   
        end
        if isClose then
            Facade.SendNotification(NotifyName.CloseUI,ViewList.TopConsoleView)
        end
    end
end

function TopBarControllerView:OnDisable_late()
    order_stack:pop(self.topbar_index)
end

function TopBarControllerView:SetCurrentTopBar()
    self.topbar_index = order_stack:push(self)
end

function TopBarControllerView:IsTopBarView()
    return true
end

function TopBarControllerView:CloseTopBarParent()
    --子类重写
    Facade.SendNotification(NotifyName.SceneCity.Goback_Hall_city)

end

--- 日榜是每周会变的
function TopBarControllerView:CheckCompetitionObj(competitionObj,refTable,isPopup)
    --local dependentFile = require("View.DailyCompetition.CompetitionDependentFile")
    --local info = dependentFile[1]
    --if info and not competitionObj then
    --    Cache.load_prefabs(AssetList[info.topPrefabName],info.topPrefabName,function(obj2)
    --        local obj = fun.get_instance(obj2,refTable.CompetitionRoot)
    --        refTable.TopQuickTask = obj
    --        refTable.TopCompetitionView = obj
    --        if    refTable._topCompetition then
    --            refTable._topCompetition:CheckActivity(obj)
    --        end
    --        if refTable._hallFunction then
    --            refTable._hallFunction:TopQuickTaskCheckActivity(refTable.TopCompetitionView)
    --        end
    --        if isPopup then  Event.Brocast(EventName.Event_show_competition_task) end
    --    end)
    --else
    --    --self._hallFunction:TopQuickTaskCheckActivity(self.TopQuickTask)
    --end
end