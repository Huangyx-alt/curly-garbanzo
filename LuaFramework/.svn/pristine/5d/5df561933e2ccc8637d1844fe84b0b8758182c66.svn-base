--[[
Descripttion: 
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年8月26日15:40:50
LastEditors: gaoshuai
LastEditTime: 2025年8月26日15:40:50
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandBase
local base = CommandBase
---@class CmdHandleBingoQueue : CommandBase
local CmdHandleBingoQueue = BaseClass("CmdHandleBingoQueue", base)
local CommandConst = CommandConst
local private = {}

function CmdHandleBingoQueue:OnCmdExecute(args)
    if not args then
        args = self.options.args or {}
    end

    self.cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
    self.cardId = tonumber(args.cardId)
    self.showCompleteOrder = 1
    
    private.ShowBingoData(self, args.bingoleftData)
end

function private.ShowBingoData(self, bingoleftData)
    log.r("[CmdHandleBingoQueue] ShowBingoData:", bingoleftData)
    log.r(string.format("[CmdHandleBingoQueue] cardId:%s, show Bingo.", self.cardId))
    if not bingoleftData then
        private.ShowNextBingo(self)
        return
    end
    
    local selfBingoCount = GetTableLength(bingoleftData.bingo)
    if selfBingoCount > 0 then
        --取需要播动画的格子
        local bingoNumbers, jackpotNumber, bingoOrJack = {}, {}, 0
        table.walk(bingoleftData.bingo, function(v)
            if tonumber(v.cardId) == self.cardId and not v.isSelfBingoCellTrigger then
                --排序：构成BINGO的格子动画，达成多个BINGO时，顺序如下
                --竖线>横线>斜线（↘）>斜线（↙）>四个角
                --table.sort(v.numbers)
                --fun.add_table(bingoNumbers, v.numbers)
                table.insert(bingoNumbers, v.numbers)
                if v.type > bingoOrJack then
                    bingoOrJack = v.type
                end
                if v.type == 2 then
                    fun.add_table(jackpotNumber, v.numbers)
                end
            end
        end)

        --去重
        --bingoNumbers = fun.table_unique(bingoNumbers)

        if bingoOrJack == 2 then
            --jackpot表现
            Event.Brocast(EventName.Trigger_Jackpot, self.cardId, bingoNumbers, jackpotNumber, function()
                bingoleftData.showCompleteOrder = self.showCompleteOrder
                self.showCompleteOrder = self.showCompleteOrder + 1
                private.ShowNextBingo(self)
            end)
        else
            --播放bingo后获得卡牌奖励的效果
            self.cardView:HideCardReward(self.cardId)
            
            private.ShowCellAnim(self, bingoNumbers, function()
                bingoleftData.showCompleteOrder = self.showCompleteOrder
                self.showCompleteOrder = self.showCompleteOrder + 1
                private.ShowNextBingo(self)
            end)
        end
    else
        bingoleftData.showCompleteOrder = self.showCompleteOrder
        self.showCompleteOrder = self.showCompleteOrder + 1
        private.ShowNextBingo(self)
    end
end

function private.ShowNextBingo(self)
    log.r("[CmdHandleBingoQueue] BingoQueue:", BingoBangEntry.BingoQueue[self.cardId])
    local bingoleftData = table.find(BingoBangEntry.BingoQueue[self.cardId], function(k, v)
        return not v.showCompleteOrder
    end)
    if bingoleftData then
        private.ShowBingoData(self, bingoleftData)
    else
        self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end
end

--触发bingo的格子依次播动画
function private.ShowCellAnim(self, cellIndexes, onComplete)
    local delayTime = GlobalArtConfig.CellsSignAnimDelayOnBingo
    table.walk(cellIndexes, function(v, k)
        table.sort(v, function(a, b)
            return a < b
        end)
        --触发bingo的格子依次播动画
        table.walk(v, function(cellIndex)
            local cell = self.cardView:GetCardCell(self.cardId, cellIndex)
            self.cardView:SignCard(cell, 2, delayTime, cellIndex, self.cardId)
            delayTime = delayTime + GlobalArtConfig.CellsSignAnimIntervalOnBingo
        end)

        delayTime = delayTime + GlobalArtConfig.CellsAnimIntervalOnMultiBingo
    end)

    LuaTimer:SetDelayFunction(delayTime, onComplete)
end

return CmdHandleBingoQueue