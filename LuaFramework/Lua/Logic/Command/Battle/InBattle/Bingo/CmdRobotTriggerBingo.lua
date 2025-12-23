--[[
Descripttion: 机器人触发Bingo后的逻辑和表现流程
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年7月21日15:03:25
LastEditors: gaoshuai
LastEditTime: 2025年7月21日15:03:25
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

local CmdStartBattleSettle = require "Logic.Command.Battle.Settle.CmdStartBattleSettle"

---@type CommandBase
local base = CommandBase
---@class CmdRobotTriggerBingo : CommandBase
local CmdRobotTriggerBingo = BaseClass("CmdRobotTriggerBingo", base)
local CommandConst = CommandConst

function CmdRobotTriggerBingo:OnCmdExecute(args)
    args = args or {}
    
    local bingoleftData = args.bingoleftData
    local curModel = ModelList.BattleModel:GetCurrModel()

    curModel:SaveBingoRobots(bingoleftData.robots)
    
    if bingoleftData.bingoLeft <= 10 then
        UISound.set_bgm_volume(0.7)
    end
    --如果可以进入结算，则停止叫号
    if bingoleftData.bingoLeft <= 0 then
        BattleMachineList.GetMchine("CallNumberMachine"):Stop()
    end

    --BingoLeft界面表现
    Facade.SendNotification(NotifyName.Bingo.Sync_Bingos, bingoleftData)
    
    --self:ExecuteDone(CommandConst.CmdExecuteResult.Success)

    --可以结算，进入结算流程
    if bingoleftData.bingoLeft <= 0 and curModel:GetReadyState() == 1 then
        curModel:SetReadyState(2)
        if not BingoBangEntry.IsInBattlePreSettle and not BingoBangEntry.IsInBattleSettle then
            local settleCmd = CmdStartBattleSettle.New()
            settleCmd:Execute()
        end
    end
end

return CmdRobotTriggerBingo