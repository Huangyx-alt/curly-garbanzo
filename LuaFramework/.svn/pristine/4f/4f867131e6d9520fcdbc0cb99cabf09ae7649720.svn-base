--[[
Descripttion: 
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年9月1日17:19:42
LastEditors: gaoshuai
LastEditTime: 2025年9月1日17:19:42
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

local BingoSettleDetailView = require "View.Bingo.SettleModule.UIView.SettleDetail.BingoSettleDetailView"
local PirateShipSettleDetailView = BingoSettleDetailView:New('PirateShipSettleDetailView')
local this = PirateShipSettleDetailView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "Root",
    "btn_continue",
    "FinalRewardsRoot",
    "FinalRewardTemp",
    "NormalRewardsRoot",
    "ActivityRewardsRoot",
    "BoxRewardsRoot",
    "BoxRewardTemp",
    "BoxRewardContent",
    "BoxContainerTemp",
    "TotalReward",
    "TotalRewardText",
    "DoubleRewardsRoot",
    "DoubleRewardsContent",
    "DoubleRewardsTemp",
    "TotalRewardFlyTarget",
    "anim",
    "MiniGameRoot",
    "Slider",
    "HaveCount",
    "ProgressText",
    "MiniGameAnim",
    "ticket_image",
    "chip_image",
}

this.MiniGamID = 1

function PirateShipSettleDetailView:OnDisable()
    BingoSettleDetailView.OnDisable(self)
    self.newCount = 0
end

function PirateShipSettleDetailView:InitPuzzleShow()
    
end

function PirateShipSettleDetailView:InitOthers()
    --local miniGameCfg = Csv.GetData("new_minigame", this.MiniGamID)
    --if not miniGameCfg then
    --    return
    --end
    --local chipItemID, ticket_id = miniGameCfg.chip_need[1], miniGameCfg.ticket_id
    
    
    local data = ModelList.MiniGameModel:GetMiniGameDataByGameId(this.MiniGamID)
    local gameInfo = data and data.gameInfo
    if gameInfo then
        local chipCfg = Csv.GetData("new_item", gameInfo.chipId)
        self.chip_image.sprite = AtlasManager:GetSpriteByName("BingoBangItemAtlas", chipCfg.icon)

        local ticketCfg = Csv.GetData("new_item", gameInfo.ticket.id)
        self.ticket_image.sprite = AtlasManager:GetSpriteByName("BingoBangItemAtlas", ticketCfg.icon)
        
        local allItemReward, newCount = self.settleData and self.settleData.allItemReward, 0
        --指定位置拼图解锁
        table.walk(allItemReward, function(v)
            if v.id == gameInfo.chipId then
                newCount = v.value
            end
        end)
        self.newCount = newCount

        if gameInfo.progress - newCount < 0 then
            --本次进度会加满
            local cur, max = gameInfo.target - gameInfo.progress + newCount, gameInfo.target
            self.Slider.fillAmount = cur / max
            self.ProgressText.text = string.format("%s%s", math.floor(cur / max * 100), "%")
            self.HaveCount.text = gameInfo.ticket.value - 1
        else
            local cur, max = gameInfo.progress - newCount, gameInfo.target
            self.Slider.fillAmount = cur / max
            self.ProgressText.text = string.format("%s%s", math.floor(cur / max * 100), "%")
            self.HaveCount.text = gameInfo.ticket.value
        end
    end
end

function PirateShipSettleDetailView:StartFinalSequence(cmd)
    --local miniGameCfg = Csv.GetData("new_minigame", this.MiniGamID)
    --if not miniGameCfg then
    --    return cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    --end
    
    --解锁拼图表现流程
    --小游戏收集进度
    local data = ModelList.MiniGameModel:GetMiniGameDataByGameId(1)
    local gameInfo = data and data.gameInfo
    if gameInfo and self.newCount > 0 then
        fun.play_animator(self.MiniGameAnim, "shou")
        UISound.play("minigamechips")
        
        LuaTimer:SetDelayFunction(1.25, function()
            if gameInfo.progress - self.newCount < 0 then
                --本次进度会加满
                local curValue = self.Slider.fillAmount
                local targetValue = gameInfo.progress / gameInfo.target
                Anim.do_smooth_float_update(curValue, 1, 0.1, function(temp)
                    self.Slider.fillAmount = temp
                    self.ProgressText.text = string.format("%s%s", math.floor(temp * 100), "%")
                end, function()
                    self.Slider.fillAmount = 1
                    self.ProgressText.text = string.format("%s%s", math.floor(1 * 100), "%")
                    --接着涨
                    Anim.do_smooth_float_update(0, targetValue, 0.2, function(temp)
                        self.Slider.fillAmount = temp
                        self.ProgressText.text = string.format("%s%s", math.floor(temp * 100), "%")
                    end, function()
                        self.Slider.fillAmount = 1
                        self.ProgressText.text = string.format("%s%s", math.floor(targetValue * 100), "%")
                        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                    end)
                end)
            else
                local curValue = self.Slider.fillAmount
                local targetValue = gameInfo.progress / gameInfo.target
                --播放进度条动画
                Anim.do_smooth_float_update(curValue, targetValue, 0.3, function(temp)
                    self.Slider.fillAmount = temp
                    self.ProgressText.text = string.format("%s%s", math.floor(temp * 100), "%")
                end, function()
                    self.Slider.fillAmount = targetValue
                    self.ProgressText.text = string.format("%s%s", math.floor(targetValue * 100), "%")
                    cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                end)
            end
        end)
    else
        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end
end

return this