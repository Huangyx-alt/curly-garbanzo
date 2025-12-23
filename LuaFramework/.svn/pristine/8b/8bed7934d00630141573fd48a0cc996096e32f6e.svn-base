

local RewardShowTipItem = BaseView:New("RewardShowTipItem")
local this = RewardShowTipItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "icon_item",
    "text_num"
}

function RewardShowTipItem:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function RewardShowTipItem:Awake()
    self:on_init()
end

function RewardShowTipItem:OnEnable()
    self._init = true
    if self.cacheData then
        self:SetReward(self.cacheData)
    end
end

function RewardShowTipItem:OnDisable()
    self:Close()
    self._init = nil
    self.cacheData = nil
end

function RewardShowTipItem:OnDestroy()

end

function RewardShowTipItem:on_close()

end

function RewardShowTipItem:SetReward(data)
    self.cacheData = data
    if self._init then
        if data.id then
            local icon = Csv.GetItemOrResource(data.id,"icon")
            if fun.is_ios_platform() then
                if icon == "ZBJL" then
                    icon = "ZBJLold"
                elseif icon == "ZBDwJl" then
                    icon = "ZBDwJlold"
                end
            end
            Cache.SetImageSprite("ItemAtlas",icon,self.icon_item)
            self.text_num.text = self:GenNumberText({id = data.id,value = data.value})
            -- if fun.CheckIsAmazonCard(data.id) then
            --     self.text_num.text = fun.GetAmazonCardDescription(data.id)
            -- else
            --     self.text_num.text = self:GenNumberText({id = data.id,value = data.value})
            -- end
        else
            local icon = Csv.GetItemOrResource(data[1],"icon")
            if fun.is_ios_platform() then
                if icon == "ZBJL" then
                    icon = "ZBJLold"
                elseif icon == "ZBDwJl" then
                    icon = "ZBDwJlold"
                end
            end
            Cache.SetImageSprite("ItemAtlas",icon,self.icon_item)
            self.text_num.text = self:GenNumberText({id = data[1],value = data[2]})
            -- if fun.CheckIsAmazonCard(data[1]) then
            --     self.text_num.text = fun.GetAmazonCardDescription(data[1])
            -- else
            --     self.text_num.text = self:GenNumberText({id = data[1],value = data[2]})
            -- end
        end
    end
end

function RewardShowTipItem:GenNumberText(data)
    if not data or not data.value then
        return ""
    end

    if (data.id  == Resource.hintTime ) or (data.id == RESOURCE_TYPE.RESOURCE_TYPE_VICTORY_BEATS_DOUBLE_NOTE_BUFF) then
        ---放大镜数量转化成时间
        local ti = data.value
        local hrs = math.floor(ti / 3600)
        if hrs > 0 then
            return fun.NumInsertComma(hrs) .. " HRS" --tostring(data.value)
        else
            local min = math.floor(ti / 60)
            return fun.NumInsertComma(min) .. " Min" --tostring(data.value)
        end
    else
        local item_type = Csv.GetData("item", data.id, "item_type")
        if item_type == 17 then
            local ti = data.value
            local hrs = math.floor(ti / 60)
            if hrs > 0 then
                return fun.NumInsertComma(hrs) .. " HRS" --tostring(data.value)
            else
                local min = math.floor(ti)
                return fun.NumInsertComma(min) .. " Min" --tostring(data.value)
            end
        else
            return fun.format_reward(data)
        end
    end
end

return this