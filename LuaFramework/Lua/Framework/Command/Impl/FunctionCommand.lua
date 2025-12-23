--[[
Descripttion: 执行一个函数，可以指定回调
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
---@class FunctionCommand : CommandBase
local FunctionCommand = BaseClass("FunctionCommand", base)

local CommandConst = CommandConst

function FunctionCommand:__init(options)
	self.options = options or {}
	self.executeFunc = options.executeFunc
	self.completeFunc = options.completeFunc
end

function FunctionCommand:OnDestroy()
	self.executeFunc = nil
	self.completeFunc = nil
	base.OnDestroy(self)
end

---开始执行
function FunctionCommand:OnCmdExecute()
	if self.executeFunc ~= nil then
		self.executeFunc(self)
	else
		self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
	end
end

---命令完成回调
function FunctionCommand:OnCmdExecuteDone()
	if self.completeFunc ~= nil then
		self.completeFunc(self)
	end
end

return FunctionCommand
