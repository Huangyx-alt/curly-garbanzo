require "State/Common/CommonState"

local SelectBattleConfigView = BaseView:New("SelectBattleConfigView","SettingAtlas")

local this = SelectBattleConfigView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
this.auto_bind_ui_items = {
    "btn_close",
    "btn_play",
    "btn_decrease_bet",
    "btn_increase_bet",
    "textPuzzleNum",
    "bingoCard",
    "btn_decrease_card",
    "btn_increase_card",
    "textCardNum",
    "textCoinCost",
    "textBetMul",
    "grayBetProgressBg",
    "line",
    "betProgress",
    "bingoWin",
    "btn_jackpot_info",
    "textMul4",
    "textMul3",
    "textMul2",
    "textMul1",
    "textPuzzleRewardNum",
    "textPlay",
    "textPlayLockTip",
    "btn_close_jackpot",
    "itemPrefab",
    "itemArea",
    "specialIcon",

}

local selectCardNumData =
{
    [1] = 1,
    [2] = 2,
    [3] = 4,
    --[4] = 6
}

local betBgSprite =
{
    [1] = "TkBet01",
    [2] = "TkBet02",
    [3] = "TkBet03",
    [4] = "TkBetDi",
}

local selectBetChangeType =
{
    Increase = 1 ,
    Decrease = 2 ,
}

local betColorType =
{
    Orange = 1,
    Green = 2,
    Blue = 3,
    Gray = 4,
}

local lineMaxLocalPoX = 415
local isOpenJackpot = false
local puzzleLinePosData = {} --拼图线位置
local betProgressData = {} --bet位置
local maxCreatPuzzleNum = 6 --最多6个拼图

local betData = nil
local chestView = require("View/PeripheralSystem/SelectBattleConfigView/SelectBattleConfigChestRewardsItem")
local cookieView = require("View/PeripheralSystem/SelectBattleConfigView/SelectBattleConfigCookieRewardsItem")
local tournamentView = require("View/PeripheralSystem/SelectBattleConfigView/SelectBattleConfigTournamentRewardsItem")
local piggySlotsTicketView = require("View/PeripheralSystem/SelectBattleConfigView/SelectBattleConfigMiniGamePiggySlotsRewardsItem")
local selectBattleConfigSeasonPassView = require("View/PeripheralSystem/SelectBattleConfigView/SelectBattleConfigSeasonPassRewardsItem")

function SelectBattleConfigView:GetSelectCardNum()
    return selectCardNumData[self.selectCardIndex]
end

function SelectBattleConfigView:Awake()
    self:on_init()
end

function SelectBattleConfigView:InitBeforeSelectData()
    local cardNum = ModelList.BetConfigModel.ReadSelectCardNum()
    for k ,v in pairs(selectCardNumData) do
        if v == cardNum then
            self.selectCardIndex = k --bingo卡数量
            break
        end
    end
end

function SelectBattleConfigView:InitBetData()
    betData = ModelList.BetConfigModel.GetUseBetConfig()
    log.log("bet问题内容 实际bet数据 " , betData)
end

function SelectBattleConfigView:GetBetNum()
    return GetTableLength(betData.curBet)
end

function SelectBattleConfigView:RefreshMiniGame()
    local sceneId = ModelList.CityModel:GetCity()
    local curPuzzleData = ModelList.NewPuzzleModel:GetScenePuzzlesData(sceneId)
    if curPuzzleData then
        self.textPuzzleNum.text = string.format("%s%s%s", curPuzzleData.collectNum,"/" , curPuzzleData.puzzleNum)
    else
        self.textPuzzleNum.text = ""
    end
end

function SelectBattleConfigView:OnEnable()
    Facade.RegisterView(self)
    self:InitBeforeSelectData()
    self:InitBetData()
    self:InitPuzzleConfig()
    ModelList.CityModel:SetCardNumber(selectCardNumData[self.selectCardIndex])
    self:SetBetPos(1)
    self:SetBetPos(2)
    self:SetBetPos(4)
    --self:SetBetPos(6)
    self:InitBetColor()
    self:InitBetOrder()
    self:BuildFsm()
    self:RefreshCost()
    self:RefreshBetProgress(false)
    self:RefreshBetOrder()
    self:RefreshSelectCard()
    local lastBet = ModelList.CityModel:GetBetValue()
    self:PlayBetColor(lastBet)
    self:RefreshPlayBtn(lastBet)
    self:RefreshCardButton()
    self:RefreshBetButton()
    self.textMul4.text = "X6"
    self.textMul3.text = "X4"
    self.textMul2.text = "X3"
    self.textMul1.text = "X2"
    self:RefreshMiniGame()
    self:InitRewardItem()
    self:RefreshSpecialIocn()
end

function SelectBattleConfigView:RefreshSpecialIocn()
    if fun.is_null(self.specialIcon) then
        return
    end
    local maxBet = self:GetBetNum()
    local curBet = ModelList.CityModel:GetBetValue()
    local betIndex = self:GetBetIndex(curBet)

    if not betIndex or betIndex >= maxBet then
        Util.SetUIImageGray(self.specialIcon, false)
    else
        Util.SetUIImageGray(self.specialIcon, true)
    end
end

function SelectBattleConfigView:GetPuzzleDataByCardNum(cardNum)
    local maxBet = self:GetBetNum()
    local data = self.puzzleConfig[cardNum][maxBet]
    local config = {}
    local puzzleNum = 0
    for i = 1 , GetTableLength(data) do
        if data[i] > puzzleNum then
            puzzleNum = data[i]
            config[puzzleNum] = i
        end
    end
    return puzzleNum, config , data
end

function SelectBattleConfigView:GetPuzzleNum(cardNum)
    local num = GetTableLength(puzzleLinePosData[cardNum])
    return num
end

function SelectBattleConfigView:SetBetPos(cardNum)
    local maxBet = self:GetBetNum()
    local puzzleNum , config , data = self:GetPuzzleDataByCardNum(cardNum)
    log.log("bet问题内容 计算开始 " , betData , "   \n   "  , config , "   \n   " , data)
    local betAverage = {}
    if puzzleNum == 0 then
        betAverage[1] = {}
        for i = 1 , maxBet do
            table.insert(betAverage[1] , i)
        end
        log.log("bet问题内容 计算拼图数量0：  ", betAverage)
    else
        local beforePuzzleBetIndex = 0
        local containBet = {}
        for i = 1 , puzzleNum + 1 do
            --根据拼图节点对bet分段
            betAverage[i] = betAverage[i] or {}
            if i <= puzzleNum then
                local puzzleBetIndex = config[i]
                for z = 1 , maxBet do
                    if puzzleBetIndex >  z and z > beforePuzzleBetIndex then
                        local num = GetTableLength(betAverage[i])
                        table.insert(betAverage[i] , z)
                        beforePuzzleBetIndex = z
                        containBet[z] = true
                    end
                end
            else
                for z = 1 , maxBet do
                    if not containBet[z] then
                        table.insert(betAverage[i] , z)
                    end
                end
            end
        end
    end
    
    betProgressData[cardNum] = {}
    local curDistanceNum = GetTableLength(betAverage)  --分段数量
    puzzleLinePosData[cardNum] = puzzleLinePosData[cardNum] or {}
    local curPuzzleNum = curDistanceNum - 1
    if curDistanceNum == 1 then  --分段有1个 没有拼图
        for i = 1 , maxBet do
            betProgressData[cardNum][1] = {fillValue  = 1 , distance = lineMaxLocalPoX}
        end
    else --分段大于等于2 有分段-1个拼图线展示
        local puzzleDistance = tonumber(string.format("%.1f",lineMaxLocalPoX / curDistanceNum))
        for i = 1 , curPuzzleNum do
            puzzleLinePosData[cardNum][i] = puzzleDistance * i
        end
        for k ,v in ipairs(betAverage) do
            local distanceContainBetNum = GetTableLength(v)
            if distanceContainBetNum> 0 then
                local num = 0
                for z ,w in ipairs(v) do
                    num = num + 1
                    if maxBet == 1 then
                        betProgressData[cardNum][w] = {fillValue = 1 , distance = lineMaxLocalPoX}
                    else
                        local betPos = 0
                        local betDistance = 0
                        if k == 1 then
                            betDistance = puzzleDistance / (distanceContainBetNum + 1)
                            betPos = betDistance * num + (k-1) * puzzleDistance
                            betProgressData[cardNum][w] = {fillValue  = betPos / lineMaxLocalPoX , distance = betPos}
                        else
                            if k == curDistanceNum then
                                --最后一段
                                if distanceContainBetNum == 1 then
                                    betProgressData[cardNum][w] = {fillValue  = 1 , distance = lineMaxLocalPoX}
                                else
                                    betDistance = puzzleDistance / (distanceContainBetNum -1 )
                                    betPos = betDistance * (num-1) + (k-1) * puzzleDistance
                                    betProgressData[cardNum][w] = {fillValue  = betPos / lineMaxLocalPoX , distance = betPos}
                                end
                            else
                                betDistance = puzzleDistance / distanceContainBetNum
                                betPos = betDistance * (num-1) + (k-1) * puzzleDistance
                                betProgressData[cardNum][w] = {fillValue  = betPos / lineMaxLocalPoX , distance = betPos}
                            end
                        end
                        --log.log("计算数值错误 e " , betPos , "  " ,  lineMaxLocalPoX)
                    end

                end  
            end
        end
    end
    log.log("bet问题内容 计算结束 拼图位置：    " ,  cardNum ,"  ", maxBet , "  " , puzzleLinePosData)
    log.log("bet问题内容 计算结束 bet位置：    " , cardNum  , "  " ,  maxBet, "  ",betProgressData)
end

function SelectBattleConfigView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("BetRateOperatedView", self, {
        BetRateOperatedOriginalState:New(),
        BetRateOperatedStiffState:New()
    })
    self._fsm:StartFsm("BetRateOperatedOriginalState")
end

function SelectBattleConfigView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function SelectBattleConfigView:OnDisable()
    Facade.RemoveView(self)
    isOpenJackpot = false
    self.betLineList = {}
    self.lastSelectCardNum = nil
    self.selectCardIndex = 1 --bingo卡数量
    self.puzzleConfig = {}
    self.betColorList = {}
    isOpenJackpot = false
    puzzleLinePosData = {}
    betProgressData = {}
    CommonState.DisposeFsm(self) 
end

function SelectBattleConfigView:InitBetOrder()
    self.betLineList = {}
    for i = 1 , maxCreatPuzzleNum do
        local grid = fun.get_instance(self.line, self.grayBetProgressBg)
        fun.set_active(grid, false)
        self.betLineList[i] = grid
        grid.transform.name = "betLine"..i
    end
end

function SelectBattleConfigView:InitBetColor()
    local maxBet = ModelList.CityModel:GetMaxRateOpen()
    local orangeBet = math.floor((maxBet + 2)/3)
    local greenBet = math.floor((maxBet + 1)/3)
    local blueBet = maxBet - orangeBet - greenBet
    local nextUnlockBet , nextUnlockLv = self:GetNextUnlockBet()
    
    self.betColorList = 
    {
        [betColorType.Orange] = {min = 1 , max = orangeBet},
        [betColorType.Green] = {min = orangeBet+1 , max = orangeBet + greenBet},
        [betColorType.Blue] = {min = orangeBet + greenBet + 1 , max = maxBet},
        [betColorType.Gray] = {min = nextUnlockBet or 0  , max = nextUnlockBet},
    }
    
    log.log("bet区分检查 bet配置 " ,maxBet   ,"   ", self.betColorList)
end

function SelectBattleConfigView:GetBetColor(bet)
    if self.betColorList[betColorType.Orange].min <= bet and bet <= self.betColorList[betColorType.Orange].max then
        return betColorType.Orange
    elseif self.betColorList[betColorType.Green].min <= bet and bet <= self.betColorList[betColorType.Green].max then
        return betColorType.Green
    elseif self.betColorList[betColorType.Blue].min <= bet and bet <= self.betColorList[betColorType.Blue].max then
        return betColorType.Blue
    else
        return betColorType.Gray
    end
end

function SelectBattleConfigView:PlayCardColor(isIncrease)
    if isIncrease then
        --+
        fun.play_animator(self.bingoWin, "card" , true)
    else
        fun.play_animator(self.bingoWin, "winNo" , true)
    end
end

function SelectBattleConfigView:PlayBetColor(lastBet)
    local curBet = ModelList.CityModel:GetBetValue()
    local curColorType = self:GetBetColor(curBet)
    local lastColorType = self:GetBetColor(lastBet)
    local animName = nil
    self.betProgress.sprite = AtlasManager:GetSpriteByName("SelectBattleAtlas", betBgSprite[curColorType])
    if curColorType > lastColorType then
        --升bet 档位颜色变高
        if lastColorType == betColorType.Orange then
            --橙色升级到绿色
            animName = "win2"
        elseif lastColorType == betColorType.Green then
            --绿色升级到蓝色
            animName = "win3"
        end
    elseif curColorType < lastColorType then
        --降bet，档位颜色变低
        if lastColorType == betColorType.Blue then
            --蓝色降级到绿色
            animName = "3_2"
        elseif lastColorType == betColorType.Green then
            --绿色降级到橙色
            animName = "2_1"
        end
    else
        if curColorType == betColorType.Orange then
            animName = "win1idle"
        elseif curColorType == betColorType.Green then
            animName = "win2idle"
        else
            animName = "win3idle"
        end        
    end
    
    if animName then
        fun.play_animator(self.bingoWin, animName , true)
    else
        log.log("选卡界面 bet动画 失败 " , lastBet , "  ", curBet , "  " , animName)
    end
end

function SelectBattleConfigView:PlayCardChangeAnim(cardNum)
    local clipName = "card" .. cardNum
    fun.play_animator(self.bingoCard,clipName,true)
    if not self.lastSelectCardNum then
        self.lastSelectCardNum = cardNum
    end
    self.lastSelectCardNum = cardNum
end

function SelectBattleConfigView:HideBetLin()
    for k ,v in pairs(self.betLineList) do
        fun.set_active(v, false)
    end
end

function SelectBattleConfigView:RefreshBetOrder(betChangeType)
    self:HideBetLin()
    local maxBet = self:GetBetNum()
    local curBet = ModelList.CityModel:GetBetValue()
    local betIndex = self:GetBetIndex(curBet)
    local cardNum = self:GetSelectCardNum()
    local config = self.puzzleConfig[cardNum][maxBet]
    local puzzleIconPos = self:GetPuzzleIconPos(config)
    local puzzleRewardNum = 0
    local puzzleNum = self:GetPuzzleNum(cardNum)
    local isLockBet = self:CheckIsNextUnlockBet(curBet)
    local isNormalGame = ModelList.BetConfigModel.CheckIsNormalGame()
    for i = 1 , puzzleNum do -----
        local grid = self.betLineList[i]
        if puzzleIconPos[i] then
            fun.set_active(grid, true)
            grid.transform.localPosition = Vector2.New(puzzleLinePosData[cardNum][i],0)
            local ref = fun.get_component(grid, fun.REFER)
            local textBetProgressPuzzle = ref:Get("textBetProgressPuzzle")
            local puzzle = ref:Get("puzzle")
            local ef = ref:Get("ef")
            fun.set_active(ef, false)
            fun.set_active(puzzle , isNormalGame)
            if isLockBet then
                puzzle.sprite = AtlasManager:GetSpriteByName("SelectBattleAtlas", "TkBetIcon04")
            else
                local colorType = self:GetBetColor(puzzleIconPos[i])
                if betIndex == puzzleIconPos[i] then
                    if betChangeType == selectBetChangeType.Increase and not isNormalGame then
                        fun.set_active(ef, true)
                    end
                    puzzleRewardNum = puzzleRewardNum + 1
                    puzzle.sprite = AtlasManager:GetSpriteByName("SelectBattleAtlas", "TkBetIcon0" .. colorType)
                elseif betIndex > puzzleIconPos[i] then
                    puzzleRewardNum = puzzleRewardNum + 1
                    puzzle.sprite = AtlasManager:GetSpriteByName("SelectBattleAtlas", "TkBetIcon0" .. colorType)
                else
                    puzzle.sprite = AtlasManager:GetSpriteByName("SelectBattleAtlas", "TkBetIcon04")
                end
            end
            textBetProgressPuzzle.text = i
        else
            fun.set_active(grid, false)
        end
    end

    local playId = ModelList.CityModel.GetPlayIdByCity()
    local isNormal = playId == PLAY_TYPE.PLAY_TYPE_NORMAL
    fun.set_active(self.textPuzzleRewardNum.transform.parent, isNormal)
    self.textPuzzleRewardNum.text = "x" ..puzzleRewardNum
end

function SelectBattleConfigView:GetPuzzleIconPos(config)
    local puzzleData = {}
    local signPuzzleNum = 0
    for k ,v in pairs(config) do
        if v > 0 and signPuzzleNum < v then
            signPuzzleNum = v
            puzzleData[v] = k
        end
    end
    return puzzleData
end

function SelectBattleConfigView:InitPuzzleConfig()
    self.puzzleConfig = ModelList.BetConfigModel.GetPuzzleConfig()
end

function SelectBattleConfigView:RefreshSelectCard()
    local cardNum = self:GetSelectCardNum()
    self.textCardNum.text = cardNum
    self:PlayCardChangeAnim(cardNum)
end

function SelectBattleConfigView:GetBetProgress(curBet, cardNum)
    if self:CheckIsNextUnlockBet(curBet) then
        --未解锁的
        return 1
    else
        --已经解锁的
        local betIndex = self:GetBetIndex(curBet)
        if betProgressData[cardNum] and betProgressData[cardNum][betIndex].fillValue then
            return betProgressData[cardNum][betIndex].fillValue
        end
        log.log("错误 缺少bet进度 " , curBet ,  betIndex , cardNum , betProgressData)
        return 0
    end
end

function SelectBattleConfigView:RefreshBetProgress(isAnim)
    local cardNum = self:GetSelectCardNum()
    local curBet = ModelList.CityModel:GetBetValue()
    local betProgress = self:GetBetProgress(curBet,cardNum)
    log.log("获取实际bet b " , cardNum ,"  " , curBet ,  "  " , betProgress)
    if isAnim then
        Anim.do_smooth_float_update(self.betProgress.fillAmount,betProgress,0.1,function(num)
            self.betProgress.fillAmount = num
        end,nil)
    else
        self.betProgress.fillAmount = betProgress
    end
end

function SelectBattleConfigView:RefreshCost()
    local curBet = ModelList.CityModel:GetBetValue()
    local cardNum = self:GetSelectCardNum()
    self.textBetMul.text = string.format("%s%s","x" , curBet )
    self.textCoinCost:RollByTime(curBet  * cardNum,0.5,function()
        UISound.stop("coin_fly")
    end)
end

function SelectBattleConfigView:on_close()
end

function SelectBattleConfigView:OnDestroy()
    betData = nil
end

function SelectBattleConfigView:OnIncreaseClick()
    local lastBet = ModelList.CityModel:GetBetValue()
    ModelList.CityModel:SetBetRateStep(1)
    local cardNum = self:GetSelectCardNum()
    ModelList.CityModel:SetAutoSignCost(cardNum , false)
    UISound.play("bet_1")
    local curBet = ModelList.CityModel:GetBetValue()
    local nextUnlockBet , nextUnlockLv = self:GetNextUnlockBet()
    if curBet == nextUnlockBet then
    else
        self:RefreshBetProgress(true)
    end
    log.log("选卡界面问题 bet后 in" , curBet)
    self:RefreshCost()
    self:RefreshBetOrder(selectBetChangeType.Increase)
    self:PlayBetColor(lastBet)
    self:GetBetColor(curBet)
    self:RefreshBetButton()
    self:RefreshPlayBtn(curBet)
    self:RefreshRewardItem()
    self:RefreshSpecialIocn()
end

function SelectBattleConfigView:RefreshPlayBtn(curBet)
    local nextUnlockBet , nextUnlockLv = self:GetNextUnlockBet()
    if nextUnlockBet and nextUnlockBet == curBet then
        --用的下个等级解锁的bet
        Util.SetUIImageGray(self.btn_play, true)
        fun.set_active(self.textPlayLockTip, true)
        fun.set_active(self.textPlay, false)
        self.textPlayLockTip.text = string.format("Unlock at lv.%s" , nextUnlockLv )
        fun.enable_button(self.btn_play , false)
    else
        Util.SetUIImageGray(self.btn_play, false)
        fun.set_active(self.textPlayLockTip, false)
        fun.set_active(self.textPlay, true)
        fun.enable_button(self.btn_play , true)
    end
end

function SelectBattleConfigView:OnDecreaseClick()
    local lastBet = ModelList.CityModel:GetBetValue()
    ModelList.CityModel:SetBetRateStep(-1)
    local nextUnlockBet , nextUnlockLv = self:GetNextUnlockBet()
    local cardNum = self:GetSelectCardNum()
    ModelList.CityModel:SetAutoSignCost(cardNum , false)
    UISound.play("bet_2")
    self:RefreshCost()
    if nextUnlockBet and nextUnlockBet == lastBet then
        --上次选择的bet是下一级未解锁bet 不刷新进度
    else
        self:RefreshBetProgress(true)
    end
    self:RefreshBetOrder(selectBetChangeType.Decrease)
    local curBet = ModelList.CityModel:GetBetValue()
    self:PlayBetColor(lastBet)
    self:GetBetColor(curBet)
    self:RefreshBetButton()
    self:RefreshPlayBtn(curBet)
    self:RefreshRewardItem()
    self:RefreshSpecialIocn()
end


function SelectBattleConfigView:OnMaximumClick()
end

function SelectBattleConfigView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI,self)
end

function SelectBattleConfigView:on_btn_jackpot_info_click()
    if not isOpenJackpot then
        isOpenJackpot = true
        fun.play_animator(self.btn_jackpot_info,"enter", true)
    else
        isOpenJackpot = false
        fun.play_animator(self.btn_jackpot_info,"end", true)
    end
end

function SelectBattleConfigView:on_btn_increase_bet_click()
    local curBet = ModelList.CityModel:GetBetValue()
    local maxBet = self:GetBetNum()
    local checkBet = maxBet
    local nextUnlockBet , nextUnlockLv = self:GetNextUnlockBet()
    if nextUnlockBet then
        checkBet = nextUnlockBet
    end
    if checkBet <= curBet then
        log.log("已达到最大bet" , maxBet)
        return
    end
    log.log("选卡界面问题 bet前 " , curBet)
    self._fsm:GetCurState():Operate(self._fsm, 1)
end


function SelectBattleConfigView:on_btn_decrease_bet_click()
    self._fsm:GetCurState():Operate(self._fsm, 2)
    SDK.decrease_bet(playId, self._betRate)
end

function SelectBattleConfigView:on_btn_decrease_card_click()
    if self.selectCardIndex <= 1 then
        return
    end
    self.selectCardIndex = self.selectCardIndex - 1
    ModelList.CityModel:SetCardNumber(selectCardNumData[self.selectCardIndex])
    self:PlayCardColor(false)
    self:RefreshCost()
    self:RefreshSelectCard()
    self:RefreshBetOrder()
    self:RefreshBetProgress(true)
    self:RefreshCardButton()
    local curBet = ModelList.CityModel:GetBetValue()
    self:RefreshPlayBtn(curBet)
    self:RefreshRewardItem()
end

function SelectBattleConfigView:on_btn_increase_card_click()
    local selectCardNum = GetTableLength(selectCardNumData)
    if self.selectCardIndex >= selectCardNum then
        return
    end
    self.selectCardIndex = self.selectCardIndex + 1
    ModelList.CityModel:SetCardNumber(selectCardNumData[self.selectCardIndex])
    self:PlayCardColor(true)
    self:RefreshCost()
    self:RefreshSelectCard()
    self:RefreshBetOrder()
    self:RefreshBetProgress(true)
    self:RefreshCardButton()
    local curBet = ModelList.CityModel:GetBetValue()
    self:RefreshPlayBtn(curBet)
    self:RefreshRewardItem()
end

function SelectBattleConfigView:RefreshCardButton()
    local selectCardNum = GetTableLength(selectCardNumData)
    log.log("检查卡片数量 " , selectCardNum  , "   " , self.selectCardIndex)
    if self.selectCardIndex == selectCardNum then
        fun.enable_button(self.btn_increase_card , false)
        Util.SetUIImageGray(self.btn_increase_card, true)
        fun.enable_button(self.btn_decrease_card , true)
        Util.SetUIImageGray(self.btn_decrease_card, false)
    elseif self.selectCardIndex == 1 then
        fun.enable_button(self.btn_increase_card , true)
        Util.SetUIImageGray(self.btn_increase_card, false)
        fun.enable_button(self.btn_decrease_card , false)
        Util.SetUIImageGray(self.btn_decrease_card, true)
    else
        fun.enable_button(self.btn_increase_card , true)
        Util.SetUIImageGray(self.btn_increase_card, false)
        fun.enable_button(self.btn_decrease_card , true)
        Util.SetUIImageGray(self.btn_decrease_card, false)
    end
end

function SelectBattleConfigView:GetNextUnlockBet()
    if betData and betData.nextBet and betData.nextBet[1] then
        return betData.nextBet[1] ,betData.nextBet[2]       
    end
    return nil
end

function SelectBattleConfigView:RefreshBetButton()
    local betRate = ModelList.CityModel:GetBetValue()
    local isLockBet = self:CheckIsNextUnlockBet(betRate)
    local curBet = self:GetBetIndex(betRate)
    local maxBet = self:GetBetNum()
    local checkBet = maxBet
    local nextUnlockBet , nextUnlockLv = self:GetNextUnlockBet()
    if nextUnlockBet then
        checkBet = nextUnlockBet
    end

    if isLockBet then
        fun.enable_button(self.btn_increase_bet , false)
        Util.SetUIImageGray(self.btn_increase_bet, true)
        fun.enable_button(self.btn_decrease_bet , true)
        Util.SetUIImageGray(self.btn_decrease_bet, false)
    elseif curBet == checkBet then
        fun.enable_button(self.btn_increase_bet , false)
        Util.SetUIImageGray(self.btn_increase_bet, true)
        fun.enable_button(self.btn_decrease_bet , true)
        Util.SetUIImageGray(self.btn_decrease_bet, false)
    elseif curBet == 1 then
        fun.enable_button(self.btn_increase_bet , true)
        Util.SetUIImageGray(self.btn_increase_bet, false)
        fun.enable_button(self.btn_decrease_bet , false)
        Util.SetUIImageGray(self.btn_decrease_bet, true)
    else
        fun.enable_button(self.btn_increase_bet , true)
        Util.SetUIImageGray(self.btn_increase_bet, false)
        fun.enable_button(self.btn_decrease_bet , true)
        Util.SetUIImageGray(self.btn_decrease_bet, false)
    end   
end

function SelectBattleConfigView:on_btn_play_click()
    local curBet = ModelList.CityModel:GetBetValue()
    local nextUnlockBet , nextUnlockLv = self:GetNextUnlockBet()
    if nextUnlockBet and nextUnlockBet == curBet then
        log.log("bet未解锁")
        return
    end
    
    local cardNum = self:GetSelectCardNum()
    local betIndex = self:GetBetIndex(curBet)
    local cost = curBet * cardNum
    Facade.SendNotification(NotifyName.ShopView.CheckCurrencyAvailable, 8008, RESOURCE_TYPE.RESOURCE_TYPE_COINS, cost, function()
        ModelList.BetConfigModel.SaveLastPlayCity()
        ModelList.BetConfigModel.SaveSelectBattleConfig(betIndex,cardNum)
        self:SendMsg2Server2EnterGame()
    end, nil, nil, SHOP_TYPE.SHOP_TYPE_CHIPS)
end

function SelectBattleConfigView:GetNextSceneName()
    local game_type = ModelList.BattleModel:GetGameCityPlayID()
    return Csv.GetData("city_play", game_type, "scenes_name")
end

function SelectBattleConfigView:SendMsg2Server2EnterGame()
    --local mode = ModelList.CityModel:GetEnterGameMode()
    --if mode == PLAY_TYPE.PLAY_TYPE_NORMAL then
        local CmdEnterBattle = require "Logic.Command.Battle.Enter.CmdEnterBattle"
        local cmd = CmdEnterBattle.New()
        cmd:Execute()
    --else
    --    ModelList.BattleModel:ReqEnterGame()
    --end
end

function SelectBattleConfigView:GetBetIndex(betRate)
    for k ,v in ipairs(betData.curBet) do
        if v == betRate then
            return k
        end
    end
    log.log("bet数据不一致 " , betRate , betData)
    return nil
end

function SelectBattleConfigView:CheckIsNextUnlockBet(betRate)
    if betData.nextBet and betData.nextBet[1] == betRate then
        return true
    end
    return false
end

function SelectBattleConfigView:on_btn_close_jackpot_click()
    isOpenJackpot = false
    fun.play_animator(self.btn_jackpot_info,"end", true)
end

function SelectBattleConfigView:InitRewardItem()
    local betRate = ModelList.CityModel:GetBetValue()
    self.rewardItemList = {}
    local cardNum = self:GetSelectCardNum()
    local betNum = self:GetBetNum()
    local betIndex = self:GetBetIndex(betRate)
    local rewardData = ModelList.BetConfigModel.GetItemRewardConfig(betRate,cardNum,betNum)
    for k ,v in pairs(rewardData) do    
        local go = fun.get_instance(self.itemPrefab,self.itemArea)
        local view = self:GetRewardItemView(k)
        local rewardItem = view:New()
        rewardItem:SetReward(k,rewardData[k],cardNum,betIndex)
        rewardItem:SkipLoadShow(go,true,nil)
        self.rewardItemList[k] = rewardItem
    end
end

function SelectBattleConfigView:RefreshRewardItem()
    local betRate = ModelList.CityModel:GetBetValue()
    local cardNum = self:GetSelectCardNum()
    local betNum = self:GetBetNum()
    local rewardData = ModelList.BetConfigModel.GetItemRewardConfig(betRate,cardNum,betNum)
    local cardNum = self:GetSelectCardNum()
    local betIndex = self:GetBetIndex(betRate)
    for k ,v in pairs(self.rewardItemList) do
        if rewardData[k] then
            self.rewardItemList[k]:RefreshItemData(rewardData[k] , cardNum,betIndex)
        end
    end
end

function SelectBattleConfigView:GetRewardItemView(rewardTypeIndex)
    if rewardTypeIndex == BingoBangEntry.selectBattleReward.Cheset then
        return chestView
    elseif rewardTypeIndex == BingoBangEntry.selectBattleReward.Cookie then
        return cookieView
    elseif rewardTypeIndex == BingoBangEntry.selectBattleReward.Tournament then
        return tournamentView
    elseif rewardTypeIndex == BingoBangEntry.selectBattleReward.PiggySlotsTicket then
        return piggySlotsTicketView
    elseif rewardTypeIndex == BingoBangEntry.selectBattleReward.SeasonPass then
        return selectBattleConfigSeasonPassView
    end
end

this.NotifyList = {
}

return this

