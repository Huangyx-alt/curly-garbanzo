
ProcedureGameLoading = Clazz(BaseProcedure,"ProcedureGameLoading")

function ProcedureGameLoading:New()
    local o = {}
    setmetatable(o,{__index = ProcedureGameLoading})
    return o
end

function ProcedureGameLoading:OnEnter(fsm,lastName)
    Facade.SendNotification(NotifyName.ShowUI, ViewList.SceneLoadingGameView)
end

function ProcedureGameLoading:OnLeave(fsm)
end

function ProcedureGameLoading:ProcedureName()
    return "ProcedureGameLoading"
end

function ProcedureGameLoading:GetCurrentSceneName()
    return "GameLoadingScene"
end