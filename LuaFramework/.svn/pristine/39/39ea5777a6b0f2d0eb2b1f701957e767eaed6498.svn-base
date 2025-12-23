--[[
Descripttion: 进战斗加载资源
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年7月8日 15:38:28
LastEditors: gaoshuai
LastEditTime: 2025年7月8日 15:38:28
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandBase
local base = CommandBase
---@class CmdLoadCommonBattleRes : CommandBase
local CmdLoadCommonBattleRes = BaseClass("CmdLoadCommonBattleRes", base)

local CommandConst = CommandConst
local private = {}

function CmdLoadCommonBattleRes:OnCmdExecute()
    local sequence = CommandSequence.New({ LogTag = "CmdLoadCommonBattleRes CommandSequence", })

    --1、卸载大厅资源
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            --卸载大厅资源
            local lobby = require("Logic.Bundle.UnloadLobbyBundle")
            lobby:StartUnload()
            --卸载大厅音效
            UISound.unload_sound_data_in_need(1)
            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end,
        LogTag = "CmdLoadCommonBattleRes 1",
    }))

    --2、加载通用战斗音效
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            UISound.load_machine_and_commonUI_res()
            UISound.stop_bgm()
            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end,
        LogTag = "CmdLoadCommonBattleRes 2",
    }))    
    
    --3、加载通用战斗资源
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            AssetManager.unload_lobby_res_for_enter_game()
            
            --通过配置表（new_game_bingo_view）加载模块所需图集
            AssetManager.load_game_res()

            --通用战斗图集
            Cache.Load_Atlas(AssetList["BingoBangBattleAtlas"], "BingoBangBattleAtlas")
            Cache.Load_Atlas(AssetList["BingoBangSettleAtlas"], "BingoBangSettleAtlas")
            
            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end,
        LogTag = "CmdLoadCommonBattleRes 3",
    }))    
    
    sequence:AddDoneFunc(function()
        self:ExecuteDone(sequence.executeResult)
    end)

    --开始
    sequence:Execute()
end

return CmdLoadCommonBattleRes