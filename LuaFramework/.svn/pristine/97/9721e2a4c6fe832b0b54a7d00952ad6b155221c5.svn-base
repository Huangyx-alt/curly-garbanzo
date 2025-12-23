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

local SettleCoinRewardView = BaseView:New('SettleCoinRewardView','BingoBangSettleAtlas')
local this = SettleCoinRewardView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "WinTip",
    "GigWinTip",
    "WinRewardText",
    "BigWinRewardText",
    "TotalReward",
    "TotalRewardText",
    "TotalRewardFlyTarget",
    "CardEffect",
    "BingoFly",
    "BingoFlyText",
    "Mask",
}

function SettleCoinRewardView.Awake(obj)
    this:on_init()
end

function SettleCoinRewardView:OnEnable(options)
    this.options = options or {}
    
    this:RegisterEvent()
    this.model = ModelList.BattleModel:GetCurrModel()
    this.settleData = this.model:GetSettleData()
    this:ShowView()
end

function SettleCoinRewardView:OnDisable()
    this.options = {}
    this:UnRegisterEvent()
end

function SettleCoinRewardView.OnDestroy()
    this:Destroy()
end

function SettleCoinRewardView:RegisterEvent()
    --Event.AddListener(EventName.Event_Upload_Game_Settle_Data,this.HasUploadSettleData)
end

function SettleCoinRewardView:UnRegisterEvent()
    --Event.RemoveListener(EventName.Event_Upload_Game_Settle_Data,this.HasUploadSettleData)
end

function SettleCoinRewardView:ShowView()
    this.totalCoinReward = 0
    this.TotalRewardText.text = 0
    this.BingoFlyText.text = 0
    fun.set_active(this.BingoFly, false)
    
    coroutine.start(function()
        Event.Brocast(EventName.CardEffect_Exit_To_Settle_Effect)
        
        --coroutine.wait(0.66)
        fun.set_active(this.TotalReward, true)
        
        coroutine.wait(2)
        
        this.curModel = ModelList.BattleModel:GetCurrModel()
        this.settleData = this.curModel and this.curModel:GetSettleData()
        this.rewardInfo = this.settleData and this.settleData.cardReward
        if not this.rewardInfo then
            fun.SafeCall(this.options.OnComplete)
            return
        end

        this:MoveCardEffect()
        this:StartSequence()
    end)
end

--将预制的效果放到卡牌的位置上
function SettleCoinRewardView:MoveCardEffect()
    this.cardEffectList = {}
    local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
    
    table.walk(this.rewardInfo, function(v)
        local cardEffectTemp = fun.find_child(this.CardEffect, string.format("SettleCardEffect%s", v.cardId))
        if not IsNull(cardEffectTemp) then
            local cardObj = cardView:GetCardMap(v.cardId)
            fun.set_active(cardEffectTemp, true)
            fun.set_same_position_with(cardEffectTemp, cardObj)
            
            this.cardEffectList[v.cardId] = cardEffectTemp
        end
    end)
end

function SettleCoinRewardView:StartSequence()
    --流程
    local sequence = CommandSequence.New({ LogTag = "SettleCoinRewardView Sequence ", })
    --盖章奖励
    sequence:AddFunctionCommand(this.ShowDaubCoins, { LogTag = "SettleCoinRewardView 1", })
    sequence:AddFunctionCommand(this.ShowBingoCoins, { delayExecuteTime = 0.5, LogTag = "SettleCoinRewardView 2", })
    sequence:AddFunctionCommand(this.PlayRewardFinal, { delayExecuteTime = 0.5, LogTag = "SettleCoinRewardView 3", })
    sequence:AddDoneFunc(this.OnShowComplete)
    sequence:Execute()
end

function SettleCoinRewardView.ShowDaubCoins(cmd)
    local sourNum = this.totalCoinReward
    local totalCount = GetTableLength(this.rewardInfo)
    local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()

    if totalCount == 0 then
        return cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end
    
    local isPlayedSound = false
    table.walk(this.rewardInfo, function(v)
        local cardID, daubCoins = v.cardId, v.daubCoins
        if daubCoins > 0 then
            if not isPlayedSound then
                UISound.play("settlementadd")
                isPlayedSound = true
            end
            
            local cardEffect = this.cardEffectList[cardID]
            local effectRefer = fun.get_component(cardEffect, fun.REFER)
            local Daub = effectRefer:Get("Daub")
            local daubImage = effectRefer:Get("daubImage")
            local daubNum = effectRefer:Get("daubNum")

            --盖章数量
            local data, daubCount = ModelList.BattleModel:GetCurrModel():GetRoundData(cardID), 0
            table.walk(data.cards, function(cellData)
                local defaultCellAnimOrder = cardView:GetDefaultCellAnimOrder(cardID, cellData.index)
                if not defaultCellAnimOrder and cellData.sign > 0 then
                    daubCount = daubCount + 1
                end
            end)
            daubNum.text = "X" ..fun.formatNum(daubCount)

            fun.set_active(Daub, true)
            LuaTimer:SetDelayFunction(1, function()
                fun.play_animator(Daub, "Fly", true)
                --曲线运动
                local bezierPath, startPos, targetPos = {}, fun.get_gameobject_pos(Daub.gameObject), fun.get_gameobject_pos(this.TotalRewardFlyTarget.gameObject)
                bezierPath[1] = fun.calc_new_position_between(startPos, targetPos, -1.5, 1, 0)
                bezierPath[2] = targetPos
                Anim.bezier_move(Daub.gameObject, bezierPath, 0.66, 0, 1, 2, function()
                    fun.set_active(Daub, false)
                    
                    --全部飞行结束
                    totalCount = totalCount - 1
                    if totalCount <= 0 then
                        --加总金币数值
                        fun.play_animator(this.TotalReward, "act", true)
                        Anim.do_smooth_float_update(sourNum, this.totalCoinReward, 0.2, function(num)
                            this.TotalRewardText.text = fun.format_money(math.floor(num))
                        end, function ()
                            this.TotalRewardText.text = fun.format_money(this.totalCoinReward)
                            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                        end)
                    end
                end)
            end)

            this.totalCoinReward = this.totalCoinReward + daubCoins
        else
            totalCount = totalCount - 1
            if totalCount <= 0 then
                cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
            end
        end
    end)
end

function SettleCoinRewardView.ShowBingoCoins(cmd)
    local sourNum = this.totalCoinReward
    local totalCount = GetTableLength(this.rewardInfo)
    fun.set_active(this.BingoFly, true)
    
    if totalCount == 0 then
        return cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end
    
    local isPlayedSound = false
    table.walk(this.rewardInfo, function(v)
        local cardID, bingoAwards = v.cardId, v.bingoAwards[1]
        local bingoNum, coinReward = bingoAwards.bingoNum, bingoAwards.content
        if bingoNum > 0 then
            if not isPlayedSound then
                UISound.play("settlementadd")
                isPlayedSound = true
            end
            local cardEffect = this.cardEffectList[cardID]
            local effectRefer = fun.get_component(cardEffect, fun.REFER)
            local Bingo = effectRefer:Get("Bingo")
            local BingoImage = effectRefer:Get("BingoImage")

            --Bingo数量
            local imageName = string.format("%sbingoFont", Mathf.Clamp(bingoNum, 1, 5))
            BingoImage.sprite = AtlasManager:GetSpriteByName("BingoBangSettleAtlas", imageName)
            BingoImage:SetNativeSize()
            
            fun.set_active(Bingo, true)
            LuaTimer:SetDelayFunction(1, function()
                fun.play_animator(Bingo, "Fly", true)
                --曲线运动
                local bezierPath, startPos, targetPos = {}, fun.get_gameobject_pos(Bingo.gameObject, false), fun.get_gameobject_pos(this.TotalRewardFlyTarget.gameObject, false)
                bezierPath[1] = fun.calc_new_position_between(startPos, targetPos, -1.5, 1, 0)
                bezierPath[2] = targetPos
                Anim.bezier_move(Bingo.gameObject, bezierPath, 0.66, 0, 1, 2, function()
                    fun.set_active(Bingo, false)
                    --全部飞行结束
                    totalCount = totalCount - 1
                    if totalCount <= 0 then
                        fun.set_active(this.BingoFly, false)
                        --加总金币数值
                        fun.play_animator(this.TotalReward, "act", true)
                        Anim.do_smooth_float_update(sourNum, this.totalCoinReward, 0.2, function(num)
                            this.TotalRewardText.text = fun.format_money(math.floor(num))
                        end, function ()
                            this.TotalRewardText.text = fun.format_money(this.totalCoinReward)
                            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                        end)
                    end
                end)
            end)

            this.totalCoinReward = this.totalCoinReward + coinReward
        else
            totalCount = totalCount - 1
            if totalCount <= 0 then
                fun.set_active(this.BingoFly, false)
                cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
            end
        end
    end)
    
    this.BingoFlyText.text = string.format("+%s", fun.format_money(this.totalCoinReward - sourNum))
end

function SettleCoinRewardView.PlayRewardFinal(cmd)
    this.WinRewardText.text = 0
    this.BigWinRewardText.text = 0
    
    local isWin = this:IsWin()
    local isBigWin = this:IsBigWin()
    fun.set_active(this.WinTip, isWin and not isBigWin)
    fun.set_active(this.GigWinTip, isBigWin)
    
    if not isWin then
        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        return
    end

    UISound.play(isBigWin and "bigwinsound" or "winsound")
    
    local text = isBigWin and this.BigWinRewardText or this.WinRewardText
    Anim.do_smooth_float_update(0, this.totalCoinReward, 3, function(num)
        text.text = fun.format_money(math.floor(num))
    end, function ()
        text.text = fun.format_money(this.totalCoinReward)
        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end)
end

function SettleCoinRewardView:IsWin()
    local buyCardCost = ModelList.BattleModel:GetCurrModel():GetBattleExtraInfo("gamePlaySpend")
    log.r("[SettleCoinRewardView] IsWin buyCardCost:", buyCardCost)
    if not buyCardCost then
        return
    end
    
    return this.totalCoinReward > buyCardCost
    --return this.settleData.chips > buyCardCost
end

function SettleCoinRewardView:IsBigWin()
    local buyCardCost = ModelList.BattleModel:GetCurrModel():GetBattleExtraInfo("gamePlaySpend")
    log.r("[SettleCoinRewardView] IsBigWin buyCardCost:", buyCardCost)
    if not buyCardCost then
        return
    end
    
    local settle_stratify = Csv.GetControlByName("settle_stratify")
    if settle_stratify then
        local settleCoin = this.totalCoinReward
        --local settleCoin = this.settleData.chips
        local getRate = settleCoin/ buyCardCost *100
        if getRate >= settle_stratify[2][1]  and settleCoin>=  settle_stratify[2][2]   then
            return true
        end
    end
end

function SettleCoinRewardView.OnShowComplete()
    LuaTimer:SetDelayFunction(1, function()
        fun.set_active(this.Mask, false)
        fun.SafeCall(this.options.OnComplete)
    end)
end

return this

