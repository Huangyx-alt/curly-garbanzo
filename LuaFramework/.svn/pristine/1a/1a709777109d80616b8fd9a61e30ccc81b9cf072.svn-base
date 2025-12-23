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
---@class CmdShowCoinSettle : CommandBase
local CmdShowCoinSettle = BaseClass("CmdShowCoinSettle", base)
local CommandConst = CommandConst

function CmdShowCoinSettle:OnCmdExecute()
    Event.Brocast(EventName.SoundMachine_Stop_City_Music, false)
    
    local model = ModelList.BattleModel:GetCurrModel()
    local settleData = model:GetSettleData()
    if not settleData then
        self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        return
    end
    
    --停止Bingoview界面的update
    Event.Brocast(EventName.Event_stop_bingo_game)
    
    local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    local view = fun.find_child(game_ui, "GameSettleView/SettleCoinReward")
    --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.SettleCoinRewardView, view)
    ViewList.SettleCoinRewardView:SkipLoadShow(view, true, nil, {
        OnComplete = function(totalCoinReward)
            self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end
    })

    --对局数据上报
    local publishNumbers = model:LoadGameData().publishNumbers
    local missNumber, totalPublishNumber = {}, GetTableLength(publishNumbers)
    local firstMissData, allMissData = 0, {}
    table.walk(BingoBangEntry.MissNumberList, function(list, k)
        missNumber[k] = GetTableLength(list)
    end)
    table.walk(publishNumbers, function(number, k)
        table.walk(BingoBangEntry.MissNumberList, function(list)
            local key = table.keyof(list, number)
            if key then
                table.insert(allMissData, k)
                if firstMissData == 0 then
                    firstMissData = k / totalPublishNumber
                end
            end
        end)
    end)
    allMissData = fun.table_unique(allMissData)
    local avgMissData, allMissStr = 0
    table.walk(allMissData, function(k)
        local v = k / totalPublishNumber
        if not allMissStr then
            allMissStr = v
        else
            allMissStr = string.format("%s|%s", allMissStr, v)
        end
        avgMissData = avgMissData + v
    end)
    avgMissData = avgMissData / GetTableLength(allMissData)

    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    local powerUpView = bingoView:GetPowerUpView()
    local cardCount = ModelList.BattleModel:GetCurrModel():GetCardCount()
    local onlyShow2Card = fun.read_value(BingoBangEntry.selectGameCardNumString, BingoBangEntry.selectGameCardNum.FourCard)
    SDK.BI_Event_Tracker("bingo_play", {
        bingobangs = BingoBangEntry.LuckyBangTriggerBingoCount,  --触发新增的bingo数（若未使用bang则上报0）
        cardshow = cardCount == 4 and onlyShow2Card or 0,  --4卡对局，根据设置内的选项上报，单面展示4卡：4，单面展示2卡：2
        manualdaub = BingoBangEntry.ManualDaubCount, --玩家手动涂抹的格子个数（不包括pu自动释放涂抹的格子）
        autodaub = BingoBangEntry.DaubPowerDaubCount, --使用autodaub功能，涂抹的格子个数
        missnumber = missNumber, --玩家在对局中漏掉涂抹的数量，如 {1:3, 2:1, 3:0, 4:2}；对象属性，包含以下4个
        firstmissposition = firstMissData, --首个漏号在叫号序列中的相对位置（例：0.73，表示在 73% 处）
        misspositions = allMissStr, --记录漏号的号码，在叫号队列中的相对位置（例：共10个叫号，在第一个叫号漏号，和倒数第二个漏号，上报"0.10|0.90|"），保留两位小数
        avgmissposition = avgMissData, --各漏号相对位置相加，除以漏号数（例："(0.10+0.90)/2=0.50）
        autocards = powerUpView:IsOpenAutoUse(), --结算时是否开启autoCards按钮
        magnifier = bingoView.is_open_magnifier, --是否有放大镜
    })
end

return CmdShowCoinSettle