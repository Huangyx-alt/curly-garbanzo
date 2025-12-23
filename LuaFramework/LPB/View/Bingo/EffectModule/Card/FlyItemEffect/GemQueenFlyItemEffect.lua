local BaseFlyItemEffect = require("View.Bingo.EffectModule.Card.FlyItemEffect.BaseFlyItemEffect")

local GemQueenFlyItemEffect = BaseFlyItemEffect:New("GemQueenFlyItemEffect")
local this = GemQueenFlyItemEffect

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
        if 28 == data.result[1] then
            UISound.play("queencharms_flyin")
            
            --收集到了哪个道具
            local effectName = ""
            if 1 == data.result[2] then
                local ext = curCell:GetExtInfo()
                local partCellID = ext and ext.otherPart
                if partCellID then
                    local partCell = curModel:GetRoundData(cardId, partCellID)
                    if partCell and (partCell:IsNotSign() or partCell:IsLogicSign()) then
                        Event.Brocast(EventName.Event_Sign_Cell_Background, data.result[2], cardId, cellIndex, treasureItems.part, math.min(partCell.index, cellIndex))
                        return
                    end
                end
                effectName = "treasureFlyItem01"
            elseif data.result[2] == 2 then
                effectName = "treasureFlyItem02"
            elseif data.result[2] == 3 then
                effectName = "treasureFlyItem03"
            elseif data.result[2] == 4 then
                effectName = "treasureFlyItem04"
            end
            
            local cellObj = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, cellIndex):GetCellObj()
            local flyObj = BattleEffectPool:Get(effectName, cellObj)
            fun.set_parent(flyObj, cellObj, false)
            fun.set_same_position_with(flyObj, cellObj)
            local flyAnim = fun.get_component(flyObj, fun.ANIMATOR)
            flyAnim:Play("in1")

            --if data.result[2] ~= 1 then
                Event.Brocast(EventName.Event_Sign_Cell_Background, data.result[2], cardId, cellIndex, nil, nil)
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
                    UISound.play("queencharms_add")
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

--宝石玩法Bingo技能
function this:ShowSkillBingo(cardId, cellIndex)
    local model = ModelList.BattleModel:GetCurrModel()
    local cardPower = BattleModuleList.GetModule("CardPower")
    local cellData = model:GetRoundData(cardId, cellIndex)
    local powerId, serverExtraPos = cellData:GetPowerupId(), cellData:GetPuExtraPos()
    local extraPos, cellPosList = BattleTool.GetExtraPos(serverExtraPos), {}
    local cardView = cardPower.cardView
    local cellObj = cardView:GetCardCell(tonumber(cardId), cellIndex)

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

    --播放魔镜技能
    BattleEffectCache:GetSkillPrefabFromCache("skillmojingchuxian", cellObj, function(obj)
        fun.set_same_position_with_but_z_zero(obj, cellObj)
        self:SameScaleWithCard(obj, cardId)
        UISound.play("queencharms_mirror")

        --1秒后开始触发盖章
        LuaTimer:SetDelayFunction(1, function()
            table.each(cellPosList, function(cellID, k)
                LuaTimer:SetDelayFunction(0.15 * (k - 1), function()
                    cellData = model:GetRoundData(cardId, cellID)
                    if cellData:IsNotSign() then
                        --标识是被法杖技能盖章
                        cellData.isSignByGemBingoSkill = true
                        cardView:OnClickCardIgnoreJudgeByIndex(cardId, cellID, powerId)
                    end
                    cardPower:ChangeCellState(cardId, cellID, cardPower.CellState.Signed)
                end, false, LuaTimer.TimerType.BattleUI)
            end)
        end, false, LuaTimer.TimerType.BattleUI)
    end, 3.5, cardId)
end

return this