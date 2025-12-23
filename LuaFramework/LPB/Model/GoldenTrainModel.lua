require "Model/ModelPart/BaseGameModel"
local bingoJokerMachine = require("Combat.Machine.BingoJokerMachine")

---鼹鼠矿工玩法
local GoldenTrainModel = BaseGameModel:New()
local this = GoldenTrainModel
local private = {}

------需要子类重写，设置参数------------------------------------------------------------------------------
function GoldenTrainModel:InitModeOptions()
    self.gameType_ = PLAY_TYPE.PLAY_TYPE_GOLD_TRAIN
    self.cityPlayID_ = 30
end

function GoldenTrainModel:GetQuestItemOffsetPos()
    return 26.5, -32
end

------------------------------------------------------------------------------------------------------

function GoldenTrainModel:InitData()
    self:InitModeOptions()
    self:SetSelfGameType(self.gameType_)
    self.bingoInfoRecord = { {}, {}, {}, {} }
    self.curBingoRewardReward = {0, 0, 0, 0}
    self.rollAnimList = {}
    self.settleGameData = nil
end

function GoldenTrainModel:ReqEnterGame()
    if not self:CheckCityIsOpen() then
        return
    end

    ModelList.BattleModel:DirectSetGameType(self.gameType_, self.cityPlayID_)
    ModelList.CityModel.SetPlayId(self.cityPlayID_)
    self:SetReadyState(0)

    local procedure = require "Procedure/ProcedureGoldenTrain"
    Facade.SendNotification(NotifyName.ShowUI, ViewList.SceneLoadingGameView, nil, nil, procedure:New())

    ModelList.CityModel:SavePreviousPlayInfo()
    self:ResetSettleCode()

    local cardNum = ModelList.CityModel:GetCardNumber()
    local city = ModelList.CityModel:GetCity()
    local powerupGear, powerupId = ModelList.CityModel:GetPowerupGear()
    local data = {
        cardNum = cardNum,
        rate = ModelList.CityModel:GetBetRate(),
        powerUpId = tonumber(powerupId),
        cityId = city,
        couponId = ModelList.CouponModel.get_currentCouponIdByCardNum(cardNum),
        useCouponId = ModelList.CouponModel.get_currentCouponUseIdByCardNum(cardNum),
        playId = ModelList.CityModel.GetPlayIdByCity(city),
        hideCardAuto = ModelList.BattleModel.GetIsAutoSign() and 1 or 0
    }
    self.SendMessage(MSG_ID.MSG_GAME_GOLD_TRAIN, data)
end

function GoldenTrainModel:ReqSignCard(info)
    local cardIds = {}
    for i = 1, #info.total do
        if this:RefreshRoundDataByIndex(info.total[i].cardId, info.total[i].index, 1) then
            if not fun.is_include(info.total[i].cardId, cardIds) then
                table.insert(cardIds, info.total[i].cardId)
            end
            --this:CalcuateBingo(info.total[i].cardId, info.total[i].index, info.total[i].number)
        end
    end
    for i = 1, #cardIds do
        --this:CalcuateBingo(cardIds[i])
    end
end

function GoldenTrainModel:RefreshRoundDataByIndex(cardid, cellIndex, signType, need_fly_item, mark)
    --父类处理
    local ret1, ret2 = this.__index:RefreshRoundDataByIndex(cardid, cellIndex, signType, need_fly_item, mark)

    --如果盖章触发技能/获得道具，添加sign计时，保证技能、道具动效播完
    local cell = self.roundData:GetCell(tostring(cardid), cellIndex)
    if cell then
        if cellIndex ~= 13 then
            cell.forbiddenSignType = true
        end
        if not cell:IsEmpty() then
            self.cardSignLogicDelayTime = os.time()
        end
    end

    return ret1, ret2
end

function GoldenTrainModel.ResponeEnterGame(code, data)
    private.OnResEnterGame(this)
    if (code == RET.RET_SUCCESS) then
        log.log("GoldenTrainModel.ResponeEnterGame bingoRuleId ", data.bingoRuleId)
        this:SaveGameLoadData(data)
        this:SetReadyState(1)
        this:InitRoundData()
        this:InitExtraData(data.ext)
        ModelList.BattleModel.SetBattleDouble(data.activityStatus)
        ModelList.BattleModel.SetIsJokerMachine(((data.jokerData and #data.jokerData > 0) or ModelList.CityModel:IsMaxBetRate()) and
            true or false)
        ModelList.BattleModel:BackupLoadData(data)
        this:SetGameState(GameState.Ready)
        Event.Brocast(EventName.Recorder_Data, 5001, data)
    else
        log.r("发送进入游戏失败" .. code)
        Event.Brocast(EventName.Event_Cancel_Loading_Game)
        UIUtil.return_to_scenehome()
        UIUtil.show_common_global_popup(8004, true)
    end
end

function GoldenTrainModel.ResSettleGame(code, data)
    if (code == RET.RET_SUCCESS) then
        log.log("GoldenTrainModel.ResSettleGame succ ")
        this.settleGameData = data
        local settleInfo = data.settleInfo
        for i1, v1 in ipairs(settleInfo) do
            for i2 = 1, #v1.bingoPath do
                v1.bingoPath[i2] = this:TransformBingoPathIdS2C(v1.bingoPath[i2])
            end

            for i3, v3 in ipairs(v1.pathReward) do
                v3.bingoPath = this:TransformBingoPathIdS2C(v3.bingoPath)
                for i5, v5 in ipairs(v3.markedPos) do
                    v5.pos = ConvertServerPos(v5.pos)
                    if #v5.itemReward > 0 then
                        v5.hasMini = v5.itemReward[1].id == 191003 and true or false
                        v5.hasDouble = v5.itemReward[1].id == 191002 and true or false
                    else
                        v5.hasMini = false
                        v5.hasDouble = false
                    end
                end
            end

            for i4, v4 in ipairs(v1.markedPos) do
                v4.pos = ConvertServerPos(v4.pos)
                if #v4.itemReward > 0 then
                    v4.hasMini = v4.itemReward[1].id == 191003 and true or false
                    v4.hasDouble = v4.itemReward[1].id == 191002 and true or false
                else
                    v4.hasMini = false
                    v4.hasDouble = false
                end
            end
        end
        this.settleInfo = settleInfo
    else
        log.log("GoldenTrainModel.ResSettleGame fail ")
    end
end

function GoldenTrainModel:ResBingoInfo(code, data)
    if (code == RET.RET_SUCCESS) then
        this:SaveBingoLeftInfo(data)
        if this.onlySaveBingoInfo then
            return
        end
        this:RefreshBingoInfo()
        Facade.SendNotification(NotifyName.Bingo.Sync_Bingos)
        if data.bingoLeft <= 10 then
            UISound.set_bgm_volume(0.7)
        end
        if data.bingoLeft <= 0 and this:GetReadyState() == 1 then
            this:SetReadyState(2)
            LuaTimer:SetDelayFunction(MCT.delay_to_show_settle, function ()
                this.loop_delay_settle = LuaTimer:SetDelayLoopFunction(0.1, 0.1, 100, function ()
                    --if this:IsGameSettling() then
                    this:ShowSettle()
                    LuaTimer:Remove(this.loop_delay_settle)
                    --end
                end, nil, nil, LuaTimer.TimerType.Battle)
            end)
        end
    else
        log.w("同步Bingo错误")
    end
end

function GoldenTrainModel:OnReceiveSettle()
    if self:GetGameState() < GameState.ShowSettle then
        self:ShowSettle()
    end
end

function GoldenTrainModel:Clear()
    table.each(self.loop_delay_checks, function (v)
        LuaTimer:Remove(v)
    end)

    this.__index:Clear()
    this.settleInfo = nil
    this.settleGameData = nil

    self.bingoInfoRecord = { {}, {}, {}, {} }
    self.bingoRewardMap1 = nil
    self.bingoRewardMap2 = nil
    self.curBingoRewardReward = {0, 0, 0, 0}
    self.rollAnimList = {}
end

--- 卡面上的bingo表现有延迟，确保最新一个bingo效果能满足最低存活时间
function GoldenTrainModel:IsBingoShowComplete()
    local check = this.__index:IsBingoShowComplete()

    --cell被盖章后飞出道具及做动画的时间
    local checkTime = os.time() - self.cardSignLogicDelayTime > 2.5
    return check and checkTime
end

--- 需要等特效还有bingo画面啥的都得等播放完再弹出结算界面
--- 战斗结算前，检查彩球叫号器
function GoldenTrainModel:CheckJokerBallSprayer(callBack)
    local haveJokerBall = ModelList.BattleModel.HasJokerBallSprayer()
    private.StartSkillEmptyCheck(self, function ()
        local cb = function ()
            if haveJokerBall then
                --有彩球喷射器，等技能、盖章效果播完再继续彩球喷射器
                --这里等4秒是因为彩球喷射器动画太长，要等动画播完才走盖章逻辑
                LuaTimer:SetDelayFunction(4, function ()
                    private.StartSkillEmptyCheck(self, function ()
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

function GoldenTrainModel:SetRoundGiftData(card_id, cell_index, new_gift, number, skill_id, self_bingo, powerId, extraPos)
    this.__index:SetRoundGiftData(card_id, cell_index, new_gift, number, skill_id, self_bingo, powerId, extraPos)
    if powerId == 186 then
        --记录猪技能数据，结束上传
        table.insert(self.cachedSkillDataCache, {
            cardId = tonumber(card_id),
            cellIndex = cell_index,
            extraPos = extraPos,
        })
    elseif powerId == 187 then
        --记录猪技能数据，结束上传
        table.insert(self.cachedSkillDataCache, {
            cardId = tonumber(card_id),
            cellIndex = cell_index,
            extraPos = extraPos,
        })
    end
end

function GoldenTrainModel:UploadGameData(gameType, quiteType)
    if self.roundData ~= nil and self.roundData.GetRoundData ~= nil then
        self:PreCalcuatePigSkill()
    end
    this.__index:UploadGameData(gameType, quiteType)
end

function GoldenTrainModel:PlayBattleOverSound()
    UISound.play("minerbattleover")
end

---提前计算好猪技能的数据，上传到服务器
function GoldenTrainModel:PreCalcuatePigSkill()
    local typeFlag = {} --标识哪些类型已经被技能使用
    table.each(self.cachedSkillDataCache, function (v)
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

function GoldenTrainModel:CheckBingoSkillExtraPosValid(cardId, extraPos)
    local ret, type = {}
    table.each(extraPos, function (v)
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
        table.sort(ret, function (a, b)
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
    table.sort(ret, function (a, b)
        return a > b
    end)
    return ret, newType
end

function GoldenTrainModel:GetCurrentCollectLevel()
    local level = self:GetBattleExtraInfo("longStage")
    log.log("GoldenTrainModel:GetCurrentCollectLevel the level is ", level)
    level = level and tonumber(level) or 1
    return level
end

function GoldenTrainModel:GetDefaultReward()
    local reward = self:GetBattleExtraInfo("trainBingoReward") or 0
    log.log("GoldenTrainModel:GetDefaultReward the reward is ", reward)
    return reward
end

function GoldenTrainModel:GetCardBingoRewardList(cardId)
    if not self.bingoRewardMap1 then
        self.bingoRewardMap1 = self:GetBattleExtraInfo("trainCardBingoReward") or {}
    end
    
    return self.bingoRewardMap1[tostring(cardId)] or {}
end

--增量
function GoldenTrainModel:GetCardBingoReward1(cardId, bingoOrder)
    local rewardList = self:GetCardBingoRewardList(cardId)
    local reward = rewardList[bingoOrder] or 0
    return reward
end

--累积量
function GoldenTrainModel:GetCardBingoReward2(cardId, bingoOrder)
    if not self.bingoRewardMap2 then
        self.bingoRewardMap2 = {}
        local cardCount = self:GetCardCount()
        for i = 1, cardCount do
            self.bingoRewardMap2[i] = {}
            local rewardList = self:GetCardBingoRewardList(i)
            local acc = 0
            for j, v in ipairs(rewardList) do
                acc = acc + v
                self.bingoRewardMap2[i][j] = acc
            end
        end
    end
    
    local rewardList = self.bingoRewardMap2[cardId] or {}
    local reward = rewardList[bingoOrder] or 0
    return reward
end

function GoldenTrainModel:SetCurBingoReward(cardId, reward)
    self.curBingoRewardReward[cardId] = reward
end

function GoldenTrainModel:GetCurBingoReward(cardId)
    return self.curBingoRewardReward[cardId] or 0
end


function GoldenTrainModel:SetRollAnim(cardId, rollAnim)
    if self.rollAnimList[cardId] then
        self.rollAnimList[cardId]:Kill()
        self.rollAnimList[cardId] = nil
    end
    self.rollAnimList[cardId] = rollAnim
end

function GoldenTrainModel:CellIndex2Col(idx)
    return math.floor((idx + 4) / 5)
end

function GoldenTrainModel:CellIndex2Row(idx)
    return (idx - 1) % 5 + 1
end

function GoldenTrainModel:TransformBingoPathIdC2S(bingoPathId)
    if not bingoPathId or bingoPathId < 1 or bingoPathId > 13 then
        log.log("GoldenTrainModel:TransformBingoPathIdC2S Error")
        return
    end

    if bingoPathId < 6 then
        return 6 - bingoPathId
    elseif bingoPathId > 10 and bingoPathId < 13 then
        return 23 - bingoPathId
    else
        return bingoPathId
    end
end

function GoldenTrainModel:TransformBingoPathIdS2C(bingoPathId)
    return self:TransformBingoPathIdC2S(bingoPathId)
end

--生成类型，1：2X，   2：MINI
function GoldenTrainModel:GetSpecialCoinType(cardId, cellIdx)
    local cfg = Csv.GetData("item", 2031, "result")
    if cfg and cfg[1] == 54 then
        local item1, weight1 = cfg[2], cfg[3]
        local item2, weight2 = cfg[4], cfg[5]
        local weight = weight1 + weight2
        local rv = math.random(1, weight)
        if rv <= weight1 then
            return 1
        else
            return 2
        end
    else
        return 1
    end
end

--- 保存当前战斗bingo数据
function GoldenTrainModel:RecordBingoInfo(cardId, info)
    table.insert(self.bingoInfoRecord[cardId], info)
end

function GoldenTrainModel:GetBingoCount(cardId)
    if not self.bingoInfoRecord then
        return 0
    end

    if not self.bingoInfoRecord[cardId] then
        return 0
    end

    return #self.bingoInfoRecord[cardId]
end

function GoldenTrainModel:GenerateBingoOrderList()
    local cardCount = self:GetCardCount()
    local list = {}
    local settleInfoList = {}
    local settleData = this.settleInfo

    for cardId = 1, cardCount do
        local temp = {}
        local settleInfo = nil
        for i = 1, #settleData do
            if settleData[i].cardId == cardId then
                temp = deep_copy(settleData[i].bingoPath)
                settleInfo = settleData[i]
            end
        end
        list[tostring(cardId)] = temp
        settleInfoList[tostring(cardId)] = settleInfo
    end

    return list, settleInfoList
end

--- 获取当前战斗bingo顺序
function GoldenTrainModel:GetBingoOrder()
    return self:GenerateBingoOrderList()
    --[[测试数据
    bingoOrder =  {
        ["1"] = { 1, 2, 3, 4, 5,6,7,8,9,10,11,12,13 },
        --["2"] = { 4, 5, 6 },
        --["3"] = { 7, 8, 9 },
        --["4"] = { 10, 11, 12 },
    }
    --]]
    --return bingoOrder
end

function GoldenTrainModel:GetBingoOrderByCardId(cardId, transform2Server)
    cardId = tonumber(cardId)
    local temp = {}
    for i, v in ipairs(self.bingoInfoRecord[cardId]) do
        local pathId = v.pathId
        if transform2Server then
            pathId = self:TransformBingoPathIdC2S(pathId)
        end
        table.insert(temp, pathId)
    end

    return temp
end

--
function GoldenTrainModel:GetSmallGameData()
    return (this.settleGameData and this.settleGameData.allRewardValue and this.settleGameData.allRewardValue > 0) and
        this.settleGameData or nil
end

function GoldenTrainModel:IsTriggerExtraReward()
    local curRate = ModelList.CityModel:GetBetRate()
    -- local playid = ModelList.CityModel.GetPlayIdByCity()
    -- local minBet = Csv.GetData("city_play", playid, "supermatch_bet")
    -- if minBet == 0 then return false end
    if ModelList.UltraBetModel:IsActivityValid() then
        return true
    end

    return curRate >= 8
end

function GoldenTrainModel:GetExtraRewardTipIconSprite()
    local curSprite = AtlasManager:GetSpriteByName("GoldenTrainHallAtlas", "iconBell")
    return curSprite
end

--确认bingo场景加载完成，通知后端开始叫号
function GoldenTrainModel:ReqGameReady()
    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    if bingoView then
        --local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
        local cardView = bingoView:GetCardView()
        if cardView then
            cardView:ShowTrainInitalAnima()
        end
    end

    LuaTimer:SetDelayFunction(1.5, function()
        BattleMachineList.StartBattleMachine()
        BattleModuleList.EnableUpdate()
        Event.Brocast(EventName.Recorder_Data, 5002, nil)
    end, nil, LuaTimer.TimerType.Battle)
end

function GoldenTrainModel:GetMiniReward()
    local result = Csv.GetData("item", 191003, "result")
    if result and result[1] == 4 and result[2] then
        return result[2] * 10
    end

    return 100
end

----------------------------------------------私有方法----------------------------------------------begin
---开始一场新的对局，初始化本地数据
function private.OnResEnterGame(self)
    self.cardSignLogicDelayTime = 0
    self.cachedSkillDataCache = {}
    self.loop_delay_checks = {}
end

function private.StartSkillEmptyCheck(self, cb)
    local loop_delay_check
    loop_delay_check = LuaTimer:SetDelayLoopFunction(0.2, 0.1, -1, function ()
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

    table.each(cellData.hide_gift, function (v2)
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

    table.each(cells, function (cellData)
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
----------------------------------------------私有方法----------------------------------------------end

this.BaseMsgIdList = {
    { msgid = MSG_ID.MSG_GAME_GOLD_TRAIN,        func = this.ResponeEnterGame },
    { msgid = MSG_ID.MSG_GAME_GOLD_TRAIN_SETTLE, func = this.ResSettleGame },
}

this.Const = {
    soundDelayTime1 = 1,    --goldentraincoinsdown
    soundDelayTime2 = 0.3,    --goldentrainbonusbreak
    soundDelayTime3 = 0.5,    --goldentraincoinsflyin
    soundDelayTime4 = 1.3,    --goldentrainnumadd ①.奖励事件触发金币数字开始增长时播
    soundDelayTime5 = 1,    --goldentrainnumadd ②.触发2X，数字翻倍，数字增长时播
}

return this