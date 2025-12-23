
local SelectBattleConfigRewardsItem = BaseView:New("SelectBattleConfigRewardsItem")
local this = SelectBattleConfigRewardsItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = 
{
    "icon",
    "anim",
    "textNum",
}

function SelectBattleConfigRewardsItem:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function SelectBattleConfigRewardsItem:Awake()
    self:on_init()
end

function SelectBattleConfigRewardsItem:OnEnable()
    self._init = true
    if self.cacheData and self.rewardType and self.cardNum then
        self:SetReward(self.rewardType , self.cacheData , self.cardNum,self.betIndex)
    end
end

function SelectBattleConfigRewardsItem:OnDisable()
    self._init = nil
    self.cacheData = nil
    self.rewardType = nil
    self.cardNum = nil
    self.betIndex = nil
end

function SelectBattleConfigRewardsItem:SetReward(rewardType , data, cardNum,betIndex)
    self.cacheData = data
    self.rewardType = rewardType
    self.cardNum = cardNum
    self.betIndex = betIndex
    if self._init then
        --log.log("刷新的配置奖励 ", rewardType , data)
        self:RefreshItem()
        self:ShowItemAnim(data,true, cardNum,betIndex)
    end
end

function SelectBattleConfigRewardsItem:RefreshItem()
end

function SelectBattleConfigRewardsItem:CheckValueChangeState(data,isInitItem)
end

function SelectBattleConfigRewardsItem:RefreshItemData(data,cardNum,betIndex)
    self:ShowItemAnim(data,false, cardNum , betIndex)
    self:ShowValueChange(cardNum,betIndex)
    self.cacheData = data
    self.cardNum = cardNum
    self.betIndex = betIndex
    self:RefreshItem()
end

function SelectBattleConfigRewardsItem:ShowValueChange()
end

function SelectBattleConfigRewardsItem:CheckBanItem()
end

function SelectBattleConfigRewardsItem:ShowItemAnim(data,isInitItem,cardNum,betIndex)
    local changeState , rewardNum = self:CheckValueChangeState(data,isInitItem,cardNum,betIndex)

    if changeState == BingoBangEntry.selectBattleConfigItemValueChange.InitItem then
        if rewardNum <= 0 then
            Util.SetUIImageGray(self.icon.gameObject, true)
            fun.play_animator(self.anim , "zhihui" , true)
        else
            fun.play_animator(self.anim , "subtract" , true)
        end        
    elseif changeState == BingoBangEntry.selectBattleConfigItemValueChange.Decrease then
        --减少
        if rewardNum <= 0 then
            Util.SetUIImageGray(self.icon.gameObject, true)
            fun.play_animator(self.anim , "zhihui" , true)
        else
            fun.play_animator(self.anim , "subtract" , true)
        end
    elseif changeState == BingoBangEntry.selectBattleConfigItemValueChange.Increase then
        --增加 
        Util.SetUIImageGray(self.icon.gameObject, false)
        fun.play_animator(self.anim , "add" , true)
    else
        --数量不变
    end
end

function SelectBattleConfigRewardsItem:CheckItemRewardEmpty()

end

function SelectBattleConfigRewardsItem:GetRewardType()
    return self.rewardType
end

function SelectBattleConfigRewardsItem:GetPosition()
    if self.go then
        return self.go.transform.position
    end
    return nil
end


return this
