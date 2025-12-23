--[[
Descripttion: 触发Bingo后的逻辑和表现流程
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年7月21日15:03:25
LastEditors: gaoshuai
LastEditTime: 2025年7月21日15:03:25
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

local CmdHandleBingoQueue = require "Logic.Command.Battle.InBattle.Bingo.CmdHandleBingoQueue"
local CmdStartBattleSettle = require "Logic.Command.Battle.Settle.CmdStartBattleSettle"

---@type CommandBase
local base = CommandBase
---@class CmdTriggerBingo : CommandBase
local CmdTriggerBingo = BaseClass("CmdTriggerBingo", base)
local CommandConst = CommandConst

function CmdTriggerBingo:OnCmdExecute(args)
    args = args or {}
    BingoBangEntry.IsInBattleBingoSequence = true
    local curModel = ModelList.BattleModel:GetCurrModel()
    local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
    local bingoleftData = args.bingoleftData
    local cardId = tonumber(bingoleftData.cardId)
    
    BingoBangEntry.BingoQueue[cardId] = BingoBangEntry.BingoQueue[cardId] or {}
    if not bingoleftData.showOrder and not bingoleftData.showCompleteOrder then
        bingoleftData.showOrder = GetTableLength(BingoBangEntry.BingoQueue[cardId])
        table.insert(BingoBangEntry.BingoQueue[cardId], bingoleftData)
    end

    ----先做BingoLeft表现
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

    if BingoBangEntry.BingoExecuteFlag[cardId] then
        log.r(string.format("[CmdTriggerBingo] cardId:%s, is Execute Bingo.", cardId))
        return
    end
    BingoBangEntry.BingoExecuteFlag[cardId] = true
    
    --流程
    local sequence = CommandSequence.New({ LogTag = "CmdTriggerBingo Sequence", })
    --播放bingo相关格子动画
    sequence:AddCommand(CmdHandleBingoQueue.New({
        args = {
            cardId = cardId,
            bingoleftData = bingoleftData,
        },
        LogTag = "CmdTriggerBingo 1",
    }))
    
    --展示Bingo达成的特效和动画
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            table.sort(BingoBangEntry.BingoQueue[cardId], function(a, b) 
                return a.showOrder > b.showOrder
            end)
            local lastBingoData = BingoBangEntry.BingoQueue[cardId][1].bingo
            BingoBangEntry.BingoQueue[cardId] = {}
            
            Event.Brocast(EventName.CardEffect_MapClick_Effect, cardId, 2)
            
            cardView:OnPlayBingoEffect(cardId)
            
            log.r("[CmdTriggerBingo] BingoQueue:", BingoBangEntry.BingoQueue[cardId])
            local bingo_table = curModel:HandleBingoDataOnPlayBingo(lastBingoData)
            Event.Brocast(EventName.CardBingoEffect_ShowBingo, bingo_table, function()
                BingoBangEntry.BingoExecuteFlag[cardId] = false
                cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
            end)
            Event.Brocast(EventName.SoundMachine_Bingo_Audio, bingo_table)
        end,
        LogTag = "CmdTriggerBingo 2",
    }))

    --检查是否禁用卡片
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            local needForbidCard = curModel:CheckIsMaxBingo(cardId)
            if needForbidCard then
                curModel:GetRoundData(cardId):SetForbid()
            end
            if curModel.CheckAllCardForbid then
                curModel:CheckAllCardForbid()
            end
            
            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end,
        LogTag = "CmdTriggerBingo 3",
    }))
    
    --结束
    sequence:AddDoneFunc(function()
        log.r("[CmdTriggerBingo] BingoExecuteFlag:", BingoBangEntry.BingoExecuteFlag)
        --所有卡片上的bingo效果是否都播放结束
        local checkAllCard = true
        table.walk(BingoBangEntry.BingoExecuteFlag, function(v)
            if v then
                checkAllCard = false
            end
        end)
        if checkAllCard then
            BingoBangEntry.IsInBattleBingoSequence = false
        end
        
        --local options = bingoleftData.options or {}
        --fun.SafeCall(options.onBingoShowComplete)
        --self:ExecuteDone(sequence.executeResult)
        
        --可以结算，进入结算流程
        if bingoleftData.bingoLeft <= 0 and curModel:GetReadyState() == 1 then
            curModel:SetReadyState(2)

            if not BingoBangEntry.IsInBattlePreSettle and not BingoBangEntry.IsInBattleSettle then
                local settleCmd = CmdStartBattleSettle.New()
                settleCmd:Execute()
            end
        end
    end)

    --开始
    sequence:Execute()
    
    --1、达成bingo的格子做bingo盖章动画(可能会有多组，间隔0.2s播放每一组)
    --2、出bingo效果，中间格子盖章类型变换

    --顺序流程
    --1、格子盖章后，计算是否达成binigo：GameModel:ReqSignCard(info)
    --2、减号机执行逻辑：Event.Brocast(EventName.Player_Bingo_Reduce_Bingoleft, totalBingoInfoList, cardId)
    --3、通知GameModel：ModelList.BattleModel:GetCurrModel():ResBingoInfo(0,bingoleftData)
    ----3.1、0.3s后出Bingo特效：this:RefreshBingoInfo()
    ----3.2、BingoLeft界面表现：Facade.SendNotification(NotifyName.Bingo.Sync_Bingos)
    ------3.2.1、盖章和卡牌震动：Event.Brocast(EventName.Trigger_Bingo, idList[k], bingoNumbers)
    --------3.2.1.1、等最后一个格子盖章时间超过0.8s，所有金币跳跃一次：GameCardView:JumpAllCoin(cardid, numbers)
end

return CmdTriggerBingo