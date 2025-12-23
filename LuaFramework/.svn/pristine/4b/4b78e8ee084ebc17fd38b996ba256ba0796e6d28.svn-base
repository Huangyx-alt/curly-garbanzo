ProcedureVolcano = Clazz(BaseProcedure,"ProcedureVolcano")
local isEnter = false
local isShowReady = false
function ProcedureVolcano:New()
    local o = {}
    setmetatable(o,{__index = ProcedureVolcano})
    return o
end

function ProcedureVolcano:OnEnter(fsm, previous)
    isEnter = true
    ProcedureVolcano:StartShow()
end

function ProcedureVolcano:ShowReadyView()
    isShowReady = true
    ProcedureVolcano:StartShow()
end

function ProcedureVolcano:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"VolcanoBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.VolcanoBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"VolcanoReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end
    end
end

function ProcedureVolcano:OnLeave(fsm)
    isEnter = false
    isShowReady = false
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureVolcano:ProcedureName()
    return "ProcedureVolcano"
end

function ProcedureVolcano:GetCurrentSceneName()
    return "SceneVolcano"
end

return ProcedureVolcano