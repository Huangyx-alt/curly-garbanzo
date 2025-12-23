--[[
Descripttion: 并行处理多任务命令，所有子命令处理完成才算完成，有一个执行失败，则任务直接走失败逻辑
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年7月8日 15:38:28
LastEditors: gaoshuai
LastEditTime: 2025年7月8日 15:38:28
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandContainerBase
local base = CommandContainerBase
---@class CommandParallel : CommandContainerBase
local CommandParallel = BaseClass("CommandParallel", base)

local CommandConst = CommandConst

function CommandParallel:__init()
    self.complete_task_count = 0
end

function CommandParallel:OnDestroy()
    self.complete_task_count = nil
    base.OnDestroy(self)
end

---开始执行
function CommandParallel:OnCmdExecute()
    self.complete_task_count = 0
    if self:ChildCount() <= 0 then
        self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    else
        --并行处理命令
        table.walk(self.child_cmd_list, function(cmd)
            if not self:IsExecuteDone() then
                cmd:Execute()
            else
                self:Log(string.format("Parallel IsExecuteDone, Skip Execute Child [%s]", cmd._class_type.__cname))
            end
        end)
    end
end

---子命令执行完成
---@param cmd CommandBase 一个命令类实例
function CommandParallel:OnChildComplete(cmd)
    self.executeResult = cmd.executeResult
    if cmd.executeResult == CommandConst.CmdExecuteResult.Fail then
        --有一个执行失败，则直接走任务失败逻辑
        self:ExecuteDone(CommandConst.CmdExecuteResult.Fail)
    else
        if self:IsExecuteDone() then
            self:Log(string.format("IsExecuteDone, OnChildComplete [%s] return", cmd._class_type.__cname))
            return
        end
        
        self.complete_task_count = self.complete_task_count + 1
        if self:ChildCount() == self.complete_task_count then
            self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end
    end
end

return CommandParallel
