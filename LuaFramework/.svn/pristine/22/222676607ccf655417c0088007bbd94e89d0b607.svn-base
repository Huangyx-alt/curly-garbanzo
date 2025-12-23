---A*寻路算法
local VolcanoAStar = Clazz(ClazzBase, "VolcanoAStar")
local this = VolcanoAStar
local private = {}

local dirOrder = { -1, 5, 1, -5 } --上、右、下、左

function this:FindPath(dragon, cardID, startIndex, endIndex, ignoreOtherDragonPos)
    self.openList = {}      --准备处理的格子
    self.closeList = {}     --处理完成的格子

    self.dragon = dragon
    self.cardID = cardID
    self.startIndex = startIndex
    self.endIndex = endIndex
    self.ignoreOtherDragonPos = ignoreOtherDragonPos

    self.endNode = nil --路径中最后一个点

    local h, w = private.GetCellH(self, startIndex)
    self.startNode = private.CreateNode(self, self.startIndex, nil, 0, h + w, { h, w })
    table.insert(self.openList, self.startNode)

    self.model = ModelList.BattleModel:GetCurrModel()

    self:Find()

    local pathCellList = private.GetPathByNode(self, self.endNode)
    --起点不加入
    local length = GetTableLength(pathCellList)
    if length > 0 and pathCellList[length] == startIndex then
        table.remove(pathCellList, length)
    end
    pathCellList = table.reverse(pathCellList)
    return pathCellList, self.closeList
end

function this:GetPath()
    if self.endNode == nil then
        --没找到到达终点的路径，取最近的格子
        table.sort(self.closeList, function(a, b)
            if a.f ~= b.f then
                return a.f < b.f
            end
            if a.h ~= b.h then
                return a.h < b.h
            end
        end)
        --有多个最近的格子，按方向取
        local tempNode = self.closeList[1]
        local sameHNodes = table.findAll(self.closeList, function(k, node)
            return node.h == tempNode.h
        end)
        if #sameHNodes > 1 then
            local pathList = {}
            table.each(sameHNodes, function(node)
                local path = private.GetPathByNode(self, node)
                local secondMoveToIndex = path[#path]
                pathList[tostring(secondMoveToIndex - self.startIndex)] = path
            end)
            for i = 1, #dirOrder do
                local temp = dirOrder[i]
                if pathList[tostring(temp)] then
                    return pathList[tostring(temp)]
                end
            end
        else
            return private.GetPathByNode(self, tempNode)
        end
    else
        return private.GetPathByNode(self, self.endNode)
    end
end

function this:Find()
    local temp = 1
    --temp < 100 防止循环卡死
    while #self.openList > 0 and self.endNode == nil and temp < 100 do
        temp = temp + 1
        table.sort(self.openList, function(a, b)
            if a.f ~= b.f then
                return a.f < b.f
            end
            if a.h ~= b.h then
                return a.h < b.h
            end
            return a.index < b.index
        end)

        local node = table.remove(self.openList, 1)
        self:HandleNeighborNode(node)
        table.insert(self.closeList, node)
    end
end

function this:HandleNeighborNode(node)
    local aroundCells = private.GetAroundCells(node.index)
    table.each(aroundCells, function(cellIndex)
        local oldNode = table.find(self.closeList, function(k, v)
            return v.index == cellIndex
        end)
        --已经处理过的节点
        if oldNode then
            return
        end

        local cellData = self.model:GetRoundData(self.cardID, cellIndex)
        if cellData:IsNotSign() then
            --无法通行
            return
        end

        if not self.ignoreOtherDragonPos then
            local check = self.model.dragonController:CheckCellUsedByDragon(self.cardID, cellIndex, self.dragon.dragonType)
            if check then
                --被其他条龙占用
                return
            end
        end

        self:AddCellToOpenList(node, cellIndex, 1)
    end)
end

function this:AddCellToOpenList(parentNode, cellIndex, g)
    g = parentNode.g + g
    local oldNode = table.find(self.openList, function(k, node)
        return node.index == cellIndex
    end)
    if oldNode then
        if g < oldNode.g then
            oldNode.g = g
            oldNode.parent = parentNode
        end
    else
        local h, w = private.GetCellH(self, cellIndex)
        local newNode = private.CreateNode(self, cellIndex, parentNode, g, h + w, { h, w })
        if cellIndex == self.endIndex then
            self.endNode = newNode
        else
            table.insert(self.openList, newNode)
        end
    end
end

--------------------------------------------------------------------------------
--计算格子到终点格子的移动距离
function private.GetCellH(self, cellIndex)
    local rowTemp = math.floor((self.endIndex - 1) / 5) + 1
    local rowIndex = math.floor((cellIndex - 1) / 5) + 1
    if rowTemp ~= rowIndex then
        local a, b = math.abs(rowTemp - rowIndex) --横着移动几格
        if rowIndex < rowTemp then
            b = math.abs((cellIndex + 5 * a) - self.endIndex) --竖着移动几格
        else
            b = math.abs((cellIndex - 5 * a) - self.endIndex) --竖着移动几格
        end
        return b, a
    end

    return math.abs(self.endIndex - cellIndex), 0
end

--取位于指定格子的上下左右位置的格子
function private.GetAroundCells(cellIndex)
    local ret = {}
    table.each(dirOrder, function(num)
        local index = cellIndex + num
        if private.IsValidIndex(index, cellIndex) then
            table.insert(ret, index)
        end
    end)
    return ret
end

--判断格子是否有效
function private.IsValidIndex(index, tempIndex)
    if math.abs(index - tempIndex) == 1 then
        local rowTemp = math.floor((tempIndex - 1) / 5) + 1
        local rowIndex = math.floor((index - 1) / 5) + 1
        if rowTemp ~= rowIndex then
            return false
        end
    end

    return index >= 1 and index <= 25
end

--通过Node计算path路径列表
function private.GetPathByNode(self, node)
    local path = {}
    local temp = 1
    --temp < 10 防止循环卡死
    while node ~= nil and temp < 25 do
        temp = temp + 1
        table.insert(path, node.index)
        node = node.parent
    end
    return path
end

--创建一个node
function private.CreateNode(self, cellIndex, parentNode, g, h, hw)
    local node = {}
    node.index = cellIndex   --格子坐标
    node.targetIndex = self.endIndex   --移动终点
    node.parent = parentNode --路径中的上一个node 
    node.g = g               --出发点到该节点需要移动的距离 
    node.h = h               --该节点到终点需要移动的距离
    node.hw = hw             --该节点到终点的纵向距离和横向距离
    node.f = g + h           --该节点的移动估价  
    return node
end

return this