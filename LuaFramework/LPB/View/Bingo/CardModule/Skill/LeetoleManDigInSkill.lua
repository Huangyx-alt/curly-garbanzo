
local BaseSkill = require "View/Bingo/CardModule/Skill/BaseSkill"

local LeetoleManDigInSkill = BaseSkill:New("LeetoleManDigInSkill")
setmetatable(LeetoleManDigInSkill,BaseSkill)
local this = LeetoleManDigInSkill
local private = {}

function LeetoleManDigInSkill:ShowDigInSkill(cardId,cellIndex,powerId,skillId)
    local target = self:GetCardPower().cardView:GetCardCell(tonumber(cardId), cellIndex)
    BattleEffectCache:GetSkillPrefabFromCache("cityget", target, nil, 2)
    --LuaTimer:SetDelayFunction(0.5, function()
    --local targetObj = self:GetCardPower().cardView:GetCardMap(tonumber(cardId))
    BattleEffectCache:GetSkillPrefabFromCache("LeetoleManJNjinchanzi", target, function(obj)
        self:SaveSkillInfo(cardId,obj)
        UISound.play("stpatrick_goldspade")
        fun.set_same_position_with_but_z_zero(obj, target)
        self:SameScaleWithCard(obj, cardId)
        local reftemp = fun.get_component(obj.transform,fun.ANIMATOR)
        local indexFloor = math.floor(math.max((cellIndex - 1)) / 5)
        if 0 == indexFloor then
            reftemp:Play("LeetoleManJNjinchanzi01")
        elseif 1 == indexFloor then
            reftemp:Play("LeetoleManJNjinchanzi02")
        elseif 2 == indexFloor then
            reftemp:Play("LeetoleManJNjinchanzi03")
        elseif 3 == indexFloor then
            reftemp:Play("LeetoleManJNjinchanzi04")
        elseif 4 == indexFloor then
            reftemp:Play("LeetoleManJNjinchanzi05")
        end
        if indexFloor <= 3 then
            LuaTimer:SetDelayFunction(1.7, function()
                if ModelList.BattleModel:GetCurrModel():GetRoundData(cardId,cellIndex + 5):IsNotSign() then
                    self:GetCardPower().cardView:OnClickCardIgnoreJudgeByIndex(cardId, cellIndex + 5, powerId)
                end
                self:GetCardPower():ChangeCellState(cardId, cellIndex + 5, self.CellState.Signed)
            end,nil,LuaTimer.TimerType.Battle)
        end
        if indexFloor <= 2 then
            LuaTimer:SetDelayFunction(1.9, function()
                if ModelList.BattleModel:GetCurrModel():GetRoundData(cardId,cellIndex + 10):IsNotSign() then
                    self:GetCardPower().cardView:OnClickCardIgnoreJudgeByIndex(cardId, cellIndex + 10, powerId)
                end
                self:GetCardPower():ChangeCellState(cardId, cellIndex + 10, self.CellState.Signed)
            end,nil,LuaTimer.TimerType.Battle)
        end
        if indexFloor <= 1 then
            LuaTimer:SetDelayFunction(2, function()
                if ModelList.BattleModel:GetCurrModel():GetRoundData(cardId,cellIndex + 15):IsNotSign() then
                    self:GetCardPower().cardView:OnClickCardIgnoreJudgeByIndex(cardId, cellIndex + 15, powerId)
                end
                self:GetCardPower():ChangeCellState(cardId, cellIndex + 15, self.CellState.Signed)
            end,nil,LuaTimer.TimerType.Battle)
        end
        if 0 == indexFloor then
            LuaTimer:SetDelayFunction(2.2, function()
                if ModelList.BattleModel:GetCurrModel():GetRoundData(cardId,cellIndex + 20):IsNotSign() then
                    self:GetCardPower().cardView:OnClickCardIgnoreJudgeByIndex(cardId, cellIndex + 20, powerId)
                end
                self:GetCardPower():ChangeCellState(cardId, cellIndex + 20, self.CellState.Signed)
            end,nil,LuaTimer.TimerType.Battle)
        end
        LuaTimer:SetDelayFunction(4.5,function()
            self:RemoveSkillInfo(obj)
            BattleEffectPool:Recycle("LeetoleManJNjinchanzi", obj)
            --Destroy(obj)
        end,nil,LuaTimer.TimerType.Battle)
    end,0, cardId)
end

-------------------------私有方法-------------------------------------------------------


return this