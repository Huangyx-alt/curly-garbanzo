local BaseFlyItemEffect = require("View.Bingo.EffectModule.Card.FlyItemEffect.BaseFlyItemEffect")

local NewLeetoleManFlyItemEffect = BaseFlyItemEffect:New("NewLeetoleManFlyItemEffect")
local this = NewLeetoleManFlyItemEffect

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
        if 41 == data.result[1] then
            --创建飞行道具
            local effectName = "flyItem"
            local cellObj = curCell:GetCellObj()
            local flyObj = BattleEffectPool:Get(effectName, cellObj)
            flyObj.transform.position = cellObj.transform.position
            local parentObj, flyAnim = self:GetCardView():GetCard(cardId).flyItemRoot
            if fun.is_not_null(parentObj) and fun.is_not_null(flyObj) then
                fun.set_parent(flyObj, parentObj)
                flyAnim = fun.get_component(flyObj, fun.ANIMATOR)
                if flyAnim then
                    flyAnim:Play("in1")
                end
            end
            
            --格子上展示道具
            --Event.Brocast(EventName.Event_Sign_Cell_Background, data.result[2], cardId, cellIndex, nil, nil)
            UISound.play("newleetolemanflyin")

            if fun.is_null(flyObj) then
                return
            end
            
            coroutine.start(function()
                coroutine.wait(1)
                --道具收集后逻辑
                Event.Brocast(EventName.Event_Logic_Collect_Item, cardId, cellIndex, data.result[2], 1)
                
                --飞行对象及飞行时间
                local moveTime, targetPos = self:GetTreasureFlyTime(tonumber(cardId), flyObj, data.result[2])
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
                    Event.Brocast(EventName.Event_View_Collect_Item, cardId, data.result[2])
                    UISound.play("newleetolemanadd")
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
    
    --先做标识，不寻路
    table.each(cellPosList, function(cellID, k)
        cellData = model:GetRoundData(cardId, cellID)
        cellData.isGained = true
    end)
    
    BattleEffectCache:GetSkillPrefabFromCache("NewLeetoleManskill1", cellData.obj, function(obj)
        self:SameScaleWithCard(obj, cardId)
        UISound.play("newleetolemanjar")

        coroutine.start(function()
            coroutine.wait(1.5)

            if isExtraPosValid then
                table.each(cellPosList, function(cellID, k)
                    cellData = model:GetRoundData(cardId, cellID)
                    BattleEffectCache:GetSkillPrefabFromCache("NewLeetoleManBingoSkillget", cellData.obj, function()
                        --直接获得宝箱
                        if cellData:IsNotSign() then
                            cardView:OnClickCardIgnoreJudgeByIndex(cardId, cellID, powerId)
                        end
                        Event.Brocast(EventName.Event_Collect_Item_By_Sign, cardId, cellID)
                        
                        coroutine.wait(0.2)
                        --道具消失
                        local effectList = cardView:GetCellBgEffect(cardId, cellID)
                        table.each(effectList, function(effect)
                            fun.set_active(effect, false)
                        end)
                    end, 2, cardId)
                    cardPower:ChangeCellState(cardId, cellID, cardPower.CellState.Signed)
                end)
            end
        end)
    end, 2.5, cardId)
end

return this