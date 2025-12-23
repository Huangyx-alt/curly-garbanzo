local BaseBingoView = require "View.Bingo.UIView.MainView.BaseBingoView"

local ScratchWinnerBingoView = BaseBingoView:New("ScratchWinnerBingoView", "ScratchWinnerBingoAtlas")
local this = ScratchWinnerBingoView
this.ViewName = "ScratchWinnerBingoView"

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
    "CollectDetails",
}

--- 加载战斗背景
function this:InitCityBg()
    self.__index.InitCityBg(self, function(bg_animator)
        --LuaTimer:SetDelayFunction(0.25,function()
            self:PlayBackgroundAction("enter")
        --end, nil, LuaTimer.TimerType.Battle)
    end)
end

--倒计时结束
function this:TimeCountOver(jokerPos)
    self.__index.TimeCountOver(self, jokerPos)
    self:PlayBackgroundAction("move")
end

-- bingosleft 显示
function this:LoadBingoleftView()
    -- if self.bingosleftView then
    --     self.bingosleftView:Show()
    -- end
    BaseBingoView.LoadBingoleftView(self)

    local anim = fun.get_component(self.CollectDetails, fun.ANIMATOR)
    if anim then
        anim.enabled = true
        local count = this.model:GetCardCount()
        if count == 1 then
            anim:Play("enter1")
        else
            anim:Play("enter2")
        end
    end

    local curModel = ModelList.BattleModel:GetCurrModel()
    local ref1 = fun.get_component(self.CollectDetails, fun.REFER)
    if fun.is_not_null(ref1) then
        for i = 1, 5 do
            local item = ref1:Get("Item" .. i)
            local ref2 = fun.get_component(item, fun.REFER)
            if fun.is_not_null(ref2) then
                local reward  = ref2:Get("rewardNum")
                reward.text = curModel:GetBingoReward(i, true)
            end
        end
    end
end

function this:OnCardExitEffect()
    -- if self.superMatchBingoView then
    --     fun.set_active(self.SuperMatchObj, false)
    -- end

    -- if self.SuperMatchBingosi then
    --     fun.set_active(self.SuperMatchBingosi, false)
    -- end

    BaseBingoView.OnCardExitEffect(self)

    local anim = fun.get_component(self.CollectDetails, fun.ANIMATOR)
    if anim then
        anim.enabled = true
        local count = this.model:GetCardCount()
        if count == 1 then
            anim:Play("end1")
        else
            anim:Play("end2")
        end
    end
end

return this