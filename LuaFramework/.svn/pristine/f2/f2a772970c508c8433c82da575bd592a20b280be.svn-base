local Toolkit = require "View/SeasonCard/Toolkit"
local SeasonCardOpenTreasureBoxView = BaseDialogView:New('SeasonCardOpenTreasureBoxView')
local this = SeasonCardOpenTreasureBoxView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "btn_collect",
    "btn_close",
    "imgPackage",
    "packageRoot",
    "cardsRoot",
    "rewardPanel",
    "rewardItem",
    "anima",
}

function SeasonCardOpenTreasureBoxView:Awake()
end

function SeasonCardOpenTreasureBoxView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
    self.cardPackageId = nil
    self.rewardItemList = {}
end

function SeasonCardOpenTreasureBoxView:on_after_bind_ref()    
    self:InitView()
end

function SeasonCardOpenTreasureBoxView:InitView()
    fun.set_active(self.rewardItem, false)
    fun.set_active(self.packageRoot, true)
    fun.set_active(self.otherRewardRoot, true)

    self:InitReward()
    local animName = "start" .. self.data.index
    local animFileName = "SeasonCardOpenTreasureBoxViewstart" .. self.data.index
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {animName, animFileName}, false, function()
            self:MutualTaskFinish()
        end)
    end
    self:DoMutualTask(task)
    UISound.play("card_chests")
end

function SeasonCardOpenTreasureBoxView:InitPackage(id)
    self.cardPackageId = id
    local seasonId = ModelList.SeasonCardModel:GetCurSeasonId()
    local packageFixedInfo = ModelList.SeasonCardModel:GetCardPackageInfo(id, seasonId)
    local img = fun.get_component(self.imgPackage, fun.IMAGE)
    local iconName = packageFixedInfo.icon
    iconName = Toolkit.GetBagBigIconName(iconName)
    img.sprite = AtlasManager:GetSpriteByName("SeasonCardOpenPackage", iconName)
end

function SeasonCardOpenTreasureBoxView:InitReward()
    fun.clear_all_child(self.rewardPanel)
    local rewards = self.data.reward
    for i, v in ipairs(rewards) do
        if ModelList.SeasonCardModel:IsCardPackage(v.id) then --前提保证宝箱只能开出一个卡包
            self:InitPackage(v.id)
        else
            local item = self:CreateRewardItem(v)
            fun.set_parent(item, self.rewardPanel, true)
            local rewardItem = {}
            rewardItem.go = item
            rewardItem.data = v
            table.insert(self.rewardItemList, rewardItem)
        end
    end
end

function SeasonCardOpenTreasureBoxView:CreateRewardItem(rewardData)
    local go = fun.get_instance(self.rewardItem)
    local ref = fun.get_component(go, fun.REFER)
    local icon = ref:Get("icon")
    local value = ref:Get("value")
    local id = rewardData.id
    local count = rewardData.value
    local iconName = Csv.GetItemOrResource(id, "more_icon")
    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
    --value.text = fun.format_money(count)
    value.text = Toolkit.FormatReward(count)
    fun.set_active(go, true)
    return go
end

function SeasonCardOpenTreasureBoxView:OnDisable()
    Facade.RemoveViewEnhance(self)
end

function SeasonCardOpenTreasureBoxView:SetData(data)
    self.data = data
    self.rewards = data.reward
end

function SeasonCardOpenTreasureBoxView:CloseSelf()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"end", "SeasonCardOpenTreasureBoxViewend"}, false, function()
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.HideDialog, self)
        end)
    end

    self:DoMutualTask(task)
end

function SeasonCardOpenTreasureBoxView:on_btn_close_click()
    self:CloseSelf()
end

function SeasonCardOpenTreasureBoxView:on_btn_collect_click()
    local task = function()
        self:CollectNormalRewards()
    end
    self:DoMutualTask(task)
end

function SeasonCardOpenTreasureBoxView:CollectNormalRewards()
    if #self.rewardItemList > 0 then
        local delay = 0
        local coroutine_fun = nil
        for index, value in ipairs(self.rewardItemList) do
            coroutine_fun = function()
                delay = delay + 0.2
                coroutine.wait(delay)
                local pos = fun.get_gameobject_pos(value.go)
                local itemId = value.data.id
                local callback = function()
                    if index == #self.rewardItemList then
                        Event.Brocast(EventName.Event_currency_change)
                        self:MutualTaskFinish()
                        self:CollectCardPackage()
                    end
                end
                Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts, pos, itemId, callback, nil, true)
            end
            coroutine.resume(coroutine.create(coroutine_fun))
        end
    else
        self:MutualTaskFinish()
        self:CollectCardPackage()
    end
end

function SeasonCardOpenTreasureBoxView:CollectCardPackage()
    AnimatorPlayHelper.Play(self.anima, {"end", "SeasonCardOpenTreasureBoxViewend"}, false, function()
        Facade.SendNotification(NotifyName.CloseUI, self)
        if self.cardPackageId then
            local params = {}
            params.bagIds = {self.cardPackageId}
            ModelList.SeasonCardModel:OpenCardPackage(params)
        end
    end)
end


function SeasonCardOpenTreasureBoxView:OnForceExit(params)
    self:CloseSelf()
end

--设置消息通知
this.NotifyEnhanceList =
{
    --{notifyName = NotifyName.SeasonCard.ShowExchangeBoxBubble, func = this.ShowBubble},
    {notifyName = NotifyName.SeasonCard.ForceExit, func = this.OnForceExit},
}

return this