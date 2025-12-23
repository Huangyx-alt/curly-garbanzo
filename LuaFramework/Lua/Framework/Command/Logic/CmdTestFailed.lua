--[[
Descripttion: 单元测试用
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年7月8日 15:38:28
LastEditors: gaoshuai
LastEditTime: 2025年7月8日 15:38:28
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

local base = CommandBase
local CmdTestFailed = BaseClass("CmdTestFailed", base)
local CommandConst = CommandConst

function CmdTestFailed:OnCmdExecute()
    self:ExecuteDone(CommandConst.CmdExecuteResult.Fail)
end

return CmdTestFailed