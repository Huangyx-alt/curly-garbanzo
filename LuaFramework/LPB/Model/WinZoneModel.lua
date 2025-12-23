--WinZone玩法
local Const = require "View/WinZone/WinZoneConst"
require 'Model/ModelPart/BaseGameModel'
local WinZoneModel = BaseGameModel:New()
local this = WinZoneModel
local isEverFinishedMatch = false

function WinZoneModel:InitData()
    self.activityInfo = nil
    log.r('WinZone玩法 触发了 NotifyName.HallCityBanner.AddBannerItem')
    Event.Brocast(NotifyName.HallCityBanner.AddBannerItem, hallCityBannerType.winzone)
end

 --玩家自身等级是否可以开启活动
function WinZoneModel:IsPlayerLevelEnough()
    local nowLevel = ModelList.PlayerInfoModel:GetLevel()
    local myLabel = ModelList.PlayerInfoModel:GetUserType()
    if myLabel and myLabel > 0 then
        if nowLevel and self.payOpenLevel then
            return nowLevel >= self.payOpenLevel
        else
            return false
        end
    else
        if nowLevel and self.openLevel then
            return nowLevel >= self.openLevel
        else
            return false
        end
    end

end

--玩家vip等级是否可以开启活动
function WinZoneModel:IsVipLevelEnough()
    local nowVip = ModelList.PlayerInfoModel:GetVIP()
    if nowVip and self.vipOpenLevel then
        return nowVip >= self.vipOpenLevel
    else
        return false
    end
end

function WinZoneModel:IsActivityValid()
    if not self:IsPlayerLevelEnough() then
        return false
    end

    if not self:IsVipLevelEnough() then
        return false
    end

    return true
end

--获得join房间时玩家列表信息
function WinZoneModel:GetJoinPlayers()
    return self.playerJoinList
end

--获得对局结束时玩家列表信息
function WinZoneModel:GetPlayerList()
    return self.playerList
end

--获得所有晋级的玩家列表信息
function WinZoneModel:GetPlayerPromoteList()
    local reliveTimeOffset = 0
    local promoteList = {}
    local reliveList = {}
    local waitReliveCount = 0
    for i, v in ipairs(self.playerList) do
        local player = {}
        player.role = v
        if v.status == Const.PlayerStates.relive then
            if self:IsSelf(v.uid) then
                player.reliveTime = -1
                table.insert(reliveList, 1, player)
            else
                reliveTimeOffset = self:GenPlayerReliveTime(reliveTimeOffset)
                player.reliveTime = reliveTimeOffset
                table.insert(reliveList, player)
                waitReliveCount = waitReliveCount + 1
            end
            
        elseif v.status == Const.PlayerStates.promote then
            table.insert(promoteList, player)
        elseif v.status == Const.PlayerStates.disuse then
            --玩家被淘汰了
        end
    end

    for i, v in ipairs(reliveList) do
        table.insert(promoteList, v)
    end

    return promoteList, waitReliveCount
end

function WinZoneModel:IsSelf(uid)
    local myUid = ModelList.PlayerInfoModel:GetUid()
    return myUid == tonumber(uid)
end

function WinZoneModel:GenPlayerReliveTime(baseTime)
    baseTime = baseTime or 0
    local reliveTime = math.min(Const.ReliveProcessMaxDuration, baseTime + math.random(Const.ReliveMinTime, Const.ReliveMaxTime))
    return reliveTime
end

function WinZoneModel:GetActivityInfo()
    return self.activityInfo
end

function WinZoneModel:UpdateActivityRoundInfo(rounds)
    if fun.is_table_empty(rounds) then
        return
    end

    if fun.is_table_empty(self.activityInfo) then
        return
    end
    
    self.activityInfo.rounds = rounds
end

function WinZoneModel:EnterSystem()
    log.log("WinZoneModel:EnterSystem", self.curState)
    if not self:IsActivityValid() then
        log.log("WinZoneModel:EnterSystem() error 未达到活动开放条件")
        return
    end

    if not self.curState or self.curState == Const.GameStates.none then --说明当前不在战斗内
        --弹出局数选择界面
        Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneChooseRoundView)
    elseif self.curState == Const.GameStates.chooseRound then
        --弹出局数选择界面
        Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneChooseRoundView)
    elseif self.curState == Const.GameStates.joinRoom then
        --集结界面表现入场
        self:ShowJoinProcess()
    elseif self.curState == Const.GameStates.ready then
        --集结界面表现5s倒计时
        self:ShowReadyProcess()
    elseif self.curState == Const.GameStates.disusePlayers then
        --淘汰界面表现淘汰过程
        self:ShowDisuseProcess()
    elseif self.curState == Const.GameStates.waitSelfRelive then
        --复活弹窗
        if self:CanRelive() then --此时还可以复活
            self:ShowReliveDialog()
        else
            --现在过期了（过了复活的时间）
            --有奖领奖，无奖退出
            if self:HasReward() then
                log.log("WinZoneModel:EnterSystem some thing error 有奖励", self.curState)
                self:C2S_VictoryBeatsReward()
            else    --不可复活且无奖励 只能做退出操作了
                log.log("WinZoneModel:EnterSystem some thing error 无奖励", self.curState)
                self:C2S_VictoryBeatsExit()
            end
        end
    elseif self.curState == Const.GameStates.waitOtherRelive then
        --集结界面等待其它玩家复活
        self:WaitOtherRelive()
    elseif self.curState == Const.GameStates.battleStage1 then
        self:EnterGameHall()
    elseif self.curState == Const.GameStates.waitClaimReward then
        self:C2S_VictoryBeatsReward()
    elseif self.curState == Const.GameStates.waitExit then
        self:C2S_VictoryBeatsExit()
    end
end

--展示淘汰过程
function WinZoneModel:ShowDisuseProcess()
    log.log("WinZoneModel:ShowDisuseProcess", self.settleData)
    if not self.settleData then
        --https://www.tapd.cn/65500448/bugtrace/bugs/view?bug_id=1165500448001015174
        log.log("WinZoneModel:ShowDisuseProcess 无结算数据")
        self:C2S_VictoryBeatsExit()
        return
    end
    if self.allRound and self.allRound == self.curRound then
        ViewList.WinZonePromoteView2:SetData(self.settleData)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZonePromoteView2)
    else
        ViewList.WinZonePromoteView1:SetData(self.settleData)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZonePromoteView1)
    end
end

--展示复活弹窗
function WinZoneModel:ShowReliveDialog()
    log.log("WinZoneModel:ShowReliveDialog", self.settleData)
    ViewList.WinZoneReliveDialog:SetData(self.settleData)
    Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneReliveDialog)
end

--等待别的玩家复活过程
function WinZoneModel:WaitOtherRelive()
    log.log("WinZoneModel:WaitOtherRelive")
    ViewList.WinZoneLobbyView:SetGameState(Const.GameStates.waitOtherRelive)
    Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneLobbyView)
end

--展示准备过程（5s倒计时）
function WinZoneModel:ShowReadyProcess()
    log.log("WinZoneModel:ShowReadyProcess")
    ViewList.WinZoneLobbyView:SetGameState(Const.GameStates.ready)
    Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneLobbyView)
end

--展示加入房间过程
function WinZoneModel:ShowJoinProcess()
    log.log("WinZoneModel:ShowJoinProcess")
    ViewList.WinZoneLobbyView:SetGameState(Const.GameStates.joinRoom)
    Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneLobbyView)
end

--获得玩家复活币数量
function WinZoneModel:GetReliveCoinCount()
    local count = ModelList.ItemModel.getResourceNumByType(Const.ReliveCoinId) or 0
    return count
end

--获得第几次复活的相关配置
function WinZoneModel:GetReliveCfg(reliveTimes, totalRound)
    if not Csv.victorybeats_revival then
        log.log("WinZoneModel:GetReliveCfg(reliveTime, totalRound) victorybeats_revival 配置表Error", reliveTimes, totalRound)
        return
    end

    for i, v in ipairs(Csv.victorybeats_revival) do
        if v.revival_times == reliveTimes then
            return v
        end
    end
end

--请求购买复活币
function WinZoneModel:PurchaseReliveCoin(itemId)
    ModelList.MainShopModel.C2S_RequestActivityPay(itemId, "victoryBeats")
end

---取集结完毕后后端返回的play数据
function WinZoneModel:GetPlayReadyData()
    return this.playReadyData
end

---进入战斗准备房间
function WinZoneModel:EnterGameHall()
    if not self:CheckVersion() then
        return
    end
    if resMgr then
        --TODO by LwangZg 运行时热更部分
        resMgr:RefreshModuleInfo("WinZone")
    elseif LuaHelper.GetResManager()  then
        LuaHelper.GetResManager():RefreshModuleInfo("WinZone")
    end
    log.log("WinZoneModel:EnterGameHall")
    ModelList.BattleModel.RequireModuleLua("WinZone")
    local playID = 17
    local data = Csv.GetData("city_play", playID)
    Facade.SendNotification(NotifyName.SpecialGameplay.CloseSpecialGameplayView)
    Facade.SendNotification(NotifyName.SceneCity.Click_City_Enter, nil, data.city_id, playID)
end

---检查winzone模块版本
function WinZoneModel:CheckVersion()
    if not this.local_version  then
        this.local_version = MachineDownloadManager.get_machine_local_version(14)
        if fun.IsEditor() then
            this.local_version = 1
        end
    elseif this.local_version == 0 then
        this.local_version = MachineDownloadManager.get_machine_local_version(14)
    end
    if this.local_version and this.local_version >0 then
        return true
    else
        UIUtil.show_common_popup(8047,false,function()
            Facade.SendNotification(NotifyName.WinZone.StartDownloadMachine)
        end,nil)
    end
end

--是否应该进入战斗大厅
function WinZoneModel:ShouldGotoGameHall()
    return self.curState == Const.GameStates.battleStage1
end

--是否可以复活
function WinZoneModel:CanRelive()
    if not self.settleData then
        return false
    end

    if not self.settleData.isDisuse then
        return false
    end

    if not self.settleData.canRelive then
        return false
    end

    if not self.settleData.lastPlayTime then
        return false
    end

    local currTime = ModelList.PlayerInfoModel.get_cur_server_time()
    if Const.MinPopupReliveDialogTime + currTime < self:GetLastPlayTime() then
        return true
    end

    return false
end

--是否有奖励可领
function WinZoneModel:HasReward()
    if not self.settleData then
        return false
    end

    return not fun.is_table_empty(self.settleData.reward)
end

--自己是否淘汰了
function WinZoneModel:IsDisuse()
    if not self.settleData then
        return false
    end

    return self.settleData.isDisuse
end

--是否有奖励且不能复活
function WinZoneModel:HasRewardAndCannotRelive()
    return self:HasReward() and not self:CanRelive()    
end

--进入比赛的截止时间
function WinZoneModel:GetLastPlayTime()
    --return ModelList.PlayerInfoModel.get_cur_server_time() + 100  --for test
    return self.lastPlayTime or 0
end

--现在处于第几局
function WinZoneModel:GetCurRound()
    return self.curRound or 0
end

--当前选的比赛总共有多少局
function WinZoneModel:GetTotalRound()
    return self.allRound or 0
end

--当前比赛所有对局信息
function WinZoneModel:GetRecord()
    if not self.settleData then
        return
    end

    return self.settleData.roundResult
end

--当前比赛是否是最后一轮
function WinZoneModel:IsInLastRound()
    local data = self:GetPlayReadyData()
    if not data then
        return false
    end
    
    return data.curRound == data.allRound
end

--当前的服务器时间
function WinZoneModel:GetCurServerTime()
    return ModelList.PlayerInfoModel.get_cur_server_time() or 0
end

--退出比赛的倒计时结束时间
function WinZoneModel:GetReadyEndTime()
    return self.readyEndTime or 0
end

--退出比赛的倒计时剩余时间
function WinZoneModel:GetReadyEndRemainTime()
    if not self.readyEndTime then
        return 0
    end
    local curServerTime = self:GetCurServerTime()
    local remain = self.readyEndTime - curServerTime
    remain = Mathf.Clamp(remain, 0, remain)
    return remain
end

--检查退出比赛的剩余时间，如果倒计时结束则弹出提示
function WinZoneModel:CheckReadyEndTime()
    if not ModelList.WinZoneModel:IsActivityValid() then
        return true
    end    
    if not ModelList.CityModel:CheckCurTypeIs(PLAY_TYPE.PLAY_TYPE_VICTORY_BEATS) then
        return true
    end
    
    local remainTime = self:GetReadyEndRemainTime()
    if remainTime > 0 then
        return true
    else
        UIUtil.show_common_popup(8045,true,function()
            --倒计时结束,直接做淘汰表现
            self:C2S_VictoryBeatsExit()
        end)
    end
end

---额外奖励buff剩余时间
function WinZoneModel:GetDoubleBuffRemainTime()
    local expireTime = ModelList.ItemModel.getResourceNumByType(RESOURCE_TYPE.RESOURCE_TYPE_VICTORY_BEATS_DOUBLE_NOTE_BUFF)
    local remainTime = math.max(0, expireTime - os.time())
    return remainTime
end

--是否完成过比赛
function WinZoneModel:IsEverFinishedMatch()
    return isEverFinishedMatch
end

--记录选局记录
function WinZoneModel:RecordSelectRound(roundType)
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    fun.save_value(Const.ROUND_SELECT_RECORD .. playerInfo.uid, roundType)
end

--获得之前的选局记录
function WinZoneModel:GetSelectRoundRecord()
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    local selectRecord = fun.read_value(Const.ROUND_SELECT_RECORD .. playerInfo.uid)
    return selectRecord
end

--清除之前的选局记录
function WinZoneModel:ClearSelectRoundRecord()
    self:RecordSelectRound()
end

--记录最后排名
function WinZoneModel:RecordFinalRank()
    local rank = self:GetSelfRank()
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    fun.save_value(Const.FINAL_RANK_RECORD .. playerInfo.uid, rank)
end

--获得记录最后排名
function WinZoneModel:GetFinalRankRecord()
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    local rank = fun.read_value(Const.FINAL_RANK_RECORD .. playerInfo.uid, -1)
    return rank
end

--清除之前记录最后排名
function WinZoneModel:ClearFinalRankRecord()
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    fun.save_value(Const.FINAL_RANK_RECORD .. playerInfo.uid)
end

--记录手动退出
function WinZoneModel:RecordManualExit(exitType)
    --[[
    if exitType == Const.ManualExitType.lobby then
    elseif exitType == Const.ManualExitType.battle then
    end
    --]]

    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    fun.save_value(Const.MANUAL_EXIT_RECORD .. playerInfo.uid, true)
end

--查询刚是否为手动退出
function WinZoneModel:GetManualExitRecord()
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    return fun.read_value(Const.MANUAL_EXIT_RECORD .. playerInfo.uid, false)
end

--清楚手动退出记录
function WinZoneModel:ClearManualExitRecord()
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    fun.save_value(Const.MANUAL_EXIT_RECORD .. playerInfo.uid, false)
end

--展示奖励
function WinZoneModel:DisplayReward(reward, closeCallback, isTopOne)
    local params = {}
    params.reward = reward
    params.closeCallback = closeCallback

    if (self:GetSelfRank() == 1 and self.allRound and self.allRound == self.curRound) or isTopOne then
        ViewList.WinZoneRewardView2:SetData(params)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneRewardView2)
    else
        ViewList.WinZoneRewardView1:SetData(params)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneRewardView1)
    end
end

--获得自己的排名
function WinZoneModel:GetSelfRank()
    if self.playerList then
        for i, v in ipairs(self.playerList) do
            if self:IsSelf(v.uid) then
                return v.rank
            end
        end
    end

    return -1
end

--清上一局的数据
function WinZoneModel:ClearLastRoundData()
    self.settleData = nil
    self.lastPlayTime = 0
    self.playerList = nil
end

--清空整场比赛数据（完成所有对局了）
function WinZoneModel:ClearMatchData()
    self.settleData = nil
    self.allRound = nil
    self.curRound = nil
    self.playerJoinList = nil
    self.lastPlayTime = 0
    self.playerList = nil
    self.playReadyData = nil
end

------------- winzone 弹窗领奖相关 -------------
function WinZoneModel:Check_WinZone_Need_Open()
    if ModelList.WinZoneModel:IsActivityValid() and ModelList.WinZoneModel:ShouldGotoGameHall() then
        return true
    end
    return false
end

function WinZoneModel.CheckHasRewardAndCannotRelive()
    local hasReward =  ModelList.WinZoneModel:HasRewardAndCannotRelive()
    if hasReward then
        Event.AddListener(EventName.Event_WinZone_Popup_Res_SettleReward, this.OnResSettleReward, this)
        ModelList.WinZoneModel:C2S_VictoryBeatsReward()
        return true
    else
        return false
    end
end


function WinZoneModel:OnResSettleReward(code,data)
    if code == RET.RET_SUCCESS and data.reward then
        ModelList.WinZoneModel:DisplayReward(data.reward,nil)
    end
    this.CheckHasRewardAndCannotReliveOver()
end

function WinZoneModel:CheckHasRewardAndCannotReliveOver()
    Event.RemoveListener(EventName.Event_WinZone_Popup_Res_SettleReward, this.OnResSettleReward, this)
end
--------------------------------------------------------------------------------------

-------------------------------------------------状态相关-------------------------------------------------Begin
function WinZoneModel:InitState()
    self.curState = Const.GameStates.none
end

function WinZoneModel:SetCurState(state)
    if self.curState then
        log.log("WinZoneModel:SetCurState cur state is ", self.curState, " new state is ", state)
    end
    self.curState = state
end

function WinZoneModel:GetCurState()
    log.log("WinZoneModel:GetCurState cur state is ", self.curState)
    return self.curState
end
-------------------------------------------------状态相关-------------------------------------------------end

-------------------------------------------------网络消息-------------------------------------------------Begin
-------------------------------------------------消息请求-------------------------------------------------Begin
function WinZoneModel:C2S_VictoryBeatsInfo()
    self.SendMessage(MSG_ID.MSG_VICTORY_BEATS_FETCH, {})
end

function WinZoneModel:Login_C2S_VictoryBeatsInfo()
    return this:SendDataToBase64(MSG_ID.MSG_VICTORY_BEATS_FETCH, {})
end




function WinZoneModel:C2S_VictoryBeatsJoin(roundType)
    self.SendMessage(MSG_ID.MSG_VICTORY_BEATS_JOIN, {roundType = roundType})
    self:ClearFinalRankRecord()
    self:ClearManualExitRecord()
end

function WinZoneModel:C2S_VictoryBeatsPlay()
    self.SendMessage(MSG_ID.MSG_VICTORY_BEATS_PLAY, {}, false, true)
end

function WinZoneModel:C2S_VictoryBeatsExit(cb, exitType)
    -- 1-用户主动退出 2-系统退出
    self.SendMessage(MSG_ID.MSG_VICTORY_BEATS_EXIT, {exitType = exitType or 2}, false, true)
    if exitType == 1 then
        self:RecordManualExit(Const.ManualExitType.lobby)
    end
end

function WinZoneModel:C2S_VictoryBeatsReward()
    self.SendMessage(MSG_ID.MSG_VICTORY_BEATS_REWARD, {}, false, true)
end

function WinZoneModel:C2S_VictoryBeatsRelive()
    self.SendMessage(MSG_ID.MSG_VICTORY_BEATS_RELIVE, {}, false, true)
end

function WinZoneModel:C2S_VictoryBeatsRankSync(rank)
    self.SendMessage(MSG_ID.MSG_VICTORY_BEATS_RANK_SYNC, {rank = rank})
end
-------------------------------------------------消息请求-------------------------------------------------End

-------------------------------------------------消息返回-------------------------------------------------Begin
function WinZoneModel.S2C_VictoryBeatsInfo(code, data)
    log.log("WinZoneModel.S2C_VictoryBeatsInfo code, data", code, data)
    if code == RET.RET_SUCCESS then
        this.activityInfo = data
        this.openLevel = data.openLevel
        this.vipOpenLevel = data.vipOpenLevel
        this.payOpenLevel = data.payOpenLevel
        if fun.is_table_empty(data.nextMessages) then
            --if this.curState == Const.GameStates.none then
                this:SetCurState(Const.GameStates.chooseRound)
            --end
        else
            table.each(data.nextMessages, function(v)
                local body = Base64.decode(v.msgBase64)
                local ret = Proto.decode(v.msgId, body)
                Message.DispatchMessage(v.msgId, v.code, ret)
            end)
        end
    else
        log.log("WinZoneModel.S2C_VictoryBeatsInfo error", code)
    end
end

function WinZoneModel.S2C_VictoryBeatsJoin(code, data)
    log.log("WinZoneModel.S2C_VictoryBeatsJoin code, data", code, data)
    if code == RET.RET_SUCCESS then
        this.allRound = data.allRound
        this.curRound = data.curRound
        this.playerJoinList = data.players
        this.lastPlayTime = data.lastPlayTime
        this.playerList = {}
        for i, v in ipairs(data.players) do
            table.insert(this.playerList, v.role)
        end

        this:SetCurState(Const.GameStates.joinRoom)
        local bundle = {nextState = Const.GameStates.joinRoom}
        Facade.SendNotification(NotifyName.WinZone.SelectRoundSucc, bundle)
    else
        log.log("WinZoneModel.S2C_VictoryBeatsJoin error", code)
        local bundle = {errorCode = code}
        Facade.SendNotification(NotifyName.WinZone.SelectRoundFail, bundle)
    end
end

function WinZoneModel.S2C_VictoryBeatsPlay(code, data)
    log.log("WinZoneModel.S2C_VictoryBeatsPlay code, data", code, data)
    if code == -99 then
        return
    end

    this:ClearLastRoundData()
    if code == RET.RET_SUCCESS then
        --前端计算结束时间戳
        local curServerTime = this:GetCurServerTime()
        this.readyEndTime = curServerTime + data.countDown
        
        this.playReadyData = data
        this.allRound = data.allRound
        this.curRound = data.curRound
        
        this:SetCurState(Const.GameStates.battleStage1)
        Facade.SendNotification(NotifyName.WinZone.ReadyPlaySucc)
    else
        this.playReadyData = nil
        log.log("WinZoneModel.S2C_VictoryBeatsPlay error", code)
        local bundle = {errorCode = code}
        Facade.SendNotification(NotifyName.WinZone.ReadyPlayFail, bundle)
    end
end

function WinZoneModel.S2C_VictoryBeatsSettle(code, data)
    log.log("WinZoneModel.S2C_VictoryBeatsSettle code, data", code, data)
    if code == RET.RET_SUCCESS then
        -- data.allRound
        -- data.curRound
        -- data.roles
        -- data.isDisuse
        -- data.canRelive
        -- data.reward
        -- data.reliveTimes
        -- data.reliveNeedCoin
        -- data.lastPlayTime
        -- data.isAtGameOver
        this.allRound = data.allRound
        this.curRound = data.curRound
        this.lastPlayTime = data.lastPlayTime
        this.playerList = data.roles
        this.settleData = data
        if data.isAtGameOver then
            this:SetCurState(Const.GameStates.disusePlayers)
            if this.allRound == this.curRound then
                this:RecordFinalRank()
            end
        else
            if this.allRound == this.curRound then --最后一轮的结算只能有奖领奖无奖退出
                if this:HasReward() then  --有奖励可领
                    this:SetCurState(Const.GameStates.waitClaimReward)
                else --没有奖励可领
                    log.log("WinZoneModel.S2C_VictoryBeatsSettle 数据有问题1", code, data)
                    this:SetCurState(Const.GameStates.waitExit)
                end
            elseif not data.isDisuse then --晋级了
                this:SetCurState(Const.GameStates.waitOtherRelive)
            elseif this:CanRelive() then  --淘汰但可以复活（这时间看）
                this:SetCurState(Const.GameStates.waitSelfRelive)
            elseif this:HasReward() then  --淘汰不可复活但有奖励可领
                this:SetCurState(Const.GameStates.waitClaimReward)
            else --淘汰不可复活且没有奖励可领
                log.log("WinZoneModel.S2C_VictoryBeatsSettle 数据有问题2", code, data)
                this:SetCurState(Const.GameStates.waitExit)
            end
        end
    else
        this.settleData = nil
        log.log("WinZoneModel.S2C_VictoryBeatsSettle error", code)
    end
end

function WinZoneModel.S2C_VictoryBeatsExit(code, data)
    log.log("WinZoneModel.S2C_VictoryBeatsExit code, data", code, data)
    if code == -99 then
        return
    end

    if code == RET.RET_SUCCESS then
        this:SetCurState(Const.GameStates.none)
        if GetTableLength(data and data.reward) > 0 then
            --this:DisplayReward(data.reward) --这里不直接展示奖励了，
        else
            Facade.SendNotification(NotifyName.WinZone.MatchEnded)
            Event.Brocast(EventName.Event_WinZone_Match_Ended)
        end

        isEverFinishedMatch = true
    else
        log.log("WinZoneModel.S2C_VictoryBeatsExit error", code)
        if code == RET.RET_VICTORY_BEATS_NO_GAME_INFO then
            this:SetCurState(Const.GameStates.none)
            Facade.SendNotification(NotifyName.WinZone.MatchEnded)
            Event.Brocast(EventName.Event_WinZone_Match_Ended)
        else
            log.log("WinZoneModel.S2C_VictoryBeatsExit error 未知错误码", code)
            --对于未知错误码，也暂时做这样的处理
            
            this:SetCurState(Const.GameStates.none)
            Facade.SendNotification(NotifyName.WinZone.MatchEnded)
            Event.Brocast(EventName.Event_WinZone_Match_Ended)
        end
    end

    local bundle = {}
    bundle.code = code
    bundle.reward = data and data.reward
    Facade.SendNotification(NotifyName.WinZone.Exit, bundle)
    ModelList.GiftPackModel:RemoveWinzonePack()
    this:ClearMatchData()
end

function WinZoneModel.S2C_VictoryBeatsReward(code, data)
    log.log("WinZoneModel.S2C_VictoryBeatsReward code, data", code, data)
    if code == -99 then
        return
    end
    if code == RET.RET_SUCCESS then
        -- if not fun.is_table_empty(data.reward) then
        --     local params = {}
        --     params.reward = data.reward
        --     --params.closeCallback = function() end
        --     ViewList.WinZoneRewardView2:SetData(params)
        --     if this:GetSelfRank() == 1 and this.allRound and this.allRound == this.curRound then
        --         ViewList.WinZoneRewardView2:SetData(params)
        --         Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneRewardView2)
        --     else
        --         ViewList.WinZoneRewardView1:SetData(params)
        --         Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneRewardView1)
        --     end
        -- end
        this:SetCurState(Const.GameStates.none)
        if data and data.rounds then
            this:UpdateActivityRoundInfo(data.rounds)
        end

        isEverFinishedMatch = true
    else
        log.log("WinZoneModel.S2C_VictoryBeatsReward error", code)
        this:SetCurState(Const.GameStates.none)
        if code == 16 then
            log.log("WinZoneModel.S2C_VictoryBeatsReward error 16 参数错误，没有可领取的奖励", code)
        else
            log.log("WinZoneModel.S2C_VictoryBeatsReward error 未知错误码", code)
        end
    end

    --- popup 结算奖励返回事件
    Event.Brocast(EventName.Event_WinZone_Popup_Res_SettleReward, code, data)

    local bundle = {}
    bundle.code = code
    bundle.reward = data and data.reward
    Facade.SendNotification(NotifyName.WinZone.ClaimReward, bundle)

    if fun.is_table_empty(bundle.reward) then
        Facade.SendNotification(NotifyName.WinZone.MatchEnded)
        Event.Brocast(EventName.Event_WinZone_Match_Ended)
    end

    ModelList.GiftPackModel:RemoveWinzonePack()
    this:ClearMatchData()
end

function WinZoneModel.S2C_VictoryBeatsRelive(code, data)
    log.log("WinZoneModel.S2C_VictoryBeatsRelive code, data", code, data)
    if code == RET.RET_SUCCESS then
        if this.settleData then
            this.settleData.isDisuse = false
            this.settleData.canRelive = false
        end
        if this.playerList then
            for i, v in ipairs(this.playerList) do
                if this:IsSelf(v.uid) then
                    v.status = Const.PlayerStates.relive
                end
            end
        end
        Facade.SendNotification(NotifyName.WinZone.ReliveSucc)
    else
        local bundle = {errorCode = code}
        Facade.SendNotification(NotifyName.WinZone.ReliveFail, bundle)
        log.log("WinZoneModel.S2C_VictoryBeatsRelive error", code)
    end
end

function WinZoneModel.S2C_VictoryBeatsRankSync(code, data)
    log.log("WinZoneModel.S2C_VictoryBeatsRankSync code, data", code, data)
    if code == RET.RET_SUCCESS then
        
    else
        log.log("WinZoneModel.S2C_VictoryBeatsRankSync error", code)
        --异常不需作处理
    end
end
-------------------------------------------------消息返回-------------------------------------------------End
-------------------------------------------------网络消息-------------------------------------------------End

this.MsgIdList =
{
    {msgid = MSG_ID.MSG_VICTORY_BEATS_FETCH, func = this.S2C_VictoryBeatsInfo},
    {msgid = MSG_ID.MSG_VICTORY_BEATS_JOIN, func = this.S2C_VictoryBeatsJoin},
    {msgid = MSG_ID.MSG_VICTORY_BEATS_PLAY, func = this.S2C_VictoryBeatsPlay},
    {msgid = MSG_ID.MSG_VICTORY_BEATS_SETTLE, func = this.S2C_VictoryBeatsSettle},
    {msgid = MSG_ID.MSG_VICTORY_BEATS_EXIT, func = this.S2C_VictoryBeatsExit},
    {msgid = MSG_ID.MSG_VICTORY_BEATS_REWARD, func = this.S2C_VictoryBeatsReward},
    {msgid = MSG_ID.MSG_VICTORY_BEATS_RELIVE, func = this.S2C_VictoryBeatsRelive},
    {msgid = MSG_ID.MSG_VICTORY_BEATS_RANK_SYNC, func = this.S2C_VictoryBeatsRankSync},
}

return this