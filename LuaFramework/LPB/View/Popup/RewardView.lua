require "State/Common/CommonState"

local RewardView = BaseView:New("RewardView")
local this = RewardView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "content",
    "reward_item",
    "btn_collect",
    "anima"
}

local rewards_item = nil
local click_callback = nil
local enter_animation = nil

local isInit = nil

local rewardItemsCache = nil

--local Input = UnityEngine.Input
--local KeyCode = UnityEngine.KeyCode

function RewardView:Awake(obj)
    self:on_init()
end

function RewardView:OnEnable()
    isInit = true
    self:ShowRewards()
    --self.update_x_enabled = true
    --self:start_x_update()
    CommonState.BuildFsm(self,"RewardView")

    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"efCollectRewardsenter","efCollectRewardsenter"},false,function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        end)
    end)
    UISound.play("kick_reward")
end

function RewardView:OnDisable()
    self:Close()
    CommonState.DisposeFsm(self)
end

function RewardView:on_close()
    rewards_item = nil
    click_callback = nil
    enter_animation = nil
    isInit = nil
    rewardItemsCache = nil
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end

--[[
function RewardView:on_x_update()
    if Input and Input.GetKeyUp(KeyCode.Mouse0) then
        if click_callback then
            click_callback()
            click_callback = nil
        end
    end
end
--]]

function RewardView:SetRewards(rewards)
    rewards_item = rewards
    if isInit then
        self:ShowRewards()
    end
end

function RewardView:SetCallBack(callback)
    click_callback = callback
end

function RewardView:SetAnimation(anima)

end


function RewardView:ShowRewards()
    if rewards_item then
        if rewardItemsCache == nil then
            rewardItemsCache = {}
        end
        local view = require("View/CommonView/CollectRewardsItem")
        local count = fun.get_table_size(rewards_item)
        assert(count > 0,"奖励异常")
        for key, value in pairs(rewards_item) do
            local go = fun.get_instance(self.reward_item,self.content)
            local rewardItem = view:New()
            rewardItem:SetReward(value)
            rewardItem:SkipLoadShow(go,true,nil)
            if rewardItemsCache[key] == nil then
                table.insert(rewardItemsCache,rewardItem)
            end
        end
    end
end

function RewardView:on_btn_collect_click()
    if click_callback then
        self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState2State",function()
            click_callback()
            self._timer = Invoke(function()
                self._fsm:GetCurState():DoCommonState2Action(self._fsm,"CommonOriginalState")
            end,3)
        end)
    end
end

function RewardView:CloseView()
    local delay = 0
    local coroutine_fun = nil
    for key, value in pairs(rewardItemsCache) do
        coroutine_fun = function()
            delay = delay + 0.2
            coroutine.wait(delay)
            Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,value:GetPosition(),value:GetRewardItemId(),function()
                Event.Brocast(EventName.Event_currency_change)
            end)
        end
        coroutine.resume(coroutine.create(coroutine_fun))
    end
    coroutine_fun = function()
        delay = delay + 0.2
        coroutine.wait(delay)
        AnimatorPlayHelper.Play(self.anima,{"efCollectRewardsexit","efCollectRewardsexit"},false,function()
            Facade.SendNotification(NotifyName.CloseUI,self)
        end)
    end
    coroutine.resume(coroutine.create(coroutine_fun))

    UISound.play("gift_box_open")
end

this.NotifyList =
{

}

return this