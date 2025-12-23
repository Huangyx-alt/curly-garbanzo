local Const = require "View/CarQuest/CarQuestConst"
local CarQuestCar = BaseView:New("CarQuestCar")
local this = CarQuestCar
this.viewType = CanvasSortingOrderManager.LayerType.none
local useDirectSwithSpeed = true

local CarAnimConfig = {
    idle = {"idle", "car1idle", "car2idle"},
    act = {"act", "car1act", "car2act"},
    stop = {"stop", "car1stop", "car2stop"},
    change = {"change", "car1change", "car2change"},
    idlegaoji = {"idlegaoji", "car1gaojiidle", "car2gaojiidle"},
    actgaoji = {"actgaoji", "car1gaojiact", "car2gaojiact"},
    stopgaoji = {"stopgaoji", "car1stopgaoji", "car2stopgaoji"},
    changegaoji = {"change", "car1change", "car2change"},
}

local CarFuleUpAnimConfig = {
    act0 = {"0", "jiayou_0"},
    act1 = {"1_0", "jiayou_1_0"},
    act2 = {"2_0", "jiayou_2_0"},
    act3 = {"3_0", "jiayou_3_0"},
    act03 = {"03_0", "jiayou_03_0"},
    act12 = {"12_0", "jiayou_12_0"},
    act13 = {"13_0", "jiayou_13_0"},
    act23 = {"23_0", "jiayou_23_0"},
}

this.auto_bind_ui_items = {
    "car",
    "bubble",
    "txtNum",
    "bubbleRect",
    "anima",
    "bubble_jiayou",
    "animaFuleUp",
    "Text0",
    "Text1",
    "Text2",
    "Text3",
    "txtTotal",
}

function CarQuestCar:New()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function CarQuestCar:Awake()
end

function CarQuestCar:OnEnable()
    Facade.RegisterViewEnhance(self)
    self.carState = Const.CarStates.none
end

function CarQuestCar:on_after_bind_ref()
    if fun.is_not_null(self.bubble_jiayou) then
        fun.set_active(self.bubble_jiayou, false)
    end

    self:InitItem()
end

function CarQuestCar:OnDisable()
    Facade.RemoveViewEnhance(self)
end

function CarQuestCar:SetData(data)
    log.log("CarQuestCar:SetData", data)
    self.data = data
    self.view = data.view
    self.mgr = data.mgr
    self.index = data.index or 0
    self.grade = Const.EnmuCarGrade.low
    self.gameProps = data.gameProps
    self.playerType = data.playerType or Const.EnmuPlayerType.enemy
    self.details = data.details
    self.speed = Const.CarNormalSpeed
    self.targetSpeed = 0
    self.moveTime = 0
    self.curMoveTime = 0

    self.startFuel = data.startFuel
    self.endFuel = data.endFuel
    
    local raceConfig = self.view:GetRaceConfig()
    local screenHeight = self.view:GetScreenHeight()
    local params = Const.CalculateMoveParams(raceConfig, screenHeight, self.startFuel, self.endFuel)
    log.log("CarQuestCar:SetData the params is ", self.index, params)
    self.targetMoveDistance = params.targetMoveDistance
    self.startPos = params.traveledDistance
    self.endPos = self.startPos + self.targetMoveDistance
    self.curMoveDistanceInScreen = 0
    self.stageFinishRecord = {}
    self.raceConfig = raceConfig

    self:InitGrade()
end

function CarQuestCar:InitGrade()
    if self.gameProps and #self.gameProps > 0 then
        for i, v in ipairs(self.gameProps) do
            local name = Csv.GetData("resources", v, "name")
            if name == "racingreward" then
                self:SetGrade(Const.EnmuCarGrade.high)
                break
            end
        end
    else
        self:SetGrade(Const.EnmuCarGrade.low)
    end
end

function CarQuestCar:SetGrade(grade)
    self.grade = grade
end

function CarQuestCar:InitItem()
    self:SetFuel(self.endFuel)
    self:ShowFuleBubble()
    self:CalculatePosInScreen()
    self:SetLocalPosY(self.startPosInScreen)
    self:ShowInStartPos()
end

function CarQuestCar:GetStartPos()
    return self.startPos
end

function CarQuestCar:GetEndPos()
    return self.EndPos
end

function CarQuestCar:GetCurPosInScreen()
    return self.startPosInScreen + self.curMoveDistanceInScreen
end

function CarQuestCar:ShowInStartPos()
    if self.startFuel >= self.view:GetFinishRaceNeedScore() then
        self:SetLocalPosY(2000)
    else
        self:SetLocalPosY(self.startPosInScreen)
    end
end

function CarQuestCar:ShowInEndPos()
    self:SetLocalPosY(self.endPosInScreen)
    if self.endFuel >= self.view:GetFinishRaceNeedScore() then
        self:SetLocalPosY(2000)
    end
end

function CarQuestCar:HasFinishRaceBefore()
    if self.startFuel >= self.view:GetFinishRaceNeedScore() then
        return true
    else
        return false
    end
end

function CarQuestCar:NotifyFinishRaceBefore()
    local bundle = {
        index = self.index,
        playerType = self.playerType,
        endFuel = self.endFuel,
        startFuel = self.startFuel,
    }
    Facade.SendNotification(NotifyName.CarQuest.NotifyFinishRaceBefore, bundle)
end

function CarQuestCar:GetTargetMoveDistance()
    return self.targetMoveDistance
end

function CarQuestCar:CalculatePosInScreen()
    self.startPosInScreen = self.startPos - self.mgr:GetPlayerStartPosInRoad() + self.view:GetPlayerCarMovingPos()
    self.targetMoveDistanceInScreen = self.targetMoveDistance - self.mgr:GetPlayerTargetMoveDistanceInRoad()
    self.endPosInScreen = self.startPosInScreen + self.targetMoveDistanceInScreen
    self.speed = self.targetMoveDistanceInScreen / Const.MoveTime
    self.curPosInScreen = self.startPosInScreen
end

function CarQuestCar:SetMoveTime(moveTime)
    self.moveTime = moveTime or Const.MoveTime
end

function CarQuestCar:CalculateSpeed()
    self.speed = self.targetMoveDistanceInScreen / self.moveTime
end

function CarQuestCar:SetStartPosInScreen(pos)
    self.startPosInScreen = pos
end

function CarQuestCar:SetTargetMoveDistanceInScreen(distance)
    self.targetMoveDistanceInScreen = distance
end

function CarQuestCar:SetEndPosInScreen(pos)
    self.endPosInScreen = pos
end

function CarQuestCar:SetSpeed(speed)
    self.speed = speed
end

function CarQuestCar:Update(deltaTime)
    if self.carState == Const.CarStates.moving then
        self:MoveV1(deltaTime)
        self.curMoveTime = self.curMoveTime + deltaTime
        self:CheckFinishStage()
        if self.curMoveTime >= self.moveTime and math.abs(self.curMoveDistanceInScreen) >= math.abs(self.targetMoveDistanceInScreen) then
            log.log("CarQuestCar:Update self.carState = Const.CarStates.movingFinish", self.index)
            self.carState = Const.CarStates.movingFinish
            local bundle = {
                index = self.index,
                playerType = self.playerType,
                score = self.endFuel
            }
            Facade.SendNotification(NotifyName.CarQuest.CarMovingFinish, bundle)
        end
    elseif self.carState == Const.CarStates.starting then
        self:MoveV1(deltaTime)
        self.curMoveTime = self.curMoveTime + deltaTime
        if self.curMoveTime >= self.moveTime and math.abs(self.curMoveDistanceInScreen) >= math.abs(self.targetMoveDistanceInScreen) then
            log.log("CarQuestCar:Update self.carState = Const.CarStates.startingFinish", self.index)
            self.carState = Const.CarStates.startingFinish
            local bundle = {
                index = self.index,
                playerType = self.playerType,
            }
            Facade.SendNotification(NotifyName.CarQuest.CarStartingFinish, bundle)
        end
    elseif self.carState == Const.CarStates.sprinting then
        self:MoveV2(deltaTime)
        self.curMoveTime = self.curMoveTime + deltaTime
        if self.curMoveTime >= self.moveTime then
            self.carState = Const.CarStates.sprintingFinish
            local bundle = {
                index = self.index,
                playerType = self.playerType,
            }
            Facade.SendNotification(NotifyName.CarQuest.CarSprintFinish, bundle)
        end
    end
end

function CarQuestCar:GetLocalPosY()
    local obj = self.go
    if fun.is_not_null(obj) then
        local pos = fun.get_gameobject_pos(obj, true)
        return pos.y
    end

    return 0
end

function CarQuestCar:SetLocalPosY(posY)
    log.log("CarQuestCar:SetLocalPosY ", posY)
    local obj = self.go
    if fun.is_not_null(obj) then
        local pos = fun.get_gameobject_pos(obj, true)
        fun.set_gameobject_pos(obj, pos.x, posY, 0, true)
    end
end

function CarQuestCar:UpdatePos(offsetY)
    local obj = self.go
    if fun.is_not_null(obj) then
        local pos = fun.get_gameobject_pos(obj, true)
        fun.set_gameobject_pos(obj, pos.x, pos.y + offsetY, 0, true)
    end
end

function CarQuestCar:MoveV1(deltaTime)
    if math.abs(self.curMoveDistanceInScreen) >= math.abs(self.targetMoveDistanceInScreen) then
        return
    end

    local offset = deltaTime * self.speed
    if math.abs(self.curMoveDistanceInScreen) + math.abs(offset) >= math.abs(self.targetMoveDistanceInScreen) then
        offset = self.targetMoveDistanceInScreen - self.curMoveDistanceInScreen
    end
    self:UpdatePos(offset)
    self.curMoveDistanceInScreen = self.curMoveDistanceInScreen + offset
end

function CarQuestCar:MoveV2(deltaTime)
    local offset = deltaTime * self.speed
    self:UpdatePos(offset)
    self.curMoveDistanceInScreen = self.curMoveDistanceInScreen + offset
end

function CarQuestCar:StartMove()
    --[[
    self:StopAccelerate()
    if useDirectSwithSpeed then
        self.speed = Const.CarLowSpeed
    else
        self.accelerateAnim = Anim.do_smooth_float_update(0, Const.CarLowSpeed, 1,
            function(num) 
                self.speed = num
            end,
            function()
                self.accelerateAnim = nil
                self.speed = Const.CarLowSpeed
            end
        )
    end
    ]]
    self.carState = Const.CarStates.moving
end

function CarQuestCar:Starting()
    self.carState = Const.CarStates.starting
end

function CarQuestCar:StartFinialSprint()
    self.curMoveTime = 0
    self.carState = Const.CarStates.sprinting
end

function CarQuestCar:MoveSlow()
    self:StopAccelerate()
    if useDirectSwithSpeed then
        self.speed = Const.CarLowSpeed
    else
        self.accelerateAnim = Anim.do_smooth_float_update(self.speed, Const.CarLowSpeed, 1,
            function(num) 
                self.speed = num
            end,
            function()
                self.accelerateAnim = nil
                self.speed = Const.CarLowSpeed
            end
        )
    end
end

function CarQuestCar:MoveFast()
    self:StopAccelerate()
    if useDirectSwithSpeed then
        self.speed = Const.CarHighSpeed
    else
        self.accelerateAnim = Anim.do_smooth_float_update(self.speed, Const.CarHighSpeed, 1,
            function(num) 
                self.speed = num
            end,
            function()
                self.accelerateAnim = nil
                self.speed = Const.CarHighSpeed
            end
        )
    end
end

function CarQuestCar:StopAccelerate()
    if self.accelerateAnim then 
        self.accelerateAnim:Kill()
        self.accelerateAnim = nil
    end
end

function CarQuestCar:SetFuel(num)
    local numText
    if num >= 100000 then
        numText = fun.format_number(num)
    else
        numText = tostring(num)
    end

    if #numText <= 2 then
        self.bubbleRect.sizeDelta = Vector2.New(108, 100)
    else
        self.bubbleRect.sizeDelta = Vector2.New(108 + (#numText - 2) * 30, 100)
    end

    self.txtNum.text = numText
end

function CarQuestCar:PlayAnima(action, cb)
    if self.grade == Const.EnmuCarGrade.high then
        action = action .. "gaoji"
    end

    local clipNameIdx
    if self.playerType == Const.EnmuPlayerType.myself then
        clipNameIdx = 3
    else
        clipNameIdx = 2
    end

    AnimatorPlayHelper.Play(self.anima, {CarAnimConfig[action][1], CarAnimConfig[action][clipNameIdx]}, false,
        function() 
            if cb then
                cb()
            end
        end
    )
end

function CarQuestCar:PlayIdleAnima()
    self:PlayAnima("idle")
end

function CarQuestCar:PlayStopAnima()
    self:PlayAnima("stop")
end

function CarQuestCar:PlaySprintAnima()
    self:PlayAnima("act")
end

function CarQuestCar:PlayUpgradeAnima()
    self:PlayAnima("change")
end

function CarQuestCar:TryStartFuleUp()
    if self.playerType == Const.EnmuPlayerType.myself then
        local list = ModelList.CarQuestModel:GetOilDrumCollectRecord()
        if list and #list > 0 then
            self:StartFuleUp(list)
        else
            self:FinishFuleUp(true)
        end
        ModelList.CarQuestModel:CleanOilDrumCollectRecord()
    end
end

function CarQuestCar:StartFuleUp(list)
    local idxs = {}
    for i, v in ipairs(list) do
        local item = Csv.GetData("item", v.id)
        local level = item.level
        local txtGo = self["Text" .. level]
        if fun.is_not_null(txtGo) then
            txtGo.text = v.value
        end
        table.insert(idxs, level)
    end

    self.txtTotal.text = (self.endFuel - self.startFuel)

    local animName = "act" 
    if #idxs <= 2 then
        for i, v in ipairs(idxs) do
            animName = animName .. v
        end
    else
        animName = "act0"
    end

    self:PlayFuleUpAnima(animName)
end

function CarQuestCar:PlayFuleUpAnima(action)
    if CarFuleUpAnimConfig[action] then
        fun.set_active(self.bubble_jiayou, true)
        UISound.play("racingoil")
        AnimatorPlayHelper.Play(self.animaFuleUp, {CarFuleUpAnimConfig[action][1], CarFuleUpAnimConfig[action][2]}, false,
            function()
                self:FinishFuleUp()
            end
        )
    else
        self:FinishFuleUp()
    end
end

function CarQuestCar:FinishFuleUp(isQuick)
    fun.set_active(self.bubble_jiayou, false)
    if isQuick then
        Facade.SendNotification(NotifyName.CarQuest.FuelUpFinish)
    else
        --[[现在不用等了
        self.view:register_invoke(function()
            Facade.SendNotification(NotifyName.CarQuest.FuelUpFinish)
        end, 1.5)
        --]]
        Facade.SendNotification(NotifyName.CarQuest.FuelUpFinish)
    end    
end

function CarQuestCar:CheckFinishStage()
    local curStageIdx = self.view:GetCurStageIdx()
    if not self.stageFinishRecord[curStageIdx] then
        local posY1 = self:GetLocalPosY()
        local posY2 = self.view:GetZebraStripesPos()
        local targetFuel = self.raceConfig[curStageIdx][3]
        if posY1 + self.view:GetScreenHeight() / 2 + 10 >= posY2 and self.endFuel >= targetFuel then
            log.log("CarQuestCar:CheckFinishStage, ", self.index, curStageIdx, posY1, posY2)
            self.stageFinishRecord[curStageIdx] = true

            local firstGetter = self.view:GetFirstRewardGetter(curStageIdx)
            local isFirst = false
            if firstGetter then
                isFirst = self.details.uid == firstGetter.uid
            end
            local bundle = {}
            bundle.index = self.index
            bundle.curStageIdx = curStageIdx
            bundle.playerType = self.playerType
            bundle.isFirst = isFirst
            bundle.firstGetter = firstGetter
            Facade.SendNotification(NotifyName.CarQuest.FinishOneStage, bundle)
        end
    end
end

function CarQuestCar:GetGameObject()
    return self.go
end

function CarQuestCar:ShowFuleBubble()
    fun.set_active(self.bubble, true)
end

function CarQuestCar:HideFuleBubble()
    fun.set_active(self.bubble, false)
end

function CarQuestCar:ShowStartFuel()
    self:SetFuel(self.startFuel)
end

function CarQuestCar:ShowEndFuel()
    self:SetFuel(self.endFuel)
end

--设置消息通知
this.NotifyEnhanceList =
{
    --{notifyName = NotifyName.ZipResDownload.StartDownload, func = this.OnStartDownload},
}

return this