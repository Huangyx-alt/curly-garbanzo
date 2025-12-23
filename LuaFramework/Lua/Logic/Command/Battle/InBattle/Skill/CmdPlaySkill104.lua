--[[
Descripttion: 海盗玩法，大炮技能
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年9月2日14:59:54
LastEditors: gaoshuai
LastEditTime: 2025年9月2日14:59:54
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandBase
local base = CommandBase
---@class CmdPlaySkill104 : CommandBase
local CmdPlaySkill104 = BaseClass("CmdPlaySkill104", base)
local CommandConst = CommandConst

---OnCmdExecute
---@param args table {skill_id = skill_id,cardId = cardId,cellIndex = cellIndex,powerId = powerId,extraPos = extraPos}
function CmdPlaySkill104:OnCmdExecute(args)
    args = args or {}
    local skill_id, cardId, cellIndex, powerId, extraPos = args.skill_id, args.cardId, args.cellIndex, args.powerId, args.extraPos
    local cardPower = args.cardPower
    local curModel = ModelList.BattleModel:GetCurrModel()
    local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
    local cellObj = cardView:GetCardCell(tonumber(cardId), cellIndex)
    local cardObj = cardView:GetCardMap(cardId)

    local data = Csv.GetData("new_skill", skill_id, "skill_xyz")
    extraPos = {}
    table.walk(data, function(offset)
        local ori_x = math.modf((cellIndex - 1) / 5)
        local ori_y = math.modf((cellIndex - 1) % 5)
        local new_x = ori_x + offset[1]
        local new_y = ori_y - offset[2]
        if new_x >= 0 and new_x <= 4 and new_y >= 0 and new_y <= 4 then
            local new_index = new_x * 5 + new_y + 1
            table.insert(extraPos, new_index)
        end
    end)

    if GetTableLength(extraPos) == 0 then
        return self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end
    
    local signStartDelay, signInterval = 1.1, 0.18
    local root = cardView:GetEffectPlayRoot(cardId, BingoBangEntry.BattleContainerType.PuEffectContainer)
    BattleEffectCache:GetSkillPrefab_BingoBang(cardId, "PirateShipPuSkill", cellObj, 2.5, function(obj)
        if not IsNull(obj) then
            UISound.play("piratecannon")
            
            fun.play_animator(obj, animName, true)
            coroutine.start(function()
                coroutine.wait(signStartDelay)
                table.walk(extraPos, function(signPos, k)
                    coroutine.wait((k - 1) * signInterval)
                    --local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, signPos)
                    --if cellData:IsNotSign() then
                        cardView:OnClickCardIgnoreJudgeByIndex(cardId, signPos, powerId)
                    --end
                    cardPower:ChangeCellState(cardId, cellIndex, cardPower.CellState.Signed)
                end)
                self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
            end)
        else
            self:ExecuteDone(CommandConst.CmdExecuteResult.Fail)
        end
    end)
end

return CmdPlaySkill104