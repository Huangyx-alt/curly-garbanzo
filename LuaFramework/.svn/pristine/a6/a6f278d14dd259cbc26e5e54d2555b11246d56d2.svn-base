local BaseFlyItemEffect = require("View.Bingo.EffectModule.Card.FlyItemEffect.BaseFlyItemEffect")

local DrinkingFrenzyFlyItemEffect = BaseFlyItemEffect:New("DrinkingFrenzyFlyItemEffect")
local this = DrinkingFrenzyFlyItemEffect

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
    log.log("创建特效开始 " , treasureItems)
    if treasureItems then
        local data = Csv.GetData("new_item", treasureItems.id)
        local bigCellIndexMin = nil
        local bigCellIndexMax = nil
        if 11 == data.result[1] then
            --收集到的道具
            local effectName = ""
            --if 1 == data.result[3] or 2 == data.result[3] then
            if curModel:CheckIsBigGlass(treasureItems.id) then
                local ext = curCell:GetExtInfo()
                local groupCells = ext and ext.groupCells
                if groupCells then
                    --group中的格子是否都被盖章
                    local isAllSigned, pos = true, Vector3.zero
                    local indexList = {}
                    local NotSignNum = 0
                    local notSignCellIndex = nil
                    table.each(groupCells, function(cellData)
                        if cellData then
                            local cellObj = cellData:GetCellObj()
                            pos = pos + cellObj.transform.position
                            local isNotSign = cellData:IsNotSign()
                            local isLogicSign = cellData:IsLogicSign()
                            isAllSigned = isAllSigned and not (isNotSign or isLogicSign)
                            table.insert(indexList, cellData.index)
                            if not bigCellIndexMin or bigCellIndexMin > cellData.index then
                                bigCellIndexMin = cellData.index
                            end

                            if not bigCellIndexMax or bigCellIndexMax < cellData.index then
                                bigCellIndexMax = cellData.index                                
                            end
                            
                            if isNotSign then
                                NotSignNum = NotSignNum + 1
                                notSignCellIndex = cellData.index
                            end
                        end
                    end)

                    if NotSignNum == 1 or NotSignNum == 2 or NotSignNum == 3  then
                        self:ShowRightPlayerWaitBeer(cardId)
                    end

                    if NotSignNum == 1 then
                        --CalculateBingoMachine.OnDataChange(cardId, cellIndex,true  ,1 ) -- for wish
                        CalculateBingoMachine.OnDataChange(cardId, cellIndex,true , 0 ,1,notSignCellIndex ) -- for wish
                    end
                    
                    

                    if not isAllSigned then
                        pos = pos / #groupCells
                        log.log("DrinkingFrenzyFlyItemEffect:CreateTreasure 00 cardId, cellIndex, #groupCells, indexList, pos ", cardId, cellIndex, #groupCells, indexList, pos)
                        Event.Brocast(EventName.Event_Sign_Cell_Background, treasureItems.id,data.result[3], cardId, cellIndex, data.icon, treasureItems.part, pos)
                        return
                    end
                end
            end

            if treasureItems.id == 261001 then
                effectName = "treasureFlyItem02"
            elseif treasureItems.id == 261002 or treasureItems.id == 261003 then
                effectName = "treasureFlyItem01"
            end    
            UISound.play("drinkingbeerget")
            local cellObj = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, cellIndex):GetCellObj()
            local flyObj = BattleEffectPool:Get(effectName, cellObj)
            local flyParent = self:GetFlyItemParent(cardId)
            if flyParent then
                fun.set_parent(flyObj, flyParent, false)
            else
                fun.set_parent(flyObj, cellObj, false)
            end
            if effectName == "treasureFlyItem02" then
                fun.set_same_position_with(flyObj, cellObj)
            else
                local minCellObj = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, bigCellIndexMin):GetCellObj()
                local maxCellObj = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, bigCellIndexMax):GetCellObj()
                local minPos = minCellObj.transform.position
                local maxPos = maxCellObj.transform.position
                flyObj.transform.position = Vector2.New((minPos.x + maxPos.x)*0.5,(minPos.y + maxPos.y)*0.5)
            end
            local flyAnim = fun.get_component(flyObj, fun.ANIMATOR)
            if flyAnim then
                flyAnim:Play("in1")
            end

            Event.Brocast(EventName.Event_Sign_Cell_Background, treasureItems.id,data.result[3], cardId, cellIndex, data.icon, nil, nil)
            log.log("DrinkingFrenzyFlyItemEffect:CreateTreasure 01 cardId, cellIndex, data.result[3] ", cardId, cellIndex, data.result[3])
            --飞道具
            LuaTimer:SetDelayFunction(1, function()
                if fun.is_null(flyObj) then
                    return
                end

                --local moveTime, targetPos = self:GetTreasureFlyTime(treasureItems.id,tonumber(cardId), flyObj, data.result[3])
                --local coverObj = UnityEngine.GameObject.New()
                --coverObj.transform.name = "testfly"
                --fun.set_parent(coverObj, flyObj.transform.parent, true)
                --fun.set_gameobject_scale(flyObj, 1, 1, 1)
                --if fun.is_not_null(targetPos) then
                --    coverObj.transform.position = targetPos
                --else
                --    coverObj.transform.localPosition = Vector3.zero
                --end

                --local localTargetPos = fun.get_gameobject_pos(coverObj, true)
                --localTargetPos = localTargetPos - fun.get_child(flyObj.transform, 0).localPosition
                --Destroy(coverObj)


                Event.Brocast(EventName.Event_Logic_Collect_Item, cardId, treasureItems.id)
                --飞道具动画
                --flyObj.transform:SetSiblingIndex(0)
                --flyAnim:Play("idlefei")

                local collectIndex,collectProgress = curModel:GetReadyFlyIndex(treasureItems.id , tonumber(cardId))
                curModel:AddReadyFlyNumProgress(cardId,collectIndex,  1)
                --Anim.move(flyObj, localTargetPos.x, localTargetPos.y, localTargetPos.z, moveTime, true, true, function()
                    --Destroy(flyObj)
                    BattleEffectPool:Recycle(effectName, flyObj)
                    Event.Brocast(EventName.Event_View_Collect_Item, treasureItems.id ,cardId, data.result[3])
                    --UISound.play("mineradd")
                --end)
            end)
        end
    end
end

function this:ShowRightPlayerWaitBeer(cardId)
    local cardView = self:GetCardView()
    if cardView and cardView["ShowRightPlayerWaitBeer"] then
        cardView:ShowRightPlayerWaitBeer(cardId)
    end
end

function this:GetFlyItemParent(cardId)
    local cardView = self:GetCardView()
    if cardView and cardView["GetFlyItemParent"] then
        return cardView:GetFlyItemParent(cardId)
    end
end

function this:GetTreasureFlyTime(itemId,cardId, fly, itemType)
    local cardView = self:GetCardView()
    if cardView and cardView["GetFlyTargetPos"] then
        local targetPos = cardView:GetFlyTargetPos(itemId,cardId, itemType)
        local dis = Vector3.Distance(targetPos, fun.get_gameobject_pos(fly))
        return (dis / 4) * 1.2, targetPos
    end

    return 1
end

--Bingo技能
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

    if GetTableLength(cellPosList) == 0 then
        return
    end
    log.log("dghdgh00008 ddddddddddd 0000000", cardId, cellIndex, powerId, extraPos, cellPosList)

    --添加ExtraData，结算时通知服务器某个类型达成了Bingo
    model:GetRoundData(cardId):AddExtraUpLoadData("cardHitGridBingo", {
        cardId = tonumber(cardId),
        pos = ConvertCellIndexToServerPos(cellIndex),
        extraPos = BattleTool.ConvertedToServerPosList(cellPosList),
    }, "pos")
end

return this