local SeasonCardGalleryItem = require "View/SeasonCard/SeasonCardGalleryItem"
local SeasonCardClownCard = require "View/SeasonCard/SeasonCardClownCard"
local SeasonCardOpenPackageView = BaseDialogView:New('SeasonCardOpenPackageView')
local this = SeasonCardOpenPackageView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "btn_collect",
    "btn_close",
    "imgPackage",
    "CardItem",
    "packageRoot",
    "cardsRoot",
    "rewardPanel",
    "row1",
    "row2",
    "anima",
    "titleAnima",
}

local animParams = {
    {"start0", "SeasonCardOpenPackageView_start0"},
    {"start1", "SeasonCardOpenPackageView_start1"},
    {"start2", "SeasonCardOpenPackageView_start2"},
    {"start3", "SeasonCardOpenPackageView_start3"},
    {"start4", "SeasonCardOpenPackageView_start4"},
    {"start5", "SeasonCardOpenPackageView_start5"},
    {"start6", "SeasonCardOpenPackageView_start6"},
    {"start7", "SeasonCardOpenPackageView_start7"},
    {"start8", "SeasonCardOpenPackageView_start8"},
    {"start9", "SeasonCardOpenPackageView_start9"},
    {"start10", "SeasonCardOpenPackageView_start10"},
    {"start11", "SeasonCardOpenPackageView_start11"},
    {"start0", "SeasonCardOpenPackageView_start0"},
    {"start0", "SeasonCardOpenPackageView_start0"},
    exit1 = {"endA", "SeasonCardOpenPackageView_endA"},
    exit2 = {"endB", "SeasonCardOpenPackageView_endB"},
    exit3 = {"endC", "SeasonCardOpenPackageView_endC"},
}

function SeasonCardOpenPackageView:Awake()
end

function SeasonCardOpenPackageView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
    self.hasClownCard = false
    self.isCollecting = false
end

function SeasonCardOpenPackageView:on_after_bind_ref()
    self:InitView()
end

function SeasonCardOpenPackageView:InitView()
    fun.set_active(self.CardItem, false)
    fun.set_active(self.cardsRoot, false)
    fun.set_active(self.packageRoot, true)
    Facade.SendNotification(NotifyName.SeasonCard.OpenPackageViewOpen)
    self:OpenOnePackage()
end

function SeasonCardOpenPackageView:OpenOnePackage()
    if self.showIndex <= #self.packageList then
        fun.set_active(self.CardItem, false)
        fun.set_active(self.cardsRoot, false)
        fun.set_active(self.packageRoot, true)
        local hasClownCard = self:IsHasClownCard(self.packageList[self.showIndex].cardIds)
        local bagId = self.packageList[self.showIndex].bagId
        local cardIds = self.packageList[self.showIndex].cardIds
        local seasonId = self.packageList[self.showIndex].seasonId
        self:SetPackageData(bagId, hasClownCard, seasonId)
        self:SetCardListData(cardIds, seasonId)
    end
end

function SeasonCardOpenPackageView:SetData(packageList)
    self.packageList = packageList
    self.showIndex = 1
end

function SeasonCardOpenPackageView:IsHasClownCard(cardIds)
    for i, v in ipairs(cardIds) do
        if ModelList.SeasonCardModel:IsClownCard(v) then
            return true
        end
    end
    return false
end

function SeasonCardOpenPackageView:SetPackageData(packageId, hasClownCard, seasonId)
    local packageInfo = ModelList.SeasonCardModel:GetCardPackageInfo(packageId, seasonId)
    --[[这里转为动画处理了
    local img = fun.get_component(self.imgPackage, fun.IMAGE)
    local iconName = packageInfo.icon
    iconName = Toolkit.GetBagBigIconName(iconName)
    img.sprite = AtlasManager:GetSpriteByName("SeasonCardOpenPackage", iconName)
    --]]
    self.hasClownCard = hasClownCard

    self.curLevel = packageInfo.level
    self.curPackageInfo = packageInfo
    local animParam = self:GetAnimName(self.curLevel, "start", hasClownCard)
    local task = function()
        self.isCollecting = true
        AnimatorPlayHelper.Play(self.anima, animParam, false, function() 
            self:MutualTaskFinish()
            self.isCollecting = false
        end)

        if hasClownCard then
            AnimatorPlayHelper.Play(self.titleAnima, {"start2", "SeasonCardOpenPackageViewTitle_start2"}, false, nil)
        else
            AnimatorPlayHelper.Play(self.titleAnima, {"start1", "SeasonCardOpenPackageViewTitle_start1"}, false, nil)
        end
    end
    self:DoMutualTask(task)
    UISound.play(self:GetAudioName(self.curLevel))
end

function SeasonCardOpenPackageView:GetAnimName(level, opt, hasClownCard)
    if self.curPackageInfo and self.curPackageInfo.icon == "iconCards12" then
        if opt == "end" then
            return {"endD", "SeasonCardOpenPackageView_endD"}
        elseif opt == "start" then
            return {"start12", "SeasonCardOpenPackageView_start12"}
        end
    else
        if opt == "end" then
            local starLevel = 1
            if level > 4 then
                starLevel = 3
            elseif level > 2 then
                starLevel = 2
            end

            return animParams["exit" .. starLevel]
        elseif opt == "start" then
            return animParams[level + 1] or {"start1", "SeasonCardOpenPackageView_start1"}
        end
    end
end

function SeasonCardOpenPackageView:GetAudioName(level)
    if not level then
        return "card_open"
    end

    if level == 0 then
        return "card_open_short"
    elseif level >= 1 and level <= 5 then
        return "card_open_middle"
    else
        return "card_open"
    end
end

function SeasonCardOpenPackageView:SetCardListData(cardList, seasonId)
    if not cardList or #cardList == 0 then
        return
    end

    local row1 = {}
    local row2 = {}
    local rowList = {row1, row2}
    local rowCount = 0
    if #cardList <= 3 then
        for i, v in ipairs(cardList) do
            row1[i] = v
        end
        rowCount = 1
    elseif #cardList == 4 then
        table.insert(row1, cardList[1])
        for i = 2, 4 do
            table.insert(row2, cardList[i])
        end
        rowCount = 2
    else
        for i, v in ipairs(cardList) do
            if i <= 3 then
                table.insert(row1, cardList[i])
            else
                table.insert(row2, cardList[i])
            end
        end
        rowCount = 2
    end

    fun.clear_all_child(self.row1)
    fun.clear_all_child(self.row2)
    fun.set_active(self.row1, false)
    fun.set_active(self.row2, false)
    for i = 1, rowCount do
        local row = self:CreateRow(rowList[i], i, seasonId)
    end
end

function SeasonCardOpenPackageView:CreateRow(data, index, seasonId)
    local row = self["row" .. index]
    fun.set_active(row, true)
    for i, v in ipairs(data) do
        local item
        if ModelList.SeasonCardModel:IsClownCard(v) then
            item = self:CreateClownCardItem(v, i, seasonId)
        else
            item = self:CreateCardItem(v, i, seasonId)
        end
        
        fun.set_parent(item.go, row, true)
        fun.set_active(item.go, true)
    end
    return row
end

function SeasonCardOpenPackageView:CreateCardItem(cardId, index, seasonId)
    local itemGo = fun.get_instance(self.CardItem)
    local data = {parent = self, cardId = cardId, seasonId = seasonId}
    local item = SeasonCardGalleryItem:New()
    item:SetData(data)
    item:SetOnlyShowBasicInfo()
    item:SkipLoadShow(itemGo)
    item:SetClickEnable(false)
    return item
end

function SeasonCardOpenPackageView:CreateClownCardItem(cardId, index, seasonId)
    local itemGo = fun.get_instance(self.CardItem)
    local data = {parent = self, cardId = cardId, seasonId = seasonId}
    local item = SeasonCardClownCard:New()
    item:SetData(data)
    item:SetOnlyShowBasicInfo()
    item:SkipLoadShow(itemGo)
    item:SetClickEnable(false)
    return item
end

function SeasonCardOpenPackageView:OnDisable()
    Facade.RemoveViewEnhance(self)
    self.showIndex = 0
    self.curLevel = 0
    self.closeCallback = nil
end

function SeasonCardOpenPackageView:SetCloseCallback(cb)
    self.closeCallback = cb
end

function SeasonCardOpenPackageView:CloseSelf()
    local animParam = self:GetAnimName(self.curLevel, "end", self.hasClownCard)
    local task = function()
        AnimatorPlayHelper.Play(self.titleAnima, {"end", "SeasonCardOpenPackageViewTitle_end"}, false, nil)
        AnimatorPlayHelper.Play(self.anima, animParam, false, function()
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.HideDialog, self)
            if self.closeCallback then
                self.closeCallback()
            end
            Facade.SendNotification(NotifyName.SeasonCard.OpenPackageViewClose)
        end)
    end
    
    self:DoMutualTask(task)
end

function SeasonCardOpenPackageView:on_btn_close_click()
    self:CloseSelf()
end

function SeasonCardOpenPackageView:on_btn_collect_click()
    if self.isCollecting then
        return
    end

    if self.showIndex < #self.packageList then
        self.showIndex = self.showIndex + 1
        self:OpenOnePackage()
    else
        self:CloseSelf()
    end
end

function SeasonCardOpenPackageView:OnForceExit(params)
    self:CloseSelf()
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.SeasonCard.ForceExit, func = this.OnForceExit},
}

return this