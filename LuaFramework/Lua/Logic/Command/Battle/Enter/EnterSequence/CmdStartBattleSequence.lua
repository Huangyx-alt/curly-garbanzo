--[[
Descripttion: 战斗开始流程
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年7月8日 15:38:28
LastEditors: gaoshuai
LastEditTime: 2025年7月8日 15:38:28
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

local CmdStartCountDown = require "Logic.Command.Battle.Enter.StartSequence.CmdStartCountDown"
local CmdStartEntryEffect = require "Logic.Command.Battle.Enter.StartSequence.CmdStartEntryEffect"
local CmdStartMapEffect = require "Logic.Command.Battle.Enter.StartSequence.CmdStartMapEffect"

---@type CommandBase
local base = CommandBase
---@class CmdStartBattleSequence : CommandBase
local CmdStartBattleSequence = BaseClass("CmdStartBattleSequence", base)

local CommandConst = CommandConst

function CmdStartBattleSequence:OnCmdExecute()
    local sequence = CommandSequence.New({ LogTag = "CmdStartBattleSequence CommandSequence", })
    
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
                WaitForFixedUpdate()
                UISound.set_bgm_volume(0.7)
                WaitForEndOfFrame()
                UISound.max_fade_in_bgm()
            end)

            ModelList.BattleModel:GetCurrBattleView():PlayBackgroundAction("Bg", true)
            
            --展示BingoLeft、叫号界面、BingoView卡牌入场动画、JackpotView、 
            Event.Brocast(EventName.CardEffect_Enter_Effect, function()
                cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
            end)
            --Facade.SendNotification(NotifyName.Bingo.StartBingosleftIncrease)
        end,
        LogTag = "CmdStartBattleSequence 1",
    }))
    
    --界面入场表现
    sequence:AddCommand(CmdStartEntryEffect.New({
        LogTag = "CmdStartBattleSequence 2",
    }))

    --入场后卡牌表现
    sequence:AddCommand(CmdStartMapEffect.New({
        LogTag = "CmdStartBattleSequence 3",
    }))
    
    --倒计时
    sequence:AddCommand(CmdStartCountDown.New({
        LogTag = "CmdStartBattleSequence 4",
    }))

    sequence:AddDoneFunc(function()
        self:ExecuteDone(sequence.executeResult)
    end)

    --开始
    sequence:Execute()

    --readyView倒计时结束，开始战斗StartSequence
    --1、展示BingoLeft、叫号界面、BingoView卡牌入场动画、JackpotView、 
    ----展示时机：在ReadyView倒计时为2时开始
    ----开始展示接口：Event.Brocast(EventName.CardEffect_Enter_Effect)           
    --2、分三步：powerup卡牌展示(一)、之后展示卡包开场动画，卡包飞行到卡牌右上角(二)、展示小丑卡入场(三)、展示小丑卡翻牌(四)
    ----展示时机：在ReadyView倒计时为2后，再延迟0.7s时
    ----powerup卡牌展示：Event.Brocast(Notes.START_POWERUP_ENABLE)，(这一步包含一个放大镜效果展示：Event.Brocast(Notes.START_MIRROR_CHECK))
    ------展示卡包：Event.Brocast(EventName.Event_Game_Open_Card_Pack_Enter)
    --------小丑卡入场：Event.Brocast(EventName.Enter_Play_First_Joker_Card)
    ----------小丑卡翻牌：Event.Brocast(EventName.Enter_Play_Joker_Card,nil)
    --3、展示格子上的道具
    ----展示时机：在ReadyView倒计时为1时开始
    ----开始展示接口：Event.Brocast(EventName.CardEffect_Drop_All_Cell_Item)
    --4、Bingo效果预加载(达成Bingo后播放的效果)
    --Event.Brocast(EventName.Event_Preload_Bingo_Effect)
    --5、请求战斗开始
    --self:GetModel():ReqGameReady()

    --标识1：Readview倒计时结束
    --标识2和6：powerup卡牌界面展示  
    ----展示时机：步骤二(1)
    ----开始展示接口：Event.Brocast(Notes.START_POWERUP_ENABLE)
    --标识5：卡牌角标特效 
    ----展示时机：步骤二(2)
    ----开始展示接口：Event.Brocast(Notes.START_PLAY_CARD_REWARD)          
    --标识7：杯赛活动开启时，在开场时展示活动开启效果   
    ----展示时机：步骤三：CardLoad:StartDropCellItemEffect(播放格子上的道具出现动画)中，所有格子的道具都显示出来后
    ----开始展示接口：Event.Brocast(EventName.Competition_battle_start_effect)
    --标识8：小丑卡活动开启时，在开场时展示小丑卡翻牌效果:clown
    ----展示时机：步骤二(3)
    ----开始展示接口：Event.Brocast(EventName.Enter_Play_Joker_Card,nil)
    --标识9：小丑卡活动开启时，在开场时展示小丑卡入场效果:clown01   
    ----展示时机：步骤二(3)
    ----开始展示接口：Event.Brocast(EventName.Enter_Play_First_Joker_Card)
    --标识10：展示卡包入场动画，然后卡包飞行到卡牌右上角
    ----展示时机：步骤二(2)
    ----开始展示接口：Event.Brocast(EventName.Event_Game_Open_Card_Pack_Enter)
end

return CmdStartBattleSequence