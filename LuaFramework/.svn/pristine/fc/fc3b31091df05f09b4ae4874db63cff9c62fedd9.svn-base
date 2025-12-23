local BaseSingleCard = require("Combat.Common.View.BaseSingleCardView")
local BisonSingleCardView = BaseSingleCard:New()
local this = BisonSingleCardView

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

function BisonSingleCardView:OnEnable(params)

end

function BisonSingleCardView:OnDisable()

end

--[[function BisonSingleCardView:on_after_bind_ref()
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
                            iconImg.sprite = AtlasManager:GetSpriteByName("BisonBingoAtlas", imgName)
                        end
                    end
                end
            end
        end
    end
end--]]

--[[function BisonSingleCardView:BindObj(obj, parentView)
    self:on_init(obj, parentView)
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local curModel = ModelList.BattleModel:GetCurrModel()
    local collectLevel = curModel:GetCurrentCollectLevel()

    self.treasure1Text.text = string.format("0/%s", Csv.GetCollectiveMaxCount(1, playid, collectLevel))
    self.treasure2Text.text = string.format("0/%s", Csv.GetCollectiveMaxCount(2, playid, collectLevel))
    self.treasure3Text.text = string.format("0/%s", Csv.GetCollectiveMaxCount(3, playid, collectLevel))
    self.treasure4Text.text = string.format("0/%s", Csv.GetCollectiveMaxCount(4, playid, collectLevel))
end--]]

function BisonSingleCardView:Clone(name)
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
    local maxcount = curModel:GetCollectiveMaxCount(bowlType, collectLevel)
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
    --self[string.format("treasure%sText", bowlType)].text = string.format("%s/%s", lastCount + addCount, maxcount)
    return state
end

--bowltype 由原id变成了序号
function BisonSingleCardView:AddBowlDrink(bowlTable, cardId, bowlType, addCount)
    local lastCount = bowlTable[cardId][bowlType]
    bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
    local anim = self[itemNames[bowlType]]
    if fun.is_not_null((anim)) then
        GetBowlAnimaName(self, lastCount, addCount, anim, cardId, bowlType)
    end
end

function BisonSingleCardView:ForbidCollider()
    if self.forbidCollide then
        fun.set_active(self.forbidCollide, true)
    end
end

return this