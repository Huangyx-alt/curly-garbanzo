
PiggySlotsGameFinishSpinBigPiggyWheelState = Clazz(BasePiggySlotsGameState,"PiggySlotsGameFinishSpinBigPiggyWheelState")

function PiggySlotsGameFinishSpinBigPiggyWheelState:OnEnter(fsm,previous,bigPiggyWheelIndex)
    log.log("PiggySlotsGameFinishSpinBigPiggyWheelState 小猪转盘序号" , bigPiggyWheelIndex)
    if fsm then
        -- self.bigPiggyWheelIndex = bigPiggyWheelIndex
        local rewardData = ModelList.PiggySloltsGameModel.GetBreakRewardData()
        if rewardData[bigPiggyWheelIndex + 1] then
            --还有转盘
            self:ChangeState(fsm,"PiggySlotsGameWaitSpinBigPiggyWheelState" , bigPiggyWheelIndex + 1)
        else
            --金币飞行结算
            log.log("PiggySlotsGameFinishSpinBigPiggyWheelState 金币飞行结算")
            if fsm then 
                fsm:GetOwner():FlyCollectReward()
            end
        end
    end
end

function PiggySlotsGameFinishSpinBigPiggyWheelState:OnLeave(fsm)
    self:ClearDelayFunc()
end

function PiggySlotsGameFinishSpinBigPiggyWheelState:DoSpinPiggyWheel(fsm)
    self:ClearDelayFunc()
    if fsm then 
        fsm:GetOwner():HideBigPiggyUI()
        log.log("处理小猪效果" , self.bigPiggyWheelIndex)
        local rewardData = ModelList.PiggySloltsGameModel.GetBreakRewardData()
        local wheelData = rewardData[self.bigPiggyWheelIndex]
        fsm:GetOwner():ReelOpenReward(wheelData.col, wheelData.row,PiggySlotsEffectType.Piggy2x3,wheelData.winCoin)
        self._timer = LuaTimer:SetDelayFunction(1, function()
            fsm:GetOwner():ShowBigPiggyWheel(self.bigPiggyWheelIndex)
        end)
    end
end

function PiggySlotsGameFinishSpinBigPiggyWheelState:ClearDelayFunc()
    if self._timer then
        LuaTimer:Remove(self._timer)
        self._timer = nil
    end
end

function PiggySlotsGameFinishSpinBigPiggyWheelState:DoFinishBigWheel(fsm,bigPiggyWheelIndex)
    if fsm then
        self:ChangeState(fsm,"PiggySlotsGameFinishSpinBigPiggyWheelState" , bigPiggyWheelIndex)
        -- fsm:GetOwner():OnCollectOneBingoCardReward()
    end
end

function PiggySlotsGameFinishSpinBigPiggyWheelState:DoEnterNextCard(fsm)
    if fsm then 
        self:ChangeState(fsm,"PiggySlotsGameCheckNextCardState")
    end
end

