ProcedureGoldenPig = Clazz(BaseProcedure,"ProcedureGoldenPig")
local isEnter = false
local isShowReady = false
function ProcedureGoldenPig:New()
    local o = {}
    setmetatable(o,{__index = ProcedureGoldenPig})
    return o
end

function ProcedureGoldenPig:OnEnter(fsm, previous)
    isEnter = true
    ProcedureGoldenPig:StartShow()
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView = fun.find_child(game_ui,"GoldenPigBingoView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.GoldenPigBingoView, gameBingoView)

    --game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"GoldenPigReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
    --if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --    ViewList.SceneLoadingGameView:FadeOut()
    --end
end

function ProcedureGoldenPig:ShowReadyView()
    isShowReady = true
    ProcedureGoldenPig:StartShow()
end

function ProcedureGoldenPig:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"GoldenPigBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.GoldenPigBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"GoldenPigReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end
    end
end

function ProcedureGoldenPig:OnLeave(fsm)
    isEnter = false
    isShowReady = false
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureGoldenPig:ProcedureName()
    return "ProcedureGoldenPig"
end

function ProcedureGoldenPig:GetCurrentSceneName()
    return "SceneGoldenPig"
end

return ProcedureGoldenPig