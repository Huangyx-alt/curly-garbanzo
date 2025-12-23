require "State/Common/CommonState"

local RegisterRewardView = BaseView:New("RegisterRewardView","RegisterRewardAtlas")
local this = RegisterRewardView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true

this.auto_bind_ui_items = {
    "btn_collect",
    "content",
    "reward_item",
    "anima"
}

local rewardItemsCache = nil

function RegisterRewardView:Awake(obj)
    self:on_init()
end

function RegisterRewardView:OnEnable(params)
    if params then
        if rewardItemsCache == nil then
            rewardItemsCache = {}
        end
        local view = require("View/CommonView/CollectRewardsItem")
        for key, value in pairs(params) do
            local go = fun.get_instance(self.reward_item,self.content)
            local rewardItem = view:New()
            rewardItem:SetReward(value)
            rewardItem:SkipLoadShow(go,true,nil)
            if rewardItemsCache[key] == nil then
                table.insert(rewardItemsCache,rewardItem)
            end
        end
    end
    --self.text_tip.text = Csv.GetDescription(972)
    CommonState.BuildFsm(self,"RegisterRewardView")
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"RegisterRewardViewin","RegisterRewardViewin"},false,function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        end)
    end)
end

function RegisterRewardView:OnDisable()
    rewardItemsCache = nil
    CommonState.DisposeFsm(self)
    Event.Brocast(EventName.Event_registerReward,nil)
end

function RegisterRewardView:on_btn_collect_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        local delay = 0
        local coroutine_fun = nil
        for key, value in pairs(rewardItemsCache) do
            coroutine_fun = function()
                delay = delay + 0.2
                coroutine.wait(delay)
                Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,value:GetPosition(),value:GetRewardItemId(),function()
                    Event.Brocast(EventName.Event_currency_change)
                end,nil,self.isPromoteTopView)
            end
            coroutine.resume(coroutine.create(coroutine_fun))
        end
        coroutine_fun = function()
            delay = delay + 0.2
            coroutine.wait(delay)
            AnimatorPlayHelper.Play(self.anima,{"RegisterRewardViewout","RegisterRewardViewout"},false,function()
                Facade.SendNotification(NotifyName.CloseUI,self)
            end)
        end
        coroutine.resume(coroutine.create(coroutine_fun))
    end)
end

return this