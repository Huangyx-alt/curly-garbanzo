local BaseBingoView = require "View.Bingo.UIView.MainView.BaseBingoView"

local MoleMinerBingoView = BaseBingoView:New("MoleMinerBingoView", "MoleMinerBingoAtlas")
local this = MoleMinerBingoView
this.ViewName = "MoleMinerBingoView"

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

--- ����ս������
function this:InitCityBg()
    self.__index.InitCityBg(self, function(bg_animator)
        --LuaTimer:SetDelayFunction(0.25,function()
            self:PlayBackgroundAction("enter")
        --end, nil, LuaTimer.TimerType.Battle)
    end)
end

--����ʱ����
function this:TimeCountOver(jokerPos)
    self.__index.TimeCountOver(self, jokerPos)
    self:PlayBackgroundAction("move")
end

return this