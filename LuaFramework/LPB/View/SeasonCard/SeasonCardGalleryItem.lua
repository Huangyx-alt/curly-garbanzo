local Toolkit = require "View/SeasonCard/Toolkit"
local SeasonCardGalleryItem = BaseView:New("SeasonCardGalleryItem")
local this = SeasonCardGalleryItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "imgBg",
    "imgIcon",
    "imgCountBg",
    "txtCount",
    "btn_card",
    "starPanel",
    "imgStar",
    "txtDescription",
    "btn_reward",
    "imgNew",
    "btn_collect",
    "anima",
    "advancedLight",
}

function SeasonCardGalleryItem:New()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function SeasonCardGalleryItem:Awake()
end

function SeasonCardGalleryItem:OnEnable()
    Facade.RegisterViewEnhance(self)
end

function SeasonCardGalleryItem:on_after_bind_ref()
    fun.set_active(self.imgNew, false)
    fun.set_active(self.advancedLight, false)
    self:InitItem()
end

function SeasonCardGalleryItem:OnDisable()
    Facade.RemoveViewEnhance(self)
    self.onlyShowBasicInfo = false
end

function SeasonCardGalleryItem:SetData(data)
    self.data = data
    self.index = data.index or 1
    self.parent = data.parent
    self.cardId = data.cardId
    self.seasonId = data.seasonId
    self.cardInfo = ModelList.SeasonCardModel:GetCardInfo(self.cardId, self.seasonId)
end

function SeasonCardGalleryItem:SetOnlyShowBasicInfo()
    self.onlyShowBasicInfo = true
end

function SeasonCardGalleryItem:InitItem()
    if not self.data then
        return
    end
    fun.set_active(self.imgNew, false)
    fun.set_active(self.imgStar, false)
    fun.set_active(self.imgCountBg, false)
    fun.set_active(self.btn_collect, false)

    self:InitBasicInfo()
    if not self.onlyShowBasicInfo then
        self:UpdateState()
    end
end

function SeasonCardGalleryItem:InitBasicInfo()
    local level = self.cardInfo.fixedData.level
    local starCount = self.cardInfo.fixedData.star

    self.txtDescription.text = self.cardInfo.fixedData.name
    fun.clear_all_child(self.starPanel)
    for i = 1, starCount do
        local starGo = fun.get_instance(self.imgStar)
        fun.set_active(starGo, true)
        fun.set_parent(starGo, self.starPanel, true)
    end

    if self:CheckShowRewardIcon() then
        fun.set_active(self.btn_reward, true)
    else
        fun.set_active(self.btn_reward, false)
    end

    local imgBg = fun.get_component(self.imgBg, fun.IMAGE)
    local bgName = Toolkit.GetCardBgNameByLevel(level)
    imgBg.sprite = AtlasManager:GetSpriteByName("SeasonCardGallery", bgName)

    

    local iconName = self.cardInfo.fixedData.icon
    local imgIcon = fun.get_component(self.imgIcon, fun.IMAGE)
    --[[
    local atlasName = Toolkit.GetAtlasByCardIconName(iconName)
    if atlasName then
        imgIcon.sprite = AtlasManager:GetSpriteByName(atlasName, iconName)
    else
        log.log("SeasonCardGalleryItem:InitBasicInfo 找不到图片", iconName)
    end
    --]]

    if ModelList.SeasonCardModel.Consts.USE_LOCAL_CARD_RES then
        ViewTool:LoadFoodSprite(iconName, iconName, imgIcon)
    else
        ViewTool:LoadSeasonCardSprite(self.seasonId, iconName, imgIcon)
    end
    fun.set_active(self.advancedLight, self.cardInfo.fixedData.effect == 1)
end

function SeasonCardGalleryItem:UpdateState()
    self:UpdateCollectNumState()
    self:UpdateGrayState()
    self:UpdateRewardState()
    self:UpdateNewGetState()
    self:UpdateRewardBtnState()
end

function SeasonCardGalleryItem:UpdateCollectNumState()
    if self.cardInfo.flexibleData.collectNum <= 1 then
        fun.set_active(self.imgCountBg, false)
    else
        fun.set_active(self.imgCountBg, true)
        self.txtCount.text = self.cardInfo.flexibleData.collectNum
    end
end

function SeasonCardGalleryItem:UpdateGrayState()
    --[[把卡片背景框和卡片图标都变灰，当没收集到时
    if self.cardInfo.flexibleData.collectNum == 0 then
        Util.SetUIImageGray(self.imgBg.gameObject, true)
        Util.SetUIImageGray(self.imgIcon.gameObject, true)
    else
        Util.SetUIImageGray(self.imgBg.gameObject, false)
        Util.SetUIImageGray(self.imgIcon.gameObject, false)
    end
    --]]

    ---[[把卡片图标变灰，卡片背景框用指定的灰色框，当没收集到时
    local level = self.cardInfo.fixedData.level
    local imgBg = fun.get_component(self.imgBg, fun.IMAGE)
    local bgName = Toolkit.GetCardBgNameByLevel(level)
    if self.cardInfo.flexibleData.collectNum == 0 then
        bgName = Toolkit.GetGrayCardBgName(level)
        --Util.SetUIImageGray(self.imgIcon.gameObject, true)
        fun.set_active(self.imgIcon, false)
    else
        --Util.SetUIImageGray(self.imgIcon.gameObject, false)
        fun.set_active(self.imgIcon, true)
    end
    imgBg.sprite = AtlasManager:GetSpriteByName("SeasonCardGallery", bgName)
    --]]
end

function SeasonCardGalleryItem:UpdateRewardState()
    if self.cardInfo.flexibleData.hasReward then
        fun.set_active(self.btn_reward, true)
    else
        fun.set_active(self.btn_reward, false)
    end

    local imgIcon = fun.get_component(self.btn_reward, fun.IMAGE)
    local iconName = "CardGift01"
    if self.cardInfo.flexibleData.isRewarded then
        imgIcon = fun.get_component(self.btn_reward, fun.IMAGE)
        iconName = "CardGift02"        
    end
    imgIcon.sprite = AtlasManager:GetSpriteByName("SeasonCardGallery", iconName)
end

function SeasonCardGalleryItem:UpdateNewGetState()
    --当前无此需求
    if self.cardInfo.flexibleData.isNew then
        --fun.set_active(self.imgNew, true)
    else
        fun.set_active(self.imgNew, false)
    end
end

function SeasonCardGalleryItem:UpdateRewardBtnState()
    if ModelList.SeasonCardModel:IsHasSingleCardReward(self.cardId) then
        fun.set_active(self.btn_collect, true)
    else
        fun.set_active(self.btn_collect, false)
    end
end

function SeasonCardGalleryItem:CheckShowRewardIcon()
    if not self.cardInfo.fixedData.reward then
        return false
    end

    if not self.cardInfo.fixedData.reward[1] then
        return false
    end

    if not self.cardInfo.fixedData.reward[1][2] then
        return false
    end

    return true
end

function SeasonCardGalleryItem:ReadyRefresh()
    if fun.is_not_null(self.anima) then
        -- AnimatorPlayHelper.Play(self.anima, {"idlekong", "CardItemidlekong"}, false, function()
        --     --do something
        -- end)

        --fun.play_animator(self.anima, "idlekong", true)

        AnimatorPlayHelper.Play(self.anima, {"idlekong", "CardItemidlekong"}, false, nil)
    end
end

function SeasonCardGalleryItem:StartRefresh()
    if fun.is_not_null(self.anima) then
        -- AnimatorPlayHelper.Play(self.anima, {"enter", "CardItementer"}, false, function()
        --     --do something
        -- end)

        --fun.play_animator(self.anima, "enter", true)

        AnimatorPlayHelper.Play(self.anima, {"enter", "CardItementer"}, false, nil)
    end
end

function SeasonCardGalleryItem:on_btn_card_click()
    if not self.clickEnable then
        return
    end

    local data = {}
    data.cardInfo = self.cardInfo
    data.purpose = ViewList.SeasonCardFeatureView.PurposeType.display
    data.seasonId = self.seasonId
    ViewList.SeasonCardFeatureView:SetData(data)
    Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardFeatureView)
end

function SeasonCardGalleryItem:on_btn_reward_click()
    if not self.clickEnable then
        return
    end
    local reward = self.cardInfo.fixedData.reward
    local pos = fun.get_gameobject_pos(self.go, false)
    local params = {}
    params.pos = pos
    params.rewards = reward
    Facade.SendNotification(NotifyName.SeasonCard.ShowSingleCardRewardBubble, params)
end

function SeasonCardGalleryItem:on_btn_collect_click()
    if not self.clickEnable then
        return
    end
    ModelList.SeasonCardModel:C2S_ReceiveCardAward(self.cardId)
end

function SeasonCardGalleryItem:SetClickEnable(enable)
    self.clickEnable = enable
end

function SeasonCardGalleryItem:OnCardAdd(params)
    if params.cardId == self.cardId then
        if not self.onlyShowBasicInfo then
            self:UpdateState()
        end
    end
end

function SeasonCardGalleryItem:OnDropOneCard(params)
    if params.cardId == self.cardId and params.seasonId == self.seasonId then
        if not self.onlyShowBasicInfo then
            self:UpdateCollectNumState()
        end
    end
end

function SeasonCardGalleryItem:OnCollectSingleCardRewardFinish(params)
    if params.cardId == self.cardId and params.seasonId == self.seasonId then
        if not self.onlyShowBasicInfo then
            self:UpdateState()
        end
    end
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.SeasonCard.CardAdd, func = this.OnCardAdd},
    {notifyName = NotifyName.SeasonCard.DropOneCard, func = this.OnDropOneCard},
    {notifyName = NotifyName.SeasonCard.CollectSingleCardRewardFinish, func = this.OnCollectSingleCardRewardFinish},
}

return this