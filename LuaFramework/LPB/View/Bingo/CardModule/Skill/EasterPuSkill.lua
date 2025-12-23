local BaseSkill = require "View/Bingo/CardModule/Skill/BaseSkill"
local EasterPuSkill = BaseSkill:New("EasterPuSkill")
local this = EasterPuSkill
local private = {}

function EasterPuSkill:ShowSkill(cardId, cellIndex, powerId, skillId)
    local target = self:GetCardPower().cardView:GetCardCell(tonumber(cardId), cellIndex)
    BattleEffectCache:GetSkillPrefabFromCache("cityget", target, nil, 2)

    BattleEffectCache:GetSkillPrefabFromCache("Easterskill2", target, function(obj)
        UISound.play("easterpaint")

        local cellIndexs = private.GetSkillCells(cellIndex)
        local signDelays = {0.5, 0.6, 0.7, 0.8}
        table.each(cellIndexs, function(index, key)
            LuaTimer:SetDelayFunction(signDelays[key], function()
                private.TrySignCell(self, cardId, index, powerId)
            end, false, LuaTimer.TimerType.BattleUI)            
        end)
    end, 2, cardId)
end

--------------------------------------------------------------------------------
function private.GetSkillCells(cellIndex)
    local ret = {}
    for i = 1, 4 do
        local tmpIdx = cellIndex + i * 5
        if tmpIdx <= 25 then
            table.insert(ret, tmpIdx)
        else
            break
        end
    end

    return ret
end

function private.TrySignCell(self, cardId, index, powerId)
    local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, index)
    if cellData:IsNotSign() then
        --cellData.isSignByGemPuSkill = true
        self:GetCardPower().cardView:OnClickCardIgnoreJudgeByIndex(cardId, index, powerId)
    end
    self:GetCardPower():ChangeCellState(cardId, index, self.CellState.Signed)
end

return this