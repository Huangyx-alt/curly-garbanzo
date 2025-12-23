local BaseSkill = require("View.Bingo.CardModule.Skill.BaseSkill")

local ThievesPuSkill = BaseSkill:New("ThievesPuSkill")
setmetatable(ThievesPuSkill, BaseSkill)
local this = ThievesPuSkill
local private = {}

function ThievesPuSkill:ShowSkill(cardId, cellIndex)
    cardId = tonumber(cardId)

    local logicModule = BattleLogic.GetLogicModule(LogicName.Card_logic)
    if logicModule:IsJackpot(cardId) then
        return
    end

    local curModel, thievesPosList = ModelList.BattleModel:GetCurrModel()
    if ModelList.BattleModel:IsRocket() then
        --在小火箭界面使用5036里的数据
        local data = curModel:GetSettleExtraInfo("wolfClaw")
        data = table.find(data, function(k, v)
            local cellID = ConvertServerPos(v.pos)
            return v.cardId == cardId and cellID == cellIndex
        end)
        if data then
            thievesPosList = BattleTool.GetFromServerPos(data.wolfPos)
        end
        if not data or #thievesPosList == 0 then
            thievesPosList = curModel:GetValidThievesForPuSkill(cardId, cellIndex)
        end
    else
        thievesPosList = curModel:GetValidThievesForPuSkill(cardId, cellIndex)
    end
    table.each(thievesPosList, function(pos)
        private.ShowClawSkillEffect(self, cardId, cellIndex, pos)
    end)

    --添加ExtraData，结算时通知服务器
    curModel:GetRoundData(cardId):AddExtraUpLoadData("wolfClaw", {
        cardId = tonumber(cardId),
        pos = ConvertCellIndexToServerPos(cellIndex),
        wolfPos = BattleTool.ConvertedToServerPosList(thievesPosList),
    }, "pos")
end

-----------------私有方法----------------------------------------------

function private.ShowClawSkillEffect(self, cardId, cellIndex, thievesPos)
    --逻辑层更新
    BattleLogic.GetLogicModule(LogicName.Card_logic):ReduceLogicLockTiers(cardId, thievesPos)

    --local target = self:GetCardPower().cardView:GetCardMap((cardId))
    --local cellTarget = self:GetCardPower().cardView:GetCardCell((cardId), cellIndex)
    local thievesTarget = self:GetCardPower().cardView:GetCardCell((cardId), thievesPos)
    local curModel, cardView = ModelList.BattleModel:GetCurrModel(), self:GetCardPower().cardView
    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    
    BattleEffectCache:GetSkillPrefabFromCache("ThievesPuSkill", thievesTarget, function(obj)
        UISound.play("thievesgun")
        if ModelList.BattleModel:IsRocket() then
            fun.set_gameobject_scale(obj, 1, 1, 1)
        end

        if bingoView and fun.is_not_null(bingoView.PuSkillRoot) then
            obj.transform.parent = bingoView.PuSkillRoot.transform
        end
        
        coroutine.start(function()
            coroutine.wait(1.4)
            curModel:RefreshSignLogicDelayTime()
            cardView:ReduceLockTiers(cardId, thievesPos)
        end)
    end, 3)
    
end

return this