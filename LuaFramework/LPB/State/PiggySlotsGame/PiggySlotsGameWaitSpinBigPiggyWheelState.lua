
PiggySlotsGameWaitSpinBigPiggyWheelState = Clazz(BasePiggySlotsGameState,"PiggySlotsGameWaitSpinBigPiggyWheelState")

function PiggySlotsGameWaitSpinBigPiggyWheelState:OnEnter(fsm,previous,bigPiggyWheelIndex)
    fsm:GetOwner():WheelSpinUpdateUI(true)
    log.log("小猪转盘序号 b bigPiggyWheelIndex" , bigPiggyWheelIndex)
    if fsm then
        self.bigPiggyWheelIndex = bigPiggyWheelIndex
        local rewardData = ModelList.PiggySloltsGameModel.GetBreakRewardData()
        local wheelData = rewardData[bigPiggyWheelIndex]
        fsm:GetOwner():ShowBigPiggyUI(bigPiggyWheelIndex,wheelData.col,wheelData.row)
    end
end

function PiggySlotsGameWaitSpinBigPiggyWheelState:OnLeave(fsm)

    self:ClearDelayFunc()
end

function PiggySlotsGameWaitSpinBigPiggyWheelState:DoSpinPiggyWheel(fsm)
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

function PiggySlotsGameWaitSpinBigPiggyWheelState:ClearDelayFunc()
    if self._timer then
        LuaTimer:Remove(self._timer)
        self._timer = nil
    end
end

function PiggySlotsGameWaitSpinBigPiggyWheelState:DoFinishBigWheel(fsm,bigPiggyWheelIndex)
    if fsm then
        self:ChangeState(fsm,"PiggySlotsGameFinishSpinBigPiggyWheelState" , bigPiggyWheelIndex)
        -- fsm:GetOwner():OnCollectOneBingoCardReward()
    end
end


-- function PiggySlotsGameWaitSpinBigPiggyWheelState:DoCollectBreakRewardFinish(fsm)
--     if fsm then 
--         -- fsm:GetOwner():OnCollectOneBingoCardReward()
--     end
-- end

