--- 城市6技能
local BaseSkill = require("View.Bingo.CardModule.Skill.BaseSkill")
local Play14Skill = BaseSkill:New("Play14Skill")
setmetatable(Play14Skill, BaseSkill)
local this = Play14Skill

function Play14Skill:ShowSkill(cardId, cellIndex, powerId, skillId)
    self:SaveSkillInfo(cardId, nil)
    local targetObj = self:GetCardPower().cardView:GetCardCell(tonumber(cardId), cellIndex)

    BattleEffectCache:GetSkillPrefabFromCache("Play14Skill", targetObj, function(obj)
        self:SaveSkillInfo(cardId, obj)
        fun.set_same_position_with_but_z_zero(obj, self:GetCardPower().cardView:GetCardCell(tonumber(cardId), cellIndex))
        self:SameScaleWithCard(obj, cardId)

        UISound.play("mexicoSkull")

        local data = Csv.GetData("skill", skillId, "skill_xyz")
        local ori_x = math.modf((cellIndex - 1) / 5)
        local ori_y = math.modf((cellIndex - 1) % 5)
        
        LuaTimer:SetDelayFunction(2.2, function()
            table.each(data, function(offset, index)
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
            end)
        end, nil, LuaTimer.TimerType.Battle)
    end, 4, cardId)
end

return this