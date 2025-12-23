local GiftPackBaseView = require("View.GiftPack.GiftPackBaseView")
local GiftPackTournamentSprintBaseView = GiftPackBaseView:New("GiftPackTournamentSprintBaseView", "GiftPackTournamentSprintAtlas")
local this = GiftPackTournamentSprintBaseView
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
    "GiftPackTournamentSprintView",
    "btn_close",
    "btn_buy1",
    "btn_buy2",
    "btn_buy3",
    "bg1",
    "bg2",
    "bg3",
}

function GiftPackTournamentSprintBaseView:New(viewName, atlasName)
    local o = {}
    o.viewName = viewName
    o.atlasName = atlasName
    setmetatable(o,{__index = GiftPackTournamentSprintBaseView})
    return o
end

function GiftPackTournamentSprintBaseView:Awake(obj)
    self:on_init()
    self._isInit = true
    --- 修复部分机型首次进入界面不显示问题
    if self._reshowAfterInit then
        self._reshowAfterInit = nil
        self:ShowDetailGift()
    end
end

function GiftPackTournamentSprintBaseView:OnEnable()
    self:BuildFsm(self)
    self:Bi_Tracker()
end

function GiftPackTournamentSprintBaseView:OnDisable()
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

function GiftPackTournamentSprintBaseView:ClearCountDown()
    if remainTimeCountDown then
        remainTimeCountDown:StopCountDown()
        remainTimeCountDown = nil
    end
end

function GiftPackTournamentSprintBaseView:CloseUIShiny(obj)
    local uishiny = fun.get_component(obj, "UIShiny")
    if uishiny then
        uishiny.enabled = false
    end
end

function GiftPackTournamentSprintBaseView:GetLastClickTime()
    return lastClickTime or 0
end

function GiftPackTournamentSprintBaseView:on_btn_buy1_click()
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

function GiftPackTournamentSprintBaseView:on_btn_buy2_click()
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

function GiftPackTournamentSprintBaseView:on_btn_buy3_click()
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

function GiftPackTournamentSprintBaseView:SetExtra(extraUI, extraParent, bonus)
    if not bonus or bonus == 0 then
        fun.set_active(extraParent, false)
    else
        fun.set_active(extraParent, true)
        extraUI.text = string.format("%s<size=55>%s</size>", bonus, "%")
    end
end

function GiftPackTournamentSprintBaseView:SetItemGrid(itemId, itemNum, itemGrid)
    local refItem = fun.get_component(itemGrid, fun.REFER)
    local itemData = Csv.GetData("item", itemId)
    local icon = refItem:Get("icon")
    local textNum = refItem:Get("textNum")
    local iconKey = "more_icon"

    --不是资源类的id 而且不是天将奇遇的类型
    if itemId > 1000 and itemData.item_type ~= ItemType.rofy  then
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

function GiftPackTournamentSprintBaseView:ShowItemGrid()
    data = ModelList.GiftPackModel:GetShowGiftPack()
    self:CollectProduct(data.pId, data.giftInfo)
    itemList = itemList or {}
    vipExpList = vipExpList or {}
    self:HideGridItem()
    self:SetItem(self.bg1, product_list[1], itemListPos.Up, self.btn_buy1)
    self:SetItem(self.bg2, product_list[2], itemListPos.Middle , self.btn_buy2)
    self:SetItem(self.bg3, product_list[3], itemListPos.Down , self.btn_buy3)

    buttonEnableList = {}
    self:SetButton(self.btn_buy1, product_list[1], itemListPos.Up)
    self:SetButton(self.btn_buy2, product_list[2], itemListPos.Middle)
    self:SetButton(self.btn_buy3, product_list[3], itemListPos.Down)
    self:SetLeftTime(data.giftInfo[1].expireTime)
end

function GiftPackTournamentSprintBaseView:ClearItems()
    for i = 1, 3 do
        local itemUI = self["bg" .. i]
        local itemParent = itemUI:Get("itemParent")
        fun.clear_all_child(itemParent)
    end
end

function GiftPackTournamentSprintBaseView:SetItem(itemUI, id, pos, btn)
    if not itemUI then return end
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

function GiftPackTournamentSprintBaseView:GetItemGrid(pos,index,prefab, parent)
    if itemList[pos] and itemList[pos][index] then
        return itemList[pos][index]
    end
    local itemGrid = fun.get_instance(prefab, parent)
    return itemGrid
end

function GiftPackTournamentSprintBaseView:HideGridItem()
    for k, v in pairs(itemList) do
        for z, w in pairs(v) do
            if w then
                fun.set_active(w, false)
            end
        end
    end
end

function GiftPackTournamentSprintBaseView:ShowDetailGift()
    if self._isInit then
        self:ShowItemGrid()
    else
        self._reshowAfterInit = true
    end
end

function GiftPackTournamentSprintBaseView:SetButton(button, id, pos)
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

function GiftPackTournamentSprintBaseView:SetLeftTime(endTimeStamp)
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

function GiftPackTournamentSprintBaseView:CollectProduct(pId, giftInfo)
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

function GiftPackTournamentSprintBaseView:CloseFunc()
    Facade.SendNotification(NotifyName.HideDialog, self)
end

--[[子类重写
function GiftPackTournamentSprintBaseView:ClosePackView()
    if self._fsm:GetCurName() == "GiftPackShowState" then
        return
    end

    self:ClearCountDown()
    Facade.SendNotification(NotifyName.HideUI, ViewList.GiftPackTournamentSprintBaseView)
    ModelList.GiftPackModel:CloseView()
end
]]

function GiftPackTournamentSprintBaseView:on_btn_close_click()
    self:ClosePackView()
end

function GiftPackTournamentSprintBaseView:OnBuySuccess(needClose, itemData)
    self:ChangeState(self, "GiftPackShowState", itemData)
end

function GiftPackTournamentSprintBaseView:GetGiftPos(id)
    if id == product_list[1] then
        return self:GetItemPos(itemListPos.Up)
    elseif id == product_list[2] then
        return self:GetItemPos(itemListPos.Middle)
    else
        return self:GetItemPos(itemListPos.Down)
    end
end

function GiftPackTournamentSprintBaseView:GetItemPos(pos)
    local posTable ={}
    for k, v in pairs(itemList[pos]) do
        table.insert(posTable, v.transform.position)
    end
    table.insert(posTable, vipExpList[pos].transform.position)
    return unpack(posTable)
end

return this