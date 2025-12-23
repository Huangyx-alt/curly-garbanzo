
--网络监听管理--

-- Protocal是C#共用的，定义网络的几种状态

json = require 'cjson'

Network = {};									--网络管理
local this = Network;
this.loginTimes = 0;							--第几次登录成功
this.isConnect = false
this.SendConnectState = 0   --  0 默认状态  1 连接中  2 socket连接成功  3  服务器连接成功
this.state = 0
this.TryConectServer = false
local msgQueue = Queue:New()
local SendMsgList = Dictionary:New("int","table")

local SetLastMissConnectTime = function(isReset)
    if isReset then
        this.lastMissConnectTime = 0
    else
        if this.lastMissConnectTime == 0 then
            this.lastMissConnectTime =  ModelList.PlayerInfoModel.get_cur_client_time()
        end
    end
end


--添加网络监听
function Network.Start()
    log.w("lpb Network.Start!!");
    this.SendConnectState = 0
    Message.AddMessage(Protocal.Connect, this.OnConnect);
    Message.AddMessage(Protocal.Message, this.OnMessage);
    Message.AddMessage(Protocal.Exception, this.OnException);
    Message.AddMessage(Protocal.Disconnect, this.OnDisconnect);
    this.ResetMsgList()
    Network.StartProcessMsgQueue()
end

function Network.StartProcessMsgQueue()
    if(Network.tickHandle)then
        UnityTick.update_tick_remove(Network.tickHandle)
        Network.tickHandle = nil
    end
    Network.tickHandle = UnityTick.update_tick_add(
            function()
                log.e("心跳！！ Network.StartProcessMsgQueue!!");
                local msg = msgQueue:pop()
                if(msg~=nil)then
                    Message.DispatchMessage(msg.key, msg.data);
                end
                if SendMsgList:Count() > 0 then
                    local nowTime = os.time()
                    for key, value in pairs(SendMsgList.keyList) do
                        if value and nowTime - SendMsgList[value].time > 10 then
                            log.r("消息没返回：" .. value)
                            Event.Brocast(EventName.MSG_NOT_RETURN, value)
                            --this.Close()
                            Network.MissMsgTryAgain(value)
                            --UIUtil.show_common_popup(8012,true)
                            this.ResetMsgList()
                            Facade.SendNotification(NotifyName.Common.Reconnection,true)
                            break
                        end
                    end
                end
            end)
end

function Network.MissMsgTryAgain(key)
    if key == 2102 then
        ModelList.PlayerInfoSysModel.C2S_RequestAvatarList()
    end
end

--卸载网络监听
function Network.Unload()
    Message.RemoveMessage(Protocal.Connect);
    Message.RemoveMessage(Protocal.Message);
    Message.RemoveMessage(Protocal.Exception);
    Message.RemoveMessage(Protocal.Disconnect);
    for k, v in pairs(ModelList) do
        for k1, v1 in ipairs(v.MsgIdList) do
            if v1.msgid then Message.RemoveMessage(v1.msgid) end
        end
    end
    log.w('Unload Network...');
    this.SendConnectState = 0
end

--Socket消息
--@key 消息id
--@data: [net.NetData#NetData]
function Network.OnSocket(key, data)
    -- Message.DispatchMessage(key, data);
    local msg = {key= key,data=data}
    msgQueue:push(msg)
end

function Network.Close()
    this.SendConnectState = 0
    log.w("Network.Close 连接已关闭")
    this.isConnect = false
    this.TryConectServer = false
    this.ResetMsgList()
    if fun.is_not_null(CS.NetworkManager) then
        CS.NetworkManager:Close()
    end
end

function Network.ResetMsgList()
    msgQueue:reset()
    SendMsgList:Clear()
    Facade.SendNotification(NotifyName.HideUI, ViewList.NetLoadingView,false,false)
    ModelList.PlayerInfoModel:logout()
    log.r("Network.ResetMsgList")
end

function Network.ResetSendMsgList()
    SendMsgList:Clear()
end

function Network.Connect(host,port)
    log.e(string.format("请求链接 host%s port%s ",host,port))
    if not fun.is_null( CS.NetworkManager) then
        Network.SendConnectState = 1
        CS.NetworkManager:SendConnect(host,port)
    end
end

---@param needResend boolean 当消息发送失败,是否需要重发
function Network.SendMessage(msgId,msgBodyTb,noNeedRespone,needResend)
    if(not fun.is_null( CS.NetworkManager) and   CS.NetworkManager.Connected)then
        if(SendMsgList[msgId]  and os.time() -SendMsgList[msgId].time <2  )then
            log.r(msgId.." 已经发送,服务器未回消息前不能重复发送!")
            return
        end
        local strBody =Base64.encode(Proto.encode(msgId,msgBodyTb))
        if strBody == nil then
            return
        end
        if needResend and not ModelList.loginModel:IsGetEnterRes() then
            Network.SaveNeedResendMsg(msgId,msgBodyTb)
        end
        if(tonumber(msgId)~= MSG_ID.MSG_PING  and log.enabled )then
            log.r('@--------Send Network Message, Id>>: ' .. Network.MsgIdToString(msgId)   .. ', data content>>: ' ,msgBodyTb);
        end
        if noNeedRespone ~= true then
            if SendMsgList[msgId] then
                --SendMsgList[msgId].time = os.time()
            else
                SendMsgList:Add(msgId,{time = os.time()} )
                if SendMsgList:Count()  == 1 then
                    Facade.SendNotification(NotifyName.ShowUI, ViewList.NetLoadingView)
                end
            end
        end
        local seq = CS.NetworkManager:SendMessage(msgId,strBody);
        return seq
    else
        if needResend then
            Network.SaveNeedResendMsg(msgId,msgBodyTb)
        end
        --未连网也回包
        Message.DispatchMessage(msgId, -99, nil);
        if not this.TryConectServer and ModelList.loginModel:IsSessionUsable() then
            this.isConnect = false
            Facade.SendNotification(NotifyName.Login.ConnectServer)
            this.TryConectServer = true
        elseif this.TryConectServer and not this.delayReconnect then
            Network.BackgroundReconnect()
        end
        return -1
    end
end

--- 储存需要重发的消息，同一条协议只会保存最新的一条
function Network.SaveNeedResendMsg(msgId,msgBodyTb)
    if not this.needResendMsgList then
        this.needResendMsgList = {}
    end
    this.needResendMsgList[msgId] = msgBodyTb
end

--- 重发需要重发的消息
function Network.ResendNeedResendMsg()
    if this.needResendMsgList then
        for k,v in pairs(this.needResendMsgList) do
            Network.SendMessage(k,v,true)
        end
        this.needResendMsgList = nil
    end
end



--当连接建立时--需要跟服务端发送session等信息，进行身份验证
function Network.OnConnect()
    log.w("Network---Game Server connected!!");
    this.isConnect = true
    this.TryConectServer = false
    this.SendConnectState = 2
    Facade.SendNotification(NotifyName.Login.UserEnter);
    Network.ResetReconnect()

    if ModelList.BattleModel:IsGameing()  then
        Event.Brocast(EventName.Pause_Battle,false)
    end
end

--异常断线--
function Network.OnException()
    this.loginTimes = 0;
    this.TryConectServer = false
    this.ResetMsgList()
    this.isConnect = false
    SetLastMissConnectTime(false)
    if ModelList.loginModel and ModelList.loginModel:IsSessionUsable() then
        Facade.SendNotification(NotifyName.Common.Reconnection)
    end
end


--连接中断，或者被踢掉--
function Network.OnDisconnect()
    this.loginTimes = 0;
    this.TryConectServer = false
    this.ResetMsgList()
    this.isConnect = false
    SetLastMissConnectTime(false)
    log.r("Network---OnDisconnect------->>>>");
    if(this.isConnect)then
        local reconnect_cb = function ()
            Facade.SendNotification(NotifyName.Login.ConnectServer)
        end
        Facade.SendNotification(NotifyName.Common.Reconnection,nil,8019,reconnect_cb)
    end

end

local function split(str, d) --str是需要查分的对象 d是分界符
    local lst = { }
    local n = string.len(str)--长度
    local start = 1
    while start <= n do
        local i = string.find(str, d, start) -- find 'next' 0
        if i == nil then
            table.insert(lst, string.sub(str, start, n))
            break
        end
        table.insert(lst, string.sub(str, start, i-1))
        if i == n then
            table.insert(lst, "")
            break
        end
        start = i + 1
    end
    return lst
end

--登录返回--
local function unpack_response_data(msgBody)
    local splitPos = split(msgBody,":")
    local msgId = splitPos[1]
    local seq = splitPos[2]
    local code  = splitPos[3]
    local body   = splitPos[4]
    local data = {}
    data.id = tonumber(msgId)
    data.debugstr = Network.MsgIdToString(msgId)
    data.code = tonumber(code)
    data.seq = seq   --用来对应消息id,客户端发1,服务端回1,每次发送seq+1(自动处理)
    if(#body==0)then
        data.data = nil
    else
        data.data = Proto.decode(msgId,Base64.decode(body))
    end
    return data
end

function Network.MsgIdToString(msgId)
    local id = tonumber(msgId)

    if(fun.IsEditor())then
        for k,v in pairs(MSG_ID) do
            if(v==id)then
                return k.."   :"..tostring(id)
            end
        end
        return id
    end
    return id

end

function Network.UpdateErrorCode(msgid,code)
    if(code~=0 and msgid>0)then
        Http.report_error("service_error_code","msgid:"..tostring(msgid).." code:"..tostring(code))
    end
end

function Network.OnMessage(bodyStr)
    --log.y("Network---OnMessage---",bodyStr)  --
    if not Network.isConnect then Network.isConnect = true end
    local onMessRec = function()
        local data = unpack_response_data(bodyStr)
        if data == nil then
            return
        end
        Network.UpdateErrorCode(data.id, data.code)
        --消息id都没有了，先注释掉
        if( data.id ~= MSG_ID.MSG_PING  )then
            if ModelList.GuideModel ~= nil then
                ModelList.GuideModel:DisposeGuideStep(data.id)
            end
            --过滤心跳,心跳太烦了
            if log.enabled then
                    log.y('@--------Receive Network Message, Id>>: ' ,data.debugstr , ", data content>>: " , data)
            end
        end
        local a = SendMsgList:Count()
        SendMsgList:Remove(data.id)
        if a >0 and SendMsgList:Count()  == 0 then
            Facade.SendNotification(NotifyName.HideUI, ViewList.NetLoadingView,false,false)
        end
        Message.DispatchMessage(data.id, data.code,data.data,data.seq);
    end
    xpcall(onMessRec,__G__TRACKBACK__)
end


local lastReconnectTime = 0
local reconnectCount = 0
local backgroundConnect = false
this.reconnectView1 = 0
this.reconnectView2 = 0
this.viewList = {}
this.waitNextbackground = false
Network.focus_time=-1    --记录切换到后台的时间


function Network.ResetReconnect()
    lastReconnectTime = 0
    reconnectCount = 0
    backgroundConnect = false
    this.waitNextbackground =false
    SetLastMissConnectTime(true)
    this.lastMissConnectTime = 0
    if this.delayReconnect then
        LuaTimer:Remove(this.delayReconnect,LuaTimer.TimerType.Network)
        this.delayReconnect = nil
        log.r("Network. delayReconnect  nil")
    end
    Facade.SendNotification(NotifyName.HideUI, ViewList.NetworkLoadingView, false, false)

    --统一处理断线重连的消息
end

local maxReconnectCount = 10000   --后台重连最大次数
local backReconnectInterval = 3   --后台重连间隔

--重连次数得到当前重连次数
function Network.getReconnectCount()
    
end

function Network.CanBackgroundReconnect()
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
--静默重连
function Network.BackgroundReconnect(forceReconnect)
    if not this.waitNextbackground and Http.session_id ~= "" then
        lastReconnectTime = UnityEngine.Time.time
        reconnectCount = reconnectCount + 1
        log.g("reconnectCount  "..reconnectCount)
        if reconnectCount>maxReconnectCount then
            --Facade.SendNotification(NotifyName.HideUI, ViewList.NetworkLoadingView)
            backgroundConnect = false
            return
        end
        if not Network.isConnect  or forceReconnect then
            backgroundConnect = true
            lastReconnectTime = UnityEngine.Time.time
            Facade.SendNotification(NotifyName.Login.ConnectServer)
            if ModelList.BattleModel:IsGameing() then
                Facade.SendNotification(NotifyName.Net.BattleReconnect)
            end
            this.waitNextbackground = true
            log.r("Network. delayReconnect ")
            this.delayReconnect = LuaTimer:SetDelayFunction(backReconnectInterval,function()
                this.waitNextbackground = false
                Network.BackgroundReconnect()
                if this.delayReconnect then
                    LuaTimer:Remove(this.delayReconnect)
                    this.delayReconnect = nil
                    log.r("Network. delayReconnect  nil")
                end
            end,nil,LuaTimer.TimerType.Network)
            log.r("Network. delayReconnect "..this.delayReconnect)
        end
    end

end


this.lastMissConnectTime = 0  --最近丢失连接的时间
function Network.GetLastMissConnectTime()
    return this.lastMissConnectTime
end






