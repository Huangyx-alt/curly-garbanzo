--[[
Descripttion: 多任务命令基类
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年7月8日 15:38:28
LastEditors: gaoshuai
LastEditTime: 2025年7月8日 15:38:28
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandBase
local base = CommandBase
---@class CommandContainerBase : CommandBase
local CommandContainerBase = BaseClass("CommandContainerBase", base)

local CommandConst = CommandConst

function CommandContainerBase:__init()
    self.child_cmd_list = {}
end

function CommandContainerBase:CloseCmd()
    table.walk(self.child_cmd_list, function(cmd)
        cmd:CloseCmd()
    end)
    base.CloseCmd(self)
end

function CommandContainerBase:OnDestroy()
    self.child_cmd_list = nil
    base.OnDestroy(self)
end

---添加子命令
---@param cmd CommandBase 一个命令类实例
---@param pos number 插入到命令列表的哪个位置
function CommandContainerBase:AddCommand(cmd, pos)
    assert(cmd ~= nil)
    cmd:AddDoneFunc(function()
        self:OnChildComplete(cmd)
    end)
    if pos == nil or pos > self:ChildCount() then
        table.insert(self.child_cmd_list, cmd)
    else
        table.insert(self.child_cmd_list, pos, cmd)
    end
end

---添加子命令
---@param func function
---@param pos number 插入到命令列表的哪个位置
function CommandContainerBase:AddFunctionCommand(func, args, pos)
    assert(func ~= nil)

    local options = args or {}
    options.executeFunc = func
    local funcCmd = FunctionCommand.New(options)
    funcCmd:AddDoneFunc(function()
        self:OnChildComplete(funcCmd)
    end)

    if pos == nil or pos > self:ChildCount() then
        table.insert(self.child_cmd_list, funcCmd)
    else
        table.insert(self.child_cmd_list, pos, funcCmd)
    end
end

---移除子命令
function CommandContainerBase:RemoveCommand(pos)
    local cmd = table.remove(self.child_cmd_list, pos)
    return cmd
end

---从子命令列表里取指定命名的index
---@param cmd_class_type string 子命令类名
function CommandContainerBase:GetSubCommandPos(cmd_class_type)
    local v, index = table.find(self.child_cmd_list, function(k, v)
        return v._class_type == cmd_class_type
    end)
    return index
end

function CommandContainerBase:ChildCount()
    local count = table.count(self.child_cmd_list)
    return count
end

---对每一个子命令执行逻辑
---@param onStepWalk function
function CommandContainerBase:WalkChildren(onStepWalk)
    table.walk(self.child_cmd_list, function(cmd)
        onStepWalk(cmd)
    end)
end

---给子类重写
function CommandContainerBase:OnChildComplete()
    
end

return CommandContainerBase
