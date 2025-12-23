
MiniGameEntrance = {}
MiniGameEntrance.miniGameLuaList = {

    "MiniGame/MiniGame01/EnterGameStolenStep",
    "MiniGame/MiniGame01/EnterGamekJackpotStep",
    "MiniGame/MiniGame01/EnterGameTopRewardStep",
    "MiniGame/MiniGame01/EnterGameShowTipsStep",
    "MiniGame/MiniGame01/EnterGameResetLayerStep",
    "MiniGame/MiniGame01/EnterGameSequence",
    
    "MiniGame/MiniGame01/OpenBoxStolenStep",
    "MiniGame/MiniGame01/OpenBoxCheckJackpotStep",
    "MiniGame/MiniGame01/OpenBoxCheckTopRewardStep",
    "MiniGame/MiniGame01/OpenBoxFlyRewardStep",
    "MiniGame/MiniGame01/OpenBoxNextLayerStep",
    "MiniGame/MiniGame01/OpenBoxShowTipsStep",
    "MiniGame/MiniGame01/OpenBoxResetLayerStep",
    "MiniGame/MiniGame01/OpenBoxSequence",
    
    "MiniGame/MiniGame01/BaseMiniGame01",
    "MiniGame/MiniGame01/MiniGame01BaseState",
    "MiniGame/MiniGame01/MiniGame01OriginalState",
    "MiniGame/MiniGame01/MiniGame01EnterState",
    "MiniGame/MiniGame01/MiniGame01PlayState",
    "MiniGame/MiniGame01/MiniGame01StiffState",

    "MiniGame/MiniGame01/MiniGame01View",
    "MiniGame/MiniGame01/ExtraRewardView",
    "MiniGame/MiniGame01/MiniGame01LayerItem",
    "MiniGame/MiniGame01/MiniGame01CollectRewardItem",
    "MiniGame/MiniGame01/MiniGame01StageProperty",
    "MiniGame/MiniGame01/MiniGameStealthView",
    "MiniGame/MiniGame01/MiniGame01BigRewardView",
    "MiniGame/MiniGame01/MiniGame01QuitView",
    "MiniGame/MiniGame01/MiniGame01PlayHelperView",
    "MiniGame/MiniGame01/MiniGame01DodgeView",
    "MiniGame/MiniGame01/MiniGame01PopupView"
}


function MiniGameEntrance:EnterGameSartMiniGame()
    for index, value in ipairs(MiniGameEntrance.miniGameLuaList) do
        require(value)
    end
    Facade.SendNotification(NotifyName.ShowUI,MiniGame01View)
end

function MiniGameEntrance:SartMiniGame()
    for index, value in ipairs(MiniGameEntrance.miniGameLuaList) do
        require(value)
    end
    -- Facade.SendNotification(NotifyName.ShowUI,MiniGame01View)
    Facade.SendNotification(NotifyName.HallCity.Function_icon_click_special,MiniGame01View)
end

function MiniGameEntrance:ShowHatBoost()
    for index, value in ipairs(MiniGameEntrance.miniGameLuaList) do
        require(value)
    end
    -- Facade.SendNotification(NotifyName.ShowUI,MiniGame01PopupView)
    Facade.SendNotification(NotifyName.HallCity.Function_icon_click_special,MiniGame01PopupView, {showCollectTopView = false , isLobbyOpen = true})
end

function MiniGameEntrance.ClearMiniGameLua()
    for index, value in ipairs(MiniGameEntrance.miniGameLuaList) do
        local miniGameLua = string.sub(value,20,-1)
        package.loaded[value] = nil
        package.preload[miniGameLua] = nil
        _G[miniGameLua] = nil
    end
end