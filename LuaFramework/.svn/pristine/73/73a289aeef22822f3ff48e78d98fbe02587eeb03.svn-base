
local WinZoneExchangeConfirmItem2 = BaseView:New("WinZoneExchangeConfirmItem2")
local this = WinZoneExchangeConfirmItem2
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "icon_item",
    "text_num",
    "scaleRoot",
}

function WinZoneExchangeConfirmItem2:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function WinZoneExchangeConfirmItem2:Awake()
    self:on_init()
end

function WinZoneExchangeConfirmItem2:OnEnable()
    self.hasInit = true
    if self.cacheData then
        self:InitItem(self.cacheData)
    end

    local scale = 0.6
    fun.set_gameobject_scale(self.scaleRoot, scale, scale, 0)
end

function WinZoneExchangeConfirmItem2:OnDisable()
    self.hasInit = nil
    self.cacheData = nil
end

function WinZoneExchangeConfirmItem2:GetRewardItemId()
    if self.cacheData then
        return self.cacheData[1]
    end
    return nil
end

function WinZoneExchangeConfirmItem2:GetPosition()
    if self.go then
        return self.go.transform.position
    end
    return nil
end

function WinZoneExchangeConfirmItem2:SetData(data)
    self.cacheData = data
    if self.hasInit then
        self:InitItem(self.cacheData)
    end
end

function WinZoneExchangeConfirmItem2:InitItem(rewardData)
    if not rewardData or not rewardData[1] or not rewardData[2] then
        log.log("WinZoneExchangeConfirmItem2:InitItem 数据错误 ", rewardData)
        return
    end

    local id = rewardData[1]

    if ModelList.SeasonCardModel:IsCardPackage(id) then
        local cardCfg = ModelList.SeasonCardModel:GetCardPackageInfo(id)
        local item_info =  cardCfg and cardCfg.icon or ""
        ViewTool:LoadBattleGiftSprite(nil,self.icon_item,item_info)
    else
        local iconName = Csv.GetItemOrResource(id, "more_icon")
        self.icon_item.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
        self.icon_item:SetNativeSize()
    end

    local num1 = rewardData[2]
    local num2 = rewardData[3] or num1
    if id == RESOURCE_TYPE.RESOURCE_TYPE_HINTTIME then
        num1 = num1 / 60
        num2 = num2 / 60
        if num1 == num2 then
            self.text_num.text = fun.format_number(num1)
        else
            self.text_num.text = fun.format_number(num1) .. "Min-" .. fun.format_number(num2).."Min"
        end
    else

        if num1 == num2 then
            self.text_num.text = fun.format_number(num1)
        else
            self.text_num.text = fun.format_number(num1) .. "-" .. fun.format_number(num2)
        end
    end
end

return this