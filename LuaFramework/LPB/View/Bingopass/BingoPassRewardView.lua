
local BingoPassRewardsOriginalState = require "View/Bingopass/states/BingoPassRewardsOriginalState"
local BingoPassRewardsExtraState = require "View/Bingopass/states/BingoPassRewardsExtraState"
local BingoPassRewardsStiffState = require "View/Bingopass/states/BingoPassRewardsStiffState"
local RewardItemView = require("View/CommonView/CollectRewardsItem")
local BingoPassRewardView = BaseView:New("BingoPassRewardView")
local this = BingoPassRewardView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "btn_activate",
    "btn_collect",
    "txt_description",
    "item_template",
    "scroll_rect1",
    "scroll_rect2",
    "anima",
}

local rewards_item = nil
local isInit = nil
local rewardItemsCache1 = nil
local rewardItemsCache2 = nil
local closeCallback = nil
local buySucceed = nil

function BingoPassRewardView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("BingoPassRewardView",self,{
        BingoPassRewardsOriginalState,
        BingoPassRewardsStiffState,
        BingoPassRewardsExtraState
    })
    self._fsm:StartFsm("BingoPassRewardsOriginalState")
end

function BingoPassRewardView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function BingoPassRewardView:Awake(obj)
    self:on_init()
end

function BingoPassRewardView:OnEnable(prams)
    Facade.RegisterView(self)
    self:ClearMutualTask()
    isInit = true
    self:FillData()
    self:ShowRewards()
    self:ShowRewardsExtra()

    self:BuildFsm()
    local task = function()
        self._fsm:GetCurState():PlayEnter(self._fsm,function()
            AnimatorPlayHelper.Play(self.anima, {"efCollectRewardsenter", "BingoPassRewardenter"}, false, function()
                self._fsm:GetCurState():Change2Original(self._fsm)
                self:MutualTaskFinish()
            end)
        end)
    end

    self:DoMutualTask(task)
    UISound.play("kick_reward")
end

function BingoPassRewardView:OnDisable()
    Facade.RemoveView(this)
    self:Close()
    self:DisposeFsm()
end

function BingoPassRewardView:on_close()
    rewards_item = nil
    isInit = nil
    rewardItemsCache1 = nil
    rewardItemsCache2 = nil
    buySucceed = nil
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
    if closeCallback then
        closeCallback()
    end
    closeCallback = nil
end

function BingoPassRewardView:FillData()
    local desc1 = Csv.GetDescription(1090)
    self.txt_description.text = desc1
end

function BingoPassRewardView:SetRewards(rewards)
    rewards_item = rewards
    if isInit then
        self:ShowRewards()
        self:ShowRewardsExtra()
    end
end

function BingoPassRewardView:SetCloseCallback(callback)
    closeCallback = callback
end

function BingoPassRewardView:ShowRewards()
    if rewards_item then
        if rewardItemsCache1 == nil then
            rewardItemsCache1 = {}
        end
        
        local count = fun.get_table_size(rewards_item)
        assert(count > 0,"奖励异常")
        local itemScale = count >= 4 and 0.8 or 1
        for key, value in ipairs(rewards_item) do
            local go = fun.get_instance(self.item_template, self.scroll_rect1)
            if go and not fun.is_null(go) then
                local rewardItem = RewardItemView:New()
                rewardItem:SetReward(value)
                rewardItem:SkipLoadShow(go, true, nil)
                if rewardItemsCache1[key] == nil then
                    table.insert(rewardItemsCache1, rewardItem)
                end
                fun.set_gameobject_scale(go, itemScale, itemScale, itemScale)
            end
        end
        
        --local scrollRect = fun.get_component(self.scroll_rect1.transform.parent.parent, fun.SCROLL_RECT)
        --scrollRect.movementType = UnityEngine.UI.ScrollRect.MovementType.Clamped
        --scrollRect.movementType = UnityEngine.UI.ScrollRect.MovementType.Elastic
        --fun.set_rect_pivot(self.scroll_rect1, 0, 0.5)
        --self.scroll_rect1.padding
        self.scroll_rect1.spacing = count >= 4 and 40 or 90
    end
end

function BingoPassRewardView:ShowRewardsExtra()
    local rewardNow, rewardSoon = ModelList.BingopassModel:GetAllReward(BingoPassPayType.Pay499)
    local rewardItems = {}
    for key, value in pairs(rewardNow) do
        local item = {}
        item.id = key
        item.value = value
        table.insert(rewardItems, item)
    end
    rewardItemsCache2 = {}
    
    local count = GetTableLength(rewardItems)
    local itemScale = count >= 4 and 0.8 or 1
    for key, value in ipairs(rewardItems) do
        local go = fun.get_instance(self.item_template, self.scroll_rect2)
        if go and not fun.is_null(go) then
            local rewardItem = RewardItemView:New()
            rewardItem:SetReward(value)
            rewardItem:SkipLoadShow(go, true, nil)
            table.insert(rewardItemsCache2, rewardItem)
            fun.set_gameobject_scale(go, itemScale, itemScale, itemScale)
        end
    end

    self.scroll_rect2.spacing = count >= 4 and 40 or 90
end

function BingoPassRewardView:on_btn_collect_click()
    local task = function()
        if self and self._fsm then
            self._fsm:GetCurState():CollectReward(self._fsm)
            self:register_invoke(function()
                self:MutualTaskFinish()
            end, 2)
        end
    end
    self:DoMutualTask(task)
end

function BingoPassRewardView:on_btn_activate_click()
    self:ShowRecommendOrPurchase()
end

function BingoPassRewardView:OnCollectReward()
    self._timer = Invoke(function()
        Util.SetImageColorGray(self.btn_collect, false)
        self._fsm:GetCurState():Change2Original(self._fsm)
    end,3)
    Util.SetImageColorGray(self.btn_collect, true)
    self:DoCollectReward()
end

function BingoPassRewardView:ShowRecommendOrPurchase()
    --local level = ModelList.BingopassModel:GetLevel()
    --local targetLevel = Csv.GetControlByName("season_pass_level")[1][1]
    --if level > targetLevel then
        self:ShowPurchase()
    --else
    --    self:ShowRecommend()
    --end
end

function BingoPassRewardView:ShowRecommend()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.BingoPassRecommendView)
    ViewList.BingoPassRecommendView:SetCloseCallback(self.AfterRecommendClose)
end

function BingoPassRewardView:ShowPurchase()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.BingoPassPurchaseView)
    ViewList.BingoPassPurchaseView:SetCloseCallback(self.AfterPurchaseClose)
end

function BingoPassRewardView.AfterRecommendClose(closeMethod)
    if closeMethod == ViewList.BingoPassRecommendView.CloseMethod.normal then
        this:ShowPurchase()
    elseif closeMethod == ViewList.BingoPassRecommendView.CloseMethod.paySucceed then
    end
end

function BingoPassRewardView.AfterPurchaseClose(closeMethod)
    if closeMethod == ViewList.BingoPassPurchaseView.CloseMethod.normal then
        this:on_btn_collect_click()
    elseif closeMethod == ViewList.BingoPassPurchaseView.CloseMethod.paySucceed then
    end
end

function BingoPassRewardView.OnBuyBingoPassSucc()
    buySucceed = true
    this:on_btn_collect_click()
end

function BingoPassRewardView:DoCollectReward()
    local delay = 0
    local coroutine_fun = nil
    local count = 0
    local allReward
    if buySucceed then
        allReward = {}
        fun.merge_array(allReward, rewardItemsCache1, rewardItemsCache2)
    else
        allReward = rewardItemsCache1
    end
    local totalCardPack = {}
    for key, value in ipairs(allReward) do
        if ModelList.SeasonCardModel:IsCardPackage(value:GetRewardItemId()) then
            table.insert(totalCardPack, value:GetRewardItemId())
        end

        coroutine_fun = function()
            delay = delay + 0.2
            count = count + 1
            coroutine.wait(delay)
            Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,value:GetPosition(),value:GetRewardItemId(),function()
                count = math.max(0,count - 1)
                Event.Brocast(EventName.Event_currency_change)
                if 0 == count then
                    AnimatorPlayHelper.Play(self.anima, {"efCollectRewardsexit", "BingoPassRewardexit"}, false, function()
                        Facade.SendNotification(NotifyName.CloseUI, self)
                        if totalCardPack and #totalCardPack > 0 then
                            ModelList.SeasonCardModel:OpenCardPackage({bagIds = totalCardPack})
                        end
                    end)
                end
            end, nil, true)
        end
        coroutine.resume(coroutine.create(coroutine_fun))
    end
    UISound.play("gift_box_open")
end

this.NotifyList = {
    {notifyName = NotifyName.BingoPass.ReceivedViewClose, func = this.OnBuyBingoPassSucc}
}

return this