local VolcanoAStar = require("Combat.BattleLogic.Volcano.VolcanoAStar")

---寻路移动
local VolcanoMoveMachine = {}
local this = VolcanoMoveMachine

local private = {}
local MoveDirection = { Left = 1, Right = 2, Up = 3, Down = 4 }
local NormalSpeed = 2
local QuickSpeed = 2

function this:Init(cardID, cellIndex)
    self.model = ModelList.BattleModel:GetCurrModel()
    private.InitMoveCtrl(self, cardID, cellIndex)
    self.isGainedBySkill = false
    self.isGainedByMove = false
    self.moveTimeTemp = 0
end

function this:Start()
    self:start_x_update()
    self.update_x_enabled = true
end

function this:Pause(isPause)
    self.update_x_enabled = not isPause
end

function this:Stop()
    if self.update_x_handler then
        UpdateBeat:RemoveListener(self.update_x_handler)
        self.update_x_handler = nil
    end
    self.update_x_enabled = false
end

function this:start_x_update()
    self:Stop()
    self.update = xp_call(function()
        self:on_x_update()
    end)
    self.update_x_handler = UpdateBeat:CreateListener(self.update)
    UpdateBeat:AddListener(self.update_x_handler)
end

function this:on_x_update()
    if self.update_x_enabled then
        if #self.movePath > 0 then
            self:OnMoving()
        end
    end
end

--通过bingo技能获得龙时，设置数据
function this:OnGetBySkill()
    self.isGainedBySkill = true
end 

--是否可以到达火山
function this:CanMoveToEnd()
    if self.isGainedBySkill or self.isGainedByMove then
        return false
    end

    --限制每秒检测一次
    self.lastCheckTime = self.lastCheckTime or os.time()
    if os.time() - self.lastCheckTime < 1 then
        return
    end

    local aStar = CreateInstance_(VolcanoAStar)
    local path = aStar:FindPath(self, self.cardID, self.curStayCell, 13)
    if GetTableLength(path) > 0 then
        return true
    end
    
    return false
end

function this:IsMoving()
    if self.isGainedBySkill or self.isGainedByMove then
        return false
    end
    
    local path = self.movePath
    return path and #path > 0
end

--移动中，做表现
function this:OnMoving()
    local node = self.movePath[1]
    local cellData = self.model:GetRoundData(self.cardID, node)
    local nodeCellCtrl = cellData:GetCellReferScript("bg_tip").transform

    --左右转向
    local turnDir = private.GetNextNodeDir(self, node)
    if turnDir == MoveDirection.Left or turnDir == MoveDirection.Right then
        private.TurnMoveCtrlDirection(self, turnDir)
    end

    --移动对象，做平移
    local moveItemCtrl = self.moveCtrl
    --local dir = (nodeCellCtrl.position - moveItemCtrl.position).normalized
    local moveSpeed = NormalSpeed
    if ModelList.BattleModel:IsRocket() then
        moveSpeed = QuickSpeed
    end
    --if turnDir == MoveDirection.Right then
    --    moveSpeed = -moveSpeed
    --end
    --moveItemCtrl:Translate(dir * moveSpeed * Time.deltaTime)
    
    --插值移动
    self.moveTimeTemp = self.moveTimeTemp + UnityEngine.Time.deltaTime
    local lerp = self.moveTimeTemp / moveSpeed
    lerp = Mathf.Clamp(lerp, 0 , 1)
    moveItemCtrl.position = Vector3.Lerp(moveItemCtrl.position, nodeCellCtrl.position, lerp)
    
    
    --上下移动
    if turnDir == MoveDirection.Up then
        self.moveCtrlAnimator:SetInteger("State", 1)
    elseif turnDir == MoveDirection.Down then
        self.moveCtrlAnimator:SetInteger("State", 2)
    else
        self.moveCtrlAnimator:SetInteger("State", 6)
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
        self.curStayCell = node
        self.moveTimeTemp = 0
        table.remove(self.movePath, 1)

        --移动结束，已到达目标点
        if GetTableLength(self.movePath) == 0 then
            self.moveCtrlAnimator:SetInteger("State", 5)
            self:OnMoveEnd(node)
        else
            if self:CheckMovePath() then
                self.movePath = {}
            end
        end
    end
end

--检查将要移动到的下一个格子是否会遇到其他龙
function this:CheckMovePath(node)
    local checkNode = node or self.movePath[1]
    local dragonController = self.model.dragonController
    local ret = dragonController:CheckCellIsInDragonPath(self.cardID, checkNode, self.dragonType)
    return ret
end

--移动结束，获得奖励，达成bingo
function this:OnMoveEnd(endCellIndex)
    UISound.stop_loop("lavadragon")
    
    --动画
    local anima = self.moveCtrlAnimator
    anima:Play("idle")

    if endCellIndex == 13 then
        self.isGainedByMove = true
        
        local cellData = self.model:GetRoundData(self.cardID, self.cellIndex)
        --获得奖励
        if not cellData.isGained then
            --没获取时才能获得
            Event.Brocast(EventName.Event_Collect_Item_By_Sign, self.cardID, self.cellIndex)
            cellData.isGained = true
            cellData.isMoveTarget = false
        end

        local dragonController = self.model.dragonController
        dragonController:OnDragonMoveEnd(self.cardID, self.dragonType)
        
        self:Stop()
        return
    end

    self.forbidCalculatePath = true
    coroutine.start(function()
        coroutine.wait(0.12)
        --停止转向判断
        local rowTemp = math.floor((endCellIndex - 1) / 5) + 1
        if rowTemp == 1 then
            --右转
            private.TurnMoveCtrlDirection(self, MoveDirection.Right, true)
        elseif rowTemp == 5 then
            --左转
            private.TurnMoveCtrlDirection(self, MoveDirection.Left, true)
        end
        
        self.forbidCalculatePath = false
        
        coroutine.wait(0.38)
        
        local dragonController = self.model.dragonController
        dragonController:OnDragonMoveEnd(self.cardID, self.dragonType)
        
        if not self:IsMoving() then
            --重新计算路径
            self:ReCalculatePath()
        end
    end)
end

--选择新的路径
--行驶的判定优先级为：是否通路>开出的先后时间>距离远近>格子位置从小到大
function this:ReCalculatePath()
    if self.isGainedBySkill or self.isGainedByMove then
        return
    end
    
    if not self.update_x_enabled or self.forbidCalculatePath then
        return
    end
    
    local targetIndex = 13   --火山位置
    local aStar = CreateInstance_(VolcanoAStar)
    local path, passedNodes = aStar:FindPath(self, self.cardID, self.curStayCell, targetIndex)
    if GetTableLength(path) > 0 then
        log.g(string.format("卡牌:%s,龙:%s,寻路到火山路径:%s", self.cardID, self.cellIndex, table.print(path)))
        
        --找到去火山的路
        self:SetPath(path)
        
        --标识龙即将被获得
        local cellData = self.model:GetRoundData(self.cardID, self.cellIndex)
        if cellData then
            cellData.isMoveTarget = true
        end
        return
    end
    
    --没有去火山的路，寻找距离火山最近的点
    table.sort(passedNodes, function(a, b)
        --路径长度
        if a.h ~= b.h then return a.h < b.h end
        --格子位置
        return a.index < b.index
    end)
    local retNode = passedNodes[1]
    if retNode then
        --是当前所在的点，不用移动
        if retNode.index == self.curStayCell then
            log.g(string.format("卡牌:%s,龙:%s,重新寻路结果：是当前所在的点，不用移动。", self.cardID, self.cellIndex))
            
            --需要做转向
            if retNode.targetIndex then
                local nowColumn = math.floor((self.curStayCell - 1) / 5) + 1
                local targetColumn = math.floor((retNode.targetIndex - 1) / 5) + 1
                if nowColumn ~= targetColumn then
                    local turnDir = targetColumn > nowColumn and MoveDirection.Right or MoveDirection.Left
                    private.TurnMoveCtrlDirection(self, turnDir)
                end
            end
            return
        end
        
        path = aStar:FindPath(self, self.cardID, self.curStayCell, retNode.index)
        if GetTableLength(path) > 0 then
            --去距离火山最近的点
            log.g(string.format("卡牌:%s,龙:%s,重新寻路结果：去距离火山最近的点%s,路径:%s", self.cardID, self.cellIndex, retNode.index, table.print(path)))
            self:SetPath(path)
        end
    end
end

--设置新的移动路径
function this:SetPath(path)
    if self:CheckMovePath(path[1]) then
        self.movePath = {}
        return
    end
    
    self.movePath = path
    self:Pause(true)
    self.forbidCalculatePath = true
    
    --起步动画
    self.moveCtrlAnimator:SetInteger("State", 3)
    coroutine.start(function()
        coroutine.wait(0.2)
        UISound.play_loop("lavadragon")
        coroutine.wait(0.2)
        
        --转向
        local nextNode = path[1]
        local dir = private.GetNextNodeDir(self, nextNode)
        if dir == MoveDirection.Left or dir == MoveDirection.Right then
            private.TurnMoveCtrlDirection(self, dir)
        end
        
        self.forbidCalculatePath = false
        self:Pause(false)
    end)
end

--检查龙是否可以移动到火山(不考虑其他龙的阻挡)
function this:CheckHavePathToEnd()
    local targetIndex = 13   --火山位置
    local aStar = CreateInstance_(VolcanoAStar)
    local path = aStar:FindPath(self, self.cardID, self.curStayCell, targetIndex, true)
    if GetTableLength(path) > 0 then
        return true
    end
    
    return false
end

--------------------------------------------------------------------------------
function private.InitMoveCtrl(self, cardID, cellIndex)
    self.cardID = cardID
    self.cellIndex = cellIndex
    
    local cellData = self.model:GetRoundData(cardID, cellIndex)
    local treasureItems = cellData:Treasure2Item()
    local data = Csv.GetData("item", treasureItems.id)
    local dragonType = data.result[2]
    self.dragonType = dragonType
    
    local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
    local view = cardView:GetCard(cardID)
    self.moveCtrl = view.dragonCtrlList[dragonType].transform
    self.moveCtrlAnimator = fun.get_animator(self.moveCtrl)
    self.movePath = {}
    self.curStayCell = cellIndex
    --self.curTurnDir = MoveDirection.Left
    self.forbidCalculatePath = false

    local rowTemp = math.floor((13 - 1) / 5) + 1
    local rowIndex = math.floor((cellIndex - 1) / 5) + 1
    if rowIndex > rowTemp then
        private.TurnMoveCtrlDirection(self, MoveDirection.Left, true)
    elseif rowIndex < rowTemp then
        private.TurnMoveCtrlDirection(self, MoveDirection.Right, true)
    end
end

function private.TurnMoveCtrlDirection(self, dir, ignoreEffect)
    local effect = fun.get_child(self.moveCtrl, 1)
    if fun.is_null(effect) then
        return
    end

    if self.curTurnDir ~= dir then
        fun.set_active(effect, false)
        --做转向
        if dir == MoveDirection.Right then
            fun.set_gameobject_rot(self.moveCtrl, 0, 180, 0, true)
        elseif dir == MoveDirection.Left then
            fun.set_gameobject_rot(self.moveCtrl, 0, 0, 0, true)
        end
        if not ignoreEffect then
            fun.set_active(effect, true)
        end
        self.curTurnDir = dir
    end
end

function private.GetNextNodeDir(self, node)
    local curCell = self.curStayCell
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

return this