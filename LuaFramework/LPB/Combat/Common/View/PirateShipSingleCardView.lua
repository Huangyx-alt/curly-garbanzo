local BaseSingleCard = require("Combat.Common.View.BaseSingleCardView")

local PirateShipSingleCardView = BaseSingleCard:New();
local this = PirateShipSingleCardView;

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
    "autoFlag",
    "minigameProgress",
    "bg",
    "letter",
    "rewardCard",
    "shengzi1",
    "foodbg1",
    "foodbg2",
    "ef_Bingo_click",
    "flash_clone",
    "CanvasGroup",
    "CellPartContainer",
    "CellsRoot",
    "CellBgRoot",
    "TopShowRoot",
    "moveItemCtrl",
    "Collectitem1",
    "Collectitem2",
    "Collectitem3",
    "Collectitem4",
    "Collectitem5",
    "smallShip",
    "storehouse",
    "EffectRoot",
    "tishi_b",
    "tishi_i",
    "tishi_n",
    "tishi_g",
    "tishi_o",
}

function PirateShipSingleCardView:OnEnable(params)

end

function PirateShipSingleCardView:OnDisable()

end

function PirateShipSingleCardView:BindObj(obj, parentView, cardID)
    self:on_init(obj, parentView)
    
    coroutine.start(function()
        coroutine.wait(2)
        local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardID, 13)
        if self.moveItemCtrl and cellData then
            local target = cellData:GetCellReferScript("bg_tip").transform
            self.moveItemCtrl.transform.position = target.transform.position
        end
    end)
end

function PirateShipSingleCardView:Clone(name)
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
    end

    if ModelList.BattleModel:GetCurrModel():GetIsMaxBet() then
        obj:Play("MaxBetover")
    else
        obj:Play("over")
    end
    
    if bowlType >= 5 then
        fun.set_active(self.smallShip, false)
    else
        self:MoveSmallShip(obj)
    end
    
    return state
end

function PirateShipSingleCardView:AddBowlDrink(bowlTable, cardId, bowlType, addCount)
    local lastCount = bowlTable[cardId][bowlType]
    bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
    
    local key = "Collectitem" .. bowlType
    local anima = self[key]
    if fun.is_not_null(anima) then
        return GetBowlAnimaName(self, lastCount, addCount, anima, cardId, bowlType)
    end
end

function PirateShipSingleCardView:ForbidCollider()
    if self.forbidCollide then
        fun.set_active(self.forbidCollide, true)
    end
end

function PirateShipSingleCardView:MoveSmallShip(obj)
    if self.smallShip and obj then
        local targetPos = fun.get_gameobject_pos(obj, true)
        Anim.move_to_x(self.smallShip, targetPos.x, 0.2, function()
            coroutine.start(function()
                coroutine.wait(1)
                Anim.move_to_x(self.smallShip, targetPos.x + 40, 0.2, function()

                end)
            end)
        end)
    end
end

function PirateShipSingleCardView:ShowMaxBetEffect()
    for i = 1, 5 do
        if fun.is_not_null(self["Collectitem" .. i]) then
            local go = self["Collectitem" .. i].gameObject
            if fun.is_not_null(go) then
                --local ref = fun.get_component(go, fun.REFER)
                --if fun.is_not_null(ref) then
                --    local icon1 = ref:Get("di")
                --    local icon2 = ref:Get("di2")
                --    if fun.is_not_null(icon1) and fun.is_not_null(icon2) then
                --        local iconName1 = isMaxBet and "ExplorersBoxOpen5" or "ExplorersBoxOpen1"
                --        local iconName2 = isMaxBet and "ExplorersBox5" or "ExplorersBox1"
                --        icon1.sprite = AtlasManager:GetSpriteByName("PirateShipBingoAtlas", iconName1)
                --        icon2.sprite = AtlasManager:GetSpriteByName("PirateShipBingoAtlas", iconName2)
                --    end
                --end
                fun.play_animator(go, "MaxBet", true)
            end
        end
    end
end

return this