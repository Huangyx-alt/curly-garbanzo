--[[
Descripttion: 
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年10月11日
LastEditors: gaoshuai
LastEditTime: 2025年10月11日
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandBase
local base = CommandBase
---@class CmdShowMissOrPerfect : CommandBase
local CmdShowMissOrPerfect = BaseClass("CmdShowMissOrPerfect", base)
local CommandConst = CommandConst

function CmdShowMissOrPerfect:OnCmdExecute()
    --显示GameSettleView
    local game_ui = fun.GameObject_find("Canvas/GameUI/NormalNode")
    local gameSettleView =  fun.find_child(game_ui,"GameSettleView")
    fun.set_active(gameSettleView, true)
    
    local model = ModelList.BattleModel:GetCurrModel()
    local settleData = model:GetSettleData()
    if not settleData then
        self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        return
    end
    
    --判断是否PerfectDaub
    local roundData = model:GetRoundData()
    local totalNumber = model:GetCalledNumber()
    local IsPerfectDaub, totalDaubCount, missCells = true, 0, {}
    local daubInfo = {} -- 用于数据上传
    table.walk(roundData, function(cardData, cardID)
        --记录SDK上报数据
        local key = string.format("card%s", cardID)
        BingoBangEntry.MissNumberList[key] = BingoBangEntry.MissNumberList[key] or {}
        
        table.walk(cardData.cards, function(cellData, cellIndex)
            if cellData.sign == 0 then
                if table.keyof(totalNumber, cellData.num) then
                    IsPerfectDaub = false
                    table.insert(missCells, cellData)
                    table.insert(BingoBangEntry.MissNumberList[key], cellData.num)
                elseif cellData.double_num > 0 and table.keyof(totalNumber, cellData.double_num) then
                    IsPerfectDaub = false
                    table.insert(missCells, cellData)
                    table.insert(BingoBangEntry.MissNumberList[key], cellData.double_num)
                end
            else
                totalDaubCount = totalDaubCount + 1
                if cellData.mark == 1 then
                    table.insert(daubInfo, {
                        card = cardID,
                        coordinate = cellIndex,
                        time = cellData:GetDaubTime(),
                    })
                end
            end
        end) 
    end)
    IsPerfectDaub = IsPerfectDaub and totalDaubCount > 0
    
    local refer = fun.get_component(gameSettleView, fun.REFER)
    local PerfectDaub = refer:Get("PerfectDaub")
    coroutine.start(function()
        --卡面动画
        Event.Brocast(EventName.CardEffect_Exit_To_LuckyBang_Effect)
        coroutine.wait(0.8)

        if IsPerfectDaub then
            fun.set_active(PerfectDaub, true)
            UISound.play("perfectdaub")
        else
            table.walk(missCells, function(cell)
                local cellRefer = fun.get_component(cell.obj, fun.REFER)
                local RoundOverMiss = cellRefer:Get("RoundOverMiss")
                fun.set_active(RoundOverMiss, true)
            end)
        end

        coroutine.wait(2)
        self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end)

    --对局结束，上报事件
    --1、bingo对局中pu行为，对局结束上报
    local powerUpView = ModelList.BattleModel:GetCurrBattleView():GetPowerUpView()
    local pudeliver, puused, publockindex, publockname, pudiamondcost, puischarged = powerUpView:GetReportData()
    SDK.BI_Event_Tracker("bingo_pu_action", {
        gameid = ModelList.BattleModel:GetCurrModel():GetGameId(),
        uid = ModelList.PlayerInfoModel:GetUid(),
        level = ModelList.PlayerInfoModel:GetLevel(),
        pudeliver = pudeliver,          --本局下发的 PU 数量
        puused = puused,                --本局已使用 PU 数量
        publockindex = publockindex,    --卡在第几个 PU
        publockname = publockname,      --被卡住的 PU 名称 / ID
        pudiamondcost = pudiamondcost,  --PU 的钻石兑换价
        puischarged = puischarged,      --是否已充能完毕
        balance = {
            [1] = ModelList.ItemModel.get_diamond(),
            [2] = ModelList.ItemModel.get_coin(),
        },
    })

    --2、对局结束后上报玩家整局涂抹格子信息
    SDK.BI_Event_Tracker("daub_time_info", {
        playtype = ModelList.PlayerInfoModel:GetLevel(),
        level = ModelList.PlayerInfoModel:GetLevel(),
        choosecard = ModelList.BattleModel:GetCurrModel():GetCardCount(),   --选择bingo卡片数
        daubinfo = daubInfo,        --上报玩家对局内【手动涂抹】的格子信息，包含格子坐标和涂抹用时
        --    card = {                    --2卡卡片编号：左1，右2;4卡卡片编号：左上1，右上2，左下3，右下4
        --        [1] = {},
        --        [1] = {},
        --        [1] = {},
        --        [1] = {},
        --    },                   
        --    coordinate = 1,             --玩家手动涂抹的格子下标，按顺序
        --    time = 1,                   --从出球到玩家手动涂抹对应数字格子的用时，至少要到小数点后两位
    })
end

return CmdShowMissOrPerfect