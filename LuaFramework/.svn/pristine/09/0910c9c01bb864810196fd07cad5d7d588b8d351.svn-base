--[[
Descripttion: 顺序处理多任务命令，任务失败不会中断后续任务的执行
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年7月8日 15:38:28
LastEditors: gaoshuai
LastEditTime: 2025年7月8日 15:38:28
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandSequence
local base = CommandSequence
---@class CommandSequenceNotInterrupted : CommandSequence
local CommandSequenceNotInterrupted = BaseClass("CommandSequenceNotInterrupted", base)

local CommandConst = CommandConst

---子命令执行完成
---@param cmd CommandBase 一个命令类实例
function CommandSequenceNotInterrupted:OnChildComplete(cmd)
    if self.isStop then
        --命令已经被停止执行
        return
    end
    
    self.executeResult = CommandConst.CmdExecuteResult.Success
    self:Next()
end

return CommandSequenceNotInterrupted
