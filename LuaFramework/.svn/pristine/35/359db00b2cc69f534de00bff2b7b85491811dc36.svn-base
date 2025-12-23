local Const = require "View/CarQuest/CarQuestConst"
local CarQuestPropItem = require "View/CarQuest/CarQuestPropItem"
local CarQuestPropMgr = {}

local States = {
    none = 0,
    moving = 1,
    movingFinish = 2
}

local AwardStates = {
    none = 0,
    reachable = 1,
    reached = 2,
    outOfReach = 3,
}

function CarQuestPropMgr:Init(view, root, rankData, extraRewards)
    self.view = view
    self.root = root
    self.rankData = rankData
    self.extraRewards = extraRewards
    local ref = fun.get_component(root, fun.REFER)
    local topPoint = ref:Get("topPoint")
    self.itemProp = ref:Get("itemProp")
    self.cursorRoot = ref:Get("cursorRoot")
    self.baojinbi = ref:Get("baojinbi")
    self.baozuanshi = ref:Get("baozuanshi")
    self.baoxiaohuojian = ref:Get("baoxiaohuojian")
    fun.set_active(self.itemProp, false)
    
    self.state = States.none
    self.posList = {}
    self.startPos = 0
    self.speed = 0
    self.targetMoveDistance = 0
    self.moveDistance = 0
    self.startTotalIdx = 0
    self.endTotalIdx = 0
    self.traveledDistance = 0
    self.screenHeight = view:GetScreenHeight()
    self.startFuelVolume = rankData[Const.MyTrackNum].lastScore
    self.endFuelVolume = rankData[Const.MyTrackNum].score
    self.deactiveItemList = {}

    local raceConfig = self.view:GetRaceConfig()
    local screenHeight = self.view:GetScreenHeight()
    self.initSucc, self.arrangeList = Const.CalculatePropArrange(raceConfig, screenHeight, self.extraRewards)
    log.log("CarQuestPropMgr:Init, self.arrangeList is ", self.arrangeList)

    self:CalculatePropParams()
    self:InitExtraRewardBuffState()
end

function CarQuestPropMgr:InitExtraRewardBuffState()
    if not self.initSucc then
        return
    end

    self.extraRewardBuffRecord = {}
    for i1 = 1, Const.TrackCount do
        self.extraRewardBuffRecord[i1] = false
        local props = self.rankData and self.rankData[i1] and self.rankData[i1].gameProps
        if props and #props > 0 then
            for i2, v2 in ipairs(props) do
                local name = Csv.GetData("resources", v2, "name")
                if name == "racingreward" then
                    self.extraRewardBuffRecord[i1] = true
                    break
                end
            end
        end
    end
end

function CarQuestPropMgr:IsNeedCreateProp(col)
    if col == Const.MyTrackNum then
        return true
    end

    return self.extraRewardBuffRecord[col]
end

function CarQuestPropMgr:GetCarFinalScore(col)
    return self.rankData and self.rankData[col] and self.rankData[col].score or 0
end

function CarQuestPropMgr:CalculatePropParams()
    if not self.initSucc then
        return
    end

    self.propAwardStateList = {}
    for i1 = 1, Const.TrackCount do
        self.propAwardStateList[i1] = {}
        local startScore = self.rankData[i1].lastScore
        local endScore = self.rankData[i1].score
        local params = Const.CalculatePropParams(self.arrangeList, startScore, endScore)
        local startTotalIdx = params.startIdx
        local endTotalIdx = params.endIdx
        self.propAwardStateList[i1].startTotalIdx = startTotalIdx
        self.propAwardStateList[i1].endTotalIdx = endTotalIdx
        local record = {}
        for i2 = 1, #self.arrangeList do
            if i2 < startTotalIdx then
                record[i2] = AwardStates.reached
            elseif i2 < endTotalIdx then
                record[i2] = AwardStates.reachable
            else
                record[i2] = AwardStates.outOfReach
            end
        end
        --处理最一个节点，玩家已经到终点的情况
        if endScore >= self.arrangeList[#self.arrangeList].score then
            record[#self.arrangeList] = AwardStates.reachable
        end
        self.propAwardStateList[i1].record = record
    end

    self.startTotalIdx = self.propAwardStateList[Const.MyTrackNum].startTotalIdx
    self.endTotalIdx = self.propAwardStateList[Const.MyTrackNum].endTotalIdx
end

function CarQuestPropMgr:CalculateSpeed()
    if not self.initSucc then
        return
    end
    self.speed = self.targetMoveDistance / self.carMovingTime
end

function CarQuestPropMgr:SetTraveledDistance(traveledDistance)
    self.traveledDistance = traveledDistance
end

function CarQuestPropMgr:SetTargetMoveDistance(targetMoveDistance)
    self.targetMoveDistance = targetMoveDistance
end

function CarQuestPropMgr:GetTraveledDistance()
    return self.traveledDistance
end

function CarQuestPropMgr:GetTargetMoveDistance()
    return self.targetMoveDistance
end

function CarQuestPropMgr:CreatePropsAtStartPoint()
    if not self.initSucc then
        return
    end

    self.propItemList = {}
    self:InitRectInsightAtStartPoint()
    for i1 = 1, Const.TrackCount do
        self.propItemList[i1] = {}
        if self:IsNeedCreateProp(i1) then
            for i2, v2 in ipairs(self.arrangeList) do
                if i2 + Const.MaxPropDensity >= self.startTotalIdx and i2 - Const.MaxPropDensity <= self.startTotalIdx and self:IsItemInSight(v2.pos) then
                    if self.propAwardStateList[i1].record[i2] ~= AwardStates.reached then
                        local item = self:CreatePropItem(i1, v2)
                        item:UpdateData(v2, i1)
                        if i1 == Const.MyTrackNum then
                            if self.extraRewardBuffRecord[i1] then
                                item:Active()
                            else
                                item:Deactive()
                            end
                        else
                            item:Active()
                        end
                        table.insert(self.propItemList[i1], item)
                        --fun.set_rect_anchored_position(itemGo, (i1 - (Const.TrackCount + 1) / 2) * Const.TrackWidth, v2.pos)
                    end
                end
            end
        end
    end
end

function CarQuestPropMgr:CreatePropsAtEndPoint()
    if not self.initSucc then
        return
    end

    self.propItemList = {}
    self:InitRectInsightAtEndPoint()
    for i1 = 1, Const.TrackCount do
        self.propItemList[i1] = {}
        if self:IsNeedCreateProp(i1) then
            for i2, v2 in ipairs(self.arrangeList) do
                if i2 + Const.MaxPropDensity >= self.endTotalIdx and i2 - Const.MaxPropDensity <= self.endTotalIdx and self:IsItemInSight(v2.pos) then
                    --if self.propAwardStateList[i1].record[i2] ~= AwardStates.reached and self.arrangeList[i2].score > self:GetCarFinalScore(i1) then
                    if self.propAwardStateList[i1].record[i2] == AwardStates.outOfReach then
                        local item = self:CreatePropItem(i1, v2)
                        item:UpdateData(v2, i1)
                        if i1 == Const.MyTrackNum then
                            if self.extraRewardBuffRecord[i1] then
                                item:Active()
                            else
                                item:Deactive()
                            end
                        else
                            item:Active()
                        end
                        table.insert(self.propItemList[i1], item)
                        --fun.set_rect_anchored_position(itemGo, (i1 - (Const.TrackCount + 1) / 2) * Const.TrackWidth, v2.pos)
                    end
                end
            end
        end
    end
end

function CarQuestPropMgr:InitRectInsightAtStartPoint()
    self.startIndxInSight = 0
    self.endIndxInSight = #self.arrangeList
  
    for i, v in ipairs(self.arrangeList) do
        if i + Const.MaxPropDensity >= self.startTotalIdx and i - Const.MaxPropDensity <= self.startTotalIdx and self:IsItemInSight(v.pos) then
            if self.startIndxInSight == 0 then
                self.startIndxInSight = i
            end
            self.endIndxInSight = i
        end
    end

    if self.startIndxInSight == 0 then
        self.startIndxInSight = self.endIndxInSight
        log.log("CarQuestPropMgr:InitRectInsightAtStartPoint 已经到终点", self.startIndxInSight, self.startTotalIdx, self.endTotalIdx )
    end
    log.log("CarQuestPropMgr:InitRectInsightAtStartPoint ", self.startIndxInSight, self.endIndxInSight)
end

function CarQuestPropMgr:InitRectInsightAtEndPoint()
    self.startIndxInSight = 0
    self.endIndxInSight = #self.arrangeList
  
    for i, v in ipairs(self.arrangeList) do
        if i + Const.MaxPropDensity >= self.endTotalIdx and i - Const.MaxPropDensity <= self.endTotalIdx and self:IsItemInSight(v.pos) then
            if self.startIndxInSight == 0 then
                self.startIndxInSight = i
            end
            self.endIndxInSight = i
        end
    end

    if self.startIndxInSight == 0 then
        self.startIndxInSight = self.endIndxInSight
        log.log("CarQuestPropMgr:InitRectInsightAtEndPoint 已经到终点", self.startIndxInSight, self.startTotalIdx, self.endTotalIdx )
    end

    log.log("CarQuestPropMgr:InitRectInsightAtEndPoint ", self.startIndxInSight, self.endIndxInSight)
end

function CarQuestPropMgr:UpdateStartIdxInsight()
    local startIndxInSight = self.startIndxInSight
    local endIndxInSight = #self.arrangeList
    for i = self.startIndxInSight, endIndxInSight do
        if self:IsItemInSight(self.arrangeList[i].pos) then
            startIndxInSight = i
            break
        end
    end
  
    if startIndxInSight ~= self.startIndxInSight then
        for i1 = 1, Const.TrackCount do
            for i2 = #self.propItemList[i1], 1, -1 do
                local item = self.propItemList[i1][i2]
                if item:GetTotalIdx() < startIndxInSight then
                    item:Deactive()
                    table.remove(self.propItemList[i1], i2)
                    self:RecyclePropItem(item)
                end
            end
        end
        self.startIndxInSight = startIndxInSight
    end
end

function CarQuestPropMgr:UpdateEndIdxInsight()
    local endIndxInSight = #self.arrangeList
    local findFlag = false
    for i = self.endIndxInSight, #self.arrangeList do
        if self:IsItemInSight(self.arrangeList[i].pos) then
            endIndxInSight = i
            findFlag = true
        elseif findFlag then
            break
        end
    end
  
    if endIndxInSight ~= self.endIndxInSight then
        for i1 = 1, Const.TrackCount do
            if self:IsNeedCreateProp(i1) then
                for i2 = self.startIndxInSight, endIndxInSight do
                    if i2 > self.endIndxInSight then
                        local item = self:GetDeactivePropItem()
                        if not item then
                            item = self:CreatePropItem()
                        end
                        item:UpdateData(self.arrangeList[i2], i1)
                        if self:IsItemAheadCar(i1, item) then
                            if i1 == Const.MyTrackNum then
                                if self.extraRewardBuffRecord[i1] then
                                    item:Active()
                                else
                                    item:Deactive()
                                end
                            else
                                item:Active()
                            end
                        else
                            item:Deactive()
                        end
                        table.insert(self.propItemList[i1], item)
                    end
                end
            end
        end
        self.endIndxInSight = endIndxInSight
    end
end

function CarQuestPropMgr:CheckCollision(deltaTime)
    for i1 = 1, Const.TrackCount do
        if self.extraRewardBuffRecord[i1] then
            for i2 = 1, #self.propItemList[i1] do
                local item = self.propItemList[i1][i2]
                if (not self:IsItemAheadCar(i1, item) or self.state == States.movingFinish) and self.propAwardStateList[i1].record[item:GetTotalIdx()] == AwardStates.reachable then
                    item:PlayCollisionEffect()
                    self.propAwardStateList[i1].record[item:GetTotalIdx()] = AwardStates.reached
                else
                    --break --为更好的性能
                end
            end
        end
    end
end

function CarQuestPropMgr:RecyclePropItem(item)
    table.insert(self.deactiveItemList, item)
end

function CarQuestPropMgr:GetDeactivePropItem()
    if self.deactiveItemList and #self.deactiveItemList > 0 then
        return table.remove(self.deactiveItemList)
    end

    return nil
end

function CarQuestPropMgr:CreatePropItem()
    local item = CarQuestPropItem:New()
    item:SetParent(self.cursorRoot)
    item:SetView(self.view)
    local itemGo = fun.get_instance(self.itemProp, self.cursorRoot)
    item:SkipLoadShow(itemGo)
    fun.set_active(itemGo, true)
    return item
end

function CarQuestPropMgr:Update(deltaTime)
    if not self.initSucc then
        return
    end

    if self.state == States.moving then
        self:Move(deltaTime)
    end
end

function CarQuestPropMgr:UpdateLater(deltaTime)
    if not self.initSucc then
        return
    end

    if self.state == States.moving then
        if self.moveDistance >= self.targetMoveDistance then
            self.state = States.movingFinish
        end
        self:UpdateStartIdxInsight()
        self:UpdateEndIdxInsight()
        self:CheckCollision()
    end
end

function CarQuestPropMgr:Move(deltaTime)
    if self.moveDistance >= self.targetMoveDistance then
        return
    end

    local offset = deltaTime * self.speed

    if self.moveDistance + offset >= self.targetMoveDistance then
        offset =  self.targetMoveDistance - self.moveDistance
    end
    self.moveDistance = self.moveDistance + offset
    local obj = self.cursorRoot

    local pos = fun.get_rect_anchored_position(obj)
    fun.set_rect_anchored_position(obj, 0, pos.y - offset)
end

function CarQuestPropMgr:CalculateCursorStartPos()
    local pos = self.view:GetPlayerCarMovingPos() - self.traveledDistance + Const.ZebraStripesWidth / 2 + Const.PropHeight / 2
    return pos
end

function CarQuestPropMgr:CalculateCursorEndPos()
    local pos = self.view:GetPlayerCarMovingPos() - self.traveledDistance - self.targetMoveDistance + Const.ZebraStripesWidth / 2 + Const.PropHeight / 2
    return pos
end

function CarQuestPropMgr:ShowInStartPos()
    if not self.initSucc then
        return
    end

    self.moveDistance = 0
    local pos = self:CalculateCursorStartPos()
    fun.set_rect_anchored_position(self.cursorRoot, 0, pos)
end

function CarQuestPropMgr:ShowInFinalPos()
    if not self.initSucc then
        return
    end

    self.moveDistance = self.targetMoveDistance
    local pos = self:CalculateCursorEndPos()
    fun.set_rect_anchored_position(self.cursorRoot, 0, pos)
end

function CarQuestPropMgr:IsItemInSight(pos)
    local startPos = self:CalculateCursorStartPos()
    local absolutePos = pos + startPos + Const.PropHeight / 2 - self.moveDistance
    if absolutePos + Const.PropHeight / 2 > -self.screenHeight / 2 and absolutePos - Const.PropHeight / 2 < self.screenHeight / 2 then
        return true
    else
        return false
    end
end

function CarQuestPropMgr:StartMove()
    if not self.initSucc then
        return
    end

    self.state = States.moving
end

function CarQuestPropMgr:SetCarMovingTime(movingTime)
    self.carMovingTime = movingTime
end

function CarQuestPropMgr:Test()
    self.moveDistance = 0
    self:CalculateMoveParams()
end

function CarQuestPropMgr:GetStartStageIdx()
    return self.startTotalIdx
end

function CarQuestPropMgr:GetEndStageIdx()
    return self.endTotalIdx
end

function CarQuestPropMgr:GetCurPosInScreen()
    if fun.is_not_null(self.cursorRoot) then
        local pos = fun.get_rect_anchored_position(self.cursorRoot)
        return pos.y
    end

    return 0
end

function CarQuestPropMgr:GetItemPosInScreen(item)
    local pos = -self.moveDistance - self.traveledDistance + item:GetPos()
    return pos
end

function CarQuestPropMgr:IsItemAheadCar(col, item)
    local carPos = self.view:GetCarCurPosInScreen(col)
    local itemPos = self:GetItemPosInScreen(item)
    return itemPos > carPos + 200
end

function CarQuestPropMgr:ForeshowPropItems()
    if not self.initSucc then
        return
    end

    local items = self.propItemList[Const.MyTrackNum]
    for i, v in ipairs(items) do
        if self.propAwardStateList[Const.MyTrackNum] and self.propAwardStateList[Const.MyTrackNum].record then
            if self.propAwardStateList[Const.MyTrackNum].record[v:GetTotalIdx()] == AwardStates.outOfReach then
                v:Active()
            end
        end
    end
end

return CarQuestPropMgr