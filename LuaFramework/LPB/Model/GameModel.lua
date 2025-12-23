require 'Model/ModelPart/BaseGameModel'
local sgDataComp = require("Model.ModelPart.SmallGame.SGDataComp")

--- 普通玩法 Model
---@class GameModel : BaseGameModel
local GameModel = BaseGameModel:New()
local this = GameModel
this.rocketSettleData = nil

function GameModel:New()
    local o = {}
    setmetatable(o, { __index = GameModel });
    return o
end

function GameModel:InitData()
    self:SetSelfGameType(PLAY_TYPE.PLAY_TYPE_NORMAL)
end

--小火箭界面再次结算，获取到新结算数据
function GameModel:IsGetNewSettleData()
    return this:GetReadyState() == 5
end

--2小火箭界面再次结算，获取到新结算数据
function GameModel:IsGetNewSettleData2()
    return this:GetReadyState() == 6
end

--请求卡片签章
function GameModel:ReqSignCard(info)
    for i = 1, #info.total do
        local isSuccessClick = this:RefreshRoundDataByIndex(info.total[i].cardId, info.total[i].index, 1)
        if isSuccessClick then
            this:CalcuateBingo(info.total[i].cardId, info.total[i].index)
        end
    end
end

--后端同步叫号
function GameModel.ResSyncNumber(code,data)
    if(code == RET.RET_SUCCESS)then
        this:SetNewCallNumber(data)
        this:AddCalledNumber( data.currNumber)
        Event.Brocast(Notes.SYNC_NUMBER,data)
        --Event.Brocast(EventName.SoundMachine_Call_Number_Audio,data.currNumber,data.bingo)
    else
        log.r("同步号码错误")
    end
end


--设置引导战斗ID
function GameModel:SetGuideBattle(data)
    if data and data.type ~= nil and data.type>0 then
        ModelList.GuideModel:SetGuideBattle(data.type)
    end
end

--使用小火箭后，只保存bingo信息 不做展示
function GameModel:SetOnlySaveBingoInfo()
    this.onlySaveBingoInfo = true
end

--使用小火箭后，只保存bingo信息 不做展示
function GameModel:RocketShowBingoInfo()
    this.onlySaveBingoInfo = false
    if this.rocketSettleData  or  this:GetSettleCode() == MSG_ID.MSG_GAME_COMMON_SETTLE then
        --this.ResBingoInfo(RET.RET_SUCCESS, this:LoadBingoLeftData())
        return true
    end
    return false
end


--后端Bingo预结算
function GameModel.ResBingoPreSeettle(code,data)
    if(code == RET.RET_SUCCESS)then
        this:SaveSettleData(data,MSG_ID.MSG_GAME_COMMON_PRE_SETTLE)
        this:SetReadyState(3)
        this:StopBattleMachine()
    else
        log.w("同步Bingo错误")
    end
end

--后端Bingo结算
function GameModel.ResBingoSettle(code,data)
    if(code == RET.RET_SUCCESS)then
        this:SaveSettleData(data,MSG_ID.MSG_GAME_COMMON_SETTLE)
        this:SetReadyState(5)
        this:StopBattleMachine()
    else
        log.w("同步Bingo错误")
    end
end


--后端power返回
function GameModel.ResPowerUp(code,data)
    if(code == RET.RET_SUCCESS)then


    else
        log.w("同步Bingo错误")
    end
end


--后端盖章返回
function GameModel.ResSign(code,data)
    if(code == RET.RET_SUCCESS)then
        --this:BattleMessageQueuePushBingos(data.index,data.bingoIds)
    else
        log.w("同步Bingo错误")
    end
end




function GameModel:Clear()
    this.rocketSettleData = nil
    this.__index:Clear()
end


--服务器判定异常
function GameModel.ResGameError(code,data)
    this:StopBattleMachine()
    if(code == RET.RET_SUCCESS)then
        local gameid = data.gameid
        local msgId = data.showMsgId
        if gameid == this:GetGameId() then
            if msgId == ERROR_MSG_ID.NORMAL_CALLNUMBER_NOT_CHECKED then

                UIUtil.show_common_error_popup(8006,true,function()
                    this:BackToHallScene()
                end)
            elseif msgId == ERROR_MSG_ID.HANGUP_CALLNUMBER_NOT_CHECKED then
                UIUtil.show_common_error_popup(8007,true,function()
                    this:BackToHallScene()
                end)
            end
        end
    else
        log.w("同步Bingo错误")
    end
end

--服务器盖章验证
function GameModel.ResGameSignSure(code,data)
    if(code == RET.RET_SUCCESS)then

    else
        log.w("同步Bingo错误")
    end
end

---@使用小火箭，use_type 1火箭2钻石3广告4跳过 5广告结束 3广告4跳过
function GameModel:ReqUseRocket(use_type,info,count)
    local game_id = this:GetGameId()
    if use_type == 3 or  use_type == 4 then
        this.SendMessage(MSG_ID.MSG_GAME_USE_ROCKET, {gameId = game_id, type= use_type ,no =count },true,true);
    else
        this.SendMessage(MSG_ID.MSG_GAME_USE_ROCKET, {gameId = game_id, type= use_type ,cardInfo = info,no =count },true,true);
    end
end
--小火箭
function GameModel.ResUseRocket(code,data)
    if code == RET.RET_SUCCESS then
        this.rocketSettleData = data
        if data.bingoIds and #data.bingoIds >0 then
        else
        end
        
        local haveCommonSettleRet = false
        --附带其它-推送协议，需要安卓推送顺序转发
        if data and data.nextMessages then
            for key, value in ipairs(data.nextMessages) do
                local body = Base64.decode(value.msgBase64)
                local ret = Proto.decode(value.msgId, body)
                Message.DispatchMessage(value.msgId, value.code, ret)
                haveCommonSettleRet = haveCommonSettleRet or value.msgId == MSG_ID.MSG_GAME_COMMON_SETTLE
            end
        end

        --table.each(data and data.nextMessages, function(v)
        --    local body = Base64.decode(v.msgBase64)
        --    local ret = Proto.decode(v.msgId, body)
        --    Message.DispatchMessage(v.msgId, v.code, ret)
        --    haveCommonSettleRet = haveCommonSettleRet or v.msgId == MSG_ID.MSG_GAME_COMMON_SETTLE
        --end)
        if not haveCommonSettleRet then
            if data and data.no >= 2 then
                --如果2次小火箭返回值没有 5307，主动请求
                this:ReqFetchSettle()
            end
        end
    else
        this.rocketSettleData = {}
        --this:SetReadyState(5)
        this.SendMessage(MSG_ID.MSG_GAME_OVER,{gameId = this:GetGameId() })
    end

    Event.Brocast(EventName.MSG_GAME_USE_ROCKET_RET, {code = code, msg = data})
end


-- 战斗结束返回
function GameModel.ResGameOver(code,data)
    if code == RET.RET_GAME_WRONG or code == RET.RET_GAME_NOT_EXIST   then  --其它特定错误-暂时不用
        this:StopBattleMachine()
        UIUtil.show_common_popup(8021,true,function()
            UIUtil.return_to_scenehome()
        end)
    elseif code == RET.RET_GAME_OVERED then  --客户端发gameData获取 这把游戏结算数据

    end

end

--重新拉取结算数据
function GameModel:ReqFetchSettleData()
    local game_id = this:GetGameId()
    local playType = this:GetGameType()
    this.SendMessage(MSG_ID.MSG_FETCH_SETTLE_DATA, {gameId = game_id, playType = playType },true);
end

--上报当前叫号数量
function GameModel:ReqSyncCallNumberProgress(progress)
    local game_id = this:GetGameId()
    this.SendMessage(MSG_ID.MSG_GAME_SYNC_PROGRESS, {gameId = game_id, progress = progress },true,true);
end

--返回上报当前叫号数量
function GameModel:ResCallNumberProgress()

end

function GameModel:OnReceiveSettle()

end

function GameModel:CheckAllCardForbid()
    local allCardForbid = true
    local data = self:GetRoundData()
    for k, v in pairs(data) do
        if not v:GetForbid() then
            allCardForbid = false
        end
    end
    if allCardForbid then
        BattleLogic.GetLogicModule(LogicName.Card_logic):WaitUploadSettleData()
    end
end


----------------------mini game 小游戏--------------------


--收到摇球机数据
function GameModel.ResponeBallShaker(code, data)
    sgDataComp.ResponeSmallGameData("BallShaker", code, data)
end

--返回摇奖结果
function GameModel.ResponeBallShakerResult(code, data)
    sgDataComp.ResponeSmallGameData("BallShakerResult", code, data)
end

--返回金钱大厦数据
function GameModel.ResponeMansionInfo(code, data)
    sgDataComp.ResponeSmallGameData("MoneyBuilding", code, data)
end
--返回金钱大厦数据
function GameModel.ResponeMansionSpin(code, data)
    sgDataComp.ResponeSmallGameData("MoneyBuildingSpin", code, data)
end

function GameModel.ReqSGInfo(...)
    return sgDataComp:ReqSGInfo(...)
end

---小火箭完成，如果有小游戏数据，则跳入小游戏状态
function GameModel:GetSmallGameData()
    return sgDataComp:GetSmallGameData()
end

---正式结算后，如果有小游戏数据，则跳入小游戏状态
function GameModel:GetSmallGameData2()
    return sgDataComp:GetSmallGameData2()
end

function GameModel:GetExtraSmallGameData()
    return sgDataComp:GetExtraSmallGameData()
end

function GameModel:ShowSGMainView()
    return sgDataComp:ShowMainView()
end

function GameModel.ClearSGData()
    return sgDataComp:Clear()
end

---摇球机使用球
function GameModel:ReqExtraBall(index)
    local gameId = ModelList.GameModel:GetGameId()
    self.SendMessage(MSG_ID.MSG_GAME_BALL_SHAKER_USE, { gameId = gameId, index = index })
end


function GameModel:SignCardWithExtraBall(cardId, cellIndex)
    ---特殊处理,清理掉技能
    local cell = self.roundData:GetCell(tostring(cardId), cellIndex)
    cell:ResetSkill()
    cell:ResetJoker()
    ModelList.GameModel:SignCardWithPowerUpByIndex(cardId, cellIndex, false)
end
----------------------end mini game 小游戏--------------------

function GameModel:ResEnterGame(code, data)
    self:SetGuideBattle(data)
    BaseGameModel.ResEnterGame(self, code, data)
end

this.MsgIdList =
{
    { msgid = MSG_ID.MSG_GAME_LOAD_DEFAULT, func = this.ResEnterGame },
    { msgid = MSG_ID.MSG_GAME_SYNC_NUMBER, func = this.ResSyncNumber },
    --{ msgid = MSG_ID.MSG_GAME_BINGO_LEFT, func = this.ResBingoInfo },
    --{ msgid = MSG_ID.MSG_GAME_COMMON_SETTLE, func = this.ResBingoSettle },
    --{ msgid = MSG_ID.MSG_GAME_COMMON_PRE_SETTLE, func = this.ResBingoPreSeettle },
    { msgid = MSG_ID.MSG_GAME_POWERUP, func = this.ResPowerUp },
    { msgid = MSG_ID.MSG_GAME_SIGN, func = this.ResSign },
    --{msgid = MSG_ID.MSG_GAME_SKILL, func = this.ResSkill},
    --服务器判定异常-返还资源-推送客户端-弹框并结束游戏
    { msgid = MSG_ID.MSG_GAME_ERROR_RETURN, func = this.ResGameError },
    { msgid = MSG_ID.MSG_GAME_USE_ROCKET, func = this.ResUseRocket },
    { msgid = MSG_ID.MSG_GAME_OVER, func = this.ResGameOver },
    { msgid = MSG_ID.MSG_GAME_SYNC_PROGRESS, func = this.ResCallNumberProgress },
    --{msgid = MSG_ID.MSG_GAME_SURE_SIGN, func = this.ResGameError},
}

return this
