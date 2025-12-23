MiniGame01CollectRewardType = {collectreward = 1,expelthief = 2}

MiniGame01CollectRewardItem = BaseView:New("MiniGame01CollectRewardItem")
local this = MiniGame01CollectRewardItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "anima",
    "icon",
    "value"
}

function MiniGame01CollectRewardItem:New(data,rewardType)
    local o = {}
    self.__index = self
    o._reward = data
    o._rewardType = rewardType
    setmetatable(o,self)
    return o
end

function MiniGame01CollectRewardItem:Awake()
    self:on_init()
end

function MiniGame01CollectRewardItem:OnEnable()
    if self._reward then
        self.isEnable = true
        local img = Csv.GetItemOrResource(self._reward.id)
        Cache.SetImageSprite("ItemAtlas",img.more_icon or img.icon,self.icon)
        self:PlayResphoneAddReward()
    end
end

function MiniGame01CollectRewardItem:OnDisable()
    self.isEnable = nil
    self._rewardType = nil
end

function MiniGame01CollectRewardItem:IsTheSameReward(rewardId)
    if self._reward then
        return self._reward.id == rewardId
    end
    return false
end

function MiniGame01CollectRewardItem:GetLocalPosition()
    if fun.is_not_null(self.transform) then
        return self.transform.localPosition
    end
    return Vector3.New(0,0,0)
end

function MiniGame01CollectRewardItem:SetLocalPosition(localPosition)
    if fun.is_not_null(self.transform) then
        self.transform.localPosition = localPosition
    end
end

function MiniGame01CollectRewardItem:SetLocalPositionOffset(offset,isTween)
    if fun.is_not_null(self.transform) then
        if isTween then
            local pos = self.transform.localPosition
            Anim.move_ease(self.go,pos.x + offset.x,pos.y,pos.z,0.5,true,DG.Tweening.Ease.InOutSine,nil)
            pos = self.transform.anchoredPosition
            return Vector2.New(pos.x + offset.x,pos.y + offset.y)
        else
            local pos = self.transform.anchoredPosition
            self.transform.anchoredPosition = Vector2.New(pos.x + offset.x,pos.y + offset.y)
            return self.transform.anchoredPosition
        end
    end
    return Vector2.New(0,0)
end

function MiniGame01CollectRewardItem:GetPosition()
    if fun.is_not_null(self.transform) then
        return self.transform.position
    end
    return Vector3.New(0,0,0)
end

function MiniGame01CollectRewardItem:GetRewardItemId()
    if self._reward then
        return self._reward.id
    end
    return 1
end

function MiniGame01CollectRewardItem:PlayResphoneAddReward()
    if self._rewardType == MiniGame01CollectRewardType.collectreward and self.isEnable then
        AnimatorPlayHelper.Play(self.anima,{"up","rewards_up"},false,nil)
        local reward_value = ModelList.MiniGameModel:GetCollectRewardById(self._reward.id,true)
        local doubleReward = ModelList.ItemModel.get_doublehatReward()
        if doubleReward > 0 and reward_value then
            self.value.text = fun.FormatText({id = self._reward.id,value = reward_value * 2 or 0})
        else
            self.value.text = fun.FormatText({id = self._reward.id,value = reward_value or 0})
        end
    elseif self._rewardType == MiniGame01CollectRewardType.expelthief and self.isEnable then
        AnimatorPlayHelper.Play(self.anima,{"idle","property_idle"},false,nil)
        local showReward = self:GetShowRewardData()
        self.value.text = fun.FormatText(showReward)
    else
        local showReward = self:GetShowRewardData()
        self.value.text = fun.FormatText(showReward)    
    end
end

function MiniGame01CollectRewardItem:Tween2MoveHalfUnit(offset)
    if  fun.is_not_null(self.transform) then
        local pos = self.transform.position
        Anim.move_ease(self.go,pos.x + offset,pos.y,pos.z,0.5,false,DG.Tweening.Ease.InOutSine,nil)
    end
end

function MiniGame01CollectRewardItem:PlayRewardsLose(callback)
    AnimatorPlayHelper.Play(self.anima,{"lose","property_lose"},false,function()
        if callback then
            callback()
        end
    end)
end



function MiniGame01CollectRewardItem:GetShowRewardValue(value)
    local doubleReward = ModelList.ItemModel.get_doublehatReward()
    if doubleReward > 0 then
        return value * 2
    else
        return value
    end
end


function MiniGame01CollectRewardItem:GetShowRewardData()
    local doubleReward = ModelList.ItemModel.get_doublehatReward()
    if doubleReward > 0 then
        local showRewardData = DeepCopy(self._reward)
        showRewardData.value = showRewardData.value * 2
        return showRewardData
    end
    return self._reward
end



function MiniGame01CollectRewardItem:UpdateCollectRewardShowDouble()
    self:PlayResphoneAddReward()
end