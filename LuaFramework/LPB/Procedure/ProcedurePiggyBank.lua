local ProcedurePiggyBank = Clazz(BaseProcedure,"ProcedurePiggyBank")
local isEnter = false
local isShowReady = false
function ProcedurePiggyBank:New()
    local o = {}
    setmetatable(o,{__index = ProcedurePiggyBank})
    return o
end

function ProcedurePiggyBank:OnEnter(fsm, previous)
    isEnter = true
    ProcedurePiggyBank:StartShow()
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView = fun.find_child(game_ui,"PiggyBankBingoView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.PiggyBankBingoView, gameBingoView)

    --game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"PiggyBankReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
    --if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --    ViewList.SceneLoadingGameView:FadeOut()
    --end
end

function ProcedurePiggyBank:ShowReadyView()
    isShowReady = true
    ProcedurePiggyBank:StartShow()
end

function ProcedurePiggyBank:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"PiggyBankBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.PiggyBankBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"PiggyBankReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end
    end
end

function ProcedurePiggyBank:OnLeave(fsm)
    isEnter = false
    isShowReady = false
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedurePiggyBank:ProcedureName()
    return "ProcedurePiggyBank"
end

function ProcedurePiggyBank:GetCurrentSceneName()
    return "ScenePiggyBank"
end

return ProcedurePiggyBank