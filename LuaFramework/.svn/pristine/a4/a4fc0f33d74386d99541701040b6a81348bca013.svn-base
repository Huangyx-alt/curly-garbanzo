local ProcedureMonopoly = Clazz(BaseProcedure,"ProcedureMonopoly")
local isEnter = false
local isShowReady = false
function ProcedureMonopoly:New()
    local o = {}
    setmetatable(o,{__index = ProcedureMonopoly})
    return o
end

function ProcedureMonopoly:OnEnter(fsm, previous)
    isEnter = true
    ProcedureMonopoly:StartShow()
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView = fun.find_child(game_ui,"MonopolyBingoView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.MonopolyBingoView, gameBingoView)

    --game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"MonopolyReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
    --if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --    ViewList.SceneLoadingGameView:FadeOut()
    --end
end

function ProcedureMonopoly:ShowReadyView()
    isShowReady = true
    ProcedureMonopoly:StartShow()
end

function ProcedureMonopoly:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"MonopolyBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.MonopolyBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"MonopolyReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end
    end
end

function ProcedureMonopoly:OnLeave(fsm)
    isEnter = false
    isShowReady = false
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureMonopoly:ProcedureName()
    return "ProcedureMonopoly"
end

function ProcedureMonopoly:GetCurrentSceneName()
    return "SceneMonopoly"
end

return ProcedureMonopoly