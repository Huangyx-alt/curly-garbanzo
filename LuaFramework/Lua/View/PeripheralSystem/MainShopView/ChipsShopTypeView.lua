local shopTypeBaseView = require "View/PeripheralSystem/MainShopView/ShopTypeBaseView"
local ChipsShopTypeView = shopTypeBaseView:New()
local this = ChipsShopTypeView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_daily_gift",
    "textGiftButton",
    "shopItemScrollView",
    "shopItem",
    "Content",
    "giftIcon",
    "textBoxRewardLevel",
}

local itemView = require "View/PeripheralSystem/MainShopView/ShopItemView/ChipsShopItemView"

function ChipsShopTypeView:Awake()
    self:on_init()
end

function ChipsShopTypeView:CheckDailyRewardExist()
    local isReward = ModelList.PlayerInfoModel.get_cur_daily_info()
    local openLv = Csv.GetData("level_open",12,"openlevel")
    if isReward and  isReward == 1 and ModelList.PlayerInfoModel:GetLevel() >= openLv then
        return true
    end
    return false
end

function ChipsShopTypeView:RefreshView()
    local currVipLv = ModelList.PlayerInfoModel:GetVIP()
    self.textBoxRewardLevel.text = currVipLv
    if self:CheckDailyRewardExist() then
        local information   = ModelList.PlayerInfoModel:GetUserInfo()
        local daily_reward  = self:GetDailyReward(information.level)
        Util.SetUIImageGray(self.btn_daily_gift, false)        
    else
        Util.SetUIImageGray(self.btn_daily_gift, true)        
    end
end

function ChipsShopTypeView:GetDailyReward(id)
    if id ~= nil then
        if not self.daily_reward then
            self.daily_reward = ModelList.FixedActivityModel:GetDailyRewardType()
        end
        if not self.daily_reward then
            self.daily_reward = 1
        end
        if self.daily_reward and self.daily_reward == 2 then
            return Csv.GetData("level", id, "pay_daily_reward")
        else
            return Csv.GetData("level", id, "daily_reward")
        end
    end
end

function ChipsShopTypeView:OnClaimReward()
    local reward = ModelList.PlayerInfoModel:GetRewardItemId()
    local pos = self.giftIcon.transform.position 
    for i = 1, #reward do
        if i == #reward then
            Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,pos,reward[i].id,function()
                Event.Brocast(EventName.Event_currency_change)
            end,nil)
        else
            Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,pos,reward[i].id,function()
            end,nil)
        end
    end
    self:RefreshView()
end


function ChipsShopTypeView:OnDisable()

end

function ChipsShopTypeView:GetItemView()
    return itemView
end

function ChipsShopTypeView:GetItemData()
    local data = ModelList.MainShopModel:GetShopTypeData(BingoBangEntry.mainShopToggleType.Chips)
    return data
end

function ChipsShopTypeView:GetItemNum()
end

function ChipsShopTypeView:GetItemPrefab()
end

function ChipsShopTypeView:on_btn_daily_gift_click()
    if self:CheckDailyRewardExist() then
        Event.Brocast(BingoBangEntry.mainShopViewEvent.ClickReqShopDailyFreeReward , self.daily_reward or 1)
    end
end

this.NotifyList =
{

}

return this