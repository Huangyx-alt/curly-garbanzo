local BaseSingleCard = require("Combat.Common.View.BaseSingleCardView")
local GoldenTrainSingleCardView = BaseSingleCard:New()
local this = GoldenTrainSingleCardView

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

function GoldenTrainSingleCardView:OnEnable(params)
end

function GoldenTrainSingleCardView:OnDisable()
end

function GoldenTrainSingleCardView:on_after_bind_ref()
    local ref = fun.get_component(self.defaultItem, fun.REFER)
    local anim = ref:Get("anima")
    
    local text_reward = ref:Get("text_reward")
    text_reward.text = ModelList.BattleModel:GetCurrModel():GetDefaultReward()
    -- anim:Play("item5idle")
    -- mask:Play("7_0")
end

function GoldenTrainSingleCardView:ShowTrainInitalAnima()
    local ref = fun.get_component(self.defaultItem, fun.REFER)
    local anim = ref:Get("anima")
    anim:Play("enter")
    UISound.play("goldentrainwhistle")
end

function GoldenTrainSingleCardView:BindObj(obj, parentView)
    self:on_init(obj, parentView)
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local curModel = ModelList.BattleModel:GetCurrModel()
    local collectLevel = curModel:GetCurrentCollectLevel()
end

function GoldenTrainSingleCardView:Clone(name)
    local o = { name = name }
    setmetatable(o, self)
    self.__index = self
    return o
end

function GoldenTrainSingleCardView:OnCollectItem(cardId, cellIdx)
    CalculateBingoMachine.OnDataChange(cardId, cellIdx)
    CalculateBingoMachine.CalcuateBingo(cardId, cellIdx)
end

function GoldenTrainSingleCardView:ForbidCollider()
    if self.forbidCollide then
        fun.set_active(self.forbidCollide, true)
    end
end

function GoldenTrainSingleCardView:GetDefaultItem()
    return self.defaultItem
end

function GoldenTrainSingleCardView:ShowShakeAnima()
    self.b_letter:Play("pick")
end

return this