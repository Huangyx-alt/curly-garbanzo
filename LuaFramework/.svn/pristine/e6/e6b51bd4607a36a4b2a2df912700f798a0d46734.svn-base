--[[
Descripttion: 顺序处理多任务命令，有一个执行失败，则任务直接走失败逻辑
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
---@class CommandSequence : CommandContainerBase
local CommandSequence = BaseClass("CommandSequence", base)

local CommandConst = CommandConst

function CommandSequence:__init()
    --当前在执行哪个child
    self.cur_execute_index = nil
end

function CommandSequence:OnDestroy()
    self.cur_execute_index = nil
    base.OnDestroy(self)
end

---是否正在执行命令
function CommandSequence:IsExecuting()
    return self.cur_execute_index ~= nil
end

---开始执行
function CommandSequence:OnCmdExecute()
    self.cur_execute_index = 0
    self:Next()
end

---子命令执行完成
---@param cmd CommandBase 一个命令类实例
function CommandSequence:OnChildComplete(cmd)
    if self.isStop then
        --命令已经被停止执行
        return
    end
    
    if self.child_cmd_list[self.cur_execute_index] ~= cmd then
        self:Log("OnChildComplete 错误, 完成的对象不是当前运行Command", true)
    end
    
    self.executeResult = cmd.executeResult
    if self.executeResult == CommandConst.CmdExecuteResult.Fail then
        --有一个执行失败，则直接走任务失败逻辑
        self:ExecuteDone(CommandConst.CmdExecuteResult.Fail)
    else
        self:Next()
    end
end

function CommandSequence:Next()
    if self.isStop then
        --命令已经被停止执行
        return
    end

    local count = self:ChildCount()
    if count > 0 and self.cur_execute_index < count then
        --执行下一个任务
        self.cur_execute_index = self.cur_execute_index + 1
        local cmd = self.child_cmd_list[self.cur_execute_index]
        
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
        --所有任务都执行成功了
        self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end
end

return CommandSequence
