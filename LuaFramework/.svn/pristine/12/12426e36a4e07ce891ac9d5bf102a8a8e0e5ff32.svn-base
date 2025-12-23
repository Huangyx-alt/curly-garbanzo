require "pblua.PB_Common"
require "Common.config"
require "Common.fun"
-- require "net.Proto" --大改网络模块 by LwwangZg
require "Logic.ErrorReport"

local json = require "cjson"
local Base64 = require "net.Base64"
local protoParser = BingoBangEntry.network.protoParser

--接口基础配置
local URL_BASE = AppConst.HTTP_SERVER_IP
local URL_DEFAULT = AppConst.HTTP_SERVER_IP

-- local USE_PROTOBUF = true
---@diagnostic disable
local USE_PROTOBUF = false


--拼接URL,并实现切换不同服务器环境
function build_url(keywords)
	return URL_BASE..keywords
end

Http = {}
Http.APP_ID = "0"
Http.session_id = ""
Http.hung_requests = {}
Http.requests_cost_time = {}
Http.stop_ping = true

Http.request_time = {}  --key 消息id，value 时间（毫秒）
Http.request_cout = {}  --key 消息id，请求次数


Http.while_list_no_process = {
	--MSG_ID.MSG_USER_PING,
	--MSG_ID.MSG_ERROR_REPORT,
	--MSG_ID.MSG_EVENT_REPORT,
}

--重新登录时调用此方法清理本地ck
function Http.init()
	Http.session_id = ""
	Http.register()
end

function Http.get_session_is_empty()
	if Http.session_id == "" then
		return true
	else
		return false
	end
end

function Http.clean_api_cost()
	Http.request_time = {}  --key 消息id，value 时间（毫秒）
	Http.request_cout = {}  --key 消息id，请求次数
	Http.hung_requests = {}
end
function Http.register()
	Event.RemoveListener(EventName.Event_App_Pause,Http.clean_api_cost)
	Event.AddListener(EventName.Event_App_Pause,Http.clean_api_cost)
end

function pack_request_data(msg_id,tbl)
	if USE_PROTOBUF then
		 return Base64.encode(protoParser.encode(msg_id,tbl))
        -- return Base64.encode(Proto.encode(msg_id,tbl))
	else
		return TableToJson(tbl)
	end
end

function unpack_response_data(msg_id,str)
	local obj = json.decode(str)
	if USE_PROTOBUF then
		obj.data = protoParser.decode(msg_id,Base64.decode(obj.data))
        -- obj.data = Proto.decode(msg_id,Base64.decode(obj.data))
	end
	return obj
end

-- 转译网络数据
local function mapping(o,dic)
    if not o then return end
    local r = {}
    if dic._is_array then
        if dic._item_is_table then
            for i,v in ipairs(o) do
                dic._is_array = false
                table.insert(r,mapping(v,dic))
            end
        else
            for i,v in ipairs(o) do
                table.insert(r,v)
            end
        end
    else
        for k,v in pairs(dic) do
            if type(v) == "table" then
                r[k] = mapping(o[v._name],v)
            else
                if k[1] ~= "_" then
                    r[k] = o[v]
                end
            end
        end
    end
    return r
end

--根据消息ID，取消息名称
local function get_msg_type_name(msg_id)
	for k,v in pairs(MSG_ID) do
		if msg_id == v then return k end
	end
end

--RET_SYSTEM_MAINTAIN

local function build_session_invalid_dialog()
	Http.clear_hunged_requests()
	Http.stop_ping = true
	local title = "System Error"
	local content = "Your account session has expired,\nplease log in again."
	local hide_close_btn = true
	local callback = function() UIUtil.logout() end
	Panel.show_tips(title,content,hide_close_btn,callback)
end

local function build_session_timeout_dialog()
	Http.stop_ping = true
	if(Http.session_id ~="")then
		Http.clear_hunged_requests()
		local title = "System Error"
		local content = "Problems with the current network,\nplease try again."
		local hide_close_btn = true
		local callback = function() UIUtil.logout() end

		SDK.send_net_timeout()

		Panel.show_tips(title,content,hide_close_btn,callback)
	end
end


local function build_system_maintain_dialog(http_content)
	Http.stop_ping = true
	local title = "System Maintain"
	local content = http_content
	local hide_close_btn = true
	local callback = function() UnityEngine.Application.Quit() end
	Panel.show_tips(title,content,hide_close_btn,callback)
end

local function save_msg_cost_time(msg_id,ret_code)
	--if(ret_code==200)then
		local time = Http.requests_cost_time[msg_id]
		if(time==nil)then
			--log.r("msg_is request time is nil",msg_id)
			return
		end
		local endtime = now_millisecond()
		local cost_time = endtime-time
		local date =  os.date("*t",endtime);
		--log.y("cost_time",msg_id,time,endtime,cost_time,date)
		if(Http.request_time[msg_id] == nil)then
			Http.request_time[msg_id] = cost_time
		else
			Http.request_time[msg_id] = Http.request_time[msg_id]+cost_time
		end

		if(Http.request_cout[msg_id] == nil)then
			Http.request_cout[msg_id] = 1
		else
			Http.request_cout[msg_id] = Http.request_cout[msg_id]+1
		end
	--end
end

local net_msg_size = 0





local function get_http_key(msg_id,tbl)
	if USE_PROTOBUF then
		return tostring(msg_id)..Util.md5(pack_request_data(msg_id,tbl))
	else
		return msg_id
	end
end

--- 检查文本内容是不是html格式
local function check_html_content(content)
	local htmlPattern = "<[^>]+>"
	local isHtml = string.find(content, htmlPattern)
	if isHtml then
		return true
	else
		return false
	end
end

--框架方法，不应该直接调用
local function do_post(msg_id,tbl,callback,req_error_callback)
	-- 设置超时时间. 使用2秒做测试. 7秒是正式时间.
	--log.y("[do_post]",callback)
	local timeout = 10
	local key = get_http_key(msg_id,tbl)
	if false then
		--if Http.hung_requests[key] then
		log.r("same request "..msg_id.." is hunging, wait...".." key:"..key)
		if(req_error_callback)then
			req_error_callback();
		end
	else

		local c = msg_id
		local k = pack_request_data(msg_id,tbl)
		local s = Http.session_id
		local f = USE_PROTOBUF and "pbuf" or "json"
		local function post_callback(code, txt,oriUri,currentUri,redirectUri)
			--log.y("code",code,"msg_id:",msg_id,"[Http原始响应数据]",txt)
			save_msg_cost_time(msg_id,code)
			Http.hung_requests[key] = nil
 
			if code == 200  then
				local obj = ""
				if check_html_content(txt) then -- html内容直接返回
					--local str = nil
					--if k and s and f then
					--	--str = string.format("http error msg_id=%s   k=%s   s=%s  f=%s",tostring(msg_id),k,tostring(s),tostring(f))
					--	str = "http error msg_id:"..tostring(msg_id).."  data: "..(k).."  sessionid: "..tostring(s).." type: "..tostring(f)
					--else
					--	str = string.format("http error msg_id=%s",tostring(msg_id))
					--end
					--
					--if oriUri then
					--	str = str .. string.format(" oriUri =%s   currentUri=%s   redirectUri=%s",tostring(oriUri),tostring(currentUri),tostring(redirectUri))
					--end
					--SDK.send_error_log_to_server(str)
					if callback then
						callback(-1,"Http Error " .. code, nil)
					end
					Message.DispatchMessage(msg_id,-1,nil)
				else
					local status, err = pcall(function()
						-- 可能会出现异常的代码
						obj = unpack_response_data(msg_id,txt)
					end)
					if not status then
						SDK.send_error_log_to_server("http解析错误 error".. tostring(err).."   txt "..tostring(txt).."   msg_id  "  ..tostring(msg_id))
						if callback then
							callback(-1,"Http Error " .. code, nil)
						end
						Message.DispatchMessage(msg_id,-1,nil)
					else
						if callback then
							callback(obj.code,obj.message,obj.data)
						end
						Message.DispatchMessage(msg_id,obj.code,obj.data)
					end

				end
			else
			 
				if callback then
					callback(-1,"Http Error " .. code, nil) 
				end
				Message.DispatchMessage(msg_id,-1,nil)
			end
		end
		--log.o("[Http请求>>>]",Http.get_current_network_name(),get_msg_type_name(msg_id),msg_id,tbl)
		-- log.o("Http请求 [URL_BASE]： " .. URL_BASE)
		-- URL_BASE = "http://192.168.1.231:8088"
		-- log.o("Http请求 [URL_BASE]： " .. URL_BASE)
		local request = LuaHttpRequest.New(URL_BASE,"post", post_callback)
		request:AddHeader("Content-Type","application/x-www-form-urlencoded")
		request:AddField("c",c)
		request:AddField("k",k)
		request:AddField("s",s)
		request:AddField("f",f)
		log.r(string.format("c: %s,k: %s s: %s f: %s",c,k,s,f))
		Http.hung_requests[key] = now_millisecond()

		local reqKey = tostring(key)..tostring(Http.hung_requests[key])
		
		--重写了http请示队列，保证回调是在主线程内，不会因为子线程问题导致，reqKey是唯一不重复使用
		request:Do(reqKey)
		Http.requests_cost_time[msg_id] = Http.hung_requests[key]
	end
end


local function do_get(url,callback) 
	local function get_callback(code, txt) 
		if code == 200 then
			local obj = json.decode(txt)
			local status, err = pcall(function()
				obj = json.decode(txt)
			end)
			if not status then
				SDK.send_error_log_to_server(string.format("http解析错误 error = %s  txt:%s   url:s%",   err,txt,url))
			else
				if callback then
					callback(obj.code,obj.data)
				end
			end
		else 
			if callback then
				callback(-1,"Http Error " .. code, nil) 
			end 
		end
	end
	log.o("[Http get请求>>>]",url)
	--log.o("[URL_BASE]： " .. URL_BASE)
	local request = LuaHttpRequest.New(url,"get", get_callback)
	request:AddHeader("Content-Type","application/x-www-form-urlencoded")
	--重写了http请示队列，保证回调是在主线程内，不会因为子线程问题导致，reqKey是唯一不重复使用
	request:Do(url) 
end

-- 接口报错通用处理
local function on_post_error(msg_id, param, code, msg, data)
	log.r({
		error = "接口报错",
		msg_id = get_msg_type_name(msg_id),
		code = code,
		msg = msg,
		data = data,
	})
end

function Http.clear_hunged_requests()
	for k, v in pairs(Http.hung_requests) do
		Http.hung_requests[k] = nil
	end
end


function Http.is_request_hung(msg_id) 
	local same_hung_request = Http.hung_requests[msg_id]
	if same_hung_request == nil then
		return false
	else
		-- 15秒超时
		return now_millisecond() - same_hung_request < 15000
	end
end 

--登录
function Http.login(callback,openid,token,device_id, platform,fail_callback,clearSession,jsonStr)
	local t = {}

	if clearSession then
		Http.session_id = ""
	end

	if Http.session_id~="" then
		log.r("Http.session_id 没有清理,不能登陆")
		SDK.login_event("login_fail_session_id")
		if(fail_callback)then
			fail_callback()
		end
		return
	end--已经登陆过，直接返回

	Network.Close() -- http 请求登录之前先关闭下

	local func = function(openid,token,device_id, platform)
		-- if not openid or not token or openid == "" or token == "" then
		-- 	log.log("请登录数据失败")
		-- 	return
		-- end
		local SystemInfo = UnityEngine.SystemInfo;
		t.openid = tostring(openid)
	    --t.openid = "89ea8dfe7c35094d6ef4b3573165401b5c12fdd79ew4VKPEBmBKiQn"
		t.token = tostring(token)
		t.platform = tonumber(platform)
		t.idfa = device_id
		t.deviceId = UnityEngine.SystemInfo.deviceUniqueIdentifier
		local DeviceToken = "editor"
		DeviceToken = UnityEngine.PlayerPrefs.GetString("DeviceToken","editor")
		t.deviceToken = DeviceToken --FirebaseHelper.LocalDeviceToken or "editor"
		t.appsflyerId = "editor" --SDK.GetAppFlyerId() or "editor"
		t.traceAdId   = "editor" --SDK.GetAppFlyerId() or "editor"
		t.conversion = fun.read_value2("ConversionData", "")
		--log.e("t.conversion = "..t.conversion)
		t.localTime = os.time()
		t.cpuInfo = SystemInfo.processorType
		t.systemInfo = SystemInfo.operatingSystem
		t.netWork = fun.get_network()
        t.platformInfo = jsonStr or ""
		t.versionCode = AppConst.VERSIONCODE
		t.installVersion =  tostring( UIUtil.get_install_version() )
		
		log.log(
				"请求登录\nopenid =",t.openid,
				"\ntoken =",t.token,
				"\nplatform =",t.platform,
				"\ndevideId =",t.deviceId
		)
		local score = fun.get_int("mobile_score",0)--性能评分
		t.score = score
		t.version = tostring(UIUtil.get_client_version())
        t.platformInfo = jsonStr or ""
        t.isRestrict = not string.is_empty(jsonStr)

		-- ThinkingAnalyticsHelper.Instance:Login(t.openid) --打点

		do_post(MSG_ID.MSG_USER_LOGIN,t,function(code,msg,data)
			log.r("登录数据",{code=code,msg=msg,data=data})
			if code == RET.RET_SUCCESS then
				Http.session_id = data.sessionId
				SDK.login_event("get_login_data")
				if t.platform == PLATFORM.PLATFORM_FACEBOOK then
					--是FB登录 提前替换头像
					log.log("FB登录提前替换头像")
					--SDK.request_player_head_photo(function(sprite)
					--end)
				end
				if callback then callback(code,msg,data) end
			elseif code == RET.RET_TOKEN_INVALID then
				SDK.refresh_access_token()
				log.r("服务器返回token无效，需要重新使用sdk登录")
				SDK.login_event("login_invalid_token")
				if(fail_callback)then
					fail_callback()
				end
			else
				SDK.login_event("login_fail")
				if(fail_callback)then
					fail_callback()
				end
			end

		end)
	end

	if device_id == nil then
		Util.RequestIDFA(function (device_id)
			func(openid,token,device_id, platform)
		end)
	else
		func(openid,token,device_id, platform)
	end
end

function Http.ab_test_upload_config()
	--[[消息号都没了，先注释掉
	local keys_str = SdkUtil.FirebaseReadRemoteConfig("keys")
	if keys_str and #keys_str>0 then
		local keys = JsonToTable(keys_str)
		local dic = {}
		for i,v in ipairs(keys) do
			dic[v] = SdkUtil.FirebaseReadRemoteConfig(v)
		end

		log.g("远程配置",dic)
		do_post(MSG_ID.MSG_CONFIG_REPORT,{config=TableToJson(dic)},function(code,msg,data)
			log.g({"远程配置上传",code=code,msg=msg,data=data})
		end)
	end
	--]]
end

--向服务器上报错误信息
--type 见ErrorReport
function Http.report_error(category,msg)
	--do_post(MSG_ID.MSG_ERROR_REPORT,{category=category,message=msg},function(code,msg,data)
	--	log.g({"错误消息上传",category=category,message=msg,resp={code=code,msg=msg,data=data}})
	--end)
	do_post(MSG_ID.MSG_ERROR_REPORT,{category=category,message=msg})
end


function Http.report_http_error(code,msgid,post_data,rec_msg)
	--[[消息号都没了，先注释掉
	if(code >0 and code <1000)then
		local category = ErrorReport.NET_ERROR
		local msg = {}

		if(msgid ~= nil)then
			msg.msg_id = msgid
		end
		if(post_data ~= nil)then
			msg.post_data = post_data
		end
		if(rec_msg ~= nil and #rec_msg>0)then
			msg.rec_msg = rec_msg
		end
		msg.ret_code = code
		do_post(MSG_ID.MSG_ERROR_REPORT,{category=category,message=TableToJson(msg)},function(code,msg,data)
			log.g({"错误消息上传",category=category,message=msg,resp={code=code,msg=msg,data=data}})
		end)
	end
	--]]
end


--向服务器上报事件信息
function Http.report_event(event, data, callback)
	--data = nil
	data = data or "{\"clientVersion\":"..UIUtil.get_client_version().."\"".."}"
	if(type(data) == "table")then
		data.clientVersion = UIUtil.get_client_version()
		data = TableToJson(data)
	end
	--log.r("================>>report_event data  " .. data)
	local selfId = 0
	if ModelList.PlayerInfoModel then
		selfId = ModelList.PlayerInfoModel:GetUid()
	end
	local af_id = SDK.af_tracker:GetAppFlyerId()
	do_post(MSG_ID.MSG_EVENT_REPORT,{event=event, data = data , uid = selfId,traceAdId  =af_id, afid = af_id ,clientTime = os.time() },function(code,msg,data)
		--log.g({"事件上传",event=event,resp={code=code,msg=msg,data=data}})
        if callback then callback(code, msg, data) end
	end)

	-- ThinkingAnalyticsHelper.Instance:Track(event,data)

	--22/11/14 换成数数
end

--[[改为使用tcp请求方式了
-- 绑定用户
function Http.bind_user( openid, token, platform, callback)
	local param = {}
	param.token = token
	param.openid = openid
	param.platform = tonumber(platform)

	do_post(MSG_ID.MSG_USER_BIND, param, function(code,msg,data)
		if callback then callback(code,msg,data) end
	end)
end
--]]

function Http.bind_FB_and_login(callback)
    SDK.login(function(AccessToken, jsonStr, platform)
		SDK.logout()
        if not AccessToken then 
			log.r("sdk请求失败！") 
			--Panel.show_error(ErrorReport.FACEBOOK_LOGIN_ERROR, false)
				Facade.SendNotification(NotifyName.ShowErrorTip, {type = ErrorView.error_type.ErrorTip ,content = "The request failed !!" ,btn_str = "OK",ok_func = 
				function()
				end,
				close_func = function()
				end})
            return
        end
        local token = AccessToken.TokenString
		local openid = AccessToken.UserId
		
        -- 首先尝试绑定用户
        Http.bind_user(openid, token, PLATFORM.PLATFORM_FACEBOOK, function(code,msg,data)    
            -- 如果绑定成功
            if callback then callback(code,msg, data, openid, token, PLATFORM.PLATFORM_FACEBOOK) end
        end,openid,token,platform)
    end)
end

--获取商店
function Http.fetch_shop(shop_type,callback)

	do_post(MSG_ID.MSG_FETCH_SHOP,{shopType = shop_type},callback)
end

--获取任务
function Http.fetch_task()
	do_post(MSG_ID.MSG_FETCH_TASK,{})
end
--领取blast奖励
function Http.get_blast_reward()
	do_post(MSG_ID.MSG_BLAST_DAILY_AWARD,{})
end
--获取blast运营活动开启信息
function Http.fetch_blast()
	local data = os.date("%Y%m%d%H%M%I%S")
	do_post(MSG_ID.MSG_FETCH_REWARD_INFO,{localtime = data , rewardType = "blastDaily"})
end
--获取TimeBonus
function Http.fetch_timeBonus()
	local data = os.date("%Y%m%d%H%M%I%S")
	log.log("发送的本地时间：" , data)
	do_post(MSG_ID.MSG_FETCH_REWARD_INFO,{localtime = data})
end

function Http.fetch_ad_reward()
	local data = os.date("%Y%m%d%H%M%I%S")
	log.log("发送的本地时间：" , data)
	do_post(MSG_ID.MSG_FETCH_REWARD_INFO,{localtime = data , rewardType = "video"})
end

function Http.fetch_ad_diamond_reward()
	local data = os.date("%Y%m%d%H%M%I%S")
	log.log("发送的本地时间：" , data)
	do_post(MSG_ID.MSG_FETCH_REWARD_INFO,{localtime = data , rewardType = "diamond"})
end

--[[
    @desc: 
    author:{author}
    time:2020-12-22 17:57:24
    --@bonusType: 空为所有，login,shopBonus,timeBonus1,timeBonus2,timeBonus3
    @return:
]]
function Http.fetch_Bonus(bonusType)
	local data = os.date("%Y%m%d%H%M%I%S")
	log.log("发送的本地时间：" , data)
	do_post(MSG_ID.MSG_FETCH_REWARD_INFO,{localtime = data,rewardType = bonusType})
end


--获取TimeBonus
function Http.fetch_timeBonus_reward(i)
	do_post(MSG_ID.MSG_TIME_BONUS_AWARD,{seq = i})
end

--领取奖励
function Http.fetch_task_reward(type)
	do_post(MSG_ID.MSG_TASK_AWARD,{taskType = type})
end
 
--领取周奖励
function Http.fetch_task_week_reward(type)
	do_post(MSG_ID.MSG_TASK_WEEK_AWARD,{node = type})
end
 

function Http.fetch_shop_item(item_index,callback)
	--My.set_last_purchase_item_id(item_index)
	do_post(MSG_ID.MSG_BUY_ITEM,{index =tostring(item_index) },callback)
end
 

--查询昵称修改信息
function Http.get_nickname_up_time(callback)
	do_post(MSG_ID.MSG_NICKNAME_UP_TIMES,{}, function (code, msg, data)
		if code == RET.RET_SUCCESS then
		--My.nickname_change(data)
		end
		if(callback) then callback(code, msg, data) end
	end)
end

--修改昵称
function Http.change_nickname(name, callback)
	do_post(MSG_ID.MSG_SET_NICKNAME,{nickname = tostring(name)}, function (code, msg, data)
		if code == RET.RET_SUCCESS then
			-- My.nickname = data.nickname
			Event.Brocast(EventName.Event_name_change)
			if(callback) then callback(code, msg, data) end
		else
			log.r("change_nickname error code"..code , "错误了")
		end
		log.log("修改昵称返回", data)
	end)
end

--设置头像
function Http.change_portrait(portrait, callback)
	do_post(MSG_ID.MSG_SET_AVATAR, {avatar = tostring(portrait)}, function (code, msg, data)
		if code == RET.RET_SUCCESS then
			--My.avatar = data.avatar
			Event.Brocast(EventName.Event_change_avatar)
			if(callback) then callback(code, msg, data) end
		end
	end)
end

function Http.change_sign(str, callback)
	do_post(MSG_ID.MSG_SET_SIGNATURE, {signature = tostring(str)}, function (code, msg, data)
		if code == RET.RET_SUCCESS then
			-- My.avatar = data.avatar
			-- Event.Brocast(EventName.Event_change_avatar)
			if(callback) then callback(code, msg, data) end
		end
	end)
end

--获取用户信息
function Http.fetch_user_info(uid,callback)
	log.log("请求的uid数据c" , uid)
	do_post(MSG_ID.MSG_USER_FETCH, {uid = tonumber(uid)}, function (code, msg, data)

		if callback then
			callback(code, msg, data)
		end
		-- if code == RET.RET_SUCCESS then
		-- 	My.fetch_user_info(data)
		-- 	if callback then callback(code, msg, data) end
		-- end
	end)
end

-- 获取banner信息
function Http.fetch_banners(callback)
	do_post(MSG_ID.MSG_FETCH_BANNERS,{},function(code,msg,data)
		if code == RET.RET_SUCCESS then
			local r = {}

			r.secondBanner = {}
			r.mainBanner = {}
			for i, v in ipairs(data.secondBanners) do
				local m = {}
				m.picture = v.picture --banner图片地址
				m.name = v.name --banner名字
				m.popups = v.popups --banner弹窗信息
				m.expireTime = v.expireTime --过期时间(剩余秒数)
				m.md5 = v.md5
				m.size = v.size
				r.secondBanner[i] = m

			end

			for i, v in ipairs(data.mainBanners) do
				local m = {}
				m.picture = v.picture --banner图片地址
				m.name = v.name --banner名字
				m.popups = v.popups --banner弹窗信息
				m.expireTime = v.expireTime --过期时间(剩余秒数)
				m.md5 = v.md5
				m.size = v.size
				r.mainBanner[i] = m
			end

			if callback then callback(r) end
		else
			log.r({info = "大厅banner列表网络错误",code=code,msg=msg,data=data})
			if callback then callback(r) end
		end
	end)

end
  
-- 支付的轮询
function Http.PollPayState(pid, orderId,token, productId,receipt,callback,chanel)
	local platform = UnityEngine.Application.platform
	if not chanel then
		chanel = PAY_CHANNEL.PAY_CHANNEL_GOOGLE_PLAY
		if platform == UnityEngine.RuntimePlatform.Android then
			chanel =  PAY_CHANNEL.PAY_CHANNEL_GOOGLE_PLAY
		elseif platform == UnityEngine.RuntimePlatform.IPhonePlayer or platform == UnityEngine.RuntimePlatform.OSXPlayer then
			chanel = PAY_CHANNEL.PAY_CHANNEL_APPLE_STORE
		end
	end

    local params = {
		productId = productId or 0,
		errorcode = 2,
		city ="1",
		token = token or "",
		receipt=receipt or 0,
	}
	params = json.encode(params)

	do_post(MSG_ID.MSG_PAY_NOTIFY, {
		pid = pid or 0, 
		orderId = orderId or 0,
		payChannel = chanel,
		payParams = params
	 }, function(code, msg, data)
			if callback then 
				callback()
			end 
	end)
end 
-- 获取大厅机台列表
function Http.fetch_machines(room_type, callback, moduleList)

	do_post(MSG_ID.MSG_CHECK_MODULE_VERSION, {
		appId = 1, bigVersion = UnityEngine.Application.version,
		smallVersion = UIUtil.get_small_version(),
		moduleList = moduleList }, function(code, msg, data)
		if code == RET.RET_SUCCESS then
			local r = {}
			r.room_type = "general" -- 赌场类型 general|vip
			r.machines = {}
			log.p("下载数据最新版", data)
			-- log.l("下载数据最新版", data)
			if data.moduleList then
				for i, v in ipairs(data.moduleList) do
					local m = {}
					m.machine_id = tonumber(v.moduleId)    -- 机台ID[string]
					m.size = 0        -- 机台尺寸[string]
					m.name = v.moduleName            -- 机台名称[string]
					m.version = v.version        -- 机台版本[number]
					m.type ="General"           -- 机台类型[string][General|Lightning|FastCash|...]
					m.res_info = v.resourceInfo    --机台图片信息
					m.unlock_level = v.lockLevel    -- 最低解锁等级[number]
					m.vip_limit = v.vipLockLevel    -- 最低VIP解锁等级[number]
					m.status = v.status        -- 机台状态[string][Enable|Coming|Disable]
					m.cityId = v.cityId        -- 模块城市ID
					m.playId = v.playId        -- 模块玩法ID
					m.enterType = v.enterType        -- 入口展示类型 feature_type   1:hot   2:new  3:normal 4: coming soon
					m.moduleType = v.moduleType        -- 模块类型
					m.indexInList = v.indexInList
					m.featureId = v.featureId 
					m.jackpot_info = {}
					r.machines[i] = m
					if v.version >0 then
						resMgr:InitModuleInfo(v.moduleName)
					end
				end
			end
			r.groups = {}
			if data.groups then
				for i, v in ipairs(data.groups) do
					local m = {}
					m.shared_jackpots = {}
					--for p, q in ipairs(v.sharedJackpots) do
					--	m.shared_jackpots[p] = q
					--end
					m.machine_ids = {}
					--for p, q in ipairs(v.machineIds) do
					--	m.machine_ids[p] = tonumber(q)
					--end
					r.groups[i] = m
				end
			end
			if callback then
				callback(r)
			end
		else
			log.r({ info = "大厅机台列表网络错误", code = code, msg = msg, data = data })
		end
	end)
end

 

function Http.hammer_award(callback)
	do_post(MSG_ID.MSG_HAMMER_AWARD,{}, function(code, msg, data)
		if code == RET.RET_SUCCESS then
			--My.easter_egg_info.hammerInfo.hammers = data.hammerInfo.hammers
			--My.easter_egg_info.hammerInfo.progress = data.hammerInfo.progress
			--My.easter_egg_info.hammerInfo.target = data.hammerInfo.target
		end
		if callback then callback(code, msg, data) end
	end)
end
 
 

 
 
 
 
 
-- 机台预览
function Http.machine_preview(machine_id, room_type, callback)
	do_post(MSG_ID.MSG_MACHINE_PREVIEW,{machineId = tonumber(machine_id), room_type = tostring(room_type)}, function(code, msg, data)
		if code == RET.RET_SUCCESS then
			local t = {}
            t.machine_url = data.modelPic
			t.logo_url = data.titlePic
			local b = {}
			t.bet_options = b
			for i,v in ipairs(data.betOptions) do
				b[i] = {}
				b[i].bet_multiple = v.betMultiple
				b[i].total_bet = v.totalBet
				b[i].unlock_level = v.unlockLevel
				b[i].jackpot = v.jackpot
			end
			if callback then callback(t) end
		else
            log.r({info = "机台预览网络错误:",code = code,msg = msg,data = data})
		end
		
	end)
end

function Http.pay_notify(tbl,callback)

 	local pay_notify_call = function(code, msg, data)
		if code == RET.RET_SUCCESS then
			--My.lastBuyShopItem = DeepCopy(data)
		end
		callback(code, msg, data)
	end
	do_post(MSG_ID.MSG_PAY_NOTIFY,tbl,pay_notify_call)
end
 
 	
-- 检查机台版本
function Http.check_machine_version(appid, machine_id, version, callback)

	--local myTest = fun.get_int("quality_lv",1) 
	do_post(MSG_ID.MSG_CHECK_MODULE_VERSION,{
		appId = 0,
		bigVersion = UnityEngine.Application.version,
		smallVersion = UIUtil.get_small_version(),
		moduleList = {machine_id}},
	function(code,msg,data)
		callback(code, msg, data)
	end)
end

 

function Http.get_current_network_name()
	return ""
end
 

function Http.fetch_video_reward(type, ad_banner, callback)
	log.log("领取视频奖励",type,ad_banner)



	do_post(MSG_ID.MSG_VIDEO_AWARD,{
		type = type,		-- 观看类型
		adPos = ad_banner, 	-- 广告位置
	})

	-- do_post(MSG_ID.MSG_VIDEO_AWARD,{
	-- 	type = type,		-- 观看类型
	-- 	adPos = ad_banner, 	-- 广告位置
	-- },
	-- function(code,msg,data)
	-- 	log.y("视频奖励数据",data)
	-- 	UIUtil.stop_loading_delay(function()
	-- 		if code == RET.RET_SUCCESS then
	-- 			if callback then
	-- 				callback(data)
	-- 			else
	-- 				local prizes = data.prizes
	-- 				if(prizes and GetTableLength(prizes)==0) then
	-- 					--没有奖励则通知下一个弹窗
	-- 					Event.Brocast(EventName.Event_No_Ad_awards)
	-- 				end
	-- 				for i, prize in ipairs(prizes) do
	-- 					local item_id = prize.itemId
	-- 					local count = prize.count
	-- 					local balance = prize.balance
	-- 					local start_pos = Vector3.New(0,0,0)
	-- 					if prize.type == ITEM_TYPE.ITEM_TYPE_COINS then
	-- 						-- Facade.SendNotification(NotifyName.GetReward, {show_btn =  true,  reward_num = count, show_time = 1})
	-- 					elseif prize.type == ITEM_TYPE.ITEM_TYPE_DIAMOND then
	-- 						-- SceneViewManager.show_dialog("VideoRewardDiamond", {video_type = type,prize_type = ITEM_TYPE.ITEM_TYPE_DIAMOND,total=count, animate_base=0,ad_banner = ad_banner})
	-- 					end
	-- 				end
	-- 			end
	-- 			SDK.event_ad_reward()
	-- 		else
	-- 			log.r("激励视频奖励领取失败",type,code,msg,data)
	-- 		end
	-- 	end)
		

	-- end)
end
 
function Http.get_url_base()
	URL_BASE = URL_DEFAULT or AppConst.HTTP_SERVER_IP
	-- local small_version = UIUtil.get_small_version()
	-- local big_version  = UIUtil.get_big_version()
	URL_BASE = URL_BASE .. "?version=" .. UIUtil.get_client_version()
	log.y("URL_BASE  " .. URL_BASE)
end
 

function Http.check_versions(app_id, modules, callback)
	do_post(MSG_ID.MSG_CHECK_MACHINES_VERSION,{quality = 1, versions = modules, bigVersion = UnityEngine.Application.version},
	function(code,msg,data)
		if callback then
			callback(code,msg,data)
		end
	end)
end
  
function Http.send_deep_link(linkstr,callback)
	local para = {
		params = tostring(linkstr),
	}
	do_post(MSG_ID.MSG_DEEP_LINK_REPORT, para, function(code, msg, data)
		if code == RET.RET_SUCCESS then
			if callback then
				callback(data)
			end
		else
			on_post_error(MSG_ID.MSG_DEEP_LINK_REPORT, para, code, msg, data)
		end
	end)
end

--[[
--发送deeplink数据给服务器

--]]
--发送deeplink数据给服务器
-- function Http.send_deep_link(str)

-- 	local myPara = {type = str.type,cur_data = str.cur_data}
--     myPara = TableToJson(myPara)
-- 	do_post(MSG_ID.MSG_DEEP_LINK_REPORT, {params = myPara})

-- end



function Http.req_res_list(callback)
	local para = {

	}
	do_post(MSG_ID.MSG_FETCH_RESOURCES, para, function(code, msg, data)
		if code == RET.RET_SUCCESS then
			if callback then
				callback(data)
			end
		else
			on_post_error(MSG_ID.MSG_FETCH_RESOURCES, para, code, msg, data)
		end
	end)
end

function Http.req_shop_type(shop_type,callback)
	log.log("请求商店类型A", shop_type)
	do_post(MSG_ID.MSG_FETCH_SHOP,{shopType = tonumber(shop_type)})
end

function Http.req_shop_bonus_reward()
	do_post(MSG_ID.MSG_SHOP_BONUS_AWARD,{})
end

-- Inbox
-- 请求Inbox信息
function Http.req_inbox_info()
	do_post(MSG_ID.MSG_FETCH_MAIL,{})
end

-- 删除邮件
function Http.req_delete_mail(mid)
	do_post(MSG_ID.MSG_DELETE_MAIL,{mid = tonumber(mid)})
end

-- 邮件领奖
function Http.req_get_mail_reward(mid)
	do_post(MSG_ID.MSG_MAIL_AWARD,{mid = mid})
end
-- Inbox

-- piggybank

-- 请求piggybank信息
function Http.req_piggy_bank_info()
	do_post(MSG_ID.MSG_FETCH_PIGGY_BANK,{})
end

-- 请求领取piggybank奖励
function Http.req_get_piggy_bank_reward()
	do_post(MSG_ID.MSG_PIGGY_BANK_WITHDRAW,{})
end
-- piggybank
 
--登录奖励
function Http.req_login_wheel_info(normal_wheel_id)
	do_post(MSG_ID.MSG_FETCH_WHEEL_ITEM,{wheelId = normal_wheel_id})
end

function Http.req_login_diamond_wheel_info()
	do_post(MSG_ID.MSG_FETCH_WHEEL_ITEM,{wheelId = "W000000401"})
end

function Http.req_login_diamond_wheel_info_reward()
	do_post(MSG_ID.MSG_WHEEL_SPIN,{wheelId = "W000000401"})
end


function Http.req_login_wheel_reward_info()
	local data = os.date("%Y%m%d%H%M%I%S")
	log.log("登录奖励发送的本地时间：" , data)
	do_post(MSG_ID.MSG_LOGIN_AWARD,{localtime = data})
end

function Http.req_login_gold_wheel_reward_info()
	do_post(MSG_ID.MSG_PAY_WHEEL_AWARD,{})
end

-- 评价
function Http.req_rate_us(star)
	do_post(MSG_ID.MSG_EVENT_REPORT,{ event= "rateUs" ,data = {star = star}})
end

--检查版本
function Http.req_check_app_version()
	local big_version = UIUtil.get_big_version()
	local small_version = UIUtil.get_small_version()
	local memory_size = UIUtil.get_memory_size()
	local score = UIUtil.get_phone_score()

	do_post(MSG_ID.MSG_CHECK_APP_VERSION,{ bigVersion = big_version, smallVersion = small_version, memory = memory_size, score = score})
end

--[[
    @desc: 请求广告弹窗 
    author:{author}
    time:2020-11-20 14:46:45
    --@event:
	--@callback:
	--@fail_callback: 
    @return:
]]
function Http.req_popus(event)
	local para = {
		event = event,
	}
	do_post(MSG_ID.MSG_FETCH_POPUPS, para)
end

--活动列表
function Http.req_activities_info()
	do_post(MSG_ID.MSG_FETCH_ACTIVITIES,{ })
end



--7日登陆奖励
function Http.req_get_sevendayreward_info()
	do_post(MSG_ID.MSG_FETCH_COME_BACK,{ })
end


--新手引导
function Http.req_get_guide_info()
	do_post(MSG_ID.MSG_FETCH_NOVICE_GUIDE,{ })
end

function Http.req_finish_guide(index)
	do_post(MSG_ID.MSG_FINISH_NOVICE_GUIDE,{currentPhase = index })
end
--新手引导

--社交

--获得好友列表
function Http.req_get_friend_info()
	do_post(MSG_ID.MSG_SOCIAL_GET_FRIENDS,{ })
end

--获得所有玩家（仅推荐8名用户）
function Http.req_get_all_players_info()
	do_post(MSG_ID.MSG_SOCIAL_GET_ALL_PLAYERS,{ })
end


--请求添加好友
function Http.req_add_friend(uid)
	log.log("请求添加好友ID", uid)
	do_post(MSG_ID.MSG_SOCIAL_ADD_FRIEND,{searchUId = uid })
end

--请求接受
function Http.req_accept_friend(uid)
	do_post(MSG_ID.MSG_SOCIAL_ACCEPT_FRIEND,{reqUId = uid })
end

--请求删除好友
function Http.req_delete_friend(uid)
	do_post(MSG_ID.MSG_SOCIAL_DEL_FRIEND,{delUId = uid })
end

--机台内邀请好友加入
function Http.req_invite_friends(invite_friends_tab)
	-- local uids = TableToJson(invite_friends_tab)
	log.log("邀请数据e", invite_friends_tab)
	-- do_post(MSG_ID.MSG_SOCIAL_INVITE_MACHINE,{inviteUIds = uids })
	do_post(MSG_ID.MSG_SOCIAL_INVITE_MACHINE,{inviteUIds =  invite_friends_tab })

end

--接受好友邀请
function Http.accept_invite_play(machine_id,  roomType, friendId)
	do_post(MSG_ID.MSG_ENTER_MACHINE,{ machineId = machine_id ,  roomType =  roomType , friendId = friendId })
end

--点赞其他人
function Http.like_other_player(likeUId)
	do_post(MSG_ID.MSG_SOCIAL_LIKE_PLAYER,{ likeUId = likeUId})
end
--获取分享信息
function Http.get_share_info(type,params)
	do_post(MSG_ID.MSG_SHARE_GET_INFO,{type = type,params=params})
end
--获取分享进度
function Http.get_share_progress()
	do_post(MSG_ID.MSG_SOCIAL_INVITE_PROGRESS,{})
end
--获取分享奖励
function Http.get_share_reward(rewardIndex)
	do_post(MSG_ID.MSG_SOCIAL_INVITE_REWARD,{ index = rewardIndex})
end

--社交

--vip

--请求vip基本数据
function Http.req_vip_info()
	do_post(MSG_ID.MSG_FETCH_VIP_INFO,{})
end

--请求vip是否首次进入
function Http.req_vip_first_enter(is_update)
	log.log("修改vip教程", is_update)
	do_post(MSG_ID.MSG_FETCH_VIP_GUIDE,{isUpdate = is_update})
end

--请求vip权益列表
function Http.req_vip_attr_list()
	do_post(MSG_ID.MSG_FETCH_VIP_LIST,{})
end


--vip


--小游戏
--请求小游戏配置
--game_id  小游戏id
function Http.req_mini_game_config(game_id)
	do_post(MSG_ID.MSG_MINI_GAME_INIT,{gameId = game_id})
end

--请求花费钻石继续小游戏
--game_id  小游戏id
function Http.req_cost_diamond_continue(game_id)
	do_post(MSG_ID.MSG_MINI_GAME_RENEW,{gameId = game_id})
end

--请求游戏奖励
--game_id  小游戏id
--result   小游戏结果
function Http.req_game_result(game_id, click_time )
	local tab = {}
	tab.clickTimes = click_time
	local result = TableToJson(tab)
	log.log("参数输入",result )
	do_post(MSG_ID.MSG_MINI_GAME_RESULT,{gameId = game_id , result = result} )
end



--lxm 请求推荐好友
function Http.req_suggested_friend_result( )
	do_post(MSG_ID.MSG_SOCIAL_GET_SUGGEST_FRIENDS,{})
end


-- lxm 发送选中推荐好友
function Http.send_suggested_friend_data(uidList)
	do_post(MSG_ID.MSG_SOCIAL_ADD_SUGGEST_FRIENDS,{suggestUids=uidList})
end


-- lxm 免费礼物请求
function Http.req_free_gift_reward(payProgress)
	do_post(MSG_ID.MSG_TRIPLE_SALE_FREE_AWARD,{payProgress=payProgress})
end


-- 分享邀请好友

function Http.req_share_progress()
	do_post(MSG_ID.MSG_SOCIAL_INVITE_PROGRESS,{} )
end

function Http.req_share_login()
	do_post(MSG_ID.MSG_USER_LOGIN,{} )
end



function Http.get_http_data(url,callback)
	do_get(url,callback)
end

function Http.change_url_default(url)
	URL_DEFAULT = url
end

function Http.get_url_default()
	return URL_DEFAULT
end