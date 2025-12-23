local BaseFlyItemEffect = require("View.Bingo.EffectModule.Card.FlyItemEffect.BaseFlyItemEffect")

local ScratchWinnerFlyItemEffect = BaseFlyItemEffect:New("ScratchWinnerFlyItemEffect")
local this = ScratchWinnerFlyItemEffect
local animTime1 = 0.7

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

    local treasureItems = curCell:Treasure2Item()
    if treasureItems then
        local data = Csv.GetData("item", treasureItems.id)
        if 52 == data.result[1] then
            --UISound.play("scratchwinnerflyin")
            local ext = curCell:GetExtInfo()
            local groupCells = ext and ext.groupCells
            if groupCells then
                --group中的格子是否都被盖章
                local isAllSigned = true
                local indexList = {}
                local totalCollectCount = 0
                local curCollectCount = 0
                table.each(groupCells, function(cellData)
                    if cellData then
                        local cellObj = cellData:GetCellObj()
                        isAllSigned = isAllSigned and not (cellData:IsNotSign() or cellData:IsLogicSign())
                        table.insert(indexList, cellData.index)
                        if not (cellData:IsNotSign() or cellData:IsLogicSign()) then
                            curCollectCount = curCollectCount + 1
                        end
                        totalCollectCount = totalCollectCount + 1
                    end
                end)

                local extraParams = {}
                extraParams.totalCollectCount = totalCollectCount
                extraParams.curCollectCount = curCollectCount
                if not isAllSigned then
                    extraParams.finishCollect = false
                    log.log("ScratchWinnerFlyItemEffect:CreateTreasure 00 cardId, cellIndex, #groupCells, indexList ", cardId, cellIndex, #groupCells, indexList)
                else
                    extraParams.finishCollect = true
                    log.log("ScratchWinnerFlyItemEffect:CreateTreasure 01 cardId, cellIndex, #groupCells, indexList ", cardId, cellIndex, #groupCells, indexList)
                end
                Event.Brocast(EventName.Event_Sign_Cell_Background, data.result[2], cardId, cellIndex, indexList, extraParams)

                LuaTimer:SetDelayFunction(animTime1, function()
                    Event.Brocast(EventName.Event_Logic_Collect_Item, cardId, cellIndex, data.result[2], 1)
                    Event.Brocast(EventName.Event_View_Collect_Item, cardId, data.result[2], false, cellIndex)
                end, false, LuaTimer.TimerType.Battle)
            end
        end
    end
end

--区分等级
function this:GetFlyItemName(itemType, cardId)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local level = 1
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
    BattleEffectCache:GetSkillPrefabFromCache("ScratchWinnerXXX", cellData.obj, function(obj)
        fun.set_same_position_with_but_z_zero(obj, cellData.obj)
        self:SameScaleWithCard(obj, cardId)
        UISound.play("----")

        LuaTimer:SetDelayFunction(1, function()
            table.each(cellPosList, function(cellID, k)
                    cellData = model:GetRoundData(cardId, cellID)
                    if cellData:IsNotSign() then
                    --cellData.isSignByGemBingoSkill = true
                    BattleEffectCache:GetSkillPrefabFromCache("ScratchWinnerXXXget", cellData.obj, function()
                        LuaTimer:SetDelayFunction(1.5, function()
                            cardView:OnClickCardIgnoreJudgeByIndex(cardId, cellID, powerId)
                            Event.Brocast(EventName.Event_Collect_Item_By_Sign, cardId, cellID)
                        end, false, LuaTimer.TimerType.Battle)
                    end, 2, cardId)
                end
                cardPower:ChangeCellState(cardId, cellID, cardPower.CellState.Signed)
            end)
        end, false, LuaTimer.TimerType.Battle)
        
    end, 3.5, cardId)
end

return this