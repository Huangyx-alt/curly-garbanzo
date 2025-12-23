ProcedureMoleMiner = Clazz(BaseProcedure,"ProcedureMoleMiner")
local isEnter = false
local isShowReady = false
function ProcedureMoleMiner:New()
    local o = {}
    setmetatable(o,{__index = ProcedureMoleMiner})
    return o
end

function ProcedureMoleMiner:OnEnter(fsm, previous)
    isEnter = true
    ProcedureMoleMiner:StartShow()
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView = fun.find_child(game_ui,"MoleMinerBingoView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.MoleMinerBingoView, gameBingoView)

    --game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"MoleMinerReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
    --if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --    ViewList.SceneLoadingGameView:FadeOut()
    --end
end

function ProcedureMoleMiner:ShowReadyView()
    isShowReady = true
    ProcedureMoleMiner:StartShow()
end

function ProcedureMoleMiner:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"MoleMinerBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.MoleMinerBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"MoleMinerReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end

    end

end

function ProcedureMoleMiner:OnLeave(fsm)
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureMoleMiner:ProcedureName()
    return "ProcedureMoleMiner"
end

function ProcedureMoleMiner:GetCurrentSceneName()
    return "SceneMoleMiner"
end

return ProcedureMoleMiner