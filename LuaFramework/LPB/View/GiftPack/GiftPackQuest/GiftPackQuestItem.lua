local GiftPackQuestItem = BaseView:New("GiftPackQuestItem")
local this = GiftPackQuestItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.last_click_time = 0    --购买按钮点击计时
this.canUpBuy = true
local click_interval = 0.5

this.auto_bind_ui_items = {
    "gift_icon",
    "btn_buy",
    "bl_buy_txt",
    "left_time",
    "reward1_icon",
    "reward2_icon",
    "reward3_icon",
    "reward1_count",
    "reward2_count",
    "reward3_count",
}

function GiftPackQuestItem:New(ownerView, pID, packID)
    local o = {}
    o.ownerView = ownerView
    o.pID = pID
    o.packID = packID

    self.__index = self
    setmetatable(o, self)
    return o
end

function GiftPackQuestItem:Awake()
    self:on_init()
    self._isInit = true
    --- 修复部分机型首次进入界面不显示问题
    if self._reshowAfterInit then
        self._reshowAfterInit = nil
        self:ShowDetailGift()
    end
end

function GiftPackQuestItem:OnEnable()
    if self.packID then
        self:UpdateData()
    end
end

function GiftPackQuestItem:on_close()
    if this.loopTime then
        LuaTimer:Remove(this.loopTime)
        this.loopTime = nil
    end
end

function GiftPackQuestItem:UpdateData()
    local popCfg = Csv.GetData("pop_up", self.packID)

    --金币
    self:SetItemCtrl(popCfg.item_description[1], self.reward1_icon, self.reward1_count)
    --钻石
    self:SetItemCtrl(popCfg.item_description[2], self.reward2_icon, self.reward2_count)
    --buff时间
    self:SetItemCtrl(popCfg.item_description[3], nil, self.left_time)
    --vip经验
    self:SetItemCtrl(popCfg.item_description[4], self.reward3_icon, self.reward3_count)

    --礼包价格
    self.bl_buy_txt.text = "$" .. popCfg.price

    --是否还能购买礼包
    self.canUpBuy = true
    local data = ModelList.GiftPackModel:GetGiftById(self.packID)
    if data.canBuyCount <= 0 then
        this:CloseUIShiny(self.btn_buy)
        this:SetUIImageGray(self.btn_buy, true)
        self.canUpBuy = false
    elseif this:OpenUIShiny(self.btn_buy) then
        this:SetUIImageGray(self.btn_buy, false)
    end
end

function GiftPackQuestItem:SetLeftTime(endTimeStamp)
    local start_time = ModelList.PlayerInfoModel.get_cur_server_time()
    this.endTime = endTimeStamp - start_time

    if this.loopTime then
        LuaTimer:Remove(this.loopTime)
        this.loopTime = nil
    end

    this.loopTime = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
        if self.left_time then
            this.endTime = this.endTime - 1
            if this.endTime <= 0 then
                this.on_btn_close_click()
                Event.Brocast(EventName.Event_Gift_Update)
            end
        end
    end, nil, nil, LuaTimer.TimerType.UI)
end

function GiftPackQuestItem:SetItemCtrl(cfg, iconCtrl, countCtrl)
    local itemID, itemDes = cfg[1], cfg[2]
    itemID = tonumber(itemID)

    --if fun.is_not_null(iconCtrl) then
    --    local icon, atlasName
    --    if itemID > 1000 then
    --        icon, atlasName = Csv.GetData("item", itemID, "icon"), "ItemAtlas"
    --    else
    --        icon, atlasName = Csv.GetData("resources", itemID, "pop_up"), "CommonAtlas"
    --    end
    --    iconCtrl.sprite = AtlasManager:GetSpriteByName(atlasName, icon)
    --end

    if fun.is_not_null(countCtrl) then
        if itemID == 29 or itemID == 30 then
            countCtrl.text = (tonumber(itemDes) / 60) .. "min"
        else
            countCtrl.text = fun.formatNum((itemDes))
        end
    end
end

function GiftPackQuestItem:OpenUIShiny(obj)
    local uishiny = fun.get_component(obj,"UIShiny")
    if uishiny and not  uishiny.enabled then
        uishiny.enabled = true
        return true
    end
    return false
end

function GiftPackQuestItem:CloseUIShiny(obj)
    local uishiny = fun.get_component(obj, "UIShiny")
    if uishiny then
        uishiny.enabled = false
    end
end

function GiftPackQuestItem:SetUIImageGray(btn_obj, active)
    if active then
        local particle = fun.find_child(btn_obj, "particle")
        if particle then
            fun.set_active(particle, false)
        end
    end
    Util.SetUIImageGray(btn_obj.gameObject, active)
end

function GiftPackQuestItem:GetGiftPos()
    return self.left_time.transform.position
    , self.reward1_count.transform.position
    , self.reward2_count.transform.position
    , self.reward3_count.transform.position
end

function GiftPackQuestItem:GetGiftIcon()
    return self.gift_icon.transform
end

function GiftPackQuestItem:on_btn_buy_click()
    if not ModelList.CarQuestModel:IsActivityAvailable() then
        return UIUtil.show_common_popup(9036, true)
    end    
    
    if not self.packID then
        return
    end

    if self.ownerView then
        if self.ownerView._fsm:GetCurName() ~= "GiftPackEnterState" then
            return
        end
    end

    if self.canUpBuy then
        local click_time = UnityEngine.Time.time
        if click_time - self.last_click_time > click_interval then
            ModelList.GiftPackModel:ReqEditorBuySucess(self.pID, self.packID)
            self.last_click_time = UnityEngine.Time.time
        end
    else
        UIUtil.show_common_popup(8020, true)
    end
end

return this