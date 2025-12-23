--TODO SDK打点被屏蔽，暂时不使用 by LwangZg 
--require "Logic.My"
local json = require "cjson"

local PlayerInfoModel = BaseModel:New("PlayerInfoModel");
local this = PlayerInfoModel;
this.player_info = {}
this.has_data = false
this.head_sprite = nil
this.head_sprite_list = {}
this.ShowCredit = false
this.upLevelState = {} --升级状态记录
this.deepLinkRewardInfo = {} --深度链接奖励

local DeepLinkPart = require "Model/ModelPart/DeepLinkPart"

local plateformOpenData = nil

function PlayerInfoModel:SetLoginData(data)
    log.l("角色信息 data： " , data)
    this.uid = tonumber(data.uid)--注意了，roleinfo里的uid不能用，以后可能会被后端移除掉
    this:SaveMyInfo(data.roleInfo)
    this:SetRechare(data.rechargeInfo) 
    this:SaveServerTime(data)
    this:SaveDailyInfo((data.normalActivity and {data.normalActivity.dailyReward} or {nil})[1])
    this:SavePlateformOpenData(data.openPlatforms)
    this:SaveRegisterReward((data.normalActivity and {data.normalActivity.hasRegisterReward} or {nil})[1])
    this:InitPIng()
    this:SaveMyGroupIds(data.groupIds)
    this:SetPurchaseInfo(data.rechargeInfo)
    this:SetGroupPrefix(data.groupPrefix)

    DeepLinkPart.SetDeeplinkRewardInfo()
    -- DeepLinkPart.ReqDeepLinkData(1)
end

function PlayerInfoModel:GetUid()
    return this.uid or 0
end


function PlayerInfoModel:SaveServerTime(d) 
    this.reg_time = d.regTime             -- 用户注册时间
    this.server_time = d.systemTime       -- 当前系统时间
    this.tomorrow_time = d.tomorrowTime   -- 次日零点时间
    this.client_time = os.time_()          -- 当前本机时间
    this.server_date_str = fun.time_to_date(this.server_time) 
    this.client_server_time_delta = this.client_time - this.server_time
    this.localtime_change_servertime()
end

function PlayerInfoModel:SaveDailyInfo(d)
    this.dailyReward = d             -- 每日登陆奖励情况
end

function PlayerInfoModel:GetTomorrowTime() -- 获得次日的时间
    return  this.tomorrow_time 
end

--- 保存后端推送评分信息
function PlayerInfoModel:SaveShowScoreInfo(d)
    this.showScore = d
end

function PlayerInfoModel:SaveRegisterReward(data)
    this.registerReward = data
end

function PlayerInfoModel:SavePlateformOpenData(data)
    plateformOpenData = DeepCopy(data)
    if plateformOpenData then
        local isOpen = 0
        for key, value in pairs(plateformOpenData) do
            if 1 == value then
                isOpen = 1
                break
            end
        end
        fun.save_int(DATA_KEY.FaceBookOpen,isOpen)
    end
end

function PlayerInfoModel.get_cur_daily_info()
    log.r("get_cur_daily_info 每日登录信息 this.dailyReward ",this.dailyReward)
    return  this.dailyReward
end

function PlayerInfoModel.IsHasRegisterReward()
    return  this.registerReward == 1
end

function PlayerInfoModel.get_cur_client_time()
    return math.max(os.time_(),this.client_time or 0)
end


function PlayerInfoModel.get_cur_server_time()
    return this.get_cur_client_time() - (this.client_server_time_delta or 0)
end

function PlayerInfoModel.localtime_change_servertime()
    os.time = this.get_cur_server_time
end


function PlayerInfoModel:SetRechare(data) 
    local t = data
    local r = {}
    r.amount = t.amount
    r.times = t.times
    r.max_amount = t.maxAmount
    r.last_amount = t.lastAmount
    r.last_time = t.lastTime
    this.recharge = r
end


function PlayerInfoModel:InitPIng()
    if(self._heartBeatHandle == nil)then
        self:AppHeartBeat()
    end 
end

function PlayerInfoModel:AppHeartBeat()
    local delay = 10 --心跳间隔,3次后没有响应则弹窗
    log.r("add AppHeartBeat ")
    if self._heartBeatHandle then
        self._heartBeatHandle:Stop()
    end
    self._heartBeatHandle = InvokeRepeat(function()
        --只负责发送让服务器知道我还连着就行，不管有没有回复了，其他地方管了
        --不要关掉心跳，没了心跳可能服务器误以为没有连接了
        self.SendMessage(MSG_ID.MSG_PING,{},true);
    end,delay,-1 )
end

function PlayerInfoModel:logout()
    --this.uid = 0
    -- this.nickname = "" 
    -- this.avatar = nil 
    -- this.exp = 0
    -- this.level = 0
    -- this.vip = 0
    -- this.vipPts =0
    -- this.spinPts = 0
    -- this.lang = 0
    -- this.signature = 0
    -- this.country = 0
    this.recharge = nil
    if(self._heartBeatHandle )then
        self._heartBeatHandle:Stop()
    end
    this.ResetPingCallBack()
    --Facade.RemoveCommand(NotifyName.Login.StartPing)
end

function PlayerInfoModel:ChangeNickNameAndAvatar(nickname,avatar)
    this.my_info.avatar = avatar
    this.my_info.nickname = nickname
    Event.Brocast(EventName.Event_UpdateRoleInfo)
end
function PlayerInfoModel:GetLevelInfoConfig()
    local model = ModelList.levelUpModel 
    local config = model:GetLevelInfoConfig(this.my_info.level)
end

function PlayerInfoModel:SubmitEmailAdress()
    local subEmail = Csv.GetData("description", 24, "description")
    local subTtiel = Csv.GetData("description", 25, "description")
    local subContent1 = Csv.GetData("description", 26, "description")
    local subContent2 = Csv.GetData("description", 27, "description")

    local Platform = "Android"
    local packageName = "live.party.bingo.free.vegas.online.jackpot.casino.game"
    local IDFA = ""
    local Language = ""
    local Country = ""
    local DeviceInfo = ""
    local OsVer = ""
    local bundleID = 0
    -- 判断平台
    -- 判断bundleID 
    local platform = UnityEngine.Application.platform
    if platform == UnityEngine.RuntimePlatform.IPhonePlayer then
        Platform = "iOS"
        bundleID ="1615747852"
    end 

    subTtiel = string.format(subTtiel,"LivePartyBingo")
    subContent2 = string.format(subContent2,
    "LivePartyBingo",--游戏名称
    tostring(this.uid), --uid Platform / Bundle ID /nIDFA /n Language / Country / Device Info / Os Ver
    Platform,packageName,bundleID,"Device","en","unkonwn","unkonwn",UIUtil.get_client_version())   

    Util.SendEmail(subEmail, subTtiel,subContent1..subContent2)
end


function PlayerInfoModel:IsFaceBookLogin()
    return ModelList.loginModel:GetLoginPlatform() == PLATFORM.PLATFORM_FACEBOOK
end

function PlayerInfoModel:GetUserInfo()
    if not this.my_info then
        log.log("没有基本用户数据")
        return {}
    end

    local user = {}

    user.level = this.my_info.level
    user.vip = this.my_info.vip 
    user.exp = this.my_info.exp
    user.uid = this.uid
    user.nickname = this.my_info.nickname
    user.credit = this.credit
    --local jpgId = user.uid %200+1
    user.avatar = this.my_info.avatar
    user.email  = this.my_info.email or ""
    user.team = this.teamId
    user.country = this.my_info.country

    return user
end

function PlayerInfoModel:GetUserRechargeInfo()
    local recharge = {}
    if this.my_info and this.my_info.rechargeInfo then
        recharge.amount = this.my_info.rechargeInfo.amount
        recharge.times = this.my_info.rechargeInfo.times
        recharge.maxAmount = this.my_info.rechargeInfo.maxAmount
        recharge.lastAmount = this.my_info.rechargeInfo.lastAmount
        recharge.lastTime = this.my_info.rechargeInfo.lastTime
    end
    return recharge
end

function PlayerInfoModel:GetSignature()
    return this.my_info.signature
end

function PlayerInfoModel:GetExp()
    return this.my_info.exp
end


function PlayerInfoModel:GetHeadIcon()
    -- return fun.get_strNoEmpty(--[[this.my_info.avatar 先去掉，服务器发过来的头像有问题--]] nil, "b_bingo_head2")
    return ModelList.PlayerInfoSysModel.GetUsingHeadIconName()
end

function PlayerInfoModel:IsAutoLobbyOpen()
    local playInfo = self:GetUserInfo()
    local openLevel = Csv.GetData("level_open",2,"openlevel")
    if playInfo and openLevel then
        return playInfo.level >= openLevel
    end
    return false
end

function PlayerInfoModel:ChangeHeadIconSprite(image_tab)
    if this.IsFaceBookLogin() then
        local downUrl = this.my_info.avatar
        UIUtil.request_url_portrait(downUrl,function(sprite)
            if sprite then
                this.head_sprite = sprite
                if type(image_tab) == "table" then
                    for i = 1, #image_tab do
                        image_tab[i].sprite = sprite
                    end
                else
                    image_tab.sprite = sprite
                end
            end
        end)
    else
    end
end


function PlayerInfoModel:InitHeadSprite(sprite)
    this.head_sprite = sprite
end

function PlayerInfoModel:GetHeadSprite(image,index)
    if this:IsFaceBookLogin() then
        local downUrl = this.my_info.avatar
        UIUtil.request_url_portrait(downUrl,function(sprite)
            if sprite then
                return sprite
            end
        end)
    else

    end
end

function PlayerInfoModel:GetHeadUrl()
   return ModelList.loginModel:GetResurl().. self:GetAvatar()
end

--获取VIP等级
function PlayerInfoModel:GetVIP()
    return this.my_info.vip or 0
end

--获取VIP 经验
function PlayerInfoModel:GetVipPts()
    return this.my_info.vipPts
end

function PlayerInfoModel:IsMaxVipLevel()
    if this.my_info.vip == #Csv.new_vip then return true end
    return false
end

function PlayerInfoModel:SaveOldVipPts(vipExp,vipLevel)
    this.my_old_vipPts = vipExp or this.my_info.vipPts
    this.my_old_vipLv = vipLevel or this.my_info.vip
    if not this:IsMaxVipLevel() then
        this.trigger_vip_pop = true
    end
end

function PlayerInfoModel:ShowVipChange()
    this.trigger_vip_pop = false
end

function PlayerInfoModel:GetOldVipPts()
    return this.my_old_vipPts or 0,this.my_old_vipLv or this.my_info.vip
end

function PlayerInfoModel:GetTotalSpin()
    return this.my_info.spinTimes or 0
end

--设置spin次数 假数据
function PlayerInfoModel:SetSpinTotalFake()
    if not this.my_info then
        this.my_info = {}
        this.my_info.spinTimes = 0
    end
    if not this.my_info.spinTimes then
        this.my_info.spinTimes =  0
    end
    this.my_info.spinTimes = this.my_info.spinTimes + 1
    if this.my_info.spinTimes >= 60 then
        Facade.SendNotification(NotifyName.ShowTargetNewGuide, NewGuideView.guide_list.back_home_guide)
    end
end

function PlayerInfoModel:GetTotalGain()
    return this.my_info.totalGained or 0
end

function PlayerInfoModel:SetTeamId(teamId)
    this.teamId = teamId 
    this.SendNotification(NotifyName.M10001.PlayerInfoTeamIdChange,this.teamId)
end

function PlayerInfoModel:GetTeamId()
    return this.teamId 
end

--[[
function PlayerInfoModel.set_credit(code,data)
    if(code == RET.RET_SUCCESS)then  
        this.SetCredit(data.credit)

        if this.ShowCredit then
            ShowTips("当前Credit值:"..tostring(ModelList.PlayerInfoModel.GetCredit()))
        end
    else
        log.log("机台积分通知错误" ,code)
    end 
end
--]]

--[[
function PlayerInfoModel.ReceiveNickName(code,data)
    log.log("接收昵称A", code)
    log.log("接收昵称B", data)
end

function PlayerInfoModel.ReceiveHeadIcon(code,data)
    log.log("接收头像A", code)
    log.log("接收头像B", data)
end
--]]

function PlayerInfoModel:ReqFetchPlayerInfo(uid)
    this.last_searche_uid = uid
    Http.fetch_user_info(uid)
end

function PlayerInfoModel:GetOtherPlayerInfo()
    if this.last_searche_uid == this.uid then
        return this.my_info
    else
        if  this.other_player_info[this.last_searche_uid] then
            return this.other_player_info[this.last_searche_uid]
        end
        log.log("没有对应数据玩家数据 错误")
        return nil
    end
end

function PlayerInfoModel.SetShowCredit()
    if this.ShowCredit then
        ShowTips("关闭Credit显示")
        this.ShowCredit = false
    else
        ShowTips("打开Credit显示")
        this.ShowCredit = true
    end
end

function PlayerInfoModel:IsHasOtherPlayerInof(uid)
    this.last_searche_uid = uid

    if uid == this.uid  then
        return this.my_info 
    end
    if this.other_player_info and this.other_player_info[uid] then
        return true
    end
    return false
end

--获取其他玩家信息
function PlayerInfoModel:SetOtherPlayerInfo(data)
    this.other_player_info = this.other_player_info or {}
end

function PlayerInfoModel:SaveMyInfo(data)
    local groups = nil
    if this.my_info.groups then 
        groups = deep_copy(this.my_info.groups)
    end 
    
    this.my_info = deep_copy(data)
    --if not this.my_info.vip or this.my_info.vip>Csv.GetDataLength("new_vip") then 
    --    this.my_info.vip = 1
    --end

    if not this.my_info.groups then 
        this.my_info.groups = groups
    end 

    log.g("my info data groupid"..this.my_info.groups);

    --判断邮件绑定
    if this.my_info.email and this.my_info.email  ~= "" then 
        SDK.SetFirebaseAnalyticsMail(this.my_info.email)
    end 

    this.SetAbParamKeyValue()
end

function PlayerInfoModel:IsGroupId(groupid)
    if this.my_info.groups then 
        local data = JsonToTable(this.my_info.groups) 
        if type(data) == "table" then
           for _,v in pairs(data) do
                if type(v) == "string" and v == tostring(groupid) then 
                    return true 
                end   
           end 
        end
    end 
   
    return false -- 默认不存在此群组  --ceshi 
end 

--key 为丢进来的，如果使用表是逻辑不一样，而不是数值不一样此逻辑有效
function PlayerInfoModel:CheckAbTest(key)

    -- 11/8 1.19 版本看能双端逻辑是否能统一 
    if fun.is_android_platform() then 
        return true
    else
        if  this.my_info.abParams ~= nil and  this.my_info.abParams[key] then 
            return  this.my_info.abParams[key] == "2"
        else
            return true
        end 
    end 

    return true
end 

function PlayerInfoModel:SetGroupPrefix(groupPrefix)
    log.log("dghdgh007 set group prefix ", groupPrefix, this.groupPrefix)
    this.groupPrefix = groupPrefix
end
----------deep link-----------------------------------------------------------
function PlayerInfoModel:CheckDeeplinkInfo()
    local deeplink = UnityEngine.PlayerPrefs.GetString("DeferredDeeplink","")
    log.log(" PlayerInfoModel:CheckDeeplinkInfo "..deeplink)
    if  deeplink ~= "" then 
        this:DeferredDeeplinkCallback(deeplink)
    end 
end

function PlayerInfoModel:Login_C2S_CheckDeeplinkInfo()
    local deeplink = UnityEngine.PlayerPrefs.GetString("DeferredDeeplink","")
    log.log(" PlayerInfoModel:CheckDeeplinkInfo "..deeplink)
    if  deeplink ~= "" then 
         --打点 深度链接事件
        -- local adid = SDK.GetAppFlyerId()
        -- local  deviceid = UnityEngine.PlayerPrefs.GetString("DeviceToken","editor")
        SDK.thought_DeepLinkopen(deeplinkURL,adid,deviceid)
        return MSG_ID.MSG_DEEP_LINK_REPORT,Base64.encode(Proto.encode(MSG_ID.MSG_DEEP_LINK_REPORT,{params = deeplink}))
    end 

    return nil,nil
  
    --this.SendMessage(MSG_ID.MSG_DEEP_LINK_REPORT, {params = deeplink})
    --   Http.send_deep_link(deeplinkURL,this.setDeeplinkInfoReturn)
   
end

function PlayerInfoModel:setDeeplinkInfoReturn()
    log.log(" PlayerInfoModel:Delete ")
    fun.delete_value("DeferredDeeplink")
end

--- 向bi请求互导信息参数
function PlayerInfoModel:ReqDeepLinkInfo()

    -- local adid = SDK.GetAppFlyerId()
    -- local  deviceid = UnityEngine.PlayerPrefs.GetString("DeviceToken","editor")
    SDK.thought_DeepLinkopen(deeplinkURL,adid,deviceid)
    Http.send_deep_link(deeplinkURL,this.setDeeplinkInfoReturn)
end
------------------------------------------------------------------------------------------------

function PlayerInfoModel:GetGroupPrefix()
    return this.groupPrefix
end

--- 保存用户群组id集合
function PlayerInfoModel:SaveMyGroupIds(groupIds)
    this.groupIds = deep_copy(groupIds)
    --群组变化 ,不在群组的 插屏队列 清空
    if ModelList.AdModel then
        ModelList.AdModel.CheckInterstitialQueue()
    end
end
--- 获取用户群组id集合
function PlayerInfoModel:GetMyGroupIds()
    return this.groupIds
end

--设置个人信息
function PlayerInfoModel:SetMyPlayerInfo(data)
    this:SaveMyInfo(data)
    ModelList.SetDataUpdate(data,"CityModel","roleInfo")
  
    ModelList.PlayerInfoSysModel.SetUsingAvatarData(data.avatar)

    if this:IsFaceBookLogin() then
        this.my_info.avatar = data.avatar
    else
        if data.avatar == "" then
            this.my_info.avatar = 1
        else
            this.my_info.avatar = tonumber(data.avatar)
        end
    end

    --发送事件
    Facade.SendNotification(NotifyName.PlayerInfo.UpdateRoleInfo)
end

function PlayerInfoModel.ReceivePlayerInfo(code,data)
    log.log("data    ",data)
    local result = code == 0 
    if result then
        local uid = data.uid
        if tonumber(uid) == this.uid then
            this:SetMyPlayerInfo(data.roleInfo)
        else
            this:SetOtherPlayerInfo(data.roleInfo)
        end
    else
        log.r("查找 用户失败,"..code)
        ModelList.loginModel:BackToLoginScene()
    end
    --Facade.SendNotification(NotifyName.CloseCommonLoading, "ProFileViewReqData", result)
end

function PlayerInfoModel:SetIsTrueGoldUser(flag)
    this.isTrueGoldUser = flag
end

function PlayerInfoModel:GetIsTrueGoldUser()
    return this.isTrueGoldUser and true or false
end

--全量推送
function PlayerInfoModel.S2C_Update_RoleInfo(code,data)
    if code == RET.RET_SUCCESS and data then
        if this.my_info ~= nil then --升级了
        end 

        this:SetMyPlayerInfo(data)
        Event.Brocast(EventName.Event_UpdateRoleInfo)
        ModelList.GuideModel:UpdateRoleLevel()
        ModelList.FBFansModel:UpdateRolePayType(data)
    end
end

--只推变化量
function PlayerInfoModel.S2C_Update_RoleInfo_singly(code,data)
    if code == RET.RET_SUCCESS and data then
        if this.my_info == nil then
            return
        end
        for key, value in pairs(data.item) do
            if this.my_info[value.key] then
                --log.y("======================>>S2C_Update_RoleInfo_singly key: " ..value.key .. "       value: " .. value.value)
                if value.key == "vipPts" then
                    this:SaveOldVipPts()
                end
                local t = type(this.my_info[value.key])
                if t == "string" then
                    this.my_info[value.key] = tostring(value.value)
                elseif t == "number" then
                    this.my_info[value.key] = tonumber(value.value)
                elseif t == "table" then
                    this.my_info[value.key] = json.decode(value.value)
                end
            end 
            if value.key == "abParams" then
                this.SetAbParamKeyValue()
            end
            if value.key == "level" then
                ModelList.OnLevelChange(value.value)
            end
        end

        --if not this.my_info.vip or this.my_info.vip <= 0 or this.my_info.vip>Csv.GetDataLength("new_vip") then 
        --    --this.my_info.vip = 1
        --end 

        ModelList.SetDataUpdate(this.my_info,"CityModel","roleInfo")
        Event.Brocast(EventName.Event_UpdateRoleInfo)
        ModelList.GuideModel:UpdateRoleLevel()
    end
end

function PlayerInfoModel.S2C_Update_AbParams(code,data)
    if code == RET.RET_SUCCESS and data then
        --暂时没用到这个消息，等服务端启用
    end
end

--把abparam列表转化为键值对，优化频繁读取查询
function PlayerInfoModel.SetAbParamKeyValue()
    if this.my_info and this.my_info.abParams then
        local params = this.my_info.abParams
        this.my_info.abParams = {}

        if type(params) == "table" then
            for key, value in pairs(params) do
                this.my_info.abParams[value.name] = value.value
            end
        end
        ModelList.GuideModel:InitData()
    end
end

function PlayerInfoModel.GetAbParamKeyValue(abParma)
    if this.my_info 
    and this.my_info.abParams 
    and this.my_info.abParams[abParma] then
        if this.my_info.abParams[abParma] =="1" or this.my_info.abParams[abParma] == "0" then
            return abParma
        else
            return string.format("%s_%s",abParma,this.my_info.abParams[abParma])
        end

    end
    return abParma
end

function PlayerInfoModel:GetPlayerInfo()
    return  this.player_info.roleInfo
end

function PlayerInfoModel.SetCredit(credit)
    this.credit = credit
end


function PlayerInfoModel:GetCountry()
    return this.my_info.country
end

function PlayerInfoModel:GetEmail()
    return this.my_info.email or ""
end

function PlayerInfoModel.GetCredit()
    if(this.credit)then 
        return this.credit
    end
    return 0
end

function PlayerInfoModel:ChangeHeadIcon(call)
    local downUrl = ModelList.loginModel:GetResurl().."/country/xx.jpg"
    UIUtil.request_url_portrait(downUrl,function(sprite)
        if call then
            call(sprite)
        end
    end)
end


function PlayerInfoModel:ChangeNickName(name)
    Http.change_nickname(name, function(code, msg, data)
        this.my_info.nickname = name
        Facade.SendNotification(NotifyName.System.Player_Info.UpdateNickName, data.nickname)
    end)
end

function PlayerInfoModel:ChangeHeadIconIndex(index)
    Http.change_portrait(index, function(code, msg, data)
        this.my_info.avatar = index
        Facade.SendNotification(NotifyName.System.Player_Info.UpdateTopViewHeadSprite)
        Facade.SendNotification(NotifyName.System.Player_Info.UpdateHeadIndex, index)
    end)
end

function PlayerInfoModel:ChangeSignature(str)
    Http.change_sign(str)
end

--[[
function PlayerInfoModel.ReceiveChangeSignature(code,data)
    if code == 0 then
        this:ChangeMySign(data.signature)
    else
        log.log("签名获取失败", code)
    end
end
--]]

function PlayerInfoModel:RevertStr(str)
    if string.len(str) > 32 then
        local revert = string.sub(str,1,32)
        return revert , true
    end
    return str , false
end

function PlayerInfoModel:ChangeFlagSprite(image)
    -- local downUrl = ModelList.loginModel:GetResurl()..url
    -- 现在服务端返回的国旗 名字是 局域网不能用 先用美国测试
    local downUrl
    if this.my_info.country == "局域网" then
        downUrl = ModelList.loginModel:GetResurl() .. "/country/" .."us.jpg"
    else
        downUrl = ModelList.loginModel:GetResurl() .. "/country/" .. this.my_info.country .. ".jpg"
    end
    UIUtil.request_url_portrait(downUrl,function(sprite)
        if sprite then
            this.head_sprite = sprite
            image.sprite = sprite
        end
    end)
end

function PlayerInfoModel:ChangeIndexSprite(sprite)
    this.head_sprite = sprite
end


--获取用户名
function PlayerInfoModel:GetNickName()
    -- return this.nickname
    return this.my_info.nickname
end

function PlayerInfoModel:SetHeadSpriteList(tab)
    this.head_sprite_list = tab
end

function PlayerInfoModel:LoadHeadSprite(callback)
    if this:IsFaceBookLogin() then
        SDK.request_player_head_photo(function(sprite)
            if callback then
                callback(sprite)
            end
        end)
    else
        if not tonumber(this.my_info.avatar) then
            UIUtil.request_url_portrait(this.my_info.avatar,function(sprite)
                if sprite then
                    callback(sprite)
                else
                    log.log("没有下载到对应图片", this.my_info.avatar)
                    -- callback(nil)
                end
            end)
        else
            local sprite = this.head_sprite_list[tonumber(this.my_info.avatar)] 
            callback(sprite) 
        end
    end
end

function PlayerInfoModel:GetHeadSpriteList(index)
    return this.head_sprite_list[tonumber(index)]
end

function PlayerInfoModel:SetPlayerInfo(exp,lv)
    this.my_info.exp = exp
    this.my_info.level = lv

end

function PlayerInfoModel:GetLv()
    return this.my_info.level
end

function PlayerInfoModel:C2SPing(cb)
    this.cb = cb
    Network.SendMessage(MSG_ID.MSG_PING,{isPlaying = 1},true);
end

function PlayerInfoModel.ResetPingCallBack()
    if this.cb then
        this.cb = nil
    end
end

function PlayerInfoModel.S2CPing(code,data)
    if(code == RET.RET_SUCCESS)then
        if data and data.uid ~= 0 then
            this.recPingTime  = os.time()
            this.pingFailCout = 0
        else
            if Network.isConnect then
                --log.r("PlayerInfoModel.S2CPing"..tostring(data))
                if data and  data.uid == 0 and Network.SendConnectState >= 3 then
                    Network.Close()
                end
            end
        end
    elseif(code == -99)then 

    end
    if this.cb then
        this.cb(code == RET.RET_SUCCESS and true or false)
        this.cb = nil
    end
end

function PlayerInfoModel:GetConfigTime(type)
    return SystemConfigTools:Get("playerInfo", type)
end

-- 通过传入头像参数修改头像
-- avatar :头像参数
-- callback : 设置头像方法
function PlayerInfoModel:LoadTargetHeadSprite(avatar,callback)
    local call_back = function(sprite)
        if callback then
            callback(sprite)
        end
    end
    if not avatar or avatar == "" then
        local sprite = this.head_sprite_list[1] 
        call_back(sprite)
    elseif tonumber(avatar) then
        -- 默认头像的数量 从 20个减少到16个  
        local sprite
        if tonumber(avatar)> 16 then --老号兼容
            sprite = this.head_sprite_list[1] 
        else
            sprite = this.head_sprite_list[tonumber(avatar)] 
        end
        call_back(sprite)
    else
        local str_base = "https://"
        local start_index , end_index = string.find( avatar, str_base )
        if start_index and end_index then
            --facebook 头像

            UIUtil.request_url_portrait(avatar,function(sprite)
                if sprite then
                    call_back(sprite)
                else
                    log.log("没有下载到对应图片", this.my_info.avatar)
                end
            end)
        else
            --服务器头像
            local downUrl = ModelList.loginModel:GetResurl()..avatar
            -- downUrl = string.gsub(downUrl,"jpg","png")
            -- log.log("头像下载地址",downUrl )
            UIUtil.request_url_portrait(downUrl,function(sprite)
                if sprite then
                    call_back(sprite)
                end
            end)
        end
    end
end

-- 获取玩家自己头像
function PlayerInfoModel:ChangeMyLoadSprite(callBack)
    this:LoadTargetHeadSprite(this.my_info.avatar, callBack)
end

--获得玩家国旗图片
function PlayerInfoModel:ChangePlayerFlagSprite(short_country, func)
    -- local downUrl = ModelList.loginModel:GetResurl()..url
    -- 现在服务端返回的国旗 名字是 局域网不能用 先用美国测试
    local country = ""
    if not short_country then
        country = "us"
    else
        country = string.lower(short_country)
    end
    local downUrl
    if country == "局域网" then
        downUrl = ModelList.loginModel:GetResurl() .. "/country/" .."us.jpg"
    else
        downUrl = ModelList.loginModel:GetResurl() .. "/country/" ..country .. ".jpg"
    end
    -- log.log("国旗地址", downUrl)

    -- log.log("个人信息下载国旗地址：", downUrl)
    UIUtil.request_url_portrait(downUrl,function(sprite)
        if func and sprite then
            func(sprite)
        end
    end)
end


function PlayerInfoModel:InitData()
    this.last_searche_uid = nil
    this.my_info  = {}
    this.tip_open_state = false
    this.other_player_info = {}
    this.purchase_info = nil
    this.temp_purchase = nil
end

function PlayerInfoModel:GetAvatar()
    return this.my_info.avatar
end

function PlayerInfoModel:GetLevel()
    return this.my_info.level
end

function PlayerInfoModel:SetTipState(state)
    this.tip_open_state = state
end

function PlayerInfoModel:GetTipState()
    return this.tip_open_state
end

function PlayerInfoModel:ChangeMySign(str)
    this.my_info.signature = str
end

function PlayerInfoModel:IsMe(uid)
    return this.uid == uid
end

function PlayerInfoModel:GetUserType()
    return this.my_info.userPayType
end 


--设置付费信息
function PlayerInfoModel:SetPurchaseInfo(purchase_info)
    this.purchase_info = purchase_info
end

--是否首次购买
function PlayerInfoModel:GetFirstPurchase()
    if this.temp_purchase == true then
        return false
    end
    if not this.purchase_info or not this.purchase_info.amount then
        return false
    end
    return this.purchase_info.amount <= 0
end

function PlayerInfoModel:SetLocalPurchaseState(state)
    this.temp_purchase = state
end

function PlayerInfoModel:GetCityId()
    return this.my_info.city
end

function PlayerInfoModel:ReqEventReport(event_name,extras_con)
    log.r("ReqEventReport ")
    this.SendMessage(MSG_ID.MSG_EVENT_REPORT, {event =event_name,extras = extras_con })
end

function PlayerInfoModel:ReqDailyReward(dailyRewardType)
    this.SendMessage(MSG_ID.MSG_DAILY_REWARD, {dailyRewardType = dailyRewardType })
end

function PlayerInfoModel:ClaimRegisterReward()
    Message.AddMessage(MSG_ID.MSG_REGISTER_RECEIVE_REWARD, this.S2C_OnClaimRegisterReward)
    this.SendMessage(MSG_ID.MSG_REGISTER_RECEIVE_REWARD,{})
end

function PlayerInfoModel.S2C_OnClaimRegisterReward(code,data)
    if not data then 
        data = {}
        log.w("errror S2C_OnClaimRegisterReward no data")
    end 
    
    this.registerReward = nil
    Message.RemoveMessage(MSG_ID.MSG_REGISTER_RECEIVE_REWARD)
    Event.Brocast(EventName.Event_registerReward,data.reward or {})
end

local matureTimePoint = nil
local awardInfo = nil

function PlayerInfoModel.ReceiveDailyAward(code,data)
    if code == RET.RET_SUCCESS and data then
        --matureTimePoint = data.countdown + os.time()
        --log.r("ReceiveDailyAward ")
        awardInfo = data.reward
        ModelList.PlayerInfoModel:SaveDailyInfo(nil)
        Facade.SendNotification(NotifyName.DailyRewardView.DailyRewardespone)
    end
end
function PlayerInfoModel:GetRewardItemId()
    if awardInfo then
        return awardInfo
    end
    return Resource.coin
end

function PlayerInfoModel:GetRewardNum()
    if awardInfo then
        return awardInfo.value
    end
    return 0
end

function PlayerInfoModel:IsFaceBookOpen()
    --登出账号会清理数据，所以要用PlayerPrefs保存起来
    local isOpen = false
    if plateformOpenData then
        for key, value in pairs(plateformOpenData) do
            if 1 == value then
                isOpen = true
                break
            end
        end
    end
    return isOpen or fun.get_int(DATA_KEY.FaceBookOpen,0) == 1
end

function PlayerInfoModel:GetupLevelState(type)
    if not this.upLevelState[type] then 
        return false
    end 
    
    return this.upLevelState[type]
end

function PlayerInfoModel:SetupLevelState(type)
    this.upLevelState[type] = false
end 
    
function PlayerInfoModel:SetupLevelStateTrue(type)
    this.upLevelState[type] = true
end

function PlayerInfoModel.ReceiveShowScore(code,data)
    if code == RET.RET_SUCCESS and data then
        ModelList.PlayerInfoModel:SaveShowScoreInfo(data)
    end
end

function PlayerInfoModel.GetShowScore()
    return this.showScore
end
function PlayerInfoModel.ResetShowScore()
    this.showScore = nil
end

--- 评分
function PlayerInfoModel.ReqSubmitScore(star,text)
    this.SendMessage(MSG_ID.MSG_SUBMIT_SCORE, {star =star,text = text })
end

--- 接收到建议
---
function PlayerInfoModel.ReceiveSubmitSuggest(code,data)
    if code == RET.RET_SUCCESS  then
        Event.Brocast(EventName.Event_EvaluateUs_Award)
        this.showScore = nil
    end
end

-----接收到删除账号

function PlayerInfoModel.S2C_DeleteAccount(code,data)
    if code == RET.RET_SUCCESS  then
        log.r("delete now Account")
        Http.init()
        ModelList.PlayerInfoModel:logout()
        ModelList.GuideModel:Close()
        Network.ResetReconnect()
        Network.Close()
        LuaTimer:Clear(nil,true)
        Facade.SendNotification(NotifyName.ShowUI,ViewList.SceneLoadingGameView,nil,nil,JumpSceneType.ToLogin)
    end
end

function PlayerInfoModel.C2S_DeleteAccount()
    this.SendMessage(MSG_ID.MSG_ACCOUNT_CANCEL, {})
end


-----接收到用户分组改变
function PlayerInfoModel.S2C_ChangeGroup(code,data)
    local isExitData = (data ~= nil) and next(data)
    if code == RET.RET_SUCCESS and isExitData then
        if data.type == 0 then
            this:SaveMyGroupIds(data.groupIds)
            this.SendMessage(MSG_ID.MSG_GROUP_CHANGE_NOTIFY, {groupIds =this.groupIds })
            SDK.send_change_user_groups(this.groupIds)
        end
    end
end
--修改用户名
function PlayerInfoModel:ChangeMyNickName(nickName)
    -- return this.my_info.nickname
    if this.my_info then
        this.my_info.nickname = nickName
    end
end

--同步用户分组
function PlayerInfoModel.S2C_SyncGroupPrefix(code, data)
    log.log("dghdgh007 sync group prefix ", code, data)
    if code == RET.RET_SUCCESS  then
        if data.isUse then
            local bundle = {}
            bundle.from = this:GetGroupPrefix()
            bundle.to = data.groupPrefix
            this:SetGroupPrefix(data.groupPrefix)
            Facade.SendNotification(NotifyName.PlayerInfo.RefreshGroupPrefix, bundle)
        else
            this.SendMessage(MSG_ID.MSG_SYNC_GROUP_PREFIX, {groupPrefix = data.groupPrefix})
        end
    else
        --[[
        local desc = "同步用户配置前缀异常，前缀不一致"
        if code == RET.RET_DIFF_GROUP_CONFIG_PREFIX then
            UIUtil.show_common_popup(9029,true,nil)
        end
        ]]
    end
end

----深度链接发给后端
function PlayerInfoModel:DeferredDeeplinkCallback(deeplinkURL)
  
    this.SendMessage(MSG_ID.MSG_DEEP_LINK_REPORT, {params = deeplinkURL})
 --   Http.send_deep_link(deeplinkURL,this.setDeeplinkInfoReturn)

    --打点 深度链接事件
    -- local adid = SDK.GetAppFlyerId()
    -- local  deviceid = UnityEngine.PlayerPrefs.GetString("DeviceToken","editor")
    SDK.thought_DeepLinkopen(deeplinkURL,adid,deviceid)
end 



--设置键值 的位无效
function PlayerInfoModel.SetDeeplinkRewardDisabled(key)
    DeepLinkPart.SetDeeplinkRewardDisabled(key)
end

--获取奖励信息
function PlayerInfoModel.GetDeeplinkRewardInfo()
    return DeepLinkPart.GetDeeplinkRewardInfo()
end

--获取奖励信息
function PlayerInfoModel.GetDeepLink()
    return DeepLinkPart
end

--服务器发送奖励到
function PlayerInfoModel.S2CDeeplinkRewardInfo(code,data)
    if code == RET.RET_SUCCESS  then
        DeepLinkPart.SetDeeplinkRewardInfo(data.rewardInfo)
    else 

    end 
end

--服务器发送领取奖励
function PlayerInfoModel.C2SDeepLinkCodeReward(codeid)
    this.SendMessage(MSG_ID.MSG_DEEP_LINK_CODE_REWARD, {codeId = codeid})
end

--服务器收到领取奖励
function PlayerInfoModel.S2CDeepLinkCodeReward(code,data)
    if code == RET.RET_SUCCESS  then
        
    else 

    end 
end

--发送服务器跳转链接
function PlayerInfoModel.C2SBravoHelpSuccess()
    this.SendMessage(MSG_ID.MSG_DIVERSION_REWARD, {})
end 

--服务器收到领取奖励
function PlayerInfoModel.S2CBravoHelpSuccess(code,data)
 
    --不管是否是成功还是失败，只要收到这个链接，就是有奖励领奖，没有奖励关闭
    local reward = nil 
    if data == nil then 
 
    else 
        reward = data.reward 
    end 
    Facade.SendNotification(NotifyName.BravoGuideHelp.DeepLinkHit, reward )
end

--获取vip加成数据
function PlayerInfoModel.GetVipAddValue()
    local vipLevel = ModelList.PlayerInfoModel:GetVIP()
    local data = Csv.GetData("new_vip" , vipLevel)
    return data
end

--获取账号等级商店加成
function PlayerInfoModel.GetPlayerLevelAddValue()
    local level = ModelList.PlayerInfoModel:GetLv()
    local data = Csv.GetData("new_level" , level)
    return data
end

--获取全部商店加成
function PlayerInfoModel.GetTotalAddValue()
    local vipAddData = this.GetVipAddValue()
    local levelAddData = this.GetPlayerLevelAddValue()
    return vipAddData.shop_added + levelAddData.shop_added
end

--获取下个VIP加成的VIP等级(大于当前vip等级的加成)
function PlayerInfoModel.GetNextVipAddLevel()
    local currVipLv = ModelList.PlayerInfoModel:GetVIP()
    local vipInfo = Csv.GetData("new_vip", currVipLv)
    local curAddValue = vipInfo.shop_added
    for k , v in ipairs(Csv.new_vip) do
        if v.shop_added > curAddValue then
            return k
        end
    end
    return nil
end


--获取下个等级加成的等级(大于当前等级的加成)
function PlayerInfoModel.GetNextLevelAddLevel(curLevel)
    if not curLevel then
        curLevel = ModelList.PlayerInfoModel:GetLevel()
    end
    local data = Csv.GetData("new_level", curLevel)
    local curAddValue = data.shop_added
    for k , v in ipairs(Csv.new_level) do
        if v.shop_added > curAddValue then
            return k
        end
    end
    return nil
end


this.MsgIdList =
{
    {msgid = MSG_ID.MSG_PING,func = this.S2CPing},
    {msgid = MSG_ID.MSG_USER_FETCH,func = this.ReceivePlayerInfo},
    {msgid = MSG_ID.MSG_UPDATE_ROLE_NOTIFY,func = this.S2C_Update_RoleInfo},
    {msgid = MSG_ID.MSG_ROLE_CHANGE_NOTIFY,func = this.S2C_Update_RoleInfo_singly},
    {msgid = MSG_ID.MSG_ABPARAMS_NOTIFY,func = this.S2C_Update_AbParams},
    {msgid = MSG_ID.MSG_DAILY_REWARD,func = this.ReceiveDailyAward},
    {msgid = MSG_ID.MSG_SHOW_SCORE,func = this.ReceiveShowScore},
    {msgid = MSG_ID.MSG_SUBMIT_SCORE,func = this.ReceiveSubmitSuggest},
    {msgid = MSG_ID.MSG_ACCOUNT_CANCEL,func = this.S2C_DeleteAccount},
    {msgid = MSG_ID.MSG_GROUP_CHANGE_NOTIFY,func = this.S2C_ChangeGroup},
    --{msgid = MSG_ID.MSG_ACCOUNT_CANCEL,func = this.S2C_DeleteAccount},
    {msgid = MSG_ID.MSG_DEEP_LINK_REPORT,func = this.setDeeplinkInfoReturn},
    {msgid = MSG_ID.MSG_SYNC_GROUP_PREFIX,func = this.S2C_SyncGroupPrefix},
    {msgid = MSG_ID.MSG_DEEP_LINK_CODE_NOTIFY,func = this.S2CDeeplinkRewardInfo},
    {msgid = MSG_ID.MSG_DEEP_LINK_CODE_REWARD,func = this.S2CDeepLinkCodeReward},
    {msgid = MSG_ID.MSG_DIVERSION_REWARD,func = this.S2CBravoHelpSuccess},
}

return this 