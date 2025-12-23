require("Combat/BaseMachine")
local PirateShipAStar = require("Combat.BattleLogic.PirateShip.PirateShipAStar")

---  新绿头人寻路移动
local PirateShipMoveMachine = {}
local this = PirateShipMoveMachine
this.normalSpeed = 2
this.quickSpeed = 2
this.curStayCell = {}

local private = {}
--宝箱队列                                                                               
local treasureQueue = {}
local MoveDirection = { Left = 1, Right = 2, Up = 3, Down = 4 }

function this:Start()
    treasureQueue = {}
    this.model = ModelList.BattleModel:GetCurrModel()
    private.InitMoveCtrl(this)
    this.update_x_enabled = true
    this:start_x_update()
    this.moveTimeTemp = 0
end

function this:Pause(isPause)
    this.update_x_enabled = isPause
end

function this:Stop()
    this:stop_x_update()
    treasureQueue = {}
end

function this:stop_x_update()
    if not this.update_x_enabled then
        return
    end
    if this.update_x_handler then
        UpdateBeat:RemoveListener(this.update_x_handler)
        this.update_x_handler = nil
    end
end

function this:start_x_update()
    if not this.update_x_enabled then
        return
    end
    this:stop_x_update()

    this.update = xp_call(function()
        this:on_x_update()
    end)
    this.update_x_handler = UpdateBeat:CreateListener(this.update)
    UpdateBeat:AddListener(this.update_x_handler)
end

function this:on_x_update()
    table.each(this.movePath, function(pathList, cardID)
        if #pathList > 0 then
            this:OnMoving(cardID, pathList)
        end
    end)
end
                                                                                              
function this:HaveMovingCard()
    local ret = false
    table.each(this.movePath, function(pathList, cardID)
        ret = ret or #pathList > 0
    end)
    return ret
end

--是否可以继续获得宝箱
function this:HaveMoveTarget(cardId)
    if not cardId then
        --限制每秒检测一次
        this.lastCheckTime = this.lastCheckTime or os.time()
        if os.time() - this.lastCheckTime < 1 then
            return
        end
    end

    local ret = false
    table.each(treasureQueue, function(cellIndexList, cardID)
        if cardId == cardID then
            local curStayCell = this.curStayCell[cardID]
            table.each(cellIndexList, function(v)
                local cellData = this.model:GetRoundData(cardID, v.cellIndex)
                if cellData and not cellData.isGained then
                    local aStar = CreateInstance_(PirateShipAStar)
                    local path = aStar:FindPath(cardID, curStayCell, v.cellIndex)
                    if GetTableLength(path) > 0 then
                        ret = true
                    end
                end
            end)
        end
    end)
    return ret
end

function this:IsMoving(cardID)
    local path = this.movePath[cardID]
    return path and #path > 0
end

--移动中，做表现
function this:OnMoving(cardID, pathList)
    local node = pathList[1]
    local cellData = this.model:GetRoundData(cardID, node)
    if not cellData then
        table.remove(pathList, 1)
        return
    end
    
    local bgCtrl = cellData:GetCellReferScript("bg_tip")
    if not bgCtrl then
        table.remove(pathList, 1)
        return
    end
    
    local nodeCellCtrl = bgCtrl.transform

    --左右转向
    local turnDir = private.GetNextNodeDir(this, cardID, node)
    if turnDir == MoveDirection.Left or turnDir == MoveDirection.Right then
        private.TurnMoveCtrlDirection(this, cardID, turnDir)
    end

    --移动对象，做平移
    local moveItemCtrl = this.moveCtrlList[cardID]
    --local dir = (nodeCellCtrl.position - moveItemCtrl.position).normalized
    local moveSpeed = this.normalSpeed
    if ModelList.BattleModel:IsRocket() then
        moveSpeed = this.quickSpeed
    end
    --if turnDir == MoveDirection.Right then
    --    moveSpeed = -moveSpeed
    --end
    --moveItemCtrl:Translate(dir * moveSpeed * Time.deltaTime)
    
    --插值移动
    this.moveTimeTemp = this.moveTimeTemp + UnityEngine.Time.deltaTime
    local lerp = this.moveTimeTemp / moveSpeed
    lerp = Mathf.Clamp(lerp, 0 , 1)
    moveItemCtrl.position = Vector3.Lerp(moveItemCtrl.position, nodeCellCtrl.position, lerp)
    

    --上下移动
    if turnDir == MoveDirection.Up then
        private.SetAnimatorInteger(this, cardID, 1)
    elseif turnDir == MoveDirection.Down then
        private.SetAnimatorInteger(this, cardID, 2)
    else
        private.SetAnimatorInteger(this, cardID, 6)
    end

    --是否到达目标点
    local checkX = math.abs(moveItemCtrl.position.x - nodeCellCtrl.position.x) < 0.04
    if checkX then
        fun.set_same_position_x(moveItemCtrl, nodeCellCtrl)
    end
    local checkY = math.abs(moveItemCtrl.position.y - nodeCellCtrl.position.y) < 0.04
    if checkY then
        fun.set_same_position_y(moveItemCtrl, nodeCellCtrl)
    end
    if checkX and checkY then
        moveItemCtrl.position = nodeCellCtrl.position
        this.curStayCell[cardID] = node
        this.moveTimeTemp = 0
        table.remove(pathList, 1)

        --移动结束，已到达目标点
        if GetTableLength(pathList) == 0 then
            private.SetAnimatorInteger(this, cardID, 5)
            this:OnMoveEnd(cardID, node)
        end
    end
end

--移动结束，获得奖励，达成bingo
function this:OnMoveEnd(cardID, endCellIndex)
    UISound.stop_loop("pirateship")
    
    --动画
    local anima = this.moveCtrlAnimatorList[cardID]
    anima:Play("idle")

    local cellData = this.model:GetRoundData(cardID, endCellIndex)
    --获得奖励
    if not cellData.isGained then
        --没获取时才能获得
        Event.Brocast(EventName.Event_Collect_Item_By_Sign, cardID, endCellIndex)
        cellData.isGained = true
        cellData.isMoveTarget = false

        --道具消失
        local bingoView = ModelList.BattleModel:GetCurrBattleView()
        local cardView = bingoView and bingoView.cardView
        if cardView then
            local effectList = cardView:GetCellBgEffect(cardID, endCellIndex)
            table.each(effectList, function(effect)
                fun.set_active(effect, false)
            end)
        end
    end

    this.forbidCalculatePath[cardID] = true
    coroutine.start(function()
        coroutine.wait(0.12)
        --停止转向判断
        local rowTemp = math.floor((endCellIndex - 1) / 5) + 1
        if rowTemp == 1 then
            --右转
            private.TurnMoveCtrlDirection(this, cardID, MoveDirection.Right, true)
        elseif rowTemp == 5 then
            --左转
            private.TurnMoveCtrlDirection(this, cardID, MoveDirection.Left, true)
        end
        
        this.forbidCalculatePath[cardID] = false
        
        coroutine.wait(0.38)
        if not this:IsMoving(cardID) then
            log.g(string.format("[PirateShipLog] 卡牌:%s,移动到达目标点：%s,重新寻路。", cardID, endCellIndex))
            --重新计算路径
            this:ReCalculatePath(cardID)
        end
    end)
end

---有格子盖章后，重新规划路线
function this:OnCellSigned(cardID, cellIndex)
    if not this.model then
        return
    end

    cardID = tonumber(cardID)
    local cellData = this.model:GetRoundData(cardID, cellIndex)
    if not cellData then
        return
    end
    
    local treasureItems = cellData:Treasure2Item()
    if treasureItems then
        local data = Csv.GetData("new_item", treasureItems.id)
        --是宝箱
        if 11 == data.result[1] then
            treasureQueue[cardID] = treasureQueue[cardID] or {}
            table.insert(treasureQueue[cardID], {
                cellIndex = cellIndex,
                time = os.time()
            })

            log.g(string.format("[PirateShipLog] 卡牌:%s,格子发现宝箱:%s,当前宝箱队列:%s", cardID, cellIndex, table.print(treasureQueue[cardID])))
        end
    end

    if not this.forbidCalculatePath[cardID] and not this:IsMoving(cardID) then
        log.g(string.format("[PirateShipLog] 卡牌:%s,有格子盖章:%s,重新寻路。", cardID, cellIndex))
        this:ReCalculatePath(cardID)
    end
end

--选择新的路径
--行驶的判定优先级为：是否通路>开出的先后时间>距离远近>格子位置从小到大
function this:ReCalculatePath(cardID)
    if this.forbidCalculatePath[cardID] then
        return
    end

    local retPath, retCellIndex
    --可行走的路，可行走的点
    local validPathList, passedNodesList, isAllGained = {}, {}, true
    local curStayCell = this.curStayCell[cardID] or 13

    --先寻找可以达到宝箱的路
    table.each(treasureQueue[cardID], function(v)
        local cellIndex = v.cellIndex
        local cellData = this.model:GetRoundData(cardID, cellIndex)
        if cellData and not cellData.isGained then
            isAllGained = false
            local aStar = CreateInstance_(PirateShipAStar)
            local path, passedNodes = aStar:FindPath(cardID, curStayCell, cellIndex)
            if GetTableLength(path) > 0 then
                log.g(string.format("[PirateShipLog] 卡牌:%s,寻路到宝箱:%s,路径:%s", cardID, cellIndex, table.print(path)))
                table.insert(validPathList, {
                    path = path,
                    cellIndex = cellIndex,
                    time = v.time,
                })
            end
            passedNodesList[cellIndex] = passedNodes
        end
    end)

    if #validPathList > 0 then
        table.sort(validPathList, function(a, b)
            --距离远近
            if #a.path ~= #b.path then
                return #a.path < #b.path
            end
            --开出的先后时间
            if math.abs(a.time - b.time) > 1 then
                return a.time < b.time
            end
            --格子位置
            return a.cellIndex < b.cellIndex
        end)
        retPath = validPathList[1].path
        retCellIndex = validPathList[1].cellIndex
    end

    if GetTableLength(retPath) > 0 then
        log.g(string.format("[PirateShipLog] 卡牌:%s,重新寻路结果：寻路到宝箱%s,路径:%s", cardID, retCellIndex, table.print(retPath)))
        --找到取宝箱的路
        this:SetPath(cardID, retPath)
        --标识宝箱已经可以被获取
        local cellData = this.model:GetRoundData(cardID, retCellIndex)
        if cellData then
            cellData.isMoveTarget = true
        end
        return
    end

    --看到的宝箱都已经获得
    if isAllGained then
        log.g(string.format("[PirateShipLog] 卡牌:%s,重新寻路结果：看到的宝箱都已经获得,原地不动。", cardID))
        return
    end

    --没有去宝箱的路
    --再寻找距离宝箱最近的点路
    local nodes, retNode = {}
    table.each(passedNodesList, function(nodeList)
        --没找到到达终点的路径，找最近的格子
        table.each(nodeList, function(node)
            table.insert(nodes, node)
        end)
    end)
    table.sort(nodes, function(a, b)
        --路径长度
        if a.h ~= b.h then return a.h < b.h end
        --路径高度距离
        --if a.hw[1] ~= b.hw[1] then return a.hw[1] < b.hw[1] end
        --路径宽度距离
        --if a.hw[2] ~= b.hw[2] then return a.hw[2] < b.hw[2] end
        --格子位置
        return a.index < b.index
    end)
    retNode = nodes[1]
    if retNode then
        if retNode.index == curStayCell then
            log.g(string.format("[PirateShipLog] 卡牌:%s,重新寻路结果：是当前所在的点，不用移动。", cardID))
            --是当前所在的点，不用移动
            
            --当时需要做转向
            if retNode.targetIndex then
                local nowColumn = math.floor((curStayCell - 1) / 5) + 1
                local targetColumn = math.floor((retNode.targetIndex - 1) / 5) + 1
                if nowColumn ~= targetColumn then
                    local turnDir = targetColumn > nowColumn and MoveDirection.Right or MoveDirection.Left
                    private.TurnMoveCtrlDirection(this, cardID, turnDir)
                end
            end
            return
        end

        local aStar = CreateInstance_(PirateShipAStar)
        local path = aStar:FindPath(cardID, curStayCell, retNode.index)
        if GetTableLength(path) > 0 then
            log.g(string.format("[PirateShipLog] 卡牌:%s,重新寻路结果：去距离宝箱最近的点%s,路径:%s", cardID, retNode.index, table.print(path)))
            --去距离宝箱最近的点
            this:SetPath(cardID, path)
        end
    end
end

--设置新的移动路径
function this:SetPath(cardID, path)
    this.forbidCalculatePath[cardID] = true
    
    --起步动画
    private.SetAnimatorInteger(this, cardID, 3)
    coroutine.start(function()
        coroutine.wait(0.2)
        UISound.play_loop("pirateship")
        if not this.haveTriggerFistSound then
            this.haveTriggerFistSound = true
            UISound.play("pirateweighanchor")
        end
        
        coroutine.wait(0.2)
        
        --转向
        local nextNode = path[1]
        local dir = private.GetNextNodeDir(this, cardID, nextNode)
        if dir == MoveDirection.Left or dir == MoveDirection.Right then
            private.TurnMoveCtrlDirection(this, cardID, dir)
        end

        this.movePath[cardID] = path
        this.forbidCalculatePath[cardID] = false
    end)
end

--------------------------------------------------------------------------------
function private.InitMoveCtrl(self)
    self.movePath = {}
    self.moveCtrlList = {}
    self.moveCtrlAnimatorList = {}
    self.curStayCell = {}
    self.curTurnDir = {}
    self.forbidCalculatePath = {}
    self.haveTriggerFistSound = false

    local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
    local cardCount = self.model:GetCardCount()
    for cardID = 1, cardCount do
        local view = cardView:GetCard(cardID)
        local moveItemCtrl = view.moveItemCtrl
        self.moveCtrlList[cardID] = moveItemCtrl.transform
        self.moveCtrlAnimatorList[cardID] = moveItemCtrl
        self.movePath[cardID] = {}
        self.curStayCell[cardID] = 13
        self.curTurnDir[cardID] = MoveDirection.Right
        self.forbidCalculatePath[cardID] = false
    end
end

function private.TurnMoveCtrlDirection(self, cardID, dir, ignoreEffect)
    local moveItemCtrl = this.moveCtrlList[cardID]
    local effect = fun.get_child(moveItemCtrl, 1)
    if fun.is_null(effect) then
        return
    end

    if self.curTurnDir[cardID] ~= dir then
        fun.set_active(effect, false)
        --做转向
        if dir == MoveDirection.Right then
            fun.set_gameobject_rot(moveItemCtrl, 0, 180, 0, true)
        elseif dir == MoveDirection.Left then
            fun.set_gameobject_rot(moveItemCtrl, 0, 0, 0, true)
        end
        if not ignoreEffect then
            fun.set_active(effect, true)
        end
        self.curTurnDir[cardID] = dir
    end
end

function private.GetNextNodeDir(self, cardID, node)
    local curCell = self.curStayCell[cardID]
    local diff = node - curCell
    if diff == -1 then
        return MoveDirection.Up
    elseif diff == 1 then
        return MoveDirection.Down
    elseif diff == -5 then
        return MoveDirection.Left
    elseif diff == 5 then
        return MoveDirection.Right
    end
end

function private.SetAnimatorInteger(self, cardID, integer)
    local anima = self.moveCtrlAnimatorList[cardID]
    anima:SetInteger("State", integer)
end

return this