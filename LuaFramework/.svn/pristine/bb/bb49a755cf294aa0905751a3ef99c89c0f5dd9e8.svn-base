--- 城市8技能
local BaseSkill = require("View.Bingo.CardModule.Skill.BaseSkill")
local Play25Skill = BaseSkill:New("Play25Skill")
setmetatable(Play25Skill, BaseSkill)
local this = Play25Skill

function Play25Skill:ShowSkill(cardId, cellIndex, powerId, skillId)
    self:SaveSkillInfo(cardId, nil)
    local targetObj = self:GetCardPower().cardView:GetCardCell(tonumber(cardId), cellIndex)

    BattleEffectCache:GetSkillPrefabFromCache("Play25Skill", targetObj, function(obj)
        self:SaveSkillInfo(cardId, obj)
        fun.set_same_position_with_but_z_zero(obj, self:GetCardPower().cardView:GetCardCell(tonumber(cardId), cellIndex))
        self:SameScaleWithCard(obj, cardId)

        UISound.play("greecelightning")

        local delayT = {0.7, 0.9, 1.1}
        local data = Csv.GetData("skill", skillId, "skill_xyz")
        local ori_x = math.modf((cellIndex - 1) / 5)
        local ori_y = math.modf((cellIndex - 1) % 5)

        table.each(data, function(offset, index)
            local delay = delayT[index] or 1.1
            LuaTimer:SetDelayFunction(delay, function()
                local new_x = ori_x + offset[1]
                local new_y = ori_y - offset[2]
                if new_x >= 0 and new_x <= 4 and new_y >= 0 and new_y <= 4 then
                    local new_index = new_x * 5 + new_y + 1
                    local IsNotSign = self:GetModel():GetRoundData(cardId, new_index):IsNotSign()
                    if IsNotSign then
                        self:GetCardPower().cardView:OnClickCardIgnoreJudgeByIndex(cardId, new_index, powerId)
                        self:GetCardPower():ChangeCellState(cardId, new_index, self.CellState.Signed)
                    end
                end

                if index == #data then
                    self:RemoveSkillInfo(obj)
                end
            end, nil, LuaTimer.TimerType.Battle)
        end)
    end, 4, cardId)
end

return this