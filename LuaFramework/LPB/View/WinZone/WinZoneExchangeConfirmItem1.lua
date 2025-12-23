
local WinZoneExchangeConfirmItem1 = BaseView:New("WinZoneExchangeConfirmItem1")
local this = WinZoneExchangeConfirmItem1
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "icon_item",
    "text_num",
    "scaleRoot",
}

function WinZoneExchangeConfirmItem1:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function WinZoneExchangeConfirmItem1:Awake()
    self:on_init()
end

function WinZoneExchangeConfirmItem1:OnEnable()
    self.hasInit = true
    if self.cacheData then
        self:InitItem(self.cacheData)
    end

    local scale = 1
    fun.set_gameobject_scale(self.scaleRoot, scale, scale, 0)
end

function WinZoneExchangeConfirmItem1:OnDisable()
    self.hasInit = nil
    self.cacheData = nil
end

function WinZoneExchangeConfirmItem1:GetRewardItemId()
    if self.cacheData then
        return self.cacheData[1]
    end
    return nil
end

function WinZoneExchangeConfirmItem1:GetPosition()
    if self.go then
        return self.go.transform.position
    end
    return nil
end

function WinZoneExchangeConfirmItem1:SetData(data)
    self.cacheData = data
    if self.hasInit then
        self:InitItem(self.cacheData)
    end
end

function WinZoneExchangeConfirmItem1:InitItem(rewardData)
    if not rewardData or not rewardData[1] or not rewardData[2] then
        log.log("WinZoneExchangeConfirmItem1:InitItem 数据错误 ", rewardData)
        return
    end

    local id = rewardData[1]
    local iconName = Csv.GetItemOrResource(id, "more_icon")
    self.icon_item.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
    self.icon_item:SetNativeSize()

    local num1 = rewardData[2]
    local num2 = rewardData[3] or num1
    if num1 == num2 then
        self.text_num.text = fun.format_number(num1)
    else
        self.text_num.text = fun.format_number(num1) .. "-" .. fun.format_number(num2)
    end
end

return this