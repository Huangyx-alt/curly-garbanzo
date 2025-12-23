ProcedureGemQueen = Clazz(BaseProcedure,"ProcedureGemQueen")
local isEnter = false
local isShowReady = false
function ProcedureGemQueen:New()
    local o = {}
    setmetatable(o,{__index = ProcedureGemQueen})
    return o
end

function ProcedureGemQueen:OnEnter(fsm, previous)
    isEnter = true
    ProcedureGemQueen:StartShow()
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView = fun.find_child(game_ui,"GemQueenBingoView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.GemQueenBingoView, gameBingoView)

    --game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"GemQueenReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
    --if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --    ViewList.SceneLoadingGameView:FadeOut()
    --end
end

function ProcedureGemQueen:ShowReadyView()
    isShowReady = true
    ProcedureGemQueen:StartShow()
end

function ProcedureGemQueen:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"GemQueenBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.GemQueenBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"GemQueenReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end

    end

end

function ProcedureGemQueen:OnLeave(fsm)
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureGemQueen:ProcedureName()
    return "ProcedureGemQueen"
end

function ProcedureGemQueen:GetCurrentSceneName()
    return "SceneGemQueen"
end

return ProcedureGemQueen