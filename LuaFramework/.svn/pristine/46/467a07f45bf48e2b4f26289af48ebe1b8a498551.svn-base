local BaseSkill = require "View/Bingo/CardModule/Skill/BaseSkill"
local GoldenPigPuSkill = BaseSkill:New("GoldenPigPuSkill")
local this = GoldenPigPuSkill
local private = {}

function GoldenPigPuSkill:ShowSkill(cardId, cellIndex, powerId, skillId)
    local target = self:GetCardPower().cardView:GetCardCell(tonumber(cardId), cellIndex)
    BattleEffectCache:GetSkillPrefabFromCache("cityget", target, nil, 2)

    local leftIndex, rightIndex = private.GetTargetCells(cellIndex)
    local signDelays = {0.7, 0.8, 0.9, 1, 1.1}
    BattleEffectCache:GetSkillPrefabFromCache("GoldenPigskill1", target, function(obj)
        UISound.play("goldenpigFlypig")
        
        table.each(leftIndex, function(index, key)
            if private.IsValidIndex(index) then
                LuaTimer:SetDelayFunction(signDelays[key], function()
                    private.TrySignCell(self, cardId, index, powerId)
                end, false, LuaTimer.TimerType.BattleUI)
            end
        end)
    end, 2, cardId)
end

--------------------------------------------------------------------------------

--- 取得第indexFloor列的所有格子，结果区分左边和右边的格子
function private.GetTargetCells(cellIndex)
    local left, right = {}, {}
    --左边
    local tempIndex = cellIndex
    while private.IsValidIndex(tempIndex - 5) do
        table.insert(left, tempIndex - 5)
        tempIndex = tempIndex - 5
    end

    --右边
    tempIndex = cellIndex
    while private.IsValidIndex(tempIndex + 5) do
        table.insert(right, tempIndex + 5)
        tempIndex = tempIndex + 5
    end

    return left, right
end

function private.IsValidIndex(index, tempIndex)
    return index >= 1 and index <= 25
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