ProcedureScratchWinner = Clazz(BaseProcedure,"ProcedureScratchWinner")
local isEnter = false
local isShowReady = false
function ProcedureScratchWinner:New()
    local o = {}
    setmetatable(o,{__index = ProcedureScratchWinner})
    return o
end

function ProcedureScratchWinner:OnEnter(fsm, previous)
    isEnter = true
    ProcedureScratchWinner:StartShow()
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView = fun.find_child(game_ui,"ScratchWinnerBingoView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.ScratchWinnerBingoView, gameBingoView)

    --game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"ScratchWinnerReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
    --if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --    ViewList.SceneLoadingGameView:FadeOut()
    --end
end

function ProcedureScratchWinner:ShowReadyView()
    isShowReady = true
    ProcedureScratchWinner:StartShow()
end

function ProcedureScratchWinner:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"ScratchWinnerBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.ScratchWinnerBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"ScratchWinnerReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end

    end

end

function ProcedureScratchWinner:OnLeave(fsm)
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureScratchWinner:ProcedureName()
    return "ProcedureScratchWinner"
end

function ProcedureScratchWinner:GetCurrentSceneName()
    return "SceneScratchWinner"
end

return ProcedureScratchWinner