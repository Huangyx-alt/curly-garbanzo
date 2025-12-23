local TournamentShowTopOneView = {}
local topOneUi = nil
local textScore = nil
local Text_userName = nil
local Reward_item = nil
local Content = nil
local imgHead = nil
local imageFrame = nil
local TournamentGoldSettleViewShowza = nil


local topOneData = nil
local rewardItemList = {}
local hasBindUI = false

local rewardView = require("View/CommonView/CollectRewardsItem")

local flyScoreView = nil
local flyScore = nil

function TournamentShowTopOneView:OnDestroy()
    topOneUi = nil
    textScore = nil
    Text_userName = nil
    Reward_item = nil
    Content = nil
    topOneData = nil
    imgHead = nil
    imageFrame = nil
    TournamentGoldSettleViewShowza = nil
    hasBindUI = false
    if flyScoreView then
        fun.set_active(flyScoreView.go,false)
        flyScoreView = nil
    end
    flyScore = nil

    if not fun.is_null(self.sprintBuffBtn) then
        self.parent.luabehaviour:RemoveClick(self.sprintBuffBtn)
        self.sprintBuffBtn = nil
    end
end

function TournamentShowTopOneView:BindUI()
    local ref = fun.get_component(topOneUi, fun.REFER)
    textScore = ref:Get("textScore")
    imgHead = ref:Get("imgHead")
    imageFrame = ref:Get("imageFrame")
    Text_userName = ref:Get("Text_userName")
    Reward_item = ref:Get("Reward_item")
    Content = ref:Get("Content")
    TournamentGoldSettleViewShowza = ref:Get("TournamentGoldSettleViewShowza") or nil
    hasBindUI = true
end

function TournamentShowTopOneView:OnEnable(params)
    topOneUi = params.topOneUi
    topOneData = params.topOneData
    self:BindUI()
    self:InitView()
    self:CheckSprintBuff()
end

function TournamentShowTopOneView:InitHeadIcon()
    local myUid = ModelList.PlayerInfoModel:GetUid()
    local model = ModelList.PlayerInfoSysModel
    if myUid == tonumber(topOneData.uid) then
        model:LoadOwnHeadSprite(imgHead)
    else
        local useAvatarName = model:GetCheckAvatar(topOneData.avatar , topOneData.uid)
        model:LoadTargetHeadSpriteByName(useAvatarName ,imgHead)
    end
end

function TournamentShowTopOneView:InitFrameIcon()
    local myUid = ModelList.PlayerInfoModel:GetUid()
    local model = ModelList.PlayerInfoSysModel
    if myUid == tonumber(topOneData.uid) then
        model:LoadOwnFrameSprite(imageFrame)
    else
        local useFrameName = model:GetCheckFrame(topOneData.frame , topOneData.uid)
        model:LoadTargetFrameSpriteByName(useFrameName , imageFrame)
    end
end

function TournamentShowTopOneView:InitView()
    self:InitReward()
    self:InitHeadIcon()
    self:InitFrameIcon()
    self:InitName()
    self:InitScore()
    self:InitSprintBuff()
end

function TournamentShowTopOneView:InitScore()
    textScore.text = fun.formatNum(topOneData.score) or 0
end

function TournamentShowTopOneView:InitName()
    if topOneData.nickname == nil or topOneData.nickname == "" then
        local myUid = ModelList.PlayerInfoModel.GetUid()
        if myUid == topOneData.uid then
            Text_userName.text = string.format("User_%s",topOneData.uid)
        else
            local robotName = Csv.GetData("robot_name",tonumber(topOneData.uid),"name")
            Text_userName.text = robotName
        end
    else
        Text_userName.text = topOneData.nickname
    end

end

function TournamentShowTopOneView:InitReward()
    if not topOneData or not topOneData.reward then
        return
    end
    
    for k ,v in pairs(topOneData.reward) do
        local go = fun.get_instance(Reward_item,Content)
        local item = rewardView:New()
        item:SetReward(v)
        item:SkipLoadShow(go)
        fun.set_active(go,true)
        table.insert(rewardItemList , item)
    end
end

function TournamentShowTopOneView:HideRewardItemView()
    for k , v in pairs(rewardItemList) do
        fun.set_active(v.go, false)
    end
    rewardItemList = {}
end

--爬升到第一名
function TournamentShowTopOneView:ClimbTopOne(newPlayerData)
    self:HideRewardItemView()
    topOneData = newPlayerData
    self:InitView()
    --播放特效
end

--替换第一名
function TournamentShowTopOneView:ReplaceTopOne(newPlayerData)
    self:HideRewardItemView()
    topOneData = newPlayerData
    self:InitView()
end

--是否绑定了UI
function TournamentShowTopOneView:IsBingUI()
    return hasBindUI
end

function TournamentShowTopOneView:FlyScore(callback,targetScore)
    if flyScoreView == nil then
        local flyScoreViewCode = require "View/Tournament/TournamentSettleFlyScoreView"
        flyScoreView = flyScoreViewCode:New()
        Cache.load_prefabs(AssetList["TournamentSettleViewgo"],"TournamentSettleViewgo",function(obj)
            if obj then
                flyScore = fun.get_instance(obj,topOneUi)
                fun.set_rect_anchored_position(flyScore,0,0)
                flyScoreView:SkipLoadShow( flyScore,true)
                flyScoreView:PlayFlyScore(function()
                    Anim.do_smooth_int2(textScore,topOneData.score,targetScore,0.5,DG.Tweening.Ease.InFlash,nil,function()
                        if callback then
                            callback()
                        end
                        topOneData.score = targetScore
                    end)
                end,math.max(0,targetScore - topOneData.score))
            end
        end)
    else
        flyScoreView:PlayFlyScore(function()
            Anim.do_smooth_int2(textScore,topOneData.score,targetScore,0.5,DG.Tweening.Ease.InFlash,nil,function()
                if callback then
                    callback()
                end
                topOneData.score = targetScore
            end)
        end,math.max(0,targetScore - topOneData.score))
    end
end

function TournamentShowTopOneView:SetParent(parent)
    self.parent = parent
end

function TournamentShowTopOneView:InitSprintBuff()
    local flag = self.parent and self.parent.TournamentSprintBuffFlag
    if not flag then
        return
    end
    local posParams = self:GetBuffPosParams()
    local target = fun.find_child(topOneUi, "score/trophy") or topOneUi
    --local flagGo = fun.get_instance(flag, parent)
    local flagGo = fun.get_instance(flag, topOneUi)
    local pos = fun.get_gameobject_pos(target, false)
    fun.set_gameobject_pos(flagGo, pos.x, pos.y, 0, false)
    pos = fun.get_gameobject_pos(flagGo, true)
    fun.set_gameobject_pos(flagGo, pos.x + (posParams.buffX or 0), pos.y + (posParams.buffY or 0), 0, true)
    fun.set_active(flagGo, true)
    local ref = fun.get_component(flagGo, fun.REFER)
    local btn = ref:Get("btn")
    self.parent.luabehaviour:AddClick(btn, function()
        self:OnBtnTournamentBuffClick(btn)
    end)
    self.sprintBuffBtn = btn
    self.buffFlag = flagGo
    fun.set_active(self.buffFlag, false)
end

function TournamentShowTopOneView:CheckSprintBuff()
    if fun.is_null(self.buffFlag) then
        return
    end

    if self:HasSprintBuff() then
        fun.set_active(self.buffFlag, true)
    else
        fun.set_active(self.buffFlag, false)
    end
end

function TournamentShowTopOneView:HasSprintBuff()
    --if true then return true end --test
    if not topOneData or not topOneData.buffs then
        return false
    end

    local sprintBuffIds = ModelList.TournamentModel:GetSprintBuffIds()
    for key, buffId in ipairs(sprintBuffIds) do
        for idx , buff in ipairs(topOneData.buffs) do
            if buff.id == buffId then
                return true
            end
        end
    end

    return false
end

function TournamentShowTopOneView:OnBtnTournamentBuffClick(target)
    if self:IsMyRank() then
        local bubble = ViewList.BubbleTipView and ViewList.BubbleTipView.go
        if bubble and bubble.gameObject.activeSelf then
            return
        end
        local posParams = self:GetBuffPosParams()
        local des_text = ModelList.TournamentModel:GetSprintBuffDes()
        local ArrowDirection = ViewList.BubbleTipView.ArrowDirection
        local params = {
            pos = target.transform.position,
            dir = ArrowDirection.bottom,
            text = des_text,
            offset = Vector3.New(posParams.bubbleX or 0, posParams.bubbleY or 0, 0),
            exclude = {target},
            arrowOffset = posParams.arrowOffset or 0,
        }
        Facade.SendNotification(NotifyName.ShowUI, ViewList.BubbleTipView, nil, false, params)
    end
end

function TournamentShowTopOneView:IsMyRank()
    return topOneData.uid == ModelList.PlayerInfoModel:GetUid()
end

function TournamentShowTopOneView:GetBuffPosParams()
    local params = {}
    if self.parent.viewName == "TournamentBlackGoldView" then
        params.buffX = 20
        params.buffY = 20
        params.bubbleX = -240
        params.bubbleY = 90
        params.arrowOffset = 240
    elseif self.parent.viewName == "TournamentBlackGoldSettleView" then
        params.buffX = 20
        params.buffY = 20
        params.bubbleX = -240
        params.bubbleY = 90
        params.arrowOffset = 240
    end
    return params
end

return TournamentShowTopOneView