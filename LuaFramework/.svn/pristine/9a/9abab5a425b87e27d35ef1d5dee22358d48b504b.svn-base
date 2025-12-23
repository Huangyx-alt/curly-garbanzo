require "Model/ModelPart/BaseGameModel"
local bingoJokerMachine = require("Combat.Machine.BingoJokerMachine")

---XXXX玩法
local GotYouModel = BaseGameModel:New()
local this = GotYouModel
local private = {}

------需要子类重写，设置参数------------------------------------------------------------------------------
function GotYouModel:InitModeOptions()
    self.gameType_ = PLAY_TYPE.PLAY_TYPE_THREE_PIGS
    self.cityPlayID_ = 32
end

function GotYouModel:GetQuestItemOffsetPos()
    return 26.5, -32
end

------------------------------------------------------------------------------------------------------

function GotYouModel:InitData()
    self:InitModeOptions()
    self:SetSelfGameType(self.gameType_)
end

function GotYouModel:ReqEnterGame()
    if not self:CheckCityIsOpen() then
        return
    end

    ModelList.BattleModel:DirectSetGameType(self.gameType_, self.cityPlayID_)
    ModelList.CityModel.SetPlayId(self.cityPlayID_)
    self:SetReadyState(0)

    local procedure = require "Procedure/ProcedureGotYou"
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
    self.SendMessage(MSG_ID.MSG_GAME_THREE_PIGS, data)
end

function GotYouModel:ReqSignCard(info)
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

function GotYouModel:RefreshRoundDataByIndex(cardid, cellIndex, signType, need_fly_item, mark)
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
function GotYouModel.ResponeEnterGame(code, data)
    private.OnResEnterGame(this)
    if (code == RET.RET_SUCCESS) then
        log.log("GotYouModel.ResponeEnterGame bingoRuleId ", data.bingoRuleId)
        this:SaveGameLoadData(data)
        this:SetReadyState(1)
        this:InitRoundData()
        this:InitExtraData(data.ext)
        private.ClearSmallGameData( this )
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

function GotYouModel:ResBingoInfo(code, data)
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

function GotYouModel:OnReceiveSettle()
    if self:GetGameState() < GameState.ShowSettle then
        self:ShowSettle()
    end
end

function GotYouModel:Clear()
    table.each(self.loop_delay_checks, function (v)
        LuaTimer:Remove(v)
    end)

    this.__index:Clear()
    private.ClearSmallGameData()
end

--- 卡面上的bingo表现有延迟，确保最新一个bingo效果能满足最低存活时间
function GotYouModel:IsBingoShowComplete()
    local check = this.__index:IsBingoShowComplete()

    --cell被盖章后飞出道具及做动画的时间
    local checkTime = os.time() - self.cardSignLogicDelayTime > 2.5
    return check and checkTime
end

--- 需要等特效还有bingo画面啥的都得等播放完再弹出结算界面
--- 战斗结算前，检查彩球叫号器
function GotYouModel:CheckJokerBallSprayer(callBack)
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

--undo wait powerid
function GotYouModel:SetRoundGiftData(card_id, cell_index, new_gift, number, skill_id, self_bingo, powerId, extraPos)
    this.__index:SetRoundGiftData(card_id, cell_index, new_gift, number, skill_id, self_bingo, powerId, extraPos)
    if powerId == 190 then
        --记录猪技能数据，结束上传
        table.insert(self.cachedSkillDataCache, {
            cardId = tonumber(card_id),
            cellIndex = cell_index,
            extraPos = extraPos,
        })
    end
end

function GotYouModel:UploadGameData(gameType, quiteType)
    if self.roundData ~= nil and self.roundData.GetRoundData ~= nil then
        self:PreCalcuatePigSkill()
    end
    this.__index:UploadGameData(gameType, quiteType)
end

function GotYouModel:PlayBattleOverSound()
    UISound.play("minerbattleover")
end

---提前计算好猪技能的数据，上传到服务器
function GotYouModel:PreCalcuatePigSkill()
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

function GotYouModel:CheckBingoSkillExtraPosValid(cardId, extraPos)
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

function GotYouModel:GetCurrentCollectLevel()
    local level = self:GetBattleExtraInfo("longStage")
    log.log("GotYouModel:GetCurrentCollectLevel the level is ", level)
    level = level and tonumber(level) or 1
    return level
end

--[[
function GotYouModel:GetCollectLevelMapByCardId(cardId)
    if not cardId then
        log.log("GotYouModel:GetCollectLevelMapByCardId card id is nil")
        return {1, 0, 0, 0, 0}
    end
    local itemMaps = self:GetBattleExtraInfo("trackInfo")
    if not itemMaps then
        log.log("GotYouModel:GetCollectLevelMapByCardId no trackInfo data")
        return {1, 0, 0, 0, 0}
    end

    for i, v in pairs(itemMaps) do
        if tonumber(v.cardId) == tonumber(cardId) then
            return v.track
        end
    end

    log.log("GotYouModel:GetCollectLevelMapByCardId no find trackInfo match cardId:", cardId)
    return {1, 0, 0, 0, 0}
end

function GotYouModel:GetCollectLevelByCardIdAndTrackIdx(cardId, idx)
    if not cardId or not idx then
        log.log("GotYouModel:GetCollectLevelByCardIdAndTrackIdx Error 1", cardId, idx)
        return 0
    end

    local itemMaps = self:GetCollectLevelMapByCardId(cardId)
    if not itemMaps then
        log.log("GotYouModel:GetCollectLevelByCardIdAndTrackIdx Error 2", cardId, idx)
        return 0
    else
        if itemMaps[idx] == nil then
            log.log("GotYouModel:GetCollectLevelByCardIdAndTrackIdx Error3 ", cardId, idx)
            return 0
        else
            return itemMaps[idx]
        end
    end
end

function GotYouModel:GetCollectiveMaxCount(collectType, collectLevel)
    return 1
end

function GotYouModel:CellIndex2Col(idx)
    return math.floor((idx + 4) / 5)
end
--]]

function GotYouModel:GetCellColor(idx)
    --[[
    local colorMap = {
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
    }
    --]]

    --[[
    local colorMap = {
        4, 3, 2, 3, 4,
        3, 2, 1, 2, 3,
        2, 1, 4, 1, 2,
        3, 2, 1, 2, 3,
        4, 3, 2, 3, 4,
    }
    --]]

    ---[[
    local colorMap = {
        2, 2, 3, 2, 2,
        3, 3, 2, 3, 2,
        2, 2, 3, 3, 3,
        3, 3, 2, 3, 2,
        2, 2, 3, 2, 2,
    }
    --]]

    return colorMap[idx] or 1
end

function GotYouModel:PropId2GoupId(propId)
    if propId >= 211001 and propId <= 211003 then
        return propId - 211001 + 1
    end

    log.log("GotYouModel:PropId2GoupId(propId) params is Error", propId)
end

--确认bingo场景加载完成，通知后端开始叫号
function GotYouModel:ReqGameReady()
    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    if bingoView then
        --local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
        local cardView = bingoView:GetCardView()
        if cardView then
            cardView:ShowWolfEnter()
        end
    end

    LuaTimer:SetDelayFunction(1.5, function ()
        BattleMachineList.StartBattleMachine()
        BattleModuleList.EnableUpdate()
        Event.Brocast(EventName.Recorder_Data, 5002, nil)
    end, nil, LuaTimer.TimerType.Battle)
end

function GotYouModel:IsTriggerExtraReward()
    local curRate = ModelList.CityModel:GetBetRate()
    -- local playid = ModelList.CityModel.GetPlayIdByCity()
    -- local minBet = Csv.GetData("city_play", playid, "supermatch_bet")
    -- if minBet == 0 then return false end
    if ModelList.UltraBetModel:IsActivityValid() then
        return true
    end

    return curRate >= 8
end

function GotYouModel:GetExtraRewardTipIconSprite()
    local curSprite = AtlasManager:GetSpriteByName("GotYouHallAtlas", "PigCardTitleSdm")
    return curSprite
end



------------------------------------小游戏----------------------


--玩法小游戏，金钱大厦数据
function GotYouModel.ResponeMansionInfo(code, data)
    if code == RET.RET_SUCCESS then
        if not data.gameId or data.gameId == "" then
            --为空重置游戏
            --return
        end
        this.MansionInfo = data
        ---不在战斗中,弹窗
        if not ModelList.BattleModel:IsGameing() then
            ViewList.GotYouSmallGameView = require("View.Bingo.SettleModule.UIView.SmallGame.GotYou.GotYouSmallGameView")
            --Facade.SendNotification(NotifyName.ShowUI,ViewList.GotYouSmallGameView,nil,nil,2)
            Facade.SendNotification(NotifyName.HallCity.Function_icon_click,"GotYouSmallGameView",true)
        end

        --if ViewList.GotYouSmallGameView then
        --    ViewList.GotYouSmallGameView:Show(data)
        --end
    end
end

---GetSmallGameData结算前小火箭之后的,GetSmallGameData2是结算详情面板之后的
function GotYouModel:GetSmallGameData2()
    return this.MansionInfo
end

function GotYouModel:GetMansionSpinInfo()
    if not this.MansionSpinInfo then
        this.MansionSpinInfo = {
            rate = 2,
            totalBet = 2000,
            freeSpinTimes = 0,
            --position = 23,
            --position = 22,
            position = 24,
            reward = {
                type = 1,
                freeSpinTimes = 3,
                coinReward = 5000,
                positions = { 5, 10, 15 }
                --positions = { 10 }
            },
            totalWin = 2000,
        }
    end
    return this.MansionSpinInfo
end

function GotYouModel:ReqMansionInfo(gameId, gameRate)
    self.SendMessage(MSG_ID.MSG_GAME_MONEY_MANSION_INFO, { gameId = gameId, gameRate = gameRate })
end

--玩法小游戏，金钱大厦Spin
function GotYouModel.ResponeMansionSpin(code, data)
    if code == RET.RET_SUCCESS then
        this.MansionSpinInfo = data
        if ViewList.GotYouSmallGameView then
            ViewList.GotYouSmallGameView:OnSpinReward(data)
        end
    end
end

function GotYouModel:ReqMansionSpin(rate)
    self.SendMessage(MSG_ID.MSG_GAME_MONEY_MANSION_SPIN, { rate = rate })
end


------------------------------------end 小游戏----------------------


-----------------私有方法----------------------------------------------

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

function private.ClearSmallGameData()
    this.MansionInfo = nil
    this.MansionSpinInfo = nil
end

this.BaseMsgIdList = {
    { msgid = MSG_ID.MSG_GAME_THREE_PIGS,         func = this.ResponeEnterGame },
    { msgid = MSG_ID.MSG_GAME_MONEY_MANSION_INFO, func = this.ResponeMansionInfo },
    { msgid = MSG_ID.MSG_GAME_MONEY_MANSION_SPIN, func = this.ResponeMansionSpin },
}

return this
