local BaseFlyItemEffect = require("View.Bingo.EffectModule.Card.FlyItemEffect.BaseFlyItemEffect")

local MoleMinerFlyItemEffect = BaseFlyItemEffect:New("MoleMinerFlyItemEffect")
local this = MoleMinerFlyItemEffect

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
        if 48 == data.result[1] then
            --收集到的道具
            local effectName = ""
            if 1 == data.result[2] or 2 == data.result[2] then
                local ext = curCell:GetExtInfo()
                local groupCells = ext and ext.groupCells
                if groupCells then
                    --group中的格子是否都被盖章
                    local isAllSigned, pos = true, Vector3.zero
                    local indexList = {}
                    table.each(groupCells, function(cellData)
                        if cellData then
                            local cellObj = cellData:GetCellObj()
                            pos = pos + cellObj.transform.position
                            isAllSigned = isAllSigned and not (cellData:IsNotSign() or cellData:IsLogicSign())
                            table.insert(indexList, cellData.index)
                        end
                    end)
                    if not isAllSigned then
                        pos = pos / #groupCells
                        log.log("MoleMinerFlyItemEffect:CreateTreasure 00 cardId, cellIndex, #groupCells, indexList, pos ", cardId, cellIndex, #groupCells, indexList, pos)
                        Event.Brocast(EventName.Event_Sign_Cell_Background, data.result[2], cardId, cellIndex, data.icon, treasureItems.part, pos)
                        return
                    end
                end

                effectName = "treasureFlyItem0" .. data.result[2]
            elseif data.result[2] == 3 then
                effectName = "treasureFlyItem03"
            elseif data.result[2] == 4 then
                effectName = "treasureFlyItem04"
            end
            UISound.play("minerflyin")
            local cellObj = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, cellIndex):GetCellObj()
            local flyObj = BattleEffectPool:Get(effectName, cellObj)
            fun.set_parent(flyObj, cellObj, false)
            fun.set_same_position_with(flyObj, cellObj)
            local flyAnim = fun.get_component(flyObj, fun.ANIMATOR)
            flyAnim:Play("in1")

            --if data.result[2] ~= 1 then
                Event.Brocast(EventName.Event_Sign_Cell_Background, data.result[2], cardId, cellIndex, data.icon, nil, nil)
                log.log("MoleMinerFlyItemEffect:CreateTreasure 01 cardId, cellIndex, data.result[2] ", cardId, cellIndex, data.result[2])
            --end
            --飞道具
            LuaTimer:SetDelayFunction(1, function()
                if fun.is_null(flyObj) then
                    return
                end

                local moveTime, targetPos = self:GetTreasureFlyTime(tonumber(cardId), flyObj, data.result[2])
                local coverObj = UnityEngine.GameObject.New()
                fun.set_parent(coverObj, flyObj.transform.parent, true)
                fun.set_gameobject_scale(flyObj, 1, 1, 1)
                if fun.is_not_null(targetPos) then
                    coverObj.transform.position = targetPos
                else
                    coverObj.transform.localPosition = Vector3.zero
                end

                local localTargetPos = fun.get_gameobject_pos(coverObj, true)
                localTargetPos = localTargetPos - fun.get_child(flyObj.transform, 0).localPosition
                Destroy(coverObj)

                Event.Brocast(EventName.Event_Logic_Collect_Item, cardId, cellIndex, data.result[2], 1)

                --飞道具动画
                flyObj.transform:SetSiblingIndex(0)
                flyAnim:Play("idlefei")
                Anim.move(flyObj, localTargetPos.x, localTargetPos.y, localTargetPos.z, moveTime, true, true, function()
                    --Destroy(flyObj)
                    BattleEffectPool:Recycle(effectName, flyObj)
                    Event.Brocast(EventName.Event_View_Collect_Item, cardId, data.result[2])
                    UISound.play("mineradd")
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


    --播放Bingo技能
    BattleEffectCache:GetSkillPrefabFromCache("MoleMinerskill1deng", cellData.obj, function(obj)
        fun.set_same_position_with_but_z_zero(obj, cellData.obj)
        self:SameScaleWithCard(obj, cardId)
        UISound.play("minerkerosene")

        LuaTimer:SetDelayFunction(1, function()
            table.each(cellPosList, function(cellID, k)
                    cellData = model:GetRoundData(cardId, cellID)
                    if cellData:IsNotSign() then
                    --cellData.isSignByGemBingoSkill = true
                    BattleEffectCache:GetSkillPrefabFromCache("MoleMinerskill1dengget", cellData.obj, function()
                        LuaTimer:SetDelayFunction(1.5, function()
                            cardView:OnClickCardIgnoreJudgeByIndex(cardId, cellID, powerId)
                            log.log("dghdgh00008 ddddddddddd cardId, cellID, powerId", cardId, cellID, powerId)
                            Event.Brocast(EventName.Event_Collect_Item_By_Sign, cardId, cellID)
                        end, false, LuaTimer.TimerType.BattleUI)
                    end, 2, cardId)
                end
                cardPower:ChangeCellState(cardId, cellID, cardPower.CellState.Signed)
            end)
        end, false, LuaTimer.TimerType.BattleUI)
        
    end, 3.5, cardId)
end

return this