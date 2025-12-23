ProcedureCandy = Clazz(BaseProcedure,"ProcedureCandy")
local isEnter = false
local isShowReady = false
function ProcedureCandy:New()
    local o = {}
    setmetatable(o,{__index = ProcedureCandy})
    return o
end

function ProcedureCandy:OnEnter(fsm, previous)
    isEnter = true
    ProcedureCandy:StartShow()
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView = fun.find_child(game_ui,"CandyBingoView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.CandyBingoView, gameBingoView)

    --game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"CandyReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
    --if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --    ViewList.SceneLoadingGameView:FadeOut()
    --end
end

function ProcedureCandy:ShowReadyView()
    isShowReady = true
    ProcedureCandy:StartShow()
end

function ProcedureCandy:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"CandyBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.CandyBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"CandyReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end
    end
end

function ProcedureCandy:OnLeave(fsm)
    isEnter = false
    isShowReady = false
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureCandy:ProcedureName()
    return "ProcedureCandy"
end

function ProcedureCandy:GetCurrentSceneName()
    return "SceneCandy"
end

return ProcedureCandy