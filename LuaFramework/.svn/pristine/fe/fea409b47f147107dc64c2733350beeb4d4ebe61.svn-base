local BaseBingoView = require "View.Bingo.UIView.MainView.BaseBingoView"

local DrinkingFrenzyBingoView = BaseBingoView:New("DrinkingFrenzyBingoView", "DrinkingFrenzyBingoAtlas")
local this = DrinkingFrenzyBingoView
this.ViewName = "DrinkingFrenzyBingoView"

this.auto_bind_ui_items = {
    "BingoMap1",
    "BingoMap2",
    "BingoMap3",
    "BingoMap4",
    "SwitchCard",
    "RollBall",
    "Bingosi",
    "ItemContainer",
    "Bingo",
    "powerup",
    "btn_main",
    "magnifier",
    "bottle",
    "btn_power",
    "Right",
    "BingoSpawn",
    "EffectContainer",
    "PowerUpContainer",
    "pot",
    "NormalBingosiNode",
    "Bg",
    "CardNumberSpritesContainer",
    "CellBgContainer",
    "MirrorNumberContainer",
    "RewardCollect",
    "CellDoubleNumBgContainer",
    "SafeArea",
    "MapRootPos",
}

function this:InitCityBg()
    log.log("啤酒机台进入检查 InitCityBg")
    self.__index.InitCityBg(self, function(bg_animator)
        --LuaTimer:SetDelayFunction(0.25,function()
            self:PlayBackgroundAction("enter")
        --end, nil, LuaTimer.TimerType.Battle)
    end)
end

function this:TimeCountOver(jokerPos)
    log.log("啤酒机台进入检查 timeover")
    self.__index.TimeCountOver(self, jokerPos)
    self:PlayBackgroundAction("move")
end

return this