require "Model/ModelPart/BaseGameModel"
local bingoJokerMachine = require("Combat.Machine.BingoJokerMachine")
local collectProgress = {}
local collectProgressConfig = 
{
    [1] = {progress = 0 , max = 4 , readyFlyNum = 0 },
    [2] = {progress = 0 , max = 4 , readyFlyNum = 0 },
    [3] = {progress = 0 , max = 1 , readyFlyNum = 0 },
    [4] = {progress = 0 , max = 1 , readyFlyNum = 0 },
}

local extraBonusCardData = {}


---鼹鼠矿工玩法
local DrinkingFrenzyModel = BaseGameModel:New()
local this = DrinkingFrenzyModel
local private = {}

--------需要子类重写，设置参数------------------------------------------------------------------------------
--function DrinkingFrenzyModel:InitModeOptions()
--    self.gameType_ = PLAY_TYPE.PLAY_TYPE_BEER
--    self.cityPlayID_ = 37
--end

function DrinkingFrenzyModel:GetQuestItemOffsetPos()
    return 26.5, -32
end

------------------------------------------------------------------------------------------------------

function DrinkingFrenzyModel:InitData()
    self:SetSelfGameType(PLAY_TYPE.PLAY_TYPE_BEER)
end
--
--function DrinkingFrenzyModel:ReqEnterGame(code,data)
--    private.OnResEnterGame(this)
--    if code == RET.RET_SUCCESS then
--        --this.moveMachine = require("Combat.BattleLogic.PirateShip.PirateShipMoveMachine")
--    end
--    log.log("请求协议数据 " , code , data)
--    BaseGameModel.ResEnterGame(self, code, data)
--    --if not self:CheckCityIsOpen() then
--    --    return
--    --end
--    --
--    --ModelList.BattleModel:DirectSetGameType(self.gameType_, self.cityPlayID_)
--    --ModelList.CityModel.SetPlayId(self.cityPlayID_)
--    --self:SetReadyState(0)
--    --
--    --local procedure = require "Procedure/ProcedureDrinkingFrenzy"
--    --Facade.SendNotification(NotifyName.ShowUI, ViewList.SceneLoadingGameView,nil,nil,procedure:New())
--    --
--    --ModelList.CityModel:SavePreviousPlayInfo()
--    --self:ResetSettleCode()
--    --
--    --local cardNum = ModelList.CityModel:GetCardNumber()
--    --local city = ModelList.CityModel:GetCity()
--    --local powerupGear, powerupId = ModelList.CityModel:GetPowerupGear()
--    --local data = {
--    --    cardNum = cardNum,
--    --    rate = ModelList.CityModel:GetBetRate(),
--    --    powerUpId = tonumber(powerupId),
--    --    cityId = city,
--    --    couponId = ModelList.CouponModel.get_currentCouponIdByCardNum(cardNum),
--    --    useCouponId = ModelList.CouponModel.get_currentCouponUseIdByCardNum(cardNum),
--    --    playId = ModelList.CityModel.GetPlayIdByCity(city),
--    --    hideCardAuto = ModelList.BattleModel.GetIsAutoSign() and 1 or 0
--    --}       
--    --self.SendMessage(MSG_ID.MSG_GAME_LOAD_BEER, data)
--end

function DrinkingFrenzyModel:ReqSignCard(info)
    local cardIds = {}
    for i = 1, #info.total do
        if this:RefreshRoundDataByIndex(info.total[i].cardId, info.total[i].index, 1) then
            if not fun.is_include(info.total[i].cardId, cardIds) then
                table.insert(cardIds, info.total[i].cardId)
            end
            this:CalcuateBingo(info.total[i].cardId, info.total[i].index, info.total[i].number)
        end
    end
    for i = 1, #cardIds do
        --this:CalcuateBingo(cardIds[i])
    end
end

function DrinkingFrenzyModel:RefreshRoundDataByIndex(cardid, cellIndex, signType, need_fly_item, mark)
    --父类处理
    local ret1, ret2 = this.__index:RefreshRoundDataByIndex(cardid, cellIndex, signType, need_fly_item, mark)

    --如果盖章触发技能/获得道具，添加sign计时，保证技能、道具动效播完
    local cell = self.roundData:GetCell(tostring(cardid), cellIndex)
    if cell and not cell:IsEmpty() then
        self.cardSignLogicDelayTime = os.time()
    end

    return ret1, ret2
end

function DrinkingFrenzyModel:CheckCollectFull(cardId,collectIndex)
    local collectData = collectProgress[cardId][collectIndex]
    return collectData.progress >= collectData.max
end

function DrinkingFrenzyModel:GetProgressData()
    return collectProgress
end

function DrinkingFrenzyModel:GetReadyFlyIndex(itemId,cardId)
    local collectData = collectProgress[cardId]
    if self:CheckIsBigGlass(itemId) then
        for i = 3 , 4 do
            if collectData[i].readyFlyNum < collectData[i].max then
                return i,collectData[i].readyFlyNum
            end
        end
    elseif self:CheckIsSmallGlass(itemId) then
        for i = 1 , 2 do
            if collectData[i].readyFlyNum < collectData[i].max then
                return i,collectData[i].readyFlyNum
            end
        end
    end
    log.r("啤酒机台 错误收集数据 GetReadyFlyIndex" , cardId , itemId)
    return 1,1
end

function DrinkingFrenzyModel:CheckCollectIndex(itemId,cardId)
    log.log("啤酒机台 收集数据检查 collectProgress" , collectProgress)
    local collectData = collectProgress[cardId]
    if self:CheckIsBigGlass(itemId) then
        for i = 3 , 4 do
            if collectData[i].progress < collectData[i].max then
                return i,collectData[i].progress, collectData[i].max
            end
        end
    elseif self:CheckIsSmallGlass(itemId) then
        for i = 1 , 2 do
            if collectData[i].progress < collectData[i].max then
                return i,collectData[i].progress, collectData[i].max
            end
        end        
    end
    log.r("啤酒机台 错误收集数据" , cardId , itemId)
    return 1,1
end

function DrinkingFrenzyModel:GetCollectProgress(cardId)
    return collectProgress[cardId]
end

function DrinkingFrenzyModel:AddReadyFlyNumProgress(cardId,collectIndex,addNum)
    cardId = tonumber(cardId)
    log.log("啤酒添加飞行准备 " , cardId , collectIndex , collectProgress)
    collectProgress[cardId][collectIndex].readyFlyNum = collectProgress[cardId][collectIndex].readyFlyNum + addNum 
end

function DrinkingFrenzyModel:AddCollectProgress(cardId,collectIndex,addProgress)
    if not collectProgress[cardId] or not collectProgress[cardId][collectIndex] then
        local logError = string.format("%s%s",cardId or "nil" , collectIndex or "nil")
        log.r("啤酒机台 参数错误 cardId" , logError)
        return
    end
    log.log("啤酒机台 收集数据检查 增加" ,  cardId , collectIndex)
    collectProgress[cardId][collectIndex].progress = addProgress
end

function DrinkingFrenzyModel:CheckIsBigGlass(itemId)
    if itemId == 261002 or itemId == 261003 then
        return true
    end
    return false
end

function DrinkingFrenzyModel:CheckIsSmallGlass(itemId)
    if itemId == 261001 then
        return true
    end
    return false
end

function DrinkingFrenzyModel:InitCollectProgress()
    collectProgress = {}
    for i = 1 , 4 do
        collectProgress[i] = DeepCopy(collectProgressConfig)
    end
    --log.log("啤酒机台 重置收集进度",collectProgress)    
end

function DrinkingFrenzyModel.InitExtraBonusCard()
    extraBonusCardData = {}
    for k ,v in pairs(this.gameLoadData.cardsInfo) do
        for z, w in pairs(v.cardNumberReward) do
            for  u,t in pairs(w.items) do
                if t.id == 2042 then
                    extraBonusCardData[k] =  this.roundData.num_to_index[tostring(k)][w.number] 
                    break
                end
            end
        end
    end
end

function DrinkingFrenzyModel:GetExtraBonusCardIndex()
    return extraBonusCardData
end

function DrinkingFrenzyModel:CheckIsExtraBonusCardIndexByCardId(cardId,cellIndex)
    log.log("检查格子特殊extrabonus" , extraBonusCardData , type(cardId) , type(cellIndex))
    if extraBonusCardData[cardId] and extraBonusCardData[cardId] == cellIndex then
        return true
    end
    return false
end


function DrinkingFrenzyModel:ResEnterGame(code, data)
    log.log("DPS机台内容学习 啤酒机台 协议 5537" ,code , data )
    this:InitCollectProgress()
    private.OnResEnterGame(this)
    BaseGameModel.ResEnterGame(self, code, data)
    --if (code == RET.RET_SUCCESS) then
    --    log.log("DrinkingFrenzyModel.ResponeEnterGame bingoRuleId ", data.bingoRuleId)
    --    this:SaveGameLoadData(data)
    --    this:SetReadyState(1)
    --    this:InitRoundData()
    --    this:InitExtraData(data.ext)
    --    log.log("啤酒机台 协议 特殊参数 " , this.enter_game_extra_data)
    --    ModelList.BattleModel.SetBattleDouble(data.activityStatus)
    --    ModelList.BattleModel.SetIsJokerMachine(((data.jokerData and #data.jokerData > 0) or ModelList.CityModel:IsMaxBetRate()) and true or false)
    --    ModelList.BattleModel:BackupLoadData(data)
    --    this:InitExtraBonusCard()
    --    this:SetGameState(GameState.Ready)
    --    Event.Brocast(EventName.Recorder_Data, 5001, data)
    --    
    --else
    --    log.r("发送进入游戏失败" .. code)
    --    Event.Brocast(EventName.Event_Cancel_Loading_Game)
    --    UIUtil.return_to_scenehome()
    --    UIUtil.show_common_global_popup(8004, true)
    --end
end

function DrinkingFrenzyModel:OnReceiveSettle()
    if self:GetGameState() < GameState.ShowSettle then
        self:ShowSettle()
    end
end

function DrinkingFrenzyModel:Clear()
    table.each(self.loop_delay_checks, function(v)
        LuaTimer:Remove(v)
    end)

    this.__index:Clear()
end

--- 卡面上的bingo表现有延迟，确保最新一个bingo效果能满足最低存活时间
function DrinkingFrenzyModel:IsBingoShowComplete()
    local check = this.__index:IsBingoShowComplete()

    --cell被盖章后飞出道具及做动画的时间
    local checkTime = os.time() - self.cardSignLogicDelayTime > 2.5
    return check and checkTime
end

--- 需要等特效还有bingo画面啥的都得等播放完再弹出结算界面
--- 战斗结算前，检查彩球叫号器
function DrinkingFrenzyModel:CheckJokerBallSprayer(callBack)
    local haveJokerBall = ModelList.BattleModel.HasJokerBallSprayer()
    private.StartSkillEmptyCheck(self, function()
        local cb = function()
            if haveJokerBall then
                --有彩球喷射器，等技能、盖章效果播完再继续彩球喷射器
                --这里等4秒是因为彩球喷射器动画太长，要等动画播完才走盖章逻辑
                LuaTimer:SetDelayFunction(4, function()
                    private.StartSkillEmptyCheck(self, function()
                        callBack()
                    end)
                end)
            else
                --没有彩球喷射器，等技能、盖章效果播完直接打开结算界面
                callBack()
            end
        end
        bingoJokerMachine:CheckJokerBallSprayer(cb)
    end)
end

function DrinkingFrenzyModel:SetRoundGiftData(card_id, cell_index, new_gift, number, skill_id, self_bingo, powerId, extraPos)
    this.__index:SetRoundGiftData(card_id, cell_index, new_gift, number, skill_id, self_bingo, powerId, extraPos)
    if powerId == 180 then
        --记录猪技能数据，结束上传
        table.insert(self.cachedSkillDataCache, {
            cardId = tonumber(card_id),
            cellIndex = cell_index,
            extraPos = extraPos,
        })
    end
end

function DrinkingFrenzyModel:UploadGameData(gameType, quiteType,cb)
    if self.roundData ~= nil and self.roundData.GetRoundData ~= nil then
        self:PreCalcuatePigSkill()
    end
    this.__index:UploadGameData(gameType, quiteType,cb)
end

function DrinkingFrenzyModel:PlayBattleOverSound()
    UISound.play("minerbattleover")
end

---提前计算好猪技能的数据，上传到服务器
function DrinkingFrenzyModel:PreCalcuatePigSkill()
    local typeFlag = {}  --标识哪些类型已经被技能使用
    table.each(self.cachedSkillDataCache, function(v)
        local cellData = self:GetRoundData(v.cardId, v.cellIndex)
        if not cellData or not cellData:IsNotSign() then
            return
        end

        typeFlag[v.cardId] = typeFlag[v.cardId] or {}
        local cells, type = self:CheckBingoSkillExtraPosValid(v.cardId, v.extraPos)
        if type and not typeFlag[v.cardId][type] then
            typeFlag[v.cardId][type] = true
        else
            cells = {}
        end

        local extraPos = BattleTool.ConvertedToServerPosList(cells)
        --添加ExtraData，结算时通知服务器某个类型达成了Bingo
        self:GetRoundData(v.cardId):AddExtraUpLoadData("cardHitGridBingo", {
            cardId = tonumber(v.cardId),
            pos = ConvertCellIndexToServerPos(v.cellIndex),
            extraPos = extraPos,
            isPreCheck = 1,
        }, "pos")
        --更改本地数据
        cellData:SetPuExtraPos(extraPos)
    end)
end

function DrinkingFrenzyModel:CheckBingoSkillExtraPosValid(cardId, extraPos)
    local ret, type = {}
    table.each(extraPos, function(v)
        local cellID = ConvertServerPos(v)
        local cellData = self:GetRoundData(cardId, cellID)
        if cellData then
            if cellData:IsNotSign() then
                table.insert(ret, cellID)
            end

            --该材料的类型
            if not type then
                type = private.GetCellItemType(cellData)
            end
        end
    end)

    --有指定格子未盖章，继续进行
    if #ret > 0 then
        table.sort(ret, function(a, b)
            return a > b
        end)
        return ret, type
    end

    if ModelList.BattleModel:IsRocket() then
        return ret
    end
    
    local excludeTypes = { type }
    --所有指定格子都已经盖章，选择一个其他类型的材料
    local cells, newType = private.FindNewTypeForPtgSkill(cardId, excludeTypes)
    if #cells == 0 then
        --格子无效
        return ret
    end
    if not newType or newType == type then
        --没找到新类型
        return ret
    end

    ret = cells
    table.sort(ret, function(a, b)
        return a > b
    end)
    return ret, newType
end

function DrinkingFrenzyModel:GetCurrentCollectLevel()
    local level = self:GetBattleExtraInfo("longStage")
    log.log("DrinkingFrenzyModel:GetCurrentCollectLevel the level is ", level)
    level = level and tonumber(level) or 1
    return level
end

function DrinkingFrenzyModel:GetMineralImageNameByIdxAndLevel(idx, level)
    return "Gold" ..level .. "Bullion0" .. idx
end

-----------------私有方法----------------------------------------------

---开始一场新的对局，初始化本地数据
function private.OnResEnterGame(self)
    self.cardSignLogicDelayTime = 0
    self.cachedSkillDataCache = {}
    self.loop_delay_checks = {}
end

function private.StartSkillEmptyCheck(self, cb)
    local loop_delay_check
    loop_delay_check = LuaTimer:SetDelayLoopFunction(0.2, 0.1, -1, function()
        local effectObjContainer = ModelList.BattleModel:GetCurrBattleView().effectObjContainer
        if effectObjContainer then
            local isSkillEmpty = effectObjContainer:IsSkillContainerEmpty()
            if isSkillEmpty then
                LuaTimer:Remove(loop_delay_check)
                cb()
            end
        else
            LuaTimer:Remove(loop_delay_check)
            cb()
        end
    end, nil, nil, LuaTimer.TimerType.Battle)
    table.insert(self.loop_delay_checks, loop_delay_check)
end

function private.GetCellItemType(cellData)
    local type

    table.each(cellData.hide_gift, function(v2)
        if 4 == math.floor(v2.id / 10000000) then
            type = 1
        else
            local cfg = Csv.GetData("item", v2.id, "result")
            if cfg[1] == 44 then
                type = cfg[2]
            end
        end
    end)

    return type
end

function private.FindNewTypeForPtgSkill(cardId, excludeTypes)
    local ret = {}
    local cells, newType = BattleLogic.GetLogicModule(LogicName.Card_logic):GetSkillNeedCells(cardId, excludeTypes)
    if not cells or not newType then
        return {}
    end

    table.each(cells, function(cellData)
        if cellData:IsNotSign() then
            table.insert(ret, cellData.index)
        end
    end)

    if #ret == 0 then
        if #excludeTypes == 4 then
            return {}
        else
            table.insert(excludeTypes, newType)
            return private.FindNewTypeForPtgSkill(cardId, excludeTypes)
        end
    else
        return ret, newType
    end
end

function DrinkingFrenzyModel:IsTriggerExtraReward()
    local curRate = ModelList.CityModel:GetBetRate()
    -- local playid = ModelList.CityModel.GetPlayIdByCity()
    -- local minBet = Csv.GetData("city_play", playid, "supermatch_bet")
    -- if minBet == 0 then return false end
    if ModelList.UltraBetModel:IsActivityValid() then
        return true
    end

    local maxRate = ModelList.CityModel:GetMaxRateOpen()
    local curRate = ModelList.CityModel:GetBetRate()
    if not maxRate or not curRate then
        log.log("DrinkingFrenzyModel:IsTriggerExtraReward 判断条件未达成", maxRate, curRate)
        return false
    end

    return curRate >= maxRate
end

function DrinkingFrenzyModel:GetExtraRewardTipIconSprite()
    local curSprite = resMgr:GetSpriteByName("DrinkingFrenzyHallAtlas", "BeerTitleSdm")
    return curSprite
end

function DrinkingFrenzyModel:CheckEffectShowOver()
    local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
    local check = cardView.CheckAllCardAnimShowOver and cardView:CheckAllCardAnimShowOver()
    return check
end

this.BaseMsgIdList = {
    { msgid = MSG_ID.MSG_GAME_LOAD_BEER, func = this.ResponeEnterGame },
}

return this