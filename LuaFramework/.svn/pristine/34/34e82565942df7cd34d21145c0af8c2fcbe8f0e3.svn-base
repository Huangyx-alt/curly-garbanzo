local BaseFlyItemEffect = require("View.Bingo.EffectModule.Card.FlyItemEffect.BaseFlyItemEffect")

local HorseRacingFlyItemEffect = BaseFlyItemEffect:New("HorseRacingFlyItemEffect")
local this = HorseRacingFlyItemEffect

function this:Remove()
    Event.RemoveListener(EventName.Event_Collect_Item_By_Sign, self.CreateTreasure, self)
    Event.RemoveListener(EventName.Event_Show_Skill_Bingo, self.ShowSkillBingo, self)
end

function this:Register()
    Event.AddListener(EventName.Event_Collect_Item_By_Sign, self.CreateTreasure, self)
    Event.AddListener(EventName.Event_Show_Skill_Bingo, self.ShowSkillBingo, self)
end

--创建Bingo道具
function this:CreateTreasure(cardId, cellIndex)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local curCell = curModel:GetRoundData(cardId, cellIndex)
    local col = curModel:CellIndex2Col(cellIndex)

    UISound.play("horseracingflyin")
    local ext = curCell:GetExtInfo()
    local groupCells = ext and ext.groupCells
    if groupCells then
        --group中的格子是否都被盖章
        local isAllSigned = true
        local indexList = {}
        table.each(groupCells, function(cellData)
            if cellData then
                local cellObj = cellData:GetCellObj()
                
                isAllSigned = isAllSigned and not (cellData:IsNotSign() or cellData:IsLogicSign())
                table.insert(indexList, cellData.index)
            end
        end)
        
        if not isAllSigned then

        end
            
        log.log("HorseRacingFlyItemEffect:CreateTreasure 00 cardId, cellIndex, #groupCells, indexList ", cardId, cellIndex, #groupCells, indexList)
        Event.Brocast(EventName.Event_Sign_Cell_Background, col, cardId, cellIndex, indexList)

        local effectName = self:GetFlyItemName(col, cardId)
        local cellObj = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, cellIndex):GetCellObj()
        local flyObj = BattleEffectPool:Get(effectName, cellObj)
        fun.set_active(flyObj, false)
        fun.set_parent(flyObj, cellObj, false)
        fun.set_same_position_with(flyObj, cellObj)
        local flyAnim = fun.get_component(flyObj, fun.ANIMATOR)
        --飞道具动画
        fun.set_active(flyObj, true)
        --飞道具
        LuaTimer:SetDelayFunction(1, function()
            if fun.is_null(flyObj) then
                return
            end

            local moveTime, targetPos = self:GetTreasureFlyTime(tonumber(cardId), flyObj, col)
            moveTime = moveTime * 0.8
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
            Event.Brocast(EventName.Event_Logic_Collect_Item, cardId, cellIndex, col, 1)

            --飞道具动画
            --fun.set_active(flyObj, true)
            flyObj.transform:SetSiblingIndex(0)
            flyAnim:Play("idlefei")
            Anim.move(flyObj, localTargetPos.x, localTargetPos.y, localTargetPos.z, moveTime, true, true, function()
                --Destroy(flyObj)
                BattleEffectPool:Recycle(effectName, flyObj)
                Event.Brocast(EventName.Event_View_Collect_Item, cardId, col, false, cellIndex)
                UISound.play("horseracingadd")
            end)
        end)
    end
end

--区分等级
function this:GetFlyItemName(itemType, cardId)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local level = curModel:GetCollectLevelByCardIdAndTrackIdx(cardId, itemType)
    if level == 1 then
        return "treasureFlyItem02"
    else
        return "treasureFlyItem01"
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

    --添加ExtraData，结算时通知服务器某个类型达成了Bingo
    model:GetRoundData(cardId):AddExtraUpLoadData("cardHitGridBingo", {
        cardId = tonumber(cardId),
        pos = ConvertCellIndexToServerPos(cellIndex),
        extraPos = BattleTool.ConvertedToServerPosList(cellPosList),
    }, "pos")


    --播放Bingo技能
    BattleEffectCache:GetSkillPrefabFromCache("BisonXXX", cellData.obj, function(obj)
        fun.set_same_position_with_but_z_zero(obj, cellData.obj)
        self:SameScaleWithCard(obj, cardId)
        UISound.play("minerkerosene")

        LuaTimer:SetDelayFunction(1, function()
            table.each(cellPosList, function(cellID, k)
                    cellData = model:GetRoundData(cardId, cellID)
                    if cellData:IsNotSign() then
                    --cellData.isSignByGemBingoSkill = true
                    BattleEffectCache:GetSkillPrefabFromCache("BisonXXXget", cellData.obj, function()
                        LuaTimer:SetDelayFunction(1.5, function()
                            cardView:OnClickCardIgnoreJudgeByIndex(cardId, cellID, powerId)
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