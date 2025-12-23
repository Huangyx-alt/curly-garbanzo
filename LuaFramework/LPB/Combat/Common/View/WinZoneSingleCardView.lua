--require "View/Bingo/UIView/ChildView/MiniGameProgress"

local BaseSingleCard = require("Combat.Common.View.BaseSingleCardView")
local WinZoneSingleCardView = BaseSingleCard:New();
local this = WinZoneSingleCardView;
setmetatable(this, BaseSingleCard)

this.auto_bind_ui_items = {
    "B1",
    "B2",
    "B3",
    "B4",
    "B5",
    "I1",
    "I2",
    "I3",
    "I4",
    "I5",
    "N1",
    "N2",
    "N3",
    "N4",
    "N5",
    "G1",
    "G2",
    "G3",
    "G4",
    "G5",
    "O1",
    "O2",
    "O3",
    "O4",
    "O5",
    "b_letter",
    "reward1",
    "reward2",
    "reward_icon1",
    "rewardPar",
    "PerfectDaub",
    "letter_b",
    "letter_i",
    "letter_n",
    "letter_g",
    "letter_o",
    "icon",
    "ChipsContainer",
    "fooddz",
    "autoFlag",
    "minigameProgress",
    "bg",
    "letter",
    "rewardCard",
    "shengzi1",
    "foodbg1",
    "foodbg2",
    "ef_Bingo_click",
    "gift_clone",
    "flash_clone",
    "ditu_v",
}
this.CellVictoryTips = {}

function WinZoneSingleCardView:Clone(name)
    local o = { name = name }
    o.CellVictoryTips = {}
    setmetatable(o, { __index = WinZoneSingleCardView })
    return o
end

function WinZoneSingleCardView:New(name)
    local o = { name = name }
    o.CellVictoryTips = {}
    setmetatable(o, { __index = WinZoneSingleCardView })
    return o
end

function WinZoneSingleCardView:BindObj(obj, parentView, cardId)
    self.CellVictoryTips = {}
    self.cardId = tonumber(cardId)
    self:on_init(obj, parentView)

    --if self.minigameProgress then
    --    self._minigameTicket = MiniGameProgress:New()
    --    self._minigameTicket:SkipLoadShow(self.minigameProgress)
    --end
end

function WinZoneSingleCardView:OnEnable()
    Event.AddListener(Notes.BINGO_TIME_COUNT_OVER, self.OnReadyTimeOver, self)
    Event.AddListener(EventName.CardBingoEffect_ShowWish, self.PlayWish, self)
    Event.AddListener(EventName.Refresh_CardSign, self.RefreshCardSign,self)
    self.CellVictoryTips = {}
end

function WinZoneSingleCardView:OnDisable()
    Event.RemoveListener(Notes.BINGO_TIME_COUNT_OVER, self.OnReadyTimeOver, self)
    Event.RemoveListener(EventName.CardBingoEffect_ShowWish, self.PlayWish, self)
    Event.RemoveListener(EventName.Refresh_CardSign, self.RefreshCardSign,self)
    
    --table.each(self.CellVictoryTips, function(obj)
    --    BattleEffectPool:Recycle("CellVictoryTip", obj)
    --end)
end

function WinZoneSingleCardView:RefreshMiniGameProgress(cardId, cellId)
    --if self._minigameTicket then
    --    self._minigameTicket:RefreshMiniGameProgress(cardId, cellId)
    --end
end

function WinZoneSingleCardView:OnReadyTimeOver()
    --Victory图形的格子添加额外bg，播放格子进场动画
    local loadData = ModelList.BattleModel:GetCurrModel():LoadGameData()
    local jackpotRuleId = loadData.jackpotRuleId
    if jackpotRuleId then
        local jackpotRule = Csv.GetData("jackpot", jackpotRuleId[1], "coordinate")
        table.each(jackpotRule, function(cellIndex)
            local bgV = self:GetVictoryBgAnim(cellIndex)
            fun.set_active(bgV, true)

            local cell = self.parentView:GetCardCell(self.cardId, cellIndex)
            if cell then
                local temp_ref = fun.get_component(cell, fun.REFER)
                local doubleBg = temp_ref:Get("doublebg")
                local img = fun.get_component(doubleBg, fun.IMAGE)
                img.sprite = AtlasManager:GetSpriteByName("WinZoneBattleAtlas", "Winzoncard03sV")
            end
        end)
    end
end

function WinZoneSingleCardView:GetVictoryBgAnim(cellIndex)
    local cell = self.parentView:GetCardCell(self.cardId, cellIndex)
    if not cell then
        return
    end
    
    local root = fun.find_child(self["ditu_v"], cell.name)
    if root then
        local bgV = fun.get_child(root, 0)
        if fun.is_not_null(bgV) then
            local anim = fun.get_animator(bgV)
            return anim
        end
    end
end

function WinZoneSingleCardView:PlayWish(cardId, cellIndex)
    cardId = tonumber(cardId)
    if cardId ~= self.cardId then
        return
    end
    
    local cellObj = self.parentView:GetCardCell(self.cardId, cellIndex)
    if not cellObj then
        return
    end
    
    local obj = BattleEffectPool:Get("CellVictoryTip")
    if obj then
        self.CellVictoryTips[cellIndex] = obj
        
        local bgV = self:GetVictoryBgAnim(cellIndex)
        if fun.is_not_null(bgV) then
            fun.set_parent(obj, bgV, true)
        else
            fun.set_parent(obj, cellObj, true)
        end
        
        UISound.play("winzoneWish")
    end
end

function WinZoneSingleCardView:RefreshCardSign(cardId, cellIndex)
    cardId = tonumber(cardId)
    if cardId ~= self.cardId then
        return
    end
    
    local tipObj = self.CellVictoryTips[cellIndex]
    if fun.is_not_null(tipObj) then
        BattleEffectPool:Recycle("CellVictoryTip", tipObj)
        
        --当wish的格子中有一个盖章后，剩余的其他格子做表现
        table.each(self.CellVictoryTips, function(obj)
            fun.set_active(obj, false)
            fun.set_active(obj, true,0.05)
        end)
        UISound.play("winzoneWish")
    end
    self.CellVictoryTips[cellIndex] = nil
end

return this