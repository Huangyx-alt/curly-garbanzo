
--region LoginModel.lua
--登录模块业务逻辑
--endregion
--@SuperType [Model.BaseModel#BaseModel]
local LoginModel = BaseModel:New("LoginModel");
local this = LoginModel;

this.User = {} ----PB_RoleInfo
this.sessionId = ""  --session
this.sessionState = true  --session可用状态，假如session失效，则不再触发重连，等待新session
this.connector = {} --PB_Connector
this.resurl = "" --用于下图片资源地址
this.platform = nil --登陆平台，后面用于检测是否需要bindfacebook
this.login_state = 0 --登录状态，除非回到登录界面才重置

local openidGroups = nil
local ALLOW_CONFIG_OPEN_ID = false --是否允许玩家配置openid

function LoginModel:InitData()

end

function LoginModel:SetLoginData(data)
    openidGroups = deep_copy(data.platformOpenidGroups)
    UnityEngine.PlayerPrefs.SetString("app_first_open", "1")
end

--[[
    @desc: 获取Res下载地址头
    author:{author}
    time:2020-07-23 15:57:46
    @return:
]]
function LoginModel:GetResurl()
    return this.resurl
end

--C2S：{ INT type: LoginType, STRING keyword: 关键字, STRING data0: 备用0号, STRING data1: 备用1号, STRING data2: 备用2号 }
--这是http返回来的 	
--@code: [pbnet.PB_Common#RET]
--@data: [pbnet.PB_UserLogin#PB_UserLogin_Res]			
function LoginModel.HttpReceiveLogin(code,data)
    log.log("登录返回A", code)
    --log.log("登录返回AB", data)
    if(code == RET.RET_SUCCESS)then
        --this.recommend_machine_id = data.machineId
       log.y('@LoginModel.HttpReceiveLogin, Id>>: ' , tostring(data.debugstr)  , ", data content>>: " ,tostring(data));
       log.y('@LoginModel.HttpReceiveLogin, data.connector>>: ' , data.connector  , ", data.connector.host>>: " ,data.connector.host);
        
       this.sessionId = data.sessionId
        this.sessionState = true
        this.connector = deep_copy(data.connector)
        --log.r(this.connector.host.."     "..this.connector.port)
        this.resurl = data.resUrl
        this:SetLoginType(data.loginType)
        -- LuaNotifications:SetLoginNotification()   --登录24小时通知
     
        ModelList.SetLoginData(data)
        UserData.set_uid(tostring(data.uid))
        SDK.set_firebase_user_id(tostring(data.uid))
        -- require("Logic/SDK") --暂时屏蔽SDK by LwangZg
        SDK.LoadMaxAd(data.uid,"")
        SDK.post_token()
        PlayerTrackerData.set_login_days()
        PlayerTrackerData.set_continuous_login_days()

        
        
        this.SendNotification(NotifyName.Login.ConnectServer,this);
        -- 如果获取到deeplink回调参数 则上报至服务器
        -- deepLinkPara = fun.read_value("InviteUser",nil)
        -- if(deepLinkPara~=nil)then
        --     --deeplinkPara = {type = "InviteUser",cur_data = "JTdCJTIyY29kZSUyMiUzQSUyMjQ4a2poVE5tJTIyJTdE"}
        --     --Http.send_deep_link(deeplinkPara)
        -- end
        local extra = {fbid = "",email = "",appsflyerID="",deviceToken = ""}
        local coins = ModelList.ItemModel.get_coin()
        local diamond = ModelList.ItemModel.get_diamond()
        extra["balance"] = coins
        extra["level"] = ModelList.PlayerInfoModel.my_info.level
        if ModelList.PlayerInfoModel.connector then
            extra["ip"] = ModelList.PlayerInfoModel.connector.ip
        else
            extra["ip"] = "200"
        end
        extra["version"] = UnityEngine.Application.version
        --暂时屏蔽SDK by LwangZg
       --[[  Http.report_event("login",extra,function(code,msg,data)
            --log.r("report_event login "..code.."     "..msg)
        end)

        PurchaseHelper.Initialize()--登录后才能初始化支付IAP，要不补单会拿不到相关数据 ]]
        ModelList.BingopassModel:ResetBettleRound()
    else
        if code == 1020 then
            --token过期，重新拉起登录获取token
            this:OnTokenExpired()
        end
        log.log("登录返回数据错误", code)
        this.SendNotification(NotifyName.Http.HttpLoginFaild);
    end
end

function LoginModel:GetJumpMachineID()
    return this.recommend_machine_id
end

--连接服务器后，需要传session做验证，3秒不传则服务端断开 
function LoginModel.C2S_UserEnter()
    ---前端逻辑 tcp的 enter协议 进入游戏 需要控制 与 http  登录 间隔1s，
    --- 后端的http还没有写入，导致此时的session验证失效，因此延迟0.5s再发送
    LuaTimer:SetDelayFunction(0.5, function()

        log.y("C2S_UserEnter " .. this.sessionId)
        --非登录场景，都是重连
        log.y("C2S_UserEnter  "..this.login_state)
        if this.login_state == 1 then
            Network.ResetSendMsgList()
            this.SendMessage(MSG_ID.MSG_USER_ENTER,{sessionId = this.sessionId, stype = 1})
        else
             this.SendMessage(MSG_ID.MSG_USER_ENTER,{sessionId = this.sessionId})
        end
    end
    )
end

function LoginModel.S2C_CheckConnectSuccess(code,data)
    log.y("S2C_CheckConnectSuccess:",code)
    this.login_state = 1
    Network.SendConnectState = 3
    if(code == RET.RET_SUCCESS)then
        --ShowTips("连接成功")
        LuaTimer:SetDelayFunction(0.2,function()
            Facade.SendNotification(NotifyName.Login.LoginRequestOrder)
        end)
        --[[
        if(SceneViewManager.GetCurrentSceneName() == "SceneGame")then
            this.SendNotification(NotifyName.CmdSimulateLogin);--在scene下面直接 进机台
        end
        --]]
    elseif(code == RET.RET_SESSION_INVALID)then
        log.r(" session失效，需要重登")
        this.sessionState = false
        --TODO--跳登陆流程
        --   ShowTips("session失效，需要重登")
        --ModelList.LoginModel.AutoLogin()
        UIUtil.LoadLogin()
        --Facade.SendNotification(NotifyName.CommonTip, "session_fail")
    else
        --Facade.SendNotification(NotifyName.CommonTip, "session_fail")
    end
end

---session是否可用
function LoginModel.IsSessionUsable()
    return this.sessionState
end

function LoginModel._getLoginInfo(device_id)
    local openid = UnityEngine.SystemInfo.deviceUniqueIdentifier or fun.read_value(DATA_KEY.openid, "") 
   
    if fun.is_ios_platform() then 
        Util.RequestIDFA(function (tdevice_id)
            openid = tdevice_id
        end)
    end 
    
    local token = fun.read_value(DATA_KEY.token, "")
    local platform = fun.read_value(DATA_KEY.platform, "")
    if tostring(platform) == tostring(PLATFORM.PLATFORM_FACEBOOK) then
        openid = fun.read_value(DATA_KEY.openid, "")
    elseif tostring(platform) == tostring(PLATFORM.PLATFORM_APPLE) then 

        Util.RequestIDFA(function (tdevice_id)
            openid = tdevice_id
        end)
        openid = fun.read_value(DATA_KEY.openid, "")
    end

    if GameUtil.is_windows_editor() then


        local path = string.gsub(UnityEngine.Application.dataPath, "/Assets", "") .. "/randomlogin"
        local file_exists = function(path)
            local file = io.open(path, "rb")
            if file then
                file:close()
            end
            return file ~= nil
        end
        local readAll = function(file)
            if file_exists(file) then
                local f = assert(io.open(file, "rb"))
                local content = f:read("*all")
                f:close()
                return content
            end
            return ""
        end
        local load_key = readAll(path)
        if load_key == nil or load_key =="" then
            local load_key = fun.read_value("random_login", 'abc133')
            openid = UnityEngine.SystemInfo.deviceUniqueIdentifier .. load_key
        end
        openid = UnityEngine.SystemInfo.deviceUniqueIdentifier..load_key

        if ALLOW_CONFIG_OPEN_ID then
            local playerCode, deviceCode = fun.GetPlayerAndDeviceCode()
            openid = deviceCode .. playerCode
        end
    end
    local platformInfo = fun.read_value(DATA_KEY.platformInfo,"")
    return openid, token, platform, platformInfo
end

function LoginModel.IsLogined()
    if BingoBangEntry.bingoBangNetType then
        return true
    end
    local openid,token,platform = this._getLoginInfo()
    if not StringUtil.is_empty(openid) and not StringUtil.is_empty(token) and platform then
        return true
    else
        return false
    end
end

function LoginModel.IsPreviousFacebooPlatform()
    local platform = fun.read_value(DATA_KEY.previous_platform,nil) or fun.read_value(DATA_KEY.platform, "")
    if platform == PLATFORM.PLATFORM_FACEBOOK then
        return true
    end
    return false
end

function LoginModel.AutoLogin(failCallback,successCallback,clearSession)
    --暂时屏蔽SDK by LwangZg
    -- Http.report_event("pre_autologin_start",{})
    this.login_state = 0
    local openid,token,platform,platformInfo = this._getLoginInfo()
    log.r(string.format("登陆信息 openid%s,token%s,platform%s,platformInfo%s",openid,token,platform,platformInfo))
    log.r("AutoLogin platform ===>"..platform)
    this.HttpReqLogin(openid, token,platform,openid,failCallback,successCallback,clearSession,platformInfo)
end

function LoginModel.Bind_user(openid, token, platform, failCallback,successCallback,isRestrict)
   -- if this:GetLoginPlatform() ~= PLATFORM.PLATFORM_FACEBOOK then
        this.bind_token = token
        this.bind_openid = openid
        this.bind_platform = tonumber(platform)
        this.bind_failcallback = failCallback
        this.bind_successcallback = successCallback
        this.SendMessage(MSG_ID.MSG_USER_BIND,{token = token,openid = openid,platform = tonumber(platform),isRestrict = isRestrict})
   -- end
end

function LoginModel.S2C_UserBindFacebook(code,data)
    if code == RET.RET_SUCCESS then
        log.r("RET.RET_SUCCESS  RET.RET_SUCCESS RET.RET_SUCCESS ")
        fun.save_value(DATA_KEY.openid, this.bind_openid)
        fun.save_value(DATA_KEY.token, this.bind_token) 
        fun.save_value(DATA_KEY.platform, data.platform) 
        this.user_login(this.bind_failcallback,this.bind_successcallback,true)
    else
        log.r("sdk绑定游客账号失败！" .. " code: " .. code)

        if code == 1020 then
            --token过期，重新拉起登录获取token
            this:OnTokenExpired()
        end

        if this.bind_failcallback then
            this.bind_failcallback(code)
        else
            UIUtil.show_common_error_popup(8010,true,nil)
        end        
    end
end

--[[
    @desc: facebook登陆
    author:{author}
    time:2020-08-07 11:44:26
    @return:
]]
function LoginModel.FbLogin(failCallback,successCallback)
    local platform = this:GetLoginPlatform()
    platform = platform or PLATFORM.PLATFORM_FACEBOOK  --首次为空时,默认走登陆逻辑
    
    --if GameUtil.is_windows_editor() then
	--	this.user_login(failCallback)
    --    return
	--end
    this:ReportFirstLogin("facebook")
    if platform == PLATFORM.PLATFORM_GUEST then
        local openidGroup = this:CheckOpenidGroup(PLATFORM.PLATFORM_FACEBOOK)
        if not openidGroup then
            SDK.login(function(AccessToken,jsonStr, platform)
                if not AccessToken then 
                    log.r("sdk请求失败！") --TODO 弹框yeshi tiaodao 
                    if failCallback then
                        failCallback()
                    end
                    return
                end
                this.platform = platform
                local openid, token = nil
                if fun.is_ios_platform() then  --- IOS平台走受限登录
                    token = AccessToken.TokenString
                    --local openid = AccessToken.UserId
                    local jsonObj = JsonToTable(jsonStr or "")
                    openid = jsonObj.UserId
                else                            -- android平台走非受限登录
                    token = AccessToken.TokenString
                    openid = AccessToken.UserId
                end
                this.Bind_user(openid, token, platform, failCallback, successCallback,true)
            end)
        else
            if failCallback then
                failCallback(RET.RET_ACCOUNT_BIND_NOT_CURRENT)
            end
        end
    else
        SDK.login(function(AccessToken,jsonStr ,platform)
            if not AccessToken then 
                log.r("sdk请求失败！")
                if failCallback then
                    failCallback()
                end
                return
            end
            this.platform = platform
            local openid,token = nil
            if fun.is_ios_platform() then  --- IOS平台走受限登录
                token = AccessToken.TokenString
                local jsonObj = JsonToTable(jsonStr or "")
                openid = jsonObj.UserId
                if not token or not jsonObj and  not jsonObj.UserId then
                    return
                end
            else                            -- android平台走非受限登录
                token = AccessToken.TokenString
                openid = AccessToken.UserId
                if not token or not openid then
                    return
                end
            end
            fun.save_value(DATA_KEY.openid, openid)
            fun.save_value(DATA_KEY.token, token)
            fun.save_value(DATA_KEY.platform, platform)
            fun.save_value(DATA_KEY.platformInfo, jsonStr)
            this.user_login(failCallback,successCallback)
        end)
    end
end

function LoginModel.user_login(failCallback,successCallback,clearSession)
    if this.IsLogined() then
        this.AutoLogin(function()
            if failCallback then
                failCallback()
            end
        end,function()
            Facade.SendNotification(NotifyName.Login.LoginRequestOrder)
            if successCallback then
                successCallback()
            end
        end,clearSession)
    else
        log.r("登录失败！")
    end
end

function LoginModel.user_logout()
    this.SendMessage(MSG_ID.MSG_USER_LOGOUT,{})
end

function LoginModel.S2C_UserLogout(code,data)
    if code == RET.RET_SUCCESS then
        fun.save_value(DATA_KEY.previous_platform,this.GetLoginPlatform())
        fun.delete_value(DATA_KEY.openid)
        fun.delete_value(DATA_KEY.token)
        fun.delete_value(DATA_KEY.platform)
        this:SetLoginPlatform(nil)
        Http.session_id = ""
        LuaTimer:Clear(nil,true)
        Facade.SendNotification(NotifyName.Login.LogoutRespone,data.res)
    end
end


function LoginModel.LogoutHandle()
    Http.init()
    ModelList.PlayerInfoModel:logout()
    ModelList.GuideModel:Close()
    Network.ResetReconnect()
    Network.Close()
    LuaTimer:Clear(nil, true)
end

--[[
    @desc: 游客登陆
    author:{author}
    time:2020-08-07 14:17:26
    @return:
]]
function LoginModel.GuestLogin(failCallback,successCallback)
    local token = "password"
    local platform = PLATFORM.PLATFORM_GUEST
    local openid = nil
    this.login_state = 0
    this:ReportFirstLogin("guest")
    --游客登录时openid为设备id，token为“password”
    Util.RequestIDFA(function (device_id)
        -- ModelList.ClearModelList()
        -- Network.Close()
        local discard1 = nil
        local discard2 = nil
        openid,discard1,discard2 = this._getLoginInfo(device_id)
        this.HttpReqLogin(openid, token,platform,device_id,function()
            this.platform = platform
            if failCallback then
                failCallback()
            end
        end,function()
          
            this.platform = platform
            if successCallback then
                successCallback()
            end
        end,true)
    end)
end


--[[苹果登录]]
function LoginModel.AppleLogin(failCallback,successCallback,flag)

    local platform =PLATFORM.PLATFORM_APPLE --首次为空时,默认走登陆逻辑
    this:ReportFirstLogin("apple")
    if flag then 
        SDK.AppleSignlogin(function (code,appid,token)
            log.g("AppleSignlogin code"..tostring(code))
            if code ~= 0 then  
                log.g("AppleSignlogin appid fail"..tostring(code))
                if failCallback then 
                    failCallback()
                end 
                return 
            end 
            local token =token
            local openid = appid
            if not token or not openid then
                return
            else
                log.g("AppleSignlogin appid"..tostring(appid).." token "..tostring(token))
                Http.session_id = ""
                fun.save_value(DATA_KEY.openid, openid)
                fun.save_value(DATA_KEY.token, token)
                fun.save_value(DATA_KEY.platform, platform)
                this.user_login(failCallback,successCallback) 
            end
        end)
    else 
        SDK.AppleSignlogin(function (code,appid,token)
            log.g("AppleSignlogin appid"..tostring(code))
            if code ~= 0 then  
                log.g("AppleSignlogin appid fail"..tostring(code))
                if failCallback then 
                    failCallback()
                end 
                return 
            end 
            log.g("AppleSignlogin appid"..tostring(appid).." token "..tostring(token))
            this.Bind_user(appid, token, platform, failCallback, successCallback)
        end)
    end 

  
    --读取默认的token  
    
    --没有就第一次，

    --如果有就是默认快速登录 -- 不拿取名字

    

    -- local platform = PLATFORM.PLATFORM_APPLE

    -- log.log("苹果登录数据B", userId, "\n",token)
    -- -- Http.session_id = ""
    -- Util.RequestIDFA(function (device_id)
    --     --this.HttpReqLogin(userId, token,platform,device_id)
    --     -- Http.init()
    --     -- LoadScene("SceneLoading")

    --     local token = token
    --     local platform = PLATFORM.PLATFORM_APPLE
    --     local openid = userId

    --     Http.init()
    --     fun.save_value(DATA_KEY.openid, openid)
    --     fun.save_value(DATA_KEY.token, token)
    --     fun.save_value(DATA_KEY.platform, platform)
    --     -- LoadScene("SceneLogin")
    --     if(callback)then
    --         callback()
    --     end
    -- end)
end

function LoginModel.FBBind()
    Http.bind_FB_and_login(function(code, msg, data)
        --int32 uid = 1; //绑定后的用户ID
        --string nickname = 2; //绑定后的昵称
        --string avatar = 3; //绑定后的头像
        log.log("FB账号绑定B",code , "   MSG:",msg  , "   data:", data)

        if code == RET.RET_SUCCESS then
            --af打点_用户Facebook登陆成功
            SDK.event_facebooklogin_succeeded()
            this.platform = PLATFORM.PLATFORM_FACEBOOK
            fun.save_value(DATA_KEY.platform, this.platform )
            -- 如果uid发生变化，则使用新的账号重新登录
            --if data.uid ~= ModelList.PlayerInfoModel:GetUid() then
                
            --else
                ModelList.PlayerInfoModel:ChangeNickNameAndAvatar(data.nickname,data.avatar)
                log.i("绑定FB账户，UID没有变化，刷新昵称和头像")
            --end
        elseif code == RET.RET_ACCOUNT_BIND_REPEAT then
            ShowCfgTips("已经有FB账户绑定的账号，自动使用该FB账号重新自动登陆")
            log.log("FB账号绑定B")
            Facade.SendNotification(NotifyName.ShowErrorTip, {type = ErrorView.error_type.SureTip ,content = "The request failed !!!!",btn_str = "OK",ok_func =
            function()
                UIUtil.logout()
            end, close_func = function()

            end})
        elseif code == RET.RET_ACCOUNT_EXIST then
            log.log("--账号已经存在")
            UIUtil.show_fb_login_switch_tip(openid, token, platform)

        else
            --af打点_用户Facebook登陆失败
            SDK.event_facebooklogin_faileded()
            log.log("FB绑定错误", code)
            ShowCfgTips("Error", code)
            Facade.SendNotification(NotifyName.ShowErrorTip, {type = ErrorView.error_type.ErrorTip ,content = "The request failed !!!!!",btn_str = "OK",ok_func =
            function()
            end, close_func = function()

            end})
        end
    end)
end

function LoginModel.HttpReqLogin(openid, token,platform,device_id,failCallback,successCallback,clearSession,platformInfo)
    this.platform = platform
    SDK.login_event("http_login")
    if  StringUtil.is_empty(openid) and StringUtil.is_empty(token)  then
        log.log("登录失败数据缺失 openid :", openid, "token", token )
        --Facade.SendNotification(NotifyName.CommonTip, "Facebook_fail")
        SDK.login_event("login_fail_openid")
        if failCallback then
            failCallback()
        end
        return
    end
    SDK.initThinkingData()
    Http.get_url_base()
    SDK.login_event("pre_autologin_complete")
    SDK.login_event("login")
    Http.login(function(code,msg, data)
        --log.log("自动登录返回", code , data)
        if code == RET.RET_SUCCESS then
            this.platform = platform
            local localplatform = UnityEngine.Application.platform
           -- if this.platform == PLATFORM.PLATFORM_FACEBOOK then
                --af打点_用户Facebook登陆成功
                --SDK.event_facebooklogin_succeeded()
                -- Facade.SendNotification(NotifyName.CommonTip, "Facebook_success")
            --end

            if localplatform ~= UnityEngine.RuntimePlatform.WindowsEditor and  localplatform ~= UnityEngine.RuntimePlatform.OSXEditor then
                AIHelpHelper.Instance:updateUserInfo(tostring(data.roleInfo.vip)  or "0", tostring(data.roleInfo.uid)  or "0", tostring(data.roleInfo.nickname)  or "unknow")
                
            end 

            local localOpenid,localToken,localPlatform,platformInfo = this._getLoginInfo()
            ModelList.PlayerInfoModel:SetMyPlayerInfo(data.roleInfo)

            log.r("get_portal_list_data")
            MachinePortalManager.get_portal_list_data("general")
            if(openid ~= localOpenid  or token ~= localToken or  platform~= localPlatform )then
                fun.save_value(DATA_KEY.openid, openid)
                fun.save_value(DATA_KEY.token, token)
                fun.save_value(DATA_KEY.platform, platform)
                fun.save_value(DATA_KEY.platformInfo, platformInfo)
            end
            if successCallback then
                successCallback()
            end
        else
            log.log("登录请求失败", code)
            --Facade.SendNotification(NotifyName.Common.PopupDialog, 8010, 1,function()
            --    this.AutoLogin()
            --end);
            UIUtil.show_common_error_popup(8010,true,function()
                this.AutoLogin()
            end)
        end
    end, openid, token,device_id,platform,function()
            log.log("登录请求失败")
        if failCallback then
            failCallback()
        end
    end,clearSession,platformInfo)
end

function LoginModel:GetHeadUrl(avatar)
    return self:GetResurl().. avatar
end

function LoginModel:GetLoginType()
    return this.loginType
end

function LoginModel:SetLoginType(loginType)
    this.loginType = loginType
    fun.save_value(DATA_KEY.task_today_show_state, loginType)
end

function LoginModel:GetLoginPlatform()
    --if not this.platform then
    --    this.platform = 0
    --end
    return this.platform
end

function LoginModel:CheckOpenidGroup(platform)
    if openidGroups then
        local platform_str = tostring(platform)
        for key, value in pairs(openidGroups) do
            if value.platform == platform or value.plateform == platform_str then
                return value
            end
        end
    end
    return nil
end

function LoginModel:SetLoginPlatform(Platform)
    this.platform = Platform
end

function LoginModel:BackToLoginScene()
    if fun.get_active_scene().name ~="SceneLogin" then
        UIUtil.LoadLogin()
        --Facade.SendNotification(NotifyName.CommonTip, "session_fail")
    end
end

--- 收到1007的返回，才能发起登录协议队列
function LoginModel:IsGetEnterRes()
    return     this.login_state == 1
end

---是否首次登录
function LoginModel:IsFirstLogin()
    local ret_str = UnityEngine.PlayerPrefs.GetString("real_app_first_open","0")
    if ret_str and (ret_str == "0" or ret_str == "" ) then
        return true
    end
end

---上报首次登录方式
function LoginModel:ReportFirstLogin(loginType)
    if this:IsFirstLogin() then
        Http.report_event("click_login",{login_type = loginType})
    end
end


--fb受限登录token过期后出处理
function LoginModel:OnTokenExpired()
    local platformInfo = fun.read_value(DATA_KEY.platformInfo,"")
    if string.is_empty(platformInfo) then
        --上次登录不是FB受限登录
        log.r("return  not  platformInfo  OnTokenExpired")
        return
    end

    if fun.is_ios_platform() then
        SDK.facebook:LogOut()
        --SDK.login(function(state,openid, token, platform, jsonStr)
        --    log.r("[OnTokenExpired] fb_login result",state,openid, token, platform, jsonStr)
        --    if state then
        --        fun.save_value(DATA_KEY.openid, openid)
        --        fun.save_value(DATA_KEY.token, token)
        --        fun.save_value(DATA_KEY.platform, platform)
        --        fun.save_value(DATA_KEY.platformInfo, jsonStr)
        --
        --        if this.IsLogined() then
        --            this.AutoLogin()
        --        else
        --            log.r("[OnTokenExpired] fb_login failed openid or token invalid.")
        --        end
        --    end
        --end)
    end
end

this.MsgIdList =
{
    {msgid = MSG_ID.MSG_USER_LOGIN, func = this.HttpReceiveLogin},
    {msgid = MSG_ID.MSG_USER_ENTER, func = this.S2C_CheckConnectSuccess},
    {msgid = MSG_ID.MSG_USER_BIND, func = this.S2C_UserBindFacebook},
    {msgid = MSG_ID.MSG_USER_LOGOUT,func = this.S2C_UserLogout}
}

return this
