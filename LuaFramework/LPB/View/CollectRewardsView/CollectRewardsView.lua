
--local CollectRewardsAdBaseState =  require "View/CollectRewardsView/CollectRewardsAdBaseState"
local CollectRewardsAdOriginalState =  require "View/CollectRewardsView/CollectRewardsAdOriginalState"
local CollectRewardsAdStiffState =  require "View/CollectRewardsView/CollectRewardsAdStiffState"
local CollectRewardsAdExtraState =  require "View/CollectRewardsView/CollectRewardsAdExtraState"

local CollectRewardsView = BaseView:New("CollectRewardsView","BingoBangPopupAtlas")
local this = CollectRewardsView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "content",
    "reward_item",
    "btn_collect",
    "anima"
}

local rewards_item = nil
local click_callback = nil
local close_callback = nil
local enter_animation = nil

local isInit = nil

local rewardItemsCache = nil

--local Input = UnityEngine.Input
--local KeyCode = UnityEngine.KeyCode

function CollectRewardsView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("CollectRewardsView",self,{
        CollectRewardsAdOriginalState:New(),
        CollectRewardsAdStiffState:New(),
        CollectRewardsAdExtraState:New()
    })
    self._fsm:StartFsm("CollectRewardsAdOriginalState")
end

function CollectRewardsView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function CollectRewardsView:Awake(obj)
    self:on_init()
end

function CollectRewardsView:OnEnable(prams)
    isInit = true
    self:ShowRewards()
    --self.update_x_enabled = true
    --self:start_x_update()

    self:BuildFsm()
    self._fsm:GetCurState():PlayEnter(self._fsm,function()
        AnimatorPlayHelper.Play(self.anima,{"efCollectRewardsenter","efCollectRewardsenter"},false,function()
            self._fsm:GetCurState():Change2Original(self._fsm)
            --自动领取
            if prams ~= nil and prams ==ClaimRewardsPrames.autoClick then 
                this:on_btn_collect_click()
            end 

        end)
    end)
    UISound.play("kick_reward")
end

function CollectRewardsView:OnDisable()
    self:Close()
    self:DisposeFsm()
end

function CollectRewardsView:on_close()
    if close_callback then
        close_callback()
    end
    rewards_item = nil
    click_callback = nil
    close_callback = nil
    enter_animation = nil
    isInit = nil
    rewardItemsCache = nil
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end

--[[
function CollectRewardsView:on_x_update()
    if Input and Input.GetKeyUp(KeyCode.Mouse0) then
        if click_callback then
            click_callback()
            click_callback = nil
        end
    end
end
--]]

function CollectRewardsView:SetRewards(rewards)
    rewards_item = rewards
    if isInit then
        self:ShowRewards()
    end
end

function CollectRewardsView:SetCallBack(callback)
    click_callback = callback
end

function CollectRewardsView:SetAnimation(anima)

end

function CollectRewardsView:ShowRewards()
    if rewards_item then
        if rewardItemsCache == nil then
            rewardItemsCache = {}
        end
        local view = require("View/CommonView/CollectRewardsItem")
        local count = fun.get_table_size(rewards_item)
        assert(count > 0,"奖励异常")
        for key, value in pairs(rewards_item) do
            local go = fun.get_instance(self.reward_item,self.content)
            if go and not fun.is_null(go) then
                local rewardItem = view:New()
                rewardItem:SetReward(value)
                rewardItem:SkipLoadShow(go,true,nil)
                if rewardItemsCache[key] == nil then
                    table.insert(rewardItemsCache,rewardItem)
                end
            end
        end
    end
end

function CollectRewardsView:on_btn_collect_click()
    self._fsm:GetCurState():CollectReward(self._fsm)
end

function CollectRewardsView:OnCollectReward()
    if click_callback then
        click_callback()
        self._timer = Invoke(function()
            if self and fun.is_not_null(self.btn_collect1) then
                fun.enable_button(self.btn_collect1, true)
                --Util.SetImageColorGray(self.btn_collect1,false)
            end
            if self and self._fsm then
                self._fsm:GetCurState():Change2Original(self._fsm)
            end
        end,3)
        --Util.SetImageColorGray(self.btn_collect,true)
        fun.enable_button(self.btn_collect, false)
    else
        self:CloseView()
    end
end

function CollectRewardsView:CloseView(callback)
    local delay = 0
    local coroutine_fun = nil
    local count = 0
    close_callback = callback
    --- View/CollectRewardsView/CollectRewardsView:186: bad argument #1 to 'pairs' (table expected, got nil)
    local totalCardPack = {}
    if rewardItemsCache then
        for key, value in pairs(rewardItemsCache) do
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
                    if 0 == count and self.anima then
                        if totalCardPack and #totalCardPack > 0 then
                            ModelList.SeasonCardModel:OpenCardPackage({bagIds = totalCardPack})
                        end
                        
                        AnimatorPlayHelper.Play(self.anima,{"efCollectRewardsexit","efCollectRewardsexit"},false,function()
                            Facade.SendNotification(NotifyName.CloseUI,self)
                        end)
                    end
                    if value:GetRewardItemId() == Resource.taskpoint then
                        Event.Brocast(EventName.Event_PassGetTaskRewardSucceed)
                    end
                end,nil,self.isPromoteTopView)
            end
            coroutine.resume(coroutine.create(coroutine_fun))
        end
    end
    UISound.play("gift_box_open")
end

return this