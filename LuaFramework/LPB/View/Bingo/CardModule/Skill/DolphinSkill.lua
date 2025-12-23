--海豚技能 详情https://www.tapd.cn/32691960/prong/stories/view/1132691960001000079
local BaseSkill = require("View.Bingo.CardModule.Skill.BaseSkill")

local DolphinSkill = BaseSkill:New("DolphinSkill")
setmetatable(DolphinSkill, BaseSkill)
local this = DolphinSkill
local animaTime1 = 0.5
local animaTime2 = 1
local delayTime1 = 0
local delayTime2 = 0
local delayTime3 = 3 --粒子
local delayTime4 = 3 --粒子
local stepLength = 10

function DolphinSkill:ShowSkill(cardId, cellIndex, powerId, serverExtraPos)
    log.log("DolphinSkill:ShowSkill 触发海豚技能 ", cardId, cellIndex, powerId, serverExtraPos)
    local pos = ConvertCellIndexToServerPos(cellIndex)
    local extraPos = nil
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
                            if v.itemId == 3004 and fun.is_include(pos, v.posList) then
                                extraPos = v.extraPos
                            end
                        end
                    end)
                end
            end)
        end
    end

    --[[测试用代码
    if GetTableLength(extraPos) == 0 then
       extraPos = {7, 19}
    end
    --]]

    if extraPos and #extraPos > 0 then
        this.cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
        local mapObj = this.cardView:GetCardMap(tonumber(cardId))
        local cellObj = this.cardView:GetCardCell(tonumber(cardId), cellIndex)
        for i = 1, #extraPos do
            this:ReleaseSkill(mapObj, cellObj, cardId, ConvertServerPos(extraPos[i]), powerId, i == 1)
        end
    else
        log.log("DolphinSkill:ShowSkill 触发海豚技能 extraPos 为空", extraPos)
    end
end

function DolphinSkill:ReleaseSkill(mapObj, cellObj, cardID, targetCellIndex, powerId, isFirst)
    log.log("DolphinSkill:ReleaseSkill 释放海豚技能0 ", cardID, targetCellIndex, powerId, isFirst)
    if isFirst then
        BattleEffectCache:GetSkillPrefabFromCache("clown_Haitun", nil, function(obj)
            log.log("DolphinSkill:ReleaseSkill 释放海豚技能0 clown_Haitun 加完成 ")
            fun.set_same_position_with(obj, cellObj)
            fun.set_parent(obj, mapObj)
            LuaTimer:SetDelayFunction(animaTime1 + delayTime3, function()
                BattleEffectPool:Recycle("clown_Haitun", obj)
            end, false, LuaTimer.TimerType.Battle)
        end, 0, cardID)
    end

    local targetCell = this.cardView:GetCardCell(tonumber(cardID), targetCellIndex)
    BattleEffectCache:GetSkillPrefabFromCache("clown_Haitunget", nil, function(obj)
        log.log("DolphinSkill:ReleaseSkill 释放海豚技能1 clown_Haitunget 加完成 ")
        UISound.play("dolphin")
        fun.set_same_position_with(obj, targetCell)
        fun.set_parent(obj, mapObj)

        LuaTimer:SetDelayFunction(delayTime1, function()
            if this:IsValidIndex(targetCellIndex) then
                this:TrySignCell1(cardID, targetCellIndex, powerId)
            else
                log.log("DolphinSkill:ReleaseSkill 释放海豚技能1 index invalid  ", targetCellIndex)
            end
        end, false, LuaTimer.TimerType.Battle)

        local anima = fun.get_component(obj, fun.ANIMATOR)
        if anima and fun.is_not_null(anima) then
            log.log("DolphinSkill:ReleaseSkill 释放海豚技能2 动画完成回调1")
            AnimatorPlayHelper.Play(anima, {"get", "clown_Haitunget2"}, false, 
                function()
                    log.log("DolphinSkill:ReleaseSkill 释放海豚技能2 动画完成回调2")
                    LuaTimer:SetDelayFunction(delayTime1, function()
                        log.log("DolphinSkill:ReleaseSkill 释放海豚技能2 动画完成回调3")
                        this:TrySignCell2(cardID, targetCellIndex, powerId)
                        LuaTimer:SetDelayFunction(delayTime4, function()
                            BattleEffectPool:Recycle("clown_Haitunget", obj)
                        end, false, LuaTimer.TimerType.Battle)
                    end, false, LuaTimer.TimerType.Battle)
                end
            )
        else
            log.log("DolphinSkill:ReleaseSkill 释放海豚技能3 定时回调1")
            LuaTimer:SetDelayFunction(animaTime2 + delayTime1, function()
                log.log("DolphinSkill:ReleaseSkill 释放海豚技能3 定时回调2")
                this:TrySignCell2(cardID, targetCellIndex, powerId)
                BattleEffectPool:Recycle("clown_Haitunget", obj)
            end, false, LuaTimer.TimerType.Battle)
        end
    end, 0, cardID)
end

function DolphinSkill:IsValidIndex(index)
    return index >= 1 and index <= 25
end

function DolphinSkill:TrySignCell1(cardId, index, powerId)
    local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, index)
    if cellData:IsNotSign() then
        --cellData.isSignByGemPuSkill = true
        self.cardView:OnClickCardIgnoreJudgeByIndex(cardId, index, powerId)
    else
        log.log("DolphinSkill:TrySignCell1 尝试盖章失败 此位置已盖过章 ", index)
    end
    self.cardPower:ChangeCellState(cardId, index, self.CellState.Signed)
end

function DolphinSkill:TrySignCell2(cardId, index, powerId)
    local targIndex = index + stepLength
    if self:IsValidIndex(targIndex) then
        self:TrySignCell1(cardId, targIndex, powerId)
    else
        log.log("DolphinSkill:TrySignCell2 尝试盖章失败 targIndex ", targIndex)
    end
end

return this