
ProcedureHangUp = Clazz(BaseProcedure,"ProcedureHangUp")
local isEnter = false
local isShowReady = false
function ProcedureHangUp:New()
    local o = {}
    setmetatable(o,{__index = ProcedureHangUp})
    return o
end

function ProcedureHangUp:OnEnter(fsm,lastName)
    isEnter = true
    ProcedureHangUp:StartShow()
    --Facade.RegisterCommand(NotifyName.HangUp.ShowHangUpView,CmdCommonList.CmdShowHangUpView)
    --Facade.SendNotification(NotifyName.HangUp.ShowHangUpView,ViewList.HangUpView)

    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    ----local gameBingoView =  fun.find_child(game_ui,"HangUpView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.HangUpView,game_ui )

    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"ReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.HangUpReadyView,getReadyView )
end

function ProcedureHangUp:ShowReadyView()
    isShowReady = true
    ProcedureHangUp:StartShow()
end

function ProcedureHangUp:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        --local gameBingoView =  fun.find_child(game_ui,"HangUpView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.HangUpView,game_ui )
        ViewList.SceneLoadingGameView:FadeOut()
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"ReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.HangUpReadyView,getReadyView )
    end

end

function ProcedureHangUp:OnLeave(fsm)
    isEnter = false
    isShowReady = false
    Facade.RemoveCommand(NotifyName.HangUp.ShowHangUpView)
end

function ProcedureHangUp:ProcedureName()
    return "ProcedureHangUp"
end

function ProcedureHangUp:GetCurrentSceneName()
    return "HangUpScene"
end