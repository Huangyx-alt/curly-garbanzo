local ProcedureLetemRoll = Clazz(BaseProcedure,"ProcedureLetemRoll")
local isEnter = false
local isShowReady = false
function ProcedureLetemRoll:New()
    local o = {}
    setmetatable(o,{__index = ProcedureLetemRoll})
    return o
end

function ProcedureLetemRoll:OnEnter(fsm, previous)
    isEnter = true
    ProcedureLetemRoll:StartShow()
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView = fun.find_child(game_ui,"LetemRollBingoView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.LetemRollBingoView, gameBingoView)

    --game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"LetemRollReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
    --if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --    ViewList.SceneLoadingGameView:FadeOut()
    --end
end

function ProcedureLetemRoll:ShowReadyView()
    isShowReady = true
    ProcedureLetemRoll:StartShow()
end

function ProcedureLetemRoll:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"LetemRollBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.LetemRollBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"LetemRollReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end

    end

end

function ProcedureLetemRoll:OnLeave(fsm)
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureLetemRoll:ProcedureName()
    return "ProcedureLetemRoll"
end

function ProcedureLetemRoll:GetCurrentSceneName()
    return "SceneLetemRoll"
end

return ProcedureLetemRoll