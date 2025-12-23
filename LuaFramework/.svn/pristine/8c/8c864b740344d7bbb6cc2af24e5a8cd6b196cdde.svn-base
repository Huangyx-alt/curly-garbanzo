local BaseSkill = require "View/Bingo/CardModule/Skill/BaseSkill"
local GemQueenPuSkill = BaseSkill:New("GemQueenPuSkill")
local this = GemQueenPuSkill
local private = {}

--宝石玩法-法杖
function GemQueenPuSkill:ShowSkill(cardId,cellIndex,powerId,skillId)
    local target = self:GetCardPower().cardView:GetCardCell(tonumber(cardId), cellIndex)
    BattleEffectCache:GetSkillPrefabFromCache("cityget", target, nil, 2)
    
    --触发技能的格子在第几列
    local indexFloor = math.floor(math.max((cellIndex - 1)) / 5) + 1

    --盖章
    local leftIndex, rightIndex = private.GetCellsByColumn(cellIndex, indexFloor)
    local signDelay, signInterval = 0.2, 0.15
    LuaTimer:SetDelayFunction(signDelay, function()
        --向左盖章
        table.each(leftIndex, function(index, k)
            LuaTimer:SetDelayFunction(signInterval * k, function()
                private.TrySignCell(self, cardId, index, powerId)
            end, false, LuaTimer.TimerType.BattleUI)
        end)

        --向右盖章
        table.each(rightIndex, function(index, k)
            LuaTimer:SetDelayFunction(signInterval * k, function()
                private.TrySignCell(self, cardId, index, powerId)
            end, false, LuaTimer.TimerType.BattleUI)
        end)
    end, false, LuaTimer.TimerType.BattleUI)
end

-------------------------私有方法-------------------------------------------------------

--- 取得第indexFloor列的所有格子，结果区分左边和右边的格子
function private.GetCellsByColumn(startCellIndex, indexFloor)
    local left, right = {}, {}
    --左边
    local tempIndex = startCellIndex
    while private.IsValidIndex(tempIndex - 5) do
        table.insert(left, tempIndex - 5)
        tempIndex = tempIndex - 5
    end

    --右边
    tempIndex = startCellIndex
    while private.IsValidIndex(tempIndex + 5) do
        table.insert(right, tempIndex + 5)
        tempIndex = tempIndex + 5
    end
    
    return left, right
end

function private.IsValidIndex(index)
    return index >= 1 and index <= 25
end

function private.TrySignCell(self, cardId, index, powerId)
    local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, index)
    if cellData:IsNotSign() then
        --标识是被法杖技能盖章
        cellData.isSignByGemPuSkill = true
        self:GetCardPower().cardView:OnClickCardIgnoreJudgeByIndex(cardId, index, powerId)
    end
    self:GetCardPower():ChangeCellState(cardId, index, self.CellState.Signed)
end

return this