--- 格子盖章效果
local BaseFlyItemEffect = require("View.Bingo.EffectModule.Card.FlyItemEffect.BaseFlyItemEffect")

local LeetoleManFlyItemEffect = BaseFlyItemEffect:New("LeetoleManFlyItemEffect")
local this = LeetoleManFlyItemEffect

function LeetoleManFlyItemEffect:Remove()
    Event.RemoveListener(EventName.Event_Collect_Item_By_Sign, self.CreateTreasure, self)
    Event.RemoveListener(EventName.Event_Show_Skill_Bingo, self.ShowSkillBingo, self)
end

function LeetoleManFlyItemEffect:Register()
    Event.AddListener(EventName.Event_Collect_Item_By_Sign, self.CreateTreasure, self)
    Event.AddListener(EventName.Event_Show_Skill_Bingo, self.ShowSkillBingo, self)
end

function LeetoleManFlyItemEffect:CreateTreasure(cardId, cellIndex)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local curCell = curModel:GetRoundData(cardId, cellIndex)
    local treasureItems = curCell:Treasure2Item()

    if treasureItems then
        local data = Csv.GetData("item", treasureItems.id)
        if 15 == data.result[1] then
            UISound.play("stpatrick_kick_call")
            local effectName = ""
            local throwAction = ""
            if 1 == data.result[2] then
                -- 藏宝图
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
                throwAction = { "rengditu", "LeetoleManclickdaojurengditu" }
            elseif data.result[2] == 2 then
                effectName = "treasureFlyItem02"
                throwAction = { "rengsyc", "LeetoleManclickdaojurengsyc" }
            elseif data.result[2] == 3 then
                effectName = "treasureFlyItem03"
                throwAction = { "rengmati", "LeetoleManclickdaojurengmati" }
            elseif data.result[2] == 4 then
                effectName = "treasureFlyItem04"
                throwAction = { "rengyandou", "LeetoleManclickdaojurengyandou" }
            end
            local obj = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, cellIndex):GetCellObj()
            local flyObj = BattleEffectPool:Get(effectName, obj)
            fun.set_parent(flyObj, self:GetCardView():GetCardMap(cardId), false)
            fun.set_same_position_with(flyObj, obj)
            local flyAnim = fun.get_component(flyObj, fun.ANIMATOR)
            flyAnim:Play("in1")
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
                if data.result[2] ~= 1 then
                    Event.Brocast(EventName.Event_Sign_Cell_Background, data.result[2], cardId, cellIndex, nil, nil)
                end
                Event.Brocast(EventName.Event_Logic_Collect_Item, cardId, cellIndex, data.result[2], 1)
                flyObj.transform:SetSiblingIndex(0)
                flyAnim:Play("idlefei")
                Anim.move(flyObj, localTargetPos.x, localTargetPos.y, localTargetPos.z, moveTime, true, true, function()
                    if not self:GetCardView() then
                        return
                    end
                    self:GetCardView():GetCard(cardId):PlayLeeToleManAction()
                    AnimatorPlayHelper.Play(flyAnim, throwAction, false, function()
                        Destroy(flyObj)
                        Event.Brocast(EventName.Event_View_Collect_Item, cardId, data.result[2])
                        UISound.play("stpatrick_add")
                    end)
                end)
                UISound.play("stpatrick_flyin")
            end)
        end
    else
        self:GetCardView():GetCard(cardId):PlayLeeToleManEmpty()
    end
end

function LeetoleManFlyItemEffect:GetTreasureFlyTime(cardId, fly)
    local targetPos = self:GetCardView():GetLeetoumanPos(cardId)
    local dis = Vector3.Distance(targetPos, fly.transform.position)
    return (dis / 4) * 1.2, targetPos
end

function LeetoleManFlyItemEffect:ShowSkillBingo(cardId, cellIndex)
    local model = ModelList.BattleModel:GetCurrModel()
    local cardPower = BattleModuleList.GetModule("CardPower")
    local cellData = model:GetRoundData(cardId, cellIndex)
    local powerId, serverExtraPos = cellData:GetPowerupId(), cellData:GetPuExtraPos()
    local extraPos, cellPosList = BattleTool.GetExtraPos(serverExtraPos), {}
    local cardView = cardPower.cardView
    local lastCellObj = cardView:GetCardCell(tonumber(cardId), 25)

    if #extraPos > 0 then
        cellPosList = model:CheckFlyPigExtraPosValid(cardId, extraPos, cellIndex)
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

    --播放猪开面奔跑特效
    BattleEffectCache:GetSkillPrefabFromCache("LeetoleManJbig", lastCellObj, function(obj)
        fun.set_same_position_with_but_z_zero(obj, lastCellObj)
        self:SameScaleWithCard(obj, cardId)
        UISound.play("stpatrick_pig")

        --2秒后触发旗子
        LuaTimer:SetDelayFunction(2, function()
            local validCount = 0
            --每个格子 间隔0.3秒 播放插旗子效果
            table.each(cellPosList, function(cellID, k)
                LuaTimer:SetDelayFunction(0.3 * (k - 1), function()
                    local cellData = model:GetRoundData(cardId, cellID)
                    if not cellData or not cellData:IsNotSign() then
                        return
                    end

                    validCount = validCount + 1
                    local cellObj = cardView:GetCardCell(tonumber(cardId), cellID)
                    BattleEffectCache:GetSkillPrefabFromCache("LeetoleManJbigqizi", cellObj, function(temp)
                        UISound.play("stpatrick_flag")

                        --特效2秒后盖章
                        LuaTimer:SetDelayFunction(1, function()
                            local anima = fun.get_component(temp, fun.ANIMATOR)
                            if anima then
                                anima:Play("end")
                            end
                            BattleEffectPool:Recycle("LeetoleManJbigqizi", temp)
                            --Destroy(temp)

                            --盖章
                            cardView:OnClickCardIgnoreJudgeByIndex(cardId, cellID, powerId)
                            --cardPower:ChangeCellState(cardId, cellID, cardPower.CellState.Signed)
                        end)
                    end, 0, cardId)
                end)
            end)
        end)
    end, 3.5, cardId)
end

return this



