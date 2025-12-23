local GiftPackBaseView = require("View.GiftPack.GiftPackBaseView")
local GiftPackLetemRollBoothView = GiftPackBaseView:New("GiftPackLetemRollBoothView","GiftPackLetemRollBoothAtlas")
local this = GiftPackLetemRollBoothView
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
    Total = 4,
}

this.auto_bind_ui_items = {
    "left_time_txt",
    "GiftPackLetemRollBoothView",
    "btn_close",
    "btn_buy1",
    "btn_buy2",
    "btn_buy3",
    "bg1",
    "bg2",
    "bg3",
    "btn_buy_all",
    "textVip",
    "bl_buy_txt",
}

function GiftPackLetemRollBoothView:New(viewName, atlasName)
    local o = {}
    o.viewName = viewName
    o.atlasName = atlasName
    setmetatable(o,{__index = GiftPackLetemRollBoothView})
    return o
end

function GiftPackLetemRollBoothView:Awake(obj)
    self:on_init()
    self._isInit = true
    --- 修复部分机型首次进入界面不显示问题
    if self._reshowAfterInit then
        self._reshowAfterInit = nil
        self:ShowDetailGift()
    end
end

function GiftPackLetemRollBoothView:OnEnable()
    self:BuildFsm(self)
    self:Bi_Tracker()
    UISound.play("saleboth")
end

function GiftPackLetemRollBoothView:OnDisable()
    for k, v in pairs(itemList) do
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

function GiftPackLetemRollBoothView:ClearCountDown()
    if remainTimeCountDown then
        remainTimeCountDown:StopCountDown()
        remainTimeCountDown = nil
    end
end

function GiftPackLetemRollBoothView:CloseUIShiny(obj)
    local uishiny = fun.get_component(obj, "UIShiny")
    if uishiny then
        uishiny.enabled = false
    end
end

function GiftPackLetemRollBoothView:GetLastClickTime()
    return lastClickTime or 0
end

function GiftPackLetemRollBoothView:on_btn_buy1_click()
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

function GiftPackLetemRollBoothView:on_btn_buy2_click()
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

function GiftPackLetemRollBoothView:on_btn_buy3_click()
    if self._fsm:GetCurName() ~= "GiftPackEnterState" then
        return
    end

    if buttonEnableList[itemListPos.Down] then
        local click_time = UnityEngine.Time.time
        if click_time - self:GetLastClickTime() > click_interval then
            lastClickTime = UnityEngine.Time.time
            ModelList.GiftPackModel:ReqEditorBuySucess(data.pId, product_list[3])
        end
    else
        UIUtil.show_common_popup(8020, true)
    end
end

function GiftPackLetemRollBoothView:on_btn_buy_all_click()
    if self._fsm:GetCurName() ~= "GiftPackEnterState" then
        return
    end

    if buttonEnableList[itemListPos.Total] then
        local click_time = UnityEngine.Time.time
        if click_time - self:GetLastClickTime() > click_interval then
            lastClickTime = UnityEngine.Time.time
            ModelList.GiftPackModel:ReqEditorBuySucess(data.pId, product_list[4])
        end
    else
        UIUtil.show_common_popup(8020, true)
    end
end

function GiftPackLetemRollBoothView:SetExtra(extraUI, extraParent, bonus)
    if not bonus or bonus == 0 then
        fun.set_active(extraParent, false)
    else
        fun.set_active(extraParent, true)
        extraUI.text = string.format("%s<size=55>%s</size>", bonus, "%")
    end
end

function GiftPackLetemRollBoothView:SetItemGrid(itemId, itemNum, itemGrid)
    local refItem = fun.get_component(itemGrid, fun.REFER)
    local itemData = Csv.GetData("item", itemId)
    local icon = refItem:Get("icon")
    local textNum = refItem:Get("textNum")
    local iconKey = "more_icon"

    --不是资源类的id 而且不是天将奇遇的类型
    if itemId > 1000 and itemData.item_type ~= ItemType.rofy then
        iconKey = "icon"
    end

    local iconName = Csv.GetItemOrResource(itemId, iconKey)
    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
    if ModelList.TournamentModel:IsSprintBuffId(itemId) then
        local des
        local hrs = math.floor(itemNum / 60)
        if hrs > 0 then
            des = fun.NumInsertComma(hrs) .. " HRS"
        else
            local min = itemNum
            des = fun.NumInsertComma(min) .. " Min"
        end
        textNum.text = des
    else
        textNum.text = fun.format_money_reward({id = itemId, value = itemNum})
    end
end

function GiftPackLetemRollBoothView:ShowItemGrid()
    data = ModelList.GiftPackModel:GetShowGiftPack()
    self:CollectProduct(data.pId, data.giftInfo)
    itemList = itemList or {}
    vipExpList = vipExpList or {}
    self:HideGridItem()
    self:SetItem(self.bg1, product_list[1], itemListPos.Up, self.btn_buy1)
    self:SetItem(self.bg2, product_list[2], itemListPos.Middle, self.btn_buy2)
    self:SetItem(self.bg3, product_list[3], itemListPos.Down, self.btn_buy3)
    self:SetLastItem(product_list[4], itemListPos.Total)

    buttonEnableList = {}
    self:SetButton(self.btn_buy1, product_list[1], itemListPos.Up)
    self:SetButton(self.btn_buy2, product_list[2], itemListPos.Middle)
    self:SetButton(self.btn_buy3, product_list[3], itemListPos.Down)
    self:SetButton(self.btn_buy_all, product_list[4], itemListPos.Total)
    self:SetLeftTime(data.giftInfo[1].expireTime)
end

function GiftPackLetemRollBoothView:ClearItems()
    for i = 1, 3 do
        local itemUI = self["bg" .. i]
        local itemParent = itemUI:Get("itemParent")
        fun.clear_all_child(itemParent)
    end
end

function GiftPackLetemRollBoothView:SetItem(itemUI, id, pos, btn)
    if not itemUI then return end
    local itemParent = itemUI:Get("itemParent")
    local textExtra = itemUI:Get("textExtra")
    local bl_buy_txt = itemUI:Get("bl_buy_txt")
    local textVip = itemUI:Get("textVip")
    local item = itemUI:Get("item")
    local extra = itemUI:Get("extra")
    local xls = Csv.GetData("pop_up", id)
    fun.set_active(item, false)
    bl_buy_txt.text = "$" .. xls.price
    itemList[pos] = itemList[pos] or {}
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

function GiftPackLetemRollBoothView:SetLastItem(id, pos)
    local xls = Csv.GetData("pop_up", id)
    if xls then
        if fun.is_not_null(self.bl_buy_txt) then
            self.bl_buy_txt.text = "Buy All $" .. xls.price
        end

        if fun.is_not_null(self.textVip) then
            for k, v in pairs(xls.item_description) do
                local itemId = tonumber(v[1])
                local itemNum = v[2]
                if itemId == Resource.vipExp then
                    self.textVip.text = fun.format_money_reward({id = itemId, value = itemNum})
                    vipExpList[pos] = self.textVip
                    break
                end
            end
        end
    end
end

function GiftPackLetemRollBoothView:GetItemGrid(pos,index,prefab, parent)
    if itemList[pos] and itemList[pos][index] then
        return itemList[pos][index]
    end
    local itemGrid = fun.get_instance(prefab, parent)
    return itemGrid
end

function GiftPackLetemRollBoothView:HideGridItem()
    for k, v in pairs(itemList) do
        for z, w in pairs(v) do
            if w then
                fun.set_active(w, false)
            end
        end
    end
end

function GiftPackLetemRollBoothView:ShowDetailGift()
    if self._isInit then
        self:ShowItemGrid()
    else
        self._reshowAfterInit = true
    end
end

function GiftPackLetemRollBoothView:SetButton(button, id, pos)
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

function GiftPackLetemRollBoothView:SetLeftTime(endTimeStamp)
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

function GiftPackLetemRollBoothView:CollectProduct(pId, giftInfo)
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

function GiftPackLetemRollBoothView:CloseFunc()
    Facade.SendNotification(NotifyName.HideDialog, self)
end


function GiftPackLetemRollBoothView:ClosePackView()
    if self._fsm:GetCurName() == "GiftPackShowState" then
        return
    end

    self:ClearCountDown()
    Facade.SendNotification(NotifyName.HideUI, self)
    ModelList.GiftPackModel:CloseView()
end

function GiftPackLetemRollBoothView:on_btn_close_click()
    self:ClosePackView()
end

function GiftPackLetemRollBoothView:OnBuySuccess(needClose, itemData)
    self:ChangeState(self, "GiftPackShowState", itemData)
end

function GiftPackLetemRollBoothView:GetGiftPos(id)
    if id == product_list[1] then
        return self:GetItemPos(itemListPos.Up)
    elseif id == product_list[2] then
        return self:GetItemPos(itemListPos.Middle)
    elseif id == product_list[3] then
        return self:GetItemPos(itemListPos.Down)
    elseif id == product_list[4] then
        return self:GetItemPos(itemListPos.Total)
    else
        log.log("GiftPackLetemRollBoothView:GetGiftPos(id) id error", id)
        return self:GetItemPos(itemListPos.Up)
    end
end

function GiftPackLetemRollBoothView:GetItemPos(pos)
    local posTable ={}
    if pos ~= 4 then
        for k, v in pairs(itemList[pos]) do
            table.insert(posTable, v.transform.position)
        end
        table.insert(posTable, vipExpList[pos].transform.position)
    else
        for i = 1, 3 do
            for k, v in pairs(itemList[i]) do
                table.insert(posTable, v.transform.position)
            end
            table.insert(posTable, vipExpList[i].transform.position)
        end
    end
    return unpack(posTable)
end

return this
