require "View/CommonView/RemainTimeCountDown"

local questRankItem = require("View.DailyCompetition.Quest.CompetitionQuestReadyRankItem")
local TopCompetitionQuestView = BaseView:New("TopCompetitionQuestView")
local this = TopCompetitionQuestView

this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "RemainTime",
    "FirstPlace",
    "LastPlace",
    "btn_click_mask",
    "RewardBuff",
    "ItemBuff",
    "Road",
    "txtGroup",
}

function TopCompetitionQuestView:New()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    o.rankCtrlList = {}
    return o
end

function TopCompetitionQuestView:OnEnable(params)
    Event.AddListener(EventName.Event_competition_quest_buy_buff_success, self.OnBuyBuffSuccess, self)
    Event.AddListener(EventName.Event_competition_quest_item_buff, self.SetItemBuff, self)
    Event.AddListener(EventName.Event_competition_quest_reward_buff, self.SetRewardBuff, self)
end

function TopCompetitionQuestView:OnDisable()
    Event.RemoveListener(EventName.Event_competition_quest_buy_buff_success, self.OnBuyBuffSuccess, self)
    Event.RemoveListener(EventName.Event_competition_quest_item_buff, self.SetItemBuff, self)
    Event.RemoveListener(EventName.Event_competition_quest_reward_buff, self.SetRewardBuff, self)
    self.firstEnableShow = false
end

function TopCompetitionQuestView:OnDestroy()
    self.rankCtrlList = {}
    if self.remainTimeCountDown then
        self.remainTimeCountDown:StopCountDown()
        self.remainTimeCountDown = nil
    end
end

--购买任意buff成功,做表现
function TopCompetitionQuestView:OnBuyBuffSuccess(buffIconObj, buffType, cb)
    if self.isShow then
        if fun.is_not_null(buffIconObj) and fun.is_not_null(self.Road) then
            local root = fun.GameObject_find("Canvas/GameUI")
            local instance = fun.get_instance(buffIconObj, root)
            instance.transform.position = buffIconObj.transform.position
            local targetPos = self.Road.transform.position

            if cb then cb() end
            LuaTimer:SetDelayFunction(0.5, function()
                Anim.move_ease(instance, targetPos.x, targetPos.y, targetPos.z, 1, false, DG.Tweening.Ease.InOutSine, function()
                    Destroy(instance)
                    if buffType == RESOURCE_TYPE.RESOURCE_TYPE_RACING_CAR_MORE_OIL_BUFF then
                        self:SetItemBuff()
                    elseif buffType == RESOURCE_TYPE.RESOURCE_TYPE_RACING_CAR_REWARD_BUFF then
                        self:SetRewardBuff()
                    end
                end)
            end, nil, LuaTimer.TimerType.UI)
        else
            self:SetItemBuff()
            self:SetRewardBuff()
        end
    end
end

--汽油buff道具状态更新
function TopCompetitionQuestView:SetItemBuff()
    local remainBuffTime = ModelList.CarQuestModel:GetMoreItemBuffTime()
    fun.set_active(self.ItemBuff, remainBuffTime > 0)
end
--改装buff道具状态更新
function TopCompetitionQuestView:SetRewardBuff()
    local remainBuffTime = ModelList.CarQuestModel:GetMoreRewardBuffTime()
    fun.set_active(self.RewardBuff, remainBuffTime > 0)
end

function TopCompetitionQuestView:Show()
    if self.firstEnableShow then
        return
    end
    self.firstEnableShow = true

    local remainBuffTime = ModelList.CarQuestModel:GetMoreRewardBuffTime()
    fun.set_active(self.RewardBuff, remainBuffTime > 0)
    remainBuffTime = ModelList.CarQuestModel:GetMoreItemBuffTime()
    fun.set_active(self.ItemBuff, remainBuffTime > 0)

    if fun.is_not_null(self.txtGroup) then
        local groupId = ModelList.CarQuestModel:GetRacingGroupID()
        local groupStr = "S" .. groupId
        self.txtGroup.text = groupStr
    end
    
    self:StartRemainTime()

    --if ModelList.CarQuestModel.needShowRankChange then
    --    self:ShowRanks(true)
    --    LuaTimer:SetDelayFunction(1, function()
    --        self:ShowCurRanks()
    --    end, false, LuaTimer.TimerType.UI)
    --    ModelList.CarQuestModel.needShowRankChange = false
    --else
        self:ShowRanks()
    --end

    fun.set_rect_local_pos_y(self.go, 0)
end

function TopCompetitionQuestView:StartRemainTime()
    if self.remainTimeCountDown then
        self.remainTimeCountDown:StopCountDown()
    else
        self.remainTimeCountDown = RemainTimeCountDown:New()
    end

    local remainTime = ModelList.CarQuestModel:GetActivityRemainTime() + 2
    if fun.is_not_null(self.RemainTime) then
        self.remainTimeCountDown:StartCountDown(CountDownType.cdt3, remainTime, self.RemainTime, function()
            local isAvailable = ModelList.CarQuestModel:IsActivityAvailable()
            if not isAvailable then
                self:Close()
            end
        end)
    end
end

---活动排名展示
---先加载上一次的排名
function TopCompetitionQuestView:ShowRanks(useLastRankData)
    local rankInfoList = ModelList.CarQuestModel:GetRankData()
    local totalCount = GetTableLength(rankInfoList)
    if totalCount > 0 then
        local tempCtrl, firstScore, lastScore, needSetPos
        local myUid = ModelList.PlayerInfoModel:GetUid()
        table.each(rankInfoList, function(info)
            local isSelf = myUid == info.uid
            local rank = useLastRankData and info.lastRank or info.rank
            local score = useLastRankData and info.lastScore or info.score
            tempCtrl = isSelf and self.FirstPlace or self.LastPlace
            if rank == 1 then
                --第一
                firstScore = score
                needSetPos = false
            elseif rank == totalCount then
                --倒数第一
                lastScore = score
                needSetPos = false
            else
                needSetPos = true
            end

            --第一次展示才会实例化
            local find = table.find(self.rankCtrlList, function(k, v)
                return v.rankInfo.uid == info.uid
            end)
            if not find then
                local rankCtrl = fun.get_instance(tempCtrl, tempCtrl.transform.parent)
                rankCtrl.transform.name = tostring(info.uid)
                table.insert(self.rankCtrlList, {
                    rankInfo = info,
                    ctrl = rankCtrl,
                    isSelf = isSelf,
                    needSetPos = needSetPos,
                })
                local view = questRankItem:New(info, rankCtrl)
                view:Show()
            end
        end)

        self:SetRankCtrlPos(firstScore, lastScore, useLastRankData)
    end
end

---创建所有RankCtrl后更新位置
function TopCompetitionQuestView:SetRankCtrlPos(firstScore, lastScore, useLastRankData)
    --玩家自己的层级在最上面，其它的层级按照排名来
    table.sort(self.rankCtrlList, function(a, b)
        if a.isSelf and not b.isSelf then
            return false
        end
        if not a.isSelf and b.isSelf then
            return true
        end
        if useLastRankData then
            return a.rankInfo.lastRank > b.rankInfo.lastRank
        else
            return a.rankInfo.rank > b.rankInfo.rank
        end
    end)

    --第二次更新时就需要调整大小了
    local FirstPlaceX, LastPlaceX = self.FirstPlace.transform.localPosition.x, self.LastPlace.transform.localPosition.x
    local count = GetTableLength(self.rankCtrlList)
    table.each(self.rankCtrlList, function(v, k)
        local rank = useLastRankData and v.rankInfo.lastRank or v.rankInfo.rank
        if rank == 1 then
            --第一
            fun.set_rect_local_pos_x(v.ctrl, FirstPlaceX)
        elseif rank == count then
            --倒数第一
            fun.set_rect_local_pos_x(v.ctrl, LastPlaceX)
        end
    end)

    local tempScore = firstScore - lastScore
    if tempScore ~= 0 then
        local tempDistanceX = FirstPlaceX - LastPlaceX
        table.each(self.rankCtrlList, function(v, k)
            if v.needSetPos then
                local score = useLastRankData and v.rankInfo.lastScore or v.rankInfo.score
                local diffScore = score - lastScore
                local coefficient = diffScore / tempScore
                local targetX = LastPlaceX + tempDistanceX * coefficient
                fun.set_rect_local_pos_x(v.ctrl, targetX)
            end
            fun.SetAsLastSibling(v.ctrl)
        end)
    else
        table.each(self.rankCtrlList, function(v, k)
            v.ctrl.transform.localPosition = self.LastPlace.transform.localPosition
            fun.set_rect_offset_local_pos(v.ctrl, 10 * k)
            fun.SetAsLastSibling(v.ctrl)
        end)
    end
end

---上一次的排名展示完成后再表现当前的排名
function TopCompetitionQuestView:ShowCurRanks()
    local rankInfoList = ModelList.CarQuestModel:GetRankData()
    local totalCount = GetTableLength(rankInfoList)
    if totalCount > 0 then
        local firstScore, lastScore
        table.each(rankInfoList, function(info)
            if info.rank == 1 then
                --第一
                firstScore = info.score
            elseif info.rank == totalCount then
                --倒数第一
                lastScore = info.score
            end
        end)
        self:MoveRankCtrlPos(firstScore, lastScore)
    end
end

function TopCompetitionQuestView:MoveRankCtrlPos(firstScore, lastScore)
    --玩家自己的层级在最上面，其它的层级按照排名来
    table.sort(self.rankCtrlList, function(a, b)
        if a.isSelf and not b.isSelf then
            return false
        end
        if not a.isSelf and b.isSelf then
            return true
        end
        return a.rankInfo.rank > b.rankInfo.rank
    end)

    local count = GetTableLength(self.rankCtrlList)
    local tempScore = firstScore - lastScore
    if tempScore ~= 0 then
        local FirstPlaceX, LastPlaceX = self.FirstPlace.transform.localPosition.x, self.LastPlace.transform.localPosition.x
        local tempDistanceX = FirstPlaceX - LastPlaceX
        table.each(self.rankCtrlList, function(v, k)
            if v.rankInfo.rank == 1 then
                --第一
                Anim.move_to_x(v.ctrl, FirstPlaceX, 1)
            elseif v.rankInfo.rank == count then
                --倒数第一
                Anim.move_to_x(v.ctrl, LastPlaceX, 1)
            else
                local diffScore = v.rankInfo.score - lastScore
                local coefficient = diffScore / tempScore
                local targetX = LastPlaceX + tempDistanceX * coefficient
                Anim.move_to_x(v.ctrl, targetX, 1)
            end
            fun.SetAsLastSibling(v.ctrl)
        end)
    else
        table.each(self.rankCtrlList, function(v, k)
            v.ctrl.transform.localPosition = self.LastPlace.transform.localPosition
            fun.set_rect_offset_local_pos(v.ctrl, 10 * k)
            fun.SetAsLastSibling(v.ctrl)
        end)
    end
end

function TopCompetitionQuestView:CheckActivity(obj)
    local available = ModelList.CarQuestModel:IsActivityAvailable()
    if fun.is_not_null(obj) then
        fun.set_active(obj.transform.parent.parent, available, false)
        fun.set_active(obj.transform, available, false)
        if available then
            self:SkipLoadShow(obj)
            self:Show()
        end
    end
end

function TopCompetitionQuestView:on_btn_click_mask_click()
    ModelList.CarQuestModel.ReqRacingFetch(function(code)
        if code == RET.RET_SUCCESS then
            local Const = require "View/CarQuest/CarQuestConst"
            ViewList.CarQuestMainView:SetEnterMode(Const.EnterMode.manualClick)
            Facade.SendNotification(NotifyName.ShowUI, ViewList.CarQuestMainView)
        end
    end)
end

return this


