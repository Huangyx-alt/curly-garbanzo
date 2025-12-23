local SeasonCardClownCardExchangeItem = require "View/CommonView/SeasonCardClownCardExchangeItem"
local SeasonCardClownCardExchangeGroup = BaseView:New("SeasonCardClownCardExchangeGroup")
local this = SeasonCardClownCardExchangeGroup
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "titlePanel",
    "cardsPanel",
    "titleBg1",
    "titleB2",
    "txtTitle",
    "rewardItem",
    "rewardPanel",
    "cardItem",
    "txtProgress",
}

function SeasonCardClownCardExchangeGroup:New()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function SeasonCardClownCardExchangeGroup:Awake()
end

function SeasonCardClownCardExchangeGroup:OnEnable()
    Facade.RegisterView(self)
end

function SeasonCardClownCardExchangeGroup:on_after_bind_ref()
    fun.set_active(self.cardItem, false)
    fun.set_active(self.rewardItem, false)
    if self.groupInfo and self.fixedData then
        self:InitTitle()
        self:InitReward()
        self:InitGroupView()
    end
end

function SeasonCardClownCardExchangeGroup:SetData(data)
    self.data = data
    self.index = data.index
    self.groupInfo = data.groupInfo
    self.host = data.host
    self.seasonId = data.seasonId
    self.fixedData = ModelList.SeasonCardModel:GetGroupFixedData(data.groupInfo.groupId, self.seasonId)
    self.isBig = #data.groupInfo.cards >= 6
end

function SeasonCardClownCardExchangeGroup:InitGroupView()
    fun.clear_all_child(self.cardsPanel)
    self.cardList = {}
    for index, card in ipairs(self.groupInfo.cards) do
        local cardItem = self:CreateCardItem(index, card.cardId)
        table.insert(self.cardList, cardItem)
    end
end

function SeasonCardClownCardExchangeGroup:RefreshGroupView()
    local usedCardCount = 0
    local cardItem
    for index, card in ipairs(self.groupInfo.cards) do
        if self.cardList[index] then
            cardItem = self.cardList[index]
            local data = {index = index, parent = self, cardId = card.cardId}
            cardItem:SetData(data)
            fun.set_active(cardItem.go, true)
            cardItem:SetOnlyShowBasicInfo()
            cardItem:SetClickEnable(true)
            cardItem:Refresh()
            cardItem:UpdateSelectState(self.host:GetSelectCardId())
        else
            cardItem = self:CreateCardItem(index, card.cardId)
            table.insert(self.cardList, cardItem)
        end
        usedCardCount = usedCardCount + 1
    end

    for i = usedCardCount + 1, #self.cardList do
        fun.set_active(self.cardList[i].go, false)
    end
end

function SeasonCardClownCardExchangeGroup:CreateCardItem(cardIndex, cardId)
    local itemGo = fun.get_instance(self.cardItem)
    local data = {index = cardIndex, parent = self, cardId = cardId}
    local item = SeasonCardClownCardExchangeItem:New()
    item:SetData(data)
    item:SetOnlyShowBasicInfo()
    item:SkipLoadShow(itemGo)
    item:SetClickEnable(true)    
    fun.set_parent(itemGo, self.cardsPanel, true)
    fun.set_active(itemGo, true)
    return item
end

function SeasonCardClownCardExchangeGroup:InitTitle()
    --group name 
    local nameId = self.fixedData.name
    self.txtTitle.text = Csv.GetData("description", nameId, "description")

    --collect progress
    local progress = self.groupInfo.progress or 0
    local totalCardNum = self.groupInfo.totalCardNum or 9
    self.txtProgress.text = progress .. "/" .. totalCardNum
end

function SeasonCardClownCardExchangeGroup:InitReward()
    fun.clear_all_child(self.rewardPanel)
    local rewards = self.fixedData.reward
    for i, v in ipairs(rewards) do
        local item = self:CreateRewardItem(v)
        fun.set_parent(item, self.rewardPanel, true)
        fun.set_active(item, true)
    end
end

function SeasonCardClownCardExchangeGroup:CreateRewardItem(rewardData)
    local rewardItem = fun.get_instance(self.rewardItem)
    local ref = fun.get_component(rewardItem, fun.REFER)
    local icon = ref:Get("icon")
    local value = ref:Get("value")
    local id = rewardData[1]
    local count = rewardData[2]
    local iconName = Csv.GetItemOrResource(id, "icon")
    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
    value.text = count
    return rewardItem
end

function SeasonCardClownCardExchangeGroup:GetDataKey()
    return self.index
end

function SeasonCardClownCardExchangeGroup:SetActive(active)
    fun.set_active(self.go, active)
end

function SeasonCardClownCardExchangeGroup:CanHandleData(groupData)
    local isBig = #groupData.cards >= 6
    return self.isBig == isBig
end

function SeasonCardClownCardExchangeGroup:Refresh()
    if self.groupInfo and self.fixedData then
        self:InitTitle()
        self:InitReward()
        --self:InitGroupView()
        self:RefreshGroupView()
    end
end

return this