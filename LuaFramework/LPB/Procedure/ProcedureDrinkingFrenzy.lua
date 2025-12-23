ProcedureDrinkingFrenzy = Clazz(BaseProcedure,"ProcedureDrinkingFrenzy")
local isEnter = false
local isShowReady = false
function ProcedureDrinkingFrenzy:New()
    local o = {}
    setmetatable(o,{__index = ProcedureDrinkingFrenzy})
    return o
end

function ProcedureDrinkingFrenzy:OnEnter(fsm, previous)
    isEnter = true
    ProcedureDrinkingFrenzy:StartShow()
end

function ProcedureDrinkingFrenzy:ShowReadyView()
    isShowReady = true
    ProcedureDrinkingFrenzy:StartShow()
end

function ProcedureDrinkingFrenzy:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"DrinkingFrenzyBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.DrinkingFrenzyBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"DrinkingFrenzyReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.DrinkingFrenzyReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end

    end

end

function ProcedureDrinkingFrenzy:OnLeave(fsm)
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureDrinkingFrenzy:ProcedureName()
    return "ProcedureDrinkingFrenzy"
end

function ProcedureDrinkingFrenzy:GetCurrentSceneName()
    return "SceneDrinkingFrenzy"
end

return ProcedureDrinkingFrenzy