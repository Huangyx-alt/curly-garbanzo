local BaseBingoView = require("View.Bingo.UIView.MainView.BaseBingoView")

---@class ThievesBingoView : BaseBingoView
local ThievesBingoView = BaseBingoView:New('ThievesBingoView', "HawaiiBingoAtlas");
local this = ThievesBingoView;
this.ViewName = "ThievesBingoView"

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
    "PuSkillRoot"
}

function this:InitCityBg()
    self.__index.InitCityBg(self, function(bg_animator)
        self:PlayBackgroundAction("enter")
    end)
end

function this:TimeCountOver(jokerPos)
    self.__index.TimeCountOver(self, jokerPos)
    self:PlayBackgroundAction("move")
    --UISound.play("piratebattlestart")
end

return this



