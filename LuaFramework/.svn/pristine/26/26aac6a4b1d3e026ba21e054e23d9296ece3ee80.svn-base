
local BingoPassAwardItem = BaseView:New("BingoPassAwardItem")
local this = BingoPassAwardItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "img_reward",
    "text_value"
}

function BingoPassAwardItem:New(info)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._info = info
    return o
end

function BingoPassAwardItem:Awake()
    self:on_init()
end

function BingoPassAwardItem:OnEnable()
    self._isInit = true
    self:SetInfo(self._info)
end

function BingoPassAwardItem:SetInfo(info)
    self._info = info
    if self._isInit then
        if info[1] == Resource.hintTime then
            local hrs = math.floor(info[2] / 3600)
            if hrs > 0 then
                self.text_value.text = fun.NumInsertComma(hrs) .. " HRS"
            else
                local min = math.floor(info[2] / 60)
                self.text_value.text = fun.NumInsertComma(min) .. " Min"
            end
        else
            if self._info.kbm then
                self.text_value.text = fun.format_number(info[2])
            else
                --策划要求，如果字符中间是带K，或者M，b 则显示直接显示，如果没有就用千分位
                local str = info[2]
                string.upper(str)
                if string.match(str,"K") or string.match(str,"M") or string.match(str,"B") then 
                    self.text_value.text = info[2]
                else 
                    self.text_value.text = fun.NumInsertComma(info[2])
                end 
            end
        end

        local id = tonumber(info[1])
        local icon = Csv.GetData("new_item", id, "icon")
        --if id <= 1000 then
        --    icon = Csv.GetItemOrResource(id, "more_icon")
        --else
        --    --策划要求，如果是 item_type 为天降奇域的就显示more_icon
        --    local itemData = Csv.GetData("item", id)
        --    if itemData ~= nil and itemData.item_type == ItemType.rofy then
        --        icon = Csv.GetItemOrResource(id, "more_icon")
        --    
        --    else 
        --        icon = Csv.GetItemOrResource(id, "icon")
        --    end 
        --end
        if not fun.is_empty_str(icon) then
            fun.set_active(self.img_reward, true)
            self.img_reward.sprite = AtlasManager:GetSpriteByName("BingoBangItemAtlas", icon)
        else
            fun.set_active(self.img_reward, false)
        end
        --self.img_reward.sprite = AtlasManager:GetSpriteByName("ItemAtlas", icon)
        --self.img_reward:SetNativeSize()
    end
end

function BingoPassAwardItem:SetActive(active)
    if self.go then
        fun.set_active(self.go,active)
    end
end

function BingoPassAwardItem:GetPosition()
    if self.img_reward then
        return self.img_reward.transform.position
    end
    return Vector3.New(0,0,0)
end

function BingoPassAwardItem:GetRewardItemId()
    if self._info then
        return tonumber(self._info[1])
    end
    return 0
end

function BingoPassAwardItem:GetRewardItemIcon()
    if self.img_reward then
        return self.img_reward
    end
    return nil
end

function BingoPassAwardItem:OnDisable()
end

function BingoPassAwardItem:on_close()
end

function BingoPassAwardItem:OnDestroy()
end

return this