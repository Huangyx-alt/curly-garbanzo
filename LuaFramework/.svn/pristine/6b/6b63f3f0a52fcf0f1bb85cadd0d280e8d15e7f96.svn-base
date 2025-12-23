local Const = require "View/CarQuest/CarQuestConst"
local CarQuestCar = require "View/CarQuest/CarQuestCar"
local CarQuestCarMgr = {}

function CarQuestCarMgr:Init(view, rankData)
    self.view = view
    self.carList = {}
    self.rankData = rankData
end

function CarQuestCarMgr:CreateAllCars(enemyCar, selfCar, rootNode)
    local itemGoList = {}
    for i = 1, Const.TrackCount do
        local item
        local itemGo
        local config = nil
        if i == Const.MyTrackNum then
            item = self:CreateCar(selfCar, i, Const.EnmuPlayerType.myself, config)
            itemGo = fun.get_instance(selfCar)
        else
            item = self:CreateCar(enemyCar, i, Const.EnmuPlayerType.enemy, config)
            itemGo = fun.get_instance(enemyCar)
        end
        table.insert(self.carList, item)
        table.insert(itemGoList, itemGo)
    end

    
    for i = 1, Const.TrackCount do
        local item = self.carList[i]
        local itemGo = itemGoList[i]
        if itemGo then
            itemGo.transform:SetParent(rootNode.transform)
            itemGo.transform.localScale = Vector3.one
            fun.set_rect_anchored_position(itemGo, (i - (Const.TrackCount + 1) / 2) * Const.TrackWidth, 0)
            fun.set_active(itemGo, true)
            item:SkipLoadShow(itemGo)
        end
    end
    local playerCar = self.carList[Const.MyTrackNum]
    if playerCar and fun.is_not_null(playerCar.go) then
        fun.SetAsLastSibling(playerCar.go)
    end

    -- local cfg = Csv:GetData("contral", Const.ControlId1)
    -- local distance = self.carList[Const.MyTrackNum]:GetTargetMoveDistance()
    -- local screenHeight = self.view:GetScreenHeight()

    -- local baseTime = cfg.content[1][1] or 1
    -- local maxTime = cfg.content[1][2] or 5
    -- local a111 = cfg.content[2][1]
    -- local moveTime =  baseTime + math.floor(distance / screenHeight * 4 / a111)
    -- for i = 1, Const.TrackCount do
    --     local item = self.carList[i]
    --     item:SetMoveTime(moveTime)
    --     item:CalculateSpeed()
    -- end
    self:CalculateCarMovingTime()
end

function CarQuestCarMgr:CalculateCarMovingTime()
    local cfg = Csv.GetData("control", Const.ControlId1)
    local distance = self.carList[Const.MyTrackNum]:GetTargetMoveDistance()
    local screenHeight = self.view:GetScreenHeight()

    local baseTime = cfg.content[1][1] or 1
    local maxTime = cfg.content[1][2] or 5
    local num = cfg.content[2][1]
    local moveTime = baseTime + math.floor(distance / screenHeight * 4 / num)
    if moveTime > maxTime then
        moveTime = maxTime
    end
    self.carMovingTime = moveTime
end

function CarQuestCarMgr:CalculateSpeed()
    for i = 1, Const.TrackCount do
        local item = self.carList[i]
        item:SetMoveTime(self.carMovingTime)
        item:CalculateSpeed()
    end
end

function CarQuestCarMgr:GetCarMovingTime()
    return self.carMovingTime
end

function CarQuestCarMgr:CreateCar(prefab, index, playerType, config)
    local data = {
        index = index,
        playerType = playerType, 
        startFuel = self.rankData[index].lastScore,
        endFuel = self.rankData[index].score,
        gameProps = self.rankData[index].gameProps,
        details = self.rankData[index],
        view = self.view,
        mgr = self
    }

    local item = CarQuestCar:New()
    item:SetData(data)
    return item
end

function CarQuestCarMgr:Update(deltaTime)
    for i = 1, Const.TrackCount do
        local car = self.carList[i]
        car:Update(deltaTime)
    end
end

function CarQuestCarMgr:SetAllCarsPosition(posList)
    for i = 1, Const.TrackCount do
        local car = self.carList[i]
        --car:Update()
        car:SetLocalPosY(posList[i])
    end
end

function CarQuestCarMgr:GetAllCars(posList)
    return self.carList
end

function CarQuestCarMgr:GetPlayerStartPosInRoad()
    return self.carList[Const.MyTrackNum]:GetStartPos()
end

function CarQuestCarMgr:GetPlayerEndPosInRoad()
    return self.carList[Const.MyTrackNum]:GetEndPos()
end

function CarQuestCarMgr:GetPlayerTargetMoveDistanceInRoad()
    return self.carList[Const.MyTrackNum]:GetTargetMoveDistance()
end

function CarQuestCarMgr:GetPlayerCar()
    return self.carList[Const.MyTrackNum]:GetGameObject()
end

function CarQuestCarMgr:StartingAllCars()
    for i = 1, Const.TrackCount do
        local car = self.carList[i]
        local startPos = fun.get_gameobject_pos(self.view.startPos, true)
        local endPos = self.view:GetPlayerCarMovingPos()
        car:SetStartPosInScreen(startPos.y)
        car:SetEndPosInScreen(endPos)
        car:SetTargetMoveDistanceInScreen(endPos - startPos.y)
        car:SetMoveTime(Const.CarStartingTime)
        car:SetSpeed(Const.CarStartingSpeed)
        car:PlayIdleAnima()
        car:Starting()
    end
end

function CarQuestCarMgr:SetAllCarsInStartPoint()
    local startPos = fun.get_gameobject_pos(self.view.startPos, true)
    for i = 1, Const.TrackCount do
        local car = self.carList[i]
        car:SetSpeed(0)
        car:SetLocalPosY(startPos.y)
        car:PlayStopAnima()
    end
end

function CarQuestCarMgr:StartFuelUp()
    local car = self.carList[Const.MyTrackNum]
    car:TryStartFuleUp()
end

function CarQuestCarMgr:StartMoveAllCars()
    for i = 1, Const.TrackCount do
        local car = self.carList[i]
        car:PlaySprintAnima()
        if car:HasFinishRaceBefore() then
            car:NotifyFinishRaceBefore()
        else
            car:StartMove()
        end
    end
end

function CarQuestCarMgr:StopMove(idx)
    local car = self.carList[idx]
    car:PlayIdleAnima()
end

function CarQuestCarMgr:StartFinialSprint(idx)
    local car = self.carList[idx]
    car:SetMoveTime(Const.CarSprintTime)
    car:SetSpeed(Const.CarSprintSpeed)
    car:PlaySprintAnima()
    car:StartFinialSprint()
end

function CarQuestCarMgr:AllCarPlayIdle()
    for i = 1, Const.TrackCount do
        local car = self.carList[i]
        car:PlayIdleAnima()
    end
end


function CarQuestCarMgr:ShowAllCarInEndPos()
    for i = 1, Const.TrackCount do
        local car = self.carList[i]
        car:ShowInEndPos()
    end
end

function CarQuestCarMgr:UpgradeCar(idx)
    local car = self.carList[idx]
    if car then
        car:SetGrade(Const.EnmuCarGrade.high)
        car:PlayUpgradeAnima()
    end    
end

function CarQuestCarMgr:UpgradePlayerCar()
    self:UpgradeCar(Const.MyTrackNum)
end

function CarQuestCarMgr:ShowFuleBubble()
    for i = 1, Const.TrackCount do
        local car = self.carList[i]
        car:ShowFuleBubble()
    end
end

function CarQuestCarMgr:HideFuleBubble()
    for i = 1, Const.TrackCount do
        local car = self.carList[i]
        car:HideFuleBubble()
    end
end

function CarQuestCarMgr:ShowStartFuel()
    for i = 1, Const.TrackCount do
        local car = self.carList[i]
        car:ShowStartFuel()
    end
end

function CarQuestCarMgr:ShowEndFuel()
    for i = 1, Const.TrackCount do
        local car = self.carList[i]
        car:ShowEndFuel()
    end
end

function CarQuestCarMgr:GetCarCurPosInScreen(idx)
    local car = self.carList[idx]
    return car:GetCurPosInScreen()
end

return CarQuestCarMgr