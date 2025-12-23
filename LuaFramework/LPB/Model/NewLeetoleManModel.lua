require "Model/ModelPart/BaseGameModel"
local bingoJokerMachine = require("Combat.Machine.BingoJokerMachine")

---  宝石皇后玩法
local NewLeetoleManModel = BaseGameModel:New()
local this = NewLeetoleManModel
local private = {}

------需要子类重写，设置参数------------------------------------------------------------------------------
function NewLeetoleManModel:InitModeOptions()
    self.gameType_ = PLAY_TYPE.PLAY_TYPE_NEW_GREEN_HEAD
    self.cityPlayID_ = 20
end

function NewLeetoleManModel:GetQuestItemOffsetPos()
    return 29, -29
end

------------------------------------------------------------------------------------------------------

function NewLeetoleManModel:InitData()
    self:InitModeOptions()
    self:SetSelfGameType(self.gameType_)
end

function NewLeetoleManModel:ReqEnterGame()
    if not self:CheckCityIsOpen() then
        return
    end

    ModelList.BattleModel:DirectSetGameType(self.gameType_, self.cityPlayID_)
    ModelList.CityModel.SetPlayId(self.cityPlayID_)
    self:SetReadyState(0)

    local procedure = require "Procedure/ProcedureNewLeetoleMan"
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
    self.SendMessage(MSG_ID.MSG_GAME_NEW_GREEN_HEAD, data)
end

function NewLeetoleManModel:ReqSignCard(info)
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

function NewLeetoleManModel:RefreshRoundDataByIndex(cardid, cellIndex, signType, need_fly_item, mark)
    --父类处理
    local ret = this.__index:RefreshRoundDataByIndex(cardid, cellIndex, signType, need_fly_item, mark)

    --如果盖章触发技能/获得道具，添加sign计时，保证技能、道具动效播完
    local cell = self.roundData:GetCell(tostring(cardid), cellIndex)
    if cell and not cell:IsEmpty() then
        self.cardSignLogicDelayTime = os.time()
    end

    return ret
end

function NewLeetoleManModel.ResponeEnterGame(code, data)
    private.OnResEnterGame(this)
    if (code == RET.RET_SUCCESS) then
        this.moveMachine = require("Combat.BattleLogic.NewLeetoleMan.NewLeetoleManMoveMachine")
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

function NewLeetoleManModel:ResBingoInfo(code, data)
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

function NewLeetoleManModel:OnReceiveSettle()
    if self:GetGameState() < GameState.ShowSettle then
        self:ShowSettle()
    end
end

function NewLeetoleManModel:Clear()
    table.each(self.loop_delay_checks, function(v)
        LuaTimer:Remove(v)
    end)
    
    if self.moveMachine then
        self.moveMachine:Stop()
        self.moveMachine = nil
    end
    
    this.__index:Clear()
end

--- 卡面上的bingo表现有延迟，确保最新一个bingo效果能满足最低存活时间
function NewLeetoleManModel:IsBingoShowComplete()
    local check = this.__index:IsBingoShowComplete()

    --cell被盖章后飞出道具及做动画的时间
    local checkTime = os.time() - self.cardSignLogicDelayTime > 2.5
    
    local checkMoveMachine = self.moveMachine and self.moveMachine:HaveMovingCard()
    if not checkMoveMachine then
        checkMoveMachine = self.moveMachine and self.moveMachine:HaveMoveTarget()
    end
    return check and checkTime and not checkMoveMachine
end

--- 需要等特效还有bingo画面啥的都得等播放完再弹出结算界面
--- 战斗结算前，检查彩球叫号器
function NewLeetoleManModel:CheckJokerBallSprayer(callBack)
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

function NewLeetoleManModel:SetRoundGiftData(card_id, cell_index, new_gift, number, skill_id, self_bingo, powerId, extraPos)
    this.__index:SetRoundGiftData(card_id, cell_index, new_gift, number, skill_id, self_bingo, powerId, extraPos)
    if powerId == 169 then
        --记录Bingo技能数据，结束上传
        table.insert(self.cachedSkillDataCache, {
            cardId = tonumber(card_id),
            cellIndex = cell_index,
            extraPos = extraPos,
        })
    end
end

function NewLeetoleManModel:UploadGameData(gameType, quiteType)
    if self.roundData ~= nil and self.roundData.GetRoundData ~= nil then
        self:PreCalculateBingoSkill()
    end
    this.__index:UploadGameData(gameType, quiteType)
end

--确认bingo场景加载完成，通知后端开始叫号
function NewLeetoleManModel:ReqGameReady()
    BattleMachineList.StartBattleMachine()
    if self.moveMachine then
        self.moveMachine:Start()
    end
    
    BattleModuleList.EnableUpdate()
    Event.Brocast(EventName.Recorder_Data,5002,nil)
end

---4066上传数据时检查是否有效
function NewLeetoleManModel:CheckHideGiftUpload(cellData, itemID)
    if not cellData or not itemID then
        return true
    end
    
    local data = Csv.GetData("item", itemID)
    --是宝箱
    if 41 == data.result[1] then
        if cellData.isGained then
            return true
        end
    else
        return true
    end
end

---提前计算好Bingo技能的数据，上传到服务器
function NewLeetoleManModel:PreCalculateBingoSkill()
    table.each(self.cachedSkillDataCache, function(v)
        local cellData = self:GetRoundData(v.cardId, v.cellIndex)
        if not cellData or not cellData:IsNotSign() then
            return
        end
        
        local cells = self:CheckBingoSkillExtraPosValid(v.cardId, v.extraPos)
        local extraPos = BattleTool.ConvertedToServerPosList(cells)
        --添加ExtraData，结算时通知服务器某个                                                                                            类型达成了Bingo
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

function NewLeetoleManModel:CheckBingoSkillExtraPosValid(cardId, extraPos)
    local ret = {}
    table.each(extraPos, function(v)
        local cellID = ConvertServerPos(v)
        local cellData = self:GetRoundData(cardId, cellID)
        if cellData and not cellData.isGained then
            table.insert(ret, cellID)
        end
    end)

    --继续使用原数据
    if #ret > 0 then
        return ret
    end

    if ModelList.BattleModel:IsRocket() then
        return ret
    end
    
    --所有指定格子都已经盖章，选择一个其他类型的材料
    local cells = BattleLogic.GetLogicModule(LogicName.Card_logic):GetNextMaterialCell(cardId, true)
    if #cells == 0 then
        --格子无效
        return ret
    end
    
    table.insert(ret, cells[1].index)
    return ret
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

this.BaseMsgIdList = {
    { msgid = MSG_ID.MSG_GAME_NEW_GREEN_HEAD, func = this.ResponeEnterGame },
}

return this