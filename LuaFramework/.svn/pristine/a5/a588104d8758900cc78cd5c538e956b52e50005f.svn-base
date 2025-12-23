local BaseFlyItemEffect = require("View.Bingo.EffectModule.Card.FlyItemEffect.BaseFlyItemEffect")

local EasterFlyItemEffect = BaseFlyItemEffect:New("EasterFlyItemEffect")
local this = EasterFlyItemEffect

function this:Remove()
    Event.RemoveListener(EventName.Event_Collect_Item_By_Sign, self.CheckItemType, self)
    Event.RemoveListener(EventName.Event_Show_Skill_Bingo, self.ShowSkillBingo, self)
end

function this:Register()
    Event.AddListener(EventName.Event_Collect_Item_By_Sign, self.CheckItemType, self)
    Event.AddListener(EventName.Event_Show_Skill_Bingo, self.ShowSkillBingo, self)
end

--先判断是不是双彩蛋道具
function this:CheckItemType(cardId, cellIndex)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local curCell = curModel:GetRoundData(cardId, cellIndex)
    local treasureItems = curCell:Treasure2Item()

    if treasureItems then
        local data = Csv.GetData("item", treasureItems.id)
        if 42 == data.result[1] then
            local cellObj = curCell:GetCellObj()
            local itemType = data.result[2]
            if itemType == 4 then
                --双彩蛋道具
                coroutine.start(function()
                    this:CreateItem(cardId, cellIndex, cellObj, itemType, -100)
                    coroutine.wait(0.5)
                    this:CreateItem(cardId, cellIndex, cellObj, itemType, 100)
                end)
            else
                this:CreateItem(cardId, cellIndex, cellObj, itemType)
            end
        end
    end
end

--收集逻辑
function this:CreateItem(cardId, cellIndex, cellObj, itemType, posOffsetX)
    UISound.play("easterflyin")

    local effectName = "flyItem"
    local flyObj = BattleEffectPool:Get(effectName, cellObj)
    local parentObj = self:GetCardView():GetCard(cardId).flyItemRoot
    fun.set_parent(flyObj, parentObj)
    fun.set_gameobject_scale(flyObj, 1, 1, 1)
    flyObj.transform.position = fun.get_gameobject_pos(cellObj)
    if posOffsetX then
        fun.set_rect_offset_local_pos(flyObj, posOffsetX)
    end
    
    local flyAnim = fun.get_component(flyObj, fun.ANIMATOR)
    flyAnim:Play("in1")

    Event.Brocast(EventName.Event_Sign_Cell_Background, itemType, cardId, cellIndex)

    --飞道具
    LuaTimer:SetDelayFunction(1.5, function()
        if fun.is_null(flyObj) then
            log.e(string.format("CreateItem flyObj is nil"))
            return
        end
        
        local moveTime, targetPos, targetType = self:GetTreasureFlyTime(tonumber(cardId), flyObj, itemType)
        Event.Brocast(EventName.Event_Logic_Collect_Item, cardId, cellIndex, targetType, 1)
        
        --飞道具动画
        flyObj.transform:SetSiblingIndex(0)
        flyAnim:Play("idlefei")
        Anim.move(flyObj, targetPos.x, targetPos.y, targetPos.z, moveTime, false, true, function()
            BattleEffectPool:Recycle(effectName, flyObj)
            Event.Brocast(EventName.Event_View_Collect_Item, cardId, targetType)
            UISound.play("easteradd")
        end)
    end)
end

function this:GetTreasureFlyTime(cardId, fly, itemType)
    local cardView = self:GetCardView()
    if cardView and cardView["GetFlyTargetPos"] then
        local targetPos, targetType = cardView:GetFlyTargetPos(cardId, itemType)
        local dis = Vector3.Distance(targetPos, fun.get_gameobject_pos(fly))
        return (dis / 4) * 1.2, targetPos, targetType
    end

    return 1
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
    
    BattleEffectCache:GetSkillPrefabFromCache("EasterSkill1Taril", cellData.obj, function(obj)
        self:SameScaleWithCard(obj, cardId)
        UISound.play("eastercarrot")

        LuaTimer:SetDelayFunction(1, function()
            table.each(cellPosList, function(cellID, k)
                cellData = model:GetRoundData(cardId, cellID)
                if cellData:IsNotSign() then
                    --cellData.isSignByGemBingoSkill = true
                    BattleEffectCache:GetSkillPrefabFromCache("EasterSkill1Get", cellData.obj, function()
                        LuaTimer:SetDelayFunction(0.7, function()
                            cardView:OnClickCardIgnoreJudgeByIndex(cardId, cellID, powerId)
                        end, false, LuaTimer.TimerType.BattleUI)
                    end, 2, cardId)
                end
                cardPower:ChangeCellState(cardId, cellID, cardPower.CellState.Signed)
            end)
        end, false, LuaTimer.TimerType.BattleUI)
    end, 2.5, cardId)
end

return this