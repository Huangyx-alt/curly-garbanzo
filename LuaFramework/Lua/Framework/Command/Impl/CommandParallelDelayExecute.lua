--[[
Descripttion: 并行处理多任务命令，每个子命令需要设置一个延时开始时间，所有子命令处理完成才算完成，有一个执行失败，则任务直接走失败逻辑
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年7月8日 15:38:28
LastEditors: gaoshuai
LastEditTime: 2025年7月8日 15:38:28
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandParallel
local base = CommandParallel
---@class CommandParallelDelayExecute : CommandParallel
local CommandParallelDelayExecute = BaseClass("CommandParallelDelayExecute", base)

local CommandConst = CommandConst

---开始执行
function CommandParallelDelayExecute:OnCmdExecute()
    self.complete_task_count = 0
    if self:ChildCount() <= 0 then
        self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    else
        --并行处理命令
        table.walk(self.child_cmd_list, function(cmd)
            if not self:IsExecuteDone() then
                local options = cmd.options
                --延迟执行
                if options and options.delayExecuteTime and options.delayExecuteTime > 0 then
                    LuaTimer:SetDelayFunction(options.delayExecuteTime, function()
                        cmd:Execute()
                    end)
                else
                    cmd:Execute()
                end
            else
                self:Log(string.format("Parallel IsExecuteDone, Skip Execute Child [%s]", cmd._class_type.__cname))
            end
        end)
    end
end

return CommandParallelDelayExecute
