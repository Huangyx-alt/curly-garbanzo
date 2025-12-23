local BaseSkill = require "View/Bingo/CardModule/Skill/BaseSkill"
local SolitairePuSkill = BaseSkill:New("SolitairePuSkill")
local this = SolitairePuSkill
local private = {}



function SolitairePuSkill:ShowSkill(cardId, cellIndex, powerId, skillId)
    self:ShowSkillV2(cardId, cellIndex, powerId, skillId)
end

function SolitairePuSkill:ShowSkillV1(cardId, cellIndex, powerId, skillId)
    local stage1AnimTime = 1.2
    local stage2AnimDelay = 0.8
    local stage2AnimTime = 2

    log.log("SolitairePuSkill:ShowSkill(cardId, cellIndex, , )", cardId, cellIndex)
    local target = self:GetCardPower().cardView:GetCardCell(tonumber(cardId), cellIndex)
    BattleEffectCache:GetSkillPrefabFromCache("Solitaireskillyuget", target, function(getObj)
        LuaTimer:SetDelayFunction(stage2AnimDelay, function()
            local newCellIndex = cellIndex % 5
            if newCellIndex == 0 then
                newCellIndex = 5
            end
            local newTarget = self:GetCardPower().cardView:GetCardCell(tonumber(cardId), newCellIndex)
            BattleEffectCache:GetSkillPrefabFromCache("Solitaireskillyu", target, function(obj)
                LuaTimer:SetDelayFunction(stage2AnimTime, function()
                    BattleEffectPool:Recycle("Solitaireskillyu", obj)
                end, nil, LuaTimer.TimerType.Battle)
                local cellIndexs = self:GetSkillCells(cellIndex)
                local idxOffset = 4 - #cellIndexs
                local signDelays = {1, 1.1, 1.2, 1.3}
                table.each(cellIndexs, function(index, key)
                    if private.IsValidIndex(index) then
                        local cellObj = self:GetCardPower().cardView:GetCardCell(tonumber(cardId), index)
                        BattleEffectCache:GetSkillPrefabFromCache("Solitaireskillyubiaoji", cellObj, function(getObj)
                            LuaTimer:SetDelayFunction(signDelays[key + idxOffset], function()
                                private.TrySignCell(self, cardId, index, powerId)
                                BattleEffectPool:Recycle("Solitaireskillyubiaoji", getObj)
                            end, false, LuaTimer.TimerType.Battle)
                        end)
                    end
                end)
            end, 2, cardId)
        end, nil, LuaTimer.TimerType.Battle)

        LuaTimer:SetDelayFunction(stage1AnimTime, function()
            BattleEffectPool:Recycle("Solitaireskillyuget", getObj)
        end, nil, LuaTimer.TimerType.Battle)
    end, 2)
end

function SolitairePuSkill:ShowSkillV2(cardId, cellIndex, powerId, skillId)
    local stage1AnimTime = 2.5
    log.log("SolitairePuSkill:ShowSkill(cardId, cellIndex, , )", cardId, cellIndex)
    local target = self:GetCardPower().cardView:GetCardCell(tonumber(cardId), cellIndex)
    BattleEffectCache:GetSkillPrefabFromCache("Solitaireskillyuget", target, function(getObj)
        this:SameScaleWithCard(getObj, cardId)
        local anim = fun.get_component(getObj, fun.ANIMATOR)
        local cellIndexs = self:GetSkillCells(cellIndex)
        local length = #cellIndexs
        local audioName = private.GetAudioName(length) or "solitaireclownfish"
        UISound.play(audioName)
        local signDelays = {
            {0.6},
            {0.6, 1.2},
            {0.6, 1.2, 1.8},
            {0.6, 1.2, 1.8, 2.4},
        }
        local animaName = "enter" .. length
        if fun.is_not_null(anim) then
            anim:Play(animaName)
        end

        table.each(cellIndexs, function(index, key)
            if private.IsValidIndex(index) then
                LuaTimer:SetDelayFunction(signDelays[length][key], function()
                    private.TrySignCell(self, cardId, index, powerId)
                end, false, LuaTimer.TimerType.Battle)
            end
        end)

        LuaTimer:SetDelayFunction(stage1AnimTime, function()
            BattleEffectPool:Recycle("Solitaireskillyuget", getObj)
        end, nil, LuaTimer.TimerType.Battle)
    end, 3)
end

function SolitairePuSkill:GetSkillCells(startCellIndex)
    local ret = {}
    for i = 1, 4 do
        local tmpIdx = startCellIndex + i * 5
        table.insert(ret, tmpIdx)
        if tmpIdx > 20 then
            break
        end
    end

    return ret
end

------------------------------------------------------------私有方法------------------------------------------------------------Begin
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

local skillSoundNameList = {"solitaireclownfish", "solitaireclownfish2", "solitaireclownfish3", "solitaireclownfish4"}
function private.GetAudioName(length)
    return skillSoundNameList[length]
end
------------------------------------------------------------私有方法------------------------------------------------------------End

return this