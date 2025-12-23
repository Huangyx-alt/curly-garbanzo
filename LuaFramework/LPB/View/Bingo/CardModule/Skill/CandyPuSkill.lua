local BaseSkill = require "View/Bingo/CardModule/Skill/BaseSkill"
local CandyPuSkill = BaseSkill:New("CandyPuSkill")
local this = CandyPuSkill
local private = {}

function CandyPuSkill:ShowSkill(cardId, cellIndex, powerId, skillId)
    local target = self:GetCardPower().cardView:GetCardCell(tonumber(cardId), cellIndex)
    BattleEffectCache:GetSkillPrefabFromCache("cityget", target, nil, 2)

    BattleEffectCache:GetSkillPrefabFromCache("Candyskillzhadan", target, function(obj)
        UISound.play("candysweetsbomb")
        
        local cellIndexs = private.GetSkillCells(cellIndex)
        local signDelays = {0.5, 0.6, 0.7, 0.8}
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
    --盖章顺序为：上、下、左、右
    local ret, temp = {}, {-1, 1, -5, 5}                                                                                                                                                                           

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
    local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, index)
    if cellData:IsNotSign() then
        --cellData.isSignByGemPuSkill = true
        self:GetCardPower().cardView:OnClickCardIgnoreJudgeByIndex(cardId, index, powerId)
    end
    self:GetCardPower():ChangeCellState(cardId, index, self.CellState.Signed)
end

return this