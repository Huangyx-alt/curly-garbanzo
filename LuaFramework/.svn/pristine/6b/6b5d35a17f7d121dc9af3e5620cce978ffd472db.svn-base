local BaseSignEffect = require("View.Bingo.EffectModule.Card.SignEffect.BaseSignEffect")

local LetemRollSignEffect = BaseSignEffect:New("LetemRollSignEffect")
setmetatable(LetemRollSignEffect, BaseSignEffect)
local this = LetemRollSignEffect
local itemShowCache = {}

function LetemRollSignEffect:RegisterEvent()
    itemShowCache = {}
    Event.AddListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function LetemRollSignEffect:UnRegisterEvent()
    Event.RemoveListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function LetemRollSignEffect:TriggerSingleBingo(cardId, cellIndex)
    --ModelList.BattleModel:GetCurrModel():GetRoundData(cardId)
    Event.Brocast(EventName.Event_Show_Skill_Bingo, cardId, cellIndex)
end

--格子盖章效果
function LetemRollSignEffect:SignCardEffect(cardId, index, cardCell, signType, delay, self_bingo, giftLen)
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

--undo wait deal
-- 盖章后地板效果名称
local function GetDiEffectName(treasureType, cardId)
    if treasureType == 1 then
        local bowlCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetBowlCount(cardId)
        local curCount = bowlCount[1]
        local curModel = ModelList.BattleModel:GetCurrModel()
        local location = curModel:GetCollectTargetLocation(tonumber(cardId), curCount)
        if location == 4 then
            return "treasure02"
        elseif location == 5 then
            return "treasure03"
        end

        return "treasure01"
    elseif treasureType == 2 then
        return "treasure04"
    elseif treasureType == 3 then
        return "treasure05"
    end
end

--- 格子底部印章效果
function LetemRollSignEffect:CellBgEffect(treasureType, cardId, cellIndex, iconName, part, pos)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local cellData = curModel:GetRoundData(cardId, cellIndex)
    local ext = cellData:GetExtInfo()
    local groupID = ext and ext.groupID
    log.log("dghdgh0008 the group id is ", groupID)

    if treasureType == 3 or treasureType == 2 then
        if not part then --碎片集齐
            if itemShowCache[cardId] and itemShowCache[cardId][groupID] then
                log.log("LetemRollSignEffect:CellBgEffect 00", cardId, cellIndex, part)
                self:OnAllChipFind(cardId, groupID, treasureType, cellIndex)
                return
            else
                log.log("LetemRollSignEffect:CellBgEffect error", treasureType, cardId, cellIndex, iconName, part, pos)
            end
        else --有新碎片但不是第一个
            if itemShowCache[cardId] and itemShowCache[cardId][groupID] then
                log.log("LetemRollSignEffect:CellBgEffect 01 不重复创建", cardId, cellIndex, part)
                return
            end
        end
    end

    local diEffectName = GetDiEffectName(treasureType, cardId)
    local diEffect = BattleEffectPool:Get(diEffectName)
    local parentObj = self:GetCardView():GetCard(cardId).storehouse
    if part ~= nil and groupID > 0 then
        --矿石展示时道具在bg之下
        itemShowCache[cardId] = itemShowCache[cardId] or {}
        itemShowCache[cardId][groupID] = diEffect
    end

    fun.set_parent(diEffect, parentObj, false)
    if pos then
        fun.set_gameobject_pos(diEffect, pos.x, pos.y, pos.z, false)
        log.log("LetemRollSignEffect:CellBgEffect 02 setPos", diEffectName, pos, treasureType, cardId, cellIndex, part)
    else
        local cellObj = cellData:GetCellObj()
        pos = cellObj.transform.position
        fun.set_gameobject_pos(diEffect, pos.x, pos.y, pos.z, false)
        log.log("LetemRollSignEffect:CellBgEffect 03 setPos", diEffectName, treasureType, cardId, cellIndex, part)
    end
    fun.set_gameobject_scale(diEffect, 1, 1, 1)
    if self.cardView and self.cardView["StorageCellBgEffect"] then
        self.cardView:StorageCellBgEffect(tonumber(cardId), cellIndex, diEffect)
    end
end

--- 显示格子点击提示
function LetemRollSignEffect:ShowNormalCellTip(cell, cardid, cellIndex)
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
function LetemRollSignEffect:SetJokerBgOnSign(ref_temp, cardId, cellIndex)

end


function LetemRollSignEffect:OnAllChipFind(cardId, groupID, treasureType, cellIndex)
    local bundle = {}
    bundle.signEffectObj = itemShowCache[cardId][groupID]
    
    --飞道具
    LuaTimer:SetDelayFunction(1, function()
        Event.Brocast(EventName.Event_View_Collect_Item, cardId, treasureType, bundle)
    end, nil, LuaTimer.TimerType.Battle)
end

return this