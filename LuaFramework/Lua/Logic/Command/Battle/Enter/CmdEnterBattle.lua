--[[
Descripttion: 进入战斗流程
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年7月8日 15:38:28
LastEditors: gaoshuai
LastEditTime: 2025年7月8日 15:38:28
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

local CmdReqEnterGame = require "Logic.Command.Battle.Enter.EnterSequence.CmdReqEnterGame"
local CmdLoadCommonBattleRes = require "Logic.Command.Battle.Enter.EnterSequence.CmdLoadCommonBattleRes"
local CmdLoadModuleBattleRes = require "Logic.Command.Battle.Enter.EnterSequence.CmdLoadModuleBattleRes"
local CmdStartBattleSequence = require "Logic.Command.Battle.Enter.EnterSequence.CmdStartBattleSequence"

---@type CommandBase
local base = CommandBase
---@class CmdEnterBattle : CommandBase
local CmdEnterBattle = BaseClass("CmdEnterBattle", base)
local CommandConst = CommandConst
 
function CmdEnterBattle:OnCmdExecute()
    --异步流程，须等待前一个执行完毕才能继续下一个
    --1、发送进战斗消息给后端
    --2、收到进战斗消息后，加载战斗场景
    --3、战斗场景加载完成后，进行战斗开始流程
    
    BingoBangEntry.IsInEnterBattleSequence = true 
    BingoBangEntry.IntervalBetweenTwoBattle = os.time() - (BingoBangEntry.LastEndBattleTime or os.time())
    
    local sequence = CommandSequence.New({ LogTag = "CmdEnterBattle Sequence", })
    --流程
    sequence:AddCommand(CmdReqEnterGame.New({ LogTag = "CmdEnterBattle 1", }))
    sequence:AddCommand(CmdLoadCommonBattleRes.New({ LogTag = "CmdEnterBattle 2", }))
    sequence:AddCommand(CmdLoadModuleBattleRes.New({ LogTag = "CmdEnterBattle 3", }))
    sequence:AddCommand(CmdStartBattleSequence.New({ LogTag = "CmdEnterBattle 4", }))
    
    --结束
    sequence:AddDoneFunc(function()
        BingoBangEntry.IsInEnterBattleSequence = false
        if sequence.executeResult == CommandConst.CmdExecuteResult.Success then
            GlobalBattleMachineList.StartBattleGlobalMachine()
            --请求开始战斗
            ModelList.BattleModel:GetCurrModel():ReqGameReady()
            BingoBangEntry.IsInBattle = true
        else
            Facade.SendNotification(NotifyName.HideDialog, ViewList.BattleLoadingView)
        end
        self:ExecuteDone(sequence.executeResult)
    end)
    
    --开始
    sequence:Execute()
end

return CmdEnterBattle