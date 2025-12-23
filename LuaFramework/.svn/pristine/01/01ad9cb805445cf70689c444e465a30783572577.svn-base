local BaseBingoView = require "View.Bingo.UIView.MainView.BaseBingoView"

local WinZoneGameBingoView = BaseBingoView:New("WinZoneGameBingoView", "WinZoneBattleAtlas")
local this = WinZoneGameBingoView
this.ViewName = "WinZoneGameBingoView"

this.auto_bind_ui_items = {
    "BingoMap1",
    "BingoMap2",
    "BingoMap3",
    "BingoMap4",
    "Bg",
    "Card",
    "Bingosi",
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
    "CardNumberSpritesContainer",
    "miniGame",
    "VictoryTip",
    "LastRoundVictoryTip",
}

function this:OnEnable()
    self.__index.OnEnable(self)
    self.isVictory = false
end

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

function this:RegisterEvent()
    self.__index.RegisterEvent(self)
    Event.AddListener(EventName.Trigger_Jackpot, self.OnTriggerJackpot, self)
end

function this:UnRegisterEvent()
    self.__index.UnRegisterEvent(self)
    Event.RemoveListener(EventName.Trigger_Jackpot, self.OnTriggerJackpot, self)
end

---@see  设置卡牌面板,提供给结算面板使用
function this:HandleForSettle(parent_obj)
    self.__index.HandleForSettle(self, parent_obj)
    fun.set_parent(self.VictoryTip, parent_obj)
    fun.set_parent(self.LastRoundVictoryTip, parent_obj)

    if self.bingosleftView then
        self.bingosleftView:HandleForSettle(self.jackpotView)
    end   
    if self.jackpotView then
        self.jackpotView:HandleForSettle(parent_obj)
    end
end

function this:OnTriggerJackpot()
    local jackpotView = self.jackpotView
    if jackpotView then
        local check = jackpotView.curCount >= jackpotView.totalCount and jackpotView.selfRank == 0
        --名次不够了
        if check then
            return
        end
    end

    --自己已经victory了
    if self.isVictory then
        return
    end
    
    local temp = ModelList.WinZoneModel:IsInLastRound() and self.LastRoundVictoryTip or self.VictoryTip
    --展示victory横幅
    if temp then
        self.isVictory = true
        --等jackpot效果展示完
        LuaTimer:SetDelayFunction(2.5, function()
            UISound.play("winzoneCongratulations")
            fun.set_active(temp, true)
            LuaTimer:SetDelayFunction(2.4, function()
                fun.set_active(temp, false)
            end, nil, LuaTimer.TimerType.Battle)

            if not ModelList.GuideModel:IsGuideComplete(70) then
                ModelList.GuideModel:TriggerWinZoneBattleGuide(330)
            end
        end, nil, LuaTimer.TimerType.Battle)
    end
end

return this