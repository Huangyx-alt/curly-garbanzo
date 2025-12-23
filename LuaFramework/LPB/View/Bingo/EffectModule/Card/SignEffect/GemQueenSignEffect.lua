local BaseSignEffect = require("View.Bingo.EffectModule.Card.SignEffect.BaseSignEffect")

local GemQueenSignEffect = BaseSignEffect:New("GemQueenSignEffect")
setmetatable(GemQueenSignEffect, BaseSignEffect)
local this = GemQueenSignEffect
local itemShowCache = {}

function GemQueenSignEffect:RegisterEvent()
    itemShowCache = {}
    Event.AddListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function GemQueenSignEffect:UnRegisterEvent()
    Event.RemoveListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function GemQueenSignEffect:TriggerSingleBingo(cardId, cellIndex)
    --ModelList.BattleModel:GetCurrModel():GetRoundData(cardId)
    Event.Brocast(EventName.Event_Show_Skill_Bingo, cardId, cellIndex)
end

--格子盖章效果
function GemQueenSignEffect:SignCardEffect(cardId, index, cardCell, signType, delay, self_bingo, giftLen)
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

-- 盖章后地板效果
local function GetDiEffectName(treasureType, part)
    if 1 == part then
        return "treasure01"
    elseif 2 == part then
        return "treasure02"
    elseif treasureType == 2 then
        return "treasure03"
    elseif treasureType == 3 then
        return "treasure04"
    elseif treasureType == 4 then
        return "treasure05"
    else
        return "treasure03"
    end
end

local function GetDieffectCell(view, cardId, cellIndex, part, step)
    if 1 == part then
        -- 横放
        if step then
            return view:GetCardCell(tonumber(cardId), step)
        else
            return view:GetCardCell(tonumber(cardId), cellIndex)
        end
    elseif 2 == part then
        -- 竖放
        if step then
            return view:GetCardCell(tonumber(cardId), step)
        else
            return view:GetCardCell(tonumber(cardId), cellIndex)
        end
    else
        return view:GetCardCell(tonumber(cardId), cellIndex)
    end
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
--- 格子底部印章效果
function GemQueenSignEffect:CellBgEffect(treasureType, cardId, cellIndex, part, step)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local cellData = curModel:GetRoundData(cardId, cellIndex)
    local ext = cellData:GetExtInfo()
    local groupID = ext and ext.groupID
    
    if treasureType == 1 and not part then
        if itemShowCache[cardId] and itemShowCache[cardId][groupID] then
            --皇冠获得时道具在bg之上
            fun.SetAsFirstSibling(itemShowCache[cardId][groupID])

            --jokerbg的层级需要在bg之上
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
    local parentObj = self:GetCardView():GetCard(cardId).storehouse
    local parentPos = GetDieffectCell(self:GetCardView(), cardId, cellIndex, part, step).transform.position

    local refer = fun.get_component(diEffect, fun.REFER)
    local bgCtrl = refer:Get("bg")
    if part ~= nil and groupID then
        --皇冠展示时道具在bg之下
        itemShowCache[cardId] = itemShowCache[cardId] or {}
        itemShowCache[cardId][groupID] = bgCtrl
        fun.SetAsLastSibling(bgCtrl)
    end
    
    fun.set_parent(diEffect, parentObj, false)
    fun.set_gameobject_pos(diEffect, parentPos.x, parentPos.y, parentPos.z, false)
    fun.set_gameobject_scale(diEffect, 1, 1, 1)
    if self.cardView and self.cardView["StorageCellBgEffect"] then
        self.cardView:StorageCellBgEffect(tonumber(cardId), cellIndex, diEffect)
    end

    --jokerbg的层级需要在bg之上
    local cellObj = self:GetCardView():GetCardCell(cardId, cellIndex)
    local ref_temp = fun.get_component(cellObj, fun.REFER)
    local jokerBg = ref_temp:Get("JokerBg")
    if not fun.is_null(jokerBg) then
        fun.set_parent(jokerBg.transform.parent, bgCtrl)
    end
end

--- 显示格子点击提示
function GemQueenSignEffect:ShowNormalCellTip(cell, cardid, cellIndex)
    local poolName = "CellGet"
    local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardid, cellIndex)
    if cellData then
        if cellData.isSignByGemPuSkill then
            --标识是被法杖技能盖章
            poolName = "CellGetPuSkill"
        end
        if cellData.isSignByGemBingoSkill then
            --标识是被魔镜技能盖章
            poolName = "CellGetBingoSkill"
        end
    end
    
    self.__index.ShowNormalCellTip(self, cell, cardid, cellIndex, poolName)
end

--设置新的JokerBg
function GemQueenSignEffect:SetJokerBgOnSign(ref_temp, cardId, cellIndex)

end

return this