ProcedureDragonFortune = Clazz(BaseProcedure,"ProcedureDragonFortune")
local isEnter = false
local isShowReady = false
function ProcedureDragonFortune:New()
    local o = {}
    setmetatable(o,{__index = ProcedureDragonFortune})
    return o
end

function ProcedureDragonFortune:OnEnter(fsm, previous)
    isEnter = true
    ProcedureDragonFortune:StartShow()
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView = fun.find_child(game_ui,"DragonFortuneBingoView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.DragonFortuneBingoView, gameBingoView)

    --game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"DragonFortuneReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
    --if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --    ViewList.SceneLoadingGameView:FadeOut()
    --end
end

function ProcedureDragonFortune:ShowReadyView()
    isShowReady = true
    ProcedureDragonFortune:StartShow()
end

function ProcedureDragonFortune:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"DragonFortuneBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.DragonFortuneBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"DragonFortuneReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end
    end
end

function ProcedureDragonFortune:OnLeave(fsm)
    isEnter = false
    isShowReady = false
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureDragonFortune:ProcedureName()
    return "ProcedureDragonFortune"
end

function ProcedureDragonFortune:GetCurrentSceneName()
    return "SceneDragonFortune"
end

return ProcedureDragonFortune