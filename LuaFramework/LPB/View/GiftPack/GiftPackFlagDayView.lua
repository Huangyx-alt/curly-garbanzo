local GiftPackBaseView = require("View.GiftPack.GiftPackBaseView")
local GiftPackFlagDayView = GiftPackBaseView:New('GiftPackFlagDayView', "GiftPackFlagDayViewAtlas")
local this = GiftPackFlagDayView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local data = nil
local product_list = {}
local click_interval = 0.5

local itemList = {}
local vipExpList = {}

local buttonEnableList = {}
local clickTimeList = 0
local itemListPos = 
{
    Up = 1,
    Middle = 2,
    Down = 3,
}

this.auto_bind_ui_items = {
    "left_time_txt",
    "GiftPackFlagDayView",
    "btn_close",
    "btn_buy1",
    "btn_buy2",
    "bg1",
    "bg2",
    -- "bg3",
}

local remainTimeCountDown = RemainTimeCountDown:New()

function GiftPackFlagDayView:Awake(obj)
    self:on_init()
end

function GiftPackFlagDayView:OnEnable()
    self:BuildFsm(self)
    self:Bi_Tracker()
    UISound.play("sale_flagday")
end

function GiftPackFlagDayView:OnDisable()
    for k , v in pairs(itemList) do
        for z, w in pairs(v) do
            if w then
                Destroy(w)
            end
        end
    end
    buttonEnableList = {}
    itemList = {}
    clickTimeList = 0
    vipExpList = {}
    self:ClearCountDown()
    --Event.Brocast(Notes.CARD_COLLIDER_OPEN, true)
end

function GiftPackFlagDayView:ClearCountDown()
    if remainTimeCountDown then
        remainTimeCountDown:StopCountDown()
        remainTimeCountDown = nil
    end
end

function GiftPackFlagDayView:CloseUIShiny(obj)
    local uishiny = fun.get_component(obj,"UIShiny")
    if uishiny then
        uishiny.enabled = false
    end
end

function GiftPackFlagDayView:on_btn_buy1_click()
    if self._fsm:GetCurName() ~= "GiftPackEnterState" then return end

    if buttonEnableList[itemListPos.Up] then
        local click_time = UnityEngine.Time.time
        if click_time - self:GetLastClickTime(itemListPos.Up) > click_interval then
            clickTimeList = UnityEngine.Time.time
            ModelList.GiftPackModel:ReqEditorBuySucess(data.pId, product_list[1])
        end
    else
        log.e  ("1111")
        UIUtil.show_common_popup(8020,true)
    end
end

function GiftPackFlagDayView:GetLastClickTime(pos)
    return clickTimeList or 0
end

function GiftPackFlagDayView:on_btn_buy2_click()
    if self._fsm:GetCurName() ~= "GiftPackEnterState" then return end
    if buttonEnableList[itemListPos.Middle] then
        local click_time = UnityEngine.Time.time
        if click_time - self:GetLastClickTime(itemListPos.Middle) > click_interval then
            clickTimeList = UnityEngine.Time.time
            ModelList.GiftPackModel:ReqEditorBuySucess(data.pId, product_list[2])
        end
    else
        log.e  ("1111")
        UIUtil.show_common_popup(8020,true)
    end
end

-- function GiftPackFlagDayView:on_btn_buy3_click()
--     if this._fsm:GetCurName() ~= "GiftPackEnterState" then return end
--     if buttonEnableList[itemListPos.Down] then
--         local click_time = UnityEngine.Time.time
--         if click_time - self:GetLastClickTime(itemListPos.Down) > click_interval then
--             clickTimeList = UnityEngine.Time.time
--             ModelList.GiftPackModel:ReqEditorBuySucess(data.pId, product_list[3])
--         end
--     else
--         log.e  ("1111")
--         UIUtil.show_common_popup(8020,true)
--     end
-- end

function GiftPackFlagDayView:SetExtra(extraUI,extraParent , bonus)
    if not bonus or bonus == 0 then
        fun.set_active(extraParent, false)
    else
        fun.set_active(extraParent, true)
        extraUI.text = string.format("%s<size=55>%s</size>",bonus , "%")
    end
end

function GiftPackFlagDayView:SetItemGrid(itemId, itemNum , itemGrid)
    local refItem = fun.get_component(itemGrid , fun.REFER)
    local icon = refItem:Get("icon")
    local textNum = refItem:Get("textNum")
    local iconName = Csv.GetItemOrResource(itemId, "more_icon")
    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
    textNum.text = fun.format_money_reward({id = itemId, value = itemNum})
end

function GiftPackFlagDayView:ShowItemGrid()
    data = ModelList.GiftPackModel:GetShowGiftPack()
    self:CollectProduct(data.pId,data.giftInfo)
    itemList = itemList or {}
    vipExpList = vipExpList or {}
    self:HideGridItem()
    self:SetItem(self.bg1,product_list[1],itemListPos.Up, self.btn_buy1)
    self:SetItem(self.bg2,product_list[2],itemListPos.Middle , self.btn_buy2)
    -- self:SetItem(self.bg3,product_list[3],itemListPos.Down,  self.btn_buy3)

    buttonEnableList = {}
    self:SetButton(self.btn_buy1,product_list[1], itemListPos.Up)
    self:SetButton(self.btn_buy2,product_list[2], itemListPos.Middle)
    -- self:SetButton(self.btn_buy3,product_list[3], itemListPos.Down)

    self:SetLeftTime(data.giftInfo[1].expireTime)
end

function GiftPackFlagDayView:SetItem(itemUI,id, pos, btn)
    local itemParent = itemUI:Get("itemParent")
    local textExtra = itemUI:Get("textExtra")
    local bl_buy_txt = itemUI:Get("bl_buy_txt")
    local textVip = itemUI:Get("textVip")
    local textVip = itemUI:Get("textVip")
    local item = itemUI:Get("item")
    local extra = itemUI:Get("extra")
    local xls = Csv.GetData("pop_up", id)

    if(xls==nil)then 
        self:ClosePackView()
        log.e(" xls is nil ".. tostring(id))
        return 
    end

    bl_buy_txt.text = "$" .. xls.price
    itemList[pos] = itemList[pos] or  {}
    for k ,v in pairs(xls.item_description) do
        local itemId = tonumber(v[1])
        local itemNum = v[2]
        if itemId ~= Resource.vipExp then
            local itemGrid = self:GetItemGrid(pos , k , item, itemParent)
            fun.set_active(itemGrid, true)
            self:SetItemGrid(itemId, itemNum , itemGrid)
            itemList[pos][k] = itemGrid
        else
            textVip.text = fun.format_money_reward({id = itemId, value = itemNum})
            vipExpList[pos] = textVip
        end
    end
    self:SetExtra(textExtra,extra , xls.bonus)
end

function GiftPackFlagDayView:GetItemGrid(pos,index,prefab, parent)
    if itemList[pos] and itemList[pos][index] then
        return itemList[pos][index]
    end
    local itemGrid = fun.get_instance(prefab, parent)
    return itemGrid
end

function GiftPackFlagDayView:HideGridItem()
    for k ,v in pairs(itemList) do
        for z,w in pairs(v) do
            if w then
                fun.set_active(w, false)
            end 
        end
    end
end

function GiftPackFlagDayView:ShowDetailGift()
    self:ShowItemGrid()
end

function GiftPackFlagDayView:SetButton(button, id,pos)
    local data = ModelList.GiftPackModel:GetGiftById(id)
    buttonEnableList[pos] = true
    if not data or data.canBuyCount <= 0 then
        buttonEnableList[pos] = false
        self:CloseUIShiny(button)
        Util.SetUIImageGray(button, true)
    elseif   self:OpenUIShiny(button) then
        Util.SetUIImageGray(button, false)
    end
end

function GiftPackFlagDayView:SetLeftTime(endTimeStamp)
    local start_time = ModelList.PlayerInfoModel.get_cur_server_time()
    local endTime = endTimeStamp - start_time
    if not remainTimeCountDown then
        remainTimeCountDown = RemainTimeCountDown:New()
    end
    remainTimeCountDown:StartCountDown(CountDownType.cdt2,endTime,self.left_time_txt,function()
        self:ClosePackView()
        Event.Brocast(EventName.Event_Gift_Update)
    end)
end

function GiftPackFlagDayView:CollectProduct(pId,giftInfo)
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

--function GiftPackFlagDayView.OnDestroy()
--    self:Destroy()
--end

function GiftPackFlagDayView:on_close()
    --Event.Brocast(Notes.CARD_COLLIDER_OPEN, true)
end

function GiftPackFlagDayView:CloseFunc()
    Facade.SendNotification(NotifyName.HideDialog, self)
end

function GiftPackFlagDayView:ClosePackView()
    if self._fsm and self._fsm:GetCurName() == "GiftPackShowState" then return end
    self:ClearCountDown()
    Facade.SendNotification(NotifyName.HideUI, self)
    ModelList.GiftPackModel:CloseView()
end

function GiftPackFlagDayView:on_btn_close_click()
    self:ClosePackView()
end

function  GiftPackFlagDayView:OnBuySuccess(needClose,itemData)
    self:ChangeState(self,"GiftPackShowState",itemData)
end

function  GiftPackFlagDayView:GetGiftPos(id)
    if id == product_list[1] then
        return self:GetItemPos(itemListPos.Up)
    elseif id == product_list[2] then
        return self:GetItemPos(itemListPos.Middle)
    else
        return self:GetItemPos(itemListPos.Down)
    end
end

function GiftPackFlagDayView:GetItemPos(pos)
    local posTable ={}
    for k, v in pairs(itemList[pos]) do
        table.insert(posTable , fun.get_gameobject_pos( v))
    end
    table.insert(posTable , fun.get_gameobject_pos( vipExpList[pos]))
    return unpack(posTable)
end

return this