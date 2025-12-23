local BaseSignEffect = require("View.Bingo.EffectModule.Card.SignEffect.BaseSignEffect")

local GotYouSignEffect = BaseSignEffect:New("GotYouSignEffect")
setmetatable(GotYouSignEffect, BaseSignEffect)
local this = GotYouSignEffect
local itemShowCache = {}

function GotYouSignEffect:RegisterEvent()
    itemShowCache = {}
    Event.AddListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function GotYouSignEffect:UnRegisterEvent()
    Event.RemoveListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function GotYouSignEffect:TriggerSingleBingo(cardId, cellIndex)
    --ModelList.BattleModel:GetCurrModel():GetRoundData(cardId)
    Event.Brocast(EventName.Event_Show_Skill_Bingo, cardId, cellIndex)
end

--格子盖章效果
function GotYouSignEffect:SignCardEffect(cardId, index, cardCell, signType, delay, self_bingo, giftLen)
    signType = signType or 0
    if self:CannotSignCell(cardId, index, signType) then
        return
    end
    --缓存播放过格子盖章效果
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
    --创建Bingo道具
    Event.Brocast(EventName.Event_Collect_Item_By_Sign, cardId, index)
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
function GotYouSignEffect:CellBgEffect(treasureType, cardId, cellIndex, indexList, part, pos)
    --[=[
    local curModel = ModelList.BattleModel:GetCurrModel()
    local cellData = curModel:GetRoundData(cardId, cellIndex)
    local ext = cellData:GetExtInfo()
    local groupID = ext and ext.groupID
    
    if treasureType >= 1 and treasureType <= 5 then
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
                
                if indexList and #indexList == 0 then
                    local showObj = itemShowCache[cardId][groupID].transform.parent
                    local oldParent = showObj.transform.parent
                    local anim = fun.get_component(showObj, fun.ANIMATOR)
                    anim:Play("in")
       
                    ---[[改层级
                    local cellObj = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, cellIndex):GetCellObj()
                    fun.set_parent(showObj, cellObj, false)
                    LuaTimer:SetDelayFunction(1.3, function()
                        if fun.is_not_null(showObj) and fun.is_not_null(oldParent) then
                            fun.set_parent(showObj, oldParent, false)
                        end
                    end)
                    --]]
                    log.log("GotYouSignEffect:CellBgEffect play in anim 1")
                end
                log.log("GotYouSignEffect:CellBgEffect 00", cardId, cellIndex, part)
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
                if indexList and #indexList == 0 then
                    local anim = fun.get_component(itemShowCache[cardId][groupID].transform.parent, fun.ANIMATOR)
                    anim:Play("in")
                    log.log("GotYouSignEffect:CellBgEffect play in anim 2")
                end
                log.log("GotYouSignEffect:CellBgEffect 01 不重复创建", cardId, cellIndex, part)
                return
            end
        end
    end

    local diEffectName = GetDiEffectName(treasureType, indexList)
    local diEffect = BattleEffectPool:Get(diEffectName)
    local parentObj = self:GetCardView():GetCard(cardId).storehouse
    local refer = fun.get_component(diEffect, fun.REFER)
    local bgCtrl = refer:Get("bg")
    if part ~= nil and groupID then
        --矿石展示时道具在bg之下
        itemShowCache[cardId] = itemShowCache[cardId] or {}
        itemShowCache[cardId][groupID] = bgCtrl
        fun.SetAsLastSibling(bgCtrl)
    end
    
    fun.set_parent(diEffect, parentObj, false)
    if pos then
        fun.set_gameobject_pos(diEffect, pos.x, pos.y, pos.z, false)
        log.log("GotYouSignEffect:CellBgEffect 02 setPos", diEffectName, pos, treasureType, cardId, cellIndex, part)
    else
        local cellObj = cellData:GetCellObj()
        pos = cellObj.transform.position
        fun.set_gameobject_pos(diEffect, pos.x, pos.y, pos.z, false)
        log.log("GotYouSignEffect:CellBgEffect 03 setPos", diEffectName, treasureType, cardId, cellIndex, part)
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
    --]=]
end

--- 显示格子点击提示
function GotYouSignEffect:ShowNormalCellTip(cell, cardid, cellIndex)
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
function GotYouSignEffect:SetJokerBgOnSign(ref_temp, cardId, cellIndex)

end

return this