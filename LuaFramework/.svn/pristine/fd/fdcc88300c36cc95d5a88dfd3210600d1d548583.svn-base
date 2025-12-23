--[[
Descripttion: 结算周榜
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
---@class CmdShowTournament : CommandBase
local CmdShowTournament = BaseClass("CmdShowTournament", base)
local CommandConst = CommandConst

function CmdShowTournament:OnCmdExecute()
    if ModelList.TournamentModel:IsActivityAvailable() then
        if ModelList.TournamentModel:IsTrouamentClimbRank() and ModelList.TournamentModel:IsClimbToUp() then
            --记录更新前数据
            local lastWeekScore = ModelList.TournamentModel:GetMayRankScore()
            local lastWeekRankInfo = ModelList.TournamentModel:GetMyRankInfo()
            local lastWeekTier = ModelList.TournamentModel:GetTierByScore(lastWeekScore)
            
            --请求周榜积分信息
            ModelList.TournamentModel:C2S_RequestTournamentRankInfo(false, function()
                local tier = ModelList.TournamentModel:GetTiers()
                local isUpTier = lastWeekTier < tier
                local oldScore = lastWeekScore
                if isUpTier or ModelList.TournamentModel:CheckHasStateAward() then
                    log.g("recive data OnResphoneTournamentInfo 2 TournamentScoreView")
                    Facade.SendNotification(NotifyName.ShowUI, ViewList.TournamentScoreView, function ()
                        --关闭SettleDetail
                    end, false, {
                        callBack = function ()
                            self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                        end,
                        isUpTier = isUpTier,
                        oldScore = oldScore,
                        lastWeekTier = lastWeekTier,
                        isSettle = true,
                        lastWeekRankInfo = lastWeekRankInfo
                    })
                else
                    local viewName = ""
                    if ModelList.TournamentModel:CheckIsBlackGoldUser() then
                        viewName = "TournamentBlackGoldSettleView"
                    else
                        viewName = "TournamentSettleView"
                    end
                    Facade.SendNotification(NotifyName.ShowUI, ViewList[viewName], function ()
                        --关闭SettleDetail
                    end, false, function ()
                        self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                    end)
                end
            end)
            return
        end
    end

    self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
end

return CmdShowTournament