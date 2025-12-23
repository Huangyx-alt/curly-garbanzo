--[[
Descripttion: 给玩家最后盖章的时间
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年8月12日10:33:48
LastEditors: gaoshuai
LastEditTime: 2025年8月12日10:33:48
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandBase
local base = CommandBase
---@class CmdShowLastChance : CommandBase
local CmdShowLastChance = BaseClass("CmdShowLastChance", base)
local CommandConst = CommandConst

function CmdShowLastChance:OnCmdExecute()
    BattleMachineList.GetMchine("CallNumberMachine"):Stop()
    
    --local curModel = ModelList.BattleModel:GetCurrModel()
    local IsQuitBattle = ModelList.BattleModel.IsQuitBattle()
    if IsQuitBattle then
        --提前结束
        BattleModuleList.UnLoadOneCardModule("CardInput")
        self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        return
    end
    
    Facade.SendNotification(NotifyName.Bingo.ShowLastChange, function()
        BattleModuleList.UnLoadOneCardModule("CardInput")
        self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end)
end

return CmdShowLastChance