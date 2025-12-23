--[[
Descripttion: 
version: 1.0.0
Author: LwangZg
email: 1123525779@qq.com
Date: 2025-06-17 11:03:44
LastEditors: LwangZg
LastEditTime: 2025-07-07 14:48:38
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]
local luaProtocal = require "Common/protocal"
local event = require 'events'
-- local Base64 = require "net.Base64"
---@class NetConnector bingo bang NetConnector
local NetConnector = {};
local this = NetConnector;
---@type ProtoLoader
local ProtoLoader = require "Net.ProtoLoader" --用做静态类了,
_G.Proto = ProtoLoader

local lpbQueue = require "Common/Queue"
local lpbDictionary = require "Common/Dictionary"
local msgQueue = lpbQueue:New()
local SendMsgList = lpbDictionary:New("int", "table")
local maxReconnectCount = 10000   --后台重连最大次数
local backReconnectInterval = 3   --后台重连间隔

this.lastMissConnectTime = 0
function NetConnector.Start()
    logInfo("bingo bang network Start!!");
    ProtoLoader:Load()
    event.AddListener(luaProtocal.Connect, this.OnConnect);
    event.AddListener(luaProtocal.Message, this.OnMessage);
    event.AddListener(luaProtocal.Exception, this.OnException);
    event.AddListener(luaProtocal.Disconnect, this.OnDisconnect);

    this.SendConnectState = 0
    this.ResetMsgList()
    NetConnector.StartProcessMsgQueue()
end

--Socket消息--
function NetConnector.OnSocket(key, data)
    --bingobang网络模块 后端通讯接收后分发到每个业务系统的handle
    --by LwangZg Csharp侧SocketCommand接收到NetworkManager.Update的通知，通过这里回到Lua侧
    event.Brocast(tostring(key), data);

    --lpb这样做!!!
    local msg = { key = key, data = data }
    msgQueue:push(msg)
end

function NetConnector.Close()
    this.SendConnectState = 0
    log.w("NetConnector.Close 连接已关闭")
    this.isConnect = false
    this.TryConectServer = false
    this.ResetMsgList()
    if fun.is_not_null(CS.NetworkManager) then
        CS.NetworkManager:Close()
    end
end

--当连接建立时--
function NetConnector.OnConnect()
    this.isConnect = true
    this.TryConectServer = false
    this.SendConnectState = 2
    Facade.SendNotification(NotifyName.Login.UserEnter);
    NetConnector.ResetReconnect()

    if ModelList.BattleModel:IsGameing() then
        Event.Brocast(EventName.Pause_Battle, false)
    end
end

--异常断线--
function NetConnector.OnException()
    this.loginTimes = 0;
    this.TryConectServer = false
    this.ResetMsgList()
    this.isConnect = false
    this.SetLastMissConnectTime(false)
    if ModelList.loginModel and ModelList.loginModel:IsSessionUsable() then
        Facade.SendNotification(NotifyName.Common.Reconnection)
    end
    logError("OnException------->>>>");
end

--连接中断，或者被踢掉--
function NetConnector.OnDisconnect()
    this.loginTimes = 0;
    this.TryConectServer = false
    this.ResetMsgList()
    this.isConnect = false
    this.SetLastMissConnectTime(false)
    if (this.isConnect) then
        local reconnect_cb = function()
            Facade.SendNotification(NotifyName.Login.ConnectServer)
        end
        Facade.SendNotification(NotifyName.Common.Reconnection, nil, 8019, reconnect_cb)
    end
    logError("OnDisconnect------->>>>");
end

function NetConnector.UpdateErrorCode(msgid, code)
    if (code ~= 0 and msgid > 0) then
        -- Http.report_error("service_error_code","msgid:"..tostring(msgid).." code:"..tostring(code))
    end
end

--登录返回--
function NetConnector.OnMessage(buffer)
    if not NetConnector.isConnect then NetConnector.isConnect = true end
    local onMessRec = function()
        local data = this.unpack_response_data(buffer)
        if data == nil then
            return
        end
        NetConnector.UpdateErrorCode(data.id, data.code)
        --消息id都没有了，先注释掉
        if (data.id ~= MSG_ID.MSG_PING) then
            if ModelList.GuideModel ~= nil then
                ModelList.GuideModel:DisposeGuideStep(data.id)
            end
            --过滤心跳,心跳太烦了
            if log.enabled then
                log.y('@--------Receive NetConnector Message, Id>>: ', data.debugstr, ", data content>>: ", data)
            end
        end
        local a = SendMsgList:Count()
        SendMsgList:Remove(data.id)
        if a > 0 and SendMsgList:Count() == 0 then
            Facade.SendNotification(NotifyName.HideUI, ViewList.NetLoadingView, false, false)
        end
        Message.DispatchMessage(data.id, data.code, data.data, data.seq);
    end
    xpcall(onMessRec, __G__TRACKBACK__)
    logWarn('OnMessage-------->>>');
end

--卸载网络监听--
function NetConnector.Unload()
    event.RemoveListener(luaProtocal.Connect);
    event.RemoveListener(luaProtocal.Message);
    event.RemoveListener(luaProtocal.Exception);
    event.RemoveListener(luaProtocal.Disconnect);
    if ModelList~= nil and #ModelList >0 then
        for _, v in pairs(ModelList) do
            if v ~= nil and v.MsgIdList ~= nil then
                if #v.MsgIdList > 0 then
                    for k1, v1 in ipairs(v.MsgIdList) do
                        if v1.msgid then Message.RemoveMessage(v1.msgid) end
                    end
                end
            end
        end
    end
   
    this.SendConnectState = 0
    logWarn('Unload NetConnector...');
end

--------------------------------------- lpb NetConnector 逻辑 ---------------------------------------
local lastReconnectTime = 0
local reconnectCount = 0
local backgroundConnect = false
this.reconnectView1 = 0
this.reconnectView2 = 0
this.viewList = {}
this.waitNextbackground = false
NetConnector.focus_time = -1 --记录切换到后台的时间

function NetConnector.SendMessage(msgId, msgBodyTb, noNeedRespone, needResend)
    if (not fun.is_null(CS.NetworkManager) and CS.NetworkManager.Connected) then
        if (SendMsgList[msgId] and os.time() - SendMsgList[msgId].time < 2) then
            log.r(msgId .. " 已经发送,服务器未回消息前不能重复发送!")
            return
        end
        local strBody = Base64.encode(ProtoLoader.encode(msgId, msgBodyTb))
        if strBody == nil then
            return
        end
        if needResend and not ModelList.loginModel:IsGetEnterRes() then
            NetConnector.SaveNeedResendMsg(msgId, msgBodyTb)
        end
        if (tonumber(msgId) ~= MSG_ID.MSG_PING and log.enabled) then
            log.r('@--------Send NetConnector Message, Id>>: ' .. NetConnector.MsgIdToString(msgId) .. ', data content>>: ',
                msgBodyTb);
        end
        if noNeedRespone ~= true then
            if SendMsgList[msgId] then
                --SendMsgList[msgId].time = os.time()
            else
                SendMsgList:Add(msgId, { time = os.time() })
                if SendMsgList:Count() == 1 then
                    --临时关闭弹窗 by LwangZg
                    -- Facade.SendNotification(NotifyName.ShowUI, ViewList.NetLoadingView)
                end
            end
        end
        -- print(require "3rd/lua-protobuf/serpent".block(strBody))
        local seq = CS.NetworkManager:SendMessage(msgId, strBody);
        return seq
    else
        if needResend then
            NetConnector.SaveNeedResendMsg(msgId, msgBodyTb)
        end
        --未连网也回包
        Message.DispatchMessage(msgId, -99, nil);
        if not this.TryConectServer and ModelList.loginModel:IsSessionUsable() then
            this.isConnect = false
            Facade.SendNotification(NotifyName.Login.ConnectServer)
            this.TryConectServer = true
        elseif this.TryConectServer and not this.delayReconnect then
            NetConnector.BackgroundReconnect()
        end
        return -1
    end
end

function NetConnector.unpack_response_data(msgBody)
    local splitPos = this.split(msgBody, ":")
    local msgId    = splitPos[1]
    local seq      = splitPos[2]
    local code     = splitPos[3]
    local body     = splitPos[4]
    local data     = {}
    if 2010 == tonumber(msgId) then
        print( "NetConnector.unpack_response_data 2010 msgId:" .. msgId .. " seq:" .. seq .. " code:" .. code)
    end
    data.id        = tonumber(msgId)
    data.debugstr  = NetConnector.MsgIdToString(msgId)
    data.code      = tonumber(code)
    data.seq       = seq --用来对应消息id,客户端发1,服务端回1,每次发送seq+1(自动处理)
    if (#body == 0) then
        data.data = nil
    else
        data.data = ProtoLoader.decode(msgId, Base64.decode(body))
    end
    return data
end

function NetConnector.MsgIdToString(msgId)
    local id = tonumber(msgId)

    if (fun.IsEditor()) then
        for k, v in pairs(MSG_ID) do
            if (v == id) then
                return k .. "   :" .. tostring(id)
            end
        end
        return id
    end
    return id
end

--- 储存需要重发的消息，同一条协议只会保存最新的一条
function NetConnector.SaveNeedResendMsg(msgId, msgBodyTb)
    if not this.needResendMsgList then
        this.needResendMsgList = {}
    end
    this.needResendMsgList[msgId] = msgBodyTb
end

--- 重发需要重发的消息
function NetConnector.ResendNeedResendMsg()
    if this.needResendMsgList then
        for k, v in pairs(this.needResendMsgList) do
            NetConnector.SendMessage(k, v, true)
        end
        this.needResendMsgList = nil
    end
end

function NetConnector.split(str, d) --str是需要查分的对象 d是分界符
    local lst = {}
    local n = string.len(str)  --长度
    local start = 1
    while start <= n do
        local i = string.find(str, d, start) -- find 'next' 0
        if i == nil then
            table.insert(lst, string.sub(str, start, n))
            break
        end
        table.insert(lst, string.sub(str, start, i - 1))
        if i == n then
            table.insert(lst, "")
            break
        end
        start = i + 1
    end
    return lst
end

function NetConnector.StartProcessMsgQueue()
    if (NetConnector.tickHandle) then
        UnityTick.update_tick_remove(NetConnector.tickHandle)
        NetConnector.tickHandle = nil
    end
    NetConnector.tickHandle = UnityTick.update_tick_add(
        function()
            -- log.w("心跳！！ NetConnector.StartProcessMsgQueue!!");
            local msg = msgQueue:pop()
            if (msg ~= nil) then
                Message.DispatchMessage(msg.key, msg.data);
            end
            if SendMsgList:Count() > 0 then
                local nowTime = os.time()
                for key, value in pairs(SendMsgList.keyList) do
                    if value and nowTime - SendMsgList[value].time > 10 then
                        log.r("消息没返回：" .. value)
                        Event.Brocast(EventName.MSG_NOT_RETURN, value)
                        --this.Close()
                        NetConnector.MissMsgTryAgain(value)
                        --UIUtil.show_common_popup(8012,true)
                        this.ResetMsgList()
                        Facade.SendNotification(NotifyName.Common.Reconnection, true)
                        break
                    end
                end
            end
        end)
end

function NetConnector.MissMsgTryAgain(key)
    if key == 2102 then
        ModelList.PlayerInfoSysModel.C2S_RequestAvatarList()
    end
end

function NetConnector.SetLastMissConnectTime(isReset)
    if isReset then
        this.lastMissConnectTime = 0
    else
        if this.lastMissConnectTime == 0 then
            this.lastMissConnectTime = ModelList.PlayerInfoModel.get_cur_client_time()
        end
    end
end

function NetConnector.GetLastMissConnectTime()
    return this.lastMissConnectTime
end

-----静默重连
---
function NetConnector.CanBackgroundReconnect()
    --静默重连
    --if not backgroundConnect and UnityEngine.Time.time - lastReconnectTime >2 and reconnectCount<maxReconnectCount then
    --    return true
    --end
    --return false
    --if not ModelList.BattleModel:IsGameing() then
    --    return true
    --end
    return true
end
function NetConnector.BackgroundReconnect(forceReconnect)
    if not this.waitNextbackground and Http.session_id ~= "" then
        lastReconnectTime = UnityEngine.Time.time
        reconnectCount = reconnectCount + 1
        log.g("reconnectCount  " .. reconnectCount)
        if reconnectCount > maxReconnectCount then
            --Facade.SendNotification(NotifyName.HideUI, ViewList.NetworkLoadingView)
            backgroundConnect = false
            return
        end
        if not NetConnector.isConnect or forceReconnect then
            backgroundConnect = true
            lastReconnectTime = UnityEngine.Time.time
            Facade.SendNotification(NotifyName.Login.ConnectServer)
            if BingoBangEntry.IsInEnterBattleSequence or BingoBangEntry.IsInBattle then
                Facade.SendNotification(NotifyName.Net.BattleReconnect)
            end
            this.waitNextbackground = true
            log.r("NetConnector. delayReconnect ")
            this.delayReconnect = LuaTimer:SetDelayFunction(backReconnectInterval, function()
                this.waitNextbackground = false
                NetConnector.BackgroundReconnect()
                if this.delayReconnect then
                    LuaTimer:Remove(this.delayReconnect)
                    this.delayReconnect = nil
                    log.r("NetConnector. delayReconnect  nil")
                end
            end, nil, LuaTimer.TimerType.NetConnector)
            log.r("NetConnector. delayReconnect " .. this.delayReconnect)
        end
    end
end

function NetConnector.ResetMsgList()
    msgQueue:reset()
    SendMsgList:Clear()
    Facade.SendNotification(NotifyName.HideUI, ViewList.NetLoadingView, false, false)
    ModelList.PlayerInfoModel:logout()
    log.r("NetConnector.ResetMsgList")
end

function NetConnector.ResetSendMsgList()
    SendMsgList:Clear()
end

function NetConnector.ResetReconnect()
    lastReconnectTime = 0
    reconnectCount = 0
    backgroundConnect = false
    this.waitNextbackground = false
    this.SetLastMissConnectTime(true)
    this.lastMissConnectTime = 0
    if this.delayReconnect then
        LuaTimer:Remove(this.delayReconnect, LuaTimer.TimerType.NetConnector)
        this.delayReconnect = nil
        log.r("NetConnector. delayReconnect  nil")
    end
    Facade.SendNotification(NotifyName.HideUI, ViewList.NetworkLoadingView, false, false)

    --统一处理断线重连的消息
end

--------------------------------------- lpb NetConnector 逻辑 ---------------------------------------
NetConnector.protoParser = ProtoLoader

return NetConnector;
