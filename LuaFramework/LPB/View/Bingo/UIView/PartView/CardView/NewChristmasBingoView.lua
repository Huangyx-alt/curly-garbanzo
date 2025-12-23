local BaseBingoView = require "View.Bingo.UIView.MainView.BaseBingoView"

local NewChristmasBingoView = BaseBingoView:New("NewChristmasBingoView", "NewChristmasBingoAtlas")
local this = NewChristmasBingoView
this.ViewName = "NewChristmasBingoView"

this.auto_bind_ui_items = {
    "BingoMap1",
    "BingoMap2",
    "BingoMap3",
    "BingoMap4",
    "Bg",
    "Card",
    "RollBall",
    "Bingosi",
    "JackpotList",
    "ItemContainer",
    "Bingo",
    "btn_switch",
    "map_pos_1",
    "map_pos_2",
    "Card3",
    "Card4",
    "btn_card_bg",
    "ef_Bingo_coins",
    "box",
    "ef_Bingo_firework",
    "GoldRate",
    "DiamondRate",
    "powerup",
    "Gold",
    "Diamond",
    "btn_main",
    "Jackpot",
    "magnifier",
    "bottle",
    "btn_power",
    "Right",
    "BingoSpawn",
    "Buff",
    "EffectContainer",
    "PowerUpContainer",
    "pot",
    "bingoclickgreen",
    "bingoclickpurple",
    "bingoclickred",
    "bingoclickyellow",
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
end

return this