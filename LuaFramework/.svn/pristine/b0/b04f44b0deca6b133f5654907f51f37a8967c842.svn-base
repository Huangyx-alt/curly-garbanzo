--[[
Descripttion: 格子盖章后触发技能表现
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年8月5日10:35:57
LastEditors: gaoshuai
LastEditTime: 2025年8月5日10:35:57
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

--local CmdReqEnterGame = require "Logic.Command.Battle.Enter.EnterSequence.CmdReqEnterGame"

---@type CommandBase
local base = CommandBase
---@class CmdPlayCellSkill : CommandBase
local CmdPlayCellSkill = BaseClass("CmdPlayCellSkill", base)
local CommandConst = CommandConst

---OnCmdExecute
---@param args table {skill_id = skill_id,cardId = cardId,cellIndex = cellIndex,powerId = powerId,extraPos = extraPos} 
function CmdPlayCellSkill:OnCmdExecute(args)
    args = args or {}
    args.powerId = args.powerId or 0
    --log.b("[PlayCellSkill] args:", args)
    
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

return CmdPlayCellSkill