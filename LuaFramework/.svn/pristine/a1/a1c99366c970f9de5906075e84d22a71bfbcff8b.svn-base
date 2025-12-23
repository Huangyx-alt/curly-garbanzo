
PiggySlotsGameElementMergeState = Clazz(BasePiggySlotsGameState,"PiggySlotsGameElementMergeState")

function PiggySlotsGameElementMergeState:OnEnter(fsm,previous,spinStateName)
    self.spinStateName = spinStateName
    self.isFinishMerge = false
    log.log("PiggySlotsGameElementMergeState 进入spin前的状态" , self.spinStateName)
    local isMerge = false

    local piggyDataNow = ModelList.PiggySloltsGameModel.GetPiggyDataNow()
    local piggyDataLast = ModelList.PiggySloltsGameModel.GetPiggyDataLast()
    local colNum = 5
    local rowNum = 3

    local merge2X3Data = {}
    local merge1X3Data = {}
    local merge1X2Data = {}

    local mergeData = {}
    local mergeClearData = {}
    
    local piggyLastNum = GetTableLength(piggyDataLast)
    if piggyLastNum > 0 then
        for col = 1 , colNum do
            mergeData[col] = mergeData[col] or {}
            mergeClearData[col] = mergeClearData[col] or {}
            local lastData = piggyDataLast[col]
            local nowData = piggyDataNow[col]
            for row = 1 , rowNum do
                if lastData[row] then
                    if nowData and nowData[row] then
                        --最新spin有小猪
                        if nowData[row].piggyType == lastData[row].piggyType then
                            --和上次spin是相同小猪类型
                            if nowData[row].piggyType == PiggySlotsEffectType.Piggy2x3 then
                                --相同的大猪类型 判断是重组
                                if nowData[row].StartCol == lastData[row].StartCol and nowData[row].FinishCol == lastData[row].FinishCol then
                                    --大猪位置相同
                                    log.log("小猪机台 合并小猪数据 合成检查 大猪位置相同",col,row)
                                else
                                    --大猪数据不同
                                    mergeClearData[col][row] = PiggySlotsEffectType.Piggy2x3
                                    mergeData[col][row] = PiggySlotsEffectType.Piggy2x3
                                end
                            else
                                log.log("小猪机台 合并小猪数据 合成检查 特殊逻辑",col,row)
                            end
                        else
                            --和上次spin不是相同类型
                            mergeClearData[col][row] =lastData[row].piggyType
                            mergeData[col][row] = nowData[row].piggyType
                        end
                    else
                        --上次spin存在小猪数据 最新spin不存在
                        log.log("小猪机台 合并小猪数据 合成检查 这里有问题上次存在小猪 最新spin小猪消失",col,row)
                    end
                else
                    if nowData[row] and nowData[row].piggyType and nowData[row].piggyType ~= PiggySlotsEffectType.Piggy1x1 then
                        mergeData[col][row] = nowData[row].piggyType
                        mergeClearData[col][row] = PiggySlotsEffectType.Piggy1x1
                    end
                end
            end
        end
    else
        mergeClearData = {}
        for k ,v in pairs(piggyDataNow) do
            mergeData[k] = mergeData[k] or {}
            mergeClearData[k] = mergeClearData[k] or {}
            for row = 1 , rowNum do
                if v[row] then
                    mergeData[k][row] = v[row].piggyType
                    if v[row].piggyType ~= PiggySlotsEffectType.Piggy1x1 then
                        mergeClearData[k][row] = PiggySlotsEffectType.Piggy1x1
                    end
                end
            end
        end
    end

    -- --数据重置
    if mergeData then
        for col ,v in pairs(mergeData) do
            for row ,piggyEffectType in pairs(v) do
                if piggyEffectType == PiggySlotsEffectType.Piggy1X2 then
                    if merge1X2Data[col] then
                        --每竖列只有一个1X2
                    else
                        if v[row+1] and v[row+1] == PiggySlotsEffectType.Piggy1X2 then
                            merge1X2Data[col] = 
                            {
                                startRow = row,
                                finishRow = row + 1
                            }
                        elseif v[row-1] and v[row-1] == PiggySlotsEffectType.Piggy1X2 then
                            merge1X2Data[col] = 
                            {
                                startRow = row - 1,
                                finishRow = row
                            }
                        end
                    end
                elseif piggyEffectType == PiggySlotsEffectType.Piggy1X3 then
                    if merge1X3Data[col] then
                        --每竖列只有一个1X3
                    else
                        merge1X3Data[col] = true
                    end
                elseif piggyEffectType == PiggySlotsEffectType.Piggy2x3 then
                    if mergeData[col - 1] and mergeData[col - 1][1] == PiggySlotsEffectType.Piggy2x3 then
                        local dataFinish = false
                        for k ,v in pairs(merge2X3Data) do
                            if v.startCol == col - 1 and v.finishCol == col then
                                dataFinish = true
                                break
                            end
                        end
                        if not dataFinish then
                            table.insert(merge2X3Data , {startCol = col-1 , finishCol = col})
                        end
                    end
                end
            end
        end
    end
    --数据重置


    log.log("小猪机台 合并小猪数据 other mergeData" , mergeData)
    log.log("小猪机台 合并小猪数据 other mergeClearData" , mergeClearData)
    if mergeClearData then
        local clear2X3Effect = {}
        for col = 1 , colNum do
            if mergeClearData[col] then
                if mergeClearData[col][1] == PiggySlotsEffectType.Piggy1X3 then
                    fsm:GetOwner():ShowClear1x3Effect(col)
                    isMerge = true
                elseif mergeClearData[col][1] == PiggySlotsEffectType.Piggy2x3 then
                    if col < colNum then
                        if mergeClearData[col + 1] and mergeClearData[col+1][1] == PiggySlotsEffectType.Piggy2x3 then
                            if not clear2X3Effect[col] then
                                clear2X3Effect[col] = true
                                fsm:GetOwner():ShowClear2x3Effect(col,col+1 )
                                isMerge = true
                            end
                        end
                    end
                else
                    for row = 1 , rowNum do
                        if mergeClearData[col][row] == PiggySlotsEffectType.Piggy1x1 then
                            fsm:GetOwner():ShowClear1x1Effect(col,row)
                            isMerge = true
                        elseif mergeClearData[col][row] == PiggySlotsEffectType.Piggy1X2 then
                            fsm:GetOwner():ShowClear1x2Effect(col,row)
                            isMerge = true
                        end
                    end
                end
            end
        end
    end

    self:ClearDelayShowPiggyEffect()
    self.delayShowPiggyEffect = LuaTimer:SetDelayFunction(0.5, function()
        if merge2X3Data  then
            fsm:GetOwner():ClearDelayCreatBigPiggy()
            for k , v in pairs(merge2X3Data) do
                isMerge = true
                fsm:GetOwner():ShowMerge2x3Effect(v.startCol , v.finishCol)
            end
        end
    
        if merge1X3Data then
            fsm:GetOwner():ClearDelayCreatThreePiggy()
            for k , v in pairs(merge1X3Data) do
                isMerge = true
                fsm:GetOwner():ShowMerge1x3Effect(k)
            end
        end
       
        if merge1X2Data then
            fsm:GetOwner():ClearDelayCreatTwoPiggy()
            for k , v in pairs(merge1X2Data) do
                isMerge = true
                fsm:GetOwner():ShowMerge1x2Effect(k , v.startRow , v.finishRow)
            end
        end
    end)
    

    if isMerge then
        UISound.play("piggypigmerge")
        self:ClearDelayFinishSpin()
        self._timer = LuaTimer:SetDelayFunction(1, function()
            self:DoFinishSpin(fsm)
        end)
    else
        self:DoFinishSpin(fsm)
    end    
end

function PiggySlotsGameElementMergeState:ClearDelayFinishSpin()
    if self._timer then
        LuaTimer:Remove(self._timer)
        self._timer = nil
    end
end

function PiggySlotsGameElementMergeState:ClearDelayShowPiggyEffect()
    if self._timer then
        LuaTimer:Remove(self._timer)
        self._timer = nil
    end
end

function PiggySlotsGameElementMergeState:OnLeave(fsm)
    self:ClearDelayFinishSpin()
    self:ClearDelayShowPiggyEffect()
    fsm:GetOwner():MergeSpinTaskeUpdateUI(false)
end

function PiggySlotsGameElementMergeState:DoFinishSpin(fsm)
    local isFreeSpin = ModelList.PiggySloltsGameModel.CheckIsFreeSpin()
    if isFreeSpin then
        fsm:GetOwner():ContinueFreeSpin()
        self:ChangeState(fsm,"PiggySlotsGameWaitDoFreeSpinState" , false)
    else
        if self.spinStateName == "PiggySlotsGameWaitDoFreeSpinState" then
            --免费spiun
            fsm:GetOwner():UpdateDiamondCost()
            fsm:GetOwner():FinishFreeSpinUpdateUI()
            fsm:GetOwner():OnFinishFreeSpin()
            fsm:GetOwner():AnimShowPaySpinOrTake()
        elseif self.spinStateName == "PiggySlotsGameWaitChoosePaySpinOrTakeAwayState" then
            --付费spin
            fsm:GetOwner():FinsihPaySpinUpdateUI()
            fsm:GetOwner():OnFinishPaySpin()
            self.isFinishMerge = true
        else
            log.e("错误 不确定的状态来源" , self.spinStateName)
        end
    end
   
end


function PiggySlotsGameElementMergeState:EnterPayOrFinishGameState(fsm)
     if fsm then
        fsm:GetCurState():ChangeState(fsm,"PiggySlotsGameWaitChoosePaySpinOrTakeAwayState")
     end
 end
 
function PiggySlotsGameElementMergeState:DoTakeAway(fsm)
    if not self.isFinishMerge then
        log.log("等待合并完成")
        return
    end
    UISound.play("piggyslotbuttonclick")
    if fsm then
        self:ChangeState(fsm,"PiggySlotsGameFinishOneBingoCardState" , false)
        fsm:GetOwner():MergeSpinTaskeUpdateUI(true)
    end
end