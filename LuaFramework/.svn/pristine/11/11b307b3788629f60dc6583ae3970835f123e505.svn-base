local BaseSkill = require "View/Bingo/CardModule/Skill/BaseSkill"
local WinZonePuSkill = BaseSkill:New("WinZonePuSkill")
local this = WinZonePuSkill
local private = {}

function WinZonePuSkill:ShowSkill(cardId,cellIndex,powerId,skillId)
    local target = self:GetCardPower().cardView:GetCardCell(tonumber(cardId), cellIndex)
    BattleEffectCache:GetSkillPrefabFromCache("cityget", target, nil, 2)

    BattleEffectCache:GetSkillPrefabFromCache("WinZoneskill01", target, function(obj)
        UISound.play("winzoneMicrophone")

        --触发技能的格子在第几列
        local indexFloor = math.floor(math.max((cellIndex - 1)) / 5) + 1
        --盖章
        local leftIndex, rightIndex = private.GetCellsByColumn(cellIndex, indexFloor)
        local signDelay, signInterval = 0.9, 0.15
        LuaTimer:SetDelayFunction(signDelay, function()
            --向左盖章
            table.each(leftIndex, function(index, k)
                LuaTimer:SetDelayFunction(signInterval * (k - 1), function()
                    if private.IsValidIndex(index) then
                        private.TrySignCell(self, cardId, index, powerId)
                    end
                end, false, LuaTimer.TimerType.Battle)
            end)

            --向右盖章
            table.each(rightIndex, function(index, k)
                LuaTimer:SetDelayFunction(signInterval * (k - 1), function()
                    if private.IsValidIndex(index) then
                        private.TrySignCell(self, cardId, index, powerId)
                    end
                end, false, LuaTimer.TimerType.BattleUI)
            end)
        end, false, LuaTimer.TimerType.Battle)
    end, 4, cardId)
end

-------------------------私有方法-------------------------------------------------------

--- 取得第indexFloor列的所有格子，结果区分左边和右边的格子
function private.GetCellsByColumn(startCellIndex, indexFloor)
    local left, right = {}, {}
    --左边取两个
    local tempIndex = startCellIndex
    for i = 1, 2 do
        table.insert(left, tempIndex - 5)
        tempIndex = tempIndex - 5
    end

    --右边取两个
    tempIndex = startCellIndex
    for i = 1, 2 do
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
        --cellData.isSignByGemPuSkill = true
        self:GetCardPower().cardView:OnClickCardIgnoreJudgeByIndex(cardId, index, powerId)
    end
    self:GetCardPower():ChangeCellState(cardId, index, self.CellState.Signed)
end

return this