require "State/ShopNormalItemView/ShopNormalItemBaseState"
require "State/ShopNormalItemView/ShopNormalItemOriginalState"
require "State/ShopNormalItemView/ShopNormalItemAvailableState"
require "State/ShopNormalItemView/ShopNormalItemDisableState"
require "State/ShopNormalItemView/ShopNormalItemCDCountDownState"
require "State/ShopNormalItemView/ShopNormalItemStiffState"
require "State/ShopNormalItemView/ShopNormalItemNoAdState"

require "View/CommonView/WatchADUtility"

ShopChildItemBaseView = BaseView:New()
local this = ShopChildItemBaseView

local curBuyShopItem = nil

local _watchADUtility = WatchADUtility:New(AD_EVENTS.AD_EVENTS_SHOP_ITEM)

function ShopChildItemBaseView:New()
    local o = {}
    setmetatable(o,{__index = this})
    return o
end

function ShopChildItemBaseView:RegisterViewEnhance()
    Facade.RegisterViewEnhance(self)
end

function ShopChildItemBaseView:RemoveViewEnhance()
    Facade.RemoveViewEnhance(self)
end

function ShopChildItemBaseView.GetBuyShopItem()
    return curBuyShopItem
end

function ShopChildItemBaseView.ClearCurrentShopItem()
    curBuyShopItem = nil
end

function ShopChildItemBaseView:BuildFsm(fsmName)
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm(fsmName,self,{
        ShopNormalItemOriginalState:New(),
        ShopNormalItemAvailableState:New(),
        ShopNormalItemDisableState:New(),
        ShopNormalItemCDCountDownState:New(),
        ShopNormalItemStiffState:New(),
        ShopNormalItemNoAdState:New(),
    })
    self._fsm:StartFsm("ShopNormalItemOriginalState")
end

function ShopChildItemBaseView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function ShopChildItemBaseView:OnApplicationFocus(focus)
    if focus then
        if self._fsm then
            self._fsm:GetCurState():ResetState(self._fsm)
            self:CheckState(false)
        end
    end
end

function ShopChildItemBaseView:RegisterEvent()
    self._isWatchAD = nil
    Event.AddListener(EventName.Event_ShopDataUpdata,self.EventCallBack,self)
end

function ShopChildItemBaseView:RemoveEvent()
    self._isWatchAD = nil
    Event.RemoveListener(EventName.Event_ShopDataUpdata,self.EventCallBack)
end

function ShopChildItemBaseView:EventCallBack()
    if self._isWatchAD then
        self._isWatchAD = false
        Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,self.go.transform.position,Resource.hintTime,function()
            Event.Brocast(EventName.Event_currency_change)
        end)
    end
    self:UpdateUIInfo()
    self:RefreshItemView()
end

function ShopChildItemBaseView:RefreshItemView()
    local shopData = ModelList.MainShopModel:GetShopDataById(self._shopItem.id)
    if shopData then
        self._shopItem = shopData
        self._fsm:GetCurState():ResetState(self._fsm)
        self:CheckState()
    else
        self:Hide()    
    end
end

function ShopChildItemBaseView:CheckState(isInit)
    if self._shopItem then
        --log.r("===========================>>CheckState " .. self._shopItem.id .. "    " .. self._shopItem.canBuyCount .. "   " .. self._shopItem.nextUnix)
        --self._shopItem.nextUnix = 5000000000
        if self._shopItem.fetchType == ShopFetchType.adType and not SDK.IsRewardedAdReady() then
            -- 广告没有准备好
            self._fsm:GetCurState():Change2NoAd(self._fsm, isInit)
        elseif self._shopItem.canBuyCount == 0 then
            --没有次数了
            self._fsm:GetCurState():Change2Disable(self._fsm, isInit)
        elseif self._shopItem.nextUnix > 0 and os.time() < self._shopItem.nextUnix then
            --正处于cd时间
            self._fsm:GetCurState():Change2CountDown(self._fsm, isInit)
        else
            self._fsm:GetCurState():Change2Available(self._fsm, isInit)
            SDK.ADShow(AD_EVENTS.AD_EVENTS_SHOP_ITEM)
        end
    end
end

function ShopChildItemBaseView:SetAvailable()

end

function ShopChildItemBaseView:SetDisable()

end

function ShopChildItemBaseView:SetCountdDown()

end

function ShopChildItemBaseView:SetNoAds()

end

function ShopChildItemBaseView:DoBuy()
    if self._shopItem.id then
        local shopData = Csv.GetData("shop",self._shopItem.id)
        if shopData then
            --[[
            Facade.SendNotification(NotifyName.ShowUI,ViewList.ShopPurchaseConfirmView,nil,nil,{shopItems = shopData,sure_callBack = function()
                curBuyShopItem = self
                SDK.purchase_click({itemPos = self._shopItem.id,itemType = shopData.item,
                price = shopData.price,count = -1,
                balance = {ModelList.ItemModel.get_coin(),ModelList.ItemModel.get_diamond()}})
                AddLockCountOneStep()
                ModelList.MainShopModel.C2S_RequestBuyItem(self._shopItem.id)
            end,close_callback = function()
                self._fsm:GetCurState():ClearStiff(self._fsm)
            end})
            --]]
            curBuyShopItem = self
            Facade.SendNotification(NotifyName.ShopView.ShopItemRequestBuy,shopData)
        end
    end
end

function ShopChildItemBaseView:ClickReaction()
    if self._shopItem and curBuyShopItem == nil then
        if self._shopItem.fetchType == ShopFetchType.free then
            if self._shopItem.canBuyCount == 0 then
                    
            else
                self:DoBuy()
            end
        elseif self._shopItem.fetchType == ShopFetchType.adType then
            if self._shopItem.canBuyCount == 0 then
            else
                self:CheckAdvert(self._shopItem.id)
            end
        else
            local shopData = Csv.GetData("shop",self._shopItem.id,nil)
            if shopData == nil then
                return
            end
            if shopData.gift_type == 0 or shopData.gift_type == 1 then
                if shopData.pay_type > 0 then
                    local resNum = ModelList.ItemModel.getResourceNumByType(shopData.pay_type)
                    if resNum >= tonumber(shopData.price) then
                        self:DoBuy()
                    else
                        --Facade.SendNotification(NotifyName.Common.PopupDialog, 7002, 1);
                        UIUtil.show_common_popup(7002,true)
                    end
                else
                    self:DoBuy()
                end
            elseif shopData.gift_type == 2 then
                if self._shopItem.canBuyCount == 0 then
                else
                    self:CheckAdvert(self._shopItem.id)
                end
            elseif shopData.gift_type == 3 then
                if self._shopItem.canBuyCount == 0 then
                    
                else
                    self:DoBuy()
                end
            end
        end
    end
end

function ShopChildItemBaseView:CheckAdvert(itemid)
    if _watchADUtility:IsAbleWatchAd() then
        _watchADUtility:WatchVideo(self,self.WatchAdCallback,"shop_freeitem_"..itemid, {shopItemId = self._shopItem.id})
    end 
end

function ShopChildItemBaseView:WatchAdCallback(isBreak)
    if isBreak then
        self:RefreshItemView()
    else
        self._isWatchAD = true
    end
end

function ShopChildItemBaseView:OnTimerCall(sub)
    --[[
    if sub then
        self._remainTime = math.max(0,self._remainTime - 1)
    end
    if self._remainTime <= 0 then
        self:StopTimer()
        --self._fsm:GetCurState():ResetState(self._fsm)
        --self:CheckState()
        ModelList.MainShopModel.C2S_RefreshShopInfo()
    else
        local hour = math.floor(self._remainTime/60/60)
        if hour == 0 then
            self.text_countdown.text = string.format("Come back in \n %sm %ss",math.floor(self._remainTime/60),self._remainTime%60)
        else
            self.text_countdown.text = string.format("Come back in \n %sh %sm",hour, math.floor(self._remainTime/60))
        end
    end
    --]]
end

function ShopChildItemBaseView:StartTimer()
    --[[
    self:StopTimer()
    self._remainTime = math.max(2,self._shopItem.nextUnix - os.time())
    if self._remainTime > 0 then
        self._timer = Timer.New(function()
            self:OnTimerCall(true)
        end,1,self._remainTime)
        self._timer:Start()
    end
    self:OnTimerCall()
    --]]

    self._remainTime = math.max(2,self._shopItem.nextUnix - os.time())
end

function ShopChildItemBaseView:StopTimer()
    --[[
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
    --]]
end

function ShopChildItemBaseView:OnDestroy_late()
    self._remainTime = nil
    self._shopItem = nil
end

function ShopChildItemBaseView:UpdateCountdown()
    if self._remainTime then
        self._remainTime = math.max(0,self._remainTime - 1)
        local hour = math.floor(self._remainTime/60/60)
        if hour == 0 then
            self.text_countdown.text = string.format("Come back in \n %sm %ss",math.floor(self._remainTime/60),self._remainTime%60)
        else
            self.text_countdown.text = string.format("Come back in \n %sh %sm",hour,(math.floor(self._remainTime/60) - (hour *60)) )
        end
        if self._remainTime <= 0 then
            self._remainTime = nil
            ModelList.MainShopModel.C2S_RefreshShopInfo()
       end
    end
    if self._fsm then
        self._fsm:GetCurState():CheckAD(self._fsm)
    end
end

function ShopChildItemBaseView:RefreshUltraBetUI()
    local cfg = Csv.GetData("shop",self._shopItem.id,"ultra_bet")
    if cfg then
        local is_ultra_item = cfg[1] == 1
        fun.set_active(self.ultra_shop_icon, is_ultra_item)
    else
        fun.set_active(self.ultra_shop_icon, false)
    end
end

--设置捆绑道具
function ShopChildItemBaseView:SetBundledIcon(bundledItemData)
	if bundledItemData and bundledItemData[1] and bundledItemData[1] > 0 then
		local discount = self.bundled_shop_icon:Get("discount");
		local freeTip = self.bundled_shop_icon:Get("freeTip");
		local discountTxt = self.bundled_shop_icon:Get("discountTxt");
		local textNum = self.bundled_shop_icon:Get("txt");
		fun.set_active(self.bundled_shop_icon,true);
		local itemData = Csv.GetData("item", bundledItemData[1])
		if itemData ~=nil and  (itemData.result[1] == 23 or itemData.result[1] == 24 or itemData.result[1] == 25) then
			if  itemData.result[2] >=100 then
				fun.set_active(discount,false)
				fun.set_active(freeTip,true)
			else
				fun.set_active(discount,true)
				fun.set_active(freeTip,false)
				local a = itemData.result;
				discountTxt.text =  itemData.result[2]
			end
		else
			fun.set_active(discount,false)
			fun.set_active(freeTip,false)
		end
		
		if itemData ~=nil and itemData.destroy_cd ~= nil and itemData.destroy_cd ~= 0 then
			textNum.text = fun.format_money_reward({id = bundledItemData[1], value = bundledItemData[2]}).."Mins"
		else
			textNum.text = "";
		end
		
	else
		fun.set_active(self.bundled_shop_icon,false);		
	end
end

--判断事发后有礼盒红包在奖励中   
function ShopChildItemBaseView:CheckHaveGiftPackage(shopData)
    if not shopData or not self.LH_Tip then 
        return 
    end 

    if not shopData.club_gift or not shopData.club_gift[1] or shopData.club_gift[1] ==0 then
        fun.set_active(self.LH_Tip,false)
        return 
    end 

    local isClubOpen = ModelList.ClubModel.IsClubOpen()

    if isClubOpen == false  then
        fun.set_active(self.LH_Tip,false)
        return
    end
    
    local itemIconSprite = Csv.GetItemOrResource(shopData.club_gift[1], "icon")
     self.LH_Tip.sprite = AtlasManager:GetSpriteByName("ItemAtlas", itemIconSprite)
    fun.set_active(self.LH_Tip,true )
  
end

--刷新UI
function ShopChildItemBaseView:UpdateUIInfo()
    if self.SetShopItemInfo then
        self:SetShopItemInfo()
    end
end

function ShopChildItemBaseView:IsInPromotion(data)
    --[[undo test code wait delete
    if true then
        return true
    end
    --]]
    if data and data.sale_tag then
        if data.sale_tag ~= 1 then
            return false
        end
    end

    if self._shopItem and self._shopItem.promoBuyCount then
        if self._shopItem.promoBuyCount > 0 then
            return true
        else
            return false
        end
    else
        return false
    end
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.UltraBet.ActivityStart, func = this.RefreshUltraBetUI},
    {notifyName = NotifyName.UltraBet.ActivityEnd, func = this.RefreshUltraBetUI},
    {notifyName = NotifyName.UltraBet.RewardReceiveFinish, func = this.RefreshUltraBetUI},
}