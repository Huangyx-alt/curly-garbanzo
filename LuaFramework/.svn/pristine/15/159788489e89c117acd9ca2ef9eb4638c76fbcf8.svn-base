ProcedureHorseRacing = Clazz(BaseProcedure,"ProcedureHorseRacing")
local isEnter = false
local isShowReady = false
function ProcedureHorseRacing:New()
    local o = {}
    setmetatable(o,{__index = ProcedureHorseRacing})
    return o
end

function ProcedureHorseRacing:OnEnter(fsm, previous)
    isEnter = true
    ProcedureHorseRacing:StartShow()
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView = fun.find_child(game_ui,"HorseRacingBingoView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.HorseRacingBingoView, gameBingoView)

    --game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"HorseRacingReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
    --if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --    ViewList.SceneLoadingGameView:FadeOut()
    --end
end

function ProcedureHorseRacing:ShowReadyView()
    isShowReady = true
    ProcedureHorseRacing:StartShow()
end

function ProcedureHorseRacing:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"HorseRacingBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.HorseRacingBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"HorseRacingReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end

    end

end

function ProcedureHorseRacing:OnLeave(fsm)
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureHorseRacing:ProcedureName()
    return "ProcedureHorseRacing"
end

function ProcedureHorseRacing:GetCurrentSceneName()
    return "SceneHorseRacing"
end

return ProcedureHorseRacing