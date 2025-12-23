require "View/CommonView/RemainTimeCountDown"
local GiftPackBaseView = require("View.GiftPack.GiftPackBaseView")
local GiftPackOktoberfestSaleView = GiftPackBaseView:New('GiftPackOktoberfestSaleView', "GiftPackOktoberfestSaleViewAtlas")
local this = GiftPackOktoberfestSaleView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local this = GiftPackOktoberfestSaleView
this.auto_bind_ui_items = {
    "left_time_txt",
    "GiftPackOktoberfestSaleView",
    "btn_close",
    "btn_buy1",
    "btn_buy2",
    "bg1",
    "bg2"
}

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
}

local remainTimeCountDown = RemainTimeCountDown:New()

function GiftPackOktoberfestSaleView:Awake(obj)
    --this.update_x_enabled = true
    this:on_init()
end

function GiftPackOktoberfestSaleView:OnEnable()
	--绑定状态机
	self:BuildFsm(self)
	--上报活动界面打开
	self:Bi_Tracker()
	UISound.play("sale_flagday")
	if self.spine then
		self.spine:SetAnimation("idle",nil,false,0)
	end
	if self.spine2 then
		self.spine2:SetAnimation("idle",nil,false,0)
	end
end

function GiftPackOktoberfestSaleView:OnDisable()
	--销毁动态创建的对象
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
end

function GiftPackOktoberfestSaleView:ClearCountDown()
	if remainTimeCountDown then
		remainTimeCountDown:StopCountDown()
		remainTimeCountDown = nil
	end
end

function GiftPackOktoberfestSaleView:OnDestroy()
    this:Destroy()
end

--关闭ui流光
function GiftPackOktoberfestSaleView:CloseUIShiny(obj)
	local uishiny = fun.get_component(obj,"UIShiny")
	if uishiny then
		uishiny.enabled = false
	end
end

function GiftPackOktoberfestSaleView:GetLastClickTime(pos)
	return clickTimeList or 0
end

--显示详细数据
function GiftPackOktoberfestSaleView:ShowDetailGift()
	self:ShowItemGrid()
end

--显示界面
function GiftPackOktoberfestSaleView:ShowItemGrid()
	data = ModelList.GiftPackModel:GetShowGiftPack()
	self:CollectProduct(data.pId,data.giftInfo)
	itemList = itemList or {}
	vipExpList = vipExpList or {}
	self:HideGridItem()
	self:SetItem(self.bg1,product_list[1],itemListPos.Up, self.btn_buy1)
	self:SetItem(self.bg2,product_list[2],itemListPos.Middle , self.btn_buy2)

	buttonEnableList = {}
	local btn_buy_1 = fun.find_child(self.btn_buy_1,"lButtonPurple")
	self:SetButton(self.btn_buy1,product_list[1], itemListPos.Up)
	self:SetButton(self.btn_buy2,product_list[2], itemListPos.Middle)

	self:SetLeftTime(data.giftInfo[1].expireTime)
end

--设置折扣
function GiftPackOktoberfestSaleView:SetExtra(extraUI,extraParent , bonus)
	if not bonus or bonus == 0 then
		fun.set_active(extraParent, false)
	else
		fun.set_active(extraParent, true)
		extraUI.text = string.format("%s<size=55>%s</size>",bonus , "%")
	end
end

--设置购买对象
function GiftPackOktoberfestSaleView:SetItem(itemUI,id, pos, btn)
	local itemParent = itemUI:Get("itemParent")
	local textExtra = itemUI:Get("textExtra")
	local bl_buy_txt = itemUI:Get("bl_buy_txt")
	local textVip = itemUI:Get("textVip")
	local item = itemUI:Get("item")
	local extra = itemUI:Get("extra")
	local xls = Csv.GetData("pop_up", id)
	if xls == nil then
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

function GiftPackOktoberfestSaleView:GetItemGrid(pos,index,prefab, parent)
	if itemList[pos] and itemList[pos][index] then
		return itemList[pos][index]
	end
	local itemGrid = fun.get_instance(prefab, parent)
	return itemGrid
end

function GiftPackOktoberfestSaleView:HideGridItem()
	for k ,v in pairs(itemList) do
		for z,w in pairs(v) do
			if w then
				fun.set_active(w, false)
			end
		end
	end
end

function GiftPackOktoberfestSaleView:SetButton(button, id,pos)
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

--设置倒计时
function GiftPackOktoberfestSaleView:SetLeftTime(endTimeStamp)
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

--排序子活动
function GiftPackOktoberfestSaleView:CollectProduct(pId,giftInfo)
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

function GiftPackOktoberfestSaleView:CloseFunc()
	Facade.SendNotification(NotifyName.HideDialog, self)
end

function GiftPackOktoberfestSaleView:ClosePackView()
	if self._fsm:GetCurName() == "GiftPackShowState" then return end
	self:ClearCountDown()
	Facade.SendNotification(NotifyName.HideUI, ViewList.GiftPackOktoberfestSaleView)
	ModelList.GiftPackModel:CloseView()
end

function  GiftPackOktoberfestSaleView:OnBuySuccess(needClose,itemData)
	self:ChangeState(self,"GiftPackShowState",itemData)
end

function  GiftPackOktoberfestSaleView:GetGiftPos(id)
	if id == product_list[1] then
		return self:GetItemPos(itemListPos.Up)
	elseif id == product_list[2] then
		return self:GetItemPos(itemListPos.Middle)
	else
		return self:GetItemPos(itemListPos.Down)
	end
end

function GiftPackOktoberfestSaleView:GetItemPos(pos)
	local posTable ={}
	for k, v in pairs(itemList[pos]) do
		table.insert(posTable , v.transform.position)
	end
	table.insert(posTable , vipExpList[pos].transform.position)
	return unpack(posTable)
end

--设置单个道具item
function GiftPackOktoberfestSaleView:SetItemGrid(itemId, itemNum , itemGrid)
	local refItem = fun.get_component(itemGrid , fun.REFER)
	local itemData = Csv.GetItemOrResource(itemId)
	local icon = refItem:Get("icon")
	local textNum = refItem:Get("textNum")
	local FreeTip =  refItem:Get("SaleIcon")
	local DiscountTip =  refItem:Get("saleIcon2")
	local DiscountTxt =  refItem:Get("saleIcon2Text")

	local iconName = nil
	if itemId == Resource.coin or itemId == Resource.diamon or itemId == Resource.rocket then
		iconName = Csv.GetItemOrResource(itemId, "more_icon")
	else
		if itemData.item_type and itemData.item_type == ItemType.rofy then
			iconName = Csv.GetItemOrResource(itemId, "more_icon")

		else
			iconName = Csv.GetItemOrResource(itemId, "icon")
		end

	end

	if itemData ~=nil and itemData.result then
		if (itemData.result[1] == 23 or itemData.result[1] == 24 or itemData.result[1] == 25) then
			if  itemData.result[2] >=100 then
				fun.set_active(DiscountTip,false)
				fun.set_active(FreeTip,true)
			else
				fun.set_active(DiscountTip,true)
				fun.set_active(FreeTip,false)
				DiscountTxt.text =  itemData.result[2]
			end
		end
	else
		fun.set_active(DiscountTip,false)
		fun.set_active(FreeTip,false)
	end

	icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)

	if itemData ~=nil and itemData.item_type and itemData.item_type == ItemType.rofy then
		icon:SetNativeSize()
	end
	if itemData ~=nil and itemData.destroy_cd ~= nil and itemData.destroy_cd ~= 0 then
		textNum.text = fun.format_money_reward({id = itemId, value = itemNum}).."Mins"
	else
		textNum.text = fun.format_money_reward({id = itemId, value = itemNum})
	end
end

function GiftPackOktoberfestSaleView:on_btn_close_click()
	self:ClosePackView()
end

function GiftPackOktoberfestSaleView:on_btn_buy1_click()
	if self._fsm:GetCurName() ~= "GiftPackEnterState" then return end

	if buttonEnableList[itemListPos.Up] then
		local click_time = UnityEngine.Time.time
		if click_time - self:GetLastClickTime(itemListPos.Up) > click_interval then
			clickTimeList = UnityEngine.Time.time
			ModelList.GiftPackModel:ReqEditorBuySucess(data.pId, product_list[1])
		end
	else
		UIUtil.show_common_popup(8020,true)
	end
end

function GiftPackOktoberfestSaleView:on_btn_buy2_click()
	if self._fsm:GetCurName() ~= "GiftPackEnterState" then return end
	if buttonEnableList[itemListPos.Middle] then
		local click_time = UnityEngine.Time.time
		if click_time - self:GetLastClickTime(itemListPos.Middle) > click_interval then
			clickTimeList = UnityEngine.Time.time
			ModelList.GiftPackModel:ReqEditorBuySucess(data.pId, product_list[2])
		end
	else
		UIUtil.show_common_popup(8020,true)
	end
end

return this