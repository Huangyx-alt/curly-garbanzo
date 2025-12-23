local BaseSingleCard = require("Combat.Common.View.BaseSingleCardView")
local ScratchWinnerSingleCardView = BaseSingleCard:New()
local this = ScratchWinnerSingleCardView

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
    "defaultItem",
}

function ScratchWinnerSingleCardView:OnEnable(params)

end

function ScratchWinnerSingleCardView:OnDisable()

end

function ScratchWinnerSingleCardView:on_after_bind_ref()
    local ref = fun.get_component(self.defaultItem, fun.REFER)
    local anim = ref:Get("anima")
    local mask = ref:Get("mask")
    anim:Play("item5idle")
    mask:Play("7_0")
end

function ScratchWinnerSingleCardView:ShowDiamondInitalProgress()
    local ref = fun.get_component(self.defaultItem, fun.REFER)
    local anim = ref:Get("anima")
    local mask = ref:Get("mask")
    anim:Play("item5enter")
    UISound.play("scratchwinnerscratch")
    LuaTimer:SetDelayFunction(1, function()
        mask:Play("7_1")
    end, nil, LuaTimer.TimerType.Battle)
end

function ScratchWinnerSingleCardView:BindObj(obj, parentView, cardId)
    self.cardId = cardId
    self:on_init(obj, parentView)
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local curModel = ModelList.BattleModel:GetCurrModel()
    local collectLevel = curModel:GetCurrentCollectLevel()
end

function ScratchWinnerSingleCardView:Clone(name)
    local o = { name = name }
    setmetatable(o, self)
    self.__index = self
    return o
end

local function GetBowlAnimaName(self, lastCount, addCount, cardId, bowlType, cellIndex)
    local state = 0
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local curModel = ModelList.BattleModel:GetCurrModel()
    local collectLevel = curModel:GetCurrentCollectLevel()
    --local maxcount = Csv.GetCollectiveMaxCount(bowlType, playid, collectLevel)
    local maxcount = Csv.GetCollectiveMaxCount(bowlType)
    if lastCount >= maxcount then
        return
    end
    if lastCount + addCount > maxcount then
        addCount = maxcount - lastCount
    end
    
    if lastCount + addCount >= maxcount then
        state = 1
        BattleEffectCache:GetSkillPrefabFromCache("ScratchWinnerEmpty", self.storehouse, nil, 2.5, cardId)
        LuaTimer:SetDelayFunction(2, function()
            CalculateBingoMachine.OnDataChange(cardId, 0, bowlType, addCount)
            CalculateBingoMachine.CalcuateBingo(cardId, cellIndex)
        end, false, LuaTimer.TimerType.Battle)
    else
        CalculateBingoMachine.OnDataChange(cardId, 0, bowlType, addCount)
    end

    return state
end

function ScratchWinnerSingleCardView:AddBowlDrink(bowlTable, cardId, bowlType, addCount, cellIndex)
    ---[[
    if bowlType >= 1 and bowlType <= 5 then
        local lastCount = bowlTable[cardId][bowlType]
        bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
        return GetBowlAnimaName(self, lastCount, addCount, cardId, bowlType, cellIndex)
    end
    --]]
end

function ScratchWinnerSingleCardView:ForbidCollider()
    if self.forbidCollide then
        fun.set_active(self.forbidCollide, true)
    end
end

function ScratchWinnerSingleCardView:GetDefaultItem()
    return self.defaultItem
end

return this