ProcedureWinZone = Clazz(BaseProcedure, "ProcedureWinZone")
local isEnter = false
local isShowReady = false
function ProcedureWinZone:New()
    local o = {}
    setmetatable(o, { __index = ProcedureWinZone })
    return o
end

function ProcedureWinZone:OnEnter(fsm, previous)
    isEnter = true
    ProcedureWinZone:StartShow()
end

function ProcedureWinZone:ShowReadyView()
    isShowReady = true
    ProcedureWinZone:StartShow()
end

function ProcedureWinZone:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui, "WinZoneBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.WinZoneGameBingoView, gameBingoView)

        game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView = fun.find_child(game_ui, "WinZoneReadyView")
        --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.SpecialPlayReadyView, getReadyView)
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.WinZoneReadyView, getReadyView)
        
        if ViewList.WinZoneLoadingGameView and ViewList.WinZoneLoadingGameView.go then
            ViewList.WinZoneLoadingGameView:FadeOut()
        end
    end
end

function ProcedureWinZone:OnLeave(fsm)
    isEnter = false
    isShowReady = false
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedureWinZone:ProcedureName()
    return "ProcedureWinZone"
end

function ProcedureWinZone:GetCurrentSceneName()
    return "SceneWinZoneGame"
end

return ProcedureWinZone