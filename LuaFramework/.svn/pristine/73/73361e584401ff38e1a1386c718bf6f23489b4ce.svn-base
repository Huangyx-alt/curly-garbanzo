local BaseFlyItemEffect = require("View.Bingo.EffectModule.Card.FlyItemEffect.BaseFlyItemEffect")

local CandyFlyItemEffect = BaseFlyItemEffect:New("CandyFlyItemEffect")
local this = CandyFlyItemEffect

function this:Remove()
    Event.RemoveListener(EventName.Event_Collect_Item_By_Sign, self.CreateTreasure, self)
    Event.RemoveListener(EventName.Event_Show_Skill_Bingo, self.ShowSkillBingo, self)
end

function this:Register()
    Event.AddListener(EventName.Event_Collect_Item_By_Sign, self.CreateTreasure, self)
    Event.AddListener(EventName.Event_Show_Skill_Bingo, self.ShowSkillBingo, self)
end

function this:CreateTreasure(cardId, cellIndex)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local curCell = curModel:GetRoundData(cardId, cellIndex)
    local treasureItems = curCell:Treasure2Item()

    if treasureItems then
        local data = Csv.GetData("item", treasureItems.id)
        if 33 == data.result[1] then
            local ext = curCell:GetExtInfo()
            local groupCells = ext and ext.groupCells
            if groupCells then
                --group中的格子是否都被盖章
                local isAllSigned, pos = true, Vector3.zero
                table.each(groupCells, function(cellData)
                    if cellData then
                        local cellObj = cellData:GetCellObj()
                        pos = pos + cellObj.transform.position
                        isAllSigned = isAllSigned and not (cellData:IsNotSign() or cellData:IsLogicSign())
                    end
                end)
                if not isAllSigned then
                    pos = pos / #groupCells
                    Event.Brocast(EventName.Event_Sign_Cell_Background, data.result[2], cardId, cellIndex, treasureItems.part, pos)
                    return
                end
            end

            --local effectName = string.format("treasureFlyItem0%s", data.result[2])
            local effectName = "treasureFlyItem01"
            local cellObj = curCell:GetCellObj()
            local centerPos = this:GetTypeCellsCenterPos(cardId, data.result[2])
            local flyObj = BattleEffectPool:Get(effectName, cellObj)
            
            local parentObj = self:GetCardView():GetCard(cardId).flyItemRoot
            local flyAnim = nil
            if fun.is_not_null(parentObj) and fun.is_not_null(flyObj) then
                fun.set_parent(flyObj, parentObj)
                flyObj.transform.position = centerPos
                flyAnim  = fun.get_component(flyObj, fun.ANIMATOR)
                if flyAnim then   flyAnim:Play("in1") end
            end
            Event.Brocast(EventName.Event_Sign_Cell_Background, data.result[2], cardId, cellIndex, nil, nil)
            UISound.play("candysweetsflyin")

            --LuaTimer:SetDelayFunction(0.1, function()
            --逻辑层先添加,下一步计算要用到
            Event.Brocast(EventName.Event_Logic_Collect_Item, cardId, cellIndex, data.result[2], 1)

            --星星跳出来的动画，到最大的时候，情绪最饱满，这时候就播放BINGO动画和语音
            CalculateBingoMachine.OnDataChange(tonumber(cardId), 0, data.result[2], 1)
            CalculateBingoMachine.CalcuateBingo(tonumber(cardId))
            --end, false, LuaTimer.TimerType.BattleUI)

            LuaTimer:SetDelayFunction(1, function()
                if fun.is_null(flyObj) then
                    return
                end

                local moveTime, targetPos = self:GetTreasureFlyTime(tonumber(cardId), flyObj, data.result[2])
                local coverObj = UnityEngine.GameObject.New()
                fun.set_parent(coverObj, flyObj.transform.parent, true)
                fun.set_gameobject_scale(flyObj, 1, 1, 1)
                coverObj.transform.position = targetPos
                local localTargetPos = fun.get_gameobject_pos(coverObj, true)
                localTargetPos = localTargetPos - fun.get_child(flyObj.transform, 0).localPosition
                Destroy(coverObj)

                --Event.Brocast(EventName.Event_Logic_Collect_Item, cardId, cellIndex, data.result[2], 1)

                flyObj.transform:SetSiblingIndex(0)
                if flyAnim then          flyAnim:Play("idlefei") end
                Anim.move(flyObj, localTargetPos.x, localTargetPos.y, localTargetPos.z, moveTime, true, true, function()
                    BattleEffectPool:Recycle(effectName, flyObj)
                    Event.Brocast(EventName.Event_View_Collect_Item, cardId, data.result[2])
                    UISound.play("candysweetsadd")
                end)
            end, false, LuaTimer.TimerType.BattleUI)
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

function this:GetTypeCellsCenterPos(cardId, type)
    local pos = Vector3.zero
    local cells = BattleLogic.GetLogicModule(LogicName.Card_logic):GetCellsByMaterialType(cardId, type)
    table.each(cells, function(cellData, k)
        local cellObj = cellData:GetCellObj()
        pos = pos + fun.get_gameobject_pos(cellObj)
    end)
    pos = pos / #cells
    return pos
end

function this:ShowSkillBingo(cardId, cellIndex)
    local model = ModelList.BattleModel:GetCurrModel()
    local cardPower = BattleModuleList.GetModule("CardPower")
    local cellData = model:GetRoundData(cardId, cellIndex)
    local powerId, serverExtraPos = cellData:GetPowerupId(), cellData:GetPuExtraPos()
    local extraPos, cellPosList, type = BattleTool.GetExtraPos(serverExtraPos), {}
    local cardView = cardPower.cardView

    if #extraPos > 0 then
        cellPosList, type = model:CheckBingoSkillExtraPosValid(cardId, extraPos, cellIndex)
    end
    
    if GetTableLength(cellPosList) == 0 then
        return
    end
    
    model:GetRoundData(cardId):AddExtraUpLoadData("cardHitGridBingo", {
        cardId = tonumber(cardId),
        pos = ConvertCellIndexToServerPos(cellIndex),
        extraPos = BattleTool.ConvertedToServerPosList(cellPosList),
    }, "pos")

    --计算中心点                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    local pos = Vector3.zero
    if type then
        pos = this:GetTypeCellsCenterPos(cardId, type)
    else
        table.each(cellPosList, function(cellID, k)
            local cellObj = cardView:GetCardCell(tonumber(cardId), cellID)
            pos = pos + fun.get_gameobject_pos(cellObj)
        end)
        pos = pos / #cellPosList
    end

    --中心点出特效
    BattleEffectCache:GetSkillPrefabFromCache("Candyskillxiongzhang", nil, function(obj)
        obj.transform.position = pos
        self:SameScaleWithCard(obj, cardId)
        UISound.play("candysweetsbear")

        LuaTimer:SetDelayFunction(1, function()
            table.each(cellPosList, function(cellID, k)
                cellData = model:GetRoundData(cardId, cellID)
                if cellData:IsNotSign() then
                    --cellData.isSignByGemBingoSkill = true
                    cardView:OnClickCardIgnoreJudgeByIndex(cardId, cellID, powerId)
                end
                cardPower:ChangeCellState(cardId, cellID, cardPower.CellState.Signed)
            end)
        end, false, LuaTimer.TimerType.BattleUI)
    end, 2, cardId)
end

return this