--[[
Descripttion: 小猪罐玩法，魔法炸弹技能
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年8月28日15:47:27
LastEditors: gaoshuai
LastEditTime: 2025年8月28日15:47:27
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandBase
local base = CommandBase
---@class CmdPlaySkill102 : CommandBase
local CmdPlaySkill102 = BaseClass("CmdPlaySkill102", base)
local CommandConst = CommandConst
local this = CmdPlaySkill102

function CmdPlaySkill102:OnCmdExecute(args)
    args = args or {}
    local skill_id, cardId, cellIndex, powerId, serverExtraPos = args.skill_id, args.cardId, args.cellIndex, args.powerId, args.extraPos
    this.cardPower = args.cardPower
    local pos = ConvertCellIndexToServerPos(cellIndex)
    local extraPos = {}
    local cardIndex = tonumber(cardId)

    if GetTableLength(serverExtraPos) > 0 then
        extraPos = BattleTool.GetExtraPos(serverExtraPos)
    else
        local powerUpData = ModelList.BattleModel:GetCurrModel():LoadGameData().powerUpData
        local targetPuData, puIndex = table.find(powerUpData.powerUpList, function(k, v)
            return powerId == v.powerUpId and v.isUsed
        end)
        local data = table.find(targetPuData and targetPuData.cardEffect, function(k, v)
            return v.cardId == cardId
        end)
        if data then
            extraPos = BattleTool.GetFromServerPos(data.effectData.posList)
        end
    end

    this.totalCount = GetTableLength(extraPos)
    if this.totalCount == 0 then
        local data = Csv.GetData("new_skill", skill_id, "skill_xyz")
        local needCount = data and data[1][1]
        if needCount then
            extraPos = this.cardPower:GetHitPos(cardId, needCount, this.cardPower.CellState.AddItem)
        else
            self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end
    end
    this.totalCount = GetTableLength(extraPos)
    
    this.cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
    local mapObj = this.cardView:GetCardMap(tonumber(cardId))
    local cellObj = this.cardView:GetCardCell(tonumber(cardId), cellIndex)
    for i = 1, #extraPos do
        this:ShowFly(mapObj, cellObj, cardId, ConvertServerPos(extraPos[i]), powerId)
        --this:ShowFly(mapObj, cellObj, cardId, extraPos[i], powerId, cellIndex)
    end
end

function CmdPlaySkill102:ShowFly(mapObj, cellObj, cardID, targetCellIndex, powerId, cellIndex)
    local targetCell = this.cardView:GetCardCell(tonumber(cardID), targetCellIndex)
    local prefabName = "PiggyBankskill2feiji"
    BattleEffectCache:GetSkillPrefab_BingoBang(cardID, prefabName, cellObj, 0, function(obj)
        if not IsNull(obj) then
            UISound.play("piggybankmagicbomb")

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
                --local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardID, targetCellIndex)
                --if cellData:IsNotSign() then
                    this.cardView:OnClickCardIgnoreJudgeByIndex(cardID, targetCellIndex, powerId)
                --end
                this.cardPower:ChangeCellState(cardID, targetCellIndex, this.cardPower.CellState.Signed)
                BattleEffectPool:Recycle(prefabName, obj)

                this.totalCount = this.totalCount - 1
                if this.totalCount <= 0 then
                    self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                end
            end)
        else
            self:ExecuteDone(CommandConst.CmdExecuteResult.Fail)
        end
    end)
end

--控制起始角度和结束角度
function CmdPlaySkill102:GetOffsetDir(startPos, endPos)
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

function CmdPlaySkill102:GetBeizerList(pathNodes, segmentNum)
    local path = {}
    for i = 1, segmentNum do
        local t = i / segmentNum
        local pos = this:CalculateCubicBezierPoint(t, pathNodes[1], pathNodes[2], pathNodes[3], pathNodes[4])
        table.insert(path, pos)
    end
    return path
end

---CalculateCubicBezierPoint
---@param t number 路径中第n个点
---@param p0 table 起点
---@param p1 table 控制点1
---@param p2 table 控制点2
---@param p3 table 终点
function CmdPlaySkill102:CalculateCubicBezierPoint(t, p0, p1, p2, p3)
    local arg1 = 1 - t
    local arg2 = arg1 * arg1
    local arg3 = arg2 * arg1
    local tt = t * t
    local ttt = t * t * t

    local pos = p0 * arg3 + p1 * 3 * t * arg2 + p2 * 3 * tt * arg1 + p3 * ttt
    return pos
end

return CmdPlaySkill102