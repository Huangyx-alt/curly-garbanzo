ProcedureCityHome = Clazz(BaseProcedure,"ProcedureCityHome")

local uiCamera = nil

function ProcedureCityHome:New()
    local o = {}
    setmetatable(o,{__index = ProcedureCityHome})
    return o
end

function ProcedureCityHome:OnEnter(fsm,previous)
    self.FindCamera()

    Facade.RegisterCommand(NotifyName.HallCity.ShowCityMainView,CmdCommonList.CmdShowCityMainView)
    Facade.RegisterCommand(NotifyName.HallCity.ShowHallMainView,CmdCommonList.CmdShowHallMainView)
    --Facade.RegisterCommand(NotifyName.HallCity.ShowAutoHallView,CmdCommonList.CmdShowAutoHallView)
    Facade.RegisterCommand(NotifyName.HallCity.ShowPowerUpView,CmdCommonList.CmdShowPowerUpView)

    Event.AddListener(EventName.Event_loadcityscenefinish,self.Loadcityscenefinish,self)
    local gamescene = fun.GameObject_find("CanvasScene/GameScene/MainCityScene")
    local scene = require("Scene/CityHomeScene")
    scene:SkipLoadShow(gamescene,true,nil);
end

function ProcedureCityHome:Loadcityscenefinish()
    Event.RemoveListener(EventName.Event_loadcityscenefinish,self.Loadcityscenefinish,self)

    Facade.SendNotification(NotifyName.ShowUI,ViewList.TopConsoleView)
end

function ProcedureCityHome:RepeatedEnter(fsm)
    self:OnEnter(fsm,nil)
end

function ProcedureCityHome:OnLeave(fsm)
    Facade.RemoveCommand(NotifyName.HallCity.ShowCityMainView)
    Facade.RemoveCommand(NotifyName.HallCity.ShowHallMainView)
    --Facade.RemoveCommand(NotifyName.HallCity.ShowAutoHallView)
    Facade.RemoveCommand(NotifyName.HallCity.ShowPowerUpView)
end

function ProcedureCityHome.FindCamera()
    local cameraGo = fun.GameObject_find("Canvas/Camera")
    if cameraGo then
        uiCamera = fun.get_component(cameraGo,"Camera")
    end
end

function ProcedureCityHome.GetCamera()
    return uiCamera
end  

function ProcedureCityHome:IsSceneHome()
    return CityHomeScene:IsSelectCity()
end

function ProcedureCityHome:IsSceneNormalHall()
    return CityHomeScene:IsNormalLobby()
end

function ProcedureCityHome:IsSceneAutoHall()
    return CityHomeScene:IsAutoLobby()
end

function ProcedureCityHome:IsFirstLoginEnter()
    return CityHomeScene:IsFirstLogin()
end

function ProcedureCityHome:GetCurrentSceneName()
    return CityHomeScene:GetSceneName()
end

function ProcedureCityHome:ProcedureName()
    return "ProcedureCityHome"
end