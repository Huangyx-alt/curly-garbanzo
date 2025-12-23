local BaseSingleCard = require("Combat.Common.View.BaseSingleCardView")

local DragonFortuneSingleCardView = BaseSingleCard:New();
local this = DragonFortuneSingleCardView;

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
    "flyItemRoot",
    "gift_clone",
    "ef_Bingo_click",
    "flash_clone",
    "Collectitem1",
    "Collectitem2",
    "Collectitem3",
    "Collectitem4",
    "Collectitem5",
    "CanvasGroup",
}

function DragonFortuneSingleCardView:OnEnable(params)

end

function DragonFortuneSingleCardView:OnDisable()

end

function DragonFortuneSingleCardView:BindObj(obj, parentView)
    self:on_init(obj, parentView)
end

function DragonFortuneSingleCardView:Clone(name)
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

    CalculateBingoMachine.OnDataChange(cardId, 0, bowlType, addCount)
    if lastCount + addCount >= maxcount then
        state = 1
        CalculateBingoMachine.CalcuateBingo(cardId)
    end
    
    obj:Play("over")
    return state
end

function DragonFortuneSingleCardView:AddBowlDrink(bowlTable, cardId, bowlType, addCount)
    local lastCount = bowlTable[cardId][bowlType]
    bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
    
    local key = "Collectitem" .. bowlType
    local anima = self[key]
    if fun.is_not_null(anima) then
        return GetBowlAnimaName(self, lastCount, addCount, anima, cardId, bowlType)
    end
end

function DragonFortuneSingleCardView:ForbidCollider()
    if self.forbidCollide then
        fun.set_active(self.forbidCollide, true)
    end
end

return this