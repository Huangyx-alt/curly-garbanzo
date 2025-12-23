local ProcedureSolitaire = Clazz(BaseProcedure,"ProcedureSolitaire")
local isEnter = false
local isShowReady = false
function ProcedureSolitaire:New()
    local o = {}
    setmetatable(o,{__index = ProcedureSolitaire})
    return o
end

function ProcedureSolitaire:OnEnter(fsm, previous)
    isEnter = true
    ProcedureSolitaire:StartShow()
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView = fun.find_child(game_ui,"SolitaireBingoView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.SolitaireBingoView, gameBingoView)

    --game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"SolitaireReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
    --if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --    ViewList.SceneLoadingGameView:FadeOut()
    --end
end

function ProcedureSolitaire:ShowReadyView()
    isShowReady = true
    ProcedureSolitaire:StartShow()
end

function ProcedureSolitaire:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"SolitaireBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.SolitaireBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"SolitaireReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end
    end
end

function ProcedureSolitaire:OnLeave(fsm)
    isEnter = false
    isShowReady = false
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureSolitaire:ProcedureName()
    return "ProcedureSolitaire"
end

function ProcedureSolitaire:GetCurrentSceneName()
    return "SceneSolitaire"
end

return ProcedureSolitaire