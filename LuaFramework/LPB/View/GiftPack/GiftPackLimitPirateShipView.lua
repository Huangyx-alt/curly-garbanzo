local GiftPackBaseView = require("View.GiftPack.GiftPackBaseView")
local GiftPackLimitPirateShipView = GiftPackBaseView:New("GiftPackLimitPirateShipViewInMain", "GiftPack_HotFixPack_GiftPackLimitPirateShip_AutoAtlasInMain")
local this = GiftPackLimitPirateShipView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local data = nil
local product_list = {}
local click_interval = 0.5

local itemList = {}
local vipExpList = {}

local buttonEnableList = {}
local lastClickTime = 0
local remainTimeCountDown
local itemListPos = 
{
    Up = 1,
    Middle = 2,
    Down = 3,
}

this.auto_bind_ui_items = {
    "left_time_txt",
    "btn_close",
    "btn_up_buy",
    "bg1",
    "img_soldout",
    "GiftPackLimitPirateShipView",
    "onlyobj",
    "txt_soldcout",
    "txt_soldnum",
    "txt_soldnum2",
    "txt_soldnum5",  
}

function GiftPackLimitPirateShipView:Awake(obj)
    self:on_init()
    self._isInit = true
    --- 修复部分机型首次进入界面不显示问题
    if self._reshowAfterInit then
        self._reshowAfterInit = nil
        self:ShowDetailGift()
    end
end

function GiftPackLimitPirateShipView:OnEnable()
    self:BuildFsm(self)
    self:Bi_Tracker()
    UISound.play("sale_ultrabet")
end

function GiftPackLimitPirateShipView:OnDisable()
    for k , v in pairs(itemList) do
        for z, w in pairs(v) do
            if w then
                Destroy(w)
            end
        end
    end
    buttonEnableList = {}
    itemList = {}
    lastClickTime = 0
    vipExpList = {}
    self:ClearCountDown()
end

function GiftPackLimitPirateShipView:ClearCountDown()
    if remainTimeCountDown then
        remainTimeCountDown:StopCountDown()
        remainTimeCountDown = nil
    end
end

function GiftPackLimitPirateShipView:CloseUIShiny(obj)
    local uishiny = fun.get_component(obj, "UIShiny")
    if uishiny then
        uishiny.enabled = false
    end
end

function GiftPackLimitPirateShipView:GetLastClickTime()
    return lastClickTime or 0
end

function GiftPackLimitPirateShipView:on_btn_up_buy_click()
    if self._fsm:GetCurName() ~= "GiftPackEnterState" then
        return
    end

    if buttonEnableList[itemListPos.Up] then
        local click_time = UnityEngine.Time.time
        if click_time - self:GetLastClickTime() > click_interval then
            lastClickTime = UnityEngine.Time.time
            ModelList.GiftPackModel:ReqEditorBuySucess(data.pId, product_list[1])
        end
    else
        UIUtil.show_common_popup(8020, true)
    end
end

function GiftPackLimitPirateShipView:on_btn_buy2_click()
    if self._fsm:GetCurName() ~= "GiftPackEnterState" then
        return
    end

    if buttonEnableList[itemListPos.Middle] then
        local click_time = UnityEngine.Time.time
        if click_time - self:GetLastClickTime() > click_interval then
            lastClickTime = UnityEngine.Time.time
            ModelList.GiftPackModel:ReqEditorBuySucess(data.pId, product_list[2])
        end
    else
        UIUtil.show_common_popup(8020, true)
    end
end

function GiftPackLimitPirateShipView:SetExtra(extraUI, extraParent, bonus)
    if not bonus or bonus == 0 then
        fun.set_active(extraParent, false)
    else
        fun.set_active(extraParent, true)
        extraUI.text = string.format("%s<size=55>%s</size>", bonus, "%")
    end
end

function GiftPackLimitPirateShipView:SetItemGrid(itemId, itemNum, itemGrid)
    local refItem = fun.get_component(itemGrid, fun.REFER)
    local icon = refItem:Get("icon")
    local textNum = refItem:Get("textNum")
    local iconKey = "more_icon"
    if itemId > 1000 then
        local itemData = Csv.GetData("item", itemId)
        if itemData and itemData.item_type == ItemType.rofy then
            iconKey = "more_icon"
        else 
            iconKey = "icon"
        end 
    end
    local iconName = Csv.GetItemOrResource(itemId, iconKey)
    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
    textNum.text = fun.format_money_reward_v2({id = itemId, value = itemNum, type = "kmb"})
end

function GiftPackLimitPirateShipView:ShowItemGrid()
    data = ModelList.GiftPackModel:GetShowGiftPack()
    self:CollectProduct(data.pId, data.giftInfo)
    itemList = itemList or {}
    vipExpList = vipExpList or {}
    self:HideGridItem()
    self:SetItem(self.bg1, product_list[1], itemListPos.Up, self.btn_up_buy) 
    buttonEnableList = {}
    self:SetButton(self.btn_up_buy, product_list[1], itemListPos.Up,data.giftInfo[1].canBuyCount) 
    self:SetLeftTime(data.giftInfo[1].expireTime)
    self:SetSellInfo(product_list[1], data.giftInfo[1].canBuyCount)

    if(data.giftInfo[1].canBuyCount > 0)then
        fun.set_active(self.onlyobj, true)
        fun.set_active(self.img_soldout, false)
    else
        fun.set_active(self.onlyobj, false)
        fun.set_active(self.img_soldout, true)
    end
end

-- 礼包中间需要突出显示当前礼包的剩余数量
-- 【当剩余数量大于等于50%时显示为绿色；
-- 当剩余数量大于等于20%时显示为黄色；
-- 当剩余数量小于20%时显示为红色】
-- **字体跟边框颜色不一，就不用富文本了，直接添加节点处理**
function GiftPackLimitPirateShipView:SetSellInfo(id, buyCount)
    local xls = Csv.GetData("pop_up", id)
    local num = buyCount
    local count = xls.sell_number
    self:SetCanBuyCount(count)
    local strCout = tostring(buyCount)
    if(num / count > 0.5)then 
        self.txt_soldnum.text = ""
        self.txt_soldnum2.text = ""
        self.txt_soldnum5.text = strCout
    elseif(num / count > 0.2)then 
        self.txt_soldnum.text = ""
        self.txt_soldnum2.text = strCout
        self.txt_soldnum5.text = ""
    else
        self.txt_soldnum.text = strCout
        self.txt_soldnum2.text = ""
        self.txt_soldnum5.text = ""
    end
end

function GiftPackLimitPirateShipView:SetItem(itemUI, id, pos, btn)
    local itemParent = itemUI:Get("itemParent")
    local textExtra = itemUI:Get("textExtra")
    local bl_buy_txt = itemUI:Get("bl_buy_txt")
    local textVip = itemUI:Get("textVip")
    local textVip = itemUI:Get("textVip")
    local item = itemUI:Get("item")
    local extra = itemUI:Get("extra")
    local xls = Csv.GetData("pop_up", id)

    bl_buy_txt.text = "$" .. xls.price
    itemList[pos] = itemList[pos] or  {}
    for k, v in pairs(xls.item_description) do
        local itemId = tonumber(v[1])
        local itemNum = v[2]
        if itemId ~= Resource.vipExp then
            local itemGrid = self:GetItemGrid(pos, k, item, itemParent)
            fun.set_active(itemGrid, true)
            self:SetItemGrid(itemId, itemNum, itemGrid)
            itemList[pos][k] = itemGrid
        else
            textVip.text = fun.format_money_reward({id = itemId, value = itemNum})
            vipExpList[pos] = textVip
        end
    end
    self:SetExtra(textExtra, extra, xls.bonus)
end

function GiftPackLimitPirateShipView:SetCanBuyCount(count)
   self.txt_soldnum.text = tostring(count)
end

function GiftPackLimitPirateShipView:GetItemGrid(pos, index, prefab, parent)
    if itemList[pos] and itemList[pos][index] then
        return itemList[pos][index]
    end
    local itemGrid = fun.get_instance(prefab, parent)
    return itemGrid
end

function GiftPackLimitPirateShipView:HideGridItem()
    for k, v in pairs(itemList) do
        for z, w in pairs(v) do
            if w then
                fun.set_active(w, false)
            end
        end
    end
end

function GiftPackLimitPirateShipView:ShowDetailGift()
    if self._isInit then
        self:ShowItemGrid()
    else
        self._reshowAfterInit = true
    end
end

function GiftPackLimitPirateShipView:SetButton(button, id, pos)
    local data = ModelList.GiftPackModel:GetGiftById(id)
    buttonEnableList[pos] = true
    if not data or data.canBuyCount <= 0 then
        buttonEnableList[pos] = false
        self:CloseUIShiny(button)
        Util.SetUIImageGray(button, true)
    elseif self:OpenUIShiny(button) then
        Util.SetUIImageGray(button, false)
    end
end

function GiftPackLimitPirateShipView:SetLeftTime(endTimeStamp)
    local start_time = ModelList.PlayerInfoModel.get_cur_server_time()
    local endTime = endTimeStamp - start_time
    if not remainTimeCountDown then
        remainTimeCountDown = RemainTimeCountDown:New()
    end
    remainTimeCountDown:StartCountDown(CountDownType.cdt2, endTime, self.left_time_txt, function()
        self:ClosePackView()
        Event.Brocast(EventName.Event_Gift_Update)
    end)
end

function GiftPackLimitPirateShipView:CollectProduct(pId, giftInfo)
    product_list = {}
    for _, v in pairs(Csv.pop_up) do
        if pId == v.gift_id then
            for i = 1, #giftInfo do
                if giftInfo[i].id == _ then
                    table.insert(product_list, v.id)
                    break
                end
            end
        end
    end
    table.sort(product_list)
end

function GiftPackLimitPirateShipView:CloseFunc()
    Facade.SendNotification(NotifyName.HideDialog, self)
end

function GiftPackLimitPirateShipView:ClosePackView()
    if self._fsm:GetCurName() == "GiftPackShowState" then
        return
    end

    self:ClearCountDown()
    Facade.SendNotification(NotifyName.HideUI, self)
    ModelList.GiftPackModel:CloseView()
end

function GiftPackLimitPirateShipView:on_btn_close_click()
    self:ClosePackView()
end

function GiftPackLimitPirateShipView:OnBuySuccess(needClose, itemData)
    self:ChangeState(self, "GiftPackShowState", itemData)
end

function GiftPackLimitPirateShipView:GetGiftPos(id)
    if id == product_list[1] then
        return self:GetItemPos(itemListPos.Up)
    elseif id == product_list[2] then
        return self:GetItemPos(itemListPos.Middle)
    else
        return self:GetItemPos(itemListPos.Down)
    end
end

function GiftPackLimitPirateShipView:GetItemPos(pos)
    local posTable ={}
    for k, v in pairs(itemList[pos]) do
        table.insert(posTable, v.transform.position)
    end
    table.insert(posTable, vipExpList[pos].transform.position)
    return unpack(posTable)
end

return this