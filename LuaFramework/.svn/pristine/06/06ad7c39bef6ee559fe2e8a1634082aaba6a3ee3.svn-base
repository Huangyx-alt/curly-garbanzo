-------------------------
----记录当前的主干界面，主干界面都继承该类
-------------------------
TrunkControllerView = TopBarControllerView:New("TrunkControllerView")
local this = TrunkControllerView

local curTrunkView = nil

function GetCurrentTrunkView()
    return curTrunkView
end

function TrunkControllerView:New(viewName, atlasName)
    local o = {viewName = viewName, atlasName = atlasName, isShow = false, isLoaded = false, changeSceneClear = true}
    self.__index = self
    setmetatable(o,self)
    return o
end

function TrunkControllerView:OnEnable_before()
    curTrunkView = self
    self:SetCurrentTopBar()
end

function TrunkControllerView:IsTrunk()
    return true
end