ProcedureBison = Clazz(BaseProcedure,"ProcedureBison")
local isEnter = false
local isShowReady = false
function ProcedureBison:New()
    local o = {}
    setmetatable(o,{__index = ProcedureBison})
    return o
end

function ProcedureBison:OnEnter(fsm, previous)
    isEnter = true
    ProcedureBison:StartShow()
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView = fun.find_child(game_ui,"BisonBingoView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.BisonBingoView, gameBingoView)

    --game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"BisonReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
    --if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --    ViewList.SceneLoadingGameView:FadeOut()
    --end
end

function ProcedureBison:ShowReadyView()
    isShowReady = true
    ProcedureBison:StartShow()
end

function ProcedureBison:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"BisonBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.BisonBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"BisonReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end

    end

end

function ProcedureBison:OnLeave(fsm)
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureBison:ProcedureName()
    return "ProcedureBison"
end

function ProcedureBison:GetCurrentSceneName()
    return "SceneBison"
end

return ProcedureBison