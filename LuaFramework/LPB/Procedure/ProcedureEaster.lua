ProcedureEaster = Clazz(BaseProcedure,"ProcedureEaster")
local isEnter = false
local isShowReady = false
function ProcedureEaster:New()
    local o = {}
    setmetatable(o,{__index = ProcedureEaster})
    return o
end

function ProcedureEaster:OnEnter(fsm, previous)
    isEnter = true
    ProcedureEaster:StartShow()
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView = fun.find_child(game_ui,"EasterBingoView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.EasterBingoView, gameBingoView)

    --game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"EasterReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
    --if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --    ViewList.SceneLoadingGameView:FadeOut()
    --end
end

function ProcedureEaster:ShowReadyView()
    isShowReady = true
    ProcedureEaster:StartShow()
end

function ProcedureEaster:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"EasterBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.EasterBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"EasterReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end
    end
end

function ProcedureEaster:OnLeave(fsm)
    isEnter = false
    isShowReady = false
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureEaster:ProcedureName()
    return "ProcedureEaster"
end

function ProcedureEaster:GetCurrentSceneName()
    return "SceneEaster"
end

return ProcedureEaster