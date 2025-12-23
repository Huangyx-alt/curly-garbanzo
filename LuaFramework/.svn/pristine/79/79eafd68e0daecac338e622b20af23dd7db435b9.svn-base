ProcedurePirateShip = Clazz(BaseProcedure,"ProcedurePirateShip")
local isEnter = false
local isShowReady = false
function ProcedurePirateShip:New()
    local o = {}
    setmetatable(o,{__index = ProcedurePirateShip})
    return o
end

function ProcedurePirateShip:OnEnter(fsm, previous)
    isEnter = true
    ProcedurePirateShip:StartShow()
    --local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local gameBingoView = fun.find_child(game_ui,"PirateShipBingoView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.PirateShipBingoView, gameBingoView)

    --game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    --local getReadyView =  fun.find_child(game_ui,"PirateShipReadyView")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
    --if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
    --    ViewList.SceneLoadingGameView:FadeOut()
    --end
end

function ProcedurePirateShip:ShowReadyView()
    isShowReady = true
    ProcedurePirateShip:StartShow()
end

function ProcedurePirateShip:StartShow()
    if isShowReady and isEnter then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local gameBingoView = fun.find_child(game_ui,"PirateShipBingoView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.PirateShipBingoView, gameBingoView)

        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local getReadyView =  fun.find_child(game_ui,"PirateShipReadyView")
        Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.SpecialPlayReadyView, getReadyView)
        if ViewList.SceneLoadingGameView and ViewList.SceneLoadingGameView.go then
            ViewList.SceneLoadingGameView:FadeOut()
        end
    end
end

function ProcedurePirateShip:OnLeave(fsm)
    isEnter = false
    isShowReady = false
    Facade.RemoveCommand(NotifyName.Bingo.ShowBingoView)
end

function ProcedurePirateShip:ProcedureName()
    return "ProcedurePirateShip"
end

function ProcedurePirateShip:GetCurrentSceneName()
    return "ScenePirateShip"
end

return ProcedurePirateShip