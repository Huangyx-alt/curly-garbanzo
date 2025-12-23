--[[
Descripttion: 命令系统枚举定义
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年7月8日 15:38:28
LastEditors: gaoshuai
LastEditTime: 2025年7月8日 15:38:28
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

local CommandConst = {}

---命令系统日志tag
CommandConst.LogTag = "[CommandSystem]"

CommandConst.CmdExecuteResult = {
    Success = 1,
    Fail = 2
}

CommandConst.CmdRunState = {
    Init = 1,
    Running = 2,
    Done = 3
}

--return ConstClass("CommandConst")
return CommandConst
