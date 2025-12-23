--[[
Descripttion: 进入战斗结算流程
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年8月12日10:18:02
LastEditors: gaoshuai
LastEditTime: 2025年8月12日10:18:02
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

local CmdCheckBattleEffectShowOver = require "Logic.Command.Battle.Settle.Sequence.CmdCheckBattleEffectShowOver"
local CmdShowLastChance = require "Logic.Command.Battle.Settle.Sequence.CmdShowLastChance"
local CmdShowRoundOver = require "Logic.Command.Battle.Settle.Sequence.CmdShowRoundOver"
local CmdShowLuckyBang = require "Logic.Command.Battle.Settle.Sequence.CmdShowLuckyBang"
local CmdShowMissOrPerfect = require "Logic.Command.Battle.Settle.Sequence.CmdShowMissOrPerfect"
local CmdShowCoinSettle = require "Logic.Command.Battle.Settle.Sequence.CmdShowCoinSettle"
local CmdShowSettleDetail = require "Logic.Command.Battle.Settle.Sequence.CmdShowSettleDetail"
local CmdShowTournament = require "Logic.Command.Battle.Settle.Sequence.CmdShowTournament"
local CmdBattleSettleEnd = require "Logic.Command.Battle.Settle.Sequence.CmdBattleSettleEnd"


---@type CommandBase
local base = CommandBase
---@class CmdStartBattleSettle : CommandBase
local CmdStartBattleSettle = BaseClass("CmdStartBattleSettle", base)
local CommandConst = CommandConst
 
function CmdStartBattleSettle:OnCmdExecute()
    BingoBangEntry.IsInBattle = false
    BingoBangEntry.IsInBattlePreSettle = true
    BingoBangEntry.BingoQueue = {}
    BingoBangEntry.BingoExecuteFlag = {}
    
    local sequence = CommandSequence.New({ LogTag = "CmdStartBattleSettle Sequence", })
    
    sequence:AddCommand(CmdCheckBattleEffectShowOver.New({ LogTag = "CmdStartBattleSettle 1", }))
    sequence:AddCommand(CmdShowLastChance.New({ LogTag = "CmdStartBattleSettle 2", }))
    sequence:AddCommand(CmdCheckBattleEffectShowOver.New({ LogTag = "CmdStartBattleSettle 3", }))
    sequence:AddCommand(CmdShowRoundOver.New({ LogTag = "CmdStartBattleSettle 4", }))
    sequence:AddCommand(CmdShowMissOrPerfect.New({ LogTag = "CmdStartBattleSettle 5", }))
    sequence:AddCommand(CmdShowLuckyBang.New({ LogTag = "CmdStartBattleSettle 6", }))
    sequence:AddCommand(CmdCheckBattleEffectShowOver.New({ LogTag = "CmdStartBattleSettle 7", }))
    sequence:AddCommand(CmdShowCoinSettle.New({ LogTag = "CmdStartBattleSettle 8", }))
    sequence:AddCommand(CmdShowSettleDetail.New({ LogTag = "CmdStartBattleSettle 9", }))
    sequence:AddCommand(CmdShowTournament.New({ LogTag = "CmdStartBattleSettle 10", }))
    sequence:AddCommand(CmdBattleSettleEnd.New({ LogTag = "CmdStartBattleSettle 11", }))
    
    --结束
    sequence:AddDoneFunc(function()
        BingoBangEntry.IsInBattleSettle = false
        BingoBangEntry.ManualDaubCount = 0
        BingoBangEntry.DaubPowerDaubCount = 0
        BingoBangEntry.MissNumberList = {}
        BingoBangEntry.LuckyBangTriggerBingoCount = 0
        
        self:ExecuteDone(sequence.executeResult)
    end)
    --开始
    sequence:Execute()
end

return CmdStartBattleSettle