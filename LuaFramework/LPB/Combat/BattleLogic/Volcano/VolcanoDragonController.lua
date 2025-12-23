local VolcanoMoveMachine = require("Combat.BattleLogic.Volcano.VolcanoMoveMachine")

---管理所有卡牌上龙的移动
local VolcanoDragonController = {}
local this = VolcanoDragonController

function this:CheckInit()
    if not this.haveInit then
        this:InitDragons()
    end
end

function this:InitDragons()
    this.dragonList = {}
    
    local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
    table.each(cardView.dragonCells, function(cellIndexs, cardID)
        cardID = tonumber(cardID)
        this.dragonList[cardID] = {}
        table.each(cellIndexs, function(cellIndex)
            cellIndex = tonumber(cellIndex)
            local dragonMoveMachine = CreateInstance_(VolcanoMoveMachine)
            dragonMoveMachine:Init(cardID, cellIndex)
            this.dragonList[cardID][cellIndex] = dragonMoveMachine
        end)
    end)
    
    this.haveInit = true
end

function this:Start()
    table.each(this.dragonList, function(list, cardID)
        table.each(list, function(v, cellIndex)
            v:Start()
        end)
    end)
end

function this:Pause()
    table.each(this.dragonList, function(list, cardID)
        table.each(list, function(v, cellIndex)
            v:Pause()
        end)
    end)
end

function this:Stop()
    table.each(this.dragonList, function(list, cardID)
        table.each(list, function(v, cellIndex)
            v:Stop()
        end)
    end)
end

function this:Clear()
    this:Stop()
    this.dragonList = {}
end

--是否有龙在移动中
function this:HaveMovingCtrl()
    local ret = false
    
    table.each(this.dragonList, function(list, cardID)
        table.each(list, function(v, cellIndex)
            ret = ret or v:IsMoving()
        end)
    end)
    
    return ret
end

--是否有龙可以到达终点
function this:HaveMoveTarget()
    local ret = false

    table.each(this.dragonList, function(list, cardID)
        table.each(list, function(v, cellIndex)
            ret = ret or v:CanMoveToEnd()
        end)
    end)

    return ret
end

---有格子盖章后，重新规划路线
function this:OnCellSigned(cardID, cellIndex)
    if not this.dragonList then
        return
    end

    cardID = tonumber(cardID)
    local dragons = this.dragonList[cardID]
    table.each(dragons, function(v, k)
        if not v:IsMoving() then
            v:ReCalculatePath()
        end
    end)
end

---某条龙移动到终点，其他龙继续移动
function this:OnDragonMoveEnd(cardID, dragonType)
    cardID = tonumber(cardID)
    local ret = false
    local dragons = this.dragonList[cardID]
    table.each(dragons, function(v, cellIndex)
        if v.dragonType ~= dragonType then
            v:ReCalculatePath()
        end
    end)
    return ret
end

---检查格子是否被其他条龙占用
function this:CheckCellUsedByDragon(cardID, cellIndex, dragonType)
    if cellIndex == 13 then
        return false
    end
    
    cardID = tonumber(cardID)
    local ret = false
    local dragons = this.dragonList[cardID]
    table.each(dragons, function(v, k)
        if not v.isGainedBySkill then
            if v.dragonType ~= dragonType then
                ret = ret or v.curStayCell == cellIndex
            end
        end
    end)
    return ret
end

---检查格子是否在其他龙的移动路径上
---仅检查龙的当前停留点和下一个移动点
function this:CheckCellIsInDragonPath(cardID, cellIndex, dragonType)
    if cellIndex == 13 then
        return false
    end
    
    cardID = tonumber(cardID)
    local ret = false
    local dragons = this.dragonList[cardID]
    table.each(dragons, function(v, k)
        if not v.isGainedBySkill then
            if v.dragonType ~= dragonType then
                local path = v.movePath
                if #path > 0 then
                    --下一个移动目标点
                    local nextNode = path[1]
                    ret = ret or nextNode == cellIndex
                end
                ret = ret or v.curStayCell == cellIndex
            end
        end
    end)
    return ret
end

---取龙
function this:GetDragon(cardID, cellIndex)
    cardID = tonumber(cardID)
    cellIndex = tonumber(cellIndex)
    
    local dragons = this.dragonList[cardID]
    local dragon = dragons[cellIndex]
    return dragon
end

return this