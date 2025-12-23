local BaseSkill = require "View/Bingo/CardModule/Skill/BaseSkill"
local DrinkingFrenzyPuSkill = BaseSkill:New("DrinkingFrenzyPuSkill")
local this = DrinkingFrenzyPuSkill
local private = {}

function DrinkingFrenzyPuSkill:ShowSkill(cardId, cellIndex, powerId, skillId, serverExtraPos)
    local pos = ConvertCellIndexToServerPos(cellIndex)
    local extraPos = {}
    local cardIndex = tonumber(cardId)

    if serverExtraPos then
        extraPos = BattleTool.GetExtraPos(serverExtraPos)
    else
        this.powerUpData = ModelList.BattleModel:GetCurrModel():LoadGameData().powerUpData
        for i = 1, #this.powerUpData do
            if powerId == this.powerUpData[i].powerUpId then
                for m = 1, #this.powerUpData[i].cardPowerUpEffect do
                    if this.powerUpData[i].cardPowerUpEffect[m].cardId == cardIndex and
                            fun.is_include(pos, this.powerUpData[i].cardPowerUpEffect[m].posList) then
                        extraPos = this.powerUpData[i].cardPowerUpEffect[m].extraPos
                        break
                    end
                end
            end
            if extraPos then
                break
            end
        end

        if not extraPos then
            local cardsInfo = ModelList.BattleModel:GetCurrModel():GetLoadCardInfo(cardId)
            table.each(cardsInfo and cardsInfo.beginSkillData, function(data)
                if not extraPos then
                    table.each(data.effect, function(v)
                        if not extraPos then
                            if v.itemId == 2041 and fun.is_include(pos, v.posList) then
                                extraPos = v.extraPos
                            end
                        end
                    end)
                end
            end)
        end
    end
    
    this.cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
    local mapObj = this.cardView:GetCardMap(tonumber(cardId))
    local cellObj = this.cardView:GetCardCell(tonumber(cardId), cellIndex)
    
    for i = 1, #extraPos do
        this:ShowFly(mapObj, cellObj, cardId, ConvertServerPos(extraPos[i]), powerId)
    end
end



function DrinkingFrenzyPuSkill:ShowFly(mapObj, cellObj, cardID, targetCellIndex, powerId, cellIndex)
    local targetCell = this.cardView:GetCardCell(tonumber(cardID), targetCellIndex)
    BattleEffectCache:GetSkillPrefabFromCache("DrinkingFrenzyskill2feiji", nil, function(obj)
        UISound.play("drinkingmagicbomb")
        fun.set_same_position_with(obj, cellObj)
        fun.set_parent(obj, mapObj)
        local startPos, endPos = fun.get_gameobject_pos(obj), fun.get_gameobject_pos(targetCell)
        local node1Dir, node2Dir = this:GetOffsetDir(startPos, endPos)
        local pathNodes = {}
        pathNodes[1] = fun.get_gameobject_pos(obj, false)
        pathNodes[4] = fun.get_gameobject_pos(targetCell, false)
        local distance = Vector3.Distance(startPos, endPos)
        if distance > 1.5 then
            --两个格子中间是否至少间隔一个格子
            pathNodes[2] = startPos + node1Dir
            pathNodes[3] = endPos + node2Dir
        else
            pathNodes[2] = startPos + node1Dir * 3
            pathNodes[3] = endPos + node2Dir * 0.5
        end

        --控制方向
        if not self.dirFlag then
            self.dirFlag = true
        else
            self.dirFlag = false
        end

        --贝塞尔曲线
        local retPath = this:GetBeizerList(pathNodes, 20)
        local flyTime, delayTime = 1.2, 0
        Anim.smooth_move(obj, retPath, flyTime, delayTime, 1, 8, function()
            this.cardView:OnClickCardIgnoreJudgeByIndex(cardID, targetCellIndex, powerId)
            this.cardPower:ChangeCellState(cardID, targetCellIndex, this.CellState.Signed)
            BattleEffectPool:Recycle("DrinkingFrenzyskill2feiji", obj)
        end)
    end, 0, cardID)
end


--控制起始角度和结束角度
function DrinkingFrenzyPuSkill:GetOffsetDir(startPos, endPos)
    local dir = (endPos - startPos).normalized
    local angle = self.dirFlag and 150 or -150
    local q1 = Quaternion.AngleAxis(angle, Vector3.forward)
    local node1Dir = q1 * dir

    dir = (startPos - endPos).normalized
    angle = self.dirFlag and -60 or 60
    local q2 = Quaternion.AngleAxis(angle, Vector3.forward)
    local node2Dir = q2 * dir
    return node1Dir, node2Dir
end


function DrinkingFrenzyPuSkill:GetBeizerList(pathNodes, segmentNum)
    local path = {}
    for i = 1, segmentNum do
        local t = i / segmentNum
        local pos = this:CalculateCubicBezierPoint(t, pathNodes[1], pathNodes[2], pathNodes[3], pathNodes[4])
        table.insert(path, pos)
    end
    return path
end


function private.GetSkillCells(startCellIndex)
    --盖章顺序为：上、下、左、右
    local ret, temp = {}, {-1, 1, -5, 5}                                                                                                                                                                           

    table.each(temp, function(num)
        local index = startCellIndex + num
        table.insert(ret, index)
    end)
    
    return ret
end


---CalculateCubicBezierPoint
---@param t number 路径中第n个点
---@param p0 table 起点
---@param p1 table 控制点1
---@param p2 table 控制点2
---@param p3 table 终点
function DrinkingFrenzyPuSkill:CalculateCubicBezierPoint(t, p0, p1, p2, p3)
    local arg1 = 1 - t
    local arg2 = arg1 * arg1
    local arg3 = arg2 * arg1
    local tt = t * t
    local ttt = t * t * t

    local pos = p0 * arg3 + p1 * 3 * t * arg2 + p2 * 3 * tt * arg1 + p3 * ttt
    return pos
end


function private.IsValidIndex(index,tempIndex)
    if math.abs(index - tempIndex) == 1 then
        local rowTemp = math.floor((tempIndex - 1) / 5) + 1
        local rowIndex = math.floor((index - 1) / 5) + 1
        if rowTemp ~= rowIndex then
            return false                                                                                                                               
        end
    end
    
    return index >= 1 and index <= 25
end

function private.TrySignCell(self, cardId, index, powerId)
    local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, index)
    if cellData:IsNotSign() then
        --cellData.isSignByGemPuSkill = true
        self:GetCardPower().cardView:OnClickCardIgnoreJudgeByIndex(cardId, index, powerId)
    end
    self:GetCardPower():ChangeCellState(cardId, index, self.CellState.Signed)
end

return this