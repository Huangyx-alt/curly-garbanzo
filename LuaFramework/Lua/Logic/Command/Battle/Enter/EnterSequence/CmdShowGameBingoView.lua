--[[
Descripttion: 显示战斗界面
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年7月16日15:22:42
LastEditors: gaoshuai
LastEditTime: 2025年7月16日15:22:42
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandBase
local base = CommandBase
---@class CmdShowGameBingoView : CommandBase
local CmdShowGameBingoView = BaseClass("CmdShowGameBingoView", base)

local CommandConst = CommandConst
local private = {}

function CmdShowGameBingoView:OnCmdExecute()
    local count = ModelList.BattleModel:GetCurrModel():GetCardCount()
    local onlyShow2Card = fun.read_value(BingoBangEntry.selectGameCardNumString, BingoBangEntry.selectGameCardNum.FourCard)
    onlyShow2Card = onlyShow2Card == BingoBangEntry.selectGameCardNum.TwoCard
    
    local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    local gameBingoView =  fun.find_child(game_ui,"GameBingoView")
    if count == 4 and not onlyShow2Card then
        gameBingoView =  fun.find_child(game_ui,"GameBingoView_FourCard")
    end
    
    --隐藏GameSettleView
    local gameSettleView =  fun.find_child(game_ui,"GameSettleView")
    fun.set_active(gameSettleView, false)
    
    local modelBingoView = ModelList.BattleModel:GetCurrBattleView()
    Facade.SendNotification(NotifyName.SkipLoadShowUI, modelBingoView, gameBingoView, nil, function(go)
        self:SetCellPartLayer(go)
        LuaTimer:SetDelayFunction(0.5, function()
            self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end)
    end)
end

--移动格子子物体到场景中的指定层级
local Type = { "B", "I", "N", "G", "O" }
function CmdShowGameBingoView:SetCellPartLayer(go)
    local refer = fun.get_component(go, fun.REFER)
    for i = 1, 6 do
        local map = refer:Get("BingoMap" .. i)
        if map then
            local mapRefer = fun.get_component(map, fun.REFER)
            local CellPartContainer = mapRefer:Get("CellPartContainer")
            local CellBgRoot = mapRefer:Get("CellBgRoot")
            
            --创讲一个新的root，用于放collider
            local colliderRoot = fun.get_instance(CellBgRoot, CellBgRoot.transform.parent)
            colliderRoot.transform.localScale = Vector3.one
            colliderRoot.transform.localPosition = Vector3.zero
            colliderRoot.name = string.format("%s%s", "CellColliderRoot", i)
            fun.eachChild(colliderRoot, function(child)
                Destroy(child)
            end)
            
            table.walk(Type, function(t)
                for j = 1, 5 do
                    local cellName = t .. j
                    local cell = mapRefer:Get(cellName)
                    local cellRefer = fun.get_component(cell, fun.REFER)
                    
                    local bg_tip = cellRefer:Get("bg_tip")
                    local root1 = fun.find_child(CellBgRoot, cellName)
                    fun.set_parent(bg_tip, root1)

                    local gift_parent = cellRefer:Get("gift_parent")
                    local root2 = fun.find_child(CellPartContainer, "GiftRoot/" .. cellName)
                    fun.set_parent(gift_parent, root2)

                    local Wish = cellRefer:Get("Wish")
                    local root3 = fun.find_child(CellPartContainer, "WishRoot/" .. cellName)
                    fun.set_parent(Wish, root3)

                    local number = cellRefer:Get("number_root")
                    local root4 = fun.find_child(CellPartContainer, "NumberRoot/" .. cellName)
                    fun.set_parent(number, root4)                    
                    
                    local effect = cellRefer:Get("bingo")
                    local RoundOverMiss = cellRefer:Get("RoundOverMiss")
                    local root5 = fun.find_child(CellPartContainer, "EffectRoot/" .. cellName)
                    fun.set_parent(effect, root5)                    
                    fun.set_parent(RoundOverMiss, root5)                    
                    
                    local collider = cellRefer:Get("collider")
                    fun.set_parent(collider, colliderRoot)
                    collider.name = cellName
                end
            end)
        end
    end
end

return CmdShowGameBingoView