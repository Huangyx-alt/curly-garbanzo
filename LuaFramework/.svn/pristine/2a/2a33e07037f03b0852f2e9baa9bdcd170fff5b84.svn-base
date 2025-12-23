local ProcedureGotYou = Clazz(BaseProcedure, "ProcedureGotYou")
local isEnter = false
local isShowReady = false
function ProcedureGotYou:New()
    local o = {}
    setmetatable(o,{__index = ProcedureGotYou})
    return o
end

function ProcedureGotYou:OnEnter(fsm, previous)
    isEnter = true
    ProcedureGotYou:StartShow()
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView = fun.find_child(game_ui,"GotYouBingoView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.GotYouBingoView, gameBingoView)

    --game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"GotYouReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
    --if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --    ViewList.SceneLoadingGameView:FadeOut()
    --end
end

function ProcedureGotYou:ShowReadyView()
    isShowReady = true
    ProcedureGotYou:StartShow()
end

function ProcedureGotYou:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"GotYouBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.GotYouBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"GotYouReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end
    end
end

function ProcedureGotYou:OnLeave(fsm)
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureGotYou:ProcedureName()
    return "ProcedureGotYou"
end

function ProcedureGotYou:GetCurrentSceneName()
    return "SceneGotYou"
end

return ProcedureGotYou