--[[
Descripttion: 结算流程结束
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
---@class CmdBattleSettleEnd : CommandBase
local CmdBattleSettleEnd = BaseClass("CmdBattleSettleEnd", base)
local CommandConst = CommandConst

function CmdBattleSettleEnd:OnCmdExecute()
    BingoBangEntry.BingoQueue = {}
    BingoBangEntry.BingoExecuteFlag = {}
    
    local sequence = CommandSequence.New({ LogTag = "CmdBattleSettleEnd Sequence", })
    local isFirstBattle = ModelList.GuideModel.IsFirstBattle()
    
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            local curModel = ModelList.BattleModel:GetCurrModel()
            curModel:Clear()
            AssetManager.unload_ab_on_game_over()
            UISound.unload_machine_res()
            Event.Brocast(Notes.QUIT_BATTLE)
            
            Facade.SendNotification(NotifyName.ShowDialog,ViewList.BattleLoadingView, nil, function()
                --等loading界面显示之后再请求
                LuaTimer:SetDelayFunction(0.5, function()
                    cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                end)
            end)
        end,
        LogTag = "CmdBattleSettleEnd 1",
    }))    
    
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            -- InitBlackCamera()
            SoundHelper.UnloadAllAudio()
            SceneViewManager.ClearView()

            local UnloadLobbyBundle = require("Logic.Bundle.UnloadLobbyBundle")
            if UnloadLobbyBundle then
                UnloadLobbyBundle:StopUnload()
            end
            local lobby = require("Logic.Bundle.UnloadBattleBundle")
            if lobby then
                lobby:StartUnload(true, true)
                --for i = 1, #lobby.other do
                --    resMgr:UnloadAssetBundle(lobby.other[i], isThorough,isForce)
                --end
                --for i = 1, #lobby.atlas do
                --    resMgr:UnloadAssetBundle(lobby.atlas[i], isThorough,isForce)
                --end
            end

            UISound.unload_sound_data_in_need(2)
            Util.ClearMemory()
            
            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end,
        LogTag = "CmdBattleSettleEnd 2",
    }))    
    
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            LoadSceneAsync("SceneHome", ProcedureCityHome:New(),function(operation)
                LuaTimer:Clear(LuaTimer.TimerType.Battle)
                LuaTimer:Clear(LuaTimer.TimerType.BattleUI)
                
                if isFirstBattle then
                    --引导结束返回玩法大厅
                    CityHomeScene:Change2NormalLobby()
                end
                
                --加载通用ab资源
                AssetManager.load_common_res(function()
                    --加载大厅资源和音效
                    AssetManager.load_lobby_res(function()
                        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                        
                        LuaTimer:SetDelayFunction(1, function()
                            Facade.SendNotification(NotifyName.HideDialog, ViewList.BattleLoadingView)
                            BingoBangEntry.LastEndBattleTime = os.time()
                        end)
                    end)
                end)
            end, true)
        end,
        LogTag = "CmdBattleSettleEnd 3",
    }))

    --结束
    sequence:AddDoneFunc(function()
        self:ExecuteDone(sequence.executeResult)
    end)
    --开始
    sequence:Execute()
end

return CmdBattleSettleEnd