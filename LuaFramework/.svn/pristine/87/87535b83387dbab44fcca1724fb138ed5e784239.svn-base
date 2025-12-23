
ProcedureLogin = Clazz(BaseProcedure,"ProcedureLogin")

function ProcedureLogin:New()
    local o = {}
    setmetatable(o,{__index = ProcedureLogin})
    return o
end

function ProcedureLogin:OnEnter(fsm,lastName)
    log.r("SceneLogin!!!")
    local game_ui = fun.find_gameObject_with_tag("NormalUiRoot")
    local loginView =  fun.find_child(game_ui,"UserLoginView")
    
    Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.LoginView,loginView)
end

function ProcedureLogin:OnLeave(fsm)
end

function ProcedureLogin:ProcedureName()
    return "ProcedureLogin"
end

function ProcedureLogin:GetCurrentSceneName()
    return "LoginScene"
end