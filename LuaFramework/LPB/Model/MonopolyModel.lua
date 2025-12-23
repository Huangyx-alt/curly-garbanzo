require "Model/ModelPart/BaseGameModel"
local bingoJokerMachine = require("Combat.Machine.BingoJokerMachine")

---  宝石皇后玩法
local MonopolyModel = BaseGameModel:New()
local this = MonopolyModel
local private = {}

local ItemIdMap = {
    251001, 251002
}

local GridIdMap = {
    251005, 251006, 251007, 251008
}

------需要子类重写，设置参数------------------------------------------------------------------------------
function MonopolyModel:InitModeOptions()
    self.gameType_ = PLAY_TYPE.PLAY_TYPE_MONOPOLY
    self.cityPlayID_ = 36
end

function MonopolyModel:GetQuestItemOffsetPos()
    return 29, -29
end

------------------------------------------------------------------------------------------------------

function MonopolyModel:InitData()
    self:InitModeOptions()
    self:SetSelfGameType(self.gameType_)
end

function MonopolyModel:ReqEnterGame()
    if not self:CheckCityIsOpen() then
        return
    end

    ModelList.BattleModel:DirectSetGameType(self.gameType_, self.cityPlayID_)
    ModelList.CityModel.SetPlayId(self.cityPlayID_)
    self:SetReadyState(0)

    local procedure = require "Procedure/ProcedureMonopoly"
    Facade.SendNotification(NotifyName.ShowUI, ViewList.SceneLoadingGameView,nil,nil,procedure:New())

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
    self.SendMessage(MSG_ID.MSG_GAME_LOAD_MONOPOLY, data)
end

function MonopolyModel:ReqSignCard(info)
    local cardIds = {}
    for i = 1, #info.total do
        if this:RefreshRoundDataByIndex(info.total[i].cardId, info.total[i].index, 1) then
            if not fun.is_include(info.total[i].cardId, cardIds) then
                table.insert(cardIds, info.total[i].cardId)
            end
            this:CalcuateBingo(info.total[i].cardId, info.total[i].index, info.total[i].number)
        end
    end
end

function MonopolyModel:RefreshRoundDataByIndex(cardid, cellIndex, signType, need_fly_item, mark)
    --父类处理
    local ret = this.__index:RefreshRoundDataByIndex(cardid, cellIndex, signType, need_fly_item, mark)

    --如果盖章触发技能/获得道具，添加sign计时，保证技能、道具动效播完
    local cell = self.roundData:GetCell(tostring(cardid), cellIndex)
    if cell and not cell:IsEmpty() then
        self.cardSignLogicDelayTime = os.time()
    end

    return ret
end

function MonopolyModel:InitBingoCfg()
    self.itemValueMap = self:GetBattleExtraInfo("baseMapItemValue")
    self.rollItemMap = self:GetBattleExtraInfo("rollItemResult")
    
    self.bingoScoreStageMap = Csv.GetData("new_bingo_rule", 62, "params")[1]
    self.bingoScoreTotalMap = {}
    for i, v in ipairs(self.bingoScoreStageMap) do
        if i == 1 then
            self.bingoScoreTotalMap[i] = self.bingoScoreStageMap[i]
        else
            self.bingoScoreTotalMap[i] = self.bingoScoreStageMap[i] + self.bingoScoreTotalMap[i - 1]
        end
    end

    self.oneBankValue = self.itemValueMap[tostring(GridIdMap[4])] or 100
end

function MonopolyModel:GetBingoScoreTotalMap()
    return self.bingoScoreTotalMap
end

function MonopolyModel.ResponeEnterGame(code, data)
    private.OnResEnterGame(this)
    if (code == RET.RET_SUCCESS) then
        this:SaveGameLoadData(data)
        this:SetReadyState(1)
        this:InitRoundData()
        this:InitExtraData(data.ext)
        this:InitBingoCfg()
        ModelList.BattleModel.SetBattleDouble(data.activityStatus)
        ModelList.BattleModel.SetIsJokerMachine(((data.jokerData and #data.jokerData > 0) or ModelList.CityModel:IsMaxBetRate()) and true or false)
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

function MonopolyModel:ResBingoInfo(code, data)
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
            LuaTimer:SetDelayFunction(MCT.delay_to_show_settle, function()
                this.loop_delay_settle = LuaTimer:SetDelayLoopFunction(0.1, 0.1, 100, function()
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

function MonopolyModel:OnReceiveSettle()
    if self:GetGameState() < GameState.ShowSettle then
        self:ShowSettle()
    end
end

function MonopolyModel:Clear()
    table.each(self.loop_delay_checks, function(v)
        LuaTimer:Remove(v)
    end)

    this.__index:Clear()
end

--- 卡面上的bingo表现有延迟，确保最新一个bingo效果能满足最低存活时间
function MonopolyModel:IsBingoShowComplete()
    local check = this.__index:IsBingoShowComplete()
    --cell被盖章后飞出道具及做动画的时间
    local checkTime = os.time() - self.cardSignLogicDelayTime > 2.5
    local isComplete = check and checkTime
    if isComplete then
        isComplete = CalculateBingoMachine.SeekInfo(99)
    end
    return isComplete
end

--- 需要等特效还有bingo画面啥的都得等播放完再弹出结算界面
--- 战斗结算前，检查彩球叫号器
function MonopolyModel:CheckJokerBallSprayer(callBack)
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

function MonopolyModel:SetRoundGiftData(card_id, cell_index, new_gift, number, skill_id, self_bingo, powerId, extraPos)
    this.__index:SetRoundGiftData(card_id, cell_index, new_gift, number, skill_id, self_bingo, powerId, extraPos)
    --[[没有bingo技能的玩法不用处理这块
    if powerId == xxxx then
        --记录猪技能数据，结束上传
        table.insert(self.cachedSkillDataCache, {
            cardId = tonumber(card_id),
            cellIndex = cell_index,
            extraPos = extraPos,
        })
    end
    --]]
end

function MonopolyModel:UploadGameData(gameType, quiteType)
    if self.roundData ~= nil and self.roundData.GetRoundData ~= nil then
        --self:PreCalcuatePigSkill()
    end
    this.__index.UploadGameData(self, gameType, quiteType)
end

--[[
---提前计算好猪技能的数据，上传到服务器
function MonopolyModel:PreCalcuatePigSkill()
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
        --添加ExtraData，结算时通知服务器某个                                                                                                   类型达成了Bingo
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

function MonopolyModel:CheckBingoSkillExtraPosValid(cardId, extraPos)
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
--]]

--确认bingo场景加载完成，通知后端开始叫号
function MonopolyModel:ReqGameReady()
    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    if bingoView then
        local cardView = bingoView:GetCardView()
        if cardView then
            cardView:PreviewBankLocation()
        end
    end

    LuaTimer:SetDelayFunction(2.5, function()
        BattleMachineList.StartBattleMachine()
        BattleModuleList.EnableUpdate()
        Event.Brocast(EventName.Recorder_Data, 5002, nil)
    end, nil, LuaTimer.TimerType.Battle)
end

---------------bingo表现队列逻辑-------------------------
---盖章后立即调用
---@param diceType number 骰子类型 1-普通骰子 2-额外骰子
---@param diceIndex number 骰子索引, 1-5
function MonopolyModel:CollectCardBingo(cardId, diceType)
    log.r("MonopolyModelcoo1 ",cardId,diceType)
    CalculateBingoMachine:SetInfo(1, cardId, diceType)
end

---盖章后立即调用
---@param diceType number 骰子类型 1-普通骰子 2-额外骰子
---@param diceIndex number 骰子索引, 1-5
function MonopolyModel:CollectCardScore(cardId, score)
    log.r("MonopolyModel:CollectCardScore ",cardId, score)
    CalculateBingoMachine:SetInfo(1, cardId, score)
end

---收集到骰子或额外bingo时调用,
---@param diceType number 骰子类型 1-普通骰子 2-额外骰子
---@param diceIndex number 骰子索引, 1-5
function MonopolyModel:CheckCardBingo(cardId, diceType, diceIndex)
    log.r("MonopolyModelcoo2 ",cardId,diceType)
    return CalculateBingoMachine:SetInfo(2, cardId, diceType, diceIndex)
end

---@param cardId number
---bingo效果结束后调用
function MonopolyModel:CheckCardBingo2(cardId)
    log.r("MonopolyModelcoo3 ",cardId)
    CalculateBingoMachine.SeekInfo(1, cardId)
end

function MonopolyModel:UpdateUpLoadDataExt(ext)
    ext = JsonToTable(ext)
    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    if bingoView then
        --local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
        local cardView = bingoView:GetCardView()
        if cardView then
            --undo
            --local bingoItems = nil
            --ext.cardAddPUBingoItems = bingoItems
        end
    end
    ext = TableToJson(ext)
    return ext
end

function MonopolyModel:IsTriggerExtraReward()
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
        log.log("MonopolyModel:IsTriggerExtraReward 判断条件未达成", maxRate, curRate)
        return false
    end

    return curRate >= maxRate
end

function MonopolyModel:GetExtraRewardTipIconSprite()
    local curSprite = AtlasManager:GetSpriteByName("MonopolyHallAtlas", "MonopolyTitleSdm")
    return curSprite
end

function MonopolyModel:GetBankValues(bankId)
    bankId = bankId or ItemIdMap[1]
    local ret = Csv.GetData("item", bankId, "result")
    local v1, v2 = 100, 200
    if ret and ret[2] and ret[3] then
        v1 = ret[2]
        v2 = ret[3]
    else
        log.log("MonopolyModel:GetBankValues cfg error")
    end
    return v1, v2
end

--------------end bingo表现队列逻辑-------------------------

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

--[[
function private.GetCellItemType(cellData)
    local type

    table.each(cellData.hide_gift, function(v2)
        if 4 == math.floor(v2.id / 10000000) then
            local itemId = Csv.GetData("item_synthetic", v2.id, "itemid")
            local cfg = Csv.GetData("item", itemId, "result")
            if cfg[1] == 62 then
                type = itemId % 10
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
--]]

this.BaseMsgIdList = {
    { msgid = MSG_ID.MSG_GAME_LOAD_MONOPOLY, func = this.ResponeEnterGame },
}

return this