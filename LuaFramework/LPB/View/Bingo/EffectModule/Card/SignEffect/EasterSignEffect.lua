local BaseSignEffect = require("View.Bingo.EffectModule.Card.SignEffect.BaseSignEffect")

local EasterSignEffect = BaseSignEffect:New("EasterSignEffect")
setmetatable(EasterSignEffect, BaseSignEffect)
local this = EasterSignEffect
local itemShowCache = {}

function EasterSignEffect:RegisterEvent()
    itemShowCache = {}
    Event.AddListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function EasterSignEffect:UnRegisterEvent()
    Event.RemoveListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function EasterSignEffect:TriggerSingleBingo(cardId, cellIndex)
    Event.Brocast(EventName.Event_Show_Skill_Bingo, cardId, cellIndex)
end

function EasterSignEffect:SignCardEffect(cardId, index, cardCell, signType, delay, self_bingo, giftLen)
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
    Event.Brocast(EventName.Event_Collect_Item_By_Sign, cardId, index)
end

local function GetDiEffectName(treasureType)
    if treasureType == 4 then
        return "showitem2"
    else
        return "showitem"
    end
end

function EasterSignEffect:CellBgEffect(treasureType, cardId, cellIndex)
    local diEffect = BattleEffectPool:Get(GetDiEffectName(treasureType))
    if fun.is_null(diEffect) then
        return
    end

    local curModel = ModelList.BattleModel:GetCurrModel()
    local curCell = curModel:GetRoundData(cardId, cellIndex)
    local cellObj = curCell:GetCellObj()
    local parentObj = self:GetCardView():GetCard(cardId).storehouse
    fun.set_parent(diEffect, parentObj)
    fun.set_same_position_with(diEffect, curCell:GetCellObj())
    fun.set_gameobject_scale(diEffect, 1, 1, 1)
    
    if self.cardView then
        self.cardView:StorageCellBgEffect(tonumber(cardId), cellIndex, diEffect)
    end

    --jokerbg的层级需要在道具之下
    local ref_temp = fun.get_component(cellObj, fun.REFER)
    local jokerBg = ref_temp:Get("JokerBg")
    if not fun.is_null(jokerBg) then
        fun.set_parent(jokerBg.transform.parent, diEffect)
        fun.SetAsFirstSibling(jokerBg.transform.parent.gameObject)
    end
end

function EasterSignEffect:SetJokerBgOnSign(ref_temp, cardId, cellIndex)
    --local jokerBg = ref_temp:Get("JokerBg")
    --if not fun.is_null(jokerBg) then
    --    --fun.set_img_color(jokerBg, Color.New(1, 1, 1, 0.65))
    --    local playId = ModelList.BattleModel:GetGameCityPlayID()
    --    local cfg = Csv.GetData("new_game_cell", playId)
    --    if cfg.joker_bg_signed ~= "0" then
    --        jokerBg.sprite = AtlasManager:GetSpriteByName(cfg.atlas_name, cfg.joker_bg_signed)
    --    end
    --end
end

return this