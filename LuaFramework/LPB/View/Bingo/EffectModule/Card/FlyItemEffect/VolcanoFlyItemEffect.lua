local BaseFlyItemEffect = require("View.Bingo.EffectModule.Card.FlyItemEffect.BaseFlyItemEffect")

local VolcanoFlyItemEffect = BaseFlyItemEffect:New("VolcanoFlyItemEffect")
local this = VolcanoFlyItemEffect

function this:Remove()
    Event.RemoveListener(EventName.Event_Collect_Item_By_Sign, self.CreateTreasure, self)
    Event.RemoveListener(EventName.Event_Show_Skill_Bingo, self.ShowSkillBingo, self)
end

function this:Register()
    Event.AddListener(EventName.Event_Collect_Item_By_Sign, self.CreateTreasure, self)
    Event.AddListener(EventName.Event_Show_Skill_Bingo, self.ShowSkillBingo, self)
end

function this:CreateTreasure(cardId, cellIndex, dragonCtrl)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local curCell = curModel:GetRoundData(cardId, cellIndex)
    local treasureItems = curCell:Treasure2Item()
    
    if treasureItems then
        local data = Csv.GetData("item", treasureItems.id)
        if 44 == data.result[1] then
            local needPlayFly = dragonCtrl == nil
            --取龙
            if not dragonCtrl then
                local dragonType = data.result[2]
                local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
                local view = cardView:GetCard(cardId)
                dragonCtrl = view.dragonCtrlList[dragonType]
            end
            if not dragonCtrl then
                log.e(string.format("VolcanoFlyItemEffect 未找到龙，cardId:%s, cellIndex:%s", cardId, cellIndex))
                return
            end

            if needPlayFly then
                local anima = fun.get_component(dragonCtrl, fun.ANIMATOR)
                anima:Play("fly")
            end
            
            UISound.play("lavaflyin")

            coroutine.start(function()
                if needPlayFly then
                    coroutine.wait(1)
                end
                
                --道具收集后逻辑
                Event.Brocast(EventName.Event_Logic_Collect_Item, cardId, cellIndex, data.result[2], 1)

                --飞行终点及飞行时间
                local moveTime, targetPos = self:GetTreasureFlyTime(tonumber(cardId), dragonCtrl, data.result[2])
                --飞向收集道具位置
                Anim.move(dragonCtrl, targetPos.x, targetPos.y, targetPos.z, moveTime, false, true, function()
                    fun.set_active(dragonCtrl, false)
                    Event.Brocast(EventName.Event_View_Collect_Item, cardId, data.result[2])
                    UISound.play("lavaadd")
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

        if model.dragonController then
            local dragon = model.dragonController:GetDragon(cardId, cellID)
            if dragon then
                dragon:OnGetBySkill()
            end
        end
    end)
    
    UISound.play("lavamagiccircle")

    coroutine.start(function()
        if isExtraPosValid then
            table.each(cellPosList, function(cellID, k)
                --取龙
                cellData = model:GetRoundData(cardId, cellID)
                local treasureItems = cellData:Treasure2Item()
                if not treasureItems then
                    return
                end
                local data = Csv.GetData("item", treasureItems.id)
                local dragonType = data.result[2]
                local view = cardView:GetCard(cardId)
                local dragonCtrl = view.dragonCtrlList[dragonType]
                
                --播传送动画
                if dragonCtrl then
                    local anima = fun.get_component(dragonCtrl, fun.ANIMATOR)
                    anima:Play("skill2a")

                    coroutine.wait(1.5)
                    --在火山位置播放动画
                    local targetCtrl = model:GetRoundData(cardId, 13):GetCellReferScript("bg_tip")
                    fun.set_same_position_with(dragonCtrl, targetCtrl)
                    anima:Play("skill2b")

                    coroutine.wait(1.5)
                    --飞向收集道具位置
                    this:CreateTreasure(cardId, cellID, dragonCtrl)
                end
            end)
        end
    end)
end

return this