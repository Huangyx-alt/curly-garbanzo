local GiftPackQuestItem = require("View.GiftPack.GiftPackQuest.GiftPackQuestItem")

--- 赛车活动礼包
local GiftPackBaseView = require("View.GiftPack.GiftPackBaseView")
local GiftPackCompetitionQuestView = GiftPackBaseView:New('CompetitionQuestPackView', "QuestGiftPackAtlas")
local this = GiftPackCompetitionQuestView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local data = nil
local product_list = {}
local canUpBuy = true
local canDownBuy = true
local click_interval = 0.5

this.auto_bind_ui_items = {
    "GiftPackTwoView",
    "btn_close",
    "Gift1",
    "Gift2",
    "Gift3",
    "Gift4",
}

function GiftPackCompetitionQuestView:Awake(obj)
    this:on_init()
    self._isInit = true
    --- 修复部分机型首次进入界面不显示问题
    if self._reshowAfterInit then
        self._reshowAfterInit = nil
        self:ShowDetailGift()
    end
end

function GiftPackCompetitionQuestView.OnEnable()
    this:BuildFsm(this)
    this:Bi_Tracker()
end

function GiftPackCompetitionQuestView.OnDisable()
    this:stop_x_update()
end

function GiftPackCompetitionQuestView:OnDestroy()
    this:Destroy()
    self.questItem_list = {}
end

function GiftPackCompetitionQuestView:on_close()
    this:stop_x_update()
    table.each(self.questItem_list, function(questItem)
        questItem:Close()
    end)
end

function GiftPackCompetitionQuestView:ShowDetailGift()
    if self._isInit then
        data = ModelList.GiftPackModel:GetQuestPack()
        if data then
            this:ShowProducts(data.pId, data.giftInfo)
        end
    else
        self._reshowAfterInit = true
    end
end

function GiftPackCompetitionQuestView:ShowProducts(pId, giftInfo)
    product_list = {}
    for k, v in pairs(Csv.pop_up) do
        if pId == v.gift_id then
            for i = 1, #giftInfo do
                if giftInfo[i].id == k then
                    table.insert(product_list, v.id)
                    break
                end
            end
        end
    end
    table.sort(product_list)

    self.questItem_list = self.questItem_list or {}
    table.each(product_list, function(packID, k)
        if not self.questItem_list[packID] then
            local questPackItem = GiftPackQuestItem:New(self, pId, packID)
            local ctrlName = "Gift" .. k
            local ctrl = self[ctrlName]
            questPackItem:SkipLoadShow(ctrl)
            self.questItem_list[packID] = questPackItem
        else
            self.questItem_list[packID]:UpdateData()
        end
    end)
end

function GiftPackCompetitionQuestView:CloseFunc()
    Facade.SendNotification(NotifyName.HideDialog, this)
end

function GiftPackCompetitionQuestView:CutDonwTarget()
    this:CloseFunc()
    this.main_effect:Play("end")
end

function GiftPackCompetitionQuestView:OnBuySuccess(needClose, itemData)
    this:ChangeState(this, "GiftPackShowState", itemData)

    if itemData and itemData.id then
        this:FlyGiftIcon(itemData.id)
    end
end

--购买礼包成功后，如果在赛车主界面，礼包图片飞到指定位置
function GiftPackCompetitionQuestView:FlyGiftIcon(packID)
    local questItem = self.questItem_list[packID]
    if questItem then
        local giftIcon = questItem:GetGiftIcon()
        if fun.is_not_null(giftIcon) then
            if ViewList.CarQuestMainView.isShow then
                local moveTarget, buffType = self:GetGiftMoveTarget(packID)
                if fun.is_not_null(moveTarget) then
                    local instance = fun.get_instance(giftIcon, moveTarget)
                    instance.transform.position = giftIcon.transform.position
                    
                    LuaTimer:SetDelayFunction(0.5, function()
                        Anim.move_ease(instance, 0, 0, 0, 1, true, DG.Tweening.Ease.InOutSine, function()
                            --赛车主界面做表现
                            ViewList.CarQuestMainView:DoGetBuffEffect(buffType)
                            Destroy(instance)
                        end)
                    end, nil, LuaTimer.TimerType.UI)
                    
                    Facade.SendNotification(NotifyName.HideUI, ViewList.GiftPackCompetitionQuestView)
                    ModelList.GiftPackModel:CloseView()
                    Event.Brocast(EventName.Event_competition_quest_buy_buff_success)
                end
            else
                --飞向顶部排行UI
                local buffType = self:GetGiftBuffType(packID)
                Event.Brocast(EventName.Event_competition_quest_buy_buff_success, giftIcon, buffType, function()
                    Facade.SendNotification(NotifyName.HideUI, ViewList.GiftPackCompetitionQuestView)
                    ModelList.GiftPackModel:CloseView()
                end)
            end
        end
    end
end

function GiftPackCompetitionQuestView:GetGiftBuffType(packID)
    local popCfg, ret = Csv.GetData("pop_up", packID)
    table.each(popCfg.item_description, function(cfg)
        local itemID = tonumber(cfg[1])
        if itemID == RESOURCE_TYPE.RESOURCE_TYPE_RACING_CAR_MORE_OIL_BUFF then
            --油桶buff
            ret = RESOURCE_TYPE.RESOURCE_TYPE_RACING_CAR_MORE_OIL_BUFF
        elseif itemID == RESOURCE_TYPE.RESOURCE_TYPE_RACING_CAR_REWARD_BUFF then
            --改装buff
            ret = RESOURCE_TYPE.RESOURCE_TYPE_RACING_CAR_REWARD_BUFF
        end
    end)
    return ret
end

function GiftPackCompetitionQuestView:GetGiftMoveTarget(packID)
    if not ViewList.CarQuestMainView.isShow then
        return
    end

    local popCfg, target, type = Csv.GetData("pop_up", packID)
    table.each(popCfg.item_description, function(cfg)
        local itemID = tonumber(cfg[1])
        if itemID == RESOURCE_TYPE.RESOURCE_TYPE_RACING_CAR_MORE_OIL_BUFF then
            --油桶buff
            target = ViewList.CarQuestMainView:GetRewardBuffTransform()
            if fun.is_not_null(target) then
                target = target.transform.parent
            end
            type = RESOURCE_TYPE.RESOURCE_TYPE_RACING_CAR_MORE_OIL_BUFF
        elseif itemID == RESOURCE_TYPE.RESOURCE_TYPE_RACING_CAR_REWARD_BUFF then
            --改装buff
            target = ViewList.CarQuestMainView:GetPlayerCarTransform()
            type = RESOURCE_TYPE.RESOURCE_TYPE_RACING_CAR_REWARD_BUFF
        end
    end)
    return target, type
end

function GiftPackCompetitionQuestView:GetGiftPos(id)
    local questItem = self.questItem_list[id]
    if questItem then
        local a, b, c, d = questItem:GetGiftPos()
        return a, b, c, d
    end
end

function GiftPackCompetitionQuestView:on_btn_close_click(force)
    if this._fsm:GetCurName() == "GiftPackShowState" then
        return
    end
    Facade.SendNotification(NotifyName.HideUI, ViewList.GiftPackCompetitionQuestView)
    ModelList.GiftPackModel:CloseView()
end

return this
