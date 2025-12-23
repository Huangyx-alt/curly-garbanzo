local SeasonCardGroupItem = require "View/SeasonCard/SeasonCardGroupItem"
local Toolkit = require "View/SeasonCard/Toolkit"
local SeasonCardStageRewardView = BaseDialogView:New('SeasonCardStageRewardView')
local this = SeasonCardStageRewardView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "btn_close",
    "txtDescription",
    "cardGroup",
    "rewardPanel",
    "rewardItem",
    "btn_collect",
    "AlbumTitle",
    "anima",
    "imgTitle1",
    "imgTitle2",
}

function SeasonCardStageRewardView:Awake()
end

function SeasonCardStageRewardView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
    self.rewardItems = {}
end

function SeasonCardStageRewardView:on_after_bind_ref()
    self:InitView()
end

function SeasonCardStageRewardView:SetData(data)
    self.data = data
end

function SeasonCardStageRewardView:InitView()
    fun.set_active(self.btn_close, false)
    fun.set_active(self.rewardItem, false)
    fun.set_active(self.cardGroup, false)
    fun.set_active(self.AlbumTitle, false)
    fun.set_active(self.imgTitle1, false)
    fun.set_active(self.imgTitle2, false)

    if self.data then
        if self.data.rewardType == ModelList.SeasonCardModel.Consts.RewardType.album then
            fun.set_active(self.imgTitle2, true)
            fun.set_active(self.AlbumTitle, true)
            --self.txtDescription.text = ""
            AnimatorPlayHelper.Play(self.anima, {"start2", "SeasonCardStageRewardView_start2"}, false, function() end)
        elseif self.data.rewardType == ModelList.SeasonCardModel.Consts.RewardType.group then
            self:InitGroupItem(self.data.groupId, self.data.seasonId)
            --self.txtDescription.text = ""
            AnimatorPlayHelper.Play(self.anima, {"start", "SeasonCardStageRewardView_start"}, false, function() end)
            fun.set_active(self.imgTitle1, true)
        end
        self:InitReward()
        UISound.play("card_complete")
    end
end

function SeasonCardStageRewardView:InitGroupItem(groupId, seasonId)
    local itemGo = self.cardGroup
    local fixedData = ModelList.SeasonCardModel:GetGroupInfo(groupId, seasonId)
    local data = {index = 1, parent = self, groupId = groupId, seasonId = seasonId}
    local item = SeasonCardGroupItem:New()
    item:SetData(data)
    item:SetOnlyShowBasicInfo()
    item:SkipLoadShow(itemGo)
    item:SetClickEnable(false)
    fun.set_active(itemGo, true)
    item:SetNewIconVisible(false)
    item:SetGiftIconVisible(false)
    item:SetLockIconVisible(false)

    return item
end

function SeasonCardStageRewardView:InitReward()
    fun.clear_all_child(self.rewardPanel)
    local rewards = self.data.reward
    for i, v in ipairs(rewards) do
        local item = self:CreateRewardItem(v)
        fun.set_parent(item.go, self.rewardPanel, true)
        table.insert(self.rewardItems, item)
    end
end

function SeasonCardStageRewardView:CreateRewardItem(rewardData)
    local go = fun.get_instance(self.rewardItem)
    local ref = fun.get_component(go, fun.REFER)
    local icon = ref:Get("icon")
    local value = ref:Get("value")
    -- local id = rewardData[1]
    -- local count = rewardData[2]
    local id = rewardData.id
    local count = rewardData.value
    local iconName = Csv.GetItemOrResource(id, "more_icon")
    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
    --value.text = fun.format_money(count)
    value.text = Toolkit.FormatReward(count)
    fun.set_active(go, true)
    local item = {}
    item.id = id
    item.count = count
    item.go = go
    return item
end

function SeasonCardStageRewardView:CollectRewards()
    if #self.rewardItems > 0 then
        local delay = 0
        local coroutine_fun = nil
        for index, value in ipairs(self.rewardItems) do
            coroutine_fun = function()
                delay = delay + 0.2
                coroutine.wait(delay)
                local pos = fun.get_gameobject_pos(value.go)
                local itemId = value.id
                local callback = function()
                    if index == #self.rewardItems then
                        Event.Brocast(EventName.Event_currency_change)
                        self:MutualTaskFinish()
                        self:CloseSelf()
                    end
                end
                Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts, pos, itemId, callback, nil, true)
            end
            coroutine.resume(coroutine.create(coroutine_fun))
        end
    else
        self:MutualTaskFinish()
        self:CloseSelf()
    end
end

function SeasonCardStageRewardView:OnDisable()
    Facade.RemoveViewEnhance(self)
end

function SeasonCardStageRewardView:CloseSelf()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"end", "SeasonCardStageRewardView_end"}, false, function()
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.HideDialog, self)
            if self.data and self.data.closeCallback then
                self.data.closeCallback()
            end
        end)
    end

    self:DoMutualTask(task)
end

function SeasonCardStageRewardView:on_btn_close_click()
    --self:CloseSelf()
end

function SeasonCardStageRewardView:on_btn_collect_click()
    local task = function()
        self:CollectRewards()
    end

    self:DoMutualTask(task)
end

function SeasonCardStageRewardView:OnForceExit(params)
    self:CloseSelf()
end

--设置消息通知
this.NotifyEnhanceList =
{
    --{notifyName = NotifyName.SeasonCard.ShowExchangeBoxBubble, func = this.ShowBubble},
    {notifyName = NotifyName.SeasonCard.ForceExit, func = this.OnForceExit},
}

return this