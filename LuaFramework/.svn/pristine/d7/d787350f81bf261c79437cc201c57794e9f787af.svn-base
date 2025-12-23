--[[
Descripttion: 进入引导战斗流程
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年9月18日16:03:24
LastEditors: gaoshuai
LastEditTime: 2025年9月18日16:03:24
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

local CmdReqEnterGame = require "Logic.Command.Battle.Enter.EnterSequence.CmdReqEnterGame"
local CmdLoadCommonBattleRes = require "Logic.Command.Battle.Enter.EnterSequence.CmdLoadCommonBattleRes"
local CmdLoadModuleBattleRes = require "Logic.Command.Battle.Enter.EnterSequence.CmdLoadModuleBattleRes"
local CmdStartBattleSequence = require "Logic.Command.Battle.Enter.EnterSequence.CmdStartBattleSequence"

---@type CommandBase
local base = CommandBase
---@class CmdEnterGuideBattle : CommandBase
local CmdEnterGuideBattle = BaseClass("CmdEnterGuideBattle", base)
local CommandConst = CommandConst
 
function CmdEnterGuideBattle:OnCmdExecute()
    --异步流程，须等待前一个执行完毕才能继续下一个
    --1、发送进战斗消息给后端
    --2、收到进战斗消息后，加载战斗场景
    --3、战斗场景加载完成后，进行战斗开始流程
    
    BingoBangEntry.IsInEnterBattleSequence = true
    ModelList.GuideModel:SetGuideBattle(2)
    
    local sequence = CommandSequence.New({ LogTag = "CmdEnterGuideBattle Sequence", })
    --流程
    sequence:AddCommand(CmdReqEnterGame.New({ LogTag = "CmdEnterGuideBattle 1", }))
    sequence:AddCommand(CmdLoadCommonBattleRes.New({ LogTag = "CmdEnterGuideBattle 2", }))
    sequence:AddCommand(CmdLoadModuleBattleRes.New({ LogTag = "CmdEnterGuideBattle 3", }))
    --sequence:AddCommand(CmdStartBattleSequence.New({ LogTag = "CmdEnterGuideBattle 4", }))
    
    --结束
    sequence:AddDoneFunc(function()
        BingoBangEntry.IsInEnterBattleSequence = false
        if sequence.executeResult == CommandConst.CmdExecuteResult.Success then
            ModelList.GuideModel:OpenUI("GameBingoView")
        else
            Facade.SendNotification(NotifyName.HideDialog, ViewList.BattleLoadingView)
        end
        self:ExecuteDone(sequence.executeResult)
    end)
    
    --开始
    sequence:Execute()
end

return CmdEnterGuideBattle