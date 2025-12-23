--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-02-29 14:46:44
]]


local PassView = class("PassView",BaseViewEx)
local this = PassView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
local csv_data_name = "task_pass"
function PassView:ctor(id)
    self.id = id 
end
fun.ExtendClass(this, fun.ExtendFunction.mutual)

 
local BaseGamePassBaseOriginalState = require "GamePlayShortPass/Base/States/BaseGamePassBaseOriginalState"
local BaseGamePassBaseEnterState = require "GamePlayShortPass/Base/States/BaseGamePassBaseEnterState"
local BaseGamePassBaseExitState = require "GamePlayShortPass/Base/States/BaseGamePassBaseExitState"
local BaseGamePassBaseStiffState = require "GamePlayShortPass/Base/States/BaseGamePassBaseStiffState"
local BaseGamePassBaseExpiredState = require "GamePlayShortPass/Base/States/BaseGamePassBaseExpiredState"

require "View/CommonView/RemainTimeCountDown"


local cacheItemList = nil
local itemIndex = 0

local itemHeight = 333
local initialOffset = 150
local showItemCount = 4
local totalItemCount = 157

local content_height = nil

local cacheLevel = nil

local remainTimeCountDown = RemainTimeCountDown:New()

local isdebug = false 
this.auto_bind_ui_items = {
    "content",
    "item",
    "slider",
    "btn_help",
    "slider_flash",
    "btn_activate",
    "btn_close",
    "btn_bigowin",
    "text_remainTime",
    "text_activate",
    "anima",
    "scrollView",
    "text_flashValue",
    "text_flashLevel",
    "accomplish",
    "crossLine",
    "cover_mask",
    "particle_slider",
    "btn_collect",
    "bottom_lock",
    "bottomItem",
    "lpFlash",
    "text_gold_price",
    "FunctionIcon",
    "lpGoldPassAccomplish",
    "lpGoldPassCard",
    
}
this._cleanImmediately = true 
function GetBingoPassFlashPos()
    if fun.is_not_null(this.lpFlash) then
        return this.lpFlash.position
    end
end

function PassView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("PassView",self,{
        BaseGamePassBaseOriginalState:New(),
        BaseGamePassBaseEnterState:New(),
        BaseGamePassBaseExitState:New(),
        BaseGamePassBaseStiffState:New(),
        BaseGamePassBaseExpiredState:New()
    })
    self._fsm:StartFsm("BaseGamePassBaseOriginalState")
end

function PassView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end


function PassView:GetModel()
    local model = ModelList.GameActivityPassModel.GetPassDataComponentById(self.id)
    return model 
end



function PassView:HideCoverageEntity()
    self:NotifyHideCoverageEntity()
end

function PassView:ShowCoverageEntity()
    self:NotifyShowCoverageEntity()
end

function PassView:GetRewardLevel()
    if self:GetModel():IsAnyPayment() then
        return self:GetModel():GetLevel()
    else
        local curLevel = self:GetModel():GetLevel()
        local temLevel = curLevel
        while true do
            local passData = self:GetModel():GetRewardDataById(math.max(1,temLevel)).free_reward ---Csv.GetData(csv_data_name,math.max(1,temLevel),"free_reward")
            if not passData then
                break
            end
            if passData[1] and passData[1] > 0 then
                break
            end
            temLevel = math.max(1,temLevel - 1)
        end
        return (self:GetModel():IsFreeReceived(temLevel) 
        and {curLevel} 
        or {temLevel})[1]
    end
end

function PassView:Awake(obj)
    self:on_init()
end

function PassView:OnEnable()
    ModelList.GuideModel:OpenUI("PassView")
    -- Facade.RegisterView(self)
    Facade.RegisterViewEnhance(self)
    self:RegisterUIEVent()
    showItemCount = math.ceil(self.scrollView.transform.rect.height / itemHeight)
    totalItemCount =  self:GetModel():GetShowRewardDataCout()  -- #Csv[csv_data_name] - 1 --最终奖励不放一起，独立开来了
    content_height = itemHeight * totalItemCount + initialOffset
    local itemView = require "GamePlayShortPass/Base/BasePassItem"
    cacheItemList = {}
    local y = -initialOffset
    -- local progress,totalItemCount = self:GetModel():get_progress()
    local curLevel = math.max(0,math.min(self:GetRewardLevel(),totalItemCount - showItemCount) - 1)
    -- local curLevel = math.max(0,math.min(progress,totalItemCount - showItemCount) - 1)
    y = y - itemHeight * curLevel
    self.content.transform.anchoredPosition = Vector2.New(0,math.abs(itemHeight * curLevel))
    fun.set_active(self.item, false)
    for i = 1, showItemCount + 2 do
        if curLevel + i <= totalItemCount then
            local go = fun.get_instance(self.item.transform,self.content)
            fun.set_gameobject_pos(go,0,y,0,true)
            fun.set_active(go.transform,true)
            local view =   itemView:create(curLevel + i ,self:GetModel()) --itemView:New()
            view:SkipLoadShow(go)
            table.insert(cacheItemList,view)
            --self:SetMaskItem(view,y)  --禁用，已经修改更新策略
            y = y - itemHeight
        end
    end
    self:UpdateCrossLinePos()
    self.cover_mask.sizeDelta = Vector2.New(930, content_height)

    --self.cover_mask:SetSiblingIndex(self.content.transform.childCount - 1)

    self.content.transform.sizeDelta = Vector2.New(0,content_height)
    self.slider.transform.sizeDelta = Vector2.New(80,content_height)
    self.slider.minValue = 0
    self.slider.maxValue = content_height
    
    self:SetExp(true)
    
    itemIndex = curLevel
    self.luabehaviour:AddScrollRectChange(self.scrollView.gameObject, function(value)
        local contentY = self.content.transform.localPosition.y
        local index = math.min(totalItemCount - showItemCount, math.floor(math.abs(contentY) / itemHeight))
        local velocity = self.scrollView.velocity.y --滑动得速度
        if velocity < 0 and contentY > 0 then
            if index < itemIndex then
                local itemMinPos = nil
                local posy = 100000000
                for key, value in pairs(cacheItemList) do
                    if value:GetPosY() < posy  then
                        itemMinPos = value
                        posy = value:GetPosY()
                    end
                end
                itemIndex = index
                fun.set_gameobject_pos(itemMinPos.go, 0, -itemHeight * index - initialOffset,0,true)
                itemMinPos:SetBingoPassInfo(index + 1)
                if index == totalItemCount - showItemCount - 1 then
                    itemMinPos:SetActive(true)
                end
            end
        elseif velocity > 0 and contentY > 0 then
            if index > itemIndex then
                local itemMaxPos = nil
                local posy = -100000000
                for key, value in pairs(cacheItemList) do
                    if value:GetPosY() > posy  then
                        itemMaxPos = value
                        posy = value:GetPosY()
                    end
                end
                itemIndex = index
                if index + showItemCount <= totalItemCount then
                    fun.set_gameobject_pos(itemMaxPos.go, 0, -itemHeight * (index + showItemCount) - initialOffset,0,true)
                    if index + showItemCount < totalItemCount then
                        itemMaxPos:SetBingoPassInfo(index + showItemCount + 1)
                        --self:SetMaskItem(itemMaxPos)  --禁用，已经修改更新策略
                    else
                        itemMaxPos:SetActive(false)
                    end
                end
            end
        end
    end)

    -- local bottomItem = require "GamePlayShortPass/Base/BingoPassBottomItem"
    -- bottomBonusItem = bottomItem:New(totalItemCount + 1)
    -- bottomBonusItem:SetMaxLevel(totalItemCount)
    -- bottomBonusItem:SkipLoadShow(self.bottomItem)

    self:BuildFsm()
    self._fsm:GetCurState():PlayEnter(self._fsm)

    remainTimeCountDown:StartCountDown(CountDownType.cdt2,self:GetModel():GetRemainTime(),self.text_remainTime,function()
        self._fsm:GetCurState():Expired(self._fsm)
    end)
    self:InitGoldPassInfo()
   -- self:InitbigowinDec()
   self:InitIcon()
   self.isWattingPurchase = false
end

function PassView:InitIcon()
    local view = ModelList.GameActivityPassModel.GetViewById(self.id,"PassIconView")  
    self.childIconView = view:create(self.id,false,"passview") 
    self.childIconView:SkipLoadShow(self.FunctionIcon,true,nil,true) 
    self.childIconView:SetCoutDown(self:GetModel():GetRemainTime())
    self.childIconView:SetProgress() 
end

function PassView:OnDestroy()
    self.isWattingPurchase = false
	self:Close()
    if(self.childIconView)then 
        self.childIconView:Close()
    end
end


function PassView:InitGoldPassInfo()
    
    local isPay499 = self:GetModel():IsCompletePay(BingoPassPayType.Pay499)
    local payData = self:GetModel():get_priceItem()
    local price = self:GetModel():get_price()
 
 
    local isPay =self:GetModel():IsAnyPayment()
    self.text_gold_price.text = string.format(" FOR $%s", price)
    if(isPay)then 
        fun.enable_button(self.btn_activate,false)
        fun.set_active(self.lpGoldPassCard,false) 
        fun.set_active(self.lpGoldPassAccomplish,true) 
        
        Util.SetImageColorGray(self.btn_activate, true)
        -- Util.SetImageColorGray(self.text_gold_price, true)
    else 

        fun.set_active(self.lpGoldPassCard,true) 
        fun.set_active(self.lpGoldPassAccomplish,false) 
        fun.enable_button(self.btn_activate,true)  
    end 


    fun.set_active(self.btn_activate,true) 
end



function PassView:OnDisable()
    Facade.RemoveViewEnhance(self)
    self:DisposeFsm()
    cacheItemList = nil
    itemIndex = nil
    content_height = nil
    cacheLevel = nil
    -- bottomBonusItem = nil
    remainTimeCountDown:StopCountDown()
    if self._tweener then
        self._tweener:Kill()
        self._tweener = nil
    end
    self:UnRegisterUIEVent()
end

function PassView:SetMaskItem(item, posY)
    if item:IsTopLockItem() then
        local y = posY or item:GetPosY()
        fun.set_gameobject_pos(self.crossLine.gameObject,0,y,0,true)
        fun.set_gameobject_pos(self.cover_mask.gameObject,0, y,0,true)
        self.cover_mask.sizeDelta = Vector2.New(930,content_height)
    end
end

function PassView:UpdateCrossLinePos()
    local y = 0 - (self:GetModel():GetLevel() * itemHeight) - initialOffset
    log.log("PassView:UpdateCrossLinePos", self:GetModel():GetLevel(), y)
    fun.set_gameobject_pos(self.crossLine.gameObject,0, y, 0, true)
    fun.set_gameobject_pos(self.cover_mask.gameObject,0, y, 0, true)
    --self.cover_mask.sizeDelta = Vector2.New(930, content_height)
end

function PassView:SetExp(isFirst)
    local level = self:GetModel():GetLevel()
    local level2 = level + 1
    local data =  self:GetModel():GetRewardDataById(level)--   Csv.GetData(csv_data_name,level)
    local data2 = self:GetModel():GetRewardDataById(level2)--Csv.GetData(csv_data_name,level2)
    local exp = self:GetModel():GetExp()
    if level == 0 then
        level = level2
        data = data2
    elseif data2 == nil or level == totalItemCount then
        --达到最大等级
        level2 = level
        data2 = data
        exp = data2.sum_exp
    end

    self:RecursionShowExpAnimation(level,level2,exp,data2.exp)

    local nextLvExp = data2.exp
    if 0 == nextLvExp or nil == nextLvExp then
        nextLvExp = data.exp
    end
    local offset = math.max(0,self:GetModel():GetExpCount() % data.sum_exp) --math.max(0,self:GetModel():GetExpCount() - data.sum_exp)
    if self:GetModel():GetLevel() > 0 then
        local source = self.slider.value
        local target = math.max(0,level - 1) * itemHeight + initialOffset + itemHeight / 2 + (offset / nextLvExp) * itemHeight
        if isFirst then
            source = 0
        end
        Anim.do_smooth_float_update(source,target,0.5,function(value)
            self.slider.value = value
        end,function(value)

        end):SetEase(DG.Tweening.Ease.InOutSine)

        fun.set_gameobject_pos(self.particle_slider.gameObject,0,-1 * (target - 300),0,true)
    else
        local source = self.slider.value
        local target = (offset / nextLvExp) * (initialOffset + itemHeight / 2)
        if isFirst then
            source = 0
        end
        Anim.do_smooth_float_update(source,target,0.5,function(value)
            self.slider.value = value
        end,function(value)

        end):SetEase(DG.Tweening.Ease.InOutSine)
    end
    
    local isPayAccomplish = self:GetModel():IsPayAccomplish()
    -- fun.set_active(self.btn_activate.transform, not isPayAccomplish)
    -- fun.set_active(self.accomplish.transform, isPayAccomplish)

    if level2 == 1 then
        fun.set_active(self.particle_slider,false)
        fun.set_active(self.crossLine,true)
        fun.set_active(self.cover_mask,true)
    elseif level == totalItemCount then
        fun.set_active(self.particle_slider,false)
        fun.set_active(self.crossLine,false)
        fun.set_active(self.cover_mask,false)
    else
        fun.set_active(self.particle_slider,true)
        fun.set_active(self.crossLine,true)
        fun.set_active(self.cover_mask,true)
    end
end

function PassView:RecursionShowExpAnimation(level,toLevel,exp,toExp)
    local curLevel = self:GetModel():GetLevel()
    if cacheLevel == nil then
        cacheLevel = toLevel
        self.slider_flash.value = 0
        self._tweener = Anim.slide_to_num(self.slider_flash,self.text_flashValue,exp,toExp,0.5,function()
            if cacheLevel then
                self.text_flashLevel.text = tostring(toLevel)
                self.text_flashValue.text = ((curLevel == cacheLevel and cacheLevel == totalItemCount) and {"MAX"} or {string.format("%s/%s",exp,toExp)})[1]
                self.slider_flash.value = exp / math.max(1,toExp)
            end
        end)
        self._tweener:SetEase(DG.Tweening.Ease.InOutSine)
    elseif math.max(0,toLevel - cacheLevel) > 0 then
        cacheLevel = cacheLevel + 1
        local data = self:GetModel():GetRewardDataById(cacheLevel)--Csv.GetData(csv_data_name,cacheLevel)
        self._tweener = Anim.slide_to_num(self.slider_flash,self.text_flashValue,data.exp,data.exp,0.5,function()
            if cacheLevel then
                self.text_flashLevel.text = tostring(math.min(cacheLevel,totalItemCount))
                --self.text_flashValue.text = string.format("%s/%s",0,data.exp)
                self.slider_flash.value = 0
                self:RecursionShowExpAnimation(level,toLevel,exp,toExp)
            end
        end)
        self._tweener:SetEase(DG.Tweening.Ease.InOutSine)
    else
        cacheLevel = cacheLevel
        self._tweener = Anim.slide_to_num(self.slider_flash,self.text_flashValue,exp,toExp,0.5,function()
            self.text_flashValue.text = ((curLevel == cacheLevel and cacheLevel == totalItemCount) and {"MAX"} or {string.format("%s/%s",exp,toExp)})[1]
        end)
        self._tweener:SetEase(DG.Tweening.Ease.InOutSine)
    end
end

function PassView:PlayBingoPassEnter()
    AnimatorPlayHelper.Play(self.anima,{"start","BingoPassView_startgreen"},false,function()
        self._fsm:GetCurState():Complete(self._fsm)
    end)
    UISound.play("bingopass_open")
end

function PassView:PlayBingoPassExit()
    AnimatorPlayHelper.Play(self.anima,{"end","BingoPassView_endlgreen"},false,function()
        self:CloseSelf()
    end)
end

function PassView:DisableDragAbility()
    self.scrollView.enabled = false
end

function PassView:EnableDragAbility()
    self.scrollView.enabled = true
end

function PassView:on_btn_help_click()
    -- Facade.SendNotification(NotifyName.ShowUI,ViewList.BingoPassHelperView)
    Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView,"PassHelperView")
end

function PassView:on_btn_activate_click() 
    
    if(isdebug)then 
        self:Purchasing_success() --debug
        -- self:OnBingoPassWatchAd()
    else
        self._fsm:GetCurState():Purchase(self._fsm)
    end
   
end

function PassView:OnShowPurchaseView()
 
    self.isWattingPurchase = true
    local task = function()
        local payItem =self:GetModel():GetPayItemId()
        if(payItem)then 
            self:GetModel():RequestActivateGoldenPass(payItem)
        end 
    end
    self:DoMutualTask(task)

end

function PassView:AfterRecommendClose(closeMethod)
    -- if closeMethod == ViewList.BingoPassRecommendView.CloseMethod.normal then
    --     Facade.SendNotification(NotifyName.ShowUI,ViewList.BingoPassPurchaseView)
    -- elseif closeMethod == ViewList.BingoPassRecommendView.CloseMethod.paySucceed then
    --     --购买成功后就不弹购买窗口了
    -- else
    --     Facade.SendNotification(NotifyName.ShowUI,ViewList.BingoPassPurchaseView)
    -- end
end

function PassView:on_btn_close_click()
    self._fsm:GetCurState():PlayExit(self._fsm)  --debug lxq
    -- Facade.SendNotification(NotifyName.CloseUI,self)
end

-- function PassView:on_btn_bigowin_click()
--     fun.set_active(self.bigowinDec.transform.parent,true)
--     LuaTimer:SetDelayFunction(3, function()
--         fun.set_active(self.bigowinDec.transform.parent,false)
--     end) 
-- end


function PassView:OnUpdataBingoPassInfo()
    if cacheItemList then
        self:SetExp()
        for key, value in pairs(cacheItemList) do
            value:RefreshInfo()
            --self:SetMaskItem(value) --禁用，已经修改更新策略
        end
        self:UpdateCrossLinePos()
        -- bottomBonusItem:RefreshInfo()
        self._fsm:GetCurState():Complete(self._fsm)
    end
end

function PassView:OnBingoPassWatchAd(passItem)
    self._fsm:GetCurState():BaseGamePassBaseWatchAd(self._fsm,passItem)
end

function PassView:OnGemUnlockLevel(passItem)
    self._fsm:GetCurState():GemUnlockLevel(self._fsm,passItem)
end

function PassView:OnClaimReward(passItem)
    self._fsm:GetCurState():ClaimReward(self._fsm,passItem)
end

function PassView:OnReceiveReward()
    if self:GetModel():IsAnyPayment() then
        self:ReceiveRewardPaid()
    else
        self:ReceiveRewardFree()
    end
end

function PassView:OnReceiveRewardFinish()

    Event.Brocast(EventName.Event_PassGetTaskRefreshIcon)

    Invoke(function()
        self:OnUpdataBingoPassInfo()
    end, 1.5)
end

function PassView:ReceiveRewardPaid()
    local rewards = self:GetModel():GetRewardList()
    Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,rewards,function()
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.hide,ClaimRewardViewType.CollectReward)
        self:OnReceiveRewardFinish()
    end,nil,nil,true)
end

function PassView:ReceiveRewardFree()
    -- local rewards = self:GetModel():GetRewardList()
    -- ViewList.BingoPassRewardView:SetRewards(rewards)
    -- ViewList.BingoPassRewardView:SetCloseCallback(this.OnReceiveRewardFinish)
    -- Facade.SendNotification(NotifyName.ShowUI, ViewList.BingoPassRewardView)
    local param = {}
    param.onCloseCallback = function()
        self:OnReceiveRewardFinish() 
    end
    local rewards = self:GetModel():GetRewardList()
    param.rewards = rewards
    Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView,"PassRewardView",param)
end

function PassView:OnExpired()
    self._fsm:GetCurState():Expired(self._fsm)
end

function PassView:CloseSelf()
    if self.closeCallback then
        self.closeCallback()
    end

    Facade.SendNotification(NotifyName.CloseUI,self)
    if not self.skipReopenHallCityView then
        Facade.SendNotification(NotifyName.SceneCity.HomeScene_promotion)
    end

    self.closeCallback = nil
    self.skipReopenHallCityView = nil
end

function PassView:SetCloseCallback(callback)
    self.closeCallback = callback
end

function PassView:SetSkipReopenHallCityView(isSkip)
    self.skipReopenHallCityView = isSkip
end

function PassView:OnActivateGoldenPassPayResult(code)
    if not self.isWattingPurchase then
        return
    end
    self.isWattingPurchase = false
    if code == RET.RET_SUCCESS then
        local payData = ModelList.MainShopModel:GetPayData()
        if PurchaseHelper.IsEditorPurchase() then
 
            self:Purchasing_success()
        else
            if fun.is_null(payData.pid) then
                UIUtil.show_common_popup(9025, true, nil)
                return
            end
            local productId = Csv.GetData("appstorepurchaseconfig",self:GetModel():get_productId(), "product_id")
            if not payData.pid or tostring(payData.pid) == "" then 
                if self.Purchasing_failure then 
                    self:Purchasing_failure()
                end 
            else 
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

function PassView:Purchasing_success()
    self:MutualTaskFinish()
    self:GetModel():SetPayInfo()
    Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView,"PassReceivedView")

    self:InitGoldPassInfo()
end
 
function PassView:Purchasing_failure()
    self:MutualTaskFinish()
end

function PassView:OnRefresh()
    self:Purchasing_success()
end

function PassView:RegisterUIEVent()
    Event.AddListener(EventName.Event_ShortPassView_Refresh, self.OnRefresh, self)
end

function PassView:UnRegisterUIEVent()
    Event.RemoveListener(EventName.Event_ShortPassView_Refresh, self.OnRefresh, self)
end

this.NotifyEnhanceList = 
{
    {notifyName = NotifyName.GamePlayShortPassView.UpdataBingoPassInfo,func = this.OnUpdataBingoPassInfo},
    {notifyName = NotifyName.GamePlayShortPassView.WatchAd,func = this.OnBingoPassWatchAd},
    {notifyName = NotifyName.GamePlayShortPassView.GemUnlockLevel,func = this.OnGemUnlockLevel},
    {notifyName = NotifyName.GamePlayShortPassView.ClaimReward,func = this.OnClaimReward},
    {notifyName = NotifyName.GamePlayShortPassView.ReceiveReward,func = this.OnReceiveReward},
    {notifyName = NotifyName.GamePlayShortPassView.Expired,func = this.OnExpired},

    {notifyName = NotifyName.ShopView.ActivityPayResult, func = this.OnActivateGoldenPassPayResult}
}

return this
