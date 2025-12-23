local BaseSignEffect = require("View.Bingo.EffectModule.Card.SignEffect.BaseSignEffect")

local PiggyBankSignEffect = BaseSignEffect:New("PiggyBankSignEffect")
setmetatable(PiggyBankSignEffect, BaseSignEffect)
local this = PiggyBankSignEffect
local itemShowCache = {}

function PiggyBankSignEffect:RegisterEvent()
    itemShowCache = {}
    -- Event.AddListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function PiggyBankSignEffect:UnRegisterEvent()
    -- Event.RemoveListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function PiggyBankSignEffect:TriggerSingleBingo(cardId, cellIndex)
    --ModelList.BattleModel:GetCurrModel():GetRoundData(cardId)
    Event.Brocast(EventName.Event_Show_Skill_Bingo, cardId, cellIndex)
end

function PiggyBankSignEffect:SignCardEffect(cardId, index, cardCell, signType, delay, self_bingo, giftLen)
    signType = signType or 0
    if self:CannotSignCell(cardId, index, signType) then
        return
    end
    self:SaveCellSignEffect(cardId, index)
    delay = delay or 0

    --if true then return end --无
    local ref_temp = fun.get_component(cardCell, fun.REFER)
    self:HideCellChild(ref_temp, cardId, index)
    --if true then return end --有
    Event.Brocast(EventName.Magnifier_Close_Single_Cell, cardCell, false)

    if self_bingo then
        self:TriggerSingleBingo(cardId, index)
    end

    local curModel = ModelList.BattleModel:GetCurrModel()
    local curCellData = curModel:GetRoundData(cardId, index)
    local isUpgradePu = fun.is_include(821, curCellData:GetGift())
    if isUpgradePu then
        self:TriggerUpgradePu(cardId, index, cardCell, signType, delay, self_bingo, giftLen)
    else
        Event.Brocast(EventName.Event_Collect_Item_By_Sign, cardId, index)
    end
end

function PiggyBankSignEffect:HideCellChild(ref_temp, cardID, cellIndex)
    for i = 1, fun.get_child_count(ref_temp) do
        fun.set_active(fun.get_child(ref_temp, i - 1), false)
    end

    BaseSignEffect.HideCellChild(self, ref_temp)

    local ef_Bingo_click = ref_temp:Get("ef_Bingo_click")
    fun.set_active(ef_Bingo_click, false)
end

function PiggyBankSignEffect:SetJokerBgOnSign(ref_temp, cardId, cellIndex)
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

function PiggyBankSignEffect:TriggerUpgradePu(cardId, index, cardCell, signType, delay, self_bingo, giftLen)
    log.log("PiggyBankSingleCardView:PreviewUpgradePuLocation 有升级PU ", cardId, index, cardCell.name)
    --undo wait anim name
    BattleEffectCache:GetSkillPrefabFromCache("PiggyBankskillyanjing", cardCell, function(obj)
        --do something
    end, 2, cardId)

    --undo anim fly to anim
    self:GetCardView():ActiveUpgradePu(index, cardId)
    Event.Brocast(EventName.Event_Collect_Item_By_Sign, cardId, index)
end

return this