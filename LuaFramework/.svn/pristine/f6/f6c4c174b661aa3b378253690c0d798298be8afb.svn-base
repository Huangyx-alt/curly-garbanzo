require 'Model/ModelPart/BaseGameModel'
local bingoJokerMachine = require("Combat.Machine.BingoJokerMachine")

---@class ThievesGameModel : BaseGameModel
local ThievesGameModel = BaseGameModel:New()
local this = ThievesGameModel
this.rocketSettleData = nil
this.puSkillDataCache = {}
this.bingoSkillDataCache = {}
this.puUsedPos = {}
this.cardSignLogicDelayTime = 0
local private = {}

function ThievesGameModel:InitData()
    if not self:IsInit() then
        this:SetSelfGameType(PLAY_TYPE.PLAY_TYPE_CAT_THIEF)
        self:SetInit()
    end
end

function ThievesGameModel:GetQuestItemOffsetPos(itemId)
    local itemType = Csv.GetItemOrResource(itemId, "item_type")
    if itemType == 33 then
        --火山活动道具
        return 32.6, -39.3
    end
    
    return 30, -31
end

--音符道具投放位置
function ThievesGameModel:GetWinZoneItemOffsetPos()
    return -36.5, 29.5
end

function ThievesGameModel:ReqEnterGame()
    if not this:CheckCityIsOpen() then
        return
    end
    ModelList.BattleModel:DirectSetGameType(PLAY_TYPE.PLAY_TYPE_CAT_THIEF, 24)
    ModelList.CityModel.SetPlayId(24)
    this:SetReadyState(0)
    local procedure = require "Procedure/ProcedureThieves"
    Facade.SendNotification(NotifyName.ShowUI, ViewList.SceneLoadingGameView, nil, nil, procedure:New())
    local cardNum = ModelList.CityModel:GetCardNumber()
    local betRate = ModelList.CityModel:GetBetRate()
    local powerupGear, powerupId = ModelList.CityModel:GetPowerupGear()
    local city = ModelList.CityModel:GetCity()
    local coupon = ModelList.CouponModel.get_currentCouponIdByCardNum(cardNum)
    local useId = ModelList.CouponModel.get_currentCouponUseIdByCardNum(cardNum)
    ModelList.CityModel:SavePreviousPlayInfo()
    this:ResetSettleCode()
    local hideCardAuto = ModelList.BattleModel.GetIsAutoSign() and 1 or 0
    this.SendMessage(MSG_ID.MSG_GAME_CAT_THIEF, { cardNum = cardNum, rate = betRate, powerUpId = tonumber(powerupId),
                                                  cityId = city, couponId = coupon, useCouponId = useId, playId = ModelList.CityModel.GetPlayIdByCity(city),
                                                  hideCardAuto = hideCardAuto });
end

function ThievesGameModel:ReqSignCard(info)
    local cardIds = {}
    for i = 1, #info.total do
        if this:RefreshRoundDataByIndex(info.total[i].cardId, info.total[i].index, 1, nil, info.total[i].mask) then
            if not fun.is_include(info.total[i].cardId, cardIds) then
                table.insert(cardIds, info.total[i].cardId)
            end
            this:CalculateJackpot2(info.total[i].cardId, info.total[i].index, info.total[i].number)
        end
    end
end

function ThievesGameModel:RefreshRoundDataByIndex(cardid, cellIndex, signType, need_fly_item, mark, extraPos)
    local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()

    ---盖章成功，增加检查监狱层数
    local signSuccCall = function()
        local affectCellList = BattleLogic.GetLogicModule(LogicName.Card_logic):ReduceLogicLockTiers(cardid, cellIndex)
        if #affectCellList > 0 then
            self.cardSignLogicDelayTime = os.time()
        end
        cardView:AffectRoundCellLockTiers(cardid, affectCellList, extraPos)
    end

    --父类处理
    return self.__index:RefreshRoundDataByIndex(cardid, cellIndex, signType, need_fly_item, mark, nil, signSuccCall)
end

function ThievesGameModel.ResEnterGame(code, data)
    private.OnResEnterGame(data)
    if (code == RET.RET_SUCCESS) then
        this:SaveGameLoadData(data)
        this:SetReadyState(1)
        this:InitRoundData()
        this:InitExtraData(data.ext)
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

function ThievesGameModel:ResBingoInfo(code, data)
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
                    this:ShowSettle()
                    LuaTimer:Remove(this.loop_delay_settle)
                end, nil, nil, LuaTimer.TimerType.Battle)
            end)
        end
    else
        log.w("同步Bingo错误")
    end
end

function ThievesGameModel:OnReceiveSettle()
    if self:GetGameState() < GameState.ShowSettle then
        self:ShowSettle()
    end
end

function ThievesGameModel:Clear()
    table.each(self.loop_delay_checks, function(v)
        LuaTimer:Remove(v)
    end)

    this.rocketSettleData = nil
    this.__index:Clear()
end

--- 卡面上的bingo表现有延迟，确保最新一个bingo效果能满足最低存活时间
function ThievesGameModel:IsBingoShowComplete()
    local check = self.__index:IsBingoShowComplete()
    --cell被盖章后飞出道具及做动画的时间
    local checkTime = os.time() - self.cardSignLogicDelayTime > 3
    return check and checkTime
end

--刷新盖章计时
function ThievesGameModel:RefreshSignLogicDelayTime()
    self.cardSignLogicDelayTime = os.time()
end

--- 需要等特效还有bingo画面啥的都得等播放完再弹出结算界面
--- 战斗结算前，检查彩球叫号器
function ThievesGameModel:CheckJokerBallSprayer(callBack)
    local haveJokerBall = ModelList.BattleModel.HasJokerBallSprayer()
    private.StartSkillEmptyCheck(function()
        local cb = function()
            if haveJokerBall then
                --有彩球喷射器，等技能、盖章效果播完再继续彩球喷射器
                --这里等4秒是因为彩球喷射器动画太长，要等动画播完才走盖章逻辑
                LuaTimer:SetDelayFunction(4, function()
                    private.StartSkillEmptyCheck(function()
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

function ThievesGameModel:SetRoundGiftData(card_id, cell_index, new_gift, number, skill_id, self_bingo, powerId, extraPos)
    self.__index.SetRoundGiftData(self, card_id, cell_index, new_gift, number, skill_id, self_bingo, powerId, extraPos)
    if powerId == 176 then
        table.insert(this.puSkillDataCache, {
            cardId = tonumber(card_id),
            cellIndex = cell_index,
        })
    end
    if powerId == 177 then
        table.insert(this.bingoSkillDataCache, {
            cardId = tonumber(card_id),
            cellIndex = cell_index,
        })
    end
end

--请求游戏结束
function ThievesGameModel:ReqQuitBingoGame(pre_quit, gameType)
    --回放模式下，需要预计算数据
    if fun.IsEditor() then
        if BingoBangEntry.IsReplayBattle then
            if self.roundData ~= nil and self.roundData.GetRoundData ~= nil then
                self:PreCalculatePuSkill()
                self:PreCalculateBingoSkill()
            end
        end
    end

    self.__index.ReqQuitBingoGame(self, pre_quit, gameType)
end

function ThievesGameModel:UploadGameData(gameType, quiteType)
    if self.roundData ~= nil and self.roundData.GetRoundData ~= nil then
        self:PreCalculatePuSkill()
        self:PreCalculateBingoSkill()
    end
    self.__index.UploadGameData(self, gameType, quiteType)
end

-----------------pu技能----------------------------------------------

function ThievesGameModel:PreCalculatePuSkill()
    table.each(this.puSkillDataCache, function(v)
        local cellData = self:GetRoundData(v.cardId, v.cellIndex)
        if not cellData:IsNotSign() then
            return
        end

        local puData = self:GetPuSkillData(v.cardId, v.cellIndex)
        puData.isPreCheck = 1

        --添加ExtraData，结算时通知服务器
        self:GetRoundData(v.cardId):AddExtraUpLoadData("wolfClaw", puData, "pos")
    end)
end

function ThievesGameModel:GetValidThievesForPuSkill(cardId, cellIndex, excludePos)
    cardId = tonumber(cardId)

    local puData = self:GetPuSkillData(cardId, cellIndex)
    if ModelList.BattleModel:IsRocket() then
        return BattleTool.GetFromServerPos(puData.wolfPos)
    end

    local logicModule, ret, needCount = BattleLogic.GetLogicModule(LogicName.Card_logic), {}, 0
    if logicModule:IsJackpot(cardId) then
        puData.wolfPos = { 24 }
        return
    end

    if #puData.wolfPos > 0 then
        table.each(puData.wolfPos, function(v)
            local wolfPos = ConvertServerPos(v)
            local isBreak = logicModule:IsThievesUnLocked(cardId, wolfPos)
            if not isBreak then
                table.insert(ret, wolfPos)
            else
                needCount = needCount + 1
            end
        end)
    else
        needCount = 1
    end

    if needCount > 0 then
        local posList = logicModule:GetLockedThievesForPreCal(cardId, needCount, excludePos)
        table.each(posList, function(v)
            table.insert(ret, v)
        end)
    end

    puData.wolfPos = BattleTool.ConvertedToServerPosList(ret)
    return ret
end

function ThievesGameModel:GetPuSkillData(cardId, cellIndex)
    cardId = tonumber(cardId)
    local data = self:GetBattleExtraInfo("wolfClawData")
    if not data then
        return
    end

    local puData = table.find(data, function(k, v)
        local pos = ConvertServerPos(v.pos)
        return pos == cellIndex and v.cardId == cardId
    end)

    if not puData then
        --后端未提供数据，前端自己算
        puData = {
            cardId = cardId,
            pos = ConvertCellIndexToServerPos(cellIndex),
            wolfPos = {},
        }
        --更改本地数据
        table.insert(data, puData)
    end

    return puData
end

-----------------bingo技能----------------------------------------------

function ThievesGameModel:PreCalculateBingoSkill()
    table.each(this.bingoSkillDataCache, function(v)
        local cellData = self:GetRoundData(v.cardId, v.cellIndex)
        if not cellData:IsNotSign() then
            return
        end

        local bingoSkillData = self:GetBingoSkillData(v.cardId, v.cellIndex)
        local wolfPos = self:GetValidThievesForBingoSkill(v.cardId, v.cellIndex)
        bingoSkillData.isPreCheck = 1

        --添加ExtraData，结算时通知服务器
        self:GetRoundData(v.cardId):AddExtraUpLoadData("wolfMoon", bingoSkillData, "pos")
    end)
end

function ThievesGameModel:GetValidThievesForBingoSkill(cardId, cellIndex, excludePos)
    cardId = tonumber(cardId)

    local bingoSkillData = self:GetBingoSkillData(cardId, cellIndex)
    if ModelList.BattleModel:IsRocket() then
        return ConvertServerPos(bingoSkillData.wolfPos)
    end

    local logicModule, ret = BattleLogic.GetLogicModule(LogicName.Card_logic)
    if logicModule:IsJackpot(cardId) then
        bingoSkillData.wolfPos = 24
        return
    end
    
    if bingoSkillData.wolfPos and bingoSkillData.wolfPos > 0 then
        local pos = ConvertServerPos(bingoSkillData.wolfPos)
        local isBreak = logicModule:IsThievesUnLocked(cardId, pos)
        if isBreak then
            ret = logicModule:GetLockedThievesForPreCal(cardId, 1, excludePos, true)
            ret = ret[1]
        else
            ret = pos
        end
    else
        ret = logicModule:GetLockedThievesForPreCal(cardId, 1, excludePos, true)
        ret = ret[1]
    end

    if not ret then
        bingoSkillData.wolfPos = 0
        return
    end

    bingoSkillData.wolfPos = ConvertCellIndexToServerPos(ret)
    return ret
end

function ThievesGameModel:GetBingoSkillData(cardId, cellIndex)
    cardId = tonumber(cardId)
    local data = self:GetBattleExtraInfo("wolfMoon")
    if not data then
        return
    end

    local bingoSkillData = table.find(data, function(k, v)
        local pos = ConvertServerPos(v.pos)
        return pos == cellIndex and v.cardId == cardId
    end)

    if not bingoSkillData then
        --后端未提供数据，前端自己算
        bingoSkillData = {
            cardId = cardId,
            pos = ConvertCellIndexToServerPos(cellIndex),
            wolfPos = 0,
        }
        --更改本地数据
        table.insert(data, bingoSkillData)
    end

    return bingoSkillData
end

-----------------私有方法----------------------------------------------

---开始一场新的对局，初始化本地数据
function private.OnResEnterGame(loadData)
    this.puSkillDataCache = {}
    this.bingoSkillDataCache = {}
    this.loop_delay_checks = {}
    private.InitPowerUpUseCells(loadData)
end

function private.InitPowerUpUseCells(loadData)
    this.puUsedPos = {}

    local powerUpData = loadData and loadData.powerUpData
    if powerUpData then
        table.each(powerUpData, function(puData)
            if puData.type == 1 then
                table.each(puData.cardPowerUpEffect, function(ue)
                    this.puUsedPos[ue.cardId] = this.puUsedPos[ue.cardId] or {}
                    local temp = this.puUsedPos[ue.cardId]
                    local posList = BattleTool.GetFromServerPos(ue.posList)
                    fun.add_table(temp, posList)
                    this.puUsedPos[ue.cardId] = fun.table_unique(temp)
                end)
            end
        end)
    end
end

function private.StartSkillEmptyCheck(cb)
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
    table.insert(this.loop_delay_checks, loop_delay_check)
end

this.MsgIdList = {
    { msgid = MSG_ID.MSG_GAME_CAT_THIEF, func = this.ResEnterGame },
}

return this