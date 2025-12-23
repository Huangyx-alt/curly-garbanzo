local SeasonCardGroupItem = BaseView:New("SeasonCardGroupItem")
local this = SeasonCardGroupItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "imgBg",
    "imgIcon",
    "progressBg",
    "progressBar",
    "txtProgress",
    "imgLock",
    "imgNew",
    "btn_group",
    "scalePanel",
    "imgSelect1",
    "imgSelect2",
    "nameBg",
    "txtName",
    "iconFinish",
    "imgGiftBg",
    "imgSelect3",
}

function SeasonCardGroupItem:New()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function SeasonCardGroupItem:Awake()
end

function SeasonCardGroupItem:OnEnable()
    Facade.RegisterViewEnhance(self)
    self.isSelected = false
end

function SeasonCardGroupItem:on_after_bind_ref()
    fun.set_active(self.imgSelect1, false)
    fun.set_active(self.imgSelect2, false)
    fun.set_active(self.imgSelect3, false)
    self:InitItem()
end

function SeasonCardGroupItem:OnDisable()
    Facade.RemoveViewEnhance(self)
    self.onlyShowBasicInfo = false
end

function SeasonCardGroupItem:SetData(data)
    self.data = data
    self.parent = data.parent
    self.index = data.index or 0
    self.groupId = data.groupId
    self.seasonId = data.seasonId
    self.groupInfo = ModelList.SeasonCardModel:GetGroupInfo(data.groupId, data.seasonId)
    log.log("SeasonCardGroupItem:SetData", data)
end

function SeasonCardGroupItem:SetOnlyShowBasicInfo()
    self.onlyShowBasicInfo = true
end

function SeasonCardGroupItem:InitItem()
    if not self.groupInfo then
        return
    end
    self:InitBasicElement()
    self:UpdateState(true)
end

function SeasonCardGroupItem:InitBasicElement()
    local nameId = self.groupInfo.fixedData.name
    local iconName = self.groupInfo.fixedData.icon
    local imgIcon = fun.get_component(self.imgIcon, fun.IMAGE)
    if ModelList.SeasonCardModel.Consts.USE_LOCAL_CARD_RES then
        imgIcon.sprite = AtlasManager:GetSpriteByName("SeasonCardIconGroupS01", iconName)
    else
        ViewTool:LoadSeasonCardSprite(self.seasonId, iconName, imgIcon)
    end
    self.txtName.text = Csv.GetData("description", nameId, "description")
end

function SeasonCardGroupItem:UpdateState(isForce)
    if self.onlyShowBasicInfo and not isForce then
        return
    end

    local progress = self.groupInfo.flexibleData.progress or 0
    local totalCardNum = self.groupInfo.flexibleData.totalCardNum or 9
    self.txtProgress.text = progress .. "/" .. totalCardNum
    self.progressBar.fillAmount = progress / totalCardNum

    if self.groupInfo.flexibleData.isLocked then
        fun.set_active(self.imgLock, true)
    else
        fun.set_active(self.imgLock, false)
    end
    --固定不显示了
    fun.set_active(self.imgLock, false)

    if self.groupInfo.flexibleData.hasNewSeasonCard then
        fun.set_active(self.imgNew, true)
    else
        fun.set_active(self.imgNew, false)
    end

    if self.groupInfo.flexibleData.isCompleted then
        fun.set_active(self.iconFinish, true)
    else
        fun.set_active(self.iconFinish, false)
    end

    if self:IsHasReward() then
        fun.set_active(self.imgGiftBg, true)
        fun.set_active(self.imgNew, false)
    else
        fun.set_active(self.imgGiftBg, false)
    end

    self:SetGray(progress == 0)
end

function SeasonCardGroupItem:IsHasReward()
    return ModelList.SeasonCardModel:IsGroupHasProgressReward(self.groupId) or ModelList.SeasonCardModel:IsGroupHasSingleCardReward(self.groupId)
end

function SeasonCardGroupItem:SetGray(isGray)
    isGray = false
    --[[直接递归的设置所有子节点
    Util.SetUIImageGray(self.go, isGray)
    --]]

    -- Util.SetUIImageGray(self.imgBg.gameObject, isGray)
    Util.SetUIImageGray(self.imgIcon.gameObject, isGray)
    -- Util.SetUIImageGray(self.progressBg.gameObject, isGray)
    -- Util.SetUIImageGray(self.progressBar.gameObject, isGray)
    -- Util.SetUIImageGray(self.txtProgress.gameObject, isGray)
    -- Util.SetUIImageGray(self.imgLock.gameObject, isGray)
    -- Util.SetUIImageGray(self.imgNew.gameObject, isGray)
    -- Util.SetUIImageGray(self.btn_group.gameObject, isGray)
    -- Util.SetUIImageGray(self.imgSelect1.gameObject, isGray)
    -- Util.SetUIImageGray(self.imgSelect2.gameObject, isGray)
    -- Util.SetUIImageGray(self.nameBg.gameObject, isGray)
    -- Util.SetUIImageGray(self.txtName.gameObject, isGray)
    -- Util.SetUIImageGray(self.iconFinish.gameObject, isGray)
end

function SeasonCardGroupItem:SetNewIconVisible(visible)
    fun.set_active(self.imgNew, visible)
end

function SeasonCardGroupItem:SetGiftIconVisible(visible)
    fun.set_active(self.imgGiftBg, visible)
end

function SeasonCardGroupItem:SetLockIconVisible(visible)
    fun.set_active(self.imgLock, visible)
end

function SeasonCardGroupItem:on_btn_group_click()
    if not self.clickEnable then
        return
    end

    if ModelList.SeasonCardModel:GetShowingGroupId() == self.groupId then
        return
    end

    ModelList.SeasonCardModel:SetShowingGroupId(self.groupId)
    ModelList.SeasonCardModel:EnterGroup(self.groupId)
    ViewList.SeasonCardGalleryView:SetData(self.groupInfo)
    ViewList.SeasonCardGalleryView:SetGroupIndex(self.index)
    if self.parent == ViewList.SeasonCardGalleryView then
        Facade.SendNotification(NotifyName.SeasonCard.RefreshGalleryView)
        Facade.SendNotification(NotifyName.SeasonCard.SwitchCardGroup)
        self:AdjustPos()
    else
        Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardGalleryView)
        Facade.SendNotification(NotifyName.SeasonCard.HideCardGroupView)
    end
end

function SeasonCardGroupItem:SetClickEnable(enable)
    self.clickEnable = enable
end

function SeasonCardGroupItem:SelectCardGroup()
    if self.parent == ViewList.SeasonCardGalleryView then
        local showingGropId = ModelList.SeasonCardModel:GetShowingGroupId()
        if self.groupId == showingGropId then
            fun.set_gameobject_scale(self.scalePanel, 0.8, 0.8, 1)
            self.isSelected = true
            log.log("SeasonCardGroupItem:SelectCardGroup ", self.index)
            fun.set_active(self.imgSelect1, true)
            fun.set_active(self.imgSelect3, true)
        else
            fun.set_gameobject_scale(self.scalePanel, 0.7, 0.7, 1)
            self.isSelected = false
            fun.set_active(self.imgSelect1, false)
            fun.set_active(self.imgSelect3, false)
        end
    else
    end
end

function SeasonCardGroupItem:OnSwitchCardGroup()
    self:SelectCardGroup()
end

function SeasonCardGroupItem:OnInitSelectCardGroup()
    self:SelectCardGroup()
    if self.isSelected then
        self:AdjustPos(true)
    end
end

function SeasonCardGroupItem:AdjustPos(isInit)
    local pos = fun.get_gameobject_pos(self.go, true)
    pos = fun.get_rect_anchored_position(self.go)
    local rect = fun.get_component(self.go, fun.RECT)
    local bundle = {}
    bundle.pos = pos
    bundle.width = rect.rect.width
    bundle.index = self.data.index
    if isInit then
        Facade.SendNotification(NotifyName.SeasonCard.InitGalleryViewScrollViewPos, bundle)
    else
        Facade.SendNotification(NotifyName.SeasonCard.AdjustGalleryViewScrollViewPos, bundle)
    end    
end

function SeasonCardGroupItem:OnEnterGroup(params)
    if params.groupId == self.groupId then
        fun.set_active(self.imgNew, false)
    end
end

function SeasonCardGroupItem:OnGroupStateChange(params)
    if params.groupId == self.groupId then
        self:UpdateState()
    end
end

function SeasonCardGroupItem:OnCollectSingleCardRewardFinish(params)
    if params.groupId == self.groupId and params.seasonId == self.seasonId then
        self:UpdateState()
    end
end

function SeasonCardGroupItem:OnCollectGroupdRewardFinish(params)
    if params.groupId == self.groupId and params.seasonId == self.seasonId then
        self:UpdateState()
    end
end

function SeasonCardGroupItem:OnDragSwitchCardGroup(params)
    if params.to == self.index then
        if self.parent == ViewList.SeasonCardGalleryView then
            ModelList.SeasonCardModel:SetShowingGroupId(self.groupId)
            ModelList.SeasonCardModel:EnterGroup(self.groupId)
            ViewList.SeasonCardGalleryView:SetData(self.groupInfo)
            ViewList.SeasonCardGalleryView:SetGroupIndex(self.index)
            Facade.SendNotification(NotifyName.SeasonCard.RefreshGalleryView)
            Facade.SendNotification(NotifyName.SeasonCard.SwitchCardGroup)
            self:AdjustPos()
        end
    end
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.SeasonCard.SwitchCardGroup, func = this.OnSwitchCardGroup},
    {notifyName = NotifyName.SeasonCard.InitSelectCardGroup, func = this.OnInitSelectCardGroup},
    {notifyName = NotifyName.SeasonCard.EnterGroup, func = this.OnEnterGroup},
    {notifyName = NotifyName.SeasonCard.GroupStateChange, func = this.OnGroupStateChange},
    {notifyName = NotifyName.SeasonCard.CollectSingleCardRewardFinish, func = this.OnCollectSingleCardRewardFinish},
    {notifyName = NotifyName.SeasonCard.CollectGroupdRewardFinish, func = this.OnCollectGroupdRewardFinish},
    {notifyName = NotifyName.SeasonCard.DragSwitchCardGroup, func = this.OnDragSwitchCardGroup},    
}

return this