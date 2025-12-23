require "Model/ModelPart/BaseGameModel"
local bingoJokerMachine = require("Combat.Machine.BingoJokerMachine")

---  宝石皇后玩法
local NewChristmasModel = BaseGameModel:New()
local this = NewChristmasModel
local private = {}

------需要子类重写，设置参数------------------------------------------------------------------------------
function NewChristmasModel:InitModeOptions()
    self.gameType_ = PLAY_TYPE.PLAY_TYPE_NEW_CHRISTMAS
    self.cityPlayID_ = 16
end

function NewChristmasModel:GetQuestItemOffsetPos()
    return 33, -31
end

------------------------------------------------------------------------------------------------------

function NewChristmasModel:InitData()
    self:InitModeOptions()
    self:SetSelfGameType(self.gameType_)
end

function NewChristmasModel:ReqEnterGame()
    if not self:CheckCityIsOpen() then
        return
    end

    ModelList.BattleModel:DirectSetGameType(self.gameType_, self.cityPlayID_)
    ModelList.CityModel.SetPlayId(self.cityPlayID_)
    self:SetReadyState(0)

    local procedure = require "Procedure/ProcedureNewChristmas"
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
    self.SendMessage(MSG_ID.MSG_GAME_LOAD_NEW_CHRISTMAS, data)
end

function NewChristmasModel:ReqSignCard(info)
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

function NewChristmasModel:RefreshRoundDataByIndex(cardid, cellIndex, signType, need_fly_item, mark)
    --父类处理
    local ret = this.__index:RefreshRoundDataByIndex(cardid, cellIndex, signType, need_fly_item, mark)

    --如果盖章触发技能/获得道具，添加sign计时，保证技能、道具动效播完
    local cell = self.roundData:GetCell(tostring(cardid), cellIndex)
    if cell and not cell:IsEmpty() then
        self.cardSignLogicDelayTime = os.time()
    end

    return ret
end

function NewChristmasModel.ResponeEnterGame(code, data)
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

function NewChristmasModel:ResBingoInfo(code, data)
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

function NewChristmasModel:OnReceiveSettle()
    if self:GetGameState() < GameState.ShowSettle then
        self:ShowSettle()
    end
end

function NewChristmasModel:Clear()
    table.each(self.loop_delay_checks, function(v)
        LuaTimer:Remove(v)
    end)

    this.__index:Clear()
end

--- 卡面上的bingo表现有延迟，确保最新一个bingo效果能满足最低存活时间
function NewChristmasModel:IsBingoShowComplete()
    local check = this.__index:IsBingoShowComplete()

    --cell被盖章后飞出道具及做动画的时间
    local checkTime = os.time() - self.cardSignLogicDelayTime > 2.5
    return check and checkTime
end

--- 需要等特效还有bingo画面啥的都得等播放完再弹出结算界面
--- 战斗结算前，检查彩球叫号器
function NewChristmasModel:CheckJokerBallSprayer(callBack)
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

function NewChristmasModel:SetRoundGiftData(card_id, cell_index, new_gift, number, skill_id, self_bingo, powerId, extraPos)
    this.__index:SetRoundGiftData(card_id, cell_index, new_gift, number, skill_id, self_bingo, powerId, extraPos)
    if powerId == 159 then
        --记录猪技能数据，结束上传
        table.insert(self.cachedSkillDataCache, {
            cardId = tonumber(card_id),
            cellIndex = cell_index,
            extraPos = extraPos,
        })
    end
end

function NewChristmasModel:UploadGameData(gameType, quiteType)
    if self.roundData ~= nil and self.roundData.GetRoundData ~= nil then
        self:PreCalcuatePigSkill()
    end
    this.__index:UploadGameData(gameType, quiteType)
end

---提前计算好猪技能的数据，上传到服务器
function NewChristmasModel:PreCalcuatePigSkill()
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

function NewChristmasModel:CheckBingoSkillExtraPosValid(cardId, extraPos)
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
            local itemId = Csv.GetData("item_synthetic", v2.id, "itemid")
            local cfg = Csv.GetData("item", itemId, "result")
            if cfg[1] == 36 then
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

this.BaseMsgIdList = {
    { msgid = MSG_ID.MSG_GAME_LOAD_NEW_CHRISTMAS, func = this.ResponeEnterGame },
}

return this