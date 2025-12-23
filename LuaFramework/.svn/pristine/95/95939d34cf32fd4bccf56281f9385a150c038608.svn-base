local BaseBingoView = require "View.Bingo.UIView.MainView.BaseBingoView"

local PirateShipBingoView = BaseBingoView:New("PirateShipBingoView", "PirateShipBingoAtlas")
local this = PirateShipBingoView
this.ViewName = "PirateShipBingoView"

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
    "SafeArea",
    "CellDoubleNumBgContainer",
    "MapRootPos",
}

function this:InitCityBg()
    self.__index.InitCityBg(self, function(bg_animator)
        --LuaTimer:SetDelayFunction(0.25,function()
            self:PlayBackgroundAction("enter")
        --end, nil, LuaTimer.TimerType.Battle)
    end)
end

function this:TimeCountOver(jokerPos)
    self.__index.TimeCountOver(self, jokerPos)
    self:PlayBackgroundAction("move")
    UISound.play("piratebattlestart")
end

return this