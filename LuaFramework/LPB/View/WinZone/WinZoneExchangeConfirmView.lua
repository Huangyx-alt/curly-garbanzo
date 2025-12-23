--local Const = require "View/WinZone/WinZoneConst"
--local ItemView1 = require "View/WinZone/WinZoneExchangeConfirmItem1"
local ItemView2 = require "View/WinZone/WinZoneExchangeConfirmItem2"

local WinZoneExchangeConfirmView = BaseDialogView:New("WinZoneExchangeConfirmView") --undo 图集
local this = WinZoneExchangeConfirmView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

local item_cache_list = nil
local itemList1 = nil
local itemList2 = nil

this.auto_bind_ui_items = {
    "btn_sure",
    "btn_close",
    "text_title",
    "Content",
    "purchase_item",
    "rewardtxt2",
    "rewardtxt1",
    "rewardicon1",
    "rewardicon2",
    "text_price",
    "waitting",
    "anima"
}

function WinZoneExchangeConfirmView:New()
    local o = {}
    setmetatable(o, {__index = self})
    return o
end

function WinZoneExchangeConfirmView:Awake()
    self:on_init()
end

function WinZoneExchangeConfirmView:OnEnable(shopId)
    Facade.RegisterViewEnhance(self)
    self.data = Csv.GetData("shop",shopId)
    self:InitView()

    if fun.is_not_null(self.anima) then
        local task = function()
            AnimatorPlayHelper.Play(self.anima, {"start", "WinZoneExchangeConfirmView_start"}, false, function()
                self:MutualTaskFinish()
            end)
        end

        self:DoMutualTask(task)
    end
end

function WinZoneExchangeConfirmView:on_after_bind_ref()
    --self:InitView()
end

function WinZoneExchangeConfirmView:InitView()
    if self.data then
        self.text_price.text = self.data.price
        itemList1 = {}
        itemList2 = {}
        self.text_title.text = self.data.description
        if self.data.random_range then
            local iconName = Csv.GetItemOrResource(self.data.random_range[1][1], "more_icon")
            self.rewardicon1.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
            local num1 = self.data.random_range[1][2]
            local num2 = self.data.random_range[1][3] or num1
            if num1 == num2 then
                self.rewardtxt1.text = fun.format_number(num1)
            else
                self.rewardtxt1.text = fun.format_number(num1) .. "-" .. fun.format_number(num2)
            end

            local iconName = Csv.GetItemOrResource(self.data.random_range[2][1], "more_icon")
            self.rewardicon2.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
            local num1 = self.data.random_range[2][2]
            local num2 = self.data.random_range[2][3] or num1
            if num1 == num2 then
                self.rewardtxt2.text = fun.format_number(num1)
            else
                self.rewardtxt2.text = fun.format_number(num1) .. "-" .. fun.format_number(num2)
            end
        end

        if self.data.random_bonus_range then
            for i, v in ipairs(self.data.random_bonus_range) do
                local item = self:CreateItem2(v, i)
                table.insert(itemList2, item)
            end
        end
    end
end


function WinZoneExchangeConfirmView:CreateItem2(info, index)
    local go = fun.get_instance(self.purchase_item, self.Content)
    local item = ItemView2:New()
    item:SetData(info)
    item:SkipLoadShow(go)
    fun.set_active(go, true)
    return item
end

function WinZoneExchangeConfirmView:OnDisable()
    Facade.RemoveViewEnhance(self)
    item_cache_list = nil
    if self.close_callback then
        self.close_callback()
        self.close_callback = nil
    end

    itemList1 = nil
    itemList2 = nil
    self.preView = nil
    self.closeCb = nil
end

function WinZoneExchangeConfirmView:SetData(data)
    self.data = data
end

function WinZoneExchangeConfirmView:SetConfirmCallback(preView)
    self.preView =preView
end

function WinZoneExchangeConfirmView:SetCloseCallback(cb)
    self.closeCb = cb
end

function WinZoneExchangeConfirmView:on_btn_close_click()
    self:CloseSelf()
end

function WinZoneExchangeConfirmView:CloseSelf()
    if fun.is_not_null(self.anima) then
        local task = function()
            AnimatorPlayHelper.Play(self.anima, {"end", "WinZoneExchangeConfirmView_end"}, false, function()
                self:MutualTaskFinish()
                Facade.SendNotification(NotifyName.CloseUI, self)
            end)
        end

        self:DoMutualTask(task)
    else
        Facade.SendNotification(NotifyName.CloseUI, self)
    end
end

function WinZoneExchangeConfirmView:on_btn_sure_click()
    if self.preView then
        self.preView:item_rule_click_callBack()
    end
    --fun.set_active(self.waitting, true)
end

function WinZoneExchangeConfirmView:BuySucceedReshpone(shopItemId)
end

function WinZoneExchangeConfirmView:BuyFailureReshone(shopItemId)
    fun.set_active(self.waitting, false)
end

function WinZoneExchangeConfirmView:ExchangeReshone(data)
    fun.set_active(self.waitting, false)
    if data and #data.reward > 0 then

    end
end

this.NotifyEnhanceList = {
    {notifyName = NotifyName.ShopView.BuySucceedReshpone, func = this.BuySucceedReshpone},
    {notifyName = NotifyName.ShopView.BuyFailureReshone, func = this.BuyFailureReshone},
}

return this