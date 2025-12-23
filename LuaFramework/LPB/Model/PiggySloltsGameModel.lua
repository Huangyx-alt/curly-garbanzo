local PiggySloltsGameModel = BaseModel:New("PiggySloltsGameModel")
local this = PiggySloltsGameModel

local useBingoCardIndex = 1
local cardMaxSpinNum = 6 --每张卡最多spin6次 

local colNum = 5 --横向5个
local rowNum = 3    --竖向 5个

local initElementData = nil --初始牌面数据
--协议数据
local gameId = nil   --小游戏id
local spinTimes = nil  --当前的spin次数，break后会重置
local totalWin = 0   --当前奖励，break后会重置
local spinSpend = nil  --spin消耗 ，第一次是免费，后面5次要花钻石
local spinElementData = nil --最新一次spin数据
local breakTimes = 0 --可以玩的回合数
local jackpotWinCoin = 0
local winList = nil
local breakRewardData = nil --break后具体小猪奖励数据
--协议数据

local piggyDataNow = {}      --所有合并猪数据最新
local piggyDataLast = {}      --所有合并猪数据上次spin
local isReqNextCard = false



function PiggySloltsGameModel:SetLoginData(data)
    -- _miniGameTicketsInfoList = {}
	isReqNextCard = false
    log.log("传输的测试数据" , data)
    -- if data and data.normalActivity
        -- and data.normalActivity.miniGameState then
        -- this.OnMiniGameUpdate(RET.RET_SUCCESS,{state = data.normalActivity.miniGameState})
    -- end
end


function PiggySloltsGameModel:IsActivityAvailable()
    if this.racingData then
        if this.racingData.isOver and  this.racingData.isOver == 1 then
            return false
        end

        local remainTime = self:GetActivityRemainTime()
        return remainTime > 0
    end
end

function PiggySloltsGameModel.GetCurrConfig()
    -- local dependentFile = require("View.DailyCompetition.CompetitionDependentFile")
    -- local info = dependentFile:GetDenpendentInfo()
    -- return info
end

function PiggySloltsGameModel.GetBigWinNum()
    return jackpotWinCoin
end

function PiggySloltsGameModel.GetResultElementData(reelIndex)
    if spinTimes and spinElementData and spinElementData[spinTimes] and spinElementData[spinTimes][reelIndex] then
        return spinElementData[spinTimes][reelIndex]
    end
    return {}
end

--设置初始牌面数据
function PiggySloltsGameModel.SetInitElement()
    initElementData = {}
    for col = 1 , colNum do
        for row = 1 , rowNum + 1 do
            if not initElementData[col] then
                initElementData[col] = {}
            end
            
            if not initElementData[col][row] then
                initElementData[col][row] = 
                {
                    elementId = math.random(PiggySlotsElementId.BlueSafeBox,PiggySlotsElementId.Gold)
                } 
                
            end
        end
    end
	log.log("设置初始牌面数据" , initElementData)
end

function PiggySloltsGameModel.GetInitSpinResult(reelIndex)
    return initElementData[reelIndex]
end


function PiggySloltsGameModel.GetUnlockBingoCard()
    return 2
end

function PiggySloltsGameModel.CheckCardSpinMax()
    if spinTimes and spinTimes >= cardMaxSpinNum then
        return true
    end
    return false
end

function PiggySloltsGameModel.GetSpinNumTip()
	local str = string.format("%s%s%s%s",spinTimes, "/" , cardMaxSpinNum , " SPINS")
	return str
end

function PiggySloltsGameModel.GetUseBingoCardIndex()
    return useBingoCardIndex
end

function PiggySloltsGameModel.GetUseBingoCardIndex(index)
    useBingoCardIndex = index
end

function PiggySloltsGameModel.GetMerageData()
end


function PiggySloltsGameModel.S2C_OnReceivePiggySlotsInfo(code, data)
    log.log("小猪机台 协议 5407", code, data)
    if code == RET.RET_SUCCESS and data then
        gameId = data.gameId
        spinTimes = data.spinTimes
        totalWin = data.totalWin
        spinSpend = data.slotsInfo.spinSpend
		jackpotWinCoin = data.slotsInfo.jackpotWinCoin
        spinElementData = nil
        breakTimes = data.breakTimes
		winList = data.slotsInfo.winList
        this.SetInitElement()
		if isReqNextCard then
			isReqNextCard = false
			piggyDataNow = nil
			piggyDataLast = {}
            log.log("小猪机台 数据清除 5407")
			Facade.SendNotification(NotifyName.PiggySlots.PiggySlotsFinishReqInfo, code)
		end
    else
        Facade.SendNotification(NotifyName.PiggySlots.PiggySlotsFinishReqInfo, code)
    end
end

function PiggySloltsGameModel.S2C_OnReceivePiggySlotsSpinResult(code, data)
    log.log("小猪机台 协议 5408", code, data)
    if code == RET.RET_SUCCESS and data then
        spinTimes = data.spinTimes
        totalWin = data.totalWin
        spinSpend = data.slotsInfo.spinSpend
        breakTimes = data.breakTimes
        this.SetFakeSpinResult(data.slotsInfo.elements)
        this.InitPiggyMerge()
        Facade.SendNotification(NotifyName.PiggySlots.PiggySlotsReqSpin, code)
    else
        Facade.SendNotification(NotifyName.PiggySlots.PiggySlotsReqSpin, code)
    end
end

function PiggySloltsGameModel.SetFakeSpinResult(elementData)
    spinElementData = spinElementData or {}
    if not spinElementData[spinTimes] then
        spinElementData[spinTimes] = {}
    end

    for k ,v in pairs(elementData) do
        local col = v.col
        local row = v.row
        if not spinElementData[spinTimes][col] then
            spinElementData[spinTimes][col] = {}
        end
        spinElementData[spinTimes][col][row] = DeepCopy(v)
    end

    for col = 1 , colNum do
        for row = 1 , rowNum do
            if not spinElementData[spinTimes][col] then
                spinElementData[spinTimes][col] = {}
            end
            if not spinElementData[spinTimes][col][row] then
                spinElementData[spinTimes][col][row] = 
                {
                    elementId = math.random(38002,38005)
                } 
                
            end
        end
    end

    log.log("小猪机台 5408 设置结算数据 最新" , spinElementData)
end

function PiggySloltsGameModel.ResetBreakRewardData(data)
    table.sort(data, function(a , b)
        if a.pigType < b.pigType then
            return true
        elseif a.pigType > b.pigType then
            return false
        else
            if a.col > b.col then
                return false
            elseif a.col < b.col then
                return true
            else
                return a.row > b.row
            end
        end
    end)
    breakRewardData = data
    log.log("小猪机台 协议 重置打碎奖励 ", breakRewardData)
end

function PiggySloltsGameModel.S2C_OnReceivePiggySlotsBreakData(code, data)
    log.log("小猪机台 协议 5409", code, data)
    if code == RET.RET_SUCCESS and data then
        spinTimes = data.spinTimes
        totalWin = data.totalWin
        spinSpend = data.slotsInfo.spinSpend
        breakTimes = data.breakTimes
        this.ResetBreakRewardData(data.gameReward)
        Facade.SendNotification(NotifyName.PiggySlots.PiggySlotsReqBreakSuccess,code)
    else
        Facade.SendNotification(NotifyName.PiggySlots.PiggySlotsReqBreakSuccess,code)
    end
end

function PiggySloltsGameModel.ReqPiggyInfo()
    if gameId then
		isReqNextCard = true
          this.SendMessage(MSG_ID.MSG_GAME_SLOTS_PIGGY_INFO,{gameId = gameId})
    else
        log.log("错误 小猪slots数据")
    end
end

function PiggySloltsGameModel.SetReqPiggyState(state)
    isReqNextCard = state
end

function PiggySloltsGameModel.ReqPiggySlotsSpin()
    if gameId then
        this.SendMessage(MSG_ID.MSG_GAME_SLOTS_PIGGY_SPIN,{gameId = gameId})
    else
        log.log("错误 小猪slots数据")
    end
end

function PiggySloltsGameModel.ReqPiggyBreak(isGoAway)
    if gameId then
        this.SendMessage(MSG_ID.MSG_GAME_SLOTS_PIGGY_BREAK,{gameId = gameId , isGoAway = isGoAway})
    else
        log.log("错误 小猪slots数据")
    end
end

function PiggySloltsGameModel.CheckPiggySlotsGameExist()
    if gameId then
        return true
    end
    return false
end

function PiggySloltsGameModel.ClearGameData()
    gameId = nil
	spinTimes = nil
	totalWin = 0
	spinSpend = nil
	spinElementData = nil
	breakTimes = 0
	jackpotWinCoin = 0
	winList = nil
	breakRewardData = nil
    piggyDataNow = nil
    isReqNextCard = false
    piggyDataLast = {}
    log.log("小猪机台 数据清除 ClearGameData")
end

function PiggySloltsGameModel.GetWinListData()
    return winList or {}
end

function PiggySloltsGameModel.GetBreakRewardData()
    return breakRewardData or nil
end

function PiggySloltsGameModel.GetColRowBreakRewardData()
	local resetBreakReward = DeepCopy(breakRewardData)
	table.sort(resetBreakReward , function(a,b)
		if a.col > b.col then
			return false
		elseif a.col < b.col then
			return true
		else
			return a.row > b.row
		end
	end)
	return resetBreakReward
end

function PiggySloltsGameModel.CheckElementPiggy(col,row)
    if spinElementData[spinTimes][col][row].elementId == PiggySlotsElementId.PiggyBank then
        return true
    end
    return false
end

function PiggySloltsGameModel.InitPiggyMerge()
    if not spinTimes or not spinElementData[spinTimes] then
        log.log("错误 小猪合并数据 spinTimes" , spinTimes)
        log.log("错误 小猪合并数据 spinElementData" , spinElementData)
        return false
    end
    log.log("小猪机台 合并小猪数据 spinElementData" , spinElementData)
    if piggyDataNow then
        piggyDataLast = DeepCopy(piggyDataNow)
    end
	piggyDataNow = {}
	local merge1X3List = {}
    for col = 1 , colNum do
        local checkRow = 2
        local bottomIsPiggy = this.CheckElementPiggy(col,checkRow - 1) 
        local topIsPiggy = this.CheckElementPiggy(col,checkRow +1) 
		piggyDataNow[col] = piggyDataNow[col] or {}

        if bottomIsPiggy and not piggyDataNow[col][1] then
			piggyDataNow[col][1] = 
			{
				piggyType = PiggySlotsEffectType.Piggy1x1,
			}
		end
		if topIsPiggy and not piggyDataNow[col][3] then
			piggyDataNow[col][3] = 
			{
				piggyType = PiggySlotsEffectType.Piggy1x1,
			}
		end

		if this.CheckElementPiggy(col,checkRow) and (piggyDataNow[col] and piggyDataNow[col][checkRow] ~= PiggySlotsEffectType.Piggy2x3) then
			piggyDataNow[col][checkRow] =
			{
				piggyType = PiggySlotsEffectType.Piggy1x1,
			}

            if bottomIsPiggy then
				piggyDataNow[col][2] = 
				{
					piggyType = PiggySlotsEffectType.Piggy1X2,
				}

				piggyDataNow[col][1] = 
				{
					piggyType = PiggySlotsEffectType.Piggy1X2,
				}
			end
            if topIsPiggy then
				piggyDataNow[col][3] = 
				{
					piggyType = PiggySlotsEffectType.Piggy1X2,
				}
				piggyDataNow[col][2] = 
				{
					piggyType = PiggySlotsEffectType.Piggy1X2,
				}
            end
            if topIsPiggy and bottomIsPiggy then
				merge1X3List[col] = true
				piggyDataNow[col][3] = 
				{
					piggyType = PiggySlotsEffectType.Piggy1X3,
				}
				piggyDataNow[col][2] = 
				{
					piggyType = PiggySlotsEffectType.Piggy1X3,
				}
				piggyDataNow[col][1] = 
				{
					piggyType = PiggySlotsEffectType.Piggy1X3,
				}
            end

            if col > 1 then
                if merge1X3List[col] and  merge1X3List[col - 1] and piggyDataNow[col][1] ~= PiggySlotsEffectType.Piggy2x3 then
					merge1X3List[col] = nil
					merge1X3List[col - 1] = nil
					
					for i = 1 ,rowNum do
						piggyDataNow[col-1][i] = 
						{
							piggyType = PiggySlotsEffectType.Piggy2x3,
							StartCol = col-1,
							FinishCol = col
						}	

						piggyDataNow[col][i] = 
						{
							piggyType = PiggySlotsEffectType.Piggy2x3,
							StartCol = col-1,
							FinishCol = col
						}
					end
                end
            end
        end
    end
end

function PiggySloltsGameModel.GetPiggyDataNow()
	return piggyDataNow
end

function PiggySloltsGameModel.GetPiggyDataLast()
	return piggyDataLast
end

function PiggySloltsGameModel.GetBreakNum()
    return breakTimes
end

function PiggySloltsGameModel.CheckHasNextCard()
	if breakTimes > 0 then
		return true
	end
	return false
end

function PiggySloltsGameModel.GetDiamondSpinCost()
    if spinTimes and spinSpend then
        for k ,v in pairs(spinSpend) do
            if v.index == spinTimes + 1 then
                return v.consume
            end 
        end
    end
    return 0
end

function PiggySloltsGameModel.CheckIsFreeSpin()
    if spinTimes then
        if spinTimes <BingoBangEntry.piggySlotsConfig.FreeSpinNum then
            return true
        else
            return false
        end
    else
        return true
    end
end

this.MsgIdList = {
    {msgid = MsgIDDefine.PB_GameSlotsPiggyInfo,func = this.S2C_OnReceivePiggySlotsInfo},
    {msgid = MSG_ID.MSG_GAME_SLOTS_PIGGY_SPIN,func = this.S2C_OnReceivePiggySlotsSpinResult},
    {msgid = MSG_ID.MSG_GAME_SLOTS_PIGGY_BREAK,func = this.S2C_OnReceivePiggySlotsBreakData},
}

local testSpinNum = 0
function PiggySloltsGameModel.SetTestSpinData()
    testSpinNum = testSpinNum + 1
    local getDataFuncName = "GetTestSpin" ..testSpinNum .."Data"
    local data = this[getDataFuncName]()
    this.S2C_OnReceivePiggySlotsSpinResult(0, data)
end

function PiggySloltsGameModel.SetTestData()
    this.SetTest5407_1()
	this.SetInitElement()
end

function PiggySloltsGameModel.SetTest5407_1()
end

function PiggySloltsGameModel.SetTest5407_2()
end

function PiggySloltsGameModel.GetTestSpin1Data()
    local dt =
     {
     }
     return dt
end

function PiggySloltsGameModel.GetTestSpin2Data()
    local dt =
    {
	
    }
    return dt
end

function PiggySloltsGameModel.GetTestSpin3Data()
    local dt =
    {
    }
    return dt
end

function PiggySloltsGameModel.GetTestSpin4Data()
    local dt =
    {
    }
    return dt
end

function PiggySloltsGameModel.GetTestSpin5Data()
    local dt =
    {
	
    }
    return dt
end

function PiggySloltsGameModel.GetTestSpin6Data()
    local dt =
    {
	
    }
    return dt
end

function PiggySloltsGameModel.GetBreakData()
    local dt = 
    {
    }
    return dt
end

function PiggySloltsGameModel.TestBreak()
    local dt = this.GetBreakData()
    this.S2C_OnReceivePiggySlotsBreakData(0, dt)
end

function PiggySloltsGameModel.CheckIsTest()
--  return true
        		 	 return false
end

return this
