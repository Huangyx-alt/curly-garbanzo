--[[
Descripttion: 向后端请求进入战斗的数据
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
---@class CmdReqEnterGame : CommandBase
local CmdReqEnterGame = BaseClass("CmdReqEnterGame", base)

local CommandConst = CommandConst

function CmdReqEnterGame:OnCmdExecute()
    if ViewList.BattleLoadingView.isShow then
        --等loading界面显示之后再请求
        LuaTimer:SetDelayFunction(1, function()
            ModelList.BattleModel:ReqEnterGame(function(success)
                if not success then
                    self:ExecuteDone(CommandConst.CmdExecuteResult.Fail)
                else
                    self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                end
            end)
        end)
    else
        Facade.SendNotification(NotifyName.ShowDialog,ViewList.BattleLoadingView, nil, function()
            --等loading界面显示之后再请求
            LuaTimer:SetDelayFunction(1, function()
                ModelList.BattleModel:ReqEnterGame(function(success)
                    if not success then
                        self:ExecuteDone(CommandConst.CmdExecuteResult.Fail)
                    else
                        self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                    end
                end)
            end)
        end)
    end
end

return CmdReqEnterGame