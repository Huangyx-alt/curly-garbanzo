--[[
Descripttion: 引导战斗开始流程
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年9月18日16:15:43
LastEditors: gaoshuai
LastEditTime: 2025年9月18日16:15:43
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

local CmdStartGuideCountDown = require "Logic.Command.Guide.CmdStartGuideCountDown"
local CmdStartEntryEffect = require "Logic.Command.Battle.Enter.StartSequence.CmdStartEntryEffect"
local CmdStartMapEffect = require "Logic.Command.Battle.Enter.StartSequence.CmdStartMapEffect"

---@type CommandBase
local base = CommandBase
---@class CmdStartGuideBattle : CommandBase
local CmdStartGuideBattle = BaseClass("CmdStartGuideBattle", base)

local CommandConst = CommandConst

function CmdStartGuideBattle:OnCmdExecute()
    BingoBangEntry.IsInEnterBattleSequence = true
    
    local sequence = CommandSequence.New({ LogTag = "CmdStartGuideBattle CommandSequence", })
    
    --显示战斗界面
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            --播放音效
            coroutine.start(function()
                local playId = ModelList.CityModel.GetPlayIdByCity()
                local city_music =  Csv.GetData("new_city_play",playId,"music")
                --if ModelList.BattleModel.GetIsJokerMachine() or ModelList.CityModel:IsMaxBetRate() then
                --    city_music =  Csv.GetData("city_play",playId,"maxbet_music")
                --end
                if playId == PLAY_TYPE.PLAY_TYPE_NORMAL then
                    local sceneId = ModelList.CityModel.GetCity()
                    city_music = Csv.GetData("new_city_play_scene", sceneId, "music")
                end
                UISound.play_bgm(city_music)
            end)
            
            --展示BingoLeft、叫号界面、BingoView卡牌入场动画、JackpotView、 
            Event.Brocast(EventName.CardEffect_Enter_Effect, function()
                cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
            end)
            --Facade.SendNotification(NotifyName.Bingo.StartBingosleftIncrease)
        end,
        LogTag = "CmdStartGuideBattle 1",
    }))
    
    --入场表现
    sequence:AddCommand(CmdStartEntryEffect.New({
        LogTag = "CmdStartGuideBattle 2",
    }))

    --入场后格子表现
    sequence:AddCommand(CmdStartMapEffect.New({
        LogTag = "CmdStartGuideBattle 3",
    }))
    
    --倒计时
    sequence:AddCommand(CmdStartGuideCountDown.New({
        LogTag = "CmdStartGuideBattle 4",
    }))

    sequence:AddDoneFunc(function()
        BingoBangEntry.IsInEnterBattleSequence = false
        GlobalBattleMachineList.StartBattleGlobalMachine()
        
        --请求开始战斗
        ModelList.BattleModel:GetCurrModel():ReqGameReady()
        BingoBangEntry.IsInBattle = true
        
        self:ExecuteDone(sequence.executeResult)
    end)

    --开始
    sequence:Execute()
end

return CmdStartGuideBattle