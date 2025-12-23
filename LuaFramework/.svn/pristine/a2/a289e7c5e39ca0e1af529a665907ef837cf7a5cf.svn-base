local BaseSingleCard = require("Combat.Common.View.BaseSingleCardView")
local HorseRacingSingleCardView = BaseSingleCard:New()
local this = HorseRacingSingleCardView

this.auto_bind_ui_items = {
    "B1",
    "B2",
    "B3",
    "B4",
    "B5",
    "I1",
    "I2",
    "I3",
    "I4",
    "I5",
    "N1",
    "N2",
    "N3",
    "N4",
    "N5",
    "G1",
    "G2",
    "G3",
    "G4",
    "G5",
    "O1",
    "O2",
    "O3",
    "O4",
    "O5",
    "b_letter",
    "reward1",
    "reward2",
    "reward_icon1",
    "rewardPar",
    "PerfectDaub",
    "letter_b",
    "letter_i",
    "letter_n",
    "letter_g",
    "letter_o",
    "icon",
    "ChipsContainer",
    "fooddz",
    "forbidCollide",
    "autoFlag",
    "storehouse",
    "signcellJBroot",
    "flash_clone",
    "gift_clone",
    "HorseRacing_item1",
    "HorseRacing_item2",
    "HorseRacing_item3",
    "HorseRacing_item4",
    "HorseRacing_item5",
    "track1",
    "track2",
    "track3",
    "track4",
    "track5",
}

local itemNames = {"HorseRacing_item1", "HorseRacing_item2", "HorseRacing_item3", "HorseRacing_item4", "HorseRacing_item5"}

function HorseRacingSingleCardView:OnEnable(params)

end

function HorseRacingSingleCardView:OnDisable()

end

function HorseRacingSingleCardView:InitTrace(idx, isHighLevel)
    fun.set_active(self["track" .. idx], isHighLevel)
end

function HorseRacingSingleCardView:InitAllStables()
    local curModel = ModelList.BattleModel:GetCurrModel()
    for i = 1, 5 do
        local collectLevel = curModel:GetCollectLevelByCardIdAndTrackIdx(self.cardId, i)
        self:InitStable(i, collectLevel == 1)
    end
end

function HorseRacingSingleCardView:InitAllTraces()
    local curModel = ModelList.BattleModel:GetCurrModel()
    local map = curModel:GetCollectLevelMapByCardId(self.cardId)
    for i = 1, 5 do
        self:InitTrace(i,  map[i] == 1)
    end
end

function HorseRacingSingleCardView:InitAllTraceProgress()
    for i = 1, 5 do
        self:UpdateTraceProgress(i, 0)
    end
end

function HorseRacingSingleCardView:InitStable(idx, isHighLevel)
    local obj = self["HorseRacing_item" .. idx]
    local ref = fun.get_component(obj, fun.REFER)
    local Door = ref:Get("Door")
    local Door01 = ref:Get("Door01")
    local Door02 = ref:Get("Door02")
    local dengBg = ref:Get("deng")
    local jiantouglow = ref:Get("jiantouglow")
    fun.set_active(jiantouglow, false)
    if isHighLevel then
        Door.sprite = AtlasManager:GetSpriteByName("HorseRacingBingoAtlas", "FlatCardFjDi02")
        Door01.sprite = AtlasManager:GetSpriteByName("HorseRacingBingoAtlas", "FlatCardYellowDoor01")
        Door02.sprite = AtlasManager:GetSpriteByName("HorseRacingBingoAtlas", "FlatCardYellowDoor02")
        dengBg.sprite = AtlasManager:GetSpriteByName("HorseRacingBingoAtlas", "FlatCardJD03")
        obj:Play("idle_da")
    else
        Door.sprite = AtlasManager:GetSpriteByName("HorseRacingBingoAtlas", "FlatCardFjDi01")
        Door01.sprite = AtlasManager:GetSpriteByName("HorseRacingBingoAtlas", "FlatCardGreenDoor01")
        Door02.sprite = AtlasManager:GetSpriteByName("HorseRacingBingoAtlas", "FlatCardGreenDoor02")
        dengBg.sprite = AtlasManager:GetSpriteByName("HorseRacingBingoAtlas", "FlatCardJD00")
        obj:Play("idle")
    end

    for i = 1, 5 do
        local deng = ref:Get("FlatCardJD0" .. i)
        if isHighLevel then
            --undo 这里可能要换灯的颜色
            deng.sprite = AtlasManager:GetSpriteByName("HorseRacingBingoAtlas", "FlatCardJD02")
        else
            deng.sprite = AtlasManager:GetSpriteByName("HorseRacingBingoAtlas", "FlatCardJD02")
        end
    end
end

function HorseRacingSingleCardView:UpdateTraceProgress(idx, collectNum)
    local obj = self["HorseRacing_item" .. idx]
    local ref = fun.get_component(obj, fun.REFER)
    for i = 1, 5 do
        local deng = ref:Get("FlatCardJD0" .. i)
        fun.set_active(deng, collectNum >= i)
    end
end

function HorseRacingSingleCardView:on_after_bind_ref()

end

function HorseRacingSingleCardView:BindObj(obj, parentView, cardId)
    self.cardId = cardId
    self:on_init(obj, parentView)
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local curModel = ModelList.BattleModel:GetCurrModel()
    local collectLevel = curModel:GetCurrentCollectLevel()

    self:InitAllStables()
    self:InitAllTraces()
    self:InitAllTraceProgress()
end

function HorseRacingSingleCardView:Clone(name)
    local o = { name = name }
    setmetatable(o, self)
    self.__index = self
    return o
end

local function GetBowlAnimaName(self, lastCount, addCount, obj, cardId, bowlType, cellIndex)
    local state = 0
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local curModel = ModelList.BattleModel:GetCurrModel()
    local collectLevel = curModel:GetCurrentCollectLevel()
    local maxcount = 5
    if lastCount >= maxcount then
        return
    end
    if lastCount + addCount > maxcount then
        addCount = maxcount - lastCount
    end
    --CalculateBingoMachine.OnDataChange(cardId, 0, bowlType, addCount)
    if lastCount + addCount >= maxcount then
        state = 1
        --CalculateBingoMachine.CalcuateBingo(cardId, cellIndex)
    else
        CalculateBingoMachine.OnDataChange(cardId, 0, bowlType, addCount)
    end

    local level = curModel:GetCollectLevelByCardIdAndTrackIdx(cardId, bowlType)
    if 1 == state then
        obj:Play("over")
        ---[[
        BattleEffectCache:GetSkillPrefabFromCache("HorseRacingEmpty", obj, nil, 2, cardId)
        LuaTimer:SetDelayFunction(2, function()
            CalculateBingoMachine.OnDataChange(cardId, 0, bowlType, addCount)
            CalculateBingoMachine.CalcuateBingo(cardId, cellIndex)
        end, nil, LuaTimer.TimerType.Battle)
        --]]
    elseif level == 1 then
        obj:Play("cat_da", 0, 0)
    else
        obj:Play("act", 0, 0)
    end

    local ref = fun.get_component(obj, fun.REFER)
    local jiantouglow = ref:Get("jiantouglow")
    fun.set_active(jiantouglow, (lastCount + addCount) == (maxcount - 1))

    self: UpdateTraceProgress(bowlType, lastCount + addCount)

    return state
end

function HorseRacingSingleCardView:AddBowlDrink(bowlTable, cardId, bowlType, addCount, cellIndex)
    if bowlType == 1 then
        local lastCount = bowlTable[cardId][bowlType]
        bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
        return GetBowlAnimaName(self, lastCount, addCount, self.HorseRacing_item1, cardId, bowlType, cellIndex)
    elseif bowlType == 2 then
        local lastCount = bowlTable[cardId][bowlType]
        bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
        return GetBowlAnimaName(self, lastCount, addCount, self.HorseRacing_item2, cardId, bowlType, cellIndex)
    elseif bowlType == 3 then
        local lastCount = bowlTable[cardId][bowlType]
        bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
        return GetBowlAnimaName(self, lastCount, addCount, self.HorseRacing_item3, cardId, bowlType, cellIndex)
    elseif bowlType == 4 then
        local lastCount = bowlTable[cardId][bowlType]
        bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
        return GetBowlAnimaName(self, lastCount, addCount, self.HorseRacing_item4, cardId, bowlType, cellIndex)
    elseif bowlType == 5 then
        local lastCount = bowlTable[cardId][bowlType]
        bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
        return GetBowlAnimaName(self, lastCount, addCount, self.HorseRacing_item5, cardId, bowlType, cellIndex)
    end
end

function HorseRacingSingleCardView:ForbidCollider()
    if self.forbidCollide then
        fun.set_active(self.forbidCollide, true)
    end
end

return this