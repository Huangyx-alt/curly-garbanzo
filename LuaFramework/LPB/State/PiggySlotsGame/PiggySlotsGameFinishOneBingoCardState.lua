
PiggySlotsGameFinishOneBingoCardState = Clazz(BasePiggySlotsGameState,"PiggySlotsGameFinishOneBingoCardState")

function PiggySlotsGameFinishOneBingoCardState:OnEnter(fsm,previous,isTakeAway)
    self.isTakeAway = isTakeAway or false
    self.isFinishState = false
    if fsm then
        -- if ModelList.PiggySloltsGameModel.CheckIsTest() then
            -- ModelList.PiggySloltsGameModel.TestBreak()
        -- else
            self:CreatResetButton(fsm)
            fsm:GetOwner():ReqPiggyBreak(isTakeAway)
        -- end
    end
end

function PiggySlotsGameFinishOneBingoCardState:OnLeave(fsm)
    self.isFinishState = true
    self:ClearResetButton()
end

function PiggySlotsGameFinishOneBingoCardState:DoOneBingoCardReward(fsm)
    self.isFinishState = true
    self:ClearResetButton()
    if fsm then 
        fsm:GetOwner():OnCollectOneBingoCardReward()
    end
end

function PiggySlotsGameFinishOneBingoCardState:DoBigPiggyWheel(fsm, bigPiggyWheelIndex)
    if fsm then 
        log.log("小猪转盘序号 a" , bigPiggyWheelIndex)
        self:ChangeState(fsm,"PiggySlotsGameWaitSpinBigPiggyWheelState" , bigPiggyWheelIndex)
    end
end


function PiggySlotsGameFinishOneBingoCardState:DoCollectBreakRewardFinish(fsm)
    if fsm then 
        fsm:GetOwner():FlyCollectReward()
    end
end

function PiggySlotsGameFinishOneBingoCardState:DoEnterNextCard(fsm)
    if fsm then 
        if self.isTakeAway then
            self:ChangeState(fsm,"PiggySlotsGameChooseExitState")
        else
            self:ChangeState(fsm,"PiggySlotsGameCheckNextCardState")
        end
    end
end

function PiggySlotsGameFinishOneBingoCardState:DoError(fsm,code)
    log.log("PiggySlotsGameCheckNextCardState code" , code)
    if code == -99 or code == RET.RET_SESSION_INVALID then
        local tip = Csv.GetDescription(191169)
        UIUtil.show_common_popup_with_options(
            {
                okType = 3,
                contentText = tip,
                sureCb = function()
                    log.log("状态完成判断 PiggySlotsGameFinishOneBingoCardState" , self.isFinishState)
                    if self.isFinishState then
                        --状态完成了
                    else
                        fsm:GetOwner():ReqPiggyBreak(self.isTakeAway)
                    end
                end,
            }
        )
    else
        self:ChangeState(fsm,"PiggySlotsGameErrorTipExitState")
    end
end


function PiggySlotsGameFinishOneBingoCardState:CreatResetButton(fsm)
    self:ClearResetButton()
    self.timeResetButton = LuaTimer:SetDelayFunction(10, function()
        fsm:GetOwner():ReqPiggyBreak(self.isTakeAway)
    end)
end

function PiggySlotsGameFinishOneBingoCardState:ClearResetButton()
    log.log("清除效果了 PiggySlotsGameFinishOneBingoCardState")
    if self.timeResetButton then
        LuaTimer:Remove(self.timeResetButton)
        self.timeResetButton = nil
    end
end

