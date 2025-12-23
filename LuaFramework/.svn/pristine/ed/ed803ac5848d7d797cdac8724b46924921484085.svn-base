--[[
Descripttion: 
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
---@class CmdShowSettleDetail : CommandBase
local CmdShowSettleDetail = BaseClass("CmdShowSettleDetail", base)
local CommandConst = CommandConst

function CmdShowSettleDetail:OnCmdExecute()
    local model = ModelList.BattleModel:GetCurrModel()
    local settleData = model:GetSettleData()
    if not settleData then
        self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        return
    end
    
    local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    local view = fun.find_child(game_ui, "GameSettleView/SettleDetail")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.SettleCoinRewardView, view)

    local playId = ModelList.CityModel.GetPlayIdByCity()
    local cfg = Csv.GetData("new_game_mode", playId)
    local viewName = cfg.settledetailview or "BingoSettleDetailView"
    local path = string.format("View.Bingo.SettleModule.UIView.SettleDetail.%s", viewName)
    local View = require(path)
    if View then
        View:SkipLoadShow(view, true, nil, {
            OnComplete = function()
                self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
            end
        })
    else
        self:ExecuteDone(CommandConst.CmdExecuteResult.Fail)
    end
end

return CmdShowSettleDetail