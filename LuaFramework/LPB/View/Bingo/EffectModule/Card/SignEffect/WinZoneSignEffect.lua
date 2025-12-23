local BaseSignEffect = require("View.Bingo.EffectModule.Card.SignEffect.BaseSignEffect")
local WinZoneSignEffect = BaseSignEffect:New("WinZoneSignEffect")
setmetatable(WinZoneSignEffect, BaseSignEffect)
local this = WinZoneSignEffect

function WinZoneSignEffect:SignCardEffect(cardId, index, cardCell, signType, delay, self_bingo, giftLen)
    getmetatable(self).SignCardEffect(self, cardId, index, cardCell, signType, delay, self_bingo, giftLen)
    local singleCard = self.cardView:GetCard(cardId)
    --singleCard:RefreshMiniGameProgress(cardId, index)
    
    if self_bingo then
        if not self:CheckIsCellTriggered(cardId, index) then
            BattleEffectCache:GetSkillPrefabFromCache("WinZoneskill02", cardCell, function(obj)
                UISound.play("winzoneRecordbingo")
            end, 4, cardId)
        end
    end

    local bgVAnim = singleCard:GetVictoryBgAnim(index)
    if fun.get_active_self(bgVAnim) then
        AnimatorPlayHelper.Play(bgVAnim, { "bg_tipidle2", "bg_tipidle2" }, false, nil)
    end
end

function WinZoneSignEffect:CheckIsCellTriggered(cardId, cellIndex)
    cardId, cellIndex = tonumber(cardId), tonumber(cellIndex)
    self.triggeredFlag = self.triggeredFlag or {}
    self.triggeredFlag[cardId] = self.triggeredFlag[cardId] or {}
    local temp = self.triggeredFlag[cardId]
    if temp[cellIndex] then
        return true
    else
        temp[cellIndex] = true
        return false
    end
end

return this

