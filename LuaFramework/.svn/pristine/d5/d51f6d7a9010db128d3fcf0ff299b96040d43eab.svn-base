--[[
Descripttion: 预加载资源
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年7月16日15:40:17
LastEditors: gaoshuai
LastEditTime: 2025年7月16日15:40:17
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandBase
local base = CommandBase
---@class CmdPreLoadModuleRes : CommandBase
local CmdPreLoadModuleRes = BaseClass("CmdPreLoadModuleRes", base)

local CommandConst = CommandConst
local private = {}

function CmdPreLoadModuleRes:OnCmdExecute()
    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    if bingoView and bingoView.effectObjContainer then
        bingoView.effectObjContainer:PreLoadBattleRes(function()
            self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end)
    else
        self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end
end

return CmdPreLoadModuleRes