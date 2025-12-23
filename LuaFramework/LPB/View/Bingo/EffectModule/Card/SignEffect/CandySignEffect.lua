local BaseSignEffect = require("View.Bingo.EffectModule.Card.SignEffect.BaseSignEffect")

local CandySignEffect = BaseSignEffect:New("CandySignEffect")
setmetatable(CandySignEffect, BaseSignEffect)
local this = CandySignEffect
local itemShowCache = {}

function CandySignEffect:RegisterEvent()
    itemShowCache = {}
    Event.AddListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function CandySignEffect:UnRegisterEvent()
    Event.RemoveListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function CandySignEffect:TriggerSingleBingo(cardId, cellIndex)
    --ModelList.BattleModel:GetCurrModel():GetRoundData(cardId)
    Event.Brocast(EventName.Event_Show_Skill_Bingo, cardId, cellIndex)
end

function CandySignEffect:SignCardEffect(cardId, index, cardCell, signType, delay, self_bingo, giftLen)
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

local function GetDiEffectName(treasureType, part)
    --return string.format("treasure0%s", treasureType)
    return string.format("treasure0%s", 3)
end

function CandySignEffect:CellBgEffect(treasureType, cardId, cellIndex, part, pos)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local cellData = curModel:GetRoundData(cardId, cellIndex)
    local ext = cellData:GetExtInfo()
    local groupID = ext and ext.groupID
    
    if not part then
        if itemShowCache[cardId] and itemShowCache[cardId][groupID] then
            --fun.SetAsFirstSibling(itemShowCache[cardId][groupID])
            local cellObj = self:GetCardView():GetCardCell(cardId, cellIndex)
            local ref_temp = fun.get_component(cellObj, fun.REFER)
            local jokerBg = ref_temp:Get("JokerBg")
            if not fun.is_null(jokerBg) then
                fun.set_parent(jokerBg.transform.parent, itemShowCache[cardId][groupID])
            end
            
            local ref = fun.get_component(itemShowCache[cardId][groupID].transform.parent, fun.REFER)
            local diImage = ref:Get("di")
            if fun.is_not_null(diImage) then
                fun.set_img_color(diImage, Color.New(1, 1, 1, 1))
            end
            return
        end
    else
        if itemShowCache[cardId] and itemShowCache[cardId][groupID] then
            local cellObj = self:GetCardView():GetCardCell(cardId, cellIndex)
            local ref_temp = fun.get_component(cellObj, fun.REFER)
            local jokerBg = ref_temp:Get("JokerBg")
            if not fun.is_null(jokerBg) then
                fun.set_parent(jokerBg.transform.parent, itemShowCache[cardId][groupID])
            end
            return
        end
    end
    
    local diEffectName = GetDiEffectName(treasureType, part)
    local diEffect = BattleEffectPool:Get(diEffectName)
    if fun.is_null(diEffect) then
        return
    end
    
    local parentObj = self:GetCardView():GetCard(cardId).storehouse
    local refer, bgCtrl = fun.get_component(diEffect, fun.REFER)
    if refer then
        bgCtrl = refer:Get("bg")
        if groupID and part ~= nil then
            itemShowCache[cardId] = itemShowCache[cardId] or {}
            itemShowCache[cardId][groupID] = bgCtrl
            --fun.SetAsLastSibling(bgCtrl)
        end
    end
    
    fun.set_parent(diEffect, parentObj, false)
    if pos then
        fun.set_gameobject_pos(diEffect, pos.x, pos.y, pos.z, false)
    end
    fun.set_gameobject_scale(diEffect, 1, 1, 1)
    if self.cardView then
        self.cardView:StorageCellBgEffect(tonumber(cardId), cellIndex, diEffect)
    end

    if bgCtrl then
        local cellObj = self:GetCardView():GetCardCell(cardId, cellIndex)
        local ref_temp = fun.get_component(cellObj, fun.REFER)
        local jokerBg = ref_temp:Get("JokerBg")
        if not fun.is_null(jokerBg) then
            fun.set_parent(jokerBg.transform.parent, bgCtrl)
        end
    end
end

function CandySignEffect:ShowNormalCellTip(cell, cardid, cellIndex)
    --local poolName = "CellGet"
    --local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardid, cellIndex)
    --if cellData then
    --    if cellData.isSignByGemPuSkill then
    --        poolName = "CellGetPuSkill"
    --    end
    --    if cellData.isSignByGemBingoSkill then
    --        poolName = "CellGetBingoSkill"
    --    end
    --end
    
    self.__index.ShowNormalCellTip(self, cell, cardid, cellIndex, poolName)
end

function CandySignEffect:SetJokerBgOnSign(ref_temp, cardId, cellIndex)

end

return this