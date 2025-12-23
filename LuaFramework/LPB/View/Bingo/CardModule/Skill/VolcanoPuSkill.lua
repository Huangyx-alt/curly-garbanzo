local BaseSkill = require "View/Bingo/CardModule/Skill/BaseSkill"
local VolcanoPuSkill = BaseSkill:New("VolcanoPuSkill")
local this = VolcanoPuSkill
local private = {}

function VolcanoPuSkill:ShowSkill(cardId, cellIndex, powerId, skillId)
    local target = self:GetCardPower().cardView:GetCardCell(tonumber(cardId), cellIndex)
    BattleEffectCache:GetSkillPrefabFromCache("cityget", target, nil, 2)
    
    BattleEffectCache:GetSkillPrefabFromCache("VolcanoSkill1", target, function(obj)
        UISound.play("lavameteorite")
        
        --spine
        --local ref = fun.get_component(obj, fun.REFER)
        --local spine = ref:Get("spine")
        --spine:SetAnimation("skill", nil, false, 0)

        local signInterval = 0.2
        local data = Csv.GetData("skill", skillId, "skill_xyz")
        local ori_x = math.modf((cellIndex - 1) / 5)
        local ori_y = math.modf((cellIndex - 1) % 5)
        coroutine.start(function()
            coroutine.wait(0.8)
            
            table.each(data, function(offset, index)
                coroutine.wait((index - 1) * signInterval)
                
                local new_x = ori_x + offset[1]
                local new_y = ori_y - offset[2]
                if new_x >= 0 and new_x <= 4 and new_y >= 0 and new_y <= 4 then
                    local new_index = new_x * 5 + new_y + 1
                    private.TrySignCell(self, cardId, new_index, powerId)
                end
            end)
        end)
    end, 2.5, cardId)
end

--------------------------------------------------------------------------------

function private.TrySignCell(self, cardId, index, powerId)
    local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, index)
    if cellData:IsNotSign() then
        --cellData.isSignByGemPuSkill = true
        self:GetCardPower().cardView:OnClickCardIgnoreJudgeByIndex(cardId, index, powerId)
    end
    self:GetCardPower():ChangeCellState(cardId, index, self.CellState.Signed)
end

return this