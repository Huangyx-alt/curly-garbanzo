local BaseSingleCard = require("Combat.Common.View.BaseSingleCardView")
local MoleMinerSingleCardView = BaseSingleCard:New()
local this = MoleMinerSingleCardView

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

    "ef_Bingo_click",
    "gift_clone",
    "flash_clone",
    "CanvasGroup",
}

local itemNames = {"LTRxiaditu", "LTRxiasyc", "LTRxiamati", "LTRxiayandou"}

function MoleMinerSingleCardView:OnEnable(params)

end

function MoleMinerSingleCardView:OnDisable()

end

function MoleMinerSingleCardView:on_after_bind_ref()
    local curModel = ModelList.BattleModel:GetCurrModel()
    local collectLevel = curModel:GetCurrentCollectLevel()
    for i, v in ipairs(itemNames) do
        if fun.is_not_null(self[v]) then
            local go = self[v].gameObject
            if fun.is_not_null(go) then
                local ref = fun.get_component(go, fun.REFER)
                if fun.is_not_null(ref) then
                    local icon = ref:Get("di")
                    if fun.is_not_null(icon) then
                        local iconImg = fun.get_component(icon, fun.IMAGE)
                        if fun.is_not_null(iconImg) then
                            local imgName = curModel:GetMineralImageNameByIdxAndLevel(i, collectLevel)
                            iconImg.sprite = AtlasManager:GetSpriteByName("MoleMinerBingoAtlas", imgName)
                        end
                    end
                end
            end
        end
    end
end

function MoleMinerSingleCardView:BindObj(obj, parentView)
    self:on_init(obj, parentView)
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local curModel = ModelList.BattleModel:GetCurrModel()
    local collectLevel = curModel:GetCurrentCollectLevel()
    self.treasure1Text.text = string.format("0/%s", Csv.GetCollectiveMaxCount(1, playid, collectLevel))
    self.treasure2Text.text = string.format("0/%s", Csv.GetCollectiveMaxCount(2, playid, collectLevel))
    self.treasure3Text.text = string.format("0/%s", Csv.GetCollectiveMaxCount(3, playid, collectLevel))
    self.treasure4Text.text = string.format("0/%s", Csv.GetCollectiveMaxCount(4, playid, collectLevel))
end

function MoleMinerSingleCardView:Clone(name)
    local o = { name = name }
    setmetatable(o, self)
    self.__index = self
    return o
end

local function GetBowlAnimaName(self, lastCount, addCount, obj, cardId, bowlType)
    local state = 0
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local curModel = ModelList.BattleModel:GetCurrModel()
    local collectLevel = curModel:GetCurrentCollectLevel()
    local maxcount = Csv.GetCollectiveMaxCount(bowlType, playid, collectLevel)
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
    if 1 == state then
        obj:Play("over")
    else
        obj:Play("act", 0, 0)
    end
    self[string.format("treasure%sText", bowlType)].text = string.format("%s/%s", lastCount + addCount, maxcount)
    return state
end

function MoleMinerSingleCardView:AddBowlDrink(bowlTable, cardId, bowlType, addCount)
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
    elseif bowlType == 5 then
        local lastCount = bowlTable[cardId][1]
        bowlTable[cardId][bowlType] = bowlTable[cardId][1] + addCount
        local state = GetBowlAnimaName(self, lastCount, addCount, self.LTRxiaditu, cardId, bowlType)
        local lastCount = bowlTable[cardId][2]
        bowlTable[cardId][bowlType] = bowlTable[cardId][2] + addCount
        state = state + GetBowlAnimaName(self, lastCount, addCount, self.LTRxiasyc, cardId, bowlType)
        local lastCount = bowlTable[cardId][3]
        bowlTable[cardId][bowlType] = bowlTable[cardId][3] + addCount
        state = state + GetBowlAnimaName(self, lastCount, addCount, self.LTRxiamati, cardId, bowlType)
        local lastCount = bowlTable[cardId][4]
        bowlTable[cardId][bowlType] = bowlTable[cardId][5] + addCount
        state = state + GetBowlAnimaName(self, lastCount, addCount, self.LTRxiayandou, cardId, bowlType)
        return state
    end
end

function MoleMinerSingleCardView:ForbidCollider()
    if self.forbidCollide then
        fun.set_active(self.forbidCollide, true)
    end
end

return this