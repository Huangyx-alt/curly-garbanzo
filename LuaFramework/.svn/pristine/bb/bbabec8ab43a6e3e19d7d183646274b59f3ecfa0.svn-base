ProcedureThieves = Clazz(BaseProcedure,"ProcedureThieves")
local isEnter = false
local isShowReady = false

function ProcedureThieves:New()
    local o = {}
    setmetatable(o,{__index = ProcedureThieves})
    return o
end

function ProcedureThieves:OnEnter(fsm,lastName)
    isEnter = true
    ProcedureThieves:StartShow()
end

function ProcedureThieves:ShowReadyView()
    isShowReady = true
    ProcedureThieves:StartShow()
end

function ProcedureThieves:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView =  fun.find_child(game_ui,"ThievesBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.ThievesBingoView,gameBingoView )
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"ThievesReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView ,getReadyView )
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end
    end
end

function ProcedureThieves:OnLeave(fsm)
    isEnter = false
    isShowReady = false
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureThieves:ProcedureName()
    return "ProcedureThieves"
end

function ProcedureThieves:GetCurrentSceneName()
    return "SceneThieves"
end

return ProcedureThieves