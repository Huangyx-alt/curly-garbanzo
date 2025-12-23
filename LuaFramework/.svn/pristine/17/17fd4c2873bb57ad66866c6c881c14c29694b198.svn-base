local BaseSingleCard = require("Combat.Common.View.BaseSingleCardView")
local GotYouSingleCardView = BaseSingleCard:New()
local this = GotYouSingleCardView

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
    "GotYou_item1",
    "GotYou_item2",
    "GotYou_item3",
    "GotYouWolfweiba",
    "GotYouWolf",
}

local itemNames = {"GotYou_item1", "GotYou_item2", "GotYou_item3"}
local maxCollectCount = 5

function GotYouSingleCardView:OnEnable(params)
    self.targetObjList = nil
    self.progressRecord = nil
end

function GotYouSingleCardView:OnDisable()

end

function GotYouSingleCardView:InitAllCollectProgress()
    for i = 1, 3 do
        self:UpdateCollectProgress(i, 0)
    end
end

function GotYouSingleCardView:UpdateCollectProgress(idx, collectNum)
    self.progressRecord = self.progressRecord or {}
    if not self.progressRecord[idx] then
        self.progressRecord[idx] = collectNum
    elseif self.progressRecord[idx] < collectNum then
        self.progressRecord[idx] = collectNum
    else
        log.log("GotYouSingleCardView:UpdateCollectProgress error idx, collectNum is ", idx, collectNum, self.progressRecord[idx])
        return
    end
    local obj = self["GotYou_item" .. idx]
    local ref = fun.get_component(obj, fun.REFER)
    if fun.is_not_null(ref) then
        local progress = ref:Get("progress")
        progress.text = collectNum .. "/" .. maxCollectCount
    end
end

function GotYouSingleCardView:ShowCollectEnter()
    for idx = 1, 3 do
        local obj = self["GotYou_item" .. idx]
        local ref = fun.get_component(obj, fun.REFER)
        if fun.is_not_null(ref) then
            local anima = ref:Get("anima")
            anima:Play("ruchang")
        end
    end
end

function GotYouSingleCardView:on_after_bind_ref()
    fun.set_active(self.GotYouWolf, false)
    fun.set_active(self.GotYouWolfweiba, true)
    self.wolfAnima = fun.get_component(self.GotYouWolf, fun.ANIMATOR)
    self.wolfTailAnima = fun.get_component(self.GotYouWolfweiba, fun.ANIMATOR)
end

function GotYouSingleCardView:BindObj(obj, parentView, cardId)
    self.cardId = cardId
    self:on_init(obj, parentView)

    self:InitAllCollectProgress()
    self:InitCellsColor()
    self.isReleasingWolfSkill = false
    self.wolfSkillFinishCallbackList = nil
end

function GotYouSingleCardView:ShowWolfEnter()
    fun.set_active(self.GotYouWolf, true)

    if fun.is_not_null(self.wolfTailAnima) then
        self.wolfTailAnima:Play("enter")
    end

    if fun.is_not_null(self.wolfAnima) then
        self.wolfAnima:Play("enter")
    end

    self:ShowCollectEnter()
end

function GotYouSingleCardView:HideWolf()
    fun.set_active(self.GotYouWolf, false)
    fun.set_active(self.GotYouWolfweiba, false)
end

function GotYouSingleCardView:ShowWolfAct()
    if fun.is_not_null(self.wolfAnima) then
        local stateInfo = self.wolfAnima:GetCurrentAnimatorStateInfo(0)
        if stateInfo:IsName("pu") then
        --if self.isReleasingWolfSkill then
            log.log("GotYouSingleCardView:ShowWolfAct 播放失败，正在释放pu")
        else
            self.wolfAnima:Play("act")
        end
    end
end

function GotYouSingleCardView:ShowWolfSkill(finishCallback)
    self.isReleasingWolfSkill = true
    self.wolfSkillFinishCallbackList = {}
    table.insert(self.wolfSkillFinishCallbackList, finishCallback)
    if fun.is_not_null(self.wolfAnima) then
        self.wolfAnima:Play("pu")
    end

    LuaTimer:SetDelayFunction(2.5, function()
        self:FinishWolfSkill()
    end, false, LuaTimer.TimerType.BattleUI)
end

function GotYouSingleCardView:ForceShowWolfSkill()
    if fun.is_not_null(self.wolfAnima) then
        self.wolfAnima:Play("pu", 0, 0)
    end
end

function GotYouSingleCardView:FinishWolfSkill()
    self.isReleasingWolfSkill = false
    for i, v in ipairs(self.wolfSkillFinishCallbackList) do
        v()
    end
    self.wolfSkillFinishCallbackList = nil
end

function GotYouSingleCardView:TryShowWolfSkill(extra)
    if extra.forceShow then
        self:ForceShowWolfSkill()
        return
    end

    if self.isReleasingWolfSkill then
        table.insert(self.wolfSkillFinishCallbackList, extra.finishCallback)
    else
        self:ShowWolfSkill(extra.finishCallback)
    end
end

function GotYouSingleCardView:TrySignCell(index, powerId)
    local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(self.cardId, index)
    if cellData:IsNotSign() then
        self:GetCardPower().cardView:OnClickCardIgnoreJudgeByIndex(self.cardId, index, powerId)
    end
    self:GetCardPower():ChangeCellState(self.cardId, index, self.CellState.Signed)
end

function GotYouSingleCardView:InitCellsColor()
    local curModel = ModelList.BattleModel:GetCurrModel()
    for i = 1, 25 do
        local color = curModel:GetCellColor(i)
        self:SetCellColor(i, color)
    end
end

function GotYouSingleCardView:SetCellColor(index, color)
    local cellObj = self:GetCell(index)
    local refer = fun.get_component(cellObj, fun.REFER)
    if fun.is_not_null(refer) then
        local bg_tip = refer:Get("bg_tip")
        local imgName = "pigbcard0" .. color
        bg_tip.sprite = AtlasManager:GetSpriteByName("GotYouBingoAtlas", imgName)
    end
end

function GotYouSingleCardView:Clone(name)
    local o = { name = name }
    setmetatable(o, self)
    self.__index = self
    return o
end

local function GetBowlAnimaName(self, lastCount, addCount, obj, cardId, bowlType, cellIndex)
    local state = 0
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local curModel = ModelList.BattleModel:GetCurrModel()
    
    if lastCount >= maxCollectCount then
        return
    end
    if lastCount + addCount > maxCollectCount then
        addCount = maxCollectCount - lastCount
    end
    --CalculateBingoMachine.OnDataChange(cardId, 0, bowlType, addCount)
    if lastCount + addCount >= maxCollectCount then
        state = 1
        --CalculateBingoMachine.CalcuateBingo(cardId, cellIndex)
    else
        CalculateBingoMachine.OnDataChange(cardId, 0, bowlType, addCount)
    end

    local ref = fun.get_component(obj, fun.REFER)
    if fun.is_not_null(ref) then
        local anima = ref:Get("anima")
        if 1 == state then
            anima:Play("over")
            ---[[
            BattleEffectCache:GetSkillPrefabFromCache("GotYouEmpty", obj, nil, 2, cardId)
            LuaTimer:SetDelayFunction(2, function()
                CalculateBingoMachine.OnDataChange(cardId, 0, bowlType, addCount)
                CalculateBingoMachine.CalcuateBingo(cardId, cellIndex)
                self:LightenTarget(bowlType)
            end, nil, LuaTimer.TimerType.Battle)
            --]]
        elseif lastCount > 0 then
            anima:Play("act", 0, 0)
        else
            anima:Play("act1", 0, 0)
        end
    end
    local flyTime = self:GetFlyTime(bowlType)
    LuaTimer:SetDelayFunction(flyTime, function()
        self:UpdateCollectProgress(bowlType, lastCount + addCount)
        self:ShowWolfAct()
        --UISound.play("gotyouadd")
    end, nil, LuaTimer.TimerType.Battle)

    return state
end

function GotYouSingleCardView:GetFlyTime(bowlType)
    if bowlType == 3 then
        return 1.9
    elseif bowlType == 2 then
        return 1.6
    else
        return  1.3
    end
end

function GotYouSingleCardView:AddBowlDrink(bowlTable, cardId, bowlType, addCount, cellIndex, flyObj)
    self:RecordCollectTarget(bowlType, flyObj)
    if bowlType == 1 then
        local lastCount = bowlTable[cardId][bowlType]
        bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
        return GetBowlAnimaName(self, lastCount, addCount, self.GotYou_item1, cardId, bowlType, cellIndex)
    elseif bowlType == 2 then
        local lastCount = bowlTable[cardId][bowlType]
        bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
        return GetBowlAnimaName(self, lastCount, addCount, self.GotYou_item2, cardId, bowlType, cellIndex)
    else
        local lastCount = bowlTable[cardId][bowlType]
        bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
        return GetBowlAnimaName(self, lastCount, addCount, self.GotYou_item3, cardId, bowlType, cellIndex)
    end
end

function GotYouSingleCardView:RecordCollectTarget(bowlType, targetObj)
    self.targetObjList = self.targetObjList or {}
    self.targetObjList[bowlType] = self.targetObjList[bowlType] or {}
    table.insert(self.targetObjList[bowlType], targetObj)
end

function GotYouSingleCardView:LightenTarget(bowlType)
    if not self.targetObjList then
        return
    end

    if not self.targetObjList[bowlType] then
        return
    end

    for i, v in ipairs(self.targetObjList[bowlType]) do
        local flyAnim = fun.get_component(v, fun.ANIMATOR)
        if fun.is_not_null(flyAnim) then
            flyAnim:Play("over")
        end
    end
end

function GotYouSingleCardView:ForbidCollider()
    if self.forbidCollide then
        fun.set_active(self.forbidCollide, true)
    end
end

return this