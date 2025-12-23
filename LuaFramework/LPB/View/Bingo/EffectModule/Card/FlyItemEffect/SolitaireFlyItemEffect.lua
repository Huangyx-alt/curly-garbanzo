local BaseFlyItemEffect = require("View.Bingo.EffectModule.Card.FlyItemEffect.BaseFlyItemEffect")

local SolitaireFlyItemEffect = BaseFlyItemEffect:New("SolitaireFlyItemEffect")
local this = SolitaireFlyItemEffect
local itemShowCache = {}

function this:Remove()
    Event.RemoveListener(EventName.Event_Collect_Item_By_Sign, self.CreateTreasure, self)
end 

function this:Register()
    itemShowCache = {}
    Event.AddListener(EventName.Event_Collect_Item_By_Sign, self.CreateTreasure, self)
end

function this:CreateTreasure(cardId, cellIndex)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local curCell = curModel:GetRoundData(cardId, cellIndex)
    local treasureItems = curCell:Treasure2Item()

    if treasureItems then
        local data = Csv.GetData("item", treasureItems.id)
        if 46 == data.item_type then
            local ext = curCell:GetExtInfo()
            CalculateBingoMachine.OnDataChange(cardId, cellIndex, ext.groupID, 1) -- for wish
            local nominalValue = ext.nominalValue
            local groupCells = ext and ext.groupCells
            if groupCells and ext.groupID == 3 then
                local isAllSigned = true
                local pos = Vector3.zero
                table.each(groupCells, function(cellData)
                    if cellData then
                        local cellObj = cellData:GetCellObj()
                        pos = pos + cellObj.transform.position
                        isAllSigned = isAllSigned and not (cellData:IsNotSign() or cellData:IsLogicSign())
                    end
                end)
                pos = pos / #groupCells
                this:DoCreateTreasure(curCell, cardId, cellIndex, ext.groupID, data.icon, isAllSigned, pos)
                if not isAllSigned then
                    return
                end
            end

            local pokerObj = this:DoCreateTreasure(curCell, cardId, cellIndex, ext.groupID, data.icon, true)
            Event.Brocast(EventName.Event_Logic_Collect_Item, cardId, cellIndex, ext.groupID, 1)
            local bundle = {nominal = nominalValue, obj = pokerObj, itemId = treasureItems.id, idx = cellIndex}
            Event.Brocast(EventName.Event_View_Collect_Item, cardId, ext.groupID, bundle)
            --UISound.play("Solitairexxx")
            -- LuaTimer:SetDelayFunction(1, function()

            -- end, false, LuaTimer.TimerType.BattleUI)
        end
    end
end

-- 盖章后地板效果名称
local function GetDiEffectName(treasureType, cardId)
    if treasureType == 1 then
        return "CollectItem1"
    elseif treasureType == 2 then
        return "CollectItem1" --不区分红黑
    elseif treasureType == 3 then
        return "CollectItem3"
    end
end

function this:DoCreateTreasure(cellData, cardId, cellIndex, groupId, icon, whole, pos)
    if groupId == 3 then
         --有新碎片但不是第一个
        if itemShowCache[cardId] and itemShowCache[cardId][groupId] then
            log.log("SolitaireFlyItemEffect:CellBgEffect 01 不重复创建", cardId, cellIndex)
            return itemShowCache[cardId][groupId]
        end
    end

    local diEffectName = GetDiEffectName(groupId, cardId)
    local diEffect = BattleEffectPool:Get(diEffectName)
    local parentObj = self:GetCardView():GetCard(cardId).storehouse
    if groupId and groupId > 0 then
        --矿石展示时道具在bg之下
        itemShowCache[cardId] = itemShowCache[cardId] or {}
        itemShowCache[cardId][groupId] = diEffect
    end

    fun.set_parent(diEffect, parentObj, false)
    if pos then
        fun.set_gameobject_pos(diEffect, pos.x, pos.y, pos.z, false)
        log.log("SolitaireFlyItemEffect:CellBgEffect 02 setPos", diEffectName, pos, groupId, cardId, cellIndex)
    else
        local cellObj = cellData:GetCellObj()
        pos = cellObj.transform.position
        fun.set_gameobject_pos(diEffect, pos.x, pos.y, pos.z, false)
        log.log("SolitaireFlyItemEffect:CellBgEffect 03 setPos", diEffectName, groupId, cardId, cellIndex)
    end
    fun.set_gameobject_scale(diEffect, 1, 1, 1)
    if self.cardView and self.cardView["StorageCellBgEffect"] then
        self.cardView:StorageCellBgEffect(tonumber(cardId), cellIndex, diEffect)
    end

    local ref = fun.get_component(diEffect, fun.REFER)
    if groupId ~= 3 then
        local poker = ref:Get("poker")
        poker.sprite = AtlasManager:GetSpriteByName("SolitaireBingoAtlas", icon)
    else

    end

    return diEffect
end

return this