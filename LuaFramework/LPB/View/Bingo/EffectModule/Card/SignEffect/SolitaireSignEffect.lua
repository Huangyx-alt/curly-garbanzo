local BaseSignEffect = require("View.Bingo.EffectModule.Card.SignEffect.BaseSignEffect")

local SolitaireSignEffect = BaseSignEffect:New("SolitaireSignEffect")
setmetatable(SolitaireSignEffect, BaseSignEffect)
local this = SolitaireSignEffect
local itemShowCache = {}

function SolitaireSignEffect:RegisterEvent()
    itemShowCache = {}
    -- Event.AddListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function SolitaireSignEffect:UnRegisterEvent()
    -- Event.RemoveListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function SolitaireSignEffect:TriggerSingleBingo(cardId, cellIndex)
    --ModelList.BattleModel:GetCurrModel():GetRoundData(cardId)
    Event.Brocast(EventName.Event_Show_Skill_Bingo, cardId, cellIndex)
end

function SolitaireSignEffect:SignCardEffect(cardId, index, cardCell, signType, delay, self_bingo, giftLen)
    signType = signType or 0
    if self:CannotSignCell(cardId, index, signType) then
        return
    end
    self:SaveCellSignEffect(cardId, index)
    delay = delay or 0
    for i = 1, fun.get_child_count(cardCell) do
        fun.set_active(fun.get_child(cardCell, i - 1), false)
    end
    --if true then return end --无
    local ref_temp = fun.get_component(cardCell, fun.REFER)
    self:HideCellChild(ref_temp, cardId, index)
    --if true then return end --有
    Event.Brocast(EventName.Magnifier_Close_Single_Cell, cardCell, false)

    if self_bingo then
        self:TriggerSingleBingo(cardId, index)
    end

    Event.Brocast(EventName.Event_Collect_Item_By_Sign, cardId, index)
end

function SolitaireSignEffect:SetJokerBgOnSign(ref_temp, cardId, cellIndex)
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