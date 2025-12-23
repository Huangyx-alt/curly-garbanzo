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

local SettleLuckyBangView = BaseView:New('SettleLuckyBangView','BingoBangSettleAtlas')
local this = SettleLuckyBangView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "Anim",
    "NumberList",
    "NumberTemp",
    "text_spin",
    "btn_spin",
    "Ball",
    "BallType",
    "BallBg",
    "NumbersContent",
    "ReelWheel",
    "FakeWheel",
    "Root",
    "SignEffectRoot",
    "WishEffectRoot",
    "WishEffectTemp",
    "AddBallEffect",
}

local AC = {
    JumpNextDelayOnNoLuckyBang = 3, --没有LuckyBang，打开界面后几秒跳转下一个流程
    HideBallDelayAfterLuckyBangSign = 1, --触发盖章后延迟多久隐藏叫号球
    HideBallAnimTime = 0.3, --缩小隐藏叫号球的动画时间
    JumpNextDelayOnLuckyBangEnd = 1, --所有LuckyBang展示结束后多久跳转下一个界面
}

function SettleLuckyBangView.Awake(obj)
    this:on_init()
end

function SettleLuckyBangView:OnEnable(options)
    this.options = options or {}
    this.isComplete = false
    this:RegisterEvent()
    this:InitData()
    this:ShowView()

    ModelList.GuideModel:OpenUI("SettleLuckyBangView")
end

function SettleLuckyBangView:OnDisable()
    this.isComplete = false
    this.options = {}
    this.wishCellList = {}
    
    this:UnRegisterEvent()
end

function SettleLuckyBangView.OnDestroy()
    this:Destroy()
end

function SettleLuckyBangView:RegisterEvent()
    --Event.AddListener(EventName.Event_Upload_Game_Settle_Data,this.HasUploadSettleData)
end

function SettleLuckyBangView:UnRegisterEvent()
    --Event.RemoveListener(EventName.Event_Upload_Game_Settle_Data,this.HasUploadSettleData)
end

function SettleLuckyBangView:InitData()
    this.model = ModelList.BattleModel:GetCurrModel()
    this.settleData = this.model:GetSettleData()
    this.luckyBangData = this.settleData.luckyBang
    --this.numbers = BattleTool.GetFromServerPos(this.luckyBangData.numbers)
    this.numbers = deep_copy(this.luckyBangData.numbers)
    --this.extraNumbers = BattleTool.GetFromServerPos(this.luckyBangData.extraNumbers)
    this.extraNumbers = deep_copy(this.luckyBangData.extraNumbers)
end

function SettleLuckyBangView:ShowView()
    --设置假转盘
    fun.set_parent(this.FakeWheel, this.ReelWheel, true)
    fun.set_gameobject_rot(this.FakeWheel, 0, 0, 0, true)
    fun.set_active(this.FakeWheel, true)
    
    --if this.options.HasLuckyBang then
        UISound.play_bgm("luckybangbgm")
        fun.set_active(this.Root, true)
        this.text_spin.text = GetTableLength(this.numbers)
        this:InitWishCell()
    --else
    --    fun.set_active(this.Root, false)
    --    LuaTimer:SetDelayFunction(AC.JumpNextDelayOnNoLuckyBang, function()
    --        fun.SafeCall(this.options.OnComplete)
    --    end)
    --end
end

function SettleLuckyBangView:InitWishCell()
    self.wishCellList = self.wishCellList or {}
    
    local roundData = this.model:GetRoundData()
    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    local cardView = bingoView:GetCardView()
    table.walk(roundData, function(cardData, cardID)
        if cardData:GetForbid(cardID) then
            return
        end
        self.wishCellList[cardID] = self.wishCellList[cardID] or {}
        
        local root = cardView:GetEffectPlayRoot(cardID, BingoBangEntry.BattleContainerType.CellEffectContainer)
        table.walk(cardData.cards, function(cellData, cellIndex)
            if cellData.sign == 0 and (cellData.wishState == 1 or self:CheckSkillCellCanTriggerBingo(cellData)) then
                local find = table.find(self.wishCellList[cardID], function(k, v)
                    return v.cellIndex == cellIndex
                end)
                if not find then
                    local wishEffect = this:GetWishEffectFromPool()
                    fun.set_parent(wishEffect, root)
                    fun.set_same_position_with(wishEffect, cellData.obj)
                    table.insert(self.wishCellList[cardID], {
                        cellIndex = cellIndex,
                        cellData = cellData,
                        wishEffect = wishEffect,
                        isShow = false,
                    })
                end
                
                --测试代码，必定触发盖章
                --table.insert(self.numbers, 1, cellData.num)
            end
        end)
    end)

    table.walk(self.wishCellList, function(list, cardID)
        table.sort(list, function(a, b)
            return a.cellIndex <= b.cellIndex
        end)
        table.walk(list, function(v)
            self:SetWishCell(v.cellData, v.wishEffect)
        end)
    end)

    --if self.wishShowTimer then
    --    LuaTimer:Remove(self.wishShowTimer)
    --    self.wishShowTimer = nil
    --end
    if not self.wishShowTimer then
        self.wishShowTimer = LuaTimer:SetDelayLoopFunction(4, 4, -1, function ()
            self:ShowWishCell()
        end, nil)
    end
end

function SettleLuckyBangView:SetWishCell(cellData, effectObj)
    local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
    --local cardObj = cardView:GetCardMap(cellData.cardId)
    --local cardScale = fun.get_gameobject_scale(cardObj, true)
    --fun.set_gameobject_scale(effectObj.gameObject, cardScale.x, cardScale.y,cardScale.y)
    fun.set_gameobject_scale(effectObj.gameObject, 1, 1, 1)
    
    local refer = fun.get_component(effectObj, fun.REFER)
    local rewardText = refer:Get("rewardText")
    local SingleNum = refer:Get("SingleNum")
    local DoubleNum = refer:Get("DoubleNum")
    local ItemRoot = refer:Get("ItemRoot")
    
    --双数字显示
    if cellData.double_num > 0 then
        fun.set_active(SingleNum, false)
        fun.set_active(DoubleNum, true)
        local DoubleNum_1 = refer:Get("DoubleNum_1")
        local DoubleNum_2 = refer:Get("DoubleNum_2")
        DoubleNum_1.text = cellData.num
        DoubleNum_2.text = cellData.double_num
    else
        fun.set_active(SingleNum, true)
        fun.set_active(DoubleNum, false)
        SingleNum.text = cellData.num
    end
    
    --奖励数值
    local singleCardFee = this.model:GetBattleExtraInfo("singleCardFee")
    if singleCardFee then
        --计算下一个Bingo的奖励
        local cardBingoCount = CalculateBingoMachine.GetTotalBingoCount(cellData.cardId)
        local playId, maxBingoCount = self.model:GetGameType(), 0
        table.walk(Csv["new_bingo_reward"], function(v)
            if v.bingo > maxBingoCount then maxBingoCount = v.bingo end
        end)
        if cardBingoCount >= maxBingoCount then
            cardBingoCount = maxBingoCount - 1
        end
        local bingoRewardCfg1 = table.find(Csv["new_bingo_reward"], function(k, v)
            return playId == v.play_id and cardBingoCount == v.bingo
        end)        
        local bingoRewardCfg2 = table.find(Csv["new_bingo_reward"], function(k, v)
            return playId == v.play_id and (cardBingoCount + 1) == v.bingo
        end)
        if bingoRewardCfg1 and bingoRewardCfg2 then
            local reward1 = bingoRewardCfg1.bingo_coins / 100 * singleCardFee
            local reward2 = bingoRewardCfg2.bingo_coins / 100 * singleCardFee
            rewardText.text = string.format("+%s", fun.format_money(reward2 - reward1))
        else
            if bingoRewardCfg2 then
                local reward = bingoRewardCfg2.bingo_coins / 100 * singleCardFee
                rewardText.text = string.format("+%s", fun.format_money(reward))
            else
                rewardText.text = string.format("+%s", fun.format_money(singleCardFee))
            end
        end
    else
        rewardText.text = "+1,000"
    end
    
    --设置道具
    local gift = cellData.gift[1]
    if gift then
        local itemCfg = Csv.GetData("new_item", gift)
        if itemCfg then
            local obj = cardView:GetCardCell(cellData.cardId, cellData.index)
            local ref_temp = obj:GetComponent(fun.REFER)
            local gift_obj = ref_temp:Get("gift_clone")
            local gift_clone = fun.get_instance(gift_obj, ItemRoot)
            fun.set_gameobject_pos(gift_clone, 0, 0, 0, true)
            fun.enable_component(fun.get_animator(gift_clone), false)
            fun.set_active(gift_clone, true)
            
            local gift_ref_temp = fun.get_component(gift_clone, fun.REFER)
            local touying = gift_ref_temp:Get("touying")
            local gift_icon = gift_ref_temp:Get("gift_icon")
            gift_icon.sprite = AtlasManager:GetSpriteByName("BingoBangBattleAtlas", itemCfg["icon"])
            touying.sprite = AtlasManager:GetSpriteByName("BingoBangBattleAtlas", itemCfg["icon"])
        end
    end
end

function SettleLuckyBangView:ShowWishCell()
    table.walk(self.wishCellList, function(list, cardID)
        local count = GetTableLength(list)
        if count == 0 then
            return
        end
        
        local find, index = table.find(list, function(k2, v2)
            return not v2.isShow
        end)
        if not find then
            --都已经展示过一遍了
            table.walk(list, function(v2, k2)
                v2.isShow = false
            end)
            
            index = 1
        end

        table.walk(list, function(v2, k2)
            if k2 ~= index then
                fun.play_animator(v2.wishEffect, "idlexiao", true)
            else
                fun.SetAsLastSibling(v2.wishEffect.gameObject)
                fun.play_animator(v2.wishEffect, "idleda", true)
                v2.isShow = true
            end
        end)
    end)
end

function SettleLuckyBangView:CheckSkillCellCanTriggerBingo(cellData)
    local check = false
    
    table.walk(cellData.skill_id, function(skillId, k)
        local skillData = Csv.GetData("new_skill", skillId)
        if skillData then
            local extraPos = {}
            if skillData.skill_type == 0 then
                --固定形状
                table.walk(skillData.skill_xyz, function(offset)
                    local ori_x = math.modf((cellData.index - 1) / 5)
                    local ori_y = math.modf((cellData.index - 1) % 5)
                    local new_x = ori_x + offset[1]
                    local new_y = ori_y - offset[2]
                    if new_x >= 0 and new_x <= 4 and new_y >= 0 and new_y <= 4 then
                        local new_index = new_x * 5 + new_y + 1
                        table.insert(extraPos, new_index)
                    end
                end)
            elseif skillData.skill_type == 1 then
                --随机盖章，需要读取后端数据
                extraPos = cellData:GetPuExtraPos()
                if GetTableLength(extraPos) > 0 then
                    extraPos = BattleTool.GetExtraPos(extraPos)
                else
                    local powerId = cellData.powerId and cellData.powerId[k]
                    if powerId then
                        local powerUpData = this.model:LoadGameData().powerUpData
                        local targetPuData, puIndex = table.find(powerUpData.powerUpList, function(_, v)
                            return powerId == v.powerUpId and v.isUsed
                        end)
                        local data = table.find(targetPuData and targetPuData.cardEffect, function(_, v)
                            return v.cardId == cellData.cardId
                        end)
                        if data then
                            extraPos = BattleTool.GetFromServerPos(data.effectData.posList)
                        end
                    end
                end
            end
            
            table.walk(extraPos, function(pos)
                local targetCellData = this.model:GetRoundData(cellData.cardId, pos)
                if targetCellData and targetCellData.sign == 0 and targetCellData.wishState == 1 then
                    check = true
                end
            end)
        end
    end)
    
    return check
end

function SettleLuckyBangView:GetCellWishEffect(cardID, cellIndex)
    --cardID, cellIndex = tonumber(cardID), tonumber(cellIndex)
    
    local ret
    table.walk(self.wishCellList, function(v, k)
        if cardID == k then
            table.walk(v, function(v2, k2)
                if v2.cellIndex == cellIndex then
                    ret = v2
                end
            end)
        end
    end)
    
    if ret then
        return ret.wishEffect
    end
end

function SettleLuckyBangView:HideWishEffect(cardID, cellIndex)
    local effect = self:GetCellWishEffect(cardID, cellIndex)
    fun.set_active(effect, false)
end

function SettleLuckyBangView:HideAllWishEffect()
    table.walk(self.wishCellList, function(v, k)
        table.walk(v, function(v2, k2)
            fun.set_active(v2.wishEffect, false)
        end)
    end)
end

function SettleLuckyBangView:ShowNext()
    local nextCallNum = table.remove(this.numbers, 1)
    if not nextCallNum then
        this:OnShowComplete()
        return
    end
    log.r("[SettleLuckyBangView] ShowNext nextCallNum:", nextCallNum)
    this.text_spin.text = GetTableLength(this.numbers)
    this.curCallNum = nextCallNum
    this:StartSequence()
end

function SettleLuckyBangView:StartSequence()
    this.isInSequence = true
    --流程
    local sequence = CommandSequence.New({ LogTag = "SettleLuckyBangView Sequence ", })
    sequence:AddFunctionCommand(this.SetRollNumber, { LogTag = "SettleLuckyBangView 1", })
    sequence:AddFunctionCommand(this.DoAnimation, { LogTag = "SettleLuckyBangView 2", })
    sequence:AddFunctionCommand(this.TriggerSign, { LogTag = "SettleLuckyBangView 4", })
    sequence:AddFunctionCommand(this.HideBall, { LogTag = "SettleLuckyBangView 5", })
    sequence:AddDoneFunc(this.OnSequenceComplete)
    sequence:Execute()
end

--设置球面
function SettleLuckyBangView.SetRollNumber(cmd)
    --local numType1, numType2 = this:GetNumType(this.curCallNum)

    --local bingoView = ModelList.BattleModel:GetCurrBattleView()
    --设置球
    --local callNumView = bingoView:GetCallNumberView()
    --this.BallType.sprite = callNumView:GetBallLetter(numType2)
    --this.BallBg.sprite = callNumView.ball_sprite_list[numType2]
    cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
end

function SettleLuckyBangView.DoAnimation(cmd)
    --真转盘归位
    fun.set_gameobject_rot(this.ReelWheel, 0, 0, 0, true)
    
    local numType = this:GetNumType(this.curCallNum)
    fun.play_animator(this.Anim, "spin_"..numType, true)
    
    --以下逻辑在一个转盘的动画时间内
    coroutine.start(function()
        --转盘跟随真转盘转动
        fun.set_parent(this.FakeWheel, this.ReelWheel)
        
        coroutine.wait(0.75)
        --隐藏假转盘
        fun.set_active(this.FakeWheel, false)
        
        --球滚动数字
        coroutine.wait(1.75)
        this.RollNumberWithText()
        
        --动画结束
        coroutine.wait(1.5)
        
        --显示假转盘
        fun.set_gameobject_rot(this.FakeWheel, 0, 0, 0, true)
        fun.set_parent(this.FakeWheel, this.ReelWheel.parent)
        fun.set_active(this.FakeWheel, true)
        
        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end)
end

--开始球面的数字滚动
function SettleLuckyBangView.RollNumberWithText()
    local numType1, numType2 = this:GetNumType(this.curCallNum)
    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    local cardView = bingoView:GetCardView()
    
    --滚动数字列表
    local startNum, endNum = (numType2 - 1) * 15 + 1, numType2 * 15
    local rollNumberList = {}
    for j = 1, 2 do
        for i = startNum, endNum do
            table.insert(rollNumberList, i)
            --转到第二轮才停止
            if this.curCallNum == i and j == 2 then
                break
            end
        end
    end
    
    local total = GetTableLength(rollNumberList)
    local lastNum = rollNumberList[total]
    local refer = fun.get_component(this.NumberTemp, fun.REFER)
    local OneNum, DoubleNum = refer:Get("OneNum"), refer:Get("DoubleNum")
    local Num = refer:Get("Num")
    local DoubleNum1, DoubleNum2 = refer:Get("DoubleNum1"), refer:Get("DoubleNum2")
    LuaTimer:SetDelayLoopFunction(0, 1 / total, total, function()
        local curNum = table.remove(rollNumberList, 1)
        if curNum >= 10 then
            fun.set_active(OneNum, false)
            fun.set_active(DoubleNum, true)
            local first_num = math.modf(curNum / 10)
            local second_num = math.modf(curNum % 10)
            second_num = second_num == 0 and 10 or second_num
            DoubleNum1.sprite = cardView:GetNormalNumberSprites(first_num)
            DoubleNum2.sprite = cardView:GetNormalNumberSprites(second_num)
        else
            fun.set_active(OneNum, true)
            fun.set_active(DoubleNum, false)
            Num.sprite = cardView:GetNormalNumberSprites(curNum)
        end
    end, function()
        if lastNum >= 10 then
            fun.set_active(OneNum, false)
            fun.set_active(DoubleNum, true)
            local first_num = math.modf(lastNum / 10)
            local second_num = math.modf(lastNum % 10)
            second_num = second_num == 0 and 10 or second_num
            DoubleNum1.sprite = cardView:GetNormalNumberSprites(first_num)
            DoubleNum2.sprite = cardView:GetNormalNumberSprites(second_num)
        else
            fun.set_active(OneNum, true)
            fun.set_active(DoubleNum, false)
            Num.sprite = cardView:GetNormalNumberSprites(lastNum)
        end
    end)
end

function SettleLuckyBangView.TriggerSign(cmd)
    local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
    local roundData = this.model:GetRoundData()
    local totalCount = 0
    
    table.walk(roundData, function(cardData, cardID)
        if cardData:GetForbid(cardID) then
            return
        end
        
        local targetCell
        table.walk(cardData.cards, function(cellData, cellIndex)
            if cellData:IsNotSign() then
                if cellData.num == this.curCallNum or cellData.double_num == this.curCallNum then
                    targetCell = cellData
                end
            end
        end)
        --没有格子被叫中
        if not targetCell then
            return
        end
        totalCount = totalCount + 1
        
        local cardCell = cardView:GetCardCell(cardID, targetCell.index)
        local effect = this:GetSignEffectFromPool()
        fun.set_same_position_with(effect, cardCell)
        fun.set_active(effect, true)
        
        --wish格子动画
        local wishEffect = this:GetCellWishEffect(cardID, targetCell.index)
        fun.play_animator(wishEffect, "zhong", true)
        
        LuaTimer:SetDelayFunction(1.28, function()
            fun.set_active(wishEffect, false)
            
            local CmdLuckyBangTriggerSign = require "Logic.Command.Battle.InBattle.Sign.CmdLuckyBangTriggerSign"
            local tempCmd = CmdLuckyBangTriggerSign.New()
            tempCmd:AddDoneFunc(function()
                this:InitWishCell()
                
                totalCount = totalCount - 1
                if totalCount == 0 then
                    this.CheckAddNewBall(targetCell.gift)
                    LuaTimer:SetDelayFunction(AC.HideBallDelayAfterLuckyBangSign, function()
                        cmd:ExecuteDone(tempCmd.executeResult)
                    end)
                end
            end)
            tempCmd:Execute({
                cardView = cardView,
                cardid = cardID,
                cardNum = this.curCallNum,
                cardCell = cardCell,
                double_num = targetCell.double_num,
                index = targetCell.index,
                mask = 1,
            })
        end)
    end)

    if totalCount == 0 then
        LuaTimer:SetDelayFunction(AC.HideBallDelayAfterLuckyBangSign, function()
            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end)
    end
end

--盖章后是否额外出发了LuckyBang
function SettleLuckyBangView.CheckAddNewBall(giftList)
    local addBallNum = 0
    table.walk(giftList, function(itemID)
        if itemID == 817 then
            addBallNum = addBallNum + 1
        end
    end)
    if addBallNum > 0 then
        coroutine.start(function()
            fun.play_animator(this.AddBallEffect, "enter", true)
            
            coroutine.wait(1)
            for i = 1, addBallNum do
                local num = table.remove(this.extraNumbers, 1)
                table.insert(this.numbers, num)
            end
            this.text_spin.text = GetTableLength(this.numbers)
        end)
    end
end

function SettleLuckyBangView:GetSignEffectFromPool()
    local ret
    fun.eachChild(this.SignEffectRoot, function(childCtrl, i)
        if not fun.get_active_self(childCtrl) then
            ret = childCtrl
        end
    end)
    if not ret then
        local temp = fun.get_child(this.SignEffectRoot, 0)
        ret = fun.get_instance(temp, this.SignEffectRoot)
        fun.set_active(ret, false)
    end
    return ret
end

function SettleLuckyBangView:GetWishEffectFromPool()
    local ret
    fun.eachChild(this.WishEffectRoot, function(childCtrl, i)
        if not fun.get_active_self(childCtrl) then
            ret = childCtrl
        end
    end)
    if not ret then
        ret = fun.get_instance(this.WishEffectTemp, this.WishEffectRoot)
        fun.set_active(ret, false)
    end
    fun.set_active(ret, true)
    return ret
end

function SettleLuckyBangView.HideBall(cmd)
    fun.enable_component(this.Anim, false)
    Anim.scale_to_xy(this.Ball, 0, 0, AC.HideBallAnimTime, function()
        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end)
end

function SettleLuckyBangView.OnSequenceComplete()
    this.isInSequence = false
    if GetTableLength(this.numbers) == 0 then
        this:OnShowComplete()
    end
end

function SettleLuckyBangView:OnShowComplete()
    if not self.isComplete then
        self.isComplete = true
        self:HideAllWishEffect()
        
        coroutine.start(function()
            fun.play_animator(this.Anim, "end", true)
            --coroutine.wait(0.6)
            coroutine.wait(AC.JumpNextDelayOnLuckyBangEnd)
            fun.SafeCall(this.options.OnComplete)
        end)
    end
end

function SettleLuckyBangView:on_btn_spin_click()
    if this.isInSequence then
        log.r("[SettleLuckyBangView] on_btn_spin_click isInSequence")
        return
    end
    UISound.play("Luckybangspin")
    this:ShowNext()
end

function SettleLuckyBangView:GetNumType(num)
    if num <= 15 then
        return "B", 1
    elseif num <= 30 then
        return "I", 2
    elseif num <= 45 then
        return "N", 3
    elseif num <= 60 then
        return "G", 4
    elseif num <= 75 then
        return "O", 5
    else
        return "O", 5
    end
end

return this

