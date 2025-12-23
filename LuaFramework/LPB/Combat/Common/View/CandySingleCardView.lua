local BaseSingleCard = require("Combat.Common.View.BaseSingleCardView")

local CandySingleCardView = BaseSingleCard:New();
local this = CandySingleCardView;

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
    "LTRxiamati",
    "LTRxiasyc",
    "LTRxiaditu",
    "LTRxiayandou",
    "forbidCollide",
    "autoFlag",
    "treasure1Text",
    "treasure2Text",
    "treasure3Text",
    "treasure4Text",
    "storehouse",
    "signcellJBroot",
    "flyItemRoot",

    "ef_Bingo_click",
    "gift_clone",
    "flash_clone",
    "CanvasGroup",
}

function CandySingleCardView:OnEnable(params)

end

function CandySingleCardView:OnDisable()

end

function CandySingleCardView:BindObj(obj, parentView)
    self:on_init(obj, parentView)
    --local playid = ModelList.CityModel.GetPlayIdByCity()
    --self.treasure1Text.text = string.format("0/%s", Csv.GetCollectiveMaxCount(1, playid))
    --self.treasure2Text.text = string.format("0/%s", Csv.GetCollectiveMaxCount(2, playid))
    --self.treasure3Text.text = string.format("0/%s", Csv.GetCollectiveMaxCount(3, playid))
    --self.treasure4Text.text = string.format("0/%s", Csv.GetCollectiveMaxCount(4, playid))
end

function CandySingleCardView:Clone(name)
    local o = { name = name }
    setmetatable(o, self)
    self.__index = self
    return o
end

local function GetBowlAnimaName(self, lastCount, addCount, obj, cardId, bowlType)
    local state = 0
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local maxcount = Csv.GetCollectiveMaxCount(bowlType, playid)
    if lastCount >= maxcount then
        return
    end
    if lastCount + addCount > maxcount then
        addCount = maxcount - lastCount
    end
    --CalculateBingoMachine.OnDataChange(cardId, 0, bowlType, addCount)
    --if lastCount + addCount >= maxcount then
    --    state = 1
    --    CalculateBingoMachine.CalcuateBingo(cardId)
    --end
    --if 1 == state then
        obj:Play("over")
    --else
    --    obj:Play("act", 0, 0)
    --end
    --self[string.format("treasure%sText", bowlType)].text = string.format("%s/%s", lastCount + addCount, maxcount)
    return state
end

function CandySingleCardView:AddBowlDrink(bowlTable, cardId, bowlType, addCount)
    if bowlType == 1 then
        local lastCount = bowlTable[cardId][bowlType]
        bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
        return GetBowlAnimaName(self, lastCount, addCount, self.LTRxiaditu, cardId, bowlType)
    elseif bowlType == 2 then
        local lastCount = bowlTable[cardId][bowlType]
        bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
        return GetBowlAnimaName(self, lastCount, addCount, self.LTRxiasyc, cardId, bowlType)
    elseif bowlType == 3 then
        local lastCount = bowlTable[cardId][bowlType]
        bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
        return GetBowlAnimaName(self, lastCount, addCount, self.LTRxiamati, cardId, bowlType)
    elseif bowlType == 4 then
        local lastCount = bowlTable[cardId][bowlType]
        bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
        return GetBowlAnimaName(self, lastCount, addCount, self.LTRxiayandou, cardId, bowlType)
    end
end

function CandySingleCardView:ForbidCollider()
    if self.forbidCollide then
        fun.set_active(self.forbidCollide, true)
    end
end

return this