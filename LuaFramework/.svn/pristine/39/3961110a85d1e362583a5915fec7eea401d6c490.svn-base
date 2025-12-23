local ClubSeasonCardClownCardExchangeGroup = require "View/CommonView/SeasonCardClownCardExchangeGroup"
local SeasonCardClownCardExchangeItem = require "View/CommonView/SeasonCardClownCardExchangeItem"
local SeasonCardInfiniteList = require "View/CommonView/SeasonCardInfiniteList"
local ClubReqCardView = BaseView:New("ClubReqCardView", "ClubAtlas")
local this = ClubReqCardView

this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "content",
    "btn_close",
    "scrollView",
    "txtDesc",
    "toggle",
    "btn_confirm",
    "groupItem1",
    "groupItem2",
    "anima",
    "cardItem",
}

function ClubReqCardView:Awake()
end

function ClubReqCardView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
    self.selectCardId = nil
end

function ClubReqCardView:on_after_bind_ref()
    fun.set_active(self.groupItem1, false)
    fun.set_active(self.groupItem2, false)
    fun.set_active(self.cardItem, false)
    self:SetConfirmBtnState(false)
    self.luabehaviour:AddToggleChange(self.toggle.gameObject, function(target, check)
        self:OnToggleChange(target, check)
    end)

    self.toggle.isOn = true
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

function ClubReqCardView:OnDisable()
    self.luabehaviour:RemoveClick(self.toggle.gameObject)
    Facade.RemoveViewEnhance(self)
    if self.loopTime then
        LuaTimer:Remove(self.loopTime)
        self.loopTime = nil
    end
end

function ClubReqCardView:OnDestroy()
    self:Close()
    if self.InfiniteList then
        self.InfiniteList:OnDestroy()
    end
    local culbAssetList = require("Module/ClubAssetList")
    if culbAssetList then
        Cache.unload_ab_no_depen(culbAssetList["ClubReqCardView"],false)
    end
end

function ClubReqCardView:SetData(data)
    self.data = data
    self.seasonId = data and data.seasonId or ModelList.SeasonCardModel:GetShowingSeasonId()
    log.log("ClubReqCardView:SetData", data)
end

function ClubReqCardView:OnToggleChange(target, check)
    log.log("ClubReqCardView:OnToggleChange ", check)
    --self:InitScrollView()
    --self:InitInfiniteList()
    self:UpdateInfiniteList()
    self:SetConfirmBtnState(false)
    self.selectCardId = nil
end

function ClubReqCardView:InitScrollView()
    fun.clear_all_child(self.content)
    local groups = self:GetGroupsData()
    for index, groupInfo in ipairs(groups) do
        self:CreateGroupItem(index, groupInfo)
    end
end

function ClubReqCardView:GetGroupsData()
    local groups = ModelList.SeasonCardModel:GetGroups()
    if not groups or #groups < 1 then
        return {}
    end
    groups = deep_copy(groups)

    ---[[
    if self:IsEnableFilter() then
        self:FilterGroups(groups)
    end
    
    self:FilterGroupCards(groups)

    if self:IsEnableSort() then
        self:SortGroups(groups)
    end
    --]]

    return groups
end

function ClubReqCardView:IsEnableSort()
    return true
end

function ClubReqCardView:IsEnableFilter()
    return self.toggle.isOn
end

function ClubReqCardView:SortGroups(groups)
    table.sort(groups, function(group1, group2)
        if group1.progress == group2.progress then
            return group1.groupId > group2.groupId
        else
            return group1.progress > group2.progress
        end
    end)
end

function ClubReqCardView:FilterGroups(groups)
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

function ClubReqCardView:FilterGroupCards(groups)
    for i = #groups, 1, -1 do
        local tmpCards = {}
        for index, card in ipairs(groups[i].cards) do
            local cardInfo = ModelList.SeasonCardModel:GetCardFixedData(card.cardId)
            if cardInfo and cardInfo.club_exchange == 1 then 
                table.insert(tmpCards,card)
            end
        end

        if #tmpCards == 0 then
            table.remove(groups, i)
        else
            groups[i].cards = tmpCards
        end
    end
end

function ClubReqCardView:CreateGroupItem(index, groupInfo)
    local itemGo
    if #groupInfo.cards < 6 then
        itemGo = fun.get_instance(self.groupItem1)
    else
        itemGo = fun.get_instance(self.groupItem2)
    end

    local groupItem = ClubSeasonCardClownCardExchangeGroup:New()
    local data = {index = index, groupInfo = groupInfo}
    groupItem:SetData(data)
    groupItem:SkipLoadShow(itemGo)
    fun.set_parent(itemGo, self.content, true)
    fun.set_active(itemGo, true)
end

function ClubReqCardView:CloseSelf()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"end", "SeasonCardClownCardExchangeViewend"}, false, function()
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.CloseUI, self)
        end)
    end

    self:DoMutualTask(task)
end

function ClubReqCardView:on_btn_close_click()
    self:CloseSelf()
end

function ClubReqCardView:on_btn_confirm_click()
    log.log("ClubReqCardView:on_btn_confirm_click", self.selectCardId)
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"end", "SeasonCardClownCardExchangeViewend"}, false, function()
            --请求卡牌
            ModelList.ClubModel.C2S_ClubSeasonCardAsk(self.selectCardId)
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.CloseUI, self)
        end)
    end

   self:DoMutualTask(task)

   Csv.GetDescription(980)
end

function ClubReqCardView:OnSelectExchangeCard(params)
    self.selectCardId = params.selectState and params.cardId or nil
    self:SetConfirmBtnState(params.selectState)
end

function ClubReqCardView:OnSeasonCardOver()
    local this = self
    UIUtil.show_common_popup(980,true,function()
        this:CloseSelf()
     end,function()
        this:CloseSelf()
     end)
   
end 

function ClubReqCardView:GetSelectCardId()
    return self.selectCardId
end

function ClubReqCardView:SetConfirmBtnState(enable)
    fun.enable_button(self.btn_confirm, enable)
    local child = fun.find_child(self.btn_confirm, "txtLbl")
    if child then
        fun.set_color_grey(child, not enable)
    end
end

function ClubReqCardView:InitInfiniteList()
    local params = {
        groupItem1 = self.groupItem1,
        groupItem2 = self.groupItem2,
        scrollView = self.scrollView,
        luabehaviour = self.luabehaviour,
        cardItem = self.cardItem,
        groupItemView = ClubSeasonCardClownCardExchangeGroup,
        cardItemView = SeasonCardClownCardExchangeItem,
        host = self,
        spacing = 0,
        paddingTop = 0,
        paddingBottom = 0,
    }
    self.infiniteList = SeasonCardInfiniteList.create(params)
end

function ClubReqCardView:UpdateInfiniteList()
    self.infiniteList:RecycleAllItems()
    self.infiniteList:UpdateListByData(self:GetGroupsData())
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.SeasonCard.SelectExchangeCard, func = this.OnSelectExchangeCard},
    {notifyName = NotifyName.SeasonCard.SeasonOver, func = this.OnSeasonCardOver},
}

return this