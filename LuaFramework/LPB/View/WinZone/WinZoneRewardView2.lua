local WinZoneRewardView2 = BaseDialogView:New('WinZoneRewardView2', "WinZoneReward2AtlasInMain")
local this = WinZoneRewardView2
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
this._cleanImmediately = true
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "btn_close",
    "txtDescription",
    "rewardPanel",
    "rewardItem",
    "btn_collect",
    "anima",
    "imgTitle",
}

function WinZoneRewardView2:Awake()
end

function WinZoneRewardView2:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
    self.rewardItems = {}
end

function WinZoneRewardView2:on_after_bind_ref()
    self:InitView()
end

function WinZoneRewardView2:OnDisable()
    Facade.RemoveViewEnhance(self)
    self:ClearCloseCallback()
    self.data = nil
end

function WinZoneRewardView2:SetData(data)
    if not self.data then
        self.data = data
    end

    self:AddCloseCallback(data and data.closeCallback)
end

function WinZoneRewardView2:InitView()
    fun.set_active(self.btn_close, false)
    fun.set_active(self.rewardItem, false)
    --fun.set_active(self.imgTitle, true)
    self:InitReward()
    UISound.play("card_complete")
    if fun.is_not_null(self.anima) then
        local task = function()
            AnimatorPlayHelper.Play(self.anima, {"start", "WinZoneRewardView2_start"}, false, function()
                self:MutualTaskFinish()
            end)
        end

        self:DoMutualTask(task)
    end
end

function WinZoneRewardView2:InitReward()
    fun.clear_all_child(self.rewardPanel)
    if not self.data then
        return
    end
    local rewards = self.data.reward
    for i, v in ipairs(rewards) do
        local item = self:CreateRewardItem(v)
        fun.set_parent(item.go, self.rewardPanel, true)
        table.insert(self.rewardItems, item)
    end
end

function WinZoneRewardView2:CreateRewardItem(rewardData)
    local go = fun.get_instance(self.rewardItem)
    local ref = fun.get_component(go, fun.REFER)
    local icon = ref:Get("icon")
    local value = ref:Get("value")
    local id = rewardData.id
    local count = rewardData.value
    local iconName = Csv.GetItemOrResource(id, "more_icon")
    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
    --value.text = fun.format_money(count)
    value.text = fun.format_money_reward(rewardData)
    fun.set_active(go, true)
    local item = {}
    item.id = id
    item.count = count
    item.go = go
    return item
end

function WinZoneRewardView2:CollectRewards()
    if #self.rewardItems > 0 then
        local delay = 0
        local coroutine_fun = nil
        local totalCardPack = {}
        for index, value in ipairs(self.rewardItems) do
            if ModelList.SeasonCardModel:IsCardPackage(value.id) then
                table.insert(totalCardPack, value.id)
            end

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

                    if totalCardPack and #totalCardPack > 0 then
                        ModelList.SeasonCardModel:OpenCardPackage({bagIds = totalCardPack})
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


function WinZoneRewardView2:CloseSelf()
    if fun.is_not_null(self.anima) then
        local task = function()
            AnimatorPlayHelper.Play(self.anima, {"end", "WinZoneRewardView2_end"}, false, function()
                self:MutualTaskFinish()
                -- if self.data and self.data.closeCallback then
                --     self.data.closeCallback()
                -- end
                self:ExecuteCloseCallback()
                Facade.SendNotification(NotifyName.HideDialog, self)
                Facade.SendNotification(NotifyName.WinZone.MatchEnded)
                Event.Brocast(EventName.Event_WinZone_Match_Ended)
            end)
        end

        self:DoMutualTask(task)
    else
        -- if self.data and self.data.closeCallback then
        --     self.data.closeCallback()
        -- end
        self:ExecuteCloseCallback()
        Facade.SendNotification(NotifyName.HideDialog, self)
        Facade.SendNotification(NotifyName.WinZone.MatchEnded)
        Event.Brocast(EventName.Event_WinZone_Match_Ended)
    end
end

function WinZoneRewardView2:AddCloseCallback(cb)
    log.log("WinZoneRewardView2:AddCloseCallback()")
    if not cb then
        return
    end

    self.closeCallbackList = self.closeCallbackList or {}
    table.insert(self.closeCallbackList, cb)
end

function WinZoneRewardView2:ClearCloseCallback()
    log.log("WinZoneRewardView2:ClearCloseCallback()")
    self.closeCallbackList = nil
end

function WinZoneRewardView2:ExecuteCloseCallback()
    log.log("WinZoneRewardView2:ExecuteCloseCallback()")
    if not self.closeCallbackList then
        return
    end

    if fun.is_table_empty(self.closeCallbackList) then
        return
    end

    for i, v in ipairs(self.closeCallbackList) do
        v()
    end

    self:ClearCloseCallback()
end

function WinZoneRewardView2:on_btn_close_click()
    self:CloseSelf()
end

function WinZoneRewardView2:on_btn_collect_click()
    local task = function()
        self:CollectRewards()
    end

    self:DoMutualTask(task)
end

--设置消息通知
this.NotifyEnhanceList =
{
    --{notifyName = NotifyName.xx.xxx, func = this.Onxxxx},
}

return this