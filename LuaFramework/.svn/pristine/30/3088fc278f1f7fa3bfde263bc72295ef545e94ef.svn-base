local SeasonCardClownCardExchangeGroup = require "View/CommonView/SeasonCardClownCardExchangeGroup"
local SeasonCardClownCardExchangeItem = require "View/CommonView/SeasonCardClownCardExchangeItem"
local SeasonCardInfiniteList = require "View/CommonView/SeasonCardInfiniteList"
local SeasonCardClownCardExchangeView = BaseView:New("SeasonCardClownCardExchangeView")
local this = SeasonCardClownCardExchangeView

this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "content",
    "btn_close",
    "scrollView",
    "txtDesc",
    "toggle",
    "btn_confirm",
    "left_time",
    "left_time_txt",
    "groupItem1",
    "groupItem2",
    "anima",
    "cardItem",
}

function SeasonCardClownCardExchangeView:Awake()
end

function SeasonCardClownCardExchangeView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
    self.selectCardId = nil
end

function SeasonCardClownCardExchangeView:on_after_bind_ref()
    fun.set_active(self.groupItem1, false)
    fun.set_active(self.groupItem2, false)
    fun.set_active(self.cardItem, false)
    self:SetConfirmBtnState(false)
    self.luabehaviour:AddToggleChange(self.toggle.gameObject, function(target, check)
        self:OnToggleChange(target, check)
    end)

    self.toggle.isOn = true
    self:SetLeftTime()
    --self:InitScrollView()
    self:InitInfiniteList()
    self:UpdateInfiniteList()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"start", "SeasonCardClownCardExchangeViewstart"}, false, function() 
            self:MutualTaskFinish()
        end)
    end
    self:DoMutualTask(task)
end

function SeasonCardClownCardExchangeView:OnDisable()
    self.luabehaviour:RemoveClick(self.toggle.gameObject)
    Facade.RemoveViewEnhance(self)
    if self.loopTime then
        LuaTimer:Remove(self.loopTime)
        self.loopTime = nil
    end

    ModelList.SeasonCardModel:ClearShowingGroupId()
end

function SeasonCardClownCardExchangeView:OnDestroy()
    self:Close()
    if self.InfiniteList then
        self.InfiniteList:OnDestroy()
    end
end

function SeasonCardClownCardExchangeView:SetData(data)
    self.data = data
    self.seasonId = data and data.seasonId or ModelList.SeasonCardModel:GetShowingSeasonId()
    log.log("SeasonCardClownCardExchangeView:SetData", data)
end

function SeasonCardClownCardExchangeView:OnToggleChange(target, check)
    log.log("SeasonCardClownCardExchangeView:OnToggleChange ", check)
    --self:InitScrollView()
    --self:InitInfiniteList()
    self:UpdateInfiniteList()
    self:SetConfirmBtnState(false)
    self.selectCardId = nil
end

function SeasonCardClownCardExchangeView:InitScrollView()
    fun.clear_all_child(self.content)
    local groups = self:GetGroupsData()
    for index, groupInfo in ipairs(groups) do
        self:CreateGroupItem(index, groupInfo)
    end
end

function SeasonCardClownCardExchangeView:GetGroupsData()
    local groups = ModelList.SeasonCardModel:GetGroups()
    if not groups or #groups < 1 then
        return {}
    end
    groups = deep_copy(groups)

    if self:IsEnableFilter() then
        self:FilterGroups(groups)
    end

    if self:IsEnableSort() then
        self:SortGroups(groups)
    end

    --[[
    local cardCount = 0
    local groupCount = 0
    for i, v in ipairs(groups) do
        cardCount = cardCount + #v.cards
        groupCount = groupCount + 1
    end
    log.log("SeasonCardClownCardExchangeView:GetGroupsData card and group count is ", cardCount, groupCount)
    ]]

    return groups
end

function SeasonCardClownCardExchangeView:IsEnableSort()
    return true
end

function SeasonCardClownCardExchangeView:IsEnableFilter()
    return self.toggle.isOn
end

function SeasonCardClownCardExchangeView:SortGroups(groups)
    table.sort(groups, function(group1, group2)
        if group1.progress == group2.progress then
            return group1.groupId > group2.groupId
        else
            return group1.progress > group2.progress
        end
    end)
end

function SeasonCardClownCardExchangeView:FilterGroups(groups)
    for i = #groups, 1, -1 do
        if groups[i].progress == groups[i].totalCardNum then
            table.remove(groups, i)
        else
            for index = #groups[i].cards, 1, -1 do
                if groups[i].cards[index].collectNum > 0 then
                    table.remove(groups[i].cards, index)
                end
            end
        end
    end
end

function SeasonCardClownCardExchangeView:CreateGroupItem(index, groupInfo)
    local itemGo
    if #groupInfo.cards < 6 then
        itemGo = fun.get_instance(self.groupItem1)
    else
        itemGo = fun.get_instance(self.groupItem2)
    end

    local groupItem = SeasonCardClownCardExchangeGroup:New()
    local seasonId = ModelList.SeasonCardModel:GetCurSeasonId()
    local data = {index = index, groupInfo = groupInfo, seasonId = seasonId}
    groupItem:SetData(data)
    groupItem:SkipLoadShow(itemGo)
    fun.set_parent(itemGo, self.content, true)
    fun.set_active(itemGo, true)
end

function SeasonCardClownCardExchangeView:SetLeftTime()
    local expireTime = ModelList.SeasonCardModel:GetSoonestClownCardExpire()
    local currentTime = ModelList.SeasonCardModel:GetCurrentTime()
    self.endTime = expireTime - currentTime
    self:RemoveTimer()
    if self.endTime > 0 then
        self.loopTime = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
            if self.left_time_txt and self.endTime >= 0 then
                self.left_time_txt.text = fun.SecondToStrFormat(self.endTime)
                self.endTime = self.endTime - 1
                if self.endTime <= 0 then
                end
            end
        end)
    end
end

function SeasonCardClownCardExchangeView:RemoveTimer()
    if self.loopTime  then
        LuaTimer:Remove(self.loopTime)
        self.loopTime = nil
    end
end

function SeasonCardClownCardExchangeView:CloseSelf()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"end", "SeasonCardClownCardExchangeViewend"}, false, function()
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.CloseUI, self)
        end)
    end

    self:DoMutualTask(task)
end

function SeasonCardClownCardExchangeView:on_btn_close_click()
    self:CloseSelf()
end

function SeasonCardClownCardExchangeView:on_btn_confirm_click()
    log.log("SeasonCardClownCardExchangeView:on_btn_confirm_click", self.selectCardId)
    ModelList.SeasonCardModel:C2S_ClownCardExchange(self.selectCardId)
    self:CloseSelf()
end

function SeasonCardClownCardExchangeView:OnSelectExchangeCard(params)
    self.selectCardId = params.selectState and params.cardId or nil
    self:SetConfirmBtnState(params.selectState)
end

function SeasonCardClownCardExchangeView:GetSelectCardId()
    return self.selectCardId
end

function SeasonCardClownCardExchangeView:SetConfirmBtnState(enable)
    fun.enable_button(self.btn_confirm, enable)
    local child = fun.find_child(self.btn_confirm, "txtLbl")
    if child then
        fun.set_color_grey(child, not enable)
    end
end

function SeasonCardClownCardExchangeView:InitInfiniteList()
    local params = {
        groupItem1 = self.groupItem1,
        groupItem2 = self.groupItem2,
        scrollView = self.scrollView,
        luabehaviour = self.luabehaviour,
        cardItem = self.cardItem,
        groupItemView = SeasonCardClownCardExchangeGroup,
        cardItemView = SeasonCardClownCardExchangeItem,
        host = self,
        spacing = 0,
        paddingTop = 0,
        paddingBottom = 0,
    }
    self.infiniteList = SeasonCardInfiniteList.create(params)
end

function SeasonCardClownCardExchangeView:UpdateInfiniteList()
    self.infiniteList:RecycleAllItems()
    self.infiniteList:UpdateListByData(self:GetGroupsData())
end

function SeasonCardClownCardExchangeView:OnForceExit(params)
    self:CloseSelf()
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.SeasonCard.SelectExchangeCard, func = this.OnSelectExchangeCard},
    {notifyName = NotifyName.SeasonCard.ForceExit, func = this.OnForceExit},
}

return this