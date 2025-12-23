local VolcanoMissionGiftPackItem = BaseView:New("VolcanoMissionGiftPackItem")
local this = VolcanoMissionGiftPackItem
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
    "rewarditem_icon",
    "rewarditem_count",
}

function VolcanoMissionGiftPackItem:New(ownerView, pID, packID)
    local o = {}
    o.ownerView = ownerView
    o.pID = pID
    o.packID = packID

    self.__index = self
    setmetatable(o, self)
    return o
end

function VolcanoMissionGiftPackItem:Awake()
    self:on_init()
    self._isInit = true
    --- 修复部分机型首次进入界面不显示问题
    if self._reshowAfterInit then
        self._reshowAfterInit = nil
        self:ShowDetailGift()
    end
end

function VolcanoMissionGiftPackItem:OnEnable()
    if self.packID then
        self:UpdateData()
    end
end

function VolcanoMissionGiftPackItem:on_close()
    if this.loopTime then
        LuaTimer:Remove(this.loopTime)
        this.loopTime = nil
    end
end

function VolcanoMissionGiftPackItem:UpdateData(packID)
    if packID and self.packID ~= packID then
        self.packID = packID
        --做礼包移动动画
        self:DoMoveAnim()
    end
    
    local popCfg = Csv.GetData("pop_up", self.packID)
    
    --buff时间 或者 直接道具奖励
    local tempReward = popCfg.item_description[3]
    local icon2 = fun.get_child(self.gift_icon, 0)
    if tempReward[1] == "37" then
        --直接道具奖励
        fun.enable_component(self.gift_icon, false)
        fun.set_active(self.left_time.transform.parent, false)
        fun.set_active(icon2, true)
        if self.rewarditem_icon then
            fun.set_active(self.rewarditem_icon.transform.parent, true)
        end
        self:SetItemCtrl(tempReward, self.rewarditem_icon, self.rewarditem_count)
    else
        fun.enable_component(self.gift_icon, true)
        fun.set_active(self.left_time.transform.parent, true)
        fun.set_active(icon2, false)
        if self.rewarditem_icon then
            fun.set_active(self.rewarditem_icon.transform.parent, false)
        end
        self:SetItemCtrl(tempReward, nil, self.left_time)
    end
    
    --金币
    self:SetItemCtrl(popCfg.item_description[1], self.reward1_icon, self.reward1_count)
    
    --钻石
    self:SetItemCtrl(popCfg.item_description[2], self.reward2_icon, self.reward2_count)

    --vip经验
    fun.set_active(self.reward3_icon.transform.parent, popCfg.item_description[4] ~= nil)
    if popCfg.item_description[4] then
        self:SetItemCtrl(popCfg.item_description[4], self.reward3_icon, self.reward3_count)
    end

    --礼包价格
    local price = tonumber(popCfg.price)
    if price > 0 then
        self.bl_buy_txt.text = "$" .. price
    else
        self.bl_buy_txt.text = "Free"
    end

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

function VolcanoMissionGiftPackItem:SetItemCtrl(cfg, iconCtrl, countCtrl)
    local itemID, itemDes = cfg[1], cfg[2]
    itemID = tonumber(itemID)
    
    if fun.is_not_null(countCtrl) then
        if itemID == 35 or itemID == 36 then
            local min = tonumber(itemDes) / 60
            local hour = min / 60
            if hour >= 1 then
                countCtrl.text = hour .. "h"
            else
                countCtrl.text = min .. "min"
            end
        else
            countCtrl.text = fun.formatNum((itemDes))
        end
    end
end

function VolcanoMissionGiftPackItem:OpenUIShiny(obj)
    local uishiny = fun.get_component(obj,"UIShiny")
    if uishiny and not  uishiny.enabled then
        uishiny.enabled = true
        return true
    end
    return false
end

function VolcanoMissionGiftPackItem:CloseUIShiny(obj)
    local uishiny = fun.get_component(obj, "UIShiny")
    if uishiny then
        uishiny.enabled = false
    end
end

function VolcanoMissionGiftPackItem:SetUIImageGray(btn_obj, active)
    if active then
        local particle = fun.find_child(btn_obj, "particle")
        if particle then
            fun.set_active(particle, false)
        end
    end
    Util.SetUIImageGray(btn_obj.gameObject, active)
end

function VolcanoMissionGiftPackItem:GetGiftPos()
    return self.left_time.transform.position
    , self.reward1_count.transform.position
    , self.reward2_count.transform.position
    , self.reward3_count.transform.position
end

function VolcanoMissionGiftPackItem:GetGiftIcon()
    return self.gift_icon.transform
end

function VolcanoMissionGiftPackItem:DoMoveAnim()
    local localPos = fun.get_localposition(self.go)
    local originY = localPos.y
    fun.set_rect_offset_local_pos(self.go, 0, -540, 0)
    Anim.move(self.go, localPos.x, originY, localPos.z, 0.5, true, true, function()
        
    end)
end

function VolcanoMissionGiftPackItem:on_btn_buy_click()
    if not ModelList.VolcanoMissionModel:IsOpenActivity() then
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
            Event.Brocast(EventName.Event_Buy_VolcanoMission_Buff)
            ModelList.GiftPackModel:ReqEditorBuySucess(self.pID, self.packID)
            self.last_click_time = UnityEngine.Time.time
        end
    else
        UIUtil.show_common_popup(8020, true)
    end
end

return this