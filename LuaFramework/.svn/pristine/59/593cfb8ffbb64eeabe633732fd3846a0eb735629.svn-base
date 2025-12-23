local BaseSingleCard = require("Combat.Common.View.BaseSingleCardView")
local DrinkingFrenzySingleCardView = BaseSingleCard:New()
local this = DrinkingFrenzySingleCardView

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

    "ef_Bingo_click",
    "gift_clone",
    "flash_clone",
    "CanvasGroup",

    --增加
    "textGlass1",
    "textGlass2",
    "textGlass3",
    "textGlass4",

    "drinkingFrenzy_item1",
    "drinkingFrenzy_item2",
    "drinkingFrenzy_item3",
    "drinkingFrenzy_item4",

    "playerLeft",
    "playerRight",

    "extraBonusLeft",
    "extraBonusRight",

    "bingoTip1",
    "bingoTip2",
    "bingoTip3",
    "bingoTip4",
    "BeerExtra",
    "BeerExtrablue",

    "DrinkingFrenzyskill1pu",
    "DrinkingFrenzyskill1puTrail",
    "beerFlyTarget",
    "flyGlassParent",
    "EffectRoot",
    "TopShowRoot",

    "tishi_b",
    "tishi_i",
    "tishi_n",
    "tishi_g",
    "tishi_o",
}

local playerAnimNameList =
{
    act1 = "act1" ,
    act2 = "act2" ,
    idle = "idle" ,
    idle2 = "idle2" ,
    idle1_2 = "idle1_2" , --只有男角色有
    ruchang = "ruchang" ,
    win = "win" ,

}

local playerSide =
{
    ManLeft = 1,
    WomanRight = 2,
}


local playerAnimTime =
{
    [1] =
    {
        ["act1"] = 1.5,
        ["act2"] = 1.5,
        ["ruchang"] = 2,
        ["idle"] = 0.1,
        ["idle1_2"] = 0.1,
        ["idle2"] = 0.1,
        ["win"] = 1.5,
    },
    [2] =
    {
        ["act1"] = 1.5,
        ["act2"] = 1.5,
        ["ruchang"] = 1.8,
        ["idle"] = 0.1,
        ["idle2"] = 0.1,
        ["win"] = 1.5,
    },
}


function DrinkingFrenzySingleCardView:OnEnable(params)
end

function DrinkingFrenzySingleCardView:OnDisable()

end

function DrinkingFrenzySingleCardView:on_after_bind_ref()
    --self.isDrinking = {[1] = false, [2] = false}
    --self.isWin = {[1] = false,[2] = false}

    self.waitWomanPlayerAnim = {}
    self.lastWomanAnimIndex = nil
    self.isShowWomanAnim = false
    self.isFinishWomanAnim = false
    self.lastWomanBingoData = nil

    fun.set_active(self.extraBonusLeft, false)
    fun.set_active(self.extraBonusRight, false)

    self.playAnimCount = 0  --标识状态，用于连续触发多个bingo时做判断
    self.playerManLastAnimName = nil
end

function DrinkingFrenzySingleCardView:BindObj(obj, parentView)
    self:on_init(obj, parentView)
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local curModel = ModelList.BattleModel:GetCurrModel()
    --local collectLevel = curModel:GetCurrentCollectLevel()
    local leftGlassString = string.format("%d%s%d",0 , "/" , 4)
    local rightGlassString = string.format("%d%s%d",0 , "/" , 1)

    self.textGlass1.text = leftGlassString
    self.textGlass2.text = leftGlassString
    self.textGlass3.text = rightGlassString
    self.textGlass4.text = rightGlassString
    
    local parent = self.drinkingFrenzy_item1.transform.parent
    fun.set_parent(self.textGlass1, parent)
    fun.set_parent(self.textGlass2, parent)
    fun.set_parent(self.textGlass3, parent)
    fun.set_parent(self.textGlass4, parent)
end

function DrinkingFrenzySingleCardView:Clone(name)
    local o = { name = name }
    setmetatable(o, self)
    self.__index = self
    return o
end

local function GetSmallGlassCollectAnim(lastCount)
    if lastCount == 0 then
        return "0_1"
    elseif lastCount == 1 then
        return "1_2"
    elseif lastCount == 2 then
        return "2_3"
    elseif lastCount == 3 then
        return "3_4"
    else
        return nil
    end
end

local function GetBigGlassCollectAnim(lastCount)
    if lastCount == 0 then
        return "0_1"
    end
    return nil
end


local function GetBowlAnimaName(self, lastCount, addCount, obj, cardId,collectIndex, cb)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local collectData = curModel:GetCollectProgress(cardId,collectIndex)
    local maxCount = collectData[collectIndex].max

    if lastCount >= maxCount then
        return fun.SafeCall(cb)
    end

    local animName = nil
    UISound.play("drinkingbeerpour")
    if collectIndex == 1 or collectIndex == 2 then
        animName = GetSmallGlassCollectAnim(lastCount)
    else
        animName = GetBigGlassCollectAnim(lastCount)
    end
    curModel:AddCollectProgress(cardId,collectIndex,lastCount + addCount)

    if animName then
        obj:Play(animName)
    end

    self["textGlass" .. collectIndex].text = string.format("%d%s%d",lastCount + addCount , "/" , maxCount)
    log.log("数据有错误 before cardId " , cardId)
    log.log("数据有错误 before collectIndex" , collectIndex)
    log.log("数据有错误 before addCount" , addCount)
    --CalculateBingoMachine.OnDataChange(cardId, 0,false, collectIndex ,addCount)
    --CalculateBingoMachine.OnDataChange(cardId, collectIndex,false ,addCount)
    CalculateBingoMachine.OnDataChange(cardId, 0,false, collectIndex ,addCount)
    
    LuaTimer:SetDelayFunction(1.15, cb)
end

function DrinkingFrenzySingleCardView:GetPlayerObj(collectIndex)
    if collectIndex == 1 or collectIndex == 2 then
        return self.playerLeft
    else
        return self.playerRight
    end
end

function DrinkingFrenzySingleCardView:GetPlayerDrinkAnimName(collectIndex)
    if collectIndex == 1 or collectIndex == 3 then
        return playerAnimNameList.act1
    else
        return playerAnimNameList.act2
    end
end

function DrinkingFrenzySingleCardView:CheckSideFinishCollectBingo(cardId,collectIndex)
    local checkSideCollectIndex = nil
    local leftIndex = 1
    if collectIndex == 1 then
        checkSideCollectIndex = 2
        leftIndex = playerSide.ManLeft
    elseif collectIndex == 2 then
        checkSideCollectIndex = 1
        leftIndex = playerSide.ManLeft
    elseif collectIndex == 3 then
        checkSideCollectIndex = 4
        leftIndex = playerSide.WomanRight
    elseif collectIndex == 4 then
        checkSideCollectIndex = 3
        leftIndex = playerSide.WomanRight
    end
    local curModel = ModelList.BattleModel:GetCurrModel()
    local finishCollectSideBingo = curModel:CheckCollectFull(cardId,checkSideCollectIndex)
    return finishCollectSideBingo , leftIndex
end

function DrinkingFrenzySingleCardView:DealExtraBonus(finishCollectTip,playerIndex)
    if finishCollectTip then
        if playerIndex == playerSide.ManLeft then
            fun.set_active(self.extraBonusLeft, true)
        else
            fun.set_active(self.extraBonusRight, true)
            fun.set_active(self.drinkingFrenzy_item3, false)
            fun.set_active(self.drinkingFrenzy_item4, false)
        end
    end
end

function DrinkingFrenzySingleCardView:PlayerDrinkIdle(playerObj , collectIndex, cardId)
    local model = ModelList.BattleModel:GetCurrModel()
    if collectIndex == 1 or collectIndex == 2 then
        local currentCollectIndex , collectProgress = model:CheckCollectIndex(261001,cardId)
      
        if collectIndex == 1 then
            if currentCollectIndex == 1 then
                self:ShowPlayerAnim(cardId,playerSide.ManLeft,playerAnimNameList.idle,false)
            else
                self:ShowPlayerAnim(cardId,playerSide.ManLeft,playerAnimNameList.idle1_2,false)
            end
        else
            self:ShowPlayerAnim(cardId,playerSide.ManLeft,playerAnimNameList.idle2,false)
        end
    else
        local currentCollectIndex , collectProgress = model:CheckCollectIndex(261002,cardId)
        if currentCollectIndex == 3 then
            self:ShowPlayerAnim(cardId,playerSide.WomanRight,playerAnimNameList.idle,false)
        else
            self:ShowPlayerAnim(cardId,playerSide.WomanRight,playerAnimNameList.idle2,false)
        end
    end
end


function DrinkingFrenzySingleCardView:PlayerDrinkMan(collectIndex,isFinishCollectSideBingo,curIndexCollectFinish,playerIndex,cardId, cb)
    --if self.isWin[leftIndex] then
    --    log.log("喝酒状态变更 全部完成")
    --    return fun.SafeCall(cb)
    --end
    local curModel = ModelList.BattleModel:GetCurrModel()
    local delayTime = 0
    local playerObj = self:GetPlayerObj(collectIndex)
    --if not self.isDrinking[playerIndex] then
    --    self.isDrinking[playerIndex] = true
        local animName = self:GetPlayerDrinkAnimName(collectIndex)
        LuaTimer:SetDelayFunction(delayTime + 1, function()
            UISound.play("drinkingbeerdrink")
            self:ShowPlayerAnim(cardId,playerIndex,animName,true)
            LuaTimer:SetDelayFunction(1.5, function()
                --self.isDrinking[playerIndex] = false
                fun.SafeCall(cb)
            end, false, LuaTimer.TimerType.Battle)
        end, false, LuaTimer.TimerType.Battle)

        if isFinishCollectSideBingo and curIndexCollectFinish  then
            delayTime = delayTime + 2.5
        else
            LuaTimer:SetDelayFunction(delayTime + 2.5, function()
                self:PlayerDrinkIdle(playerObj , collectIndex,cardId)
            end, false, LuaTimer.TimerType.Battle)
            delayTime = delayTime + 2.5
        end
    --end

    if isFinishCollectSideBingo and curIndexCollectFinish then
        LuaTimer:SetDelayFunction(delayTime, function()
            --if not self.isWin[playerIndex] then
                UISound.play("drinkingmanwin")
                self:ShowPlayerAnim(cardId,playerIndex,playerAnimNameList.win,true)
            --end
            --self.isWin[playerIndex] = true
        end, false, LuaTimer.TimerType.Battle)
    end
end

function DrinkingFrenzySingleCardView:PlayerDrinkWoMan(collectIndex,isFinishCollectSideBingo,curIndexCollectFinish,playerIndex,cardId, cb)
    --if self.isWin[leftIndex] then
    --    log.log("喝酒状态变更 全部完成")
    --    return fun.SafeCall(cb)
    --end
    local curModel = ModelList.BattleModel:GetCurrModel()
    local delayTime = 0
    local playerObj = self:GetPlayerObj(collectIndex)
    --if not self.isDrinking[playerIndex] then
    --self.isDrinking[playerIndex] = true
    local animName = self:GetPlayerDrinkAnimName(collectIndex)
    LuaTimer:SetDelayFunction(delayTime + 1, function()
        UISound.play("drinkingbeerdrink")
        self:ShowPlayerAnim(cardId,playerIndex,animName,true)
        LuaTimer:SetDelayFunction(1.5, function()
            --self.isDrinking[playerIndex] = false
            fun.SafeCall(cb)
        end, false, LuaTimer.TimerType.Battle)
    end, false, LuaTimer.TimerType.Battle)

    if isFinishCollectSideBingo and curIndexCollectFinish  then
        delayTime = delayTime + 2.5
    else
        LuaTimer:SetDelayFunction(delayTime + 2.5, function()
            self:PlayerDrinkIdle(playerObj , collectIndex,cardId)
        end, false, LuaTimer.TimerType.Battle)
        delayTime = delayTime + 2.5
    end
    --end
    --
    --if isFinishCollectSideBingo and curIndexCollectFinish and not self.isWin[playerIndex] then
    --    LuaTimer:SetDelayFunction(delayTime, function()
    --        if not self.isWin[playerIndex] then
    --            if collectIndex <= 2 then
    --                UISound.play("drinkingmanwin")
    --            else
    --                UISound.play("drinkingwomanwin")
    --            end
    --            self:ShowPlayerAnim(cardId,playerIndex,playerAnimNameList.win,true)
    --            if curIndexCollectFinish and curModel.GetIsMaxBet() then
    --                self:DealExtraBonus(isFinishCollectSideBingo,playerIndex)
    --            end
    --        end
    --        self.isWin[playerIndex] = true
    --    end, false, LuaTimer.TimerType.Battle)
    --end
end

function DrinkingFrenzySingleCardView:CheckAfterAnim(cardId)
    self.playAnimCount = self.playAnimCount - 1
    log.r(string.format("[DrinkingFrenzyLog] cardId:%s, playAnimCount after:%s", cardId, self.playAnimCount))
    if self.playAnimCount <= 0 then
        CalculateBingoMachine.CalcuateBingo(cardId)
    end
end

function DrinkingFrenzySingleCardView:AddBowlDrink(itemId,bowlTable, cardId, bowlType, addCount)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local collectIndex,collectProgress, maxCount = curModel:CheckCollectIndex(itemId , cardId)
    log.log("喝酒进度 " ,itemId ,  collectIndex , collectProgress)
    if not bowlTable[cardId] then
        bowlTable[cardId] = {}
    end
    bowlTable[cardId][collectIndex] = collectProgress + addCount
    local targetUI = self["drinkingFrenzy_item" .. collectIndex]
    
    --local isToMax = maxCount and collectProgress + addCount >= maxCount
    local isToMax = true
    if isToMax then
        self.playAnimCount = self.playAnimCount + 1
        log.r(string.format("[DrinkingFrenzyLog] cardId:%s, playAnimCount before:%s", cardId, self.playAnimCount))
    end
    
    GetBowlAnimaName(self, collectProgress, addCount, targetUI, cardId,collectIndex, function()
        local curIndexCollectFinish = curModel:CheckCollectFull(cardId,collectIndex)
        local isFinishCollectSideBingo,leftIndex  = self:CheckSideFinishCollectBingo(cardId,collectIndex)
        if curModel:CheckIsBigGlass(itemId) then
            self:PlayerDrinkWoMan(collectIndex,isFinishCollectSideBingo,curIndexCollectFinish,leftIndex, cardId, function()
                if isToMax then
                    self:CheckAfterAnim(cardId)
                end
            end)
        else
            self:PlayerDrinkMan(collectIndex,isFinishCollectSideBingo,curIndexCollectFinish,leftIndex, cardId, function()
                if isToMax then
                    self:CheckAfterAnim(cardId)
                end
            end)
        end
    end)
end

function DrinkingFrenzySingleCardView:ForbidCollider()
    if self.forbidCollide then
        fun.set_active(self.forbidCollide, true)
    end
end

function DrinkingFrenzySingleCardView:GetFlyGlassTarget(itemId,cardId)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local collectIndex,collectProgress = curModel:GetReadyFlyIndex(itemId,cardId)
    local targetUI = self["drinkingFrenzy_item" .. collectIndex]
    return targetUI
end

function DrinkingFrenzySingleCardView:GetFlyItemParent()
    return self.flyGlassParent
end

function DrinkingFrenzySingleCardView:ShowExtraBonusEffect(cardId)
    fun.set_active(self.BeerExtra , true)
    fun.set_active(self.BeerExtra , false, 2)
    fun.set_active(self.BeerExtrablue, true)
    self:ShowRightPlayerEnterEffect(cardId)
    self:ShowLeftPlayerEnterEffect(cardId)
end

function DrinkingFrenzySingleCardView:ShowRightPlayerEnterEffect(cardId,isIdleContinue)
    local cardIndex = tonumber(cardId)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local collectIndex,collectProgress = curModel:CheckCollectIndex(261002 , cardIndex)
    if  isIdleContinue and collectIndex == 4 then
        return
    end
    self:ShowPlayerAnim(cardIndex,playerSide.WomanRight,playerAnimNameList.ruchang,false)
    LuaTimer:SetDelayFunction(2.1, function()
        --anima:Play("idle")
        self:ShowPlayerAnim(cardIndex,playerSide.WomanRight,playerAnimNameList.idle,false)
    end, false, LuaTimer.TimerType.Battle)
end

function DrinkingFrenzySingleCardView:ShowLeftPlayerEnterEffect(cardId)
    local cardIndex = tonumber(cardId)
    --local anima = fun.get_component(self.playerLeft, fun.ANIMATOR)
    --anima:Play("ruchang")

    self:ShowPlayerAnim(cardIndex , playerSide.ManLeft,playerAnimNameList.ruchang,false)

    LuaTimer:SetDelayFunction(2.1, function()
        --local curModel = ModelList.BattleModel:GetCurrModel()
        --local collectIndex,collectProgress = curModel:CheckCollectIndex(261001 , cardIndex)
        --self:PlayerDrinkIdle(self.playerLeft , collectIndex, cardIndex)
        --anima:Play("idle")
        self:ShowPlayerAnim(cardIndex,playerSide.ManLeft,playerAnimNameList.idle,false)
    end, false, LuaTimer.TimerType.Battle)
end

function DrinkingFrenzySingleCardView:ShowPlayerEnterEffect(cardId)
    self:ShowLeftPlayerEnterEffect(cardId)
    self:ShowRightPlayerEnterEffect(cardId)
end

function DrinkingFrenzySingleCardView:ShowPlayerAnim(cardId,playerIndex,animName,isFromBegin)
    if playerIndex == playerSide.ManLeft then
        if self.playerManLastAnimName == playerAnimNameList.win or self.playerManLastAnimName == animName then
            return
        end
        fun.play_animator(self.playerLeft , animName , isFromBegin)
        self.playerManLastAnimName = animName
    else
        log.log("女角色动画播放检查 添加 " , animName)
        if self.isFinishWomanAnim == true then
            log.log("女角色动画播放检查 动画已固定 结束", animName)
            return
        end

        local isIgnore = false
        if animName == playerAnimNameList.ruchang then
            self.lastWomanAnimIndex = self.lastWomanAnimIndex or 1
            for i = self.lastWomanAnimIndex , GetTableLength(self.waitWomanPlayerAnim) do
                if self.waitWomanPlayerAnim[i].animName == animName and self.waitWomanPlayerAnim[i].isFinish == false then
                    isIgnore = true
                    break
                end
            end
        end

        if isIgnore then
            log.log("女角色动画播放检查 忽略", animName , self.waitWomanPlayerAnim)
            return
        end

        table.insert(self.waitWomanPlayerAnim , {animName = animName , isFinish = false})
        if self.isShowWomanAnim then
            --正在播放其他动画
        else
            self.isShowWomanAnim = true
            self:ShowNextWomanPlayerAnim(cardId)
        end
    end
end

function DrinkingFrenzySingleCardView:ShowNextWomanPlayerAnim(cardId)
    self.waitWomanPlayerAnim = self.waitWomanPlayerAnim or {}
    local animName = nil
    local animIndex = nil
    local searchStartIndex = self.lastWomanAnimIndex or 1
    for i = searchStartIndex , GetTableLength(self.waitWomanPlayerAnim) do
        if  self.waitWomanPlayerAnim[i].isFinish == false then
            animIndex = i
            animName = self.waitWomanPlayerAnim[i].animName
            break
        end
    end

    if not animIndex or not  animName then
        self.lastWomanAnimIndex = animIndex
        self.isShowWomanAnim = false
        self:ShowFinishWoManAnim(cardId)
        return
    end
    self.isShowWomanAnim = true

    self.waitWomanPlayerAnim[animIndex].isFinish = true
    local animTime = 0
    if playerAnimTime[playerSide.WomanRight] and playerAnimTime[playerSide.WomanRight][animName] then
        animTime = playerAnimTime[playerSide.WomanRight][animName]
    else
        animTime = 0
        log.log("错误 缺少角色动画时间 " , playerSide.WomanRight , animName  )
    end
    log.log("女角色动画播放检查 替换播放 " , animName)

    fun.play_animator(self.playerRight , animName , true)
    LuaTimer:SetDelayFunction(animTime, function()
        self:ShowNextWomanPlayerAnim(cardId)
    end, false, LuaTimer.TimerType.Battle)
end

function DrinkingFrenzySingleCardView:ShowFinishWoManAnim(cardId)
    if self.isFinishWomanAnim == true then
        return
    end
    local curModel = ModelList.BattleModel:GetCurrModel()
    local progressData = curModel:GetCollectProgress(cardId)
    log.log("女角色动画播放检查 collectCheck a", progressData)
    local finishDrinkNum = 0
    for i = 3 , 4 do
        if progressData[i].progress >= progressData[i].max then
            finishDrinkNum = finishDrinkNum + 1
        end
    end
    local isBingoNumChange = false
    if not self.lastWomanBingoData then
        if finishDrinkNum > 0 then
            isBingoNumChange = true
        end
    else
        if self.lastWomanBingoData < finishDrinkNum then
            isBingoNumChange = true
        end
    end
    self.lastWomanBingoData = finishDrinkNum

    if isBingoNumChange then
        if finishDrinkNum == 0 then
            fun.play_animator(self.playerRight , playerAnimNameList.idle , true)
        elseif finishDrinkNum == 1 then
            fun.play_animator(self.playerRight , playerAnimNameList.idle2 , true)
        elseif finishDrinkNum == 2 then
            self.isFinishWomanAnim = true
            UISound.play("drinkingwomanwin")
            fun.play_animator(self.playerRight , playerAnimNameList.win , true)
            if  curModel:GetIsMaxBet() then
                self:DealExtraBonus(true,playerSide.WomanRight)
            end
        end
    end
end

function DrinkingFrenzySingleCardView:CheckAllAnimShowOver(cardId)
    return self.playAnimCount <= 0
end

function DrinkingFrenzySingleCardView:BeforeSwitchView()
    fun.set_parent(self.playerLeft, self.go)
    fun.set_parent(self.playerRight, self.go)
end

function DrinkingFrenzySingleCardView:AfterSwitchView()
    local parent = ModelList.BattleModel:GetCurrBattleView()
    fun.set_parent(self.playerLeft, parent)
    fun.set_parent(self.playerRight, parent)
    fun.set_parent(self.BeerExtra, parent)
end

return this