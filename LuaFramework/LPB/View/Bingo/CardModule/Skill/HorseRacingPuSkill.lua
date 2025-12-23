local BaseSkill = require "View/Bingo/CardModule/Skill/BaseSkill"
local HorseRacingPuSkill = BaseSkill:New("HorseRacingPuSkill")
local this = HorseRacingPuSkill
local private = {}

function HorseRacingPuSkill:ShowSkill(cardId, cellIndex, powerId, skillId, serverExtraPos)
    if skillId == 136 then
        self:ShowSkill01(cardId, cellIndex, powerId, skillId)
    else
        self:ShowSkill02(cardId, cellIndex, powerId, skillId, serverExtraPos)
    end
end

-----------------------------------------------------------skill 1 弓箭技能  -----------------------------------------------------------Begin
function HorseRacingPuSkill:ShowSkill01(cardId, cellIndex, powerId, skillId)
    log.log("HorseRacingPuSkill:ShowSkill01(cardId, cellIndex, , )", cardId, cellIndex)
    local target = self:GetCardPower().cardView:GetCardCell(tonumber(cardId), cellIndex)
    BattleEffectCache:GetSkillPrefabFromCache("cityget", target, nil, 2)

    BattleEffectCache:GetSkillPrefabFromCache("HorseRacingskill2gongjian", target, function(obj)
        UISound.play("horseracingarrow")
        local cellIndexs = self:GetSkill01Cells(cellIndex)
        local signDelays = {1.1, 1.2, 1.3, 1.4}
        table.each(cellIndexs, function(index, key)
            if private.IsValidIndex(index, cellIndex) then
                local cellObj = self:GetCardPower().cardView:GetCardCell(tonumber(cardId), key)
                BattleEffectCache:GetSkillPrefabFromCache("HorseRacingskill1gongjianget", cellObj, function()
                    --private.TrySignCell(self, cardId, key, powerId)

                    --LuaTimer:SetDelayFunction(1.5, function()
                    --    --this.cardView:OnClickCardIgnoreJudgeByIndex(cardId, localCellId, powerId)
                    --    private.TrySignCell(self, cardId, localCellId, powerId)
                    --    --remove
                    --    --Event.Brocast(EventName.Event_Collect_Item_By_Sign, cardId, localCellId)
                    --end, false, LuaTimer.TimerType.BattleUI)
                    LuaTimer:SetDelayFunction(signDelays[key], function()
                        private.TrySignCell(self, cardId, index, powerId)
                    end, false, LuaTimer.TimerType.BattleUI)

                end)

                --LuaTimer:SetDelayFunction(signDelays[key], function()
                --    private.TrySignCell(self, cardId, index, powerId)
                --end, false, LuaTimer.TimerType.BattleUI)
            end
        end)
    end, 2, cardId)
end

function HorseRacingPuSkill:GetSkill01Cells(startCellIndex)
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
-----------------------------------------------------------skill 1-----------------------------------------------------------End

-----------------------------------------------------------skill 2-----------------------------------------------------------Begin
function HorseRacingPuSkill:GetSkill02Cells(startCellIndex)
    local ret = {}
    for i = 1, 4 do
        local tmpIdx = startCellIndex - i
        if tmpIdx % 5 > 0 then
            table.insert(ret, tmpIdx)
        else
            break
        end
    end

    return ret
end

function HorseRacingPuSkill:ShowSkill02(cardId, cellIndex, powerId, skillId, serverExtraPos)
    local pos = ConvertCellIndexToServerPos(cellIndex)
    local extraPos = {}
    local cardIndex = tonumber(cardId)

    if serverExtraPos then
        extraPos = BattleTool.GetExtraPos(serverExtraPos)
    else
        this.powerUpData = ModelList.BattleModel:GetCurrModel():LoadGameData().powerUpData
        for i = 1, #this.powerUpData do
            if powerId == this.powerUpData[i].powerUpId then
                for m = 1, #this.powerUpData[i].cardPowerUpEffect do
                    if this.powerUpData[i].cardPowerUpEffect[m].cardId == cardIndex and
                            fun.is_include(pos, this.powerUpData[i].cardPowerUpEffect[m].posList) then
                        extraPos = this.powerUpData[i].cardPowerUpEffect[m].extraPos
                        break
                    end
                end
            end
            if extraPos then
                break
            end
        end

        if not extraPos then
            local cardsInfo = ModelList.BattleModel:GetCurrModel():GetLoadCardInfo(cardId)
            table.each(cardsInfo and cardsInfo.beginSkillData, function(data)
                if not extraPos then
                    table.each(data.effect, function(v)
                        if not extraPos then
                            if v.itemId == 2027 and fun.is_include(pos, v.posList) then
                                extraPos = v.extraPos
                            end
                        end
                    end)
                end
            end)
        end
    end
    log.log("HorseRacingPuSkill:ShowSkill02(cardId, cellIndex, , , serverExtraPos), extraPos", cardId, cellIndex, serverExtraPos, extraPos)
    ----测试用代码
    --if GetTableLength(extraPos) == 0 then
    --    extraPos = { 7, 19 }
    --end

    this.cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
    local cellObj = this.cardView:GetCardCell(tonumber(cardId), cellIndex)
    BattleEffectCache:GetSkillPrefabFromCache("HorseRacingskill1shaozi", cellObj, function(obj)
        fun.set_same_position_with_but_z_zero(obj, cellObj)
        self:SameScaleWithCard(obj, cardId)
        UISound.play("horseracingwhistle")
        LuaTimer:SetDelayFunction(1, function()
            table.each(extraPos, function(cellID, k)
                local localCellId = ConvertServerPos(cellID)
                local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, localCellId)
                if cellData:IsNotSign() then
                    --cellData.isSignByGemBingoSkill = true
                    BattleEffectCache:GetSkillPrefabFromCache("HorseRacingskill1shaoziget", cellData.obj, function()
                        LuaTimer:SetDelayFunction(1.5, function()
                            --this.cardView:OnClickCardIgnoreJudgeByIndex(cardId, localCellId, powerId)
                            private.TrySignCell(self, cardId, localCellId, powerId)
                            --remove
                            --Event.Brocast(EventName.Event_Collect_Item_By_Sign, cardId, localCellId)
                        end, false, LuaTimer.TimerType.BattleUI)
                    end, 2, cardId)
                end
                self:GetCardPower():ChangeCellState(cardId, localCellId, self.CellState.Signed)
            end)
        end, false, LuaTimer.TimerType.BattleUI)
    end, 3.5, cardId)
end
-----------------------------------------------------------skill 2-----------------------------------------------------------End

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
