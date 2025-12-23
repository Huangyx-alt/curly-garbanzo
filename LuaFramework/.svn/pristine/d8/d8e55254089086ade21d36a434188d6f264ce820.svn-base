local PlayerInfoSysModel = BaseModel:New("PlayerInfoSysModel")
local this = PlayerInfoSysModel

local pageData = nil                                                                      --个人信息首页数据
local avatarListData = nil                                                                --后台返回的全部头像数据  key：字符串
local frameListData = nil                                                                 --后台返回的全部头像框数据 key：字符串

local configAchievementData = nil                                                         --成就配置
local configAvatarData = nil                                                              --头像配置
local configFrameData = nil                                                               --头像框配置

local useingHeadIconID = nil                                                              --使用中的头像序号（如果使用FB头像 useingHeadIconID = faceBookAvatarDefaultName）
local useingFrameID = nil                                                                 --使用中的头像框序号

local sysCheckNickName = ""                                                               --检查的昵称

local faceBookAvatarDefaultName = "fb-avatar"                                             --和后台约定使用FB头像

local newFrameOrAvatarList = {}                                                           --新解锁的头像和头像框
local nextCanChangeNickNameUnix = 0                                                       --下次可以修改昵称的时间戳

local faceBookAvatarPath = UnityEngine.Application.persistentDataPath .. "/UserPhoto.png" --本地FB头像路径
local missLocalFBResourceToReplaceId = "1"                                                --本地丢失FB头像 强制替换其他头像ID
local missLocalFBResourceToReplaceName = "b_bingo_head1"                                  --本地丢失FB头像 强制替换其他头像名字

--检查是本地存在FB头像图片
function PlayerInfoSysModel:CheckFaceBookAvatarResourceExist()
    if fun.file_exist(faceBookAvatarPath) then
        return true
    end
    return false
end

--检查是fb头像
function PlayerInfoSysModel:CheckIsFbHead(avatarName)
    return avatarName == faceBookAvatarDefaultName
end

function PlayerInfoSysModel:InitData()
    this:InitAchieventmentItem()
    this:InitAvatarItem()
    this:InitFrameItem()
end

function PlayerInfoSysModel:SetLoginData(data)
    if data then
        if data.roleInfo and data.roleInfo.avatar then
            this.LoginSetUsingHeadIconID(data.roleInfo.avatar)
        end

        if data.nextCanChangeUnix then
            this.ChangeNickNameNextUnix(data.nextCanChangeUnix)
        end
    end
end

--修改使用头像数据
function PlayerInfoSysModel.SetUsingAvatarData(avatar)
    if not avatar or avatar == "" or useingHeadIconID == avatar then
        --log.log("个人信息 修改头像错误" , avatar)
        return
    end
    this.SetUsingHeadIconID(avatar)
    this.RefreshAvatarList(avatar)
end

--缺失本地FB头像资源 强制替换其他头像
function PlayerInfoSysModel:MissLocalFBResourceToReplace()
    this.SetUsingAvatarData(missLocalFBResourceToReplaceId)
    return missLocalFBResourceToReplaceId
end

--修改头像列表使用状态
function PlayerInfoSysModel.RefreshAvatarList(avatar)
    if avatarListData and avatarListData.list then
        for k, v in pairs(avatarListData.list) do
            if v.icon ~= avatar and v.status == avatarStatus.using then
                --修改前使用的 改为未使用
                v.status = avatarStatus.unlock
            elseif v.icon == avatar then
                v.status = avatarStatus.using
            end
        end
    end
    -- log.log("个人信息 头像列表修改后" , avatar , avatarListData)
end

--修改头像框列表使用状态
function PlayerInfoSysModel.RefreshFrameList(frame)
    for k, v in pairs(frameListData.list) do
        if v.icon ~= frame and v.status == avatarStatus.using then
            --修改前使用的头像 改为未使用
            v.status = avatarStatus.unlock
        elseif v.icon == frame then
            v.status = avatarStatus.using
        end
    end

    -- log.log("个人信息 头像列表修改后" , frame , frameListData)
end

--登录数据修改头像
function PlayerInfoSysModel.LoginSetUsingHeadIconID(id)
    this.SetUsingAvatarData(id)
end

--设置使用中的头像ID
--useingHeadIconID ：后台对应的是 id>tostring
function PlayerInfoSysModel.SetUsingHeadIconID(id)
    useingHeadIconID = id
    -- log.log("个人信息 修改个人头像" , id )
end

--使用中的头像ID
function PlayerInfoSysModel.GetUsingHeadIconID()
    return useingHeadIconID
end

--使用中的头像名字
function PlayerInfoSysModel.GetUsingHeadIconName()
    if useingHeadIconID then
        return this:GetConfigAvatarIconName(useingHeadIconID)
    end
    return "xxl_head018"
end

--设置使用中的头像框ID
function PlayerInfoSysModel.SetUsingFrameIconID(id)
    useingFrameID = id
    -- log.log("设置使用 头像框" , id )
end

--使用中的头像ID
function PlayerInfoSysModel.GetUsingFrameIconID()
    return useingFrameID
end

--需要展示的成就列表
function PlayerInfoSysModel:InitAchieventmentItem()
    configAchievementData = {}
    local config = Csv.achievement
    for k, v in ipairs(config) do
        if v.sequence ~= 0 then
            configAchievementData[v.sequence] = v
        end
    end
    -- log.log("配置检查 成就初始数据"   , configAchievementData)
end

--本地头像配置
function PlayerInfoSysModel:InitAvatarItem()
    configAvatarData = {}
    local config = Csv.personalise_head
    for k, v in ipairs(config) do
        configAvatarData[tostring(v.id)] = {
            id = v.id,
            icon = v.icon,
            description = v.description,
            unlock_value = v
                .unlock_value,
            icon_type = v.icon_type,
            unlock_type = v.unlock_type,
            default_icon = v.default_icon
        }
    end
    -- log.log("个人信息 配置检查 personalise_head", configAvatarData)
end

--本地头像框配置
function PlayerInfoSysModel:InitFrameItem()
    configFrameData = {}
    local config = Csv.personalise_edge
    for k, v in ipairs(config) do
        configFrameData[tostring(v.id)] = {
            id = v.id,
            icon = v.icon,
            description = v.description,
            unlock_value = v
                .unlock_value,
            icon_type = v.icon_type,
            unlock_type = v.unlock_type,
            default_icon = v.default_icon
        }
    end
    -- log.log("个人信息 配置检查 personalise_edge", configFrameData)
end

function PlayerInfoSysModel:GetConfigAvatarIconName(id)
    if id and configAvatarData[id] then
        --基础头像
        return configAvatarData[id].icon
    end
    return id
end

function PlayerInfoSysModel:GetConfigFrameIconName(id)
    if id and configFrameData[id] then
        return configFrameData[id].icon
    end
    return "SystemFramesTop"
end

function PlayerInfoSysModel:GetConfigAvatarDesId(avatarId, iconType)
    return configAvatarData[avatarId].description
end

function PlayerInfoSysModel:GetConfigFrameDesId(frameId, iconType)
    return configFrameData[frameId].description
end

function PlayerInfoSysModel:GetConfigAvatarIsDefault(avatarId)
    return configAvatarData[avatarId].default_icon == avatarDefaultState.isDefault
end

function PlayerInfoSysModel:GetConfigFrameIsDefault(frameId)
    if configFrameData and frameId and configFrameData[frameId] then
        local defaultIcon = configFrameData[frameId].default_icon
        return defaultIcon == avatarDefaultState.isDefault
    else
        return false
    end
    -- return configFrameData[frameId].default_icon == avatarDefaultState.isDefault
end

function PlayerInfoSysModel:GetShowAchievementTable()
    return configAchievementData
end

--个人主页
function PlayerInfoSysModel:C2S_RequestPersoPage()
    this.SendMessage(MSG_ID.MSG_PERSON_PAGE, {})
end

function PlayerInfoSysModel.S2C_ReceivePersoPage(code, data)
    -- log.log("个人信息 协议 2101", code ,data)
    if code == RET.RET_SUCCESS then
        pageData = data
        Facade.SendNotification(NotifyName.HallCity.Function_icon_click, "PlayerInfoSysView")
    else
        UIUtil.show_common_popup(8011)
    end
end

-- 成就参数
function PlayerInfoSysModel.GetAchievementIconValue(type)
    if pageData and pageData.achievements and pageData.achievements[type] then
        return pageData.achievements[type]
    end
    return nil
end

-- 最佳记录城市ID
function PlayerInfoSysModel.GetAchievementBiggestCityId()
    if pageData and pageData.biggestBingoWinPlayId then
        return pageData.biggestBingoWinPlayId
    end
    return nil
end

--个人主页

--头像列表
function PlayerInfoSysModel:C2S_RequestAvatarList()
    this.SendMessage(MSG_ID.MSG_AVATAR_LIST, {})
end

--登录时请求头像
function PlayerInfoSysModel:Login_C2S_RequestAvatarList()
    return MSG_ID.MSG_AVATAR_LIST, Base64.encode(Proto.encode(MSG_ID.MSG_AVATAR_LIST, {}))
end

function PlayerInfoSysModel.S2C_ReceiveAvatarList(code, data)
    -- log.log("个人信息 协议 2102", code ,data)
    if code == RET.RET_SUCCESS then
        avatarListData = data
        if this:CheckIsFbHead(useingHeadIconID) then
            table.insert(avatarListData.list, 1, { icon = faceBookAvatarDefaultName, status = 0 })
        else
            table.insert(avatarListData.list, 1, { icon = faceBookAvatarDefaultName, status = 1 })
        end
        for k, v in pairs(avatarListData.list) do
            if v.status == avatarStatus.using then
                this.SetUsingHeadIconID(v.icon)
            end
        end
    end
end

function PlayerInfoSysModel.GetAvatarList()
    return avatarListData
end

--头像列表

--头像框列表
function PlayerInfoSysModel:C2S_RequestAvatarFrameList()
    this.SendMessage(MSG_ID.MSG_AVATAR_FRAME_LIST, {})
end

function PlayerInfoSysModel:Login_C2S_RequestAvatarFrameList()
    this.SendMessage(MSG_ID.MSG_AVATAR_FRAME_LIST, {})
    return MSG_ID.MSG_AVATAR_FRAME_LIST, Base64.encode(Proto.encode(MSG_ID.MSG_AVATAR_FRAME_LIST, {}))
end

function PlayerInfoSysModel.S2C_ReceiveAvatarFrameList(code, data)
    if code == RET.RET_SUCCESS then
        if data ~= nil and next(data) then
            frameListData = data
            for k, v in pairs(data.list) do
                if v.status == avatarStatus.using then
                    this.SetUsingFrameIconID(v.icon)
                end
            end
        end
    end
end

function PlayerInfoSysModel.GetFrameList()
    return frameListData
end

--头像框列表

function PlayerInfoSysModel.S2C_ReceiveAvatarNew(code, data)
    -- log.log("个人信息 协议 2105", code ,data)
    if code == RET.RET_SUCCESS then
        for z, w in pairs(data.list) do
            table.insert(newFrameOrAvatarList, { icon = w.icon, iconType = avatarIconType.avatar })
            if avatarListData and avatarListData.list then
                for k, v in pairs(avatarListData.list) do
                    if v.icon == w.icon then
                        v.status = w.status
                    end
                end
            end
        end
        if avatarListData and avatarListData.list then
            table.sort(avatarListData.list, function(a, b)
                return a.status < b.status
            end)
        end

        -- log.log("个人信息 解锁新头像" ,newFrameOrAvatarList )
    end
end

--获取新头像推送

--获取新头像框推送
function PlayerInfoSysModel.S2C_ReceiveAvatarFrameNew(code, data)
    -- log.log("个人信息 协议 2106", code ,data)
    if code == RET.RET_SUCCESS then
        for z, w in pairs(data.list) do
            table.insert(newFrameOrAvatarList, { icon = w.icon, iconType = avatarIconType.frame })
            for k, v in pairs(frameListData.list) do
                if v.icon == w.icon then
                    v.status = w.status
                end
            end
        end

        table.sort(frameListData.list, function(a, b)
            return a.status < b.status
        end)
    end
end

--获取新头像框推送

--修改头像
function PlayerInfoSysModel:C2S_RequestChangeHeadIcon(id)
    this.SendMessage(MSG_ID.MSG_USER_AVATAR, { avatar = tostring(id) })
end

function PlayerInfoSysModel.S2C_ReceiveChangeHeadIcon(code, data)
    -- log.log("个人信息 协议 2005", code ,data)
    if code == RET.RET_SUCCESS then
        this.SetUsingAvatarData(data.avatar)
        Event.Brocast(NotifyName.PlayerInfo.ChangeAvatarEvent)
    else
        UIUtil.show_common_popup(8011)
    end
end

--修改头像

--修改头像框
function PlayerInfoSysModel:C2S_RequestChangeHeadIconFrame(id)
    this.SendMessage(MSG_ID.MSG_USER_AVATAR_FRAME, { avatarFrame = tostring(id) })
end

function PlayerInfoSysModel.S2C_ReceiveChangeHeadIconFrame(code, data)
    -- log.log("个人信息 协议 2036", code ,data)
    if code == RET.RET_SUCCESS then
        this.SetUsingFrameIconID(data.avatarFrame)
        this.RefreshFrameList(data.avatarFrame)
        Event.Brocast(NotifyName.PlayerInfo.ChangeFrameEvent)
    end
end

--修改头像框

--昵称
function PlayerInfoSysModel:C2S_RequestChangeNickName(name)
    this.SendMessage(MSG_ID.MSG_USER_NICKNAME, { nickname = name })
end

function PlayerInfoSysModel.S2C_ReceiveChangeNickName(code, data)
    -- log.log("个人信息 协议 2020", code ,data)
    if code == RET.RET_SUCCESS then
        ModelList.PlayerInfoModel:ChangeMyNickName(data.nickname)
        this.ChangeNickNameNextUnix(data.nextCanChangeUnix)
        Event.Brocast(NotifyName.PlayerInfo.SysChangeNickNameSuccess)
    else
        --UIUtil.show_common_popup(8011)
        Event.Brocast(NotifyName.PlayerInfo.SysChangeNickNameError)
    end
end

--检查要修改的昵称
function PlayerInfoSysModel:C2S_RequestCheckNickName(name)
    this.SendMessage(MSG_ID.MSG_USER_CHECK_NICKNAME, { nickname = name })
end

function PlayerInfoSysModel.S2C_ReceiveCheckNickName(code, data)
    -- log.log("个人信息 协议 2021", code ,data)
    if code == RET.RET_SUCCESS then
        sysCheckNickName = data.nickname
        Event.Brocast(NotifyName.PlayerInfo.SysCheckChangeNickName, true)
        this.ChangeNickNameNextUnix(data.nextCanChangeUnix)
    else
        sysCheckNickName = ""
        Event.Brocast(NotifyName.PlayerInfo.SysCheckChangeNickName, false)
    end
end

function PlayerInfoSysModel.GetCheckNickName()
    return sysCheckNickName
end

--昵称

--昵称修改时间

--修改下次昵称时间
function PlayerInfoSysModel.ChangeNickNameNextUnix(unix)
    nextCanChangeNickNameUnix = unix
    -- log.log("个人信息 修改下次昵称时间" , unix)
end

--判断可以修改昵称
function PlayerInfoSysModel.CheckCanChangeNickName()
    return os.time() > nextCanChangeNickNameUnix
end

--是否修改过昵称
function PlayerInfoSysModel.CheckHasChangeNickName()
    if not nextCanChangeNickNameUnix then
        return false
    end

    --大于 20230301的时间戳就是改过
    local date = os.date("*t", nextCanChangeNickNameUnix)
    if date then
        if date.year > 2023 then
            return true
        end
        if date.month > 3 then
            return true
        end
        if date.month > 1 then
            return true
        end
    end
    return false
end

--昵称修改时间

-- 通过传入头像参数修改头像
-- avatar :头像参数
-- imageHead : 头像
function PlayerInfoSysModel:LoadTargetHeadSprite(avatar, imageHead)
    if not imageHead or fun.is_null(imageHead) then
        log.log("错误缺少接收头像UI")
        return
    end

    if this:CheckIsFbHead(avatar) then
        if this:CheckFaceBookAvatarResourceExist() then
            --log.log("个人信息 加载FB头像")
            this:LoadFbHeadSprite(imageHead)
            return
        else
            --使用FB头像 却没有资源 强制换成其他头像
            --log.log("个人信息 加载fb头像丢失 替换成其他资源")
            avatar = this:MissLocalFBResourceToReplace()
        end
    end

    avatar = fun.get_strNoEmpty(avatar, "xxl_head016")
    --log.log("个人信息 get_strNoEmpty   "..avatar)
    local avatarName = this:GetConfigAvatarIconName(avatar)
    --log.log("个人信息 2get_strNoEmpty   "..avatarName)
    this:LoadTargetHeadSpriteByName(avatarName, imageHead)
end

-- 通过传入头像参数修改头像
-- avatar :头像参数
-- imageHead : 头像
function PlayerInfoSysModel:LoadTargetHeadSpriteByName(avatarName, imageHead)
    if this:CheckAvatarIsNetUrl(avatarName) then
        log.log("是特殊头像 替换默认的")
        --是网络地址头像 前端使用默认头像
        avatarName = missLocalFBResourceToReplaceName
    end

    -- local sprite = AtlasManager:GetSpriteByName("HeadAtlas", avatarName)
    AtlasManager:LoadImageAsync("HeadAtlas", avatarName, function(spriteAtlas, sprite)
        if sprite then
            imageHead.sprite = sprite
        else
            fun.set_active(imageHead, false)
        end
    end)
    -- if sprite then
    --     imageHead.sprite = sprite
    -- else
    --     fun.set_active(imageHead, false)
    -- end
end

--frame             :头像框参数
--imageFrame        :接收UI
--isIgnoreDisable   :忽略默认隐藏效果
function PlayerInfoSysModel:LoadTargetFrameSprite(frame, imageFrame, isIgnoreDisable)
    if not imageFrame or fun.is_null(imageFrame) then
        log.log("错误缺少接收头像框UI")
        return
    end

    local frameName = ""
    if not isIgnoreDisable and this:GetConfigFrameIsDefault(frame) then
        --默认头像框
        frameName = "SystemFramesTop"
    else
        frameName = this:GetConfigFrameIconName(frame)
    end

    this:LoadTargetFrameSpriteByName(frameName, imageFrame)
end

--修改头像框
--frameName 头像框资源名字
--imageFrame 接收UI
function PlayerInfoSysModel:LoadTargetFrameSpriteByName(frameName, imageFrame)
    local spriteRes = AtlasManager:GetSpriteByName("HeadIconFrameAtlas", frameName)
    imageFrame.sprite = spriteRes
end

--机器人头像
function PlayerInfoSysModel:LoadRobotTargetHeadSprite(robotNameOrIndexOrUid, imageHead)
    local headName = Csv.GetData("robot_name", robotNameOrIndexOrUid, "icon")
    this:LoadTargetHeadSpriteByName(headName, imageHead)
end

--机器人头像框
function PlayerInfoSysModel:LoadRobotTargetFrameSprite(robotNameOrIndexOrUid, imageFrame)
    local frameName = Csv.GetData("robot_name", robotNameOrIndexOrUid, "edge")
    --log.log("个人信息 检查头像框对应" , robotNameOrIndexOrUid , frameName)
    this:LoadTargetFrameSpriteByName(frameName, imageFrame)
end

--玩家自己的头像
function PlayerInfoSysModel:LoadOwnHeadSprite(imageHead)
    local useingHeadIconId = this.GetUsingHeadIconID()
    log.r("个人信息 加载自己头像" .. useingHeadIconId)
    this:LoadTargetHeadSprite(useingHeadIconId, imageHead)
end

--玩家自己的头像框
function PlayerInfoSysModel:LoadOwnFrameSprite(imageFrame)
    local useingHeadIconId = this.GetUsingFrameIconID()
    this:LoadTargetFrameSprite(useingHeadIconId, imageFrame)
end

function PlayerInfoSysModel:LoadFbHeadSprite(imageHead)
    this:LoadFbHeadSpriteFunc(function(sprite, param)
        if sprite and imageHead and not fun.is_null(imageHead) then
            imageHead.sprite = sprite
        end
    end)
end

function PlayerInfoSysModel:LoadFbHeadSpriteFunc(func)
    log.log("触发FB头像加载")
    SDK.facebook:RequestUserPhoto(func)
end

--有头像/头像框解锁了
function PlayerInfoSysModel:CheckHasUnlockNew()
    -- log.log("个人头像调整 检查新的" , newFrameOrAvatarList)
    for k, v in pairs(newFrameOrAvatarList) do
        if v then
            return true
        end
    end
    return false
end

--获得一个解锁数据
function PlayerInfoSysModel:GetUnlockIconData(index)
    if newFrameOrAvatarList and newFrameOrAvatarList[index] then
        return newFrameOrAvatarList[index]
    end
    return nil
end

--清除上次已经解锁过的
function PlayerInfoSysModel:ClearHasUnlockNew()
    newFrameOrAvatarList = {}
end

function PlayerInfoSysModel:GetCheckAvatar(checkAvatar, uid)
    local avatarName = ""
    if tonumber(checkAvatar) then
        avatarName = this:GetConfigAvatarIconName(tostring(checkAvatar))
    else
        avatarName = fun.get_strNoEmpty(checkAvatar, Csv.GetData("robot_name", uid, "icon"))
    end
    return fun.get_strNoEmpty(avatarName, "xxl_head016")
end

function PlayerInfoSysModel:GetCheckFrame(checkFrame, uid)
    local frameName = ""
    if tonumber(checkFrame) then
        frameName = this:GetConfigFrameIconName(tostring(checkFrame))
    else
        frameName = fun.get_strNoEmpty(checkFrame, Csv.GetData("robot_name", uid, "edge"))
    end
    return fun.get_strNoEmpty(frameName, "SystemFramesTop")
end

function PlayerInfoSysModel:CheckAvatarIsNetUrl(avatar)
    local strBase = "https://"
    local findStart, findEnd = string.find(avatar, strBase)
    if findStart and findEnd then
        return true
    end
    return false
end

this.MsgIdList =
{
    { msgid = MSG_ID.MSG_PERSON_PAGE,         func = this.S2C_ReceivePersoPage },
    { msgid = MSG_ID.MSG_AVATAR_LIST,         func = this.S2C_ReceiveAvatarList },
    { msgid = MSG_ID.MSG_AVATAR_FRAME_LIST,   func = this.S2C_ReceiveAvatarFrameList },
    { msgid = MSG_ID.MSG_AVATAR_NEW,          func = this.S2C_ReceiveAvatarNew },
    { msgid = MSG_ID.MSG_AVATAR_FRAME_NEW,    func = this.S2C_ReceiveAvatarFrameNew },
    { msgid = MSG_ID.MSG_USER_AVATAR,         func = this.S2C_ReceiveChangeHeadIcon },
    { msgid = MSG_ID.MSG_USER_AVATAR_FRAME,   func = this.S2C_ReceiveChangeHeadIconFrame },
    { msgid = MSG_ID.MSG_USER_NICKNAME,       func = this.S2C_ReceiveChangeNickName },
    { msgid = MSG_ID.MSG_USER_CHECK_NICKNAME, func = this.S2C_ReceiveCheckNickName },




}




return this
