local Const = require "View/CarQuest/CarQuestConst"
local CarQuestSectionMgr = {}
local useDirectSwithSpeed = true

local States = {
    none = 0,
    moving = 1,
    movingFinish = 2
}

function CarQuestSectionMgr:Init(view, root, rankData)
    self.view = view
    self.root = root
    self.rankData = rankData
    local ref = fun.get_component(root, fun.REFER)
    local topPoint = ref:Get("topPoint")
    
    self.zebraStripes = ref:Get("imgZebraStripes")
    fun.set_active(self.zebraStripes, false)
    
    self.state = States.none
    self.posList = {}
    self.startPos = 0
    self.speed = 0
    self.targetMoveDistance = 0
    self.moveDistance = 0
    self.startSectionIdx = 0
    self.endSectionIdx = 0
    -- self.startFuelVolume = 0
    -- self.endFuelVolume = 0
    self.traveledDistance = 0
    self.curSectionIdx = 0
    self.screenHeight = view:GetScreenHeight()
    self.startFuelVolume = rankData[Const.MyTrackNum].lastScore
    self.endFuelVolume = rankData[Const.MyTrackNum].score
    self:CalculateMoveParams()
end

function CarQuestSectionMgr:CalculateMoveParams()
    local raceConfig = self.view:GetRaceConfig()
    local screenHeight = self.view:GetScreenHeight()
    local params = Const.CalculateMoveParams(raceConfig, screenHeight, self.startFuelVolume, self.endFuelVolume)
    if params then
        self.startSectionIdx = params.startIdx
        self.endSectionIdx = params.endIdx
        self.curSectionIdx = params.startIdx
        self.traveledDistance = params.traveledDistance
        self.targetMoveDistance = params.targetMoveDistance
        self.posList = params.stagePointList
    end
end

function CarQuestSectionMgr:GetTraveledDistance()
    return self.traveledDistance
end

function CarQuestSectionMgr:GetTargetMoveDistance()
    return self.targetMoveDistance
end

function CarQuestSectionMgr:CalculateSpeed()
    self.speed = self.targetMoveDistance / self.carMovingTime
end

function CarQuestSectionMgr:CreateZebraStripes()
    fun.set_rect_anchored_position(self.zebraStripes, 0, self:CalculateZebraStripesPos())
    fun.set_active(self.zebraStripes, true)
end

function CarQuestSectionMgr:Update(deltaTime)
    if self.state == States.moving then
        self:Move(deltaTime)
        if self.moveDistance >= self.targetMoveDistance then
            self.state = States.movingFinish
        end
    end
end

function CarQuestSectionMgr:Move(deltaTime)
    if self.moveDistance >= self.targetMoveDistance then
        return
    end

    local offset = deltaTime * self.speed

    if self.moveDistance + offset >= self.targetMoveDistance then
        offset =  self.targetMoveDistance - self.moveDistance
    end
    self.moveDistance = self.moveDistance + offset
    local obj = self.zebraStripes

    local pos = fun.get_rect_anchored_position(obj)
    if pos.y < -Const.ZebraStripesWidth then
        self.curSectionIdx = self.curSectionIdx + 1
        if self.curSectionIdx <= self.endSectionIdx then
            --fun.set_rect_anchored_position(obj, 0, pos.y + Const.RoadUnitLength * Const.RoadUnitCount - offset)
            fun.set_rect_anchored_position(obj, 0, self:CalculateZebraStripesPos())
        end
    else
        fun.set_rect_anchored_position(obj, 0, pos.y - offset)
    end
end

function CarQuestSectionMgr:CalculateZebraStripesPos()
    local offset = self.posList[self.curSectionIdx] - self.moveDistance - self.traveledDistance + self.view:GetPlayerCarMovingPos() + self.screenHeight / 2
    return offset
end

function CarQuestSectionMgr:ShowInFinalPos()
    self.curSectionIdx = self.endSectionIdx
    self.moveDistance = self.targetMoveDistance
    fun.set_rect_anchored_position(self.zebraStripes, 0, self:CalculateZebraStripesPos())
    fun.set_active(self.zebraStripes, true)
end

function CarQuestSectionMgr:StartMove()
    --[[
    self:StopAccelerate()
    if useDirectSwithSpeed then
        self.speed = Const.RoadLowSpeed
    else
        self.accelerateAnim = Anim.do_smooth_float_update(0, Const.RoadLowSpeed, 1,
            function(num) 
                self.speed = num
            end,
            function()
                self.accelerateAnim = nil
                self.speed = Const.RoadLowSpeed
            end
        )
    end
    ]]
    self.state = States.moving
end

function CarQuestSectionMgr:MoveSlow()
    self:StopAccelerate()
    if useDirectSwithSpeed then
        self.speed = Const.RoadLowSpeed
    else
        self.accelerateAnim = Anim.do_smooth_float_update(self.speed, Const.RoadLowSpeed, 1,
            function(num) 
                self.speed = num
            end,
            function()
                self.accelerateAnim = nil
                self.speed = Const.RoadLowSpeed
            end
        )
    end
end

function CarQuestSectionMgr:MoveFast()
    self:StopAccelerate()
    if useDirectSwithSpeed then
        self.speed = Const.RoadHighSpeed
    else
        self.accelerateAnim = Anim.do_smooth_float_update(self.speed, Const.RoadHighSpeed, 1,
            function(num) 
                self.speed = num
            end,
            function()
                self.accelerateAnim = nil
                self.speed = Const.RoadHighSpeed
            end
        )
    end
end

function CarQuestSectionMgr:StopAccelerate()
    if self.accelerateAnim then 
        self.accelerateAnim:Kill()
        self.accelerateAnim = nil
    end
end

function CarQuestSectionMgr:SetCarMovingTime(movingTime)
    self.carMovingTime = movingTime
end

function CarQuestSectionMgr:Test()
    self.moveDistance = 0
    --self.curSectionIdx = self.startSectionIdx
    --self:CalculateAllLinePos()
    self:CalculateMoveParams()
    fun.set_rect_anchored_position(self.zebraStripes, 0, self:CalculateZebraStripesPos())
end

function CarQuestSectionMgr:GetCurStageIdx()
    return self.curSectionIdx
end

function CarQuestSectionMgr:GetStartStageIdx()
    return self.startSectionIdx
end

function CarQuestSectionMgr:GetEndStageIdx()
    return self.endSectionIdx
end

function CarQuestSectionMgr:GetCurPosInScreen()
    if fun.is_not_null(self.zebraStripes) then
        local pos = fun.get_rect_anchored_position(self.zebraStripes)
        return pos.y
    end

    return 0
end

return CarQuestSectionMgr