--[[
Descripttion: 命令系统基类
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年7月8日 15:38:28
LastEditors: gaoshuai
LastEditTime: 2025年7月8日 15:38:28
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@class CommandBase
local CommandBase = BaseClass("CommandBase")

local CommandConst = CommandConst

---@param options table 额外参数
function CommandBase:__init(options)
    self.doneFuncs = {} --执行完成的外调
    self.executeResult = CommandConst.CmdExecuteResult.Success
    self.runState = CommandConst.CmdRunState.Init
    self.startTime = os.clock()
    self.isStop = false
    self.internal_complete_callback = nil
    self.options = options or {}
end

---停止命令
function CommandBase:CloseCmd()
    if self.isStop then
        return
    end

    self.isStop = true
    self:OnDestroy()
end

---销毁
function CommandBase:OnDestroy()
    self.doneFuncs = nil
    self.executeResult = nil
    self.runState = nil
    self.startTime = nil
    self.internal_complete_callback = nil
    self.isStop = nil
    self.options = nil
end

---是否执行完毕(失败或者成功都算执行完毕)
function CommandBase:IsExecuteDone()
    return self.runState == CommandConst.CmdRunState.Done
end

---外部调用，开始执行命令
function CommandBase:Execute(args)
    if self.isStop then
        self:Log("Execute, self.isStop", true)
        return
    end

    if self.runState ~= CommandConst.CmdRunState.Init then
        self:Log("Execute, self.runState ~= CommandConst.CmdRunState.Init", true)
        return
    end

    self.startTime = os.clock()
    self:Log(string.format("Execute, startTime:%s", self.startTime))
    self.executeResult = CommandConst.CmdExecuteResult.Success
    self.runState = CommandConst.CmdRunState.Running
    self:OnCmdExecute(args)
end

---子类重写，内部逻辑，开始执行命令任务
function CommandBase:OnCmdExecute(args)
    
end

---外部调用，命令执行完成
---@param executeResult CommandConst.CmdExecuteResult 执行结果的枚举值
function CommandBase:ExecuteDone(executeResult)
    if self.isStop then
        self:Log("ExecuteDone, self.isStop", true)
        return
    end

    if self.runState ~= CommandConst.CmdRunState.Running then
        self:Log("ExecuteDone, self.runState ~= CommandConst.CmdRunState.Running", true)
        return
    end

    if self.startTime then
        local costTime = string.format("%.2fs", (os.clock() - self.startTime))
        local str = string.format("ExecuteDone, ExecuteResult:[%s], CostTime:%s", table.keyof(CommandConst.CmdExecuteResult,executeResult), costTime)
        self:Log(str)
    end

    self.executeResult = executeResult
    self.runState = CommandConst.CmdRunState.Done
    self:OnCmdExecuteDone()
    self:CallDoneFunc()
    self:OnDestroy()
end

---子类重写，内部逻辑，命令执行完成
function CommandBase:OnCmdExecuteDone()

end

---添加执行完成的回调
function CommandBase:AddDoneFunc(func)
    table.insert(self.doneFuncs, func)
end
---移除执行完成的回调
function CommandBase:RemoveDoneFunc(func)
    local index = table.keyof(self.doneFuncs, func)
    if index and index > 0 then
        table.remove(self.doneFuncs, index)
    end
end
---执行命令完成的回调
function CommandBase:CallDoneFunc()
    table.walk(self.doneFuncs, function(v)
        if v ~= nil then
            v(self)
        end
    end)
end

-----------------------日志----Start------------------
function CommandBase:Log(str, isError)
    local selfTag = self.options and self.options.LogTag or self._class_type.__cname
    local logStr = string.format("[%s] [%s] %s", CommandConst.LogTag, selfTag, str)
    if isError then
        log.e(logStr)
    else
        log.log(logStr)
    end
end
-----------------------日志----End-----------------

return CommandBase
