require 'Model/ModelPart/BaseGameModel'
local Const = require "View/WinZone/WinZoneConst"
local bingoJokerMachine = require("Combat.Machine.BingoJokerMachine")

---@class WinZoneGameModel : BaseGameModel
local WinZoneGameModel = BaseGameModel:New()
local this = WinZoneGameModel
this.rocketSettleData = nil
local private = {}

------需要子类重写，设置参数------------------------------------------------------------------------------
function WinZoneGameModel:InitModeOptions()
    self.gameType_ = PLAY_TYPE.PLAY_TYPE_VICTORY_BEATS
    self.cityPlayID_ = 17
end

function WinZoneGameModel:GetQuestItemOffsetPos()
    return 40, -32
end

function WinZoneGameModel:GetWinZoneItemOffsetPos()
    return -44, 44
end

function WinZoneGameModel:UpdateUpLoadDataExt(ext)
    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    if bingoView and bingoView.bingosleftView then
        local rank = bingoView.bingosleftView.selfRank
        if rank and rank > 0 then
            ext = JsonToTable(ext)
            ext.victoryBingoRank = rank
            ext = TableToJson(ext)
            return ext
        end
    end

    return ext
end

---是否展示普通格子可以达成Bingo时的wish状态
function WinZoneGameModel:CanShowNormalCellBingoWish()
    return false
end

---是否展示技能格子可以达成Bingo/Jackpot时的wish状态
function WinZoneGameModel:CanShowSkillCellWish()
    return false
end

---Jackpot规则差n个格子就达成了Jackpot,展示这n个格子的wishState
function WinZoneGameModel:GetLessAchievedJackpotNeedCount()
    return 5
end

--请求游戏结束
function WinZoneGameModel:ReqQuitBingoGame(pre_quit, gameType)
    BaseGameModel.ReqQuitBingoGame(self, pre_quit, gameType)
    if pre_quit then --主动退出
        ModelList.WinZoneModel:RecordManualExit(Const.ManualExitType.battle)
    end
end

------------------------------------------------------------------------------------------------------

function WinZoneGameModel:InitData()
    self:InitModeOptions()
    self:SetSelfGameType(self.gameType_)
end

--请求进入游戏
function WinZoneGameModel:ReqEnterGame()
    if not this:CheckCityIsOpen() then
        return
    end

    ModelList.BattleModel:DirectSetGameType(self.gameType_, self.cityPlayID_)
    ModelList.CityModel.SetPlayId(self.cityPlayID_)
    self:SetReadyState(0)

    local procedure = require "Procedure/ProcedureWinZone"
    Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneLoadingGameView, nil, nil, procedure:New())

    local cardNum = ModelList.CityModel:GetCardNumber()

    local data = ModelList.WinZoneModel:GetPlayReadyData()
    local betRate = ModelList.CityModel:GetBetRate()
    local powerupGear, powerupId = ModelList.CityModel:GetPowerupGear()
    local city = ModelList.CityModel:GetCity()
    local coupon = ModelList.CouponModel.get_currentCouponIdByCardNum(cardNum)
    local useId = ModelList.CouponModel.get_currentCouponUseIdByCardNum(cardNum)
    ModelList.CityModel:SavePreviousPlayInfo()
    this:ResetSettleCode()
    local hideCardAuto = ModelList.BattleModel.GetIsAutoSign() and 1 or 0

    this.SendMessage(MSG_ID.MSG_GAME_LOAD_VICTORY_BEATS, {
        cardNum = cardNum,
        rate = betRate,
        powerUpId = tonumber(powerupId),
        cityId = city,
        couponId = coupon,
        useCouponId = useId,
        playId = ModelList.CityModel.GetPlayIdByCity(),
        hideCardAuto = hideCardAuto
    })
end

--请求卡片签章
function WinZoneGameModel:ReqSignCard(info)
    for i = 1, #info.total do
        local isSuccessClick, isBingoCell = this:RefreshRoundDataByIndex(info.total[i].cardId, info.total[i].index, 1)
        if isSuccessClick then
            if isBingoCell then
                --bingo格子盖章0.8s后出bingo
                LuaTimer:SetDelayFunction(0.8, function()
                    this:CalcuateBingo(info.total[i].cardId, info.total[i].index)
                end, false, LuaTimer.TimerType.Battle)
            else
                this:CalcuateBingo(info.total[i].cardId, info.total[i].index)
            end
        end
    end
end

--powerup 卡片签章
function WinZoneGameModel:SignCardWithPowerUpByIndex(tCardId, cellIndex, need_fly_item, mark, extraPos)
    local isSuccesClick, isBingoCell = this:RefreshRoundDataByIndex(tCardId, cellIndex, 1, need_fly_item, mark, extraPos)
    if isSuccesClick then
        if isBingoCell then
            --bingo格子盖章0.8s后出bingo
            LuaTimer:SetDelayFunction(0.8, function()
                this:CalcuateBingo(tCardId, cellIndex)
            end, false, LuaTimer.TimerType.Battle)
        else
            this:CalcuateBingo(tCardId, cellIndex)
        end
    end
    Event.Brocast(EventName.Switch_View_Refresh, { { cardId = tCardId, index = 0 } })
end

--收到进入游戏返回，允许进入Game场景
function WinZoneGameModel.ResEnterGame(code, data)
    this.loop_delay_checks = {}
    if code == RET.RET_SUCCESS then
        this:SaveGameLoadData(data)
        this:SetReadyState(1)
        this:InitRoundData()
        this:InitExtraData(data.ext)
        ModelList.BattleModel.SetBattleDouble(data.activityStatus)
        ModelList.BattleModel.SetIsJokerMachine((data.jokerData and #data.jokerData > 0) and true or false)
        ModelList.BattleModel:BackupLoadData(data)
        this:SetGameState(GameState.Ready)
        Event.Brocast(EventName.Recorder_Data, 5001, data)
    else
        log.r("发送进入游戏失败" .. code)
        Event.Brocast(EventName.Event_Cancel_Loading_Game)
        UIUtil.return_to_scenehome()
        UIUtil.show_common_global_popup(8004, true)

        if code == RET.RET_VICTORY_BEATS_NO_GAME_INFO then 
            -- 没有游戏信息，用户没有加入过游戏
            Event.Brocast(EventName.Event_WinZone_Match_Ended)
        elseif code == RET.RET_VICTORY_BEATS_WRONG_USER_TIMELINE then
            -- 时间线错误 用户进行play前的状态【join|settle】 用户进入对局前的状态【play|enterGame】
            Event.Brocast(EventName.Event_WinZone_Match_Ended)
            ModelList.WinZoneModel:C2S_VictoryBeatsInfo()
        elseif code == RET.RET_VICTORY_BEATS_PLAY_TIME_EXPIRED then
            -- 进入对战时间已过期、淘汰，走退出逻辑
            UIUtil.show_common_popup(8045, true, function()
                ModelList.WinZoneModel:C2S_VictoryBeatsExit()
            end)
        end
    end
end


--后端Bingo同步
function WinZoneGameModel:ResBingoInfo(code, data)
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
            LuaTimer:SetDelayFunction(2, function()
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

function WinZoneGameModel:OnReceiveSettle()
    if self:GetGameState() < GameState.ShowSettle then
        self:ShowSettle()
    end
end

function WinZoneGameModel:Clear()
    table.each(self.loop_delay_checks, function(v)
        LuaTimer:Remove(v)
    end)

    self.__index:Clear()
end

--- 需要等特效还有bingo画面啥的都得等播放完再弹出结算界面
--- 战斗结算前，检查彩球叫号器
function WinZoneGameModel:CheckJokerBallSprayer(callBack)
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
                end, nil, LuaTimer.TimerType.Battle)
            else
                --没有彩球喷射器，等技能、盖章效果播完直接打开结算界面
                callBack()
            end
        end
        bingoJokerMachine:CheckJokerBallSprayer(cb)
    end)
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

this.MsgIdList = {
    { msgid = MSG_ID.MSG_GAME_LOAD_VICTORY_BEATS, func = this.ResEnterGame },
}

return this