local BaseSignEffect = require("View.Bingo.EffectModule.Card.SignEffect.BaseSignEffect")

local DrinkingFrenzySignEffect = BaseSignEffect:New("DrinkingFrenzySignEffect")
setmetatable(DrinkingFrenzySignEffect, BaseSignEffect)
local this = DrinkingFrenzySignEffect
local itemShowCache = {}

function DrinkingFrenzySignEffect:RegisterEvent()
    itemShowCache = {}
    Event.AddListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function DrinkingFrenzySignEffect:UnRegisterEvent()
    Event.RemoveListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function DrinkingFrenzySignEffect:TriggerSingleBingo(cardId, cellIndex)
    --ModelList.BattleModel:GetCurrModel():GetRoundData(cardId)
    Event.Brocast(EventName.Event_Show_Skill_Bingo, cardId, cellIndex)
end

--格子盖章效果
function DrinkingFrenzySignEffect:SignCardEffect(cardId, index, cardCell, signType, delay, self_bingo, giftLen)
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
    Event.Brocast(EventName.Event_Collect_Item_By_Sign, cardId, index)
end

function DrinkingFrenzySignEffect:HideCellChild(ref_temp, cardID, cellIndex)
    for i = 1, fun.get_child_count(ref_temp) do
        fun.set_active(fun.get_child(ref_temp, i - 1), false)
    end

    BaseSignEffect.HideCellChild(self, ref_temp)
end


-- 盖章后地板效果名称
local function GetDiEffectName(itemId, part)
    if itemId == 261001 then
        return "treasure02"
    elseif itemId == 261002 then
        return "treasure01"
    elseif itemId == 261003 then
        return "treasure01"
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

function DrinkingFrenzySignEffect:CellExtraBonus(cardId,cellIndex)
    local curModel = ModelList.BattleModel:GetCurrModel()
    if curModel:CheckIsExtraBonusCardIndexByCardId(cardId,cellIndex) then
        local card = self:GetCardView():GetCard(cardId)
        local cellObj = self:GetCardView():GetCardCell(cardId, cellIndex)
        local pos = cellObj.transform.position
        card:FlyExtraBonus(pos)
    end
end

--- 格子底部印章效果
function DrinkingFrenzySignEffect:CellBgEffect(itemId,treasureType, cardId, cellIndex, iconName, part, pos)
    cardId = tonumber(cardId)
    self:CellExtraBonus(cardId , cellIndex)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local cellData = curModel:GetRoundData(cardId, cellIndex)
    local ext = cellData:GetExtInfo()
    local groupID = ext and ext.groupID

    if itemId == 261001 or itemId == 261002 or itemId == 261003 then
        if not part then
            if itemShowCache[cardId] and itemShowCache[cardId][groupID] then
                --矿石获得时道具在bg之上
                fun.SetAsFirstSibling(itemShowCache[cardId][groupID])

                --jokerbg的层级需要在bg之上
                local cellObj = self:GetCardView():GetCardCell(cardId, cellIndex)
                local ref_temp = fun.get_component(cellObj, fun.REFER)
                local jokerBg = ref_temp:Get("JokerBg")
                if not fun.is_null(jokerBg) then
                    fun.set_parent(jokerBg.transform.parent, itemShowCache[cardId][groupID])
                end

                log.log("DrinkingFrenzySignEffect:CellBgEffect 00", cardId, cellIndex, part)
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
                log.log("DrinkingFrenzySignEffect:CellBgEffect 01 不重复创建", cardId, cellIndex, part)
                return
            end
        end
    end

    local diEffectName = GetDiEffectName(itemId, part)
    local diEffect = BattleEffectPool:Get(diEffectName)
    log.log("丢失的UI内容 " , itemId , "   "  , diEffectName)
    local parentObj = self:GetCardView():GetCard(cardId).storehouse
    local refer = fun.get_component(diEffect, fun.REFER)
    local bgCtrl = refer:Get("bg")
    if part ~= nil and groupID then
        --矿石展示时道具在bg之下
        itemShowCache[cardId] = itemShowCache[cardId] or {}
        itemShowCache[cardId][groupID] = bgCtrl
        fun.SetAsLastSibling(bgCtrl)
    end

    ---[[牌面V1
    --local itemImg = refer:Get("di")
    --if fun.is_not_null(itemImg) then
    --    if iconName then
    --        itemImg.sprite = resMgr:GetSpriteByName("DrinkingFrenzyBingoAtlas", iconName)
    --    else
    --        local curModel = ModelList.BattleModel:GetCurrModel()
    --        local collectLevel = curModel:GetCurrentCollectLevel()
    --        local imgName = curModel:GetMineralImageNameByIdxAndLevel(treasureType, collectLevel)
    --        itemImg.sprite = resMgr:GetSpriteByName("DrinkingFrenzyBingoAtlas", imgName) --todo
    --    end
    --end
    --]]

    fun.set_parent(diEffect, parentObj, false)
    if pos then
        fun.set_gameobject_pos(diEffect, pos.x, pos.y, pos.z, false)
        log.log("DrinkingFrenzySignEffect:CellBgEffect 02 setPos", diEffectName, pos, treasureType, cardId, cellIndex, part)
    else
        local cellObj = cellData:GetCellObj()
        pos = cellObj.transform.position
        fun.set_gameobject_pos(diEffect, pos.x, pos.y, pos.z, false)
        log.log("DrinkingFrenzySignEffect:CellBgEffect 03 setPos", diEffectName, treasureType, cardId, cellIndex, part)
    end
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
function DrinkingFrenzySignEffect:ShowNormalCellTip(cell, cardid, cellIndex)
    local poolName = "CellGet"
    local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardid, cellIndex)
    if cellData then
        if cellData.isSignByGemPuSkill then
            --标识是被技能1盖章
            poolName = "CellGetPuSkill"
        end
        if cellData.isSignByGemBingoSkill then
            --标识是被技能2盖章
            poolName = "CellGetBingoSkill"
        end
    end
    self.__index.ShowNormalCellTip(self, cell, cardid, cellIndex, poolName)
end

--设置新的JokerBg
function DrinkingFrenzySignEffect:SetJokerBgOnSign(ref_temp, cardId, cellIndex)

end

return this