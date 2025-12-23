--- 城市炸弹技能
local BaseSkill =  require("View.Bingo.CardModule.Skill.BaseSkill")
local CityBoomSkill = CreateInstance_(BaseSkill, "CityBoomSkill")
local this = CityBoomSkill
local private = {}

function CityBoomSkill:ShowSkill(cardId, cellIndex, powerId, skillID, serverExtraPos)
    local extraPos = {}
    local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
    
    --后端没给数据，自己算
    local data = Csv.GetData("skill", skillID, "skill_xyz")
    for i = 1, #data do
        local offset = data[i]
        local ori_x = math.modf((cellIndex - 1) / 5)
        local ori_y = math.modf((cellIndex - 1) % 5)
        local new_x = ori_x + offset[1]
        local new_y = ori_y - offset[2]
        if new_x >= 0 and new_x <= 4 and new_y >= 0 and new_y <= 4 then
            local new_index = new_x * 5 + new_y + 1
            table.insert(extraPos, new_index)
        end
    end

    for i = 1, #extraPos do
        --技能特效，每个爆炸间隔0.15秒
        LuaTimer:SetDelayFunction(0.15 * i, function()
            --local targetObj = cardView:GetCardCell(tonumber(cardId), cellIndex)
            local clientPos = extraPos[i]
            local cellObj = cardView:GetCardCell(tonumber(cardId), clientPos)
            local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, clientPos)
            if cellData and cellData:IsNotSign() then
                BattleEffectCache:GetSkillPrefabFromCache("clown_Paozhu", cellObj, function(ob)
                    UISound.play("powerup_firecrackers")

                    --盖章
                    cardView:OnClickCardIgnoreJudgeByIndex(cardId, clientPos, powerId)
                    self:GetCardPower():ChangeCellState(cardId, clientPos, self.CellState.Signed)
                end, 3)
            end
        end)
    end
end


return this