--local BingoPassBaseState = require "View/Bingopass/states/BingoPassBaseState"
local BingoPassOriginalState = require "View/Bingopass/states/BingoPassOriginalState"
local BingoPassEnterState = require "View/Bingopass/states/BingoPassEnterState"
local BingoPassExitState = require "View/Bingopass/states/BingoPassExitState"
local BingoPassStiffState = require "View/Bingopass/states/BingoPassStiffState"
local BingoPassExpiredState = require "View/Bingopass/states/BingoPassExpiredState"

require "View/CommonView/RemainTimeCountDown"

local BingoPassView = BaseView:New("BingoPassView","BingoBangPassAtlas")
local this = BingoPassView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
local cacheItemList = nil
local itemIndex = 0

local itemHeight = 335
local initialOffset = 200
local showItemCount = 4
local totalItemCount = 157

local content_height = nil

local cacheLevel = nil

local remainTimeCountDown = RemainTimeCountDown:New()

local bottomBonusItem = nil

this.auto_bind_ui_items = {
    "content",
    "item",
    "slider",
    "btn_help",
    "slider_flash",
    "btn_activate",
    "btn_close",
    --"btn_bigowin",
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
    "bottomItem",
    "lpFlash",
    "bigowinDec",
    "btn_collect_all",
    "bottom",
}

function GetBingoPassFlashPos()
    if fun.is_not_null(this.lpFlash) then
        return this.lpFlash.position
    end
end

function BingoPassView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("BingoPassView",self,{
        BingoPassOriginalState:New(),
        BingoPassEnterState:New(),
        BingoPassExitState:New(),
        BingoPassStiffState:New(),
        BingoPassExpiredState:New()
    })
    self._fsm:StartFsm("BingoPassOriginalState")
end

function BingoPassView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function BingoPassView:HideCoverageEntity()
    self:NotifyHideCoverageEntity()
end

function BingoPassView:ShowCoverageEntity()
    self:NotifyShowCoverageEntity()
end

function BingoPassView:GetRewardLevel()
    if ModelList.BingopassModel:IsAnyPayment() then
        return ModelList.BingopassModel:GetLevel()
    else
        local curLevel = ModelList.BingopassModel:GetLevel()
        local temLevel = curLevel
        while true do
            local passData = Csv.GetData("season_pass",math.max(1,temLevel),"free_reward")
            if not passData then
                break
            end
            if passData[1] and passData[1] > 0 then
                break
            end
            temLevel = math.max(1,temLevel - 1)
        end
        return (ModelList.BingopassModel:IsFreeReceived(temLevel) 
        and {curLevel} 
        or {temLevel})[1]
    end
end

function BingoPassView:Awake(obj)
    self:on_init()
end

function BingoPassView:OnEnable()
    ModelList.GuideModel:OpenUI("BingoPassView")
    Facade.RegisterView(self)
    showItemCount = math.ceil(self.scrollView.transform.rect.height / itemHeight)
    totalItemCount = #Csv.season_pass - 1 --最终奖励不放一起，独立开来了
    content_height = itemHeight * totalItemCount + initialOffset
    local itemView = require "View/Bingopass/BingoPassItem"
    cacheItemList = {}
    local y = -initialOffset
    local curLevel = math.max(0,math.min(self:GetRewardLevel(),totalItemCount - showItemCount) - 1)
    y = y - itemHeight * curLevel
    self.content.transform.anchoredPosition = Vector2.New(0,math.abs(itemHeight * curLevel))
    for i = 1, showItemCount + 2 do
        if curLevel + i <= totalItemCount then
            local go = fun.get_instance(self.item.transform,self.content)
            fun.set_gameobject_pos(go,0,y,0,true)
            fun.set_active(go.transform,true)
            local view = itemView:New(curLevel + i )
            view:SkipLoadShow(go)
            table.insert(cacheItemList,view)
            self:SetMaskItem(view,y)
            y = y - itemHeight
        end
    end
    
    local bottomSize = fun.get_rect_delta_size(self.bottom)
    content_height = content_height + bottomSize.y
    
    --self.cover_mask:SetSiblingIndex(self.content.transform.childCount - 1)

    self.content.transform.sizeDelta = Vector2.New(0,content_height)
    self.slider.transform.sizeDelta = Vector2.New(self.slider.transform.sizeDelta.x,content_height - bottomSize.y)
    self.slider.minValue = 0
    self.slider.maxValue = content_height - bottomSize.y
    
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
                        self:SetMaskItem(itemMaxPos)
                    else
                        itemMaxPos:SetActive(false)
                    end
                end
            end
        end
    end)

    local bottomItem = require "View/Bingopass/BingoPassBottomItem"
    bottomBonusItem = bottomItem:New(totalItemCount + 1)
    bottomBonusItem:SetMaxLevel(totalItemCount)
    bottomBonusItem:SkipLoadShow(self.bottomItem)

    self:BuildFsm()
    self._fsm:GetCurState():PlayEnter(self._fsm)

    remainTimeCountDown:StartCountDown(CountDownType.cdt2,ModelList.BingopassModel:GetRemainTime(),self.text_remainTime,function()
        self._fsm:GetCurState():Expired(self._fsm)
    end)
    self:UpdateCollectButton()
   -- self:InitbigowinDec()
end

function BingoPassView:OnDisable()
    if CityHomeScene then
        CityHomeScene:SetEnterHallFromUI(true)
    end
    Facade.RemoveView(self)
    self:DisposeFsm()
    cacheItemList = nil
    itemIndex = nil
    content_height = nil
    cacheLevel = nil
    bottomBonusItem = nil
    remainTimeCountDown:StopCountDown()
    if self._tweener then
        self._tweener:Kill()
        self._tweener = nil
    end
end

function BingoPassView:SetMaskItem(item, posY)
    if item:IsTopLockItem() then
        local y = posY or item:GetPosY()
        fun.set_gameobject_pos(self.crossLine.gameObject,0,y + 30,0,true)
        fun.set_gameobject_pos(self.cover_mask.gameObject,0, y,0,true)
        self.cover_mask.sizeDelta = Vector2.New(930,content_height - math.abs(item:GetPosY()))
    end
end

function BingoPassView:SetExp(isFirst)
    local level = ModelList.BingopassModel:GetLevel()
    local level2 = level + 1
    local data = Csv.GetData("season_pass",level)
    local data2 = Csv.GetData("season_pass",level2)
    local exp = ModelList.BingopassModel:GetExp()
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
    local offset = math.max(0,ModelList.BingopassModel:GetExpCount() % data.sum_exp) --math.max(0,ModelList.BingopassModel:GetExpCount() - data.sum_exp)
    if ModelList.BingopassModel:GetLevel() > 0 then
        local source = self.slider.value
        --local target = initialOffset + math.max(0,level) * itemHeight + itemHeight / 2 + (offset / nextLvExp) * itemHeight
        local target = initialOffset + math.max(0,level) * itemHeight + (offset / nextLvExp) * itemHeight
        if isFirst then
            source = 0
        end
        Anim.do_smooth_float_update(source,target,0.5,function(value)
            self.slider.value = value
        end,function(value)

        end):SetEase(DG.Tweening.Ease.InOutSine)

        --fun.set_gameobject_pos(self.particle_slider.gameObject,0,-1 * (target - 300),0,true)
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

    local isPayAccomplish = ModelList.BingopassModel:IsPayAccomplish()
    fun.set_active(self.btn_activate.transform, not isPayAccomplish)
    --fun.set_active(self.accomplish.transform, isPayAccomplish)

    if level2 == 1 then
        --fun.set_active(self.particle_slider,false)
        fun.set_active(self.crossLine,true)
        fun.set_active(self.cover_mask,false)
    elseif level == totalItemCount then
        --fun.set_active(self.particle_slider,false)
        fun.set_active(self.crossLine,false)
        fun.set_active(self.cover_mask,false)
    else
        --fun.set_active(self.particle_slider,true)
        fun.set_active(self.crossLine,true)
        fun.set_active(self.cover_mask,false)
    end
end

function BingoPassView:RecursionShowExpAnimation(level,toLevel,exp,toExp)
    local curLevel = ModelList.BingopassModel:GetLevel()
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
        local data = Csv.GetData("season_pass",cacheLevel)
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

function BingoPassView:PlayBingoPassEnter()
    AnimatorPlayHelper.Play(self.anima,{"start","BingoPassView_start1"},false,function()
        self._fsm:GetCurState():Complete(self._fsm)
    end)
    UISound.play("bingopass_open")
end

function BingoPassView:PlayBingoPassExit()
    AnimatorPlayHelper.Play(self.anima,{"end","BingoPassView_end"},false,function()
        self:CloseSelf()
    end)
end

function BingoPassView:DisableDragAbility()
    self.scrollView.enabled = false
end

function BingoPassView:EnableDragAbility()
    self.scrollView.enabled = true
end

function BingoPassView:on_btn_help_click()
    Facade.SendNotification(NotifyName.ShowUI,ViewList.BingoPassHelperView)
end

function BingoPassView:on_btn_activate_click()
    self._fsm:GetCurState():Purchase(self._fsm)
end

function BingoPassView:OnShowPurchaseView()
    --local level = ModelList.BingopassModel:GetLevel()
    --local targetLevel = Csv.GetControlByName("season_pass_level")[1][1]
    --if level > targetLevel then
        Facade.SendNotification(NotifyName.ShowUI,ViewList.BingoPassPurchaseView)
    --else
    --    Facade.SendNotification(NotifyName.ShowUI, ViewList.BingoPassRecommendView)
    --    ViewList.BingoPassRecommendView:SetCloseCallback(this.AfterRecommendClose)
    --end
end

function BingoPassView.AfterRecommendClose(closeMethod)
    if closeMethod == ViewList.BingoPassRecommendView.CloseMethod.normal then
        Facade.SendNotification(NotifyName.ShowUI,ViewList.BingoPassPurchaseView)
    elseif closeMethod == ViewList.BingoPassRecommendView.CloseMethod.paySucceed then
        --购买成功后就不弹购买窗口了
    else
        Facade.SendNotification(NotifyName.ShowUI,ViewList.BingoPassPurchaseView)
    end
end

function BingoPassView:on_btn_close_click()
    self._fsm:GetCurState():PlayExit(self._fsm)
end

-- function BingoPassView:on_btn_bigowin_click()
--     fun.set_active(self.bigowinDec.transform.parent,true)
--     LuaTimer:SetDelayFunction(3, function()
--         fun.set_active(self.bigowinDec.transform.parent,false)
--     end) 
-- end


function BingoPassView.OnUpdataBingoPassInfo()
    this:UpdateCollectButton()
    if cacheItemList then
        this:SetExp()
        for key, value in pairs(cacheItemList) do
            value:RefreshInfo()
            this:SetMaskItem(value)
        end
        bottomBonusItem:RefreshInfo()
        this._fsm:GetCurState():Complete(this._fsm)
        
        --移动到中心
        --local curLevel = math.max(0,math.min(this:GetRewardLevel(), totalItemCount - showItemCount) - 1)
        --local originPos = fun.get_rect_anchored_position(this.content)
        --local originPosX, originPosY = originPos.x, originPos.y
        --local targetY = math.abs(itemHeight * curLevel)
        --if this.contentAnim then
        --    this.animF:Kill()
        --end
        --this.contentAnim = Anim.do_smooth_float_update(originPosY, targetY, 0.5, function(tempY)
        --    fun.set_rect_anchored_position(this.content, originPosX, tempY)
        --end, function()
        --    fun.set_rect_anchored_position(this.content, originPosX, targetY)
        --    this.contentAnim:Kill()
        --    this.contentAnim = nil
        --end)
    end
end

function BingoPassView.OnBingoPassWatchAd(passItem)
    this._fsm:GetCurState():BingoPassWatchAd(this._fsm,passItem)
end

function BingoPassView.OnGemUnlockLevel(passItem)
    this._fsm:GetCurState():GemUnlockLevel(this._fsm,passItem)
end

function BingoPassView.OnClaimReward(passItem)
    this._fsm:GetCurState():ClaimReward(this._fsm,passItem)
end

function BingoPassView.OnReceiveReward()
    if ModelList.BingopassModel:IsAnyPayment() then
        this:ReceiveRewardPaid()
    else
        this:ReceiveRewardFree()
    end
end

function BingoPassView.OnReceiveRewardFinish()
    Invoke(function()
        this:OnUpdataBingoPassInfo()
        this:UpdateCollectButton()
    end, 1.5)
end

function BingoPassView:ReceiveRewardPaid()
    local rewards = ModelList.BingopassModel:GetRewardList()
    Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,rewards,function()
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.hide,ClaimRewardViewType.CollectReward)
        this.OnReceiveRewardFinish()
    end,nil,nil,true)
end

function BingoPassView:ReceiveRewardFree()
    local rewards = ModelList.BingopassModel:GetRewardList()
    ViewList.BingoPassRewardView:SetRewards(rewards)
    ViewList.BingoPassRewardView:SetCloseCallback(this.OnReceiveRewardFinish)
    Facade.SendNotification(NotifyName.ShowUI, ViewList.BingoPassRewardView)
end

function BingoPassView.OnExpired()
    this._fsm:GetCurState():Expired(this._fsm)
end

function BingoPassView:CloseSelf()
    if self.closeCallback then
        self.closeCallback()
    end

    Facade.SendNotification(NotifyName.CloseUI,this)
    if not self.skipReopenHallCityView then
        Facade.SendNotification(NotifyName.SceneCity.HomeScene_promotion)
    end

    self.closeCallback = nil
    self.skipReopenHallCityView = nil
end

function BingoPassView:SetCloseCallback(callback)
    self.closeCallback = callback
end

function BingoPassView:SetSkipReopenHallCityView(isSkip)
    self.skipReopenHallCityView = isSkip
end

function BingoPassView:on_btn_collect_all_click()
    this._fsm:GetCurState():ClaimAllReward(this._fsm)
end

function BingoPassView:OnReqPassAllReward()
    AddLockCountOneStep()
    ModelList.BingopassModel:C2S_RequestClaimReward(0,PassRewardType.All)
end


function BingoPassView:UpdateCollectButton()
    local hasWaitGetReward, totalRewardCount = ModelList.BingopassModel:CheckWaitGetReward()
    log.log("pass数据检查 全部按钮领取状态 hasWaitGetReward" , hasWaitGetReward)
    if hasWaitGetReward and totalRewardCount> 1 then
        fun.set_active(self.btn_collect_all, true)
    else
        fun.set_active(self.btn_collect_all, false)
    end
end

function BingoPassView.UpdateCollectAllButton()
    this:UpdateCollectButton()
end

this.NotifyList = 
{
    {notifyName = NotifyName.BingoPass.UpdataBingoPassInfo,func = this.OnUpdataBingoPassInfo},
    {notifyName = NotifyName.BingoPass.WatchAd,func = this.OnBingoPassWatchAd},
    {notifyName = NotifyName.BingoPass.GemUnlockLevel,func = this.OnGemUnlockLevel},
    {notifyName = NotifyName.BingoPass.ClaimReward,func = this.OnClaimReward},
    {notifyName = NotifyName.BingoPass.ReceiveReward,func = this.OnReceiveReward},
    {notifyName = NotifyName.BingoPass.Expired,func = this.OnExpired},
    {notifyName = NotifyName.BingoPass.UpdateCollectAllButton,func = this.UpdateCollectAllButton},
}

return this