ProcedureGoldenTrain = Clazz(BaseProcedure,"ProcedureGoldenTrain")
local isEnter = false
local isShowReady = false
function ProcedureGoldenTrain:New()
    local o = {}
    setmetatable(o,{__index = ProcedureGoldenTrain})
    return o
end

function ProcedureGoldenTrain:OnEnter(fsm, previous)
    isEnter = true
    ProcedureGoldenTrain:StartShow()
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView = fun.find_child(game_ui,"GoldenTrainBingoView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.GoldenTrainBingoView, gameBingoView)

    --game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"GoldenTrainReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
    --if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --    ViewList.SceneLoadingGameView:FadeOut()
    --end
end

function ProcedureGoldenTrain:ShowReadyView()
    isShowReady = true
    ProcedureGoldenTrain:StartShow()
end

function ProcedureGoldenTrain:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"GoldenTrainBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.GoldenTrainBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"GoldenTrainReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end

    end

end

function ProcedureGoldenTrain:OnLeave(fsm)
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureGoldenTrain:ProcedureName()
    return "ProcedureGoldenTrain"
end

function ProcedureGoldenTrain:GetCurrentSceneName()
    return "SceneGoldenTrain"
end

return ProcedureGoldenTrain