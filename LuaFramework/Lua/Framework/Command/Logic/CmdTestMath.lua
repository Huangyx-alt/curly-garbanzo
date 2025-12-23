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
local CmdTestMath = BaseClass("CmdTestMath", base)
local CommandConst = CommandConst

function CmdTestMath:OnCmdExecute()
    local a = 1 + 2
    self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
end

return CmdTestMath