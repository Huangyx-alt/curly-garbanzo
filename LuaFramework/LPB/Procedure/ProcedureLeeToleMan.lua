ProcedureLeeToleMan = Clazz(BaseProcedure,"ProcedureLeeToleMan")
local isEnter = false
local isShowReady = false
function ProcedureLeeToleMan:New()
    local o = {}
    setmetatable(o,{__index = ProcedureLeeToleMan})
    return o
end

function ProcedureLeeToleMan:OnEnter(fsm,previous)
    isEnter = true
    ProcedureLeeToleMan:StartShow()
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView =  fun.find_child(game_ui,"LeeToleManView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.LeetoleManView,gameBingoView )

    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"LeetoleManReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView,getReadyView )
    --if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --    ViewList.SceneLoadingGameView:FadeOut()
    --end
end

function ProcedureLeeToleMan:ShowReadyView()
    isShowReady = true
    ProcedureLeeToleMan:StartShow()
end

function ProcedureLeeToleMan:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView =  fun.find_child(game_ui,"LeeToleManView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.LeetoleManView,gameBingoView )
        --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"LeetoleManReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView,getReadyView )
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end
    end
end

function ProcedureLeeToleMan:OnLeave(fsm)
    isEnter = false
    isShowReady = false
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureLeeToleMan:ProcedureName()
    return "ProcedureLeeToleMan"
end

function ProcedureLeeToleMan:GetCurrentSceneName()
    return "SceneLeetoleMan"
end

return ProcedureLeeToleMan