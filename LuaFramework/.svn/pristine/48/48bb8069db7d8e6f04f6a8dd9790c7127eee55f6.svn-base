local BaseSignEffect = require("View.Bingo.EffectModule.Card.SignEffect.BaseSignEffect")

local PirateShipSignEffect = BaseSignEffect:New("PirateShipSignEffect")
setmetatable(PirateShipSignEffect, BaseSignEffect)
local this = PirateShipSignEffect
local countFlag = {}
local firstSoundFlag = {}

function PirateShipSignEffect:RegisterEvent()
    countFlag = {}
    firstSoundFlag = {}
    Event.AddListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function PirateShipSignEffect:UnRegisterEvent()
    Event.RemoveListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function PirateShipSignEffect:TriggerSingleBingo(cardId, cellIndex)
    Event.Brocast(EventName.Event_Show_Skill_Bingo, cardId, cellIndex)
end

function PirateShipSignEffect:SignCardEffect(cardId, index, cardCell, signType, delay, self_bingo, giftLen)
    signType = signType or 0
    if self:CannotSignCell(cardId, index, signType) then
        return
    end
    self:SaveCellSignEffect(cardId, index)
    delay = delay or 0

    local ref_temp = fun.get_component(cardCell, fun.REFER)
    self:HideCellChild(ref_temp, cardId, index)

    Event.Brocast(EventName.Magnifier_Close_Single_Cell, cardCell, false)

    if self_bingo then
        self:TriggerSingleBingo(cardId, index)
    end
    
    --Event.Brocast(EventName.Event_Collect_Item_By_Sign, cardId, index)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local moveMachine = curModel and curModel.moveMachine
    if moveMachine then
        moveMachine:OnCellSigned(cardId, index)
    end
    
    self:CellBgEffect(cardId, index)
end

function PirateShipSignEffect:HideCellChild(ref_temp, cardID, cellIndex)
    for i = 1, fun.get_child_count(ref_temp) do
        fun.set_active(fun.get_child(ref_temp, i - 1), false)
    end
    
    BaseSignEffect.HideCellChild(self, ref_temp)

    local ef_Bingo_click = ref_temp:Get("ef_Bingo_click")
    fun.set_active(ef_Bingo_click, false)
end

function PirateShipSignEffect:CellBgEffect(cardId, cellIndex, iconName)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local curCell = curModel:GetRoundData(cardId, cellIndex)
    local treasureItems = curCell:Treasure2Item()
    if not treasureItems then
        return
    end
    
    local data = Csv.GetData("new_item", treasureItems.id)
    if 11 ~= data.result[1] then
        return
    end
    
    local cellObj = curCell:GetCellObj()
    local diEffect = BattleEffectPool:Get("showitem", cellObj)
    if fun.is_null(diEffect) then
        return
    end
    
    --图片
    local refer = fun.get_component(diEffect, fun.REFER)
    local ExplorersBox1 = refer:Get("ExplorersBox1")
    local ExplorersBox5 = refer:Get("ExplorersBox5")
    local isMaxBet = curModel:GetIsMaxBet()
    fun.set_active(ExplorersBox1, not isMaxBet)
    fun.set_active(ExplorersBox5, isMaxBet)
    
    local parentObj = self:GetCardView():GetCard(cardId).storehouse
    fun.set_parent(diEffect, parentObj, false)
    fun.set_gameobject_scale(diEffect, 1, 1, 1)
    if self.cardView then
        self.cardView:StorageCellBgEffect(tonumber(cardId), cellIndex, diEffect)
    end

    self:PlayFirstSound(cardId)
end

function PirateShipSignEffect:SetJokerBgOnSign(ref_temp, cardId, cellIndex)

end

function PirateShipSignEffect:PlayFirstSound(cardId)
    countFlag[cardId] = countFlag[cardId] or 0
    countFlag[cardId] = countFlag[cardId] + 1
    
    if countFlag[cardId] == 2 then
        --仅第2个宝箱时播放一次
        if not firstSoundFlag["2"] then
            firstSoundFlag["2"] = true
            local random = math.random(1, 2)
            UISound.play(random == 1 and "piratedoubloons" or "piratematey")
        end
    end
    if countFlag[cardId] == 3 then
        --仅第3个宝箱时播放一次
        if not firstSoundFlag["3"] then
            firstSoundFlag["3"] = true
            local random = math.random(1, 2)
            UISound.play(random == 1 and "pirateavast" or "pirateahoy")
        end
    end
    if countFlag[cardId] == 5 then
        --仅第5个宝箱时播放一次
        if not firstSoundFlag["5"] then
            firstSoundFlag["5"] = true
            UISound.play("piraterum")
        end
    end
end

return this