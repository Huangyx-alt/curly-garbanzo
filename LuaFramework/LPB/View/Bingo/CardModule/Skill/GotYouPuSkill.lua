local BaseSkill = require "View/Bingo/CardModule/Skill/BaseSkill"
local GotYouPuSkill = BaseSkill:New("GotYouPuSkill")
local this = GotYouPuSkill
local private = {}

function GotYouPuSkill:ShowSkill(cardId, cellIndex, powerId, skillId, serverExtraPos)
    self:ShowSkill01(cardId, cellIndex, powerId, skillId, serverExtraPos)
end

-----------------------------------------------------------skill 1-----------------------------------------------------------Begin
function GotYouPuSkill:ShowSkill01(cardId, cellIndex, powerId, skillId, serverExtraPos)
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
                            if v.itemId == 2034 and fun.is_include(pos, v.posList) then
                                extraPos = v.extraPos
                            end
                        end
                    end)
                end
            end)
        end
    end
    log.log("GotYouPuSkill:ShowSkill02(cardId, cellIndex, , , serverExtraPos), extraPos", cardId, cellIndex, serverExtraPos, extraPos)
    ----测试用代码
    -- if GetTableLength(extraPos) == 0 or true then
    --    extraPos = { 31, 32, 33, 34, 35 }
    -- end

    this.cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
    local cellObj = this.cardView:GetCardCell(tonumber(cardId), cellIndex)
    BattleEffectCache:GetSkillPrefabFromCache("GotYouEmpty", cellObj, function(obj)
        if fun.is_not_null(obj) then
            fun.set_same_position_with_but_z_zero(obj, cellObj)
            self:SameScaleWithCard(obj, cardId)
            LuaTimer:SetDelayFunction(0.1, function()
                local waitSignIdxList = {}
                table.each(extraPos, function(cellID, k)
                    local localCellId = ConvertServerPos(cellID)
                    local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, localCellId)
                    if cellData:IsNotSign() then
                        ---[[
                        BattleEffectCache:GetSkillPrefabFromCache("GotYouskill01get", cellData.obj, function(getObj)
                            self:SameScaleWithCard(getObj, cardId)
                            UISound.play("gotyousquall")
                            LuaTimer:SetDelayFunction(2.5, function()
                                private.TrySignCell(self, cardId, localCellId, powerId)
                            end, false, LuaTimer.TimerType.BattleUI)
                        end, 4, cardId)
                        --]]
                        table.insert(waitSignIdxList, localCellId)
                    end
                    self:GetCardPower():ChangeCellState(cardId, localCellId, self.CellState.Signed)
                end)

                --[[
                local bundle = {}
                bundle.cellIdx = cellIndex
                bundle.finishCallback = function()
                    for i, v in ipairs(waitSignIdxList) do
                        private.TrySignCell(self, cardId, v, powerId)
                    end
                end
                Event.Brocast(EventName.PIG_PU_SKILL, cardId, bundle)
                --]]
                Event.Brocast(EventName.PIG_PU_SKILL, cardId, {forceShow = true})
            end, false, LuaTimer.TimerType.BattleUI)
        else
            log.log("GotYouPuSkill:ShowSkill01 技能加载出错")
        end
    end, 3.5, cardId)
end
-----------------------------------------------------------skill 1-----------------------------------------------------------End

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