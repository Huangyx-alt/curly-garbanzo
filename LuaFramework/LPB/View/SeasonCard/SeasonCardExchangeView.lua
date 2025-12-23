local SeasonCardExchangeItem = require "View/SeasonCard/SeasonCardExchangeItem"
local SeasonCardExchangeView = BaseDialogView:New('SeasonCardExchangeView', "SeasonCardExchange")
local this = SeasonCardExchangeView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "btn_close",
    "Text1",
    "Text2",
    "ScrollView",
    "ScrollContent",
    "boxItem",
    "imgbg",
    "bubble",
    "btn_bubble_mask",
    "bubbleItem",
    "panel1",
    "panel2",
    "bubbleBg",
    "locationRoot",
    "item1",
    "item2",
    "item3",
    "anima",
}

function SeasonCardExchangeView:Awake()
end

function SeasonCardExchangeView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
end

function SeasonCardExchangeView:on_after_bind_ref()    
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"in", "SeasonCardExchangeViewenter"}, false, function() 
            self:MutualTaskFinish()
        end)
    end

    self:DoMutualTask(task)
    self:InitView()
end

function SeasonCardExchangeView:InitView()
    fun.set_active(self.boxItem, false)
    fun.set_active(self.bubbleItem, false)
    fun.set_active(self.bubble, false)
    self.Text1.text = "You have "

    local boxIds = ModelList.SeasonCardModel:GetBoxIds()
    --fun.clear_all_child(self.ScrollContent)
    for index, id in ipairs(boxIds) do
        self:CreateItem(index, id)
    end

    local scrollRect = fun.get_component(self.ScrollView, fun.SCROLL_RECT)
    scrollRect.enabled = #boxIds > 3

    self:UpdateStarCount()
end

function SeasonCardExchangeView:UpdateStarCount(count)
    local count = count or ModelList.SeasonCardModel:GetStarCount() or 0
    self.Text2.text = count
end

function SeasonCardExchangeView:CreateItem(index, id)
    --local itemGo = fun.get_instance(self.boxItem)
    local itemGo = self["item" .. index]
    local item = SeasonCardExchangeItem:New()
    local data = {boxId = id, index = index}
    item:SetData(data)
    item:SkipLoadShow(itemGo)
    fun.set_parent(itemGo, self.ScrollContent, true)
    fun.set_active(itemGo, true)
    return item
end

function SeasonCardExchangeView:OnDisable()
    Facade.RemoveViewEnhance(self)
end

function SeasonCardExchangeView:CloseSelf()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"end", "SeasonCardExchangeViewend"}, false, function()
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.HideDialog, self)
        end)
    end

    self:DoMutualTask(task)
end

function SeasonCardExchangeView:on_btn_close_click()
    self:CloseSelf()
end

function SeasonCardExchangeView:on_btn_bubble_mask_click()
    self:HideBubble()
end

function SeasonCardExchangeView:HideBubble()
    fun.set_active(self.bubble, false)
end

function SeasonCardExchangeView:CreateBubbleItem(reward)
    local itemGo = fun.get_instance(self.bubbleItem)
    fun.set_parent(itemGo, self.panel1, true)
    fun.set_active(itemGo, true)

    local ref = fun.get_component(itemGo, fun.REFER)
    local text1 = ref:Get("Text1")
    local text2 = ref:Get("Text2")
    local icon = ref:Get("icon")

    local iconName = Csv.GetItemOrResource(reward[1], "more_icon")
    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
    local from = fun.format_number(reward[2], true)
    local to = fun.format_number(reward[3], true)
    text1.text = ""
    text2.text = from .. "-" .. to

    return itemGo
end

function SeasonCardExchangeView:CreateBubbleSpecialItem(iconName)
    local itemGo = fun.get_instance(self.bubbleItem)
    fun.set_parent(itemGo, self.panel1, true)
    fun.set_active(itemGo, true)
    local ref = fun.get_component(itemGo, fun.REFER)
    local text1 = ref:Get("Text1")
    local text2 = ref:Get("Text2")
    local icon = ref:Get("icon")
    text1.text = ""
    text2.text = ""
    --[[
    icon.sprite = AtlasManager:GetSpriteByName("SeasonCardOpenPackage", iconName)
    local rect  = fun.get_component(icon, fun.RECT)
    rect.sizeDelta = Vector2.New(143, 231)
    --]]

    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)

    return itemGo
end

function SeasonCardExchangeView:ShowClownCardInfo(iconName)
    local itemGo = self.panel2
    fun.set_active(itemGo, true)

    local ref = fun.get_component(itemGo, fun.REFER)
    local text1 = ref:Get("Text1")
    local text2 = ref:Get("Text2")
    local text3 = ref:Get("Text3")
    local icon = ref:Get("icon")

    --[[暂不处理，小丑卡当前只一种样式
    if iconName then
        icon.sprite = AtlasManager:GetSpriteByName("XXXXAtlas", iconName)
    end
    ]]

    local descCode = 30038
    text1.text = ""
    text2.text = Csv.GetDescription(descCode)
    text3.text = ""

    return itemGo
end

function SeasonCardExchangeView:ShowBubble(params)
    fun.set_active(self.bubble, true)
    fun.clear_all_child(self.panel1)
    self:CreateBubbleSpecialItem(params.packageIcon)
    local rewards = params.rewards
    for i, v in ipairs(rewards) do
        self:CreateBubbleItem(v)
    end

    local hasClownCard = params.hasClownCard
    if hasClownCard then
        fun.set_active(self.panel2, true)
        self:ShowClownCardInfo()
    else
        fun.set_active(self.panel2, false)
    end
    fun.set_gameobject_pos(self.locationRoot, params.pos.x, params.pos.y, 0, false)
    --fun.set_rect_anchored_position(self.bubbleBg, 0, params.pos.y)
end

function SeasonCardExchangeView:OnStarCountChange(params)
    local from = params.from
    local to = params.to
    local offset = params.offset
    self:UpdateStarCount(to)
end

function SeasonCardExchangeView:OnForceExit(params)
    self:CloseSelf()
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.SeasonCard.ShowExchangeBoxBubble, func = this.ShowBubble},
    {notifyName = NotifyName.SeasonCard.StarCountChange, func = this.OnStarCountChange},
    {notifyName = NotifyName.SeasonCard.ForceExit, func = this.OnForceExit},
}

return this