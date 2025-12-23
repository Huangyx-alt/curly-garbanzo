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
---@class CmdShowLuckyBang : CommandBase
local CmdShowLuckyBang = BaseClass("CmdShowLuckyBang", base)
local CommandConst = CommandConst

function CmdShowLuckyBang:OnCmdExecute()
    local model = ModelList.BattleModel:GetCurrModel()
    local settleData = model:GetSettleData()
    if not settleData then
        self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        return
    end
    
    local roundData, IsAllCardForbid = model:GetRoundData(), true
    table.walk(roundData, function(cardData)
        if not cardData:GetForbid() then
            IsAllCardForbid = false
        end
    end)
    --是否有LuckyBang
    local HasLuckyBang = model:CheckHasLuckyBang()
    if not IsAllCardForbid and HasLuckyBang then
        local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
        local view = fun.find_child(game_ui, "GameSettleView/SettleLuckyBang")
        ViewList.SettleLuckyBangView:SkipLoadShow(view, true, nil, {
            OnComplete = function()
                self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
            end
        })
    else
        self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end
end

return CmdShowLuckyBang