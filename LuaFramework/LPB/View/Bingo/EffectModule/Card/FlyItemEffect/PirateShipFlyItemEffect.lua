local BaseFlyItemEffect = require("View.Bingo.EffectModule.Card.FlyItemEffect.BaseFlyItemEffect")

local PirateShipFlyItemEffect = BaseFlyItemEffect:New("PirateShipFlyItemEffect")
local this = PirateShipFlyItemEffect

function this:Remove()
    this.playAnimFlag = {}
    Event.RemoveListener(EventName.Event_Collect_Item_By_Sign, self.CreateTreasure, self)
    Event.RemoveListener(EventName.Event_Show_Skill_Bingo, self.ShowSkillBingo, self)
end

function this:Register()
    this.playAnimFlag = {} --标识状态，用于连续触发多个bingo时做判断
    Event.AddListener(EventName.Event_Collect_Item_By_Sign, self.CreateTreasure, self)
    Event.AddListener(EventName.Event_Show_Skill_Bingo, self.ShowSkillBingo, self)
end

function this:CreateTreasure(cardId, cellIndex)
    this.playAnimFlag[cardId] = this.playAnimFlag[cardId] or 0
    
    local curModel = ModelList.BattleModel:GetCurrModel()
    local curCell = curModel:GetRoundData(cardId, cellIndex)
    local treasureItems = curCell:Treasure2Item()
    
    if treasureItems then
        local data = Csv.GetData("new_item", treasureItems.id)
        if 11 == data.result[1] then
            local effectName = "flyItem"
            local cellObj = curCell:GetCellObj()
            local flyObj = BattleEffectPool:Get(effectName, cellObj)
            flyObj.transform.position = cellObj.transform.position
            
            local parentObj = self:GetCardView():GetEffectPlayRoot(cardId, BingoBangEntry.BattleContainerType.BingoEffectContainer)
            local flyAnim
            if fun.is_not_null(parentObj) and fun.is_not_null(flyObj) then
                --图片
                local refer = fun.get_component(flyObj, fun.REFER)
                local ExplorersBox1 = refer:Get("ExplorersBox1")
                local ExplorersBox5 = refer:Get("ExplorersBox5")
                local ExplorersBoxOpen1 = refer:Get("ExplorersBoxOpen1")
                local ExplorersBoxOpen5 = refer:Get("ExplorersBoxOpen5")
                local isMaxBet = curModel:GetIsMaxBet()
                fun.set_active(ExplorersBox1, not isMaxBet)
                fun.set_active(ExplorersBoxOpen1, not isMaxBet)
                fun.set_active(ExplorersBox5, isMaxBet)
                fun.set_active(ExplorersBoxOpen5, isMaxBet)
                
                fun.set_parent(flyObj, parentObj)
                flyAnim = fun.get_component(flyObj, fun.ANIMATOR)
                if flyAnim then
                    flyAnim:Play("in1")
                end
            end
            
            --Event.Brocast(EventName.Event_Sign_Cell_Background, data.result[3], cardId, cellIndex, nil, nil)
            UISound.play("pirateflyin")

            if fun.is_null(flyObj) then
                return
            end

            this.playAnimFlag[cardId] = this.playAnimFlag[cardId] + 1
            log.r(string.format("[PirateShipLog] cardId:%s, playAnimCount before:%s", cardId, this.playAnimFlag[cardId]))
            
            coroutine.start(function()
                coroutine.wait(1)
                Event.Brocast(EventName.Event_Logic_Collect_Item, cardId, cellIndex, data.result[3], 1)
                
                local moveTime, targetPos = self:GetTreasureFlyTime(tonumber(cardId), flyObj, data.result[3])
                local coverObj = UnityEngine.GameObject.New()
                fun.set_parent(coverObj, flyObj.transform.parent, true)
                fun.set_gameobject_scale(flyObj, 1, 1, 1)
                coverObj.transform.position = targetPos
                local localTargetPos = fun.get_gameobject_pos(coverObj, true)
                localTargetPos = localTargetPos - fun.get_child(flyObj, 0).localPosition
                Destroy(coverObj)

                flyObj.transform:SetSiblingIndex(0)
                if flyAnim then
                    flyAnim:Play("idlefei")
                end
                Anim.move(flyObj, localTargetPos.x, localTargetPos.y, localTargetPos.z, moveTime, true, true, function()
                    BattleEffectPool:Recycle(effectName, flyObj)
                    Event.Brocast(EventName.Event_View_Collect_Item, cardId, data.result[3])
                    UISound.play("pirateadd")
                    
                    LuaTimer:SetDelayFunction(1.15, function()
                        this.playAnimFlag[cardId] = this.playAnimFlag[cardId] - 1
                        log.r(string.format("[PirateShipLog] cardId:%s, playAnimCount after:%s", cardId, this.playAnimFlag[cardId]))
                        if this.playAnimFlag[cardId] <= 0 then
                            local haveNextBingo = curModel.moveMachine and curModel.moveMachine:HaveMoveTarget(cardId)
                            log.r(string.format("[PirateShipLog] cardId:%s, haveNextBingo:%s", cardId, haveNextBingo))
                            if not haveNextBingo then
                                CalculateBingoMachine.CalcuateBingo(cardId)
                            end
                        end
                    end)
                end)
            end)
        end
    end
end

function this:GetTreasureFlyTime(cardId, fly, itemType)
    local cardView = self:GetCardView()
    if cardView and cardView["GetFlyTargetPos"] then
        local targetPos = cardView:GetFlyTargetPos(cardId, itemType)
        local dis = Vector3.Distance(targetPos, fun.get_gameobject_pos(fly))
        return (dis / 4) * 1.2, targetPos
    end

    return 1
end

function this:CheckAllAnimShowOver(cardId)
    this.playAnimFlag = this.playAnimFlag or 0
    
    local ret = true
    table.each(this.playAnimFlag, function(count, cardid)
        if not cardId or cardId == cardid then
            ret = ret and count <= 0
        end
    end)
    return ret
end

function this:ShowSkillBingo(cardId, cellIndex)
    local model = ModelList.BattleModel:GetCurrModel()
    local cardPower = BattleModuleList.GetModule("CardPower")
    local cellData = model:GetRoundData(cardId, cellIndex)
    local powerId, serverExtraPos = cellData:GetPowerupId(), cellData:GetPuExtraPos()
    local extraPos, cellPosList = BattleTool.GetExtraPos(serverExtraPos), {}
    local cardView = cardPower.cardView

    if #extraPos > 0 then
        cellPosList = model:CheckBingoSkillExtraPosValid(cardId, extraPos, cellIndex)
    end

    local isExtraPosValid = GetTableLength(cellPosList) > 0
    if isExtraPosValid then
        model:GetRoundData(cardId):AddExtraUpLoadData("cardHitGridBingo", {
            cardId = tonumber(cardId),
            pos = ConvertCellIndexToServerPos(cellIndex),
            extraPos = BattleTool.ConvertedToServerPosList(cellPosList),
        }, "pos")
    end
    
    table.each(cellPosList, function(cellID, k)
        local data = model:GetRoundData(cardId, cellID)
        data.isGained = true
    end)
    
    BattleEffectCache:GetSkillPrefabFromCache("PirateShipBingoSkill", cellData.obj, function(obj)
        self:SameScaleWithCard(obj, cardId)
        UISound.play("piratecompass")

        if isExtraPosValid then
            table.each(cellPosList, function(cellID, k)
                cellData = model:GetRoundData(cardId, cellID)
                BattleEffectCache:GetSkillPrefabFromCache("PirateShipBingoSkillget", cellData.obj, function()
                    coroutine.start(function()
                        coroutine.wait(2)
                        if cellData:IsNotSign() then
                            cardView:OnClickCardIgnoreJudgeByIndex(cardId, cellID, powerId)
                        end
                        Event.Brocast(EventName.Event_Collect_Item_By_Sign, cardId, cellID)

                        coroutine.wait(0.2)
                        local effectList = cardView:GetCellBgEffect(cardId, cellID)
                        table.each(effectList, function(effect)
                            fun.set_active(effect, false)
                        end)
                    end)
                end, 4, cardId)
                cardPower:ChangeCellState(cardId, cellID, cardPower.CellState.Signed)
            end)
        end
    end, 4, cardId)
end

return this