ProcedureNewChristmas = Clazz(BaseProcedure,"ProcedureNewChristmas")
local isEnter = false
local isShowReady = false
function ProcedureNewChristmas:New()
    local o = {}
    setmetatable(o,{__index = ProcedureNewChristmas})
    return o
end

function ProcedureNewChristmas:OnEnter(fsm, previous)
    isEnter = true
    ProcedureNewChristmas:StartShow()
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView = fun.find_child(game_ui,"NewChristmasBingoView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.NewChristmasBingoView, gameBingoView)

    --game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"NewChristmasReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
    --if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --    ViewList.SceneLoadingGameView:FadeOut()
    --end
end

function ProcedureNewChristmas:ShowReadyView()
    isShowReady = true
    ProcedureNewChristmas:StartShow()
end

function ProcedureNewChristmas:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"NewChristmasBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.NewChristmasBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"NewChristmasReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end
    end
end

function ProcedureNewChristmas:OnLeave(fsm)
    isEnter = false
    isShowReady = false
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureNewChristmas:ProcedureName()
    return "ProcedureNewChristmas"
end

function ProcedureNewChristmas:GetCurrentSceneName()
    return "SceneNewChristmas"
end

return ProcedureNewChristmas