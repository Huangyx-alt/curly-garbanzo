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

local BingoSettleDetailView = BaseView:New('BingoSettleDetailView', 'BingoBangSettleAtlas')
local this = BingoSettleDetailView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "anim",
    "Root",
    "btn_continue",
    "FinalRewardsRoot",
    "FinalRewardTemp",
    "NormalRewardsRoot",
    "ActivityRewardsRoot",
    "BoxRewardsRoot",
    "BoxRewardTemp",
    "BoxRewardContent",
    "BoxContainerTemp",
    "PuzzleRoot",
    "SpRoot",
    "PuzzleProgress",
    "PuzzleSlider",
    "PuzzleRewardBox",
    "Puzzle_Ef_full",
    "TotalReward",
    "TotalRewardText",
    "DoubleRewardsRoot",
    "DoubleRewardsContent",
    "DoubleRewardsTemp",
    "TotalRewardFlyTarget",
    "PuzzleAddPoint",
    "PuzzleBgImage",
}

local AC = {
    WaitLastViewChangeTime = 0.66, --从上一个界面转场过来时播动画的时间
    StartShowViewDelay = 0.3, --当前界面开始展示的延迟
    ContainerMoveTime = 0.3, --展示的一组道具从右边进入界面的时间
    ContainerDisappearTime = 0.3, --一组道具展示结束时渐隐消失的时间
    BoxContainerOpenDelay = 0.3, --箱子移动后延迟多久打开
    BoxContainerShowInterval = 0.3, --每组箱子展示间隔
    DoubleEffectShowDelay = 0.3, --双倍奖励入场后延迟多久展示效果
    AddRewardTextAnimTime = 0.3, --奖励数值增加时文本数字滚动时间
    CompleteDelayShowBtnContinue = 2, --所有奖励展示结束后多久显示继续按钮
}

function BingoSettleDetailView:Awake(obj)
    self:on_init()
end

function BingoSettleDetailView:OnEnable(options)
    self.options = options or {}

    self:RegisterEvent()
    self.model = ModelList.BattleModel:GetCurrModel()
    self.settleData = self.model:GetSettleData()
    self:ShowView()
end

function BingoSettleDetailView:OnDisable()
    self.options = {}
    self:UnRegisterEvent()
end

function BingoSettleDetailView:OnDestroy()
    self:Destroy()
end

function BingoSettleDetailView:RegisterEvent()
    --Event.AddListener(EventName.Event_Upload_Game_Settle_Data,self.HasUploadSettleData)
end

function BingoSettleDetailView:UnRegisterEvent()
    --Event.RemoveListener(EventName.Event_Upload_Game_Settle_Data,self.HasUploadSettleData)
end

--进界面时的总金币奖励
function BingoSettleDetailView:InitTotalCoinReward()
    --local rewardInfo, total = self.settleData and self.settleData.cardReward, 0
    --table.walk(rewardInfo, function(v)
    --    --local cardID, daubCoins, bingoAwards = v.cardId, v.daubCoins, v.bingoAwards[1]
    --    local cardID, daubCoins, bingoAwards = v.cardId, 10000, 200000
    --    total = total + daubCoins
    --    total = total + bingoAwards
    --end)
    --self.totalCoinReward = total

    self.totalCoinReward = ViewList.SettleCoinRewardView.totalCoinReward
    fun.play_animator(self.TotalReward, "EnterDetail", true)
end

--初始化拼图展示
function BingoSettleDetailView:InitPuzzleShow()
    self.sceneID =  ModelList.CityModel:GetCity()
    --背景图
    local cfg = Csv.GetData("new_city_play_scene", self.sceneID)
    self.PuzzleBgImage.sprite = AtlasManager:GetSpriteByName("BingoBangPuzzleBgAtlas", cfg.res_name)
    
    local curPuzzleData = ModelList.NewPuzzleModel:GetScenePuzzlesData(self.sceneID)
    local puzzlePieces = curPuzzleData and curPuzzleData.puzzlePieces
    local isRewarded = curPuzzleData and curPuzzleData.isRewarded
    
    --本次结算获得的拼图奖励
    local pieceReward = self.settleData and self.settleData.pieceReward
    --指定位置拼图解锁
    table.walk(puzzlePieces, function(v)
        local puzzlePartId = v.id
        local isNewReward = table.find(pieceReward, function(k, v2)
            return v2.id == puzzlePartId
        end)
        --新获得的拼图初始不解锁
        if isNewReward and not isRewarded then
            return
        end
        
        local pos = string.sub(puzzlePartId, 7, 9)
        pos = tonumber(pos)
        local piece = fun.find_child(self.SpRoot, string.format("Sp%s", pos))
        if not IsNull(piece) then
            local animator = fun.get_animator(piece, fun.ANIMATOR)
            animator:Play("end", -1, 1)
        end
    end)

    local unlockCount = isRewarded and 0 or GetTableLength(pieceReward)
    local showCount = curPuzzleData.collectNum - unlockCount
    showCount = Mathf.Clamp(showCount, 0, showCount)
    self.PuzzleProgress.text = string.format("%s/%s", showCount, curPuzzleData.puzzleNum)
    self.PuzzleSlider.fillAmount = showCount / curPuzzleData.puzzleNum
end

function BingoSettleDetailView:InitOthers()
    
end

--初始化奖励数据
function BingoSettleDetailView:SetRewards()
    
    --箱子奖励
    fun.set_active(self.BoxRewardsRoot, false)
    local chestReward = self.settleData and self.settleData.chestReward
    local containerMaxCount, tempCount, curBoxContainer = 4, 0 --一次最多展示4个箱子
    table.walk(chestReward, function(chest)
        --容器和boxtemp
        tempCount = tempCount + 1
        if tempCount > containerMaxCount then
            tempCount = 1
            --重新实例化一个BoxContainer
            curBoxContainer = fun.get_instance(self.BoxContainerTemp, self.BoxRewardContent)
        else
            if not curBoxContainer then
                curBoxContainer = fun.get_instance(self.BoxContainerTemp, self.BoxRewardContent)
            end
        end
        fun.set_active(curBoxContainer, true)
        local boxInstance = fun.get_instance(self.BoxRewardTemp, curBoxContainer)
        fun.set_active(boxInstance, true)

        --箱子奖励
        local itemReward = chest.reward[1]
        local itemID, count = itemReward.id, itemReward.value
        local itemCfg = Csv.GetData("new_item", itemID)
        local refer = fun.get_component(boxInstance, fun.REFER)
        local Icon = refer:Get("Icon")
        local Count = refer:Get("Count")
        
        boxInstance.name = string.format("%s-%s", itemID, count)
        Icon.sprite = AtlasManager:GetSpriteByName("BingoBangItemAtlas", itemCfg.icon)
        Count.text = count

        --箱子等级
        local chestId, chestLevel = chest.chestId, chest.chestLevel
        local Box = refer:Get("Box")
        local Box2 = refer:Get("Box2")
        local chestCfg = Csv.GetData("new_item", chestId)
        if chestCfg then
            --local boxIcon = string.format("TkBetReward%s", chestLevel >= 10 and chestLevel or string.format("0%s", chestLevel))
            --Box.sprite = AtlasManager:GetSpriteByName("BingoBangItemAtlas", chestCfg.icon)
            Box.sprite = AtlasManager:GetSpriteByName("BingoBangItemAtlas", chestCfg.icon)
            local openIconName = string.format("BoxOpen%s", chestLevel >= 10 and chestLevel or string.format("0%s", chestLevel))
            Box2.sprite = AtlasManager:GetSpriteByName("BingoBangItemAtlas", openIconName)
        end
    end)

    --箱子Content位置
    local boxContainerSize = fun.get_rect_delta_size(self.BoxContainerTemp)
    self.boxContainerMoveOffset = boxContainerSize.x
    self.containerMoveOffset = boxContainerSize.x + 200
    fun.set_rect_anchored_position_x(self.BoxRewardsRoot, self.boxContainerMoveOffset)
    fun.set_active(self.BoxRewardsRoot, true)

    --双倍奖励
    self.doubleRewardCtrl = {}
    fun.set_active(self.DoubleRewardsContent, false)
    local doubleReward = self.settleData and self.settleData.doubleReward
    local ID2DoubleIcon = {
        [2] = "icon_DoubleWIN",
        [5] = "icon_DoubleXp",
    }
    table.walk(doubleReward, function(reward)
        local itemID = reward.itemId
        local itemCfg = Csv.GetData("new_item", itemID)
        local instance = fun.get_instance(self.DoubleRewardsTemp, self.DoubleRewardsContent)
        fun.set_active(instance, true)
        local refer = fun.get_component(instance, fun.REFER)
        local Icon = refer:Get("Icon")
        local Count = refer:Get("Count")

        if ID2DoubleIcon[itemID] then
            Icon.sprite = AtlasManager:GetSpriteByName("BingoBangBattleAtlas", ID2DoubleIcon[itemID])
        else
            Icon.sprite = AtlasManager:GetSpriteByName("BingoBangItemAtlas", itemCfg.icon)
        end
        Count.text = 1
        self.doubleRewardCtrl[itemID] = instance
    end)
    fun.set_rect_anchored_position_x(self.DoubleRewardsContent, self.containerMoveOffset)
    fun.set_active(self.DoubleRewardsContent, true)

    --最终奖励
    fun.set_active(self.FinalRewardsRoot, false)
    local showItemReward = self.settleData and self.settleData.showItemReward
    table.walk(showItemReward, function(reward)
        local itemID, count = reward.id, reward.value
        local itemCfg = Csv.GetData("new_item", itemID)
        
        --显示位置判断
        local settle_show_up = Csv.GetData("control", 225, "content")
        local settle_show_down = Csv.GetData("control", 226, "content")
        local upItems = settle_show_up[1]
        local downItems = settle_show_down[1]
        local tempParent
        if table.keyof(downItems, itemID) ~= nil then
            tempParent = self.ActivityRewardsRoot
        elseif table.keyof(upItems, itemID) ~= nil  then
            tempParent = self.NormalRewardsRoot
        end

        if not tempParent then
            return
        end
        
        local rewardInstance = fun.get_instance(self.FinalRewardTemp, tempParent)
        fun.set_active(rewardInstance, true)
        local refer = fun.get_component(rewardInstance, fun.REFER)
        local Icon = refer:Get("Icon")
        local Count = refer:Get("Count")

        if itemCfg then
            Icon.sprite = AtlasManager:GetSpriteByName("BingoBangItemAtlas", itemCfg.icon)
        end
        Count.text = count
    end)
    fun.set_rect_anchored_position_x(self.FinalRewardsRoot, self.containerMoveOffset)
    fun.set_active(self.FinalRewardsRoot, true)
end

function BingoSettleDetailView:ShowView()
    self.curModel = ModelList.BattleModel:GetCurrModel()
    self.settleData = self.curModel and self.curModel:GetSettleData()

    self:InitTotalCoinReward()
    self:InitPuzzleShow()
    self:InitOthers()
    self:SetRewards()
    fun.set_active(self.btn_continue, false)

    coroutine.start(function()
        Event.Brocast(EventName.CardEffect_End)
        coroutine.wait(AC.WaitLastViewChangeTime)
        
        coroutine.wait(AC.StartShowViewDelay)

        self:StartSequence()
    end)
end

function BingoSettleDetailView:StartSequence()
    --流程
    local sequence = CommandSequence.New({ LogTag = "BingoSettleDetailView Sequence ", })
    sequence:AddFunctionCommand(function(cmd) self:ShowBoxRewards(cmd) end, { LogTag = "BingoSettleDetailView 1", })
    sequence:AddFunctionCommand(function(cmd) self:ShowDoubleRewardEffect(cmd) end, { LogTag = "BingoSettleDetailView 2", })
    sequence:AddFunctionCommand(function(cmd) self:ShowFinalReward(cmd) end, { LogTag = "BingoSettleDetailView 4", })
    sequence:AddDoneFunc(function() self:OnShowComplete() end)
    sequence:Execute()
end

--开展示启宝箱奖励
function BingoSettleDetailView:ShowBoxRewards(cmd)
    local childCount, startIndex = fun.get_child_count(self.BoxRewardContent), 1
    self:MoveNextBoxContainer(childCount, startIndex, function()
        fun.set_active(self.BoxRewardsRoot, false)
        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end)
end

--展示下一个Container
function BingoSettleDetailView:MoveNextBoxContainer(childCount, nowIndex, onComplete)
    if nowIndex > childCount then
        --播放消失
        Anim.do_smooth_float_update(1, 0, AC.ContainerDisappearTime, function(temp)
            self.BoxRewardsRoot.alpha = temp
        end, function()
            self.BoxRewardsRoot.alpha = 0
            fun.SafeCall(onComplete)
        end)
        return
    end

    local curX = fun.get_rect_anchored_position(self.BoxRewardsRoot).x
    local targetMoveX = curX - self.boxContainerMoveOffset
    Anim.move_to_x(self.BoxRewardsRoot.gameObject, targetMoveX, AC.ContainerMoveTime, function()
        LuaTimer:SetDelayFunction(AC.BoxContainerOpenDelay, function()
            local containerObj = fun.get_child(self.BoxRewardContent, nowIndex - 1)
            self:OpenContainerBoxes(containerObj, function()
                nowIndex = nowIndex + 1
                LuaTimer:SetDelayFunction(AC.BoxContainerShowInterval, function()
                    self:MoveNextBoxContainer(childCount, nowIndex, onComplete)
                end)
            end)
        end)
    end)
end

--开箱子
function BingoSettleDetailView:OpenContainerBoxes(containerObj, onComplete)
    local childCount, haveCoin = fun.get_child_count(containerObj)
    local curShowCoinNum = self.totalCoinReward
    coroutine.start(function()
        for i = 1, childCount do
            if i > 1 then
                coroutine.wait(0.2) --每个箱子打开间隔0.2s
            end
            
            local boxObj = fun.get_child(containerObj, i - 1)
            --展示动效
            fun.play_animator(boxObj, "over", true)
            UISound.play("chestopen")
            
            local data = string.split(boxObj.name, "-")
            local itemId, count = data[1] or 0, data[2] or 0
            if itemId == "2" then
                --金币
                self.totalCoinReward = self.totalCoinReward + count
                haveCoin = true
            end

            --奖励图标
            local reward = fun.find_child(boxObj, "Reward")
            fun.set_active(reward, true)

            --动效播完后
            --LuaTimer:SetDelayFunction(0.66, function()
            if i == childCount then
                if haveCoin then
                    --飞金币
                    local refer = fun.get_component(boxObj, fun.REFER)
                    local Icon = refer:Get("Icon")
                    --获得道具效果
                    local startPos = fun.get_gameobject_pos(Icon)
                    local targetPos = fun.get_gameobject_pos(self.TotalRewardFlyTarget)
                    Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts, startPos, 2, function()
                        --加总金币数值
                        --fun.play_animator(self.TotalReward, "act", true)
                        if self.addRewardAnim then
                            self.addRewardAnim:Kill()
                        end
                        self.addRewardAnim = Anim.do_smooth_float_update(curShowCoinNum, self.totalCoinReward, AC.AddRewardTextAnimTime, function(num)
                            self.TotalRewardText.text = fun.format_money(math.floor(num))
                        end, function()
                            self.TotalRewardText.text = fun.format_money(self.totalCoinReward)
                            fun.SafeCall(onComplete)
                        end)
                    end, nil, false, targetPos)
                else
                    fun.SafeCall(onComplete)
                end
            end
            --end)
        end
    end)
end

--双倍奖励表现
function BingoSettleDetailView:ShowDoubleRewardEffect(cmd)
    local doubleReward = self.settleData and self.settleData.doubleReward
    if GetTableLength(doubleReward) == 0 then
        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        return
    end
    
    local curX = fun.get_rect_anchored_position(self.DoubleRewardsContent).x
    local targetMoveX = curX - self.containerMoveOffset
    Anim.move_to_x(self.DoubleRewardsContent.gameObject, targetMoveX, AC.ContainerMoveTime, function()

        LuaTimer:SetDelayFunction(AC.DoubleEffectShowDelay, function()
            --双倍奖励表现流程
            local sequence = CommandParallel.New({ LogTag = "ShowDoubleRewardEffect Parallel ", })
            sequence:AddFunctionCommand(function(c) self:ShowDoubleCoinReward(c) end, { LogTag = "ShowDoubleRewardEffect 1", })
            sequence:AddFunctionCommand(function(c) self:ShowDoubleXpReward(c) end, { delayExecuteTime = 1, LogTag = "ShowDoubleRewardEffect 2", })
            sequence:AddDoneFunc(function()
                --播放消失
                Anim.do_smooth_float_update(1, 0, AC.ContainerDisappearTime, function(temp)
                    self.DoubleRewardsRoot.alpha = temp
                end, function()
                    self.DoubleRewardsRoot.alpha = 0
                    cmd:ExecuteDone(sequence.executeResult)
                end)
            end)
            sequence:Execute()
        end)
        
    end)
end

function BingoSettleDetailView:ShowDoubleCoinReward(cmd)
    --local doubleCoinObj = fun.get_child(self.DoubleRewardsContent, 0)
    local doubleCoinObj = self.doubleRewardCtrl and self.doubleRewardCtrl[2]
    if not doubleCoinObj then
        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        return
    end
    
    local doubleReward = self.settleData and self.settleData.doubleReward
    local coin = table.find(doubleReward, function(k, v)
        return v.itemId == 2
    end)
    if not coin then
        fun.set_active(doubleCoinObj, false)
        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        return
    end
    
    local curShowCoinNum = self.totalCoinReward
    self.totalCoinReward = self.settleData.chips
    local startPos = fun.get_gameobject_pos(doubleCoinObj)
    local targetPos = fun.get_gameobject_pos(self.TotalRewardFlyTarget)
    Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts, startPos, 2, function()

        --加总金币数值
        --fun.play_animator(self.TotalReward, "act", true)
        Anim.do_smooth_float_update(curShowCoinNum, self.totalCoinReward, AC.AddRewardTextAnimTime, function(num)
            self.TotalRewardText.text = fun.format_money(math.floor(num))
        end, function()
            self.TotalRewardText.text = fun.format_money(self.totalCoinReward)
            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end)

    end, nil, false, targetPos)
end

function BingoSettleDetailView:ShowDoubleXpReward(cmd)
    --local doubleXpObj = fun.get_child(self.DoubleRewardsContent, 1)
    local doubleXpObj = self.doubleRewardCtrl and self.doubleRewardCtrl[5]
    if not doubleXpObj then
        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        return
    end
    
    local doubleReward = self.settleData and self.settleData.doubleReward
    local xp = table.find(doubleReward, function(k, v)
        return v.itemId == 5
    end)
    if not xp then
        fun.set_active(doubleXpObj, false)
        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        return
    end
    
    local startPos = fun.get_gameobject_pos(doubleXpObj)
    Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts, startPos, 5, function()
        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end, nil, true)
end

--展示最终奖励
function BingoSettleDetailView:ShowFinalReward(cmd)
    UISound.play("settlementshow")
    
    local curX = fun.get_rect_anchored_position(self.FinalRewardsRoot).x
    local targetMoveX = curX - self.containerMoveOffset
    Anim.move_to_x(self.FinalRewardsRoot.gameObject, targetMoveX, AC.ContainerMoveTime, function()
        --解锁拼图表现流程
        self:StartFinalSequence(cmd)
    end)
end

function BingoSettleDetailView:StartFinalSequence(cmd)
    --解锁拼图表现流程
    local sequence = CommandSequence.New({ LogTag = "ShowPuzzleUnlock sequence ", })
    sequence:AddFunctionCommand(function(c) self:ShowPuzzleAddPieces(c) end, { LogTag = "ShowPuzzleUnlock 1", })
    sequence:AddFunctionCommand(function(c) self:ShowPuzzleUnlock(c) end, { LogTag = "ShowPuzzleUnlock 1", })
    sequence:AddDoneFunc(function() cmd:ExecuteDone(sequence.executeResult) end)
    sequence:Execute()
end

function BingoSettleDetailView:ShowPuzzleAddPieces(cmd)
    local curPuzzleData = ModelList.NewPuzzleModel:GetScenePuzzlesData(self.sceneID)
    local isRewarded = curPuzzleData and curPuzzleData.isRewarded
    local pieceReward = self.settleData and self.settleData.pieceReward
    
    if isRewarded or GetTableLength(pieceReward) == 0 then
        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        return
    end
    
    local progress = curPuzzleData.collectNum / curPuzzleData.puzzleNum
    Http.report_event("activity_puzzle_open",{sceneid = self.sceneID, progress = progress})
    
    fun.play_animator(self.anim, "act", true)
    UISound.play("puzzleadd")
    LuaTimer:SetDelayFunction(1, function()
        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end)
end

function BingoSettleDetailView:ShowPuzzleUnlock(cmd)
    local curPuzzleData = ModelList.NewPuzzleModel:GetScenePuzzlesData(self.sceneID)
    local isRewarded = curPuzzleData and curPuzzleData.isRewarded
    
    --指定位置拼图解锁
    local pieceReward = self.settleData and self.settleData.pieceReward
    local pieceCount = GetTableLength(pieceReward)
    if isRewarded or pieceCount == 0 then
        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        return
    end

    UISound.play("puzzlebreak")
    table.walk(pieceReward, function(v)
        local puzzlePartId = v.id
        local pos = string.sub(puzzlePartId, 7, 9)
        pos = tonumber(pos)
        local piece = fun.find_child(self.SpRoot, string.format("Sp%s", pos))
        if not IsNull(piece) then
            local animator = fun.get_animator(piece, fun.ANIMATOR)
            animator:Play("end", -1, 0)
        end
    end)
    
    self.PuzzleProgress.text = string.format("%s/%s", curPuzzleData.collectNum, curPuzzleData.puzzleNum)
    local curValue = self.PuzzleSlider.fillAmount
    local targetValue = curPuzzleData.collectNum / curPuzzleData.puzzleNum
    --播放进度条动画
    Anim.do_smooth_float_update(curValue, targetValue, AC.ContainerDisappearTime, function(temp)
        self.PuzzleSlider.fillAmount = temp
    end, function()
        self.PuzzleSlider.fillAmount = targetValue
        if self.PuzzleSlider.fillAmount == 1 then
            fun.set_active(self.Puzzle_Ef_full, true)
        end
        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end)
end

function BingoSettleDetailView:OnShowComplete()
    LuaTimer:SetDelayFunction(AC.CompleteDelayShowBtnContinue, function()
        fun.set_active(self.btn_continue, true)
    end)
end

function BingoSettleDetailView:on_btn_continue_click()
    fun.SafeCall(self.options.OnComplete)
end

return this

