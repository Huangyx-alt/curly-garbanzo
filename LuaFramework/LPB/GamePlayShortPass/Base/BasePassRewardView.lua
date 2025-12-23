--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-02-29 14:46:44
]]
 

local BasePassRewardView = class("BasePassRewardView",BaseViewEx)
local this = BasePassRewardView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
local csv_data_name = "task_pass"
                                                                                     
local BaseGamePassBaseRewardsOriginalState = require "GamePlayShortPass/Base/States/BaseGamePassBaseRewardsOriginalState"
local BaseGamePassBaseRewardsExtraState = require "GamePlayShortPass/Base/States/BaseGamePassBaseRewardsExtraState"
local BaseGamePassBaseRewardsStiffState = require "GamePlayShortPass/Base/States/BaseGamePassBaseRewardsStiffState"
local RewardItemView = require("View/CommonView/CollectRewardsItem")

local this = BasePassRewardView
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
    "txt_activite",
    
}

local rewards_item = nil
local isInit = nil
local rewardItemsCache1 = nil
local rewardItemsCache2 = nil
local closeCallback = nil
local buySucceed = nil


function BasePassRewardView:ctor(id)
    self.id = id 
end

function BasePassRewardView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("BasePassRewardView",self,{
        BaseGamePassBaseRewardsOriginalState,
        BaseGamePassBaseRewardsExtraState,
        BaseGamePassBaseRewardsStiffState
    })
    self._fsm:StartFsm("BaseGamePassBaseRewardsOriginalState")
end

function BasePassRewardView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function BasePassRewardView:Awake(obj)
    self:on_init()
end


function BasePassRewardView:SetBtnCollect()
    local price = self:GetModel():get_price()
    self.txt_activite.text = string.format(" FOR $%s", price)
end


function BasePassRewardView:OnEnable(prams)
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
    isInit = true
    self:FillData()
    self:ShowRewards()
    self:ShowRewardsExtra()
    self:SetBtnCollect()
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

function BasePassRewardView:OnDisable()
    Facade.RemoveViewEnhance(self)
    self:Close()
    self:DisposeFsm()
end

function BasePassRewardView:on_close()
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

function BasePassRewardView:FillData()
    local desc1 = Csv.GetDescription(1934)
    self.txt_description.text = desc1
end

function BasePassRewardView:SetRewards(rewards)
    rewards_item = rewards
    if isInit then
        self:ShowRewards()
        self:ShowRewardsExtra()
    end
end

function BasePassRewardView:SetCloseCallback(callback)
    closeCallback = callback
end

function BasePassRewardView:ShowRewards()
    if rewards_item then
        if rewardItemsCache1 == nil then
            rewardItemsCache1 = {}
        end
        
        local count = fun.get_table_size(rewards_item)
        assert(count > 0,"奖励异常")
        for key, value in ipairs(rewards_item) do
            local go = fun.get_instance(self.item_template, self.scroll_rect1)
            if go and not fun.is_null(go) then
                local rewardItem = RewardItemView:New()
                rewardItem:SetReward(value)
                rewardItem:SkipLoadShow(go, true, nil)
                if rewardItemsCache1[key] == nil then
                    table.insert(rewardItemsCache1, rewardItem)
                end
            end
        end
    end
end

function BasePassRewardView:ShowRewardsExtra()
    local rewardNow, rewardSoon = self:GetModel():GetAllReward(BingoPassPayType.Pay499)
    local rewardItems = {}
    for key, value in pairs(rewardNow) do
        local item = {}
        item.id = key
        item.value = value
        table.insert(rewardItems, item)
    end
    rewardItemsCache2 = {}

    for key, value in ipairs(rewardItems) do
        local go = fun.get_instance(self.item_template, self.scroll_rect2)
        if go and not fun.is_null(go) then
            local rewardItem = RewardItemView:New()
            rewardItem:SetReward(value)
            rewardItem:SkipLoadShow(go, true, nil)
            table.insert(rewardItemsCache2, rewardItem)
        end
    end    
end

function BasePassRewardView:on_btn_collect_click()
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

function BasePassRewardView:on_btn_activate_click()
    self:ShowRecommendOrPurchase()
end

function BasePassRewardView:OnCollectReward()
    self._timer = Invoke(function()
        Util.SetImageColorGray(self.btn_collect, false)
        self._fsm:GetCurState():Change2Original(self._fsm)
    end,3)
    Util.SetImageColorGray(self.btn_collect, true)
    self:DoCollectReward()
end

function BasePassRewardView:ShowRecommendOrPurchase()
    local task = function()
        local payItem =self:GetModel():GetPayItemId()
        if(payItem)then 
            self:GetModel():RequestActivateGoldenPass(payItem)
        end 
    end
    self:DoMutualTask(task)
end

function BasePassRewardView:GetModel()
    local model = ModelList.GameActivityPassModel.GetPassDataComponentById(self.id)
    return model 
end


function BasePassRewardView:SetParam(param)
    if(param.onCloseCallback)then 
        self:SetCloseCallback(param.onCloseCallback)
    end 

    if(param.rewards)then 
        self:SetRewards(param.rewards)
    end
end


function BasePassRewardView:OnBuyBingoPassSucc()
    buySucceed = true
    self:on_btn_collect_click()
end

function BasePassRewardView:DoCollectReward()
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

 

function BasePassRewardView:CloseSelf(closeMethod)
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"end", "BingoPassRecommendView_end"}, false, function()
            if self.closeCallback then
                self.closeCallback(closeMethod)
            end
            self.closeCallback = nil
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.HideDialog, self)
        end)
    end
    self:DoMutualTask(task)
end

function BasePassRewardView:Purchasing_success()
    self:MutualTaskFinish()
    self:GetModel():SetPayInfo()
 
    -- Facade.SendNotification(NotifyName.HideDialog, self)
    Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView,"PassReceivedView", this.payType)

end
 
function BasePassRewardView:Purchasing_failure()
    self:MutualTaskFinish()
    self:on_btn_collect_click()
end



function BasePassRewardView:OnActivateGoldenPassPayResult(code)
    if code == RET.RET_SUCCESS then
        local payData = ModelList.MainShopModel:GetPayData()
        if PurchaseHelper.IsEditorPurchase() then
            self:Purchasing_success()
        else
            if fun.is_null(payData.pid) then
                UIUtil.show_common_popup(9025, true, nil)
                return
            end
            local productId = Csv.GetData("appstorepurchaseconfig", self:GetModel():get_productId(), "product_id")
            if not payData.pid or tostring(payData.pid) == "" then 
                if self.Purchasing_failure then 
                    self:Purchasing_failure()
                end 
            else
                local product_name = Csv.GetData("appstorepurchaseconfig",self:GetModel():get_productId(),"product_name")
                PurchaseHelper.PurchasingType(4,product_name)
                PurchaseHelper.DoPurchasing(deep_copy(payData), nil, productId, payData.pid, function()
                    self:Purchasing_success()
                end, function()
                    self:Purchasing_failure()
                end)
            end
        end
    else
        self:Purchasing_failure()
    end
end

function BasePassRewardView:Purchasing_success()
    self:MutualTaskFinish()
    self:GetModel():SetPayInfo()

    local param = {}
    param.onCloseCallback = function()
        self:on_btn_collect_click() 
    end

    Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView,"PassReceivedView")
    Event.Brocast(EventName.Event_ShortPassView_Refresh)
end
 
function BasePassRewardView:Purchasing_failure()
    self:MutualTaskFinish()
end




this.NotifyEnhanceList = {
    {notifyName = NotifyName.GamePlayShortPassView.ReceivedViewClose, func = this.OnBuyBingoPassSucc},
    {notifyName = NotifyName.ShopView.ActivityPayResult, func = this.OnActivateGoldenPassPayResult}
}

return this
