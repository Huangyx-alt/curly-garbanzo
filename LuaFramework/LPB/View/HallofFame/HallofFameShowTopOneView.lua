local HallofFameShowTopOneView = {}
local topOneUi = nil
local textScore = nil
local Text_userName = nil
local Reward_item = nil
local Content = nil
local imgHead = nil
local imageFrame = nil
local HallofFameGoldRank2ViewShowza = nil


local topOneData = nil
local rewardItemList = {}
local hasBindUI = false

local rewardView = require("View/CommonView/CollectRewardsItem")

local flyScoreView = nil
local flyScore = nil

function HallofFameShowTopOneView:OnDestroy()
    topOneUi = nil
    textScore = nil
    Text_userName = nil
    Reward_item = nil
    Content = nil
    topOneData = nil
    imgHead = nil
    imageFrame = nil
    HallofFameGoldRank2ViewShowza = nil
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

function HallofFameShowTopOneView:BindUI()
    local ref = fun.get_component(topOneUi, fun.REFER)
    textScore = ref:Get("textScore")
    imgHead = ref:Get("imgHead")
    imageFrame = ref:Get("imageFrame")
    Text_userName = ref:Get("Text_userName")
    Reward_item = ref:Get("Reward_item")
    Content = ref:Get("Content")
    HallofFameGoldRank2ViewShowza = ref:Get("HallofFameGoldRank2ViewShowza") or nil
    hasBindUI = true
end

function HallofFameShowTopOneView:OnEnable(params)
    topOneUi = params.topOneUi
    topOneData = params.topOneData
    self:BindUI()
    self:InitView()
    self:CheckSprintBuff()
end

function HallofFameShowTopOneView:InitHeadIcon()
    local myUid = ModelList.PlayerInfoModel:GetUid()
    local model = ModelList.PlayerInfoSysModel
    if myUid == tonumber(topOneData.uid) then
        model:LoadOwnHeadSprite(imgHead)
    else
        local useAvatarName = model:GetCheckAvatar(topOneData.avatar , topOneData.uid)
        model:LoadTargetHeadSpriteByName(useAvatarName ,imgHead)
    end
end

function HallofFameShowTopOneView:InitFrameIcon()
    local myUid = ModelList.PlayerInfoModel:GetUid()
    local model = ModelList.PlayerInfoSysModel
    if myUid == tonumber(topOneData.uid) then
        model:LoadOwnFrameSprite(imageFrame)
    else
        local useFrameName = model:GetCheckFrame(topOneData.frame , topOneData.uid)
        model:LoadTargetFrameSpriteByName(useFrameName , imageFrame)
    end
end

function HallofFameShowTopOneView:InitView()
    self:InitReward()
    self:InitHeadIcon()
    self:InitFrameIcon()
    self:InitName()
    self:InitScore()
    self:InitSprintBuff()
end

function HallofFameShowTopOneView:InitScore()
    textScore.text = fun.formatNum(topOneData.score) or 0
end

function HallofFameShowTopOneView:InitName()
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

function HallofFameShowTopOneView:InitReward()
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

function HallofFameShowTopOneView:HideRewardItemView()
    for k , v in pairs(rewardItemList) do
        fun.set_active(v.go, false)
    end
    rewardItemList = {}
end

--爬升到第一名
function HallofFameShowTopOneView:ClimbTopOne(newPlayerData)
    self:HideRewardItemView()
    topOneData = newPlayerData
    self:InitView()
    --播放特效
end

--替换第一名
function HallofFameShowTopOneView:ReplaceTopOne(newPlayerData)
    self:HideRewardItemView()
    topOneData = newPlayerData
    self:InitView()
end

--是否绑定了UI
function HallofFameShowTopOneView:IsBingUI()
    return hasBindUI
end

function HallofFameShowTopOneView:FlyScore(callback,targetScore)
    if flyScoreView == nil then
        local flyScoreViewCode = require "View/Tournament/TournamentSettleFlyScoreView"
        flyScoreView = flyScoreViewCode:New()
        Cache.load_prefabs(AssetList["HallofFameRank2Viewgo"],"HallofFameRank2Viewgo",function(obj)
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

function HallofFameShowTopOneView:SetParent(parent)
    self.parent = parent
end

function HallofFameShowTopOneView:InitSprintBuff()
    local flag = self.parent and self.parent.HallofFameBuffFlag
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

function HallofFameShowTopOneView:CheckSprintBuff()
    if fun.is_null(self.buffFlag) then
        return
    end

    if self:HasSprintBuff() then
        fun.set_active(self.buffFlag, true)
    else
        fun.set_active(self.buffFlag, false)
    end
end

function HallofFameShowTopOneView:HasSprintBuff()
    if not topOneData or not topOneData.buffs then
        return false
    end

    for idx , buff in ipairs(topOneData.buffs) do
        if buff.id == 33 then
            return true
        end
    end

    return false
end

function HallofFameShowTopOneView:OnBtnTournamentBuffClick(target)
    if self:IsMyRank() then
        local bubble = ViewList.BubbleTipView and ViewList.BubbleTipView.go
        if bubble and bubble.gameObject.activeSelf then
            return
        end
        local posParams = self:GetBuffPosParams()
        local des_text = ModelList.HallofFameModel:GetSprintBuffDes()
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

function HallofFameShowTopOneView:IsMyRank()
    return topOneData.uid == ModelList.PlayerInfoModel:GetUid()
end

function HallofFameShowTopOneView:GetBuffPosParams()
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

return HallofFameShowTopOneView