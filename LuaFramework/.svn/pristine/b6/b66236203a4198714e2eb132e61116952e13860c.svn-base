--[[
Descripttion: 使用Pu
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年9月3日15:05:12
LastEditors: gaoshuai
LastEditTime: 2025年9月3日15:05:12
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

--local CmdReqEnterGame = require "Logic.Command.Battle.Enter.EnterSequence.CmdReqEnterGame"

---@type CommandBase
local base = CommandBase
---@class CmdUsePowerUp : CommandBase
local CmdUsePowerUp = BaseClass("CmdUsePowerUp", base)
local CommandConst = CommandConst

---OnCmdExecute
---@param args table {skill_id = skill_id,cardId = cardId,cellIndex = cellIndex,powerId = powerId,extraPos = extraPos} 
function CmdUsePowerUp:OnCmdExecute(args)
    args = args or {}
    local puID, puUseIndex = args.powerupId, args.index
    local info = Csv.GetData("new_powerup", puID)
    local result = info["result"]
    local powerUpUseType = result[1]
    local extra_info = {}
    if RecorderMachine.powerIndex then
        RecorderMachine.powerIndex = puUseIndex
    end
    log.b("[CmdUsePowerUp] UsePowerUpCard  " .. puID .. "   index " .. puUseIndex)

    local curModel = ModelList.BattleModel:GetCurrModel()
    local powerUpData = curModel:LoadGameData().powerUpData
    local targetPuData, puIndex = table.find(powerUpData.powerUpList, function(k, v)
        return powerupId == v.powerUpId and not v.isUsed
    end)
    
    local skillCmdPath = string.format("Logic.Command.Battle.InBattle.Skill.CmdPlaySkill%s", args.skill_id)
    local success, skillCmd = pcall(require, skillCmdPath)
    if success then
        local cmd = skillCmd.New()
        cmd:AddDoneFunc(function()
            self:ExecuteDone(cmd.executeResult)
            fun.SafeCall(args.cb)
        end)
        cmd:Execute(args)
    end
end

return CmdUsePowerUp