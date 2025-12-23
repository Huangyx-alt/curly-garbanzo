--[[
Descripttion: 检查战斗相关的特效是否都已经播放完成
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年9月15日10:31:44
LastEditors: gaoshuai
LastEditTime: 2025年9月15日10:31:44
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandBase
local base = CommandBase
---@class CmdCheckBattleEffectShowOver : CommandBase
local CmdCheckBattleEffectShowOver = BaseClass("CmdCheckBattleEffectShowOver", base)
local CommandConst = CommandConst

function CmdCheckBattleEffectShowOver:OnCmdExecute()
    local IsQuitBattle = ModelList.BattleModel.IsQuitBattle()
    if IsQuitBattle then
        --提前退出
        self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        return
    end
    
    local curModel = ModelList.BattleModel:GetCurrModel()
    
    local timer
    timer = LuaTimer:SetDelayLoopFunction(0, 0.1, -1, function()
        local modelCheckRet = curModel and curModel.CheckEffectShowOver and curModel:CheckEffectShowOver()
        if modelCheckRet and not BingoBangEntry.IsInBattleBingoSequence and not BingoBangEntry.IsInBattleBingoSequence then
            LuaTimer:Remove(timer)
            timer = nil

            self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end
    end, nil, false, LuaTimer.TimerType.Battle)
end

return CmdCheckBattleEffectShowOver