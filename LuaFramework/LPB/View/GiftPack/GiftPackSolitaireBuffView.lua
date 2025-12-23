--挖矿buff礼包
local GiftPackBaseView = require("View.GiftPack.GiftPackBaseView")
---@class  GiftPackSolitaireBuffView: GiftPackBaseView
local GiftPackSolitaireBuffView = GiftPackBaseView:New('GiftPackSolitaireBuffView', "GiftPackSolitaireBuffAtlas")
local this = GiftPackSolitaireBuffView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local data =  nil
local product_list = {}
local canUpBuy = true
local canDownBuy = true
local click_interval = 0.5

this.auto_bind_ui_items = {
    "left_reward2_txt",
    "left_reward1_txt",
    "btn_left_buy",
    "left_buy_txt",
    "btn_right_buy",
    "GiftPackTwoView",
    "right_buy_txt",
    "right_reward1_txt",
    "right_reward2_txt",
    "left_reward1_icon",
    "left_reward2_icon",
    "right_reward2_icon",
    "right_reward1_icon",
    "btn_close",
    "cityExp1",
    "cityExp2",
    "right_time",
    "left_time",
    "right_reward3_icon",
    "right_reward3_txt",
}

function GiftPackSolitaireBuffView:Awake(obj)
    this:on_init()
    self._isInit = true
    --- 修复部分机型首次进入界面不显示问题
    if self._reshowAfterInit then
        self._reshowAfterInit = nil
        self:ShowDetailGift()
    end
end

function GiftPackSolitaireBuffView.OnEnable()
    this:BuildFsm(this)
    this:Bi_Tracker()
end

function GiftPackSolitaireBuffView:on_x_update()
end

function GiftPackSolitaireBuffView:ShowDetailGift()
    if self._isInit then
        data = ModelList.GiftPackModel:GetShowGiftPack()
        if data then
            this:CollectProduct(data.pId, data.giftInfo)
            this:SetLeftProduct(product_list[1])
            this:SetRightProduct(product_list[2])
            --this:SetLeftTime(data.giftInfo[1].expireTime)
        end
    else
        self._reshowAfterInit = true
    end
end

function GiftPackSolitaireBuffView:CollectProduct(pId, giftInfo)
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

local SetBuyBtnDescripe = function(btnObj, des)
    if #des > 0 and des ~= "0" then
        local content = fun.find_child(btnObj, "Image/des")
        local txt = fun.get_component(content, "Text")
        if txt then
            txt.text = des
        end
        fun.set_active(content.transform.parent, true)
    else
        local content = fun.find_child(btnObj, "Image")
        fun.set_active(content, false)
    end
end

local SetCityExp = function(btnObj, item_description, count)
    if #item_description > count - 1 then
        fun.set_active(btnObj, true)
        local vipexp = fun.find_child(btnObj, "vipexp")
        local text = fun.get_component(vipexp, "Text")
        text.text = fun.formatNum(item_description[count][2])
    else
        fun.set_active(btnObj, false)
    end
end

function GiftPackSolitaireBuffView.GetItemOrResource(id, param)
    if id > 1000 then
        return  Csv.GetData("item", id, param), "ItemAtlas"
    else
        return Csv.GetData("resources", id, "pop_up"), "CommonAtlas"
    end
end

function GiftPackSolitaireBuffView:SetLeftProduct(id)
    local xls = Csv.GetData("pop_up", id)
    this:SetContent(xls.item_description[1][1], self.left_time, xls.item_description[1][2])
    local item1 = xls.item_description[2][1]
    local icon1, atlasName = self.GetItemOrResource(tonumber(item1), "icon")
    self.left_reward1_icon.sprite = AtlasManager:GetSpriteByName(atlasName, icon1)
    this:SetContent(item1, self.left_reward1_txt, xls.item_description[2][2])
    local item2 = xls.item_description[3][1]
    local icon2, atlasName = self.GetItemOrResource(tonumber(item2), "icon")
    self.left_reward2_icon.sprite = AtlasManager:GetSpriteByName(atlasName, icon2)
    this:SetContent(item2, self.left_reward2_txt, xls.item_description[3][2])

    self.left_buy_txt.text = "$" .. xls.price
    canUpBuy = true
    local data = ModelList.GiftPackModel:GetGiftById(id)
    if data.canBuyCount <= 0 then
        this:CloseUIShiny(self.btn_left_buy)
        this:SetUIImageGray(self.btn_left_buy, true)
        canUpBuy = false
    elseif this:OpenUIShiny(self.btn_left_buy) then
        this:SetUIImageGray(self.btn_left_buy, false)
    end

    SetBuyBtnDescripe(self.btn_left_buy,xls.limit_description)
    SetCityExp(this.cityExp1,xls.item_description,4)
end

function GiftPackSolitaireBuffView:SetRightProduct(id)
    local xls = Csv.GetData("pop_up", id)
    --this:SetContent(xls.item_description[1][1], self.right_time, xls.item_description[1][2])
    fun.set_active(self.right_time, false)
    local item1 = xls.item_description[1][1]
    local icon1, atlasName = self.GetItemOrResource(tonumber(item1), "icon")
    self.right_reward1_icon.sprite = AtlasManager:GetSpriteByName(atlasName, icon1)
    this:SetContent(item1, self.right_reward1_txt, xls.item_description[1][2])
    local item2 = xls.item_description[2][1]
    local icon2, atlasName = self.GetItemOrResource(tonumber(item2), "icon")
    self.right_reward2_icon.sprite = AtlasManager:GetSpriteByName(atlasName, icon2)
    this:SetContent(item2, self.right_reward2_txt, xls.item_description[2][2])

    local item3 = xls.item_description[3][1]
    local icon3, atlasName = self.GetItemOrResource(tonumber(item3), "icon")
    log.log("dghdgh007 item3", item3, icon3, atlasName)
    self.right_reward3_icon.sprite = AtlasManager:GetSpriteByName(atlasName, icon3)
    this:SetContent(item2, self.right_reward3_txt, xls.item_description[3][2])

    self.right_buy_txt.text = "$" .. xls.price
    canDownBuy = true
    local data = ModelList.GiftPackModel:GetGiftById(id)
    if data.canBuyCount <= 0 then
        this:CloseUIShiny(self.btn_right_buy)
        this:SetUIImageGray(self.btn_right_buy,true)
        canDownBuy = false
    elseif this:OpenUIShiny(self.btn_right_buy) then
        this:SetUIImageGray(self.btn_right_buy,false)
    end

    SetBuyBtnDescripe(self.btn_right_buy, xls.limit_description)
    SetCityExp(this.cityExp2, xls.item_description, 4)
end

function GiftPackSolitaireBuffView:SetLeftTime(endTimeStamp)
    local start_time = ModelList.PlayerInfoModel.get_cur_server_time()
    this.endTime = endTimeStamp - start_time
    if this.loopTime then
        LuaTimer:Remove(this.loopTime)
        this.loopTime = nil
    end
    this.loopTime = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
        if self.left_time_txt then
            --self.left_time_txt.text = fun.SecondToStrFormat(this.endTime)
            this.endTime = this.endTime - 1
            if this.endTime <= 0 then
                this.on_btn_close_click()
                Event.Brocast(EventName.Event_Gift_Update)
            end
        end
    end, nil, nil, LuaTimer.TimerType.UI)
end

function GiftPackSolitaireBuffView:SetContent(id, txt, content)
    id = tonumber(id)
    if fun.is_null(txt) then
        return
    end
    if id == 23 or id == 24 or id == 903302 or id == 903502 then
        --txt.text = (tonumber(content) / 60).."min"
        local itemData = Csv.GetData("item", id)
        if itemData ~=nil and itemData.destroy_cd ~= nil and itemData.destroy_cd ~= 0 then 
            txt.text = fun.FormatTextToTime(content * itemData.destroy_cd)
        else
            txt.text = fun.FormatTextToTime(content)
        end
    else
        txt.text = fun.formatNum((content))
    end
end

function GiftPackSolitaireBuffView.OnDisable()
    this:stop_x_update()
end

function GiftPackSolitaireBuffView.OnDestroy()
    this:Destroy()
end

function GiftPackSolitaireBuffView:on_close()
    this:stop_x_update()
end

function GiftPackSolitaireBuffView:CloseFunc()
    Facade.SendNotification(NotifyName.CloseUI, this)
end

function GiftPackSolitaireBuffView:CutDonwTarget()
    this:CloseFunc()
    this.main_effect:Play("end")
end

function GiftPackSolitaireBuffView:on_btn_close_click()
    if this._fsm:GetCurName() == "GiftPackShowState" then
        return
    end
    if this.loopTime then
        LuaTimer:Remove(this.loopTime)
        this.loopTime = nil
    end
    Facade.SendNotification(NotifyName.CloseUI, self)
    ModelList.GiftPackModel:CloseView()
end

this.last_click_time1 = 0
function GiftPackSolitaireBuffView:on_btn_left_buy_click()
    if this._fsm:GetCurName() ~= "GiftPackEnterState" then return end
    if canUpBuy then
        local click_time = UnityEngine.Time.time
        if click_time - this.last_click_time1 > click_interval then
            ModelList.GiftPackModel:ReqEditorBuySucess(data.pId,product_list[1])
            this.last_click_time1 = UnityEngine.Time.time
        end
    else
        UIUtil.show_common_popup(8020,true)
    end
end

this.last_click_time2 = 0
function GiftPackSolitaireBuffView:on_btn_right_buy_click()
    if this._fsm:GetCurName() ~= "GiftPackEnterState" then return end
    if canDownBuy then
        local click_time = UnityEngine.Time.time
        if click_time - this.last_click_time2 > click_interval then
            ModelList.GiftPackModel:ReqEditorBuySucess(data.pId,product_list[2])
            this.last_click_time2 = UnityEngine.Time.time
        end
        --this:on_btn_close_click()
    else
        --Facade.SendNotification(NotifyName.Common.PopupDialog, 8020, 1);
        UIUtil.show_common_popup(8020,true)
    end
end

function GiftPackSolitaireBuffView:CloseUIShiny(obj)
    local uishiny = fun.get_component(obj,"UIShiny")
    if uishiny then
        uishiny.enabled = false
    end
end

function GiftPackSolitaireBuffView:SetUIImageGray(btn_obj,active)
    if active then
        local particle = fun.find_child(btn_obj,"particle")
        if particle then
            fun.set_active(particle,false)
        end
    end
    Util.SetUIImageGray(btn_obj,active)
end

function GiftPackSolitaireBuffView:OnBuySuccess(needClose,itemData)
    this:ChangeState(this,"GiftPackShowState",itemData)
end

function GiftPackSolitaireBuffView:GetGiftPos(id)
    if id == product_list[1] then
        local vipexp = fun.find_child(this.cityExp1, "vipexp")
        return   this.left_time.transform.position, this.left_reward1_txt.transform.position, this.left_reward2_txt.transform.position,
        vipexp.transform.position
    elseif id == product_list[2] then
        local vipexp = fun.find_child(this.cityExp2, "vipexp")
        return this.right_time.transform.position,  this.right_reward1_icon.transform.position, this.right_reward2_icon.transform.position, vipexp.transform.position, nil
    else
        local vipexp = fun.find_child(this.cityExp1, "vipexp")
        return this.br_reward_txt.transform.position,this.br_cost_txt.transform.position,
        vipexp.transform.position,nil
    end
end

return this
