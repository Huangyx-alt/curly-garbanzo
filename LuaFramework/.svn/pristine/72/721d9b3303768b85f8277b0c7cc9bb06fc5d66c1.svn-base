require "Model/ModelPart/BaseGameModel"
local bingoJokerMachine = require("Combat.Machine.BingoJokerMachine")

---野牛踩踏玩法
local ScratchWinnerModel = BaseGameModel:New()
local this = ScratchWinnerModel
local private = {}

------需要子类重写，设置参数------------------------------------------------------------------------------
function ScratchWinnerModel:InitModeOptions()
    self.gameType_ = PLAY_TYPE.PLAY_TYPE_SCRATCH_WINNER
    self.cityPlayID_ = 29
end

function ScratchWinnerModel:GetQuestItemOffsetPos()
    return 26.5, -32
end

------------------------------------------------------------------------------------------------------

function ScratchWinnerModel:InitData()
    self:InitModeOptions()
    self:SetSelfGameType(self.gameType_)
end

function ScratchWinnerModel:ReqEnterGame()
    if not self:CheckCityIsOpen() then
        return
    end

    ModelList.BattleModel:DirectSetGameType(self.gameType_, self.cityPlayID_)
    ModelList.CityModel.SetPlayId(self.cityPlayID_)
    self:SetReadyState(0)

    local procedure = require "Procedure/ProcedureScratchWinner"
    Facade.SendNotification(NotifyName.ShowUI, ViewList.SceneLoadingGameView, nil, nil, procedure:New())

    ModelList.CityModel:SavePreviousPlayInfo()
    self:ResetSettleCode()

    --获取大厅选择的卡片数量
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
    self.SendMessage(MSG_ID.MSG_GAME_SCRATCH_WINNER, data)

    private.ClearScratchBallShakerData(self)
end

function ScratchWinnerModel:ReqSignCard(info)
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

function ScratchWinnerModel:RefreshRoundDataByIndex(cardid, cellIndex, signType, need_fly_item, mark)
    --父类处理
    local ret1, ret2 = this.__index:RefreshRoundDataByIndex(cardid, cellIndex, signType, need_fly_item, mark)

    --如果盖章触发技能/获得道具，添加sign计时，保证技能、道具动效播完
    local cell = self.roundData:GetCell(tostring(cardid), cellIndex)
    if cell and not cell:IsEmpty() then
        self.cardSignLogicDelayTime = os.time()
    end

    return ret1, ret2
end

--接受后端返回的对局数据并进行初始化
function ScratchWinnerModel.ResponeEnterGame(code, data)
    private.OnResEnterGame(this)
    if (code == RET.RET_SUCCESS) then
        log.log("ScratchWinnerModel.ResponeEnterGame bingoRuleId ", data.bingoRuleId)
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

function ScratchWinnerModel:ResBingoInfo(code, data)
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

function ScratchWinnerModel:OnReceiveSettle()
    if self:GetGameState() < GameState.ShowSettle then
        self:ShowSettle()
    end
end

function ScratchWinnerModel:Clear()
    table.each(self.loop_delay_checks, function (v)
        LuaTimer:Remove(v)
    end)

    this.__index:Clear()
end

--- 卡面上的bingo表现有延迟，确保最新一个bingo效果能满足最低存活时间
function ScratchWinnerModel:IsBingoShowComplete()
    local check = this.__index:IsBingoShowComplete()

    --cell被盖章后飞出道具及做动画的时间
    local checkTime = os.time() - self.cardSignLogicDelayTime > 2.5
    return check and checkTime
end

--- 需要等特效还有bingo画面啥的都得等播放完再弹出结算界面
--- 战斗结算前，检查彩球叫号器
function ScratchWinnerModel:CheckJokerBallSprayer(callBack)
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

function ScratchWinnerModel:SetRoundGiftData(card_id, cell_index, new_gift, number, skill_id, self_bingo, powerId,
                                             extraPos)
    this.__index:SetRoundGiftData(card_id, cell_index, new_gift, number, skill_id, self_bingo, powerId, extraPos)
    --undo 待处理
    if powerId == 185 then
        --记录猪技能数据，结束上传
        table.insert(self.cachedSkillDataCache, {
            cardId = tonumber(card_id),
            cellIndex = cell_index,
            extraPos = extraPos,
        })
    end
end

function ScratchWinnerModel:UploadGameData(gameType, quiteType)
    if self.roundData ~= nil and self.roundData.GetRoundData ~= nil then
        self:PreCalcuatePigSkill()
    end
    this.__index:UploadGameData(gameType, quiteType)
end

function ScratchWinnerModel:PlayBattleOverSound()
    UISound.play("minerbattleover")
end

---提前计算好猪技能的数据，上传到服务器
function ScratchWinnerModel:PreCalcuatePigSkill()
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

function ScratchWinnerModel:CheckBingoSkillExtraPosValid(cardId, extraPos)
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

function ScratchWinnerModel:GetCurrentCollectLevel()
    local level = self:GetBattleExtraInfo("longStage")
    log.log("ScratchWinnerModel:GetCurrentCollectLevel the level is ", level)
    level = level and tonumber(level) or 1
    return level
end

function ScratchWinnerModel:GetCollectiveMaxCount(collectType, collectLevel)
    return 1
end

function ScratchWinnerModel:CellIndex2Col(idx)
    return math.floor((idx + 4) / 5)
end

--undo wait data
function ScratchWinnerModel:GetBingoReward(idx, useThousandSeparator)
    local bingoRewardList = self:GetBattleExtraInfo("bingoReward")
    if not bingoRewardList then
        log.log("ScratchWinnerModel:GetBingoReward no bingoReward data")
        bingoRewardList = { 0, 0, 0, 0, 0 }
    end

    if idx >= 1 and idx <= 5 then
        local curReward = bingoRewardList[tostring(idx)] or 0
        if curReward >= 100000 and useThousandSeparator then
            local newValue = fun.formatNum(curReward / 1000) .. "K"
            return newValue
        else
            local newValue = fun.formatNum(curReward) 
            return newValue
        end
    end

    return 0
end

function ScratchWinnerModel:GetWishCellIdxList(cardId)
    local cellIdxList = {0, 0, 0, 0, 0}
    if not cardId then
        log.log("ScratchWinnerModel:GetWishCellIdxList(cardId) cardId nil ")
        return cellIdxList
    end
    local unSignRecord = {{}, {}, {}, {}, {}}
    for i = 1, 25 do
        if i ~= 13 then
            local curCell = self:GetRoundData(cardId, i)
            if (curCell:IsNotSign() or curCell:IsLogicSign()) then
                local treasureItems = curCell:Treasure2Item()
                if treasureItems then
                    local data = Csv.GetData("item", treasureItems.id)
                    if 52 == data.result[1] then
                        if unSignRecord[data.result[2]] then
                            table.insert(unSignRecord[data.result[2]], curCell)
                        end
                    end
                end
            end
        end
    end
    
    for i = 1, 5 do
        if #unSignRecord[i] == 1 then
            cellIdxList[i] = unSignRecord[i][1].index
        end
    end

    return cellIdxList
end

--确认bingo场景加载完成，通知后端开始叫号
function ScratchWinnerModel:ReqGameReady()
    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    if bingoView then
        --local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
        local cardView = bingoView:GetCardView()
        if cardView then
            cardView:ShowDiamondInitalProgress()
        end
    end

    LuaTimer:SetDelayFunction(1.5, function()
        BattleMachineList.StartBattleMachine()
        BattleModuleList.EnableUpdate()
        Event.Brocast(EventName.Recorder_Data, 5002, nil)
    end, nil, LuaTimer.TimerType.Battle)
end

----------------------------------------------私有方法----------------------------------------------
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


-----------------------------region 刮刮卡摇奖-------------
--刮刮乐玩法，入场清除ScratchBallShakerData
function private.ClearScratchBallShakerData(self)
    self.ShakerData = nil
end

function private.SaveScratchBallShakerData(self, data)
    self.ShakerData = data
end

--刮刮乐玩法，收到摇球机数据
function ScratchWinnerModel:GetSmallGameData()
    return private.GetScratchBallShakerData(this)
end

function private.GetScratchBallShakerData(self)
    return self.ShakerData
end

--刮刮乐玩法，收到摇球机数据
function ScratchWinnerModel.ResponeBallShaker(code, data)
    if (code == RET.RET_SUCCESS) then
        private.SaveScratchBallShakerData(this,data)
        Event.Brocast(EventName.Event_Receive_SmallGame_Data,true)
    else
        Event.Brocast(EventName.Event_Receive_SmallGame_Data,false)
    end
end

--刮刮乐玩法，返回摇奖结果
function ScratchWinnerModel.ResponeBallShakerResult(code, data)
    --附带其它-推送协议
    table.each(data and data.nextMessages, function(v)
        local body = Base64.decode(v.msgBase64)
        local ret = Proto.decode(v.msgId, body)
        ret.noResponeNotify = true
        Message.DispatchMessage(v.msgId, v.code, ret)
    end)

    if (code == RET.RET_SUCCESS) then
        if ViewList.ScratchWinnerExtraBallView then
            ViewList.ScratchWinnerExtraBallView:ShowExtraBall(data.index)
        end
    elseif code == RET.RET_GAME_NOT_EXIST then
        if BingoBangEntry.IsReplayBattle then
            if ViewList.ScratchWinnerExtraBallView then
                ViewList.ScratchWinnerExtraBallView:ReplayShowExtraBall()
            end
        else
            ---游戏不存在,主动拉取一次游戏结算数据
            this:ReqFetchSettle()
        end

    end

end


---刮刮乐玩法，摇球机使用球
function ScratchWinnerModel:ReqExtraBall(index)
    local gameId = ModelList.ScratchWinnerModel:GetGameId()
    -- self.SendMessage(MSG_ID.MSG_GAME_SCRATCH_EXTRA_BALL, { gameId = gameId, index = index })
    self.SendMessage(MSG_ID.MSG_GAME_BALL_SHAKER_USE, { gameId = gameId, index = index })
end

function ScratchWinnerModel:SignCardWithExtraBall(cardId,cellIndex)
    ---特殊处理,清理掉技能
    local cell = self.roundData:GetCell(tostring(cardId), cellIndex)
    cell:ResetSkill()
    cell:ResetJoker()
    ModelList.ScratchWinnerModel:SignCardWithPowerUpByIndex(cardId, cellIndex, false)
end



-----------------------------endregion 刮刮卡摇奖-------------


this.BaseMsgIdList = {
    { msgid = MSG_ID.MSG_GAME_SCRATCH_WINNER, func = this.ResponeEnterGame },
    -- { msgid = MSG_ID.MSG_GAME_SCRATCH_BALL_SHAKER, func = this.ResponeScratchBallShaker },
    -- { msgid = MSG_ID.MSG_GAME_SCRATCH_EXTRA_BALL, func = this.ResponeScratchBallShakerResult },
    --{ msgid = MSG_ID.MSG_GAME_BALL_SHAKER_INFO, func = this.ResponeScratchBallShaker },
    --{ msgid = MSG_ID.MSG_GAME_BALL_SHAKER_USE, func = this.ResponeScratchBallShakerResult },
}

return this
