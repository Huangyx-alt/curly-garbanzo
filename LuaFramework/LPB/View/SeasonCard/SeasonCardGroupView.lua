local SeasonCardGroupPageView = require "View/SeasonCard/SeasonCardGroupPageView"
local SeasonCardUniversalMenuView = require "View/SeasonCard/SeasonCardUniversalMenuView"
local Toolkit = require "View/SeasonCard/Toolkit"
local SeasonCardGroupView = BaseView:New("SeasonCardGroupView", "SeasonCardGroup")
local this = SeasonCardGroupView
local lastBgmName

this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "left_time_txt",
    "btn_close",
    "btn_total_reward",
    "txtDescription",
    "rewardPanel",
    "rewardItem",
    "leftTime",
    "LeftFunctionBtns",
    "btn_help",
    "PageView",
    "PageItem",
    "GroupItem",
    "btn_next_page",
    "btn_pre_page",
    "btn_collect",
    "anima",
    "lbl_Indicator",
}

function SeasonCardGroupView:Awake()
end

function SeasonCardGroupView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
    --undo for test wait delete
    self:register_invoke(function()
        --ModelList.SeasonCardModel:TestSeasonSwitch()
    end, 15)
end

function SeasonCardGroupView:on_after_bind_ref()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"in", "SeasonCardGroupViewenter"}, false, function() 
            self:MutualTaskFinish()
            lastBgmName = UISound.get_playing_bgm() or "city"
            UISound.play_bgm("card_bgm")
        end)
    end
    self:DoMutualTask(task)
    self:InitPageView()
    self:InitUniversalBtns()
    self:OpenAlbum(self.seasonId)

    self:FillPageView()
    self:InitLeftTime()
    self:InitReward()
    self.menu:UpdateState()
end

function SeasonCardGroupView:OpenAlbum(seasonId)
    self.seasonId = seasonId or self.data.seasonId
    ModelList.SeasonCardModel:SetShowingAlbumId(self.seasonId)
    ModelList.SeasonCardModel:SetShowingAlbumById(self.seasonId)
end

function SeasonCardGroupView:CloseAlbum()
    self.seasonId = nil
    ModelList.SeasonCardModel:ClearShowingAlbum()
    ModelList.SeasonCardModel:ClearShowingAlbumId()
end

function SeasonCardGroupView:InitUniversalBtns()
    local menu = SeasonCardUniversalMenuView:New()
    menu:SetParent(self)
    menu:SkipLoadShow(self.LeftFunctionBtns)
    self.menu = menu
end

function SeasonCardGroupView:InitPageView()
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

function SeasonCardGroupView:OnBeginDrag(idx)
    log.log("SeasonCardGroupView:OnBeginDrag", idx)
end

function SeasonCardGroupView:OnDrag(idx)
end

function SeasonCardGroupView:OnEndDrag(idx)
    log.log("SeasonCardGroupView:OnEndDrag", idx)
end

function SeasonCardGroupView:OnIndexChange(idx, lastIdx)
    log.log("SeasonCardGroupView:OnIndexChange", lastIdx, "->", idx)
    local pageCount = self.pageViewCtr.PageCount
    --undo 临时方案，基于当前页数为3
    if math.abs(idx - lastIdx) > 1 or idx >= pageCount then
        return
    end

    self.lbl_Indicator.text = (idx + 1) .. "/" .. pageCount

    fun.enable_button_with_child(self.btn_pre_page, idx ~= 0)
    Util.SetUIImageGray(self.btn_pre_page.gameObject, idx == 0)

    fun.enable_button_with_child(self.btn_next_page, idx ~= (pageCount - 1))
    Util.SetUIImageGray(self.btn_next_page.gameObject, idx == (pageCount - 1))
end

function SeasonCardGroupView:FillPageView()
    self.pageViewCtr:ClearAllPages()

    local groups = ModelList.SeasonCardModel:GetGroups(self.seasonId)
    if not groups or #groups < 1 then
        return
    end

    local pageCount = math.ceil(#groups / 9)
    for idx = 1, pageCount do
        local pageData = {}
        pageData.index = idx
        pageData.groupIds = {}
        pageData.seasonId = self.seasonId
        
        for i = (idx - 1) * 9 + 1, idx * 9 do
            if i <= #groups then
                table.insert(pageData.groupIds, groups[i].groupId)
            else
                break
            end
        end
        pageData.groupCount = #pageData.groupIds
        self:CreatePage(pageData)
    end

    self.pageViewCtr.dragEnable = pageCount > 1
    --self.lbl_Indicator.text = "1/" .. pageCount
    self:OnIndexChange(0, -1)
end

function SeasonCardGroupView:CreatePage(pageData)
    local go = fun.get_instance(self.PageItem)
    local rt = fun.get_component(go, fun.RECT)
    fun.set_active(go, true)
    self.pageViewCtr:AddPage(rt)
    local page = SeasonCardGroupPageView:New()
    page:SetData(pageData)
    page:SkipLoadShow(go)
end

function SeasonCardGroupView:SetData(data)
    self.data = data
end

function SeasonCardGroupView:InitReward()
    fun.clear_all_child(self.rewardPanel)
    local rewards = ModelList.SeasonCardModel:GetAlbumRewardInfo(self.seasonId)
    for i, v in ipairs(rewards) do
        local item = self:CreateRewardItem(v)
        fun.set_parent(item, self.rewardPanel, true)
    end
    self:UpdateRewardState()
end

function SeasonCardGroupView:UpdateRewardState()
    local descId = 30076
    if ModelList.SeasonCardModel:IsAlbumRewarded(self.seasonId) then
        fun.set_active(self.btn_collect, false)
        fun.set_active(self.txtDescription, true)
        fun.set_active(self.leftTime, true)        
        descId = 30078
    else
        if ModelList.SeasonCardModel:IsAlbumCompleted(self.seasonId) then
            fun.set_active(self.btn_collect, true)
            fun.set_active(self.txtDescription, true) --false
            fun.set_active(self.leftTime, false)
            descId = 30077
        else
            fun.set_active(self.btn_collect, false)
            fun.set_active(self.txtDescription, true)
            fun.set_active(self.leftTime, true)
        end
    end
    self.txtDescription.text = Csv.GetDescription(descId)
end

function SeasonCardGroupView:CreateRewardItem(rewardData)
    local go = fun.get_instance(self.rewardItem)
    local ref = fun.get_component(go, fun.REFER)
    local icon = ref:Get("icon")
    local value = ref:Get("value")
    local id = rewardData.id
    local count = rewardData.value
    local iconName = Csv.GetItemOrResource(id, "more_icon")
    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
    --value.text = fun.format_money(count)
    value.text = Toolkit.FormatReward(count)
    fun.set_active(go, true)
    return go
end

function SeasonCardGroupView:InitLeftTime()
    self.endTime = ModelList.SeasonCardModel:GetLeftTime(self.seasonId)
    self:RemoveTimer()
    if self.endTime > 0 then
        self.loopTime = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
            if self.left_time_txt then
                self.left_time_txt.text = fun.SecondToStrFormat(self.endTime)
                self.endTime = self.endTime - 1
                if self.endTime <= 0 then
                    self:RemoveTimer()
                end
            end
        end, nil, nil, LuaTimer.TimerType.UI)
    else
        self.left_time_txt.text = fun.SecondToStrFormat(0)
    end
end

function SeasonCardGroupView:OnDisable()
    Facade.RemoveViewEnhance(self)
    self:RemoveTimer()
    self:CloseAlbum()
    ModelList.SeasonCardModel:ExitSystem()
    self.isOpenPackageViewOpen = false
    self.waitingPopupForceExit = false
end

function SeasonCardGroupView:RemoveTimer()
    if self.loopTime then
        LuaTimer:Remove(self.loopTime)
        self.loopTime = nil
    end
end

function SeasonCardGroupView:CloseSelf()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"end", "SeasonCardGroupViewend"}, false, function()
            Event.Brocast(NotifyName.SeasonCard.PopupActivityPosterFinish)
            self:MutualTaskFinish()
            UISound.stop_bgm()
            UISound.play_bgm(lastBgmName)
            Facade.SendNotification(NotifyName.CloseUI, self)
        end)
    end

    self:DoMutualTask(task)
end

function SeasonCardGroupView:on_btn_close_click()
    self:CloseSelf()
end

function SeasonCardGroupView:on_btn_help_click()
    log.log("SeasonCardGroupView:on_btn_help_click")
    Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardHelpView)
end

function SeasonCardGroupView:on_btn_next_page_click()
    log.log("SeasonCardGroupView:on_btn_next_page_click")
    --self.pageViewCtr:MoveByIndex(1)
    self.pageViewCtr:NextPage()
end

function SeasonCardGroupView:on_btn_pre_page_click()
    log.log("SeasonCardGroupView:on_btn_pre_page_click")
    --self.pageViewCtr:MoveByIndex(-1)
    self.pageViewCtr:PrePage()
end

function SeasonCardGroupView:on_btn_total_reward_click()
    log.log("SeasonCardGroupView:on_btn_total_reward_click")
end

function SeasonCardGroupView:on_btn_collect_click()
    log.log("SeasonCardGroupView:on_btn_collect_click")
    ModelList.SeasonCardModel:C2S_ReceiveAlbumAward(self.seasonId)
end

function SeasonCardGroupView:SetVisible(enable)
    if fun.is_not_null(self.go) then
        local canvasGroup = fun.get_component(self.go, fun.CANVAS_GROUP)
        if canvasGroup then
            canvasGroup.alpha = enable and 1 or 0
            canvasGroup.blocksRaycasts = enable
        end
    end
end

function SeasonCardGroupView:PopupForceExitDialog(params)
    local contentId = 305
    local sureCallBack = function()
        Facade.SendNotification(NotifyName.SeasonCard.ForceExit)
    end
    UIUtil.show_common_popup(contentId, true, sureCallBack)
end

function SeasonCardGroupView:OnHideCardGroupView()
    self:SetVisible(false)
end

function SeasonCardGroupView:OnShowCardGroupView()
    log.log("SeasonCardGroupView:OnShowCardGroupView")
    self:SetVisible(true)
end

function SeasonCardGroupView:OnAlbumRewardStateChange(params)
    log.log("SeasonCardGroupView:OnAlbumRewardStateChange")
    if params.seasonId == self.seasonId  then
        local isCompleted = params.isCompleted
        self:UpdateRewardState()
    end
end

function SeasonCardGroupView:OnCollectAlbumdRewardFinish(params)
    if params.seasonId == self.seasonId  then
        self:UpdateRewardState()
    end
end

function SeasonCardGroupView:OnSwitchAlbumFinish(params)
    if params.seasonId ~= self.seasonId then
        self:OpenAlbum(params.seasonId)
        self:FillPageView()
        self:InitLeftTime()
        self:InitReward()
        self.menu:UpdateState()
    end
end

function SeasonCardGroupView:OnSeasonOver(params)
    log.log("SeasonCardGroupView:OnSeasonOver", params.oldSeasonId .. "结束 " .. params.newSeasonId .. "开启")
    if not self.isOpenPackageViewOpen then
        self:PopupForceExitDialog()
    else
        self.waitingPopupForceExit = true
    end
end

function SeasonCardGroupView:OnOpenPackageViewOpen(params)
    log.log("SeasonCardGroupView:OnOpenPackageViewOpen")
    self.isOpenPackageViewOpen = true
end

function SeasonCardGroupView:OnOpenPackageViewClose(params)
    log.log("SeasonCardGroupView:OnOpenPackageViewClose")
    self.isOpenPackageViewOpen = false
    if self.waitingPopupForceExit then
        self:PopupForceExitDialog()
        self.waitingPopupForceExit = false
    end
end

function SeasonCardGroupView:OnForceExit(params)
    self:CloseSelf()
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.SeasonCard.HideCardGroupView, func = this.OnHideCardGroupView},
    {notifyName = NotifyName.SeasonCard.ShowCardGroupView, func = this.OnShowCardGroupView},
    {notifyName = NotifyName.SeasonCard.CloseGalleryView, func = this.OnShowCardGroupView},
    {notifyName = NotifyName.SeasonCard.AlbumRewardStateChange, func = this.OnAlbumRewardStateChange},
    {notifyName = NotifyName.SeasonCard.CollectAlbumdRewardFinish, func = this.OnCollectAlbumdRewardFinish},
    {notifyName = NotifyName.SeasonCard.SwitchAlbum, func = this.OnSwitchAlbumFinish},
    {notifyName = NotifyName.SeasonCard.SeasonOver, func = this.OnSeasonOver},
    {notifyName = NotifyName.SeasonCard.OpenPackageViewOpen, func = this.OnOpenPackageViewOpen},
    {notifyName = NotifyName.SeasonCard.OpenPackageViewClose, func = this.OnOpenPackageViewClose},
    {notifyName = NotifyName.SeasonCard.ForceExit, func = this.OnForceExit},

    
}

return this