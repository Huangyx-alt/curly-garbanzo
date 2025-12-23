
ShopTopItemChildView = ShopChildItemBaseView:New()
local  this = ShopTopItemChildView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "c_biao1",
    "text_item_name",
    "text_items_describe",
    "text_bonus1",
    "text_bonus2",
    "text_bonus3",
    "text_cost",
    "btn_top_di",
    "img_icon_res1",
    "img_icon_res2",
    "img_icon_res3",
    "img_bg",
    "img_mask",
    "img_claimed",
    "img_countdown",
    "img_soldout",
    "img_comeback",
    "text_comeback",
    "anima",
    "LH_Tip",
    "text_bonus_panel1",
    "text_bonus11",
    "text_bonus12",
    "text_bonus_panel2",
    "text_bonus21",
    "text_bonus22",
    "text_bonus_panel3",
    "text_bonus31",
    "text_bonus32",
    "tag_time_limit",
    "text_times1",
}

function ShopTopItemChildView:New(shopItem)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._shopItem = shopItem
    return o
end

function ShopTopItemChildView:Awake()
    self:on_init()
end

function ShopTopItemChildView:OnEnable()
    self:RegisterEvent()
    self:BuildFsm("ShopTopItemChildView")
    self:CheckState(true)
end

function ShopTopItemChildView:OnDisable()
    self:RemoveEvent()
    self:DisposeFsm()
    self:StopTimer()
end

function ShopTopItemChildView:on_close()

end

function ShopTopItemChildView:OnDestroy()
    self._shopItem = nil
end

function ShopTopItemChildView:SetAvailable()
    self:SetItemInfo()
    fun.set_active(self.img_mask.transform,false)
    fun.set_active(self.c_biao1.transform,true)
    fun.set_active(self.text_cost,true)
    --AnimatorPlayHelper.Play(self.anima,"efShopItemTopstart",false,nil)
end

function ShopTopItemChildView:SetDisable()
    self:SetItemInfo()
    fun.set_active(self.img_mask.transform,true)
    fun.set_active(self.img_claimed.transform,true)
    fun.set_active(self.img_countdown.transform,false)
    fun.set_active(self.img_comeback.transform,false)
    fun.set_active(self.text_comeback.transform,false)

    fun.set_active(self.c_biao1.transform,false)
    fun.set_active(self.text_cost,false)
    --AnimatorPlayHelper.Play(self.anima,"efShopItemTopidle",false,nil)
end

function ShopTopItemChildView:SetCountdDown()
    self:SetItemInfo()
    fun.set_active(self.img_mask.transform,true)
    fun.set_active(self.img_claimed.transform,false)
    fun.set_active(self.img_countdown.transform,true)
    fun.set_active(self.img_comeback.transform,true)
    fun.set_active(self.text_comeback.transform,true)

    fun.set_active(self.c_biao1.transform,false)
    fun.set_active(self.text_cost,false)

    self:StartTimer()
end

---[[ 要单独处理，跟底部商品规则不一样，这里canBuyCount为0显示倒计时，底部商品canBuyCount大于0显示倒计时
function ShopTopItemChildView:CheckState(isinit)
    if self._shopItem then
        --log.r("===========================>>CheckState " .. self._shopItem.id .. "    " .. self._shopItem.canBuyCount .. "   " .. self._shopItem.nextUnix)
        if self._shopItem.canBuyCount == 0 and (self._shopItem.nextUnix > 0 and os.time() < self._shopItem.nextUnix) then --没有次数了
            self._fsm:GetCurState():Change2CountDown(self._fsm,isinit)
        elseif self._shopItem.canBuyCount == 0 and (self._shopItem.nextUnix <= 0 or os.time() >= self._shopItem.nextUnix) then --正处于cd时间
            self._fsm:GetCurState():Change2Disable(self._fsm,isinit)
        else
            self._fsm:GetCurState():Change2Available(self._fsm,isinit)
        end
    end
end
--]]

function ShopTopItemChildView:StartTimer()
    --[[
    self:StopTimer()
    self._remainTime = math.max(2,self._shopItem.nextUnix - os.time()) + 10 -- 60 * 60 --测试
    if self._remainTime > 0 then
        self._timer = Timer.New(function()
            self:OnTimerCall(true)
        end,1,self._remainTime)
        self._timer:Start()
    end
    self:OnTimerCall()
    --]]

    self._remainTime = math.max(2,self._shopItem.nextUnix - os.time()) + 10 -- 60 * 60 --测试
end

--[[
function ShopTopItemChildView:OnTimerCall(sub)
    if sub then
        self._remainTime = math.max(0,self._remainTime - 1)
    end
    if self._remainTime <= 0 then
        self:StopTimer()
        --self._fsm:GetCurState():ResetState(self._fsm)
        --self:CheckState()
        ModelList.MainShopModel.C2S_RefreshShopInfo()
    else
        local day = math.floor(self._remainTime/60/60/24)
        local hour = 0
        local minute =  0
        local second = 0
        if day > 0 then
            hour = math.floor((self._remainTime % (60 * 60 * 24)) / 60 / 60)
            self.text_comeback.text = string.format("%sd %sh",day,hour)
        else
            hour = math.floor(self._remainTime / 60 / 60)
            if (hour > 0) then
                minute = math.floor((self._remainTime % (60 * 60)) / 60)
                self.text_comeback.text = string.format("%sh %sm",hour, minute)
            else
                minute =  math.floor(self._remainTime / 60)
                second = math.floor(self._remainTime % 60)
                self.text_comeback.text = string.format("%sm %ss",minute, second)
            end
        end
    end
end
--]]

function ShopTopItemChildView:UpdateCountdown()
    if self._remainTime then
        self._remainTime = math.max(0,self._remainTime - 1)
        local day = math.floor(self._remainTime/60/60/24)
        local hour = 0
        local minute =  0
        local second = 0
        if day > 0 then
            hour = math.floor((self._remainTime % (60 * 60 * 24)) / 60 / 60)
            self.text_comeback.text = string.format("%sd %sh",day,hour)
        else
            hour = math.floor(self._remainTime / 60 / 60)
            if (hour > 0) then
                minute = math.floor((self._remainTime % (60 * 60)) / 60)
                self.text_comeback.text = string.format("%sh %sm",hour, minute)
            else
                minute =  math.floor(self._remainTime / 60)
                second = math.floor(self._remainTime % 60)
                self.text_comeback.text = string.format("%sm %ss",minute, second)
            end
        end
        if self._remainTime <= 0 then
            self._remainTime = nil
            ModelList.MainShopModel.C2S_RefreshShopInfo()
        end
    end
end

function ShopTopItemChildView:SetItemInfo()
    if self._shopItem then
        local shopData = Csv.GetData("shop",self._shopItem.id,nil)
        if shopData then
            self.img_bg.sprite = AtlasManager:GetSpriteByName("ShopAtlas",shopData.icon)
            self.text_item_name.text = shopData.name
            self.text_items_describe.text = shopData.description
            self.text_bonus1.text = fun.NumInsertComma(shopData.item_description[1][2])
            if shopData.item[2] then
                self.text_bonus2.text = fun.NumInsertComma(shopData.item_description[2][2])
            else
                self.text_bonus2.text = "0"
            end
            if shopData.item[3] then
                self.text_bonus3.text = fun.NumInsertComma(shopData.item_description[3][2])
            else
                self.text_bonus3.text = "0"
            end
            self.text_cost.text = string.format("$%s",shopData.price)

            local resData = Csv.GetData("resources",shopData.item[1][1])
            if resData then
                self.img_icon_res1.sprite = AtlasManager:GetSpriteByName("ItemAtlas",resData.icon)
            end
            if shopData.item[2] then
                resData = Csv.GetData("resources",shopData.item[2][1])
                if resData then
                    self.img_icon_res2.sprite = AtlasManager:GetSpriteByName("ItemAtlas",resData.icon)
                end
            end
            if shopData.item[3] then
                resData = Csv.GetData("resources",shopData.item[3][1])
                if resData then
                    self.img_icon_res3.sprite = AtlasManager:GetSpriteByName("ItemAtlas",resData.icon)
                end
            end
            self:CheckHaveGiftPackage(shopData)

            self:SetItemPromotionInfo(shopData)
        end
    end
end

function ShopTopItemChildView:on_btn_top_di_click()
    self._fsm:GetCurState():ShopItemClick(self._fsm)
end

function ShopTopItemChildView:FillPromotionQuantity(shopData, index)
    if not shopData.item[index] then
        return
    end

    if not shopData.item[index][2]then
        return
    end

    if not shopData.item_sale[index] then
        return
    end

    if not shopData.item_sale[index][2]then
        return
    end

    if shopData.item[index][2] == shopData.item_sale[index][2]then
        return
    end

    fun.set_active(self["text_bonus_panel" .. index], true)
    fun.set_active(self["text_bonus" .. index], false)

    if self["text_bonus" .. index .. "1"] then
        self["text_bonus" .. index .. "1"].text = fun.NumInsertComma(shopData.item_description[index][2])
    end

    if self["text_bonus" .. index .. "2"] and shopData.item_sale[index] then
        self["text_bonus" .. index .. "2"].text = fun.NumInsertComma(shopData.item_description_sale[index][2])
    end
end

function ShopTopItemChildView:SetItemPromotionInfo(shopData)
    if not shopData then
        return
    end

    fun.set_active(self.text_bonus_panel1, false)
    fun.set_active(self.text_bonus_panel2, false)
    fun.set_active(self.tag_time_limit, false)
    fun.set_active(self.text_bonus1, true)
    fun.set_active(self.text_bonus2, true)
    fun.set_active(self.text_bonus3, true)

    if ModelList.MainShopModel:IsPromotionValid() and self:IsInPromotion(shopData) then
        self.text_items_describe.text = shopData.description_sale
        fun.set_active(self.tag_time_limit, true)
        self:FillPromotionQuantity(shopData, 1)
        self:FillPromotionQuantity(shopData, 2)
        self:FillPromotionQuantity(shopData, 3)

        if self.text_times1 then
            local total_times = shopData.frequency_sale or 0
            local remain_times = self._shopItem and self._shopItem.promoBuyCount or 0
            self.text_times1.text = remain_times .. "/" .. total_times
        end
    end
end

--刷新UI
function ShopTopItemChildView:UpdateUIInfo()
    if self.SetItemInfo then
        self:SetItemInfo()
    end  
end

return this