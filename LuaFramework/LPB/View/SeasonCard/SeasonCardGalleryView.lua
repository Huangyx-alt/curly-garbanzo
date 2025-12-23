local SeasonCardGalleryPageView = require "View/SeasonCard/SeasonCardGalleryPageView"
local SeasonCardUniversalMenuView = require "View/SeasonCard/SeasonCardUniversalMenuView"
local Toolkit = require "View/SeasonCard/Toolkit"
local SeasonCardGroupItem = require "View/SeasonCard/SeasonCardGroupItem"
local SeasonCardGalleryView = BaseView:New("SeasonCardGalleryView")
local this = SeasonCardGalleryView

this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "left_time_txt",
    "btn_close",
    "btn_total_reward",
    "txtDescription",
    "rewardPanel",
    "rewardItem",
    "rewardState",
    "LeftFunctionBtns",
    "btn_help",
    "PageView",
    "PageItem",
    "CardItem",
    "btn_next_page",
    "btn_pre_page",
    "ScrollView",
    "ScrollContent",
    "GroupItem",
    "rewardItem1",
    "rewardItem2",
    "rewardItem3",
    "btn_collect",
    "bubble",
    "btn_bubble_mask",
    "bubbleItem",
    "bubbleContent",
    "locationRoot",
    "anima",
    "imgTitle",
    "imgTitleBg",
    "titleAnima",
}

function SeasonCardGalleryView:Awake()
end

function SeasonCardGalleryView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
    UISound.play("card_page")
    self.isDragging = false
end

function SeasonCardGalleryView:on_after_bind_ref()
    fun.set_active(self.PageItem, false)
    fun.set_active(self.rewardItem, false)
    fun.set_active(self.GroupItem, false)
    fun.set_active(self.CardItem, false)
    fun.set_active(self.btn_next_page, false)
    fun.set_active(self.btn_pre_page, false)
    fun.set_active(self.bubble, false)
    fun.set_active(self.bubbleItem, false)
    fun.set_active(self.imgTitleBg, true)

    self:InitTitle()
    self:SetLeftTime()
    self:InitPageView()
    self:FillPageView()
    self:InitReward()
    self:InitScrollView()
    self:InitUniversalBtns()
    Facade.SendNotification(NotifyName.SeasonCard.InitSelectCardGroup)

    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"in", "SeasonCardGalleryViewenter"}, false, function() 
            self:MutualTaskFinish()
        end)
    end
    self:DoMutualTask(task)
end

function SeasonCardGalleryView:OnDisable()
    Facade.RemoveViewEnhance(self)
    if self.loopTime then
        LuaTimer:Remove(self.loopTime)
        self.loopTime = nil
    end

    ModelList.SeasonCardModel:ClearShowingGroupId()
end

function SeasonCardGalleryView:InitTitle(isRefresh)
    local groupInfo = ModelList.SeasonCardModel:GetGroupInfo(self.groupId, self.seasonId)
    local nameId = groupInfo.fixedData.name
    local iconName = groupInfo.fixedData.icon
    
    local imgIcon = fun.get_component(self.imgTitle, fun.IMAGE)
    if ModelList.SeasonCardModel.Consts.USE_LOCAL_CARD_RES then
        imgIcon.sprite = AtlasManager:GetSpriteByName("SeasonCardIconGroupS01", iconName)
    else
        ViewTool:LoadSeasonCardSprite(self.seasonId, iconName, imgIcon)
    end

    if isRefresh and fun.is_not_null(self.titleAnima) then
        AnimatorPlayHelper.Play(self.titleAnima, {"act", "imgTitleact"}, false, nil)
    end
end

function SeasonCardGalleryView:SetData(data)
    self.data = data
    self.groupId = data and data.groupId or ModelList.SeasonCardModel:GetShowingGroupId()
    self.seasonId = data and data.seasonId or ModelList.SeasonCardModel:GetShowingSeasonId()
    log.log("SeasonCardGalleryView:SetData", data)
end

function SeasonCardGalleryView:SetGroupIndex(index)
    self.groupIndex = index or 1
end

function SeasonCardGalleryView:InitUniversalBtns()
    local menu = SeasonCardUniversalMenuView:New()
    menu:SetParent(self)
    menu:SkipLoadShow(self.LeftFunctionBtns)
    menu:UpdateState()
end

function SeasonCardGalleryView:InitPageView()
    local pg = fun.get_component(self.PageView, fun.PAGEVIEW)
    self.pageViewCtr = pg

    pg:AddLuaListener("OnBeginDrag", function(idx)
        self:OnBeginDrag(idx)
    end)

    pg:AddLuaListener("OnEndDrag", function(idx)
        self:OnEndDrag(idx)
    end)

    pg:AddLuaListener("OnDrag", function(idx)
        self:OnDrag(idx)
    end)

    pg:AddLuaListener("OnIndexChange", function(idx, lastIdx)
        self:OnIndexChange(idx, lastIdx)
    end)
end

function SeasonCardGalleryView:OnBeginDrag(idx)
    log.log("SeasonCardGalleryView:OnBeginDrag", idx)
end

function SeasonCardGalleryView:OnDrag(idx)
end

function SeasonCardGalleryView:OnEndDrag(idx)
    log.log("SeasonCardGalleryView:OnEndDrag", idx)
end

function SeasonCardGalleryView:OnIndexChange(idx, lastIdx)
    log.log("SeasonCardGalleryView:OnIndexChange", lastIdx, "->", idx)
end

function SeasonCardGalleryView:FillPageView(isRefresh)
    self.pageViewCtr:ClearAllPages()
    local cardIds = self.data.flexibleData.cardIds
    if not cardIds or #cardIds < 1 then
        return
    end

    local pageCount = math.ceil(#cardIds / 9)
    for idx = 1, pageCount do
        local pageData = {}
        pageData.index = idx
        pageData.cardIds = {}
        pageData.seasonId = self.seasonId
        
        for i = (idx - 1) * 9 + 1, idx * 9 do
            if i <= #cardIds then
                table.insert(pageData.cardIds, cardIds[i])
            else
                break
            end
        end
        pageData.groupCount = #pageData.cardIds
        local pageItem = self:CreatePage(pageData)
        if isRefresh then
            pageItem:RefreshItems()
        end
    end

    self.pageViewCtr.dragEnable = pageCount > 1
end

function SeasonCardGalleryView:CreatePage(pageData)
    local go = fun.get_instance(self.PageItem)
    local rt = fun.get_component(go, fun.RECT)
    fun.set_active(go, true)
    self.pageViewCtr:AddPage(rt)
    local page = SeasonCardGalleryPageView:New()
    page:SetData(pageData)
    page:SkipLoadShow(go)
    return page
end

function SeasonCardGalleryView:InitScrollView()
    fun.clear_all_child(self.ScrollContent)
    local groups = ModelList.SeasonCardModel:GetGroups(self.seasonId)
    if not groups or #groups < 1 then
        return
    end

    for index, groupInfo in ipairs(groups) do
        self:CreateGroupItem(index, groupInfo.groupId)
    end
end

function SeasonCardGalleryView:CreateGroupItem(groupIndex, groupId)
    local itemGo = fun.get_instance(self.GroupItem)
    local data = {index = groupIndex, parent = self, groupId = groupId, seasonId = self.seasonId}
    local item = SeasonCardGroupItem:New()
    item:SetData(data)
    item:SkipLoadShow(itemGo)
    item:SetClickEnable(true)
    fun.set_parent(itemGo, self.ScrollContent, true)
    fun.set_active(itemGo, true)
    return item
end

function SeasonCardGalleryView:InitReward()
    fun.clear_all_child(self.rewardPanel)
    local rewards = self.data.fixedData.reward
    for i, v in ipairs(rewards) do
        local item = self:CreateRewardItem(v, i)
        --fun.set_parent(item, self.rewardPanel, true)
    end

    self:UpdateRewardState()
end

function SeasonCardGalleryView:UpdateRewardState()
    local descId = 30079
    if ModelList.SeasonCardModel:IsGroupRewarded(self.groupId) then
        fun.set_active(self.btn_collect, false)
        fun.set_active(self.txtDescription, true)
        descId = 30081
    else
        if ModelList.SeasonCardModel:IsGroupCompleted(self.groupId) then
            fun.set_active(self.btn_collect, true)
            fun.set_active(self.txtDescription, false) -- false
            descId = 30080
        else
            fun.set_active(self.btn_collect, false)
            fun.set_active(self.txtDescription, true)
        end
    end
    self.txtDescription.text = Csv.GetDescription(descId)
end

function SeasonCardGalleryView:CreateRewardItem(rewardData, index)
    local go = self["rewardItem" .. index]
    local ref = fun.get_component(go, fun.REFER)
    local icon = ref:Get("icon")
    local value = ref:Get("value")
    local id = rewardData[1]
    local count = rewardData[2]
    local iconName = Csv.GetItemOrResource(id, "icon")
    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
    --value.text = fun.format_money(count)
    value.text = Toolkit.FormatReward(count)
    fun.set_active(go, true)
    return go
end

function SeasonCardGalleryView:SetLeftTime()
    local expireTime = ModelList.SeasonCardModel:GetActivityExpireTime()
    local currentTime = ModelList.SeasonCardModel:GetCurrentTime()
    self.endTime = expireTime - currentTime
    if self.endTime > 0 then
        if self.loopTime  then
            LuaTimer:Remove(self.loopTime)
            self.loopTime = nil
        end
        self.loopTime = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
            if self.left_time_txt and self.endTime >= 0 then
                self.left_time_txt.text = fun.SecondToStrFormat(self.endTime)
                self.endTime = self.endTime - 1
                if self.endTime <= 0 then
                end
            end
        end,nil,nil,LuaTimer.TimerType.UI)
    end
end

function SeasonCardGalleryView:CloseSelf()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"end", "SeasonCardGalleryViewend"}, false, function()
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.CloseUI, self)
        end)
    end

    self:DoMutualTask(task)
end

function SeasonCardGalleryView:on_btn_close_click()
    self:CloseSelf()
    Facade.SendNotification(NotifyName.SeasonCard.CloseGalleryView)
end

function SeasonCardGalleryView:on_btn_help_click()
end

function SeasonCardGalleryView:on_btn_next_page_click()
    self.pageViewCtr:NextPage()
end

function SeasonCardGalleryView:on_btn_pre_page_click()
    self.pageViewCtr:PrePage()
end

function SeasonCardGalleryView:on_btn_total_reward_click()
end

function SeasonCardGalleryView:on_btn_collect_click()
    ModelList.SeasonCardModel:C2S_ReceiveGroupAward(self.groupId)
end

function SeasonCardGalleryView:OnRefreshGalleryView()
    --self:InitPageView()
    self:FillPageView(true)
    self:InitReward()
    self:InitTitle(true)
    --self:InitScrollView()
end

function SeasonCardGalleryView:OnInitScrollViewPos(params)
    log.log("SeasonCardGalleryView:OnInitScrollViewPos", params)
    local spacing = fun.get_component(self.ScrollContent, fun.HORIZONTALLAYOUT).spacing
    local viewWidth = fun.get_component(self.ScrollView, fun.RECT).rect.width
    local borderR = params.index * (spacing + params.width) - spacing
    if borderR > viewWidth then
        fun.set_gameobject_pos(self.ScrollContent, viewWidth - borderR, 0, 0, true)
    end
end

function SeasonCardGalleryView:OnAdjustScrollViewPos(params)
    
    local basePos = fun.get_rect_anchored_position(self.ScrollContent)
    log.log("SeasonCardGalleryView:OnAdjustScrollViewPos", params, basePos)
    local spacing = fun.get_component(self.ScrollContent, fun.HORIZONTALLAYOUT).spacing
    local viewWidth = fun.get_component(self.ScrollView, fun.RECT).rect.width
    --local borderR = params.index * (spacing + params.width) - spacing
    local borderR = params.pos.x + params.width / 2 + basePos.x
    local borderL = params.pos.x - params.width / 2 + basePos.x
    if borderR > viewWidth then
        local scrollRect = fun.get_component(self.ScrollView, fun.SCROLL_RECT)
        scrollRect.enabled = false
        Anim.move_to_x(self.ScrollContent, viewWidth - borderR + basePos.x, 0.3, function()
            scrollRect.enabled = true
        end)
    elseif borderL < 0 then
        local scrollRect = fun.get_component(self.ScrollView, fun.SCROLL_RECT)
        scrollRect.enabled = false
        Anim.move_to_x(self.ScrollContent,  - borderL + basePos.x, 0.3, function()
            scrollRect.enabled = true
        end)
    end
end

function SeasonCardGalleryView:SetVisible(enable)
    log.log("SeasonCardGalleryView:SetVisible ", enable)
    if fun.is_not_null(self.go) then
        local canvasGroup = fun.get_component(self.go, fun.CANVAS_GROUP)
        if canvasGroup then
            canvasGroup.alpha = enable and 1 or 0
            canvasGroup.blocksRaycasts = enable
        end
    end
end

function SeasonCardGalleryView:OnGroupStateChange(params)
    if params.groupId == self.groupId then
        self:UpdateRewardState()
    end
end

function SeasonCardGalleryView:ShowBubble(params)
    fun.set_active(self.bubble, true)
    fun.clear_all_child(self.bubbleContent)

    local rewards = params.rewards
    for i, v in ipairs(rewards) do
        self:CreateBubbleItem(v)
    end

    fun.set_gameobject_pos(self.locationRoot, params.pos.x, params.pos.y, 0, false)
end

function SeasonCardGalleryView:CreateBubbleItem(reward)
    local itemGo = fun.get_instance(self.bubbleItem)
    fun.set_parent(itemGo, self.bubbleContent, true)
    fun.set_active(itemGo, true)

    local ref = fun.get_component(itemGo, fun.REFER)
    local text1 = ref:Get("Text1")
    local text2 = ref:Get("Text2")
    local icon = ref:Get("icon")

    local iconName = Csv.GetItemOrResource(reward[1], "icon")
    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
    text1.text = ""
    text2.text = fun.format_number(reward[2], true)

    return itemGo
end

function SeasonCardGalleryView:on_btn_bubble_mask_click()
    self:HideBubble()
end

function SeasonCardGalleryView:HideBubble()
    fun.set_active(self.bubble, false)
end

function SeasonCardGalleryView:OnCollectGroupdRewardFinish(params)
    if params.groupId == self.groupId and params.seasonId == self.seasonId then
        self:UpdateRewardState()
    end
end

function SeasonCardGalleryView:OnDrag(params)
    if params.state == LuaEasyTouchDragState.startdrag then
        self:OnDragStart(params)
    elseif params.state == LuaEasyTouchDragState.dragging then
        self:OnDragging(params)
    elseif params.state == LuaEasyTouchDragState.enddrag then
        self:OnDragEnd(params)
    end
end

function SeasonCardGalleryView:OnDragStart(params)
    if not self:IsInFocus() then
        return
    end

    local rect = fun.get_component(self.PageView, fun.RECT)
    --local isInRect = UnityEngine.RectTransformUtility.RectangleContainsScreenPoint(rect, params.startPos)
    local isInRect
    local cameraGo = fun.GameObject_find("Canvas/Camera")
    if cameraGo then
        local uiCamera = fun.get_component(cameraGo, "Camera")
        isInRect = UnityEngine.RectTransformUtility.RectangleContainsScreenPoint(rect, params.startPos, uiCamera)
    end

    if isInRect then
        self.isDragging = true
    end    
end

function SeasonCardGalleryView:OnDragging(params)
    if self.isDragging then
    end
end

function SeasonCardGalleryView:OnDragEnd(params)
    if self.isDragging then
        local offsetX = params.pos.x - params.startPos.x
        if math.abs(offsetX) >= 50  then
            if offsetX > 0 then
                self:PreviousGroup()
            else
                self:NextGroup()
            end
        end
    end

    self.isDragging = false
end

function SeasonCardGalleryView:PreviousGroup()
    local bundle = {}
    bundle.from = self.groupIndex
    bundle.to = bundle.from - 1
    if bundle.to > 0 then
        Facade.SendNotification(NotifyName.SeasonCard.DragSwitchCardGroup, bundle)
    end
end

function SeasonCardGalleryView:NextGroup()
    local bundle = {}
    bundle.from = self.groupIndex
    bundle.to = bundle.from + 1
    if bundle.to <= ModelList.SeasonCardModel:GetGroupCount(self.seasonId) then
        Facade.SendNotification(NotifyName.SeasonCard.DragSwitchCardGroup, bundle)
    end
end

function SeasonCardGalleryView:IsInFocus()
    if CanvasSortingOrderManager.IsViewBackGround(self.viewType, self.go) then
        return false
    end

    if fun.get_active_self(self.bubble) then
        return
    end

    return true
end

function SeasonCardGalleryView:OnForceExit(params)
    self:CloseSelf()
end

--Facade.SendNotification(NotifyName.SceneCity.NotifyDragEvent
--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.SeasonCard.RefreshGalleryView, func = this.OnRefreshGalleryView},
    {notifyName = NotifyName.SeasonCard.InitGalleryViewScrollViewPos, func = this.OnInitScrollViewPos},
    {notifyName = NotifyName.SeasonCard.GroupStateChange, func = this.OnGroupStateChange},
    {notifyName = NotifyName.SeasonCard.ShowSingleCardRewardBubble, func = this.ShowBubble},
    {notifyName = NotifyName.SeasonCard.CollectGroupdRewardFinish, func = this.OnCollectGroupdRewardFinish},
    {notifyName = NotifyName.SceneCity.NotifyDragEvent, func = this.OnDrag},
    {notifyName = NotifyName.SeasonCard.AdjustGalleryViewScrollViewPos, func = this.OnAdjustScrollViewPos},
    {notifyName = NotifyName.SeasonCard.ForceExit, func = this.OnForceExit},
}

return this