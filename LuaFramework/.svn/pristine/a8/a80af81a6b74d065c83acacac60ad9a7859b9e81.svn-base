local FBFansModel = BaseModel:New("FBFansModel")
local this = FBFansModel

function FBFansModel:SetLoginData(data)
    --是否已关注fb
    this.isFollowedFaceBook = data.hadFollowFacebook
    --当天是否已展示follow-fb页面
    this.hadFirstShowFollowFacebook = data.hadFirstShowFollowFacebook
    --是否已领取首次展示follow-fb奖励
    this.firstShowFollowFacebookRewarded = data.firstShowFollowFacebookRewarded

    --是否充值过
    this.payType = data.roleInfo and data.roleInfo.userPayType or 0
end

---粉丝是否已经解锁
function FBFansModel:CheckFansPageUnlock()
    if not this.payType then
        return false
    end
    if this.payType > 0 then
        return true
    end

    local cfg = Csv.GetData("control", 150, "content")
    local openLevel = (cfg and cfg [1]) and cfg[1][1]
    local myLevel = ModelList.PlayerInfoModel:GetLevel()
    return myLevel >= openLevel
end

---检查是否关注后没有领取奖励
function FBFansModel:CheckFollowReward()
    if this.isFollowedFaceBook ~= nil then
        return this.isFollowedFaceBook and not self:IsClaimedFbFollowReward()
    else
        local cache = self:GetFromPrefs("need_follow_reward", 0)
        return cache == 1 and not self:IsClaimedFbFollowReward()
    end
end

---检查是否已经领取了粉丝页关注奖励
function FBFansModel:IsClaimedFbFollowReward()
    return this.firstShowFollowFacebookRewarded
end

---角色信息更新之后，判断是否完成首充
function FBFansModel:UpdateRolePayType(roleInfo)
    --if this.payType == 0 then
    --    if roleInfo.userPayType and roleInfo.userPayType > 0 then
    --        this.payType = roleInfo.userPayType
    --        if not this.firstShowFollowFacebookRewarded then
    --            --- 2024/1/23 商城内不要弹出粉丝页
    --            if (ViewList.ShopView and ViewList.ShopView.go and fun.get_active_self(ViewList.ShopView.go) ) then
    --                return
    --            end
    --            Facade.SendNotification(NotifyName.ShowUI, ViewList.FansPageView, function()
    --                self:SaveInPrefs("last_open_fans_page_time", os.time())
    --            end)
    --        end
    --    end
    --end
end

---持久化存储，每个用户单独存储
function FBFansModel:SaveInPrefs(key, value)
    local userInfo = ModelList.PlayerInfoModel:GetUserInfo()
    local userID = userInfo.uid
    key = string.format("%s-%s", key, userID)
    fun.save_int(key, value)
end
function FBFansModel:GetFromPrefs(key, defaultValue)
    local userInfo = ModelList.PlayerInfoModel:GetUserInfo()
    local userID = userInfo.uid
    key = string.format("%s-%s", key, userID)
    local ret = fun.get_int(key, defaultValue)
    return ret
end

-----------------SerVer Request--------------------------------------------------------------------------

--通知领取关注奖励
function FBFansModel:ReqFbFollowReward()
    this.SendMessage(MSG_ID.MSG_REWRD_AFTER_SHOW_FOLLOW, { })
end
--领取关注奖励成功
function FBFansModel.ReceiveFbFollowReward(code, data)
    if code == RET.RET_SUCCESS then
        this.firstShowFollowFacebookRewarded = true
        Facade.SendNotification(NotifyName.FBFansPage.ReceiveFbFollowReward, data)
    end
end

--通知服务器关注了FB
function FBFansModel:ReqFollowFb()
    local time = os.time()
    this.SendMessage(MSG_ID.MSG_FOLLOW_FB, { firstShowFollowFacebookUnix = time })
end
--关注FB服务端回调
function FBFansModel.ReceiveFollowFB(code, data)
    if code == RET.RET_SUCCESS then
        this.isFollowedFaceBook = true
    end
end

--通知服务器关展示了粉丝页
function FBFansModel:ReqShowFollow()
    --local time = os.time()
    --this.SendMessage(MSG_ID.MSG_SHOW_FOLLOW, {})
end

--------------------------------------------------------------------------------------------------------

this.MsgIdList =
{
    {msgid = MSG_ID.MSG_REWRD_AFTER_SHOW_FOLLOW,func = this.ReceiveFbFollowReward},
    --{msgid = MSG_ID.MSG_SHOW_FOLLOW,func = this.ReceiveShowFollow},
    {msgid = MSG_ID.MSG_FOLLOW_FB,func = this.ReceiveFollowFB},
}

return this