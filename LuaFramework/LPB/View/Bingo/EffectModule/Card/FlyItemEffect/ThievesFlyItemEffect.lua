local BaseFlyItemEffect = require("View.Bingo.EffectModule.Card.FlyItemEffect.BaseFlyItemEffect")

local ThievesFlyItemEffect = BaseFlyItemEffect:New("ThievesFlyItemEffect")
local this = ThievesFlyItemEffect

function this:Register()
    Event.AddListener(EventName.Event_Collect_Item_By_Sign, self.CreateTreasure, self)
end

function this:Remove()
    Event.RemoveListener(EventName.Event_Collect_Item_By_Sign, self.CreateTreasure, self)
end

function this:CreateTreasure(cardId, cellIndex)
    log.log(string.format("[ThievesLog] CardID:%s，保险箱位置:%s，创建飞行道具", cardId, cellIndex))
    
    local curModel = ModelList.BattleModel:GetCurrModel()
    local curCell = curModel:GetRoundData(cardId, cellIndex)
    
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

    --UISound.play("lavaflyin")
    
    coroutine.start(function()
        coroutine.wait(1)
        
        --飞行终点及飞行时间
        local moveTime, targetPos, key = self:GetTreasureFlyTime(tonumber(cardId), flyObj)
        --飞向收集道具位置
        Anim.move(flyObj, targetPos.x, targetPos.y, targetPos.z, moveTime, false, true, function()
            BattleEffectPool:Recycle(effectName, flyObj)
            Event.Brocast(EventName.Event_View_Collect_Item, cardId, cellIndex, key)
            UISound.play("thievesadd")
        end)
    end)
end

function this:GetTreasureFlyTime(cardId, fly)
    local cardView = self:GetCardView()
    if cardView and cardView["GetFlyTargetPos"] then
        local targetPos, key = cardView:GetFlyTargetPos(cardId)
        local dis = Vector3.Distance(targetPos, fun.get_gameobject_pos(fly))
        return (dis / 4) * 1.2, targetPos, key
    end

    return 1
end

return this