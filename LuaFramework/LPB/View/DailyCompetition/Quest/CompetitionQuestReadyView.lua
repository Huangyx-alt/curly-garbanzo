local questRankItem = require("View.DailyCompetition.Quest.CompetitionQuestReadyRankItem")
local CompetitionQuestReadyView = BaseView:New("CompetitionQuestReadyView", "CompetitionQuestAtlas")
local this = CompetitionQuestReadyView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

function CompetitionQuestReadyView:New()
    local o = {}
    self.__index = this
    setmetatable(o, this)
    o.rankCtrlList = {}
    return o
end

this.auto_bind_ui_items = {
    "RemainTime",
    "FirstPlace",
    "text_countdown",
    "LastPlace",
    "RewardBuff",
    "ItemBuff",
    "txtGroup"
}

function CompetitionQuestReadyView:Awake(obj)
    self:on_init()
end

function CompetitionQuestReadyView:OnEnable(params)
    local remainBuffTime = ModelList.CarQuestModel:GetMoreItemBuffTime()
    fun.set_active(self.ItemBuff, remainBuffTime > 0)
    remainBuffTime = ModelList.CarQuestModel:GetMoreRewardBuffTime()
    fun.set_active(self.RewardBuff, remainBuffTime > 0)

    if fun.is_not_null(self.txtGroup) then
        local groupId = ModelList.CarQuestModel:GetRacingGroupID()
        local groupStr = "S" .. groupId
        self.txtGroup.text = groupStr
    end
    
    self:StartRemainTime()
    self:LoadRanks()
    fun.set_rect_local_pos_y(self.go, 0)
end

function CompetitionQuestReadyView:OnDisable()
    if self.remainTimeCountDown then
        self.remainTimeCountDown:StopCountDown()
        self.remainTimeCountDown = nil
    end
end

function CompetitionQuestReadyView:OnDestroy()
    self.rankCtrlList = {}
end

function CompetitionQuestReadyView:StartRemainTime()
    if self.remainTimeCountDown then
        self.remainTimeCountDown:StopCountDown()
    else
        self.remainTimeCountDown = RemainTimeCountDown:New()
    end

    local remainTime = ModelList.CarQuestModel:GetActivityRemainTime()
    self.remainTimeCountDown:StartCountDown(CountDownType.cdt7, remainTime, self.text_countdown, function()

    end)
end

---活动排名展示
function CompetitionQuestReadyView:LoadRanks()
    local rankInfoList = ModelList.CarQuestModel:GetRankData()
    local totalCount = GetTableLength(rankInfoList)
    if totalCount > 0 then
        local tempCtrl, firstScore, lastScore, needSetPos
        local myUid = ModelList.PlayerInfoModel:GetUid()
        table.each(rankInfoList, function(info)
            local isSelf = myUid == info.uid
            tempCtrl = isSelf and self.FirstPlace or self.LastPlace
            if info.rank == 1 then
                --第一
                firstScore = info.score
                needSetPos = false
            elseif info.rank == totalCount then
                --倒数第一
                lastScore = info.score
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

        self:SetRankCtrlPos(firstScore, lastScore)
    end
end

---创建所有RankCtrl后更新位置
function CompetitionQuestReadyView:SetRankCtrlPos(firstScore, lastScore)
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

return this

