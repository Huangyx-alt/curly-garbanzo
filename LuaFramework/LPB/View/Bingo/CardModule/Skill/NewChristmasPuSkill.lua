local BaseSkill = require "View/Bingo/CardModule/Skill/BaseSkill"
local NewChristmasPuSkill = BaseSkill:New("NewChristmasPuSkill")
local this = NewChristmasPuSkill
local private = {}

function NewChristmasPuSkill:ShowSkill(cardId, cellIndex, powerId, skillId)
    local target = self:GetCardPower().cardView:GetCardCell(tonumber(cardId), cellIndex)
    BattleEffectCache:GetSkillPrefabFromCache("cityget", target, nil, 2)

    BattleEffectCache:GetSkillPrefabFromCache("NewChristmasPuSkill", target, function(obj)
        UISound.play("newchristmasLightball")

        local cellIndexs = private.GetSkillCells(cellIndex)
        local signDelays = { 0.5, 0.6, 0.7, 0.8 }
        table.each(cellIndexs, function(index, key)
            if private.IsValidIndex(index, cellIndex) then
                LuaTimer:SetDelayFunction(signDelays[key], function()
                    private.TrySignCell(self, cardId, index, powerId)
                end, false, LuaTimer.TimerType.BattleUI)
            end
        end)
    end, 2, cardId)
end

--------------------------------------------------------------------------------

function private.GetSkillCells(cellIndex)
    local ret, temp = {}, { -2, -1, -6, 4 }

    table.each(temp, function(num)
        local index = cellIndex + num
        table.insert(ret, index)
    end)

    return ret
end

function private.IsValidIndex(index, tempIndex)
    if math.abs(index - tempIndex) == 1 then
        local rowTemp = math.floor((tempIndex - 1) / 5) + 1
        local rowIndex = math.floor((index - 1) / 5) + 1
        if rowTemp ~= rowIndex then
            return false
        end
    end

    return index >= 1 and index <= 25
end

function private.TrySignCell(self, cardId, index, powerId)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local cellData = curModel and curModel:GetRoundData(cardId, index)
    if not cellData then
        return
    end
    
    if cellData:IsNotSign() then
        --cellData.isSignByGemPuSkill = true
        self:GetCardPower().cardView:OnClickCardIgnoreJudgeByIndex(cardId, index, powerId)
    end
    self:GetCardPower():ChangeCellState(cardId, index, self.CellState.Signed)
end

return this