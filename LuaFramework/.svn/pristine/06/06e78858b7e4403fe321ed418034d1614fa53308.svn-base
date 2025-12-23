require "Model/ModelPart/BaseGameModel"
local bingoJokerMachine = require("Combat.Machine.BingoJokerMachine")

---  宝石皇后玩法
local SolitaireModel = BaseGameModel:New()
local this = SolitaireModel
local private = {}
local MinItemId = 241001
local MidItemId = 241013
local MaxItemId = 241027

------需要子类重写，设置参数------------------------------------------------------------------------------
function SolitaireModel:InitModeOptions()
    self.gameType_ = PLAY_TYPE.PLAY_TYPE_SOLITAIRE
    self.cityPlayID_ = 35
end

function SolitaireModel:GetQuestItemOffsetPos()
    return 29, -29
end

------------------------------------------------------------------------------------------------------

function SolitaireModel:InitData()
    self:InitModeOptions()
    self:SetSelfGameType(self.gameType_)
end

function SolitaireModel:ReqEnterGame()
    if not self:CheckCityIsOpen() then
        return
    end

    ModelList.BattleModel:DirectSetGameType(self.gameType_, self.cityPlayID_)
    ModelList.CityModel.SetPlayId(self.cityPlayID_)
    self:SetReadyState(0)

    local procedure = require "Procedure/ProcedureSolitaire"
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
    self.SendMessage(MSG_ID.MSG_GAME_LOAD_SOLITAIRE, data)
end

function SolitaireModel:ReqSignCard(info)
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

function SolitaireModel:RefreshRoundDataByIndex(cardid, cellIndex, signType, need_fly_item, mark)
    --父类处理
    local ret = this.__index:RefreshRoundDataByIndex(cardid, cellIndex, signType, need_fly_item, mark)

    --如果盖章触发技能/获得道具，添加sign计时，保证技能、道具动效播完
    local cell = self.roundData:GetCell(tostring(cardid), cellIndex)
    if cell and not cell:IsEmpty() then
        self.cardSignLogicDelayTime = os.time()
    end

    return ret
end

function SolitaireModel.ResponeEnterGame(code, data)
    private.OnResEnterGame(this)
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

function SolitaireModel:ResBingoInfo(code, data)
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

function SolitaireModel:OnReceiveSettle()
    if self:GetGameState() < GameState.ShowSettle then
        self:ShowSettle()
    end
end

function SolitaireModel:Clear()
    table.each(self.loop_delay_checks, function(v)
        LuaTimer:Remove(v)
    end)

    this.__index:Clear()
end

--- 卡面上的bingo表现有延迟，确保最新一个bingo效果能满足最低存活时间
function SolitaireModel:IsBingoShowComplete()
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
function SolitaireModel:CheckJokerBallSprayer(callBack)
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

function SolitaireModel:SetRoundGiftData(card_id, cell_index, new_gift, number, skill_id, self_bingo, powerId, extraPos)
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

function SolitaireModel:UploadGameData(gameType, quiteType)
    if self.roundData ~= nil and self.roundData.GetRoundData ~= nil then
        --self:PreCalcuatePigSkill()
    end
    this.__index.UploadGameData(self, gameType, quiteType)
end

--[[
---提前计算好猪技能的数据，上传到服务器
function SolitaireModel:PreCalcuatePigSkill()
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
--]]

--[[
function SolitaireModel:CheckBingoSkillExtraPosValid(cardId, extraPos)
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
function SolitaireModel:ReqGameReady()
    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    if bingoView then
        local cardView = bingoView:GetCardView()
        if cardView then
            cardView:OnGameReady()
        end
    end

    local delayTime = 2.5
    if self:IsTriggerExtraReward() then
        delayTime = 3.3
    end
    LuaTimer:SetDelayFunction(delayTime, function()
        BattleMachineList.StartBattleMachine()
        BattleModuleList.EnableUpdate()
        Event.Brocast(EventName.Recorder_Data, 5002, nil)
    end, nil, LuaTimer.TimerType.Battle)
end

----------------------------------------bingo表现队列逻辑----------------------------------------Begin
---某组最后一个元素盖章后立即调用（龙，joker) 更新数据有新bingo达成
---@param itemType number 类型 1,2-普通poker 3-joker
function SolitaireModel:CollectCardBingo(cardId, itemType)
    log.log("SolitaireModel->CollectCardBingo", cardId, itemType)
    CalculateBingoMachine:SetInfo(1, cardId, itemType)
end

---某组最后一个元素完成收集后调用（龙，joker) 新bingo可以表现了（若有）
---@param itemType number 类型 1,2-普通poker 3-joker
function SolitaireModel:CheckCardBingo(cardId, itemType)
    log.log("SolitaireModel->CheckCardBingo", cardId, itemType)
    CalculateBingoMachine:SetInfo(2, cardId, itemType)
end

---@param cardId number
---bingo效果结束后调用（某卡当前的bingo表现已完成）
function SolitaireModel:FinishCurCardBingo(cardId)
    log.log("SolitaireModel->FinishCurCardBingo", cardId)
    CalculateBingoMachine.SeekInfo(1, cardId)
end

----------------------------------------bingo表现队列逻辑----------------------------------------End

function SolitaireModel:UpdateUpLoadDataExt(ext)
    -- ext = JsonToTable(ext)

    -- ext = TableToJson(ext)
    return ext
end

function SolitaireModel:IsTriggerExtraReward()
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
        log.log("SolitaireModel:IsTriggerExtraReward 判断条件未达成", maxRate, curRate)
        return false
    end

    return curRate >= maxRate
end

function SolitaireModel:GetExtraRewardTipIconSprite()
    local curSprite = AtlasManager:GetSpriteByName("SolitaireHallAtlas", "SolitaireTitleSdm")
    return curSprite
end

function SolitaireModel:GetSecondItemsByCardId(cardId)
    if not cardId then
        log.log("SolitaireModel:GetSecondItemsByCardId card id is nil")
        return nil
    end
    local itemMaps = self:GetBattleExtraInfo("secondCardItemIdArr")
    if not itemMaps then
        log.log("SolitaireModel:GetSecondItemsByCardId no trackInfo data")
        return nil
    end

    for i, v in pairs(itemMaps) do
        if tonumber(v.cardId) == tonumber(cardId) then
            return v.itemIds
        end
    end

    log.log("SolitaireModel:GetSecondItemsByCardId no find trackInfo match cardId:", cardId)
    return nil
end

function SolitaireModel:GetPearPositionListByCardId(cardId)
    if not cardId then
        log.log("SolitaireModel:GetPearPositionListByCardId card id is nil")
        return nil
    end
    local itemMaps = self:GetBattleExtraInfo("bingoPearlPosArr")
    if not itemMaps then
        log.log("SolitaireModel:GetPearPositionListByCardId no trackInfo data")
        return nil
    end

    for i, v in pairs(itemMaps) do
        if tonumber(v.cardId) == tonumber(cardId) then
            return v.pos
        end
    end

    log.log("SolitaireModel:GetPearPositionListByCardId no find trackInfo match cardId:", cardId)
    return nil
end

function SolitaireModel:ItemId2Group(itemId)
    if not itemId then
        log.log("SolitaireModel:ItemId2Group itemId is nil")
        return 1
    end

    if itemId < MinItemId then
        log.log("SolitaireModel:ItemId2Group itemId is invalid 1", itemId)
        return 1
    end

    if itemId > MaxItemId then
        log.log("SolitaireModel:ItemId2Group itemId is invalid 2", itemId)
        return 1
    end

    if itemId == MaxItemId then
        return 3
    elseif itemId > MidItemId then
        return 2
    else
        return 1
    end
end

function SolitaireModel:GenNominalValue(itemId)
    if not itemId then
        log.log("SolitaireModel:GenNominalValue itemId is nil")
        return 1, 1
    end

    if itemId < MinItemId then
        log.log("SolitaireModel:GenNominalValue itemId is invalid 1", itemId)
        return 1, 1
    end

    if itemId > MaxItemId then
        log.log("SolitaireModel:GenNominalValue itemId is invalid 2", itemId)
        return 1, 1
    end

    if itemId == MaxItemId then
        return 1, 3
    elseif itemId > MidItemId then
        return itemId - MidItemId, 2
    else
        return itemId - MinItemId + 1, 1
    end
end

function SolitaireModel:GetIconName(itemId)
    if not itemId then
        log.log("SolitaireModel:GetIconName itemId is nil")
        return "PkBlack1"
    end

    if itemId < MinItemId then
        log.log("SolitaireModel:GetIconName itemId is invalid 1", itemId)
        return "PkBlack1"
    end

    if itemId > MaxItemId then
        log.log("SolitaireModel:GetIconName itemId is invalid 2", itemId)
        return "PkBlack1"
    end

    local data = Csv.GetData("item", itemId)
    return data.icon
end

----------------------------------------------私有方法----------------------------------------------Begin
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
----------------------------------------------私有方法----------------------------------------------End

this.BaseMsgIdList = {
    { msgid = MSG_ID.MSG_GAME_LOAD_SOLITAIRE, func = this.ResponeEnterGame },
}

return this