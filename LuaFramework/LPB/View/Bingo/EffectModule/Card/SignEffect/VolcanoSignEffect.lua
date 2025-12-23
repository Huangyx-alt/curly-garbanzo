local BaseSignEffect = require("View.Bingo.EffectModule.Card.SignEffect.BaseSignEffect")

local VolcanoSignEffect = BaseSignEffect:New("VolcanoSignEffect")
setmetatable(VolcanoSignEffect, BaseSignEffect)
local this = VolcanoSignEffect
local itemShowCache = {}

function VolcanoSignEffect:RegisterEvent()
    itemShowCache = {}
    Event.AddListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function VolcanoSignEffect:UnRegisterEvent()
    Event.RemoveListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function VolcanoSignEffect:TriggerSingleBingo(cardId, cellIndex)
    Event.Brocast(EventName.Event_Show_Skill_Bingo, cardId, cellIndex)
end

function VolcanoSignEffect:SignCardEffect(cardId, index, cardCell, signType, delay, self_bingo, giftLen)
    signType = signType or 0
    if self:CannotSignCell(cardId, index, signType) then
        return
    end
    self:SaveCellSignEffect(cardId, index)
    delay = delay or 0
    for i = 1, fun.get_child_count(cardCell) do
        fun.set_active(fun.get_child(cardCell, i - 1), false)
    end
    local ref_temp = fun.get_component(cardCell, fun.REFER)
    self:HideCellChild(ref_temp, cardId, index)

    Event.Brocast(EventName.Magnifier_Close_Single_Cell, cardCell, false)

    if self_bingo then
        self:TriggerSingleBingo(cardId, index)
    end
    
    --Event.Brocast(EventName.Event_Collect_Item_By_Sign, cardId, index)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local dragonController = curModel and curModel.dragonController
    if dragonController then
        dragonController:OnCellSigned(cardId, index)
    end

    self:CellBgEffect(cardId, index)
end

function VolcanoSignEffect:CellBgEffect(cardId, cellIndex)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local curCell = curModel:GetRoundData(cardId, cellIndex)
    local treasureItems = curCell:Treasure2Item()
    if not treasureItems then
        return
    end
    
    local data = Csv.GetData("item", treasureItems.id)
    if 44 ~= data.result[1] then
        return
    end
    
    local cellObj = curCell:GetCellObj()
    local diEffect = BattleEffectPool:Get("showitem", cellObj)
    if fun.is_null(diEffect) then
        return
    end
    
    local parentObj = self:GetCardView():GetCard(cardId).storehouse
    fun.set_parent(diEffect, parentObj, false)
    fun.set_gameobject_scale(diEffect, 1, 1, 1)
    if self.cardView then
        self.cardView:StorageCellBgEffect(tonumber(cardId), cellIndex, diEffect)
    end
end

function VolcanoSignEffect:SetJokerBgOnSign(ref_temp, cardId, cellIndex)

end

return this