ProcedureNewLeetoleMan = Clazz(BaseProcedure,"ProcedureNewLeetoleMan")
local isEnter = false
local isShowReady = false
function ProcedureNewLeetoleMan:New()
    local o = {}
    setmetatable(o,{__index = ProcedureNewLeetoleMan})
    return o
end

function ProcedureNewLeetoleMan:OnEnter(fsm, previous)
    isEnter = true
    ProcedureNewLeetoleMan:StartShow()
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView = fun.find_child(game_ui,"NewLeetoleManBingoView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.NewLeetoleManBingoView, gameBingoView)

    --game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"NewLeetoleManReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
    --if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --    ViewList.SceneLoadingGameView:FadeOut()
    --end
end

function ProcedureNewLeetoleMan:ShowReadyView()
    isShowReady = true
    ProcedureNewLeetoleMan:StartShow()
end

function ProcedureNewLeetoleMan:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"NewLeetoleManBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.NewLeetoleManBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"NewLeetoleManReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end
    end
end

function ProcedureNewLeetoleMan:OnLeave(fsm)
    isEnter = false
    isShowReady = false
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureNewLeetoleMan:ProcedureName()
    return "ProcedureNewLeetoleMan"
end

function ProcedureNewLeetoleMan:GetCurrentSceneName()
    return "SceneNewLeetoleMan"
end

return ProcedureNewLeetoleMan